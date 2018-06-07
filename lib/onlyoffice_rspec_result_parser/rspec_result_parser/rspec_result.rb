module OnlyofficeRspecResultParser
  class RspecResult
    attr_accessor :processing, :result, :time, :total, :describe
    # @return [Integer] how much tests failed
    attr_accessor :failed_count

    def initialize(describe = nil, processing = nil, result = nil, time = nil, total = nil)
      @describe = describe
      @processing = processing
      @result = result
      @time = time
      @total = total
    end
  end
end
