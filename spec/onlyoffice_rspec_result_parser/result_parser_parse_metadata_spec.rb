# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeRspecResultParser::ResultParser,
         '.parse_metadata' do
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
