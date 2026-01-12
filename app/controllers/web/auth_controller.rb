# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    auth = request.env["omniauth.auth"]

    user = User.find_or_initialize_by(email: auth[:info][:email].downcase)
    user.nickname = auth[:info][:nickname]
    user.email = auth[:info][:email]
    user.token = auth[:credentials][:token]

    sign_in user if user.save
    redirect_to root_path, notice: t(".success")
  end

  def logout
    sign_out

    redirect_to root_path, notice: t(".success")
  end
end
