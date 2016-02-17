require 'nokogiri'
require 'uri'

require_relative 'rspec_result_parser/describe'
require_relative 'rspec_result_parser/example'
require_relative 'rspec_result_parser/result_creator'
require_relative 'rspec_result_parser/rspec_result'

class String
  def get_style_param(param)
    m = match(/#{param}:\s(.*);/)
    m[1]
  end

  def delete_px
    gsub 'px', ''
  end
end

class ResultParser
  LEVEL_MARGIN = 15
  @example_index = 0

  class << self
    attr_accessor :example_index

    def parse_rspec_html(html_path)
      page = Nokogiri::HTML(open(html_path))
      parse_test_result(page)
    end

    def parse_rspec_html_string(html_string)
      page = Nokogiri::HTML(html_string)
      parse_test_result(page)
    end

    def get_processing_of_rspec_html(html_path)
      page = Nokogiri::HTML(open(html_path))
      get_processing(page)
    end

    def get_failed_cases_count_from_html(html_path)
      page = Nokogiri::HTML(open(html_path))
      get_failed_count(page)
    end

    def get_total_result_of_rspec_html(html_path)
      page = Nokogiri::HTML(open(html_path))
      get_totals(page)
    end

    def parse_test_result(page)
      ResultParser.example_index = 0
      rspec_results = RspecResult.new
      rspec_results.describe = get_describe(page)
      rspec_results.processing = get_processing(page)
      rspec_results.result = get_total_result(page)
      rspec_results.time = get_total_time(page)
      rspec_results.total = get_totals(page)
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
      results.get_result
    end

    def get_describe_level(describe)
      describe.xpath('./dl')[0][:style].get_style_param('margin-left').delete_px.to_i / LEVEL_MARGIN
    end

    def parse_describe(describe)
      describe_obj = Describe.new(describe.css('dt').text)
      unless describe.css('dd').empty?
        describe.css('dd').each_with_index do |example|
          # example_log = describe.xpath("//dd/preceding-sibling::text()[1]")[@@example_index].text.strip
          describe_obj.child << parse_example(example)
          ResultParser.example_index += 1
        end
      end
      describe_obj
    end

    def parse_example(example)
      example_obj = Example.new
      example_obj.text = example.css('span').first.text
      example_obj.passed = example[:class].split(' ')[1]
      if example_obj.passed == 'failed'
        example_obj.duration = example.css('span')[1].text
        example_obj.message = format_link(example.css('div.message').text)
        example_obj.backtrace = example.css('div.backtrace').text
        example_obj.code = example.css('code').children.to_s
      elsif example_obj.passed == 'passed'
        example_obj.duration = example.css('span')[1].text
      end
      example_obj
    end

    # Method make all links in text clickable
    # @param [String] text current text
    # @return [String] text with clickable link
    def format_link(text)
      links = URI.extract(text)
      links.each do |current_link|
        if current_link.end_with?('png', 'jpg')
          text.gsub!(current_link, "<a href='#{current_link}'><img src='#{current_link}' height='50%' width='50%'></a>")
        elsif current_link.start_with?('http')
          text.gsub!(current_link, "<a href='#{current_link}'>#{current_link}</a>")
        end
      end
      text
    end
  end
end
