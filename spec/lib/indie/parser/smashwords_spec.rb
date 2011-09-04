require 'spec_helper'
require 'lib/indie/parser/shared_examples_for_parser'

describe Indie::Parser::Smashwords do
  let(:file) do
    "#{Rails.root}/features/support/files/SmashWords_salesReport-2011-06-08.xls"
  end

  expectations = {
    :titles => ['The First Book', 'The Second Book', 'The Third Book', 'The Fourth Book'],
    :books  => 4,
    :sales  => 30,
    :book_units => { 
      'The First Book'  => 21, 
      'The Second Book' => 4,
      'The Third Book' => 8,
      'The Fourth Book' => 3,
    }
  }

  it_should_behave_like "a parser", expectations

  sale_dates = [ '21 Aug 2010', '22 Aug 2010', '23 Aug 2010', '25 Aug 2010', 
    '31 Aug 2010', '1 Oct 2010', '10 Oct 2010', '17 Jan 2011', '20 Jan 2011', 
    '4 Feb 2011', '1 Mar 2011', '9 Aug 2010', '10 Aug 2010', '16 Aug 2010', 
    '17 Aug 2010'
  ]

  it_should_behave_like "a parser for daily sales", sale_dates
end

