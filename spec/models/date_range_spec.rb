require 'spec_helper'

describe DateRange do
  before { Timecop.freeze(DateTime.parse("Fri, 08 Jun 2011")) }
  after { Timecop.return }

  context "when initialized without params" do
    its(:to_date) { should == Date.today.end_of_month }
    its(:from_date) { should == 12.month.ago.to_date.beginning_of_month }
    its(:to) { should == "June 2011" }
    its(:from) { should == "June 2010" }
  end
end
