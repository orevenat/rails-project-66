# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    authorize repository, :show?

    @check = repository.checks.find(params[:id])

    @check_result = CheckLogFormat.format(@check.check_log, repository.language)
  end

  def create
    authorize repository, :show?

    @check = repository.checks.create!
    CheckRepositoryJob.perform_later(@check.id)

    redirect_to repository_path(repository), notice: t(".created")
  end
end
