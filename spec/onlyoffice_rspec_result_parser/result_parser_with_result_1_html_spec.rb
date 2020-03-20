# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser do
  let(:result_1_html) { 'spec/rspec_examples/result_1.html' }

  it 'result 1' do
    result = described_class.parse_rspec_html_string(File.read(result_1_html))
    expect(result).not_to be_nil
  end

  it 'result 1 via file name' do
    result = described_class.parse_rspec_html_string(result_1_html)
    expect(result).not_to be_nil
  end

  it 'total count result is not empty' do
    result = described_class.get_total_result_of_rspec_html(result_1_html)
    expect(result).to eq('1 example, 0 failures')
  end

  it 'failed-cases-count zero' do
    result = described_class.get_failed_cases_count_from_html(result_1_html)
    expect(result).to eq(0)
  end

  it 'parse_rspec_html contained total count' do
    result = described_class.parse_rspec_html(result_1_html)
    expect(result.passed_count).to eq(1)
  end
end
