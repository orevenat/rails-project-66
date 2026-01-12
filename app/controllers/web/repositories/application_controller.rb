# frozen_string_literal: true

class Web::Repositories::ApplicationController < Web::ApplicationController
  def repository
    @repository ||= Repository.find(params[:repository_id])
  end
end
