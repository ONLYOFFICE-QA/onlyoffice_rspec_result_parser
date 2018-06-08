module OnlyofficeRspecResultParser
  class RspecResult
    attr_accessor :processing, :result, :time, :total, :describe
    # @return [Integer] how much tests failed
    attr_accessor :failed_count
    # @return [Integer] how much tests passed
    attr_accessor :passed_count
  end
end
