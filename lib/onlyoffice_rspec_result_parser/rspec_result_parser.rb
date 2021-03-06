# frozen_string_literal: true

require 'nokogiri'
require 'uri'

require_relative 'helper/string_helper'
require_relative 'rspec_result_parser/describe'
require_relative 'rspec_result_parser/example'
require_relative 'rspec_result_parser/result_creator'
require_relative 'rspec_result_parser/rspec_result'

module OnlyofficeRspecResultParser
  # Class with stored data about rspec result
  class ResultParser
    @example_index = 0

    class << self
      attr_accessor :example_index

      # Parse rspec html
      # @param [String] html_path path to file
      # @return [Object] result of parse
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

      # Get failed count
      # @param [String] html_path path to file
      # @return [Integer] failed count
      def get_failed_cases_count_from_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        result = RspecResult.new(page).parse_page
        return 0 unless result.valid_html?

        result.failed_count
      end

      # Get total case count
      # @param [String] html_path path to file
      # @return [Integer] total count
      def get_total_result_of_rspec_html(html_path)
        page = Nokogiri::HTML(read_file(html_path))
        result = RspecResult.new(page).parse_page
        return '' unless result.valid_html?

        result.total
      end

      # @param page [String] data in page
      # @param with_describe_info [Boolean] if
      #   describe metadata should be included
      # @return [RspecResult] result of parsing
      def parse_test_result(page, with_describe_info: true)
        ResultParser.example_index = 0
        RspecResult.new(page).parse_page(with_describe_info: with_describe_info)
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
