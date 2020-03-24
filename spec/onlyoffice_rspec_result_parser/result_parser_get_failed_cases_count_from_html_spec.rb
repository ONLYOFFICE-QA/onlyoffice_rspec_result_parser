# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser,
         '.get_failed_cases_count_from_html' do
  it 'get_failed_cases_count_from_html return zero for empty string' do
    expect(described_class.get_failed_cases_count_from_html('')).to eq(0)
  end
end
