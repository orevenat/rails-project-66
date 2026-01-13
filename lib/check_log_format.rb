# # frozen_string_literal: true

class CheckLogFormat
  class << self
    def format(json_string, language)
      result = JSON.parse(json_string.presence || "{}", symbolize_names: true)

      if result.empty?
        return {
          files: []
        }
      end

      case language
      when "ruby"
        format_rubocop(result)
      when "javascript"
        format_eslint(result)
      else
        raise "Unhandled language for format #{language}"
      end
    end

    private

    def format_eslint(result)
      errors = result.reject { |record| record[:errorCount].zero? }

      files = errors.map do |error|
        offenses = error[:messages]&.map do |offence|
          {
            message: offence[:message],
            rule: offence[:ruleId],
            location: "#{offence[:line]}:#{offence[:column]}"
          }
        end

        {
          path: error[:filePath],
          offenses: offenses
        }
      end

      {
        offense_count: errors.sum { |issues_group| issues_group[:messages].size },
        files: files
      }
    end

    def format_rubocop(result)
      files = result[:files].map do |file|
        {
          path: file[:path],
          offenses: file[:offenses].map do |offense|
            {
              message: offense[:message],
              rule: offense[:cop_name],
              severity: offense[:severity],
              location: format_location(offense[:location]),
              line: offense[:location][:start_line],
              column: offense[:location][:start_column],
              correctable: offense[:correctable]
            }
          end
        }
      end

      {
        files: files,
        offense_count: result.dig("summary", "offense_count"),
        summary: result[:summary],
        metadata: result[:metadata]
      }
    end

    def format_location(location)
      "#{location[:start_line]}:#{location[:start_column]}"
    end
  end
end
