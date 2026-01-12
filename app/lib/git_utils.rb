# frozen_string_literal: true

class GitUtils
  class << self
    def find_commit_id(command_runner, repository_path)
      command = "cd #{repository_path.shellescape} && git rev-parse HEAD"
      output, exit_status = command_runner.execute(command)

      if !exit_status.zero?
        check.check_log = "Error when find commit_id. Status: #{exit_status}"
        raise
      end

      output.strip
    end
  end
end
