class BooksController < ApplicationController
  helper :chart

  def index
    @books = current_user.books
    @sales = current_user.sales
  end

  def units
    @book = current_user.books.find(params[:id])
    @date_range = DateRange.new(params[:date_range] || {})
    @currencies = @book.sales.select("distinct currency").collect(&:currency)
    @money_report = Indie::Report::Book::Royalties.new(@book.sales, :period => @date_range, :currency => 'USD')
    @chart_data = Indie::Formatter.to_data_table(@money_report.data, {
      date:  { label: 'Date', type: 'string', f: lambda { |v| v.to_s(:month_and_year) } },
      money: { label: 'Money', v: lambda { |m| m.dollars }, f: lambda {|v| v.format} } 
    })

    @share_report = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :period => @date_range, :currency => 'USD')
    @pie_chart_data = Indie::Formatter.to_data_table(@share_report.data, { 
      vendor: { label: 'Vendor', type: 'string', v: lambda {|v| Vendor.find(v).name }},
      money:  { label: 'Slices', v: lambda {|m| m.dollars}, f: lambda {|v| v.format}}
    })

    render :show
  end

  def show
    @book = current_user.books.find(params[:id])

    @date_range = DateRange.new(params[:date_range] || {})

    @currencies = @book.sales.select("distinct currency").collect(&:currency)

    @current_currency = params[:currency] || @currencies.first

    @money_report = Indie::Report::Book::Royalties.new(@book.sales, :period => @date_range, :currency => params[:currency] )
    @chart_data = Indie::Formatter.to_data_table(@money_report.data, {
      date:  { label: 'Date', type: 'string', f: lambda { |v| v.to_s(:month_and_year) } },
      money: { label: 'Money', v: lambda { |m| m.dollars }, f: lambda {|v| v.format} } 
    })

    @share_report = Indie::Report::Book::RoyaltiesShare.new(@book.sales, :period => @date_range, :currency => params[:currency])
    @pie_chart_data = Indie::Formatter.to_data_table(@share_report.data, { 
      vendor: { label: 'Vendor', type: 'string', v: lambda {|v| Vendor.find(v).name }},
      money:  { label: 'Slices', v: lambda {|m| m.dollars}, f: lambda {|v| v.format}}
    })
  end
end

