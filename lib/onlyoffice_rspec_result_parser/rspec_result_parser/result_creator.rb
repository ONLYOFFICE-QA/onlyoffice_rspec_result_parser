# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # rspec ResultCreator methods
  class ResultCreator
    # @return [Describe] result describe
    attr_reader :final_result

    # Push result to end
    # @param [String] describe to pusth
    # @param [Integer] level to check
    # @return [Object] result
    def push_to_end(describe, level)
      if level.zero?
        @final_result = describe
      elsif level.positive?
        @final_result.find_last_on_lvl(level - 1).child << describe
      end
    end
  end
end
