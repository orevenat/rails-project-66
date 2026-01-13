# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/error
  def error
    NotificationsMailer.with(user: User.first, check: Repository::Check.first).error
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/passed
  def passed
    NotificationsMailer.with(user: User.first, check: Repository::Check.first).passed
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/failed
  def failed
    NotificationsMailer.with(user: User.first, check: Repository::Check.first).failed
  end
end
