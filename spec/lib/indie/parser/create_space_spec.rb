require 'spec_helper'
require 'lib/indie/parser/shared_examples_for_parser'

describe Indie::Parser::CreateSpace do
  let(:file) do
    "#{Rails.root}/features/support/files/sales_details_384487_2012-04-30_u22ml-0 copy.xls"
  end

  expectations = {
    :titles => ['The First Book', 'The Second Book'],
    :books  => 2,
    :sales  => 5,
    :book_units => { 
      'The First Book'  => 80, 
      'The Second Book' => 2,
    },
    :book_money => { 
      'The First Book'  => Money.us_dollar(523_20), 
      'The Second Book' => Money.us_dollar(23_06),
    }
  }

  it_should_behave_like "a parser", expectations

  sale_dates = [ 
    "04 Apr 2012 12:38:57", "07 Apr 2012 00:22:10", "09 Apr 2012 08:38:21",
    "11 Apr 2012 09:19:22", "12 Apr 2012 19:12:14"
  ]

  it_should_behave_like "a parser for daily sales", sale_dates

  it "should delete books for existed period"
  it "should not delete books if start date and end date are not set"
end

