require 'spec_helper'

describe Indie::Parser do
  describe "#factory" do
    it "should return BarnesNoble parser for Barnes&Noble file" do
      parser = Indie::Parser.factory('./path/BNsales_May2011.xls')
      parser.should be_an_instance_of Indie::Parser::BarnesNoble
    end

    it "should return Smashwords parser for Smashwords file" do
      parser = Indie::Parser.factory('./path/SmashWords_salesReport-2011-06-08.xls')
      parser.should be_an_instance_of Indie::Parser::Smashwords
    end

    it "should return Amazon parser for Amazon's file" do
      parser = Indie::Parser.factory('./path/kdp-report-04-2011.xls')
      parser.should be_an_instance_of Indie::Parser::Amazon
    end
  end
end
