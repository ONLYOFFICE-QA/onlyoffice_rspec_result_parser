module OnlyofficeRspecResultParser
  class RspecResult
    attr_accessor :processing, :result, :time, :total, :describe
    # @return [Integer] how much tests failed
    attr_accessor :failed_count
  end
end
