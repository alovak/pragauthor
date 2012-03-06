module Indie
  class SalesReport
    def initialize(sales, months = nil)
      @sales = sales
      @months = months
    end

    def units
      data = @sales
      data = data.where(period_conditons) if @months
      data.sum(:units)
    end

    def money
      data = @sales
      data = data.where(period_conditons) if @months
      data = data.group(:currency).sum(:amount)

      [].tap do |money_collection|
        data.each do |currency, amount|
          money_collection << Money.new(amount, currency) if amount != 0
        end
      end
    end

    private

    def period_conditons
      ["date_of_sale > ?", @months.month.ago.end_of_month]
    end
  end
end
