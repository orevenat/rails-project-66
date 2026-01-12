# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Pundit::Authorization
  include Auth
  include Flash

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private

  def not_authorized
    flash[:alert] = t("flash.not_authorized")
    redirect_to root_path
  end
end
