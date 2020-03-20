# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser do
  let(:link_in_result) { File.read('spec/rspec_examples/link_in_result.html') }

  describe 'link in result file' do
    let(:result) { described_class.parse_rspec_html_string(link_in_result) }

    it 'check url is clickable' do
      link = "<a href='https://doc-linux-autotest.teamlab.info/"\
           "products/files/doceditor.aspx?fileid=2678604&new=true'>"\
           'https://doc-linux-autotest.teamlab.info/products/files/'\
           'doceditor.aspx?fileid=2678604&new=true</a>'
      expect(result.describe.child.first.message).to include(link)
    end

    it 'check image is inline' do
      img_string = "<img src='https://nct-data-share."\
                   's3-us-west-2.amazonaws.com/'\
                   "screenshots/irkptCRjvigq.png' height='50%' width='50%'>"
      expect(result.describe.child.first.message).to include(img_string)
    end
  end

  it 'parse_rspec_html contained pending count' do
    file = 'spec/rspec_examples/with-pendings.html'
    result = described_class.parse_rspec_html(file)
    expect(result.pending_count).to eq(3)
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
