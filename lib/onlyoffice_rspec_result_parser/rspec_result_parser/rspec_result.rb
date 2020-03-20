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

    # @return [Integer] total test result count
    def total_tests_count
      failed_count + passed_count
    end

    def parse_page(page, with_describe_info = true)
      @describe = get_describe(page) if with_describe_info
      @processing = get_processing(page)
      @result = get_total_result(page)
      @time = get_total_time(page)
      @total = get_totals(page)
      @failed_count = get_failed_count(page)
      @passed_count = get_passed_count(page)
      @pending_count = get_pending_count(page)
      self
    end

    private

    def get_describe(page)
      results = ResultCreator.new
      page.at_css('div.results').xpath('./div').each do |current|
        results.push_to_end(parse_describe(current),
                            get_describe_level(current))
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

    def get_describe_level(describe)
      style_string = describe.xpath('./dl')[0][:style]
      style_parameter = StringHelper.get_style_param(style_string,
                                                     'margin-left')
      StringHelper.delete_px(style_parameter).to_i / LEVEL_MARGIN
    end

    def get_processing(page)
      processing = page.css('script:contains("moveProgressBar")').last
      return '0' unless processing

      process = processing.text.strip.split('\'')[1]
      if process == ''
        '0'
      else
        process
      end
    end

    def get_total_result(page)
      get_totals(page).include?(' 0 failures')
    end

    def get_totals(page)
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

    def get_failed_count(page)
      page.xpath("//*[@class='example failed']").length
    end

    def get_passed_count(page)
      page.xpath("//*[@class='example passed']").length
    end

    def get_pending_count(page)
      page.xpath("//*[@class='example not_implemented']").length
    end

    def get_total_time(page)
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
