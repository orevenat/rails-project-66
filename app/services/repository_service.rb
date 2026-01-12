# frozen_string_literal: true

class RepositoryService
  class << self
    def check(check)
      begin
        check.check!

        command_runner = ApplicationContainer[:command_runner]
        git = ApplicationContainer[:git]

        repository = check.repository
        repository_path = repository.temp_repository_path

        clean_path(repository_path)
        git.clone(repository.clone_url, repository_path)

        check.commit_id = GitUtils.find_commit_id(command_runner, repository_path)

        check_command = "bundle exec rubocop #{repository_path} --format=json --config ./.rubocop.yml"
        check_log, exit_status = command_runner.execute(check_command)
        check.check_log = check_log
        check.passed = exit_status.zero?
        check.save!

        check.finish!
      rescue StandardError => error
        check.fail!
        check.passed = false
        Rails.logger.error(error)
      end
    end

    private

    def clean_path(path)
      FileUtils.rm_rf(path) if Dir.exist?(path)
    end
  end
end
