# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    authorize repository, :show?

    @check = repository.checks.find(params[:id])

    @check_result = parse_check_result(@check.check_log.presence || "{}")
  end

  def create
    authorize repository, :show?

    @check = repository.checks.create!
    RepositoryService.check(@check)

    redirect_to repository_path(repository), notice: t(".created")
  end

  private

  def parse_check_result(json_string)
    result = JSON.parse(json_string, symbolize_names: true)

    if result.empty?
      return {
        files: []
      }
    end

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
      summary: result[:summary],
      metadata: result[:metadata]
    }
  end

  def format_location(location)
    "#{location[:start_line]}:#{location[:start_column]}"
  end
end
