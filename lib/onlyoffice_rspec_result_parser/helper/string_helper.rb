# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # Class for string methods
  class StringHelper
    def self.get_style_param(string, param)
      m = string.match(/#{param}:\s(.*);/)
      m[1]
    end

    def self.delete_px(string)
      string.gsub 'px', ''
    end
  end
end
