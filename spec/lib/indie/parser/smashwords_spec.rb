require 'spec_helper'

describe Indie::Parser::Smashwords do
  let(:file) do
    "#{Rails.root}/features/support/files/SmashWords_salesReport-2011-06-08.xls"
  end

  let(:parser) do
    described_class.new(file)
  end

  context "when there are no any books in the app" do
    before do
      Book.delete_all
    end

    context "and file was processed" do
      before do
        parser.process
      end

      it "should create books" do
        Book.count.should == 4
      end

      it "should create books with corresponding titles" do
        ['The First Book', 'The Second Book', 'The Third Book', 'The Fourth Book'].each do |title|
          book = Book.find_by_title(title)
          book.should_not be_nil
        end
      end

      it "should create sales" do
        Sale.count.should == 30
      end

      it "should create sales with dates" do
        [
          '21 Aug 2010', '22 Aug 2010', '23 Aug 2010', '25 Aug 2010', '31 Aug 2010', 
          '1 Oct 2010', '10 Oct 2010', '17 Jan 2011', '20 Jan 2011', '4 Feb 2011', 
          '1 Mar 2011', '9 Aug 2010', '10 Aug 2010', '16 Aug 2010', '17 Aug 2010'
        ].each do |date|
          Sale.find_by_date_of_sale(DateTime.parse(date)).should_not be_nil
        end

        Sale.where(:date_of_sale => DateTime.parse('18 Aug 2010')).all.should have(3).sales
        Sale.where(:date_of_sale => DateTime.parse('30 May 2011')).all.should have(3).sales
      end

      it "should create sales with units for the books" do
        { 'The First Book'  => 21, 
          'The Second Book' => 4,
          'The Third Book' => 8,
          'The Fourth Book' => 3,
        }.each do |title, units|
          book = Book.find_by_title(title)
          book.sales.sum(:units).should == units
        end
      end

      it "should assign 'Smashwords' as vendor to all sales" do
        sw = Vendor.find_by_name('Smashwords')

        Sale.all.each do |sale|
          sale.vendor.should == sw
        end
      end
    end
  end
end

