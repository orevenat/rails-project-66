# frozen_string_literal: true

class GitStub
  class << self
    def clone(_clone_url, _path) # rubocop:disable Naming/PredicateMethod
      true
    end
  end
end
