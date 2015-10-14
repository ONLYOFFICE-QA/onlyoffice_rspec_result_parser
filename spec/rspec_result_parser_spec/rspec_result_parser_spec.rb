require 'rspec'
require_relative '../../parsers/rspec_result_parser'
describe 'My behaviour' do
  it 'result 1' do
    result = ResultParser.parse_rspec_html_string(File.read('spec/rspec_result_parser_spec/rspec_examples/result_1.html'))
    expect(result).not_to be_nil
  end

  it 'failed-cases-count zero' do
    result = ResultParser.get_failed_cases_count_from_html('spec/rspec_result_parser_spec/rspec_examples/result_1.html')
    expect(result).to eq(0)
  end

  it 'failed-cases-count not zero' do
    result = ResultParser.get_failed_cases_count_from_html('spec/rspec_result_parser_spec/rspec_examples/failed-cases-count.html')
    expect(result).to eq(3)
  end

  it 'check url is clickable' do
    result = ResultParser.parse_rspec_html_string(File.read('spec/rspec_result_parser_spec/rspec_examples/link_in_result.html'))
    expect(result.describe.child.first.message).to include("<a href='https://doc-linux-autotest.teamlab.info/products/files/doceditor.aspx?fileid=2678604&new=true'>https://doc-linux-autotest.teamlab.info/products/files/doceditor.aspx?fileid=2678604&new=true</a>")
  end

  it 'check image is inline' do
    result = ResultParser.parse_rspec_html_string(File.read('spec/rspec_result_parser_spec/rspec_examples/link_in_result.html'))
    expect(result.describe.child.first.message).to include("<img src='https://nct-data-share.s3-us-west-2.amazonaws.com/screenshots/irkptCRjvigq.png' height='50%' width='50%'>")
  end
end
