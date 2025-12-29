# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  enumerize :language, in: %i[ruby]

  belongs_to :user

  validates :github_id, presence: true

  def display_name
    name || "-"
  end
end
