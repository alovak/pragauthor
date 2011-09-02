require 'spec_helper'

describe Indie::Parser::BarnesNoble do
  let(:file) do
    "#{Rails.root}/features/support/files/BNsales_June2011.xls"
  end

  let(:parser) do
    described_class.new(file, user)
  end

  let(:user) { Factory(:user) }

  context "when there are no any books in the app" do
    before do
      Book.delete_all
    end

    context "and file was processed" do
      before do
        parser.process
      end

      it "should create books" do
        Book.count.should == 2
      end

      it "should create books with corresponding titles" do
        ['The First Book', 'The Second Book'].each do |title|
          book = Book.find_by_title(title)
          book.should_not be_nil
        end
      end

      it "should create sales" do
        Sale.count.should == 6
      end

      it "should create sales with dates" do
        ['1 June 2011', '5 June 2011', '10 June 2011', '15 June 2011', '20 June 2011', '25 June 2011'].each do |date|
          Sale.find_by_date_of_sale(DateTime.parse(date)).should_not be_nil
        end
      end

      it "should create sales with units for the books" do
        { 'The First Book'  => 3, 
          'The Second Book' => 18 }.each do |title, units|
          book = Book.find_by_title(title)
          book.sales.sum(:units).should == units
        end
      end

      it "should assign 'Barnes&Noble' as vendor to all sales" do
        vendor  = Vendor.find_by_name('Barnes&Noble')

        vendor.should_not be_nil

        Sale.all.each do |sale|
          sale.vendor.should == vendor
        end
      end
    end
  end
end
