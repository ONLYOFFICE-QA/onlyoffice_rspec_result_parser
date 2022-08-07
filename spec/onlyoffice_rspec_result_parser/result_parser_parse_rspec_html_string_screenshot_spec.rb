# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser,
         '.parse_rspec_html_string' do
  it 'check screenshot field nil if no error' do
    file = File.read('spec/rspec_examples/result_1.html')
    result = described_class.parse_rspec_html_string(file)
    expect(result.describe.child.first.screenshot).to be_nil
  end

  it 'check page url field not empty' do
    file = File.read('spec/rspec_examples/link_in_result.html')
    result = described_class.parse_rspec_html_string(file)
    expect(result.describe.child.first.screenshot)
      .to eq('https://nct-data-share.s3-us-west-2.amazonaws.com/' \
             'screenshots/irkptCRjvigq.png')
  end
end
