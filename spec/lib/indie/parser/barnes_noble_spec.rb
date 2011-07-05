require 'spec_helper'

describe Indie::Parser::BarnesNoble do
  let(:file) do
    "#{Rails.root}/features/support/files/BNsales_May2011.xls"
  end

  let(:parser) do
    described_class.new(file)
  end

  context "when there are no any books in the app" do
    context "and file was processed" do
      before do
        parser.process
      end

      it "should create books" do
        ['The First Book', 'The Second Book', 'The Third Book', 'The Fourth Book'].each do |title|
          book = Book.find_by_title(title)
          book.should_not be_nil
        end
      end

      it "should create sales for the books" do
        { 'The First Book'  => 8, 
          'The Second Book' => 11,
          'The Third Book'  => 2,
          'The Fourth Book' => 2}.each do |title, units|
          book = Book.find_by_title(title)
          book.sales.sum(:units).should == units
        end
      end
    end
  end
end
