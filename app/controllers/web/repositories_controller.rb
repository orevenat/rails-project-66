# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :check_auth!

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])

    authorize @repository

    @checks = @repository.checks
  end

  def new
    github_client = ::ApplicationContainer[:github_client]
    client = github_client.new(access_token: current_user.token, auto_paginate: true)

    languages = Repository.language.values

    github_repositories = client.repos(user: current_user.nickname)
    @github_repositories = github_repositories.select { |rep| languages.include?(rep.language&.downcase) }
    @repository = current_user.repositories.build
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by(repository_params)

    if @repository.save
      UpdateRepositoryInfoJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content, error: @repository.errors.full_messages.join("\n")
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
