# frozen_string_literal: true

module Auth
  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def sign_out
    reset_session
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def check_auth!
    return if current_user

    redirect_back fallback_location: root_path, alert: t("layouts.check_auth_failed")
  end
end
