# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # class for storing rspec result
  class RspecResult
    LEVEL_MARGIN = 15

    attr_accessor :processing, :result, :time, :total, :describe
    # @return [Integer] how much tests failed
    attr_accessor :failed_count
    # @return [Integer] how much tests passed
    attr_accessor :passed_count
    # @return [Integer] how much tests pending
    attr_accessor :pending_count
    # @return [String] html page of RspecResult
    attr_reader :page

    def initialize(page)
      @page = page
    end

    # @return [Integer] total test result count
    def total_tests_count
      failed_count + passed_count
    end

    def parse_page(with_describe_info = true)
      return self unless valid_html?

      @describe = fetch_describe if with_describe_info
      @processing = fetch_processing
      @result = fetch_total_result
      @time = fetch_total_time
      @total = fetch_totals
      @failed_count = fetch_failed_count
      @passed_count = fetch_passed_count
      @pending_count = fetch_pending_count
      self
    end

    # @return [True, False] is html code is valid
    def valid_html?
      return false unless page.at_css('div.results')

      true
    end

    private

    def fetch_describe
      results = ResultCreator.new
      page.at_css('div.results').xpath('./div').each do |current|
        results.push_to_end(parse_describe(current),
                            fetch_describe_level(current))
      end
      results.final_result
    end

    def parse_describe(describe)
      describe_obj = Describe.new(describe.css('dt').text)
      unless describe.css('dd').empty?
        describe.css('dd').each do |example|
          describe_obj.child << Example.new(example)
          ResultParser.example_index += 1
        end
      end
      describe_obj
    end

    def fetch_describe_level(describe)
      style_string = describe.xpath('./dl')[0][:style]
      style_parameter = StringHelper.get_style_param(style_string,
                                                     'margin-left')
      StringHelper.delete_px(style_parameter).to_i / LEVEL_MARGIN
    end

    def fetch_processing
      processing = page.css('script:contains("moveProgressBar")').last
      return '0' unless processing

      process = processing.text.strip.split('\'')[1]
      if process == ''
        '0'
      else
        process
      end
    end

    def fetch_total_result
      fetch_totals.include?(' 0 failures')
    end

    def fetch_totals
      totals = ''
      total_elem = page.css('script:contains(" example")')
      return totals unless total_elem

      totals = total_elem.text.match(/"(.*?)"/)
      if totals
        totals[1]
      else
        ''
      end
    end

    def fetch_failed_count
      page.xpath("//*[@class='example failed']").length
    end

    def fetch_passed_count
      page.xpath("//*[@class='example passed']").length
    end

    def fetch_pending_count
      page.xpath("//*[@class='example not_implemented']").length
    end

    def fetch_total_time
      total_time = page.css('script:contains("Finished in")')
                       .text
                       .match(/>(.*?)</)
      if total_time
        total_time[1]
      else
        ''
      end
    end
  end
end
