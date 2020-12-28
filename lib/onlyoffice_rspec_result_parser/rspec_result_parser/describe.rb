# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # rspec describe data
  class Describe
    attr_accessor :child, :text

    def initialize(text, child = [], result = nil)
      @text = text
      @child = child
      @result = result
    end

    # Find last info on level
    # @param [Integer] level
    # @return [Object] result
    def find_last_on_lvl(level)
      level.zero? ? self : @child.last.find_last_on_lvl(level - 1)
    end
  end
end
