# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser do
  it 'result 1' do
    result = described_class.parse_rspec_html_string(File.read('spec/rspec_examples/result_1.html'))
    expect(result).not_to be_nil
  end

  it 'result 1 via file name' do
    result = described_class.parse_rspec_html_string('spec/rspec_examples/result_1.html')
    expect(result).not_to be_nil
  end

  it 'total count result is not empty' do
    result = described_class.get_total_result_of_rspec_html('spec/rspec_examples/result_1.html')
    expect(result).to eq('1 example, 0 failures')
  end

  it 'failed-cases-count zero' do
    result = described_class.get_failed_cases_count_from_html('spec/rspec_examples/result_1.html')
    expect(result).to eq(0)
  end

  it 'failed-cases-count not zero' do
    result = described_class.get_failed_cases_count_from_html('spec/rspec_examples/failed-cases-count.html')
    expect(result).to eq(3)
  end

  it 'check url is clickable' do
    result = described_class.parse_rspec_html_string(File.read('spec/rspec_examples/link_in_result.html'))
    expect(result.describe.child.first.message).to include("<a href='https://doc-linux-autotest.teamlab.info/products/files/doceditor.aspx?fileid=2678604&new=true'>https://doc-linux-autotest.teamlab.info/products/files/doceditor.aspx?fileid=2678604&new=true</a>")
  end

  it 'check image is inline' do
    result = described_class.parse_rspec_html_string(File.read('spec/rspec_examples/link_in_result.html'))
    expect(result.describe.child.first.message).to include("<img src='https://nct-data-share.s3-us-west-2.amazonaws.com/screenshots/irkptCRjvigq.png' height='50%' width='50%'>")
  end

  it 'parse_rspec_html contained failed count' do
    result = described_class.parse_rspec_html('spec/rspec_examples/failed-cases-count.html')
    expect(result.failed_count).to eq(3)
  end

  it 'parse_rspec_html contained total count' do
    result = described_class.parse_rspec_html('spec/rspec_examples/result_1.html')
    expect(result.passed_count).to eq(1)
  end

  it 'parse_rspec_html contained pending count' do
    result = described_class.parse_rspec_html('spec/rspec_examples/with-pendings.html')
    expect(result.pending_count).to eq(3)
  end

  it 'parse_rspec_html contained total_tests_count' do
    result = described_class.parse_rspec_html('spec/rspec_examples/failed-cases-count.html')
    expect(result.total_tests_count).to eq(3)
  end

  it 'parse_metadata not contain describe info' do
    result = described_class.parse_metadata('spec/rspec_examples/failed-cases-count.html')
    expect(result).to be_a(OnlyofficeRspecResultParser::RspecResult)
    expect(result.describe).to be_nil
  end

  it 'parse_metadata without moveProgressBar' do
    result = described_class.parse_metadata('spec/rspec_examples/result_without_move_progress_bar.html')
    expect(result.processing).to eq('0')
  end

  it 'parse_metadata without moveProgressBar result' do
    result = described_class.parse_metadata('spec/rspec_examples/result_without_move_progress_bar_result.html')
    expect(result.processing).to eq('0')
  end
end
