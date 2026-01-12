# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.production?
    register :command_runner, -> { CommandRunner }
    register :git, -> { Git }
    register :github_client, -> { Octokit::Client }
  elsif Rails.env.development?
    register :command_runner, -> { CommandRunner }
    register :git, -> { Git }
    register :github_client, -> { Octokit::Client }
  else
    register :command_runner, -> { CommandRunnerStub }
    register :git, -> { GitStub }
    register :github_client, -> { GithubClientStub }
  end
end
