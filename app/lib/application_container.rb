# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.production?
    register :github_client, -> { Octokit::Client }
  elsif Rails.env.development?
    register :github_client, -> { Octokit::Client }
  else
    register :github_client, -> { GithubClientStub }
  end
end
