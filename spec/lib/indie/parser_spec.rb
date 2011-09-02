require 'spec_helper'

describe Indie::Parser do
  describe "#factory" do
    let(:user) { mock() }

    it "should return class according to file name" do
      {
        './path/BNsales_May2011.xls' => Indie::Parser::BarnesNoble,
        './path/SmashWords_salesReport-2011-06-08.xls' => Indie::Parser::Smashwords,
        './path/kdp-report-04-2011.xls' => Indie::Parser::Amazon
      }.each_pair do |file_name, parser_class|
        parser = Indie::Parser.factory(file_name, user)
        parser.should be_an_instance_of parser_class
      end
    end

    it "should assign user to parser" do
      parser = Indie::Parser.factory('./path/BNsales_May2011.xls', user)
      parser.user.should == user
    end
  end
end
