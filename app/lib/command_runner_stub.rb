# frozen_string_literal: true

class CommandRunnerStub
  class << self
    def execute(_command)
      ['', 0]
    end
  end
end
