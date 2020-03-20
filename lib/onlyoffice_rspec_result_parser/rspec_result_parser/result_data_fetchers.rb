# frozen_string_literal: true

module OnlyofficeRspecResultParser
  # Method to fetch result data
  module ResultDataFetchers
    LEVEL_MARGIN = 15

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
  end
end
