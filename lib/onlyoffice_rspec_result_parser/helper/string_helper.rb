module OnlyofficeRspecResultParser
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