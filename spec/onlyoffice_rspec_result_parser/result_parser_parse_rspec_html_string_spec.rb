# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser,
         '.parse_rspec_html_string' do
  it 'check page url field nil if no error' do
    file = File.read('spec/rspec_examples/result_1.html')
    result = described_class.parse_rspec_html_string(file)
    expect(result.describe.child.first.page_url).to be_nil
  end

  it 'check page url field not empty' do
    file = File.read('spec/rspec_examples/result_page_url.html')
    result = described_class.parse_rspec_html_string(file)
    expect(result.describe.child[2].page_url)
      .to eq('https://saul.teamlab.info/products/files/' \
             'doceditor.aspx?fileid=42774')
  end
end
