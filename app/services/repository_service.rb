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

        check_command = map_command(repository)
        check_log, exit_status = command_runner.execute(check_command)
        check.check_log = check_log
        check.passed = exit_status.zero?
        check.save!

        check.finish!
      rescue StandardError => error
        check.fail!
        check.passed = false
        check.save
        Rails.logger.error(error)
      end

      if check.failed?
        NotificationsMailer.with(user: check.repository.user, check:).error.deliver_later
      elsif check.passed?
        NotificationsMailer.with(user: check.repository.user, check:).passed.deliver_later
      else
        NotificationsMailer.with(user: check.repository.user, check:).failed.deliver_later
      end
    end

    def update_info_from_github(repository)
      github_client = ::ApplicationContainer[:github_client]

      client = github_client.new(access_token: repository.user.token, auto_paginate: true)
      github_repo = client.repo(repository.github_id.to_i)

      repository.name = github_repo[:name]
      repository.full_name = github_repo[:full_name]
      repository.language = github_repo[:language].downcase
      repository.clone_url = github_repo[:clone_url]
      repository.ssh_url = github_repo[:ssh_url]

      repository.save!

      hook_url = Rails.application.routes.url_helpers.api_checks_url

      hooks = client.hooks(repository.full_name)

      has_check_hook = hooks.any? { |hook| hook[:config][:url] == hook_url }

      return if has_check_hook

      client.create_hook(
        repository.full_name,
        :web,
        {
          url: hook_url,
          content_type: :json
        },
        {
          events: [ :push ],
          active: true
        }
      )
    end

    private

    def map_command(repository)
      case repository.language
      when "ruby"
        "bundle exec rubocop #{repository.temp_repository_path} --format=json --config ./.rubocop.yml"
      when "javascript"
        "node_modules/eslint/bin/eslint.js #{repository.temp_repository_path} --format=json --config ./.eslintrc.yml  --no-eslintrc"
      else
        raise "Unhandled language for check #{repository.language}"
      end
    end

    def clean_path(path)
      FileUtils.rm_rf(path) if Dir.exist?(path)
    end
  end
end
