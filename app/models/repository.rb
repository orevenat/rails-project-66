# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  enumerize :language, in: %i[ruby javascript]

  belongs_to :user

  has_many :checks, dependent: :destroy

  validates :github_id, presence: true

  def display_name
    name || "-"
  end

  def temp_repository_path
    File.join(Dir.tmpdir, "repositories", full_name)
  end
end
