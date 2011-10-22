require 'spec_helper'
require 'lib/indie/parser/shared_examples_for_parser'

describe Indie::Parser::BarnesNoble do
  let(:file) do
    "#{Rails.root}/features/support/files/BNsales_June2011.xls"
  end

  expectations = {
    :titles => ['The First Book', 'The Second Book'],
    :books  => 2,
    :sales  => 6,
    :book_units => { 
      'The First Book'  => 3, 
      'The Second Book' => 18 
    },

    :book_money => { 
      'The First Book'  => Money.us_dollar(1_20), 
      'The Second Book' => Money.us_dollar(7_20),
    }
  }

  it_should_behave_like "a parser", expectations

  sale_dates = ['1 June 2011', '5 June 2011', '10 June 2011', '15 June 2011', '20 June 2011', '25 June 2011']

  it_should_behave_like "a parser for daily sales", sale_dates
end
