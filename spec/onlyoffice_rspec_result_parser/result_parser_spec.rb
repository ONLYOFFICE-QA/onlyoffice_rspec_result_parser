# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser do
  let(:failed_cases_file) { 'spec/rspec_examples/failed-cases-count.html' }
  let(:link_in_result) { File.read('spec/rspec_examples/link_in_result.html') }
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

  it 'failed-cases-count not zero' do
    result = described_class.get_failed_cases_count_from_html(failed_cases_file)
    expect(result).to eq(3)
  end

  it 'check url is clickable' do
    result = described_class.parse_rspec_html_string(link_in_result)
    link = "<a href='https://doc-linux-autotest.teamlab.info/"\
           "products/files/doceditor.aspx?fileid=2678604&new=true'>"\
           'https://doc-linux-autotest.teamlab.info/products/files/'\
           'doceditor.aspx?fileid=2678604&new=true</a>'
    expect(result.describe.child.first.message).to include(link)
  end

  it 'check image is inline' do
    result = described_class.parse_rspec_html_string(link_in_result)
    img_string = "<img src='https://nct-data-share.s3-us-west-2.amazonaws.com/"\
                 "screenshots/irkptCRjvigq.png' height='50%' width='50%'>"
    expect(result.describe.child.first.message).to include(img_string)
  end

  it 'parse_rspec_html contained failed count' do
    result = described_class.parse_rspec_html(failed_cases_file)
    expect(result.failed_count).to eq(3)
  end

  it 'parse_rspec_html contained total count' do
    result = described_class.parse_rspec_html(result_1_html)
    expect(result.passed_count).to eq(1)
  end

  it 'parse_rspec_html contained pending count' do
    file = 'spec/rspec_examples/with-pendings.html'
    result = described_class.parse_rspec_html(file)
    expect(result.pending_count).to eq(3)
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

  it 'parse_metadata without moveProgressBar' do
    file = 'spec/rspec_examples/result_without_move_progress_bar.html'
    result = described_class.parse_metadata(file)
    expect(result.processing).to eq('0')
  end

  it 'parse_metadata without moveProgressBar result' do
    file = 'spec/rspec_examples/result_without_move_progress_bar_result.html'
    result = described_class.parse_metadata(file)
    expect(result.processing).to eq('0')
  end
end
