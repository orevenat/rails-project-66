# frozen_string_literal: true

require 'ostruct'

class GithubClientStub
  RepositoryStub = Struct.new(:id, :language, :full_name, :clone_url, :ssh_url)

  def initialize(*); end

  def repo(_github_id)
    {
      id: 8514,
      language: 'ruby',
      full_name: 'rails/rails',
      clone_url: 'https://github.com/rails/rails.git',
      ssh_url: 'git@github.com:rails/rails.git'
    }
  end

  def repos(*)
    content = Rails.root.join('test/fixtures/files/github_repositories.json').read
    repositories = JSON.parse(content, symbolize_names: true)
    repositories.map { |repo| RepositoryStub.new(repo) }
  end

  def hooks(_repo)
    []
  end

  def create_hook(_repo, _name, _config, _options); end
end
