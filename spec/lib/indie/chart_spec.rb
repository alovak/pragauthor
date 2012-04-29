require 'spec_helper'

describe Indie::Chart do
  let(:user) { Factory(:user) }

  let(:amazon) { Vendor.find_by_name("Amazon") }
  let(:bn) { Vendor.find_by_name("Barnes&Noble") }
  let(:smashwords) { Vendor.find_by_name("Smashwords") }
  
  before do
    @first_book  = Factory(:book, :title => 'First Book',  :user => user)
    @second_book = Factory(:book, :title => 'Second Book', :user => user)
    @third_book  = Factory(:book, :title => 'Third Book',  :user => user)

    [ { book: @first_book, 
        sales: [
          { units: 10, amount: 1000, date: '01 jun 2010', :vendor => amazon },
          { units: 20, amount: 2000, date: '01 jul 2010', :vendor => bn },
          { units: 30, amount: 3000, date: '01 aug 2010', :vendor => smashwords } ]},
      { book: @second_book, 
        sales: [
          { units: 15, amount: 1500, date: '01 jun 2010', :vendor => amazon },
          { units: 25, amount: 2500, date: '01 jul 2010', :vendor => bn },
          { units: 35, amount: 3500, date: '01 aug 2010', :vendor => smashwords } ]},
      { book: @third_book, 
        sales: [
          { units: 1, amount: 1000, date: '01 jun 2010', :vendor => amazon },
          { units: 2, amount: 2000, date: '01 jul 2010', :vendor => bn },
          { units: 3, amount: 3000, date: '01 aug 2010', :vendor => smashwords } ]},
    ].each do |data|
        data[:book]

        data[:sales].each do |sale|
          Factory(:sale, 
                  :book => data[:book],
                  :units => sale[:units],
                  :amount => sale[:amount],
                  :vendor => sale[:vendor],
                  :currency => "USD",
                  :date_of_sale => Chronic.parse(sale[:date]))
        end
    end
  end

  describe "VendorUnitsShare" do
    describe "#data" do
      it "should contain valid representation of vendor sales for provided parameters" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::VendorUnitsShare.new(Sale, :period => DateRange.new(:from => 'June 2010'))

          chart.data.should == {
            cols: [{label: 'Vendor',       type: 'string'},
                   {label: 'Amazon',       type: 'number'},
                   {label: 'Barnes&Noble', type: 'number'},
                   {label: 'Smashwords',   type: 'number'},
                  ],
            rows: [ {c: [{v: "Amazon"}, {v: 26.0}]},
                    {c: [{v: "Barnes&Noble"}, {v: 47.0}]},
                    {c: [{v: "Smashwords"}, {v: 68}]}
                  ]
          }
        end
      end
    end
  end

  describe "VendorMoneyShare" do
    describe "#data" do
      it "should contain valid representation of vendor sales for provided parameters" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::VendorMoneyShare.new(Sale, :period => DateRange.new(:from => 'June 2010'))

          chart.data.should == {
            cols: [{label: 'Vendor',       type: 'string'},
                   {label: 'Amazon',       type: 'number'},
                   {label: 'Barnes&Noble', type: 'number'},
                   {label: 'Smashwords',   type: 'number'},
                  ],
            rows: [ {c: [{v: "Amazon"}, {v: 35.0, f: "$35.00"}]},
                    {c: [{v: "Barnes&Noble"}, {v: 65.0, f: "$65.00"}]},
                    {c: [{v: "Smashwords"}, {v: 95.0, f: "$95.00"}]}
                  ]
          }
        end
      end
    end
  end
  describe "Sales" do
    describe "#data" do
      it "should contain valid representation of sales for provided parameters" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::Sales.new(Sale, :top => 2, :period => DateRange.new(:from => 'June 2010'))

          chart.data.should == {
            cols: [{label: 'Month',       type: 'string'},
                   {label: 'First Book',  type: 'number'},
                   {label: 'Second Book', type: 'number'}
                  ],
            rows: [ {c:[{v: 'Jun'}, {v: 10},{v: 15}]},
                    {c:[{v: 'Jul'}, {v: 20},{v: 25}]},
                    {c:[{v: 'Aug'}, {v: 30},{v: 35}]}
                  ]
          }
        end
      end

      it "should contain average and total if trend option set" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::Sales.new(Sale, :show_trend => true, :top => 2, :period => DateRange.new(:from => 'June 2010'))

          chart.data[:cols].should include({ label: 'Average', type: 'number' })
          chart.data[:cols].should include({ label: 'Totals', type: 'number' })

          chart.data[:rows].first[:c][-1][:v].should == 25
          chart.data[:rows].first[:c][-2][:v].should == 12
        end
      end
    end
  end
end
