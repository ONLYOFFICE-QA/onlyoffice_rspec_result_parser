require 'rspec'
require_relative '../../parsers/rspec_result_parser'
describe 'My behaviour' do

  it 'result 1' do
    result = ResultParser.parse_rspec_html_string(File.read('spec/rspec_result_parser_spec/rspec_examples/result_1.html'))
    expect(result).not_to be_nil
  end
end