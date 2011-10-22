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
    },
    :book_money => { 
      'The First Book'  => Money.us_dollar(8_59), 
      'The Second Book' => Money.us_dollar(1_20),
      'The Third Book'  => Money.us_dollar(3_35),
      'The Fourth Book' => Money.us_dollar(2_06)
    }
  }

  it_should_behave_like "a parser", expectations

  sale_dates = [ 
    "09 Aug 2010 15:57", "10 Aug 2010 08:06", "16 Aug 2010 17:11", "17 Aug 2010 14:18", "17 Aug 2010 21:02", "18 Aug 2010 14:18", 
    "18 Aug 2010 14:45", "21 Aug 2010 08:12", "22 Aug 2010 10:04", "23 Aug 2010 15:50", "25 Aug 2010 13:46", "31 Aug 2010 09:00", 
    "30 Sep 2010 21:03", "10 Oct 2010 16:19", "17 Jan 2011 05:01", "20 Jan 2011 04:46", "04 Feb 2011 04:24", "01 Mar 2011 17:04", 
    "02 Mar 2011 04:20", "02 Mar 2011 14:48", "05 Mar 2011 15:34", "18 Mar 2011 20:07", "19 Mar 2011 20:48", "02 May 2011 06:47", 
    "02 May 2011 16:43", "13 May 2011 12:23", "13 May 2011 12:23", "30 May 2011 11:21", "30 May 2011 11:21", "30 May 2011 11:21" 
  ]

  it_should_behave_like "a parser for daily sales", sale_dates
end

