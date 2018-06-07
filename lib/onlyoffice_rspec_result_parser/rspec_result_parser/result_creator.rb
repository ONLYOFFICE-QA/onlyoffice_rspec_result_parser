module OnlyofficeRspecResultParser
  class ResultCreator
    # @return [Describe] result describe
    attr_reader :final_result

    def push_to_end(describe, level)
      if level.zero?
        @final_result = describe
      elsif level > 0
        @final_result.find_last_on_lvl(level - 1).child << describe
      end
    end
  end
end
