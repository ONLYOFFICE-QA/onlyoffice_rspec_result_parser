# frozen_string_literal: true

require 'spec_helper'

describe 'My behaviour' do
  it 'check screenshot field nil if no error' do
    result = OnlyofficeRspecResultParser::ResultParser.parse_rspec_html_string(File.read('spec/rspec_examples/result_1.html'))
    expect(result.describe.child.first.screenshot).to be_nil
  end

  it 'check page url field not empty' do
    result = OnlyofficeRspecResultParser::ResultParser.parse_rspec_html_string(File.read('spec/rspec_examples/link_in_result.html'))
    expect(result.describe.child.first.screenshot).to eq('https://nct-data-share.s3-us-west-2.amazonaws.com/screenshots/irkptCRjvigq.png')
  end
end
