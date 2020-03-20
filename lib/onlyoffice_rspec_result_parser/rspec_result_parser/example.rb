# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # rspec example data
  class Example
    attr_accessor :text, :duration, :message, :backtrace, :code, :log, :passed
    # @return [String] link to page url
    attr_accessor :page_url
    # @return [String] link to screenshot
    attr_accessor :screenshot

    def initialize(data)
      fetch_data(data)
      @page_url = fetch_page_url
      @screenshot = fetch_screenshot
    end

    private

    def fetch_data(data)
      @text = data.css('span').first.text
      @passed = data[:class].split(' ')[1]
      if @passed == 'failed'
        fetch_failed_data(data)
      elsif @passed == 'passed'
        @duration = data.css('span')[1].text
      end
    end

    def fetch_page_url
      return nil unless @message

      message_url_line = @message.match(/^.*Page address:.*/)
      return nil unless message_url_line

      message_url_line.to_s.match(/'.*'/).to_s.delete("'")
    end

    def fetch_screenshot
      return nil unless @message

      screenshot_line = @message.match(/^.*Error screenshot:.*/)
      return nil unless screenshot_line

      screenshot_line.to_s.match(/'.*?'/).to_s.delete("'")
    end

    # Method make all links in text clickable
    # @param [String] text current text
    # @return [String] text with clickable link
    def format_link(text)
      links = URI.extract(text)
      links.each do |current_link|
        if current_link.end_with?('png', 'jpg')
          text.gsub!(current_link, link_url_50_percent(current_link))
        elsif current_link.start_with?('http')
          text.gsub!(current_link, link_url(current_link))
        end
      end
      text
    end

    # Fetch data for failed case
    # @param data [Nokogiri::XML::Element] element to parse
    def fetch_failed_data(data)
      @duration = data.css('span')[1].text
      @message = format_link(data.css('div.message').text)
      @backtrace = data.css('div.backtrace').text
      @code = data.css('code').children.to_s
    end

    # @param [String] link to insert
    # @return [String] result link with 50 percent size
    def link_url_50_percent(link)
      "<a href='#{link}'><img src='#{link}' height='50%' width='50%'></a>"
    end

    # @param [String] link to insert
    # @return [String] result link
    def link_url(link)
      "<a href='#{link}'>#{link}</a>"
    end
  end
end
