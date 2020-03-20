require 'nokogiri'
require 'uri'

require_relative 'helper/string_helper'
require_relative 'rspec_result_parser/describe'
require_relative 'rspec_result_parser/example'
require_relative 'rspec_result_parser/result_creator'
require_relative 'rspec_result_parser/rspec_result'

module OnlyofficeRspecResultParser
  class ResultParser
    LEVEL_MARGIN = 15
    @example_index = 0

    class << self
      attr_accessor :example_index

      def parse_rspec_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        parse_test_result(page)
      end

      # @param file [String] path to file
      # @return [RspecResult] result of parsing
      def parse_metadata(file)
        page = Nokogiri::HTML(read_file(file))
        parse_test_result(page, with_describe_info: false)
      end

      alias parse_rspec_html_string parse_rspec_html

      def get_processing_of_rspec_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        get_processing(page)
      end

      def get_failed_cases_count_from_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        get_failed_count(page)
      end

      def get_total_result_of_rspec_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        get_totals(page)
      end

      # @param page [String] data in page
      # @param with_describe_info [Boolean] if describe metadata should be included
      # @return [RspecResult] result of parsing
      def parse_test_result(page, with_describe_info: true)
        ResultParser.example_index = 0
        rspec_results = RspecResult.new
        rspec_results.describe = get_describe(page) if with_describe_info
        rspec_results.processing = get_processing(page)
        rspec_results.result = get_total_result(page)
        rspec_results.time = get_total_time(page)
        rspec_results.total = get_totals(page)
        rspec_results.failed_count = get_failed_count(page)
        rspec_results.passed_count = get_passed_count(page)
        rspec_results.pending_count = get_pending_count(page)
        rspec_results
      end

      def get_processing(page)
        processing = page.css('script:contains("moveProgressBar")').last
        if processing
          process = processing.text.strip.split('\'')[1]
          if process == ''
            '0'
          else
            process
          end
        else
          '0'
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

      def get_total_result(page)
        get_totals(page).include?(' 0 failures')
      end

      def get_total_time(page)
        total_time = page.css('script:contains("Finished in")').text.match(/>(.*?)</)
        if total_time
          total_time[1]
        else
          ''
        end
      end

      def get_totals(page)
        totals = ''
        total_elem = page.css('script:contains(" example")')
        if total_elem
          totals = total_elem.text.match(/"(.*?)"/)
          totals = if totals
                     totals[1]
                   else
                     ''
                   end
        end
        totals
      end

      def get_describe(page)
        results = ResultCreator.new
        page.at_css('div.results').xpath('./div').each do |current|
          results.push_to_end(parse_describe(current), get_describe_level(current))
        end
        results.final_result
      end

      def get_describe_level(describe)
        style_parameter = StringHelper.get_style_param(describe.xpath('./dl')[0][:style], 'margin-left')
        StringHelper.delete_px(style_parameter).to_i / LEVEL_MARGIN
      end

      def parse_describe(describe)
        describe_obj = Describe.new(describe.css('dt').text)
        unless describe.css('dd').empty?
          describe.css('dd').each do |example|
            # example_log = describe.xpath("//dd/preceding-sibling::text()[1]")[@@example_index].text.strip
            describe_obj.child << Example.new(example)
            ResultParser.example_index += 1
          end
        end
        describe_obj
      end

      private

      # Read file from disk or use string
      # @param data [String] filepath or data string
      # @return [String] result of read
      def read_file(data)
        return data unless File.exist?(data)

        File.read(data)
      end
    end
  end
end
