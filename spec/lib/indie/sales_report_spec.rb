require 'spec_helper'

describe Indie::SalesReport do
  let(:user) { Factory(:user) }
  
  before do
  end

  it "should return top 2 books" do
    first_book = Factory(:book, :user => user)
    second_book = Factory(:book, :user => user)
    third_book = Factory(:book, :user => user)


    vendor = Vendor.find_by_name("Barnes&Noble")

    Factory(:sale, 
            :book => first_book, :units => 10, :amount => 100, :currency => "USD",
            :date_of_sale => Chronic.parse("01 Jun 2010"))
    Factory(:sale, 
            :book => second_book, :units => 3, :amount => 100, :currency => "USD",
            :date_of_sale => Chronic.parse("01 Jul 2010"))
    Factory(:sale, 
            :book => third_book, :units => 9, :amount => 100, :currency => "USD",
            :date_of_sale => Chronic.parse("01 Aug 2010"))
    Factory(:sale, 
            :book => third_book, :units => 2, :amount => 100, :currency => "USD",
            :date_of_sale => Chronic.parse("01 Aug 2010"))

    Timecop.freeze(DateTime.parse("Fri, 08 Jun 2010")) do
      report = Indie::SalesReport.new(user.sales, 
                                      [ "sales.date_of_sale > ?",
                                        6.month.ago.end_of_month ])

      top_books = report.books_top(2)

      top_books.should have(2).books

      top_books.should include(first_book)
      top_books.should include(third_book)
    end
  end
end
