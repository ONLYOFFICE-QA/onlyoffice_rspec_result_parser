# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # Class for string methods
  class StringHelper
    # Get style param from string
    # @param [String] string with style
    # @param [String] param name
    # @return [String] result
    def self.get_style_param(string, param)
      m = string.match(/#{param}:\s(.*);/)
      m[1]
    end

    # Delete pixel names from string
    # @param [String] string to delete
    # @return [String] result
    def self.delete_px(string)
      string.gsub 'px', ''
    end
  end
end
