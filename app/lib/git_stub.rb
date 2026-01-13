# frozen_string_literal: true

class GitStub
  class << self
    def clone(_clone_url, _path)
      1.present?
    end
  end
end
