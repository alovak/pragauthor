module Indie
  class SalesReport
    def initialize(sales, months = 6)
      @sales = sales
      @months = months
    end

    def units
      @sales.sum(:units)
    end

    def money
      data = @sales.group(:currency).sum(:amount)

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
