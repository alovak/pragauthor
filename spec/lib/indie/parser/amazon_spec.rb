require 'spec_helper'
require 'lib/indie/parser/shared_examples_for_parser'

describe Indie::Parser::Amazon do
  let(:file) do
    "#{Rails.root}/features/support/files/kdp-report-04-2011.xls"
  end

  expectations = {
    :titles => ['The First Book', 'The Second Book', 'The Third Book'],
    :books  => 3,
    :sales  => 3,
    :book_units => { 
      'The First Book'  => 190, 
      'The Second Book' => 13,
      'The Third Book'  => 5
    },
    :book_money => { 
      'The First Book'  => Money.us_dollar(66_58), 
      'The Second Book' => Money.us_dollar(6_76),
      'The Third Book'  => Money.us_dollar(1_75)
    }
  }

  it_should_behave_like "a parser", expectations

  include_context "parser stuff"

  it "should create sales with correct dates" do
    parser.process

    Sale.where(:date_of_sale => DateTime.parse('1 Apr 2011')).all.should have(3).sales
  end

  it "should create sales with correct money" do

  end
end
