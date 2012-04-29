module Indie::Report::Book
  class UnitsShare
    def initialize(sales, params = {})
      @sales = sales
      @period = params[:period] || DateRange.new
    end

    def data
      data = @sales
        .where(["date_of_sale >= ? AND date_of_sale <= ?", @period.from_datetime, @period.to_datetime])
        .group(:vendor_id)
        .sum(:units)
        .collect {|k, v| {vendor: k, units: v} }
    end
  end
end

