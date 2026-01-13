# frozen_string_literal: true

class NotificationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.error.subject
  #
  def error
    @user = params[:user]
    @check = params[:check]

    mail(to: @user.email, subject: t('.subject'))
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.passed.subject
  #
  def passed
    @user = params[:user]
    @check = params[:check]

    mail(to: @user.email, subject: t('.subject'))
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.failed.subject
  #
  def failed
    @user = params[:user]
    @check = params[:check]

    mail(to: @user.email, subject: t('.subject'))
  end
end
