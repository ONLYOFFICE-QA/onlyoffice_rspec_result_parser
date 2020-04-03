# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser,
         '.get_total_result_of_rspec_html' do
  it 'get_total_result_of_rspec_html return empty string for empty string' do
    expect(described_class.get_total_result_of_rspec_html('')).to eq('')
  end

  it 'get_total_result_of_rspec_html return empty for incorrect data' do
    expect(described_class.get_total_result_of_rspec_html('junk')).to eq('')
  end
end
