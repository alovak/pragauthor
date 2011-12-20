require 'spec_helper'

describe Indie::Chart do
  let(:user) { Factory(:user) }
  
  before do
    @first_book  = Factory(:book, :title => 'First Book',  :user => user)
    @second_book = Factory(:book, :title => 'Second Book', :user => user)
    @third_book  = Factory(:book, :title => 'Third Book',  :user => user)

    [ { book: @first_book, 
        sales: [
          { units: 10, amount: 1000, date: '01 jun 2010' },
          { units: 20, amount: 2000, date: '01 jul 2010' },
          { units: 30, amount: 3000, date: '01 aug 2010' } ]},
      { book: @second_book, 
        sales: [
          { units: 15, amount: 1500, date: '01 jun 2010' },
          { units: 25, amount: 2500, date: '01 jul 2010' },
          { units: 35, amount: 3500, date: '01 aug 2010' } ]},
      { book: @third_book, 
        sales: [
          { units: 1, amount: 1000, date: '01 jun 2010' },
          { units: 2, amount: 2000, date: '01 jul 2010' },
          { units: 3, amount: 3000, date: '01 aug 2010' } ]},
    ].each do |data|
        data[:book]

        data[:sales].each do |sale|
          Factory(:sale, 
                  :book => data[:book],
                  :units => sale[:units],
                  :amount => sale[:amount],
                  :currency => "USD",
                  :date_of_sale => Chronic.parse(sale[:date]))
        end
    end
  end

  describe "Money" do
    describe "#data" do
      it "should contain valid representation of sales for provided parameters" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::Money.new(Sale, :top => 2, :period => 3)

          chart.data.should == {
            cols: [{label: 'Month',       type: 'string'},
                   {label: 'First Book',  type: 'number'},
                   {label: 'Second Book', type: 'number'}
                  ],
            rows: [ {c: [{v: "Jun"}, {v: 10.0, f: "$10.00"}, {v: 15.0, f: "$15.00"}]},
                    {c: [{v: "Jul"}, {v: 20.0, f: "$20.00"}, {v: 25.0, f: "$25.00"}]},
                    {c: [{v: "Aug"}, {v: 30.0, f: "$30.00"}, {v: 35.0, f: "$35.00"}]}
                  ]
          }
        end
      end

      it "should contain average and total if trend option set" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::Money.new(Sale, :show_trend => true, :top => 2, :period => 3)

          chart.data[:cols].should include({ label: 'Average', type: 'number' })
          chart.data[:cols].should include({ label: 'Totals', type: 'number' })

          chart.data[:rows].first[:c][-1][:v].should == 25.0
          chart.data[:rows].first[:c][-2][:v].should == 12.5
        end
      end
    end
  end
  describe "Sales" do
    describe "#data" do
      it "should contain valid representation of sales for provided parameters" do
        Timecop.freeze(DateTime.parse("Fri, 20 Aug 2010")) do
          chart = Indie::Chart::Sales.new(Sale, :top => 2, :period => 3)

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
          chart = Indie::Chart::Sales.new(Sale, :show_trend => true, :top => 2, :period => 3)

          chart.data[:cols].should include({ label: 'Average', type: 'number' })
          chart.data[:cols].should include({ label: 'Totals', type: 'number' })

          chart.data[:rows].first[:c][-1][:v].should == 25
          chart.data[:rows].first[:c][-2][:v].should == 12
        end
      end
    end
  end
end
