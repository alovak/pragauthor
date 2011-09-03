require 'spec_helper'

require 'lib/indie/parser/shared_examples_for_parser'

describe Indie::Parser::Smashwords do
  let(:file) do
    "#{Rails.root}/features/support/files/SmashWords_salesReport-2011-06-08.xls"
  end

  it_should_behave_like "a parser"
  it_should_behave_like "a parser for daily sales"
end

