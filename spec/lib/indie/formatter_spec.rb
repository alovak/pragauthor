require 'spec_helper'

describe Indie::Formatter do
  let (:data) { [ { :date => Date.parse("Fri, 20 Aug 2010"), :units => 100, :money => Money.new(2000, 'USD') } ] }

  describe ".to_data_table" do
    it "should return correct structure for provided data" do
      json = Indie::Formatter.to_data_table(data, {
          date:  { label: 'Date', type: 'string'},
          units: { label: 'Units' }
        })

      json.should == {
        cols: [ { label: 'Date',  type: 'string'},
                { label: 'Units', type: 'number'},
              ],
        rows: [ { c: [ { v: Date.parse("Fri, 20 Aug 2010") }, { v: 100 } ] },
              ]
      }
    end

    it "should use proc for format" do
      json = Indie::Formatter.to_data_table(data, { date: { label: 'Date', type: 'string', f: lambda { |v| v.to_s(:month_and_year) }} })
      json[:rows][0][:c][0].should include(f: "Aug 2010")
    end

    it "should use proc for value" do
      json = Indie::Formatter.to_data_table(data, { date: { label: 'Date', type: 'string', v: lambda { |v| v.to_s(:month_and_year) }} })
      json[:rows][0][:c][0].should include(v: "Aug 2010")
    end

  end
end
