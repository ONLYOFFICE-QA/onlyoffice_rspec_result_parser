# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser do
  let(:failed_cases_file) { 'spec/rspec_examples/failed-cases-count.html' }

  it 'failed-cases-count not zero' do
    result = described_class.get_failed_cases_count_from_html(failed_cases_file)
    expect(result).to eq(3)
  end

  it 'parse_rspec_html contained failed count' do
    result = described_class.parse_rspec_html(failed_cases_file)
    expect(result.failed_count).to eq(3)
  end

  it 'parse_rspec_html contained total_tests_count' do
    result = described_class.parse_rspec_html(failed_cases_file)
    expect(result.total_tests_count).to eq(3)
  end

  describe 'parse_metadata not contain describe info' do
    let(:result) { described_class.parse_metadata(failed_cases_file) }

    it 'result is correct class' do
      expect(result).to be_a(OnlyofficeRspecResultParser::RspecResult)
    end

    it 'result.describe is not nil' do
      expect(result.describe).to be_nil
    end
  end
end
