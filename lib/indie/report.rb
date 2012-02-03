require 'indie/report/vendor'
require 'indie/report/month'

module Indie
  module Report
    class Base
      MONTHS = 6

      attr_accessor :book
      attr_reader   :months, :vendors, :currency

      def initialize(book, currency = 'USD')
        @book = book
        @currency = currency
        @vendors = ::Vendor.all.collect {|vendor| Indie::Report::Vendor.new(:model => vendor, :currency => currency)}
      end

      def self.create(book, currency = 'USD')
        report = new(book, currency)
        report.generate
        report
      end

      def generate
        initialize_months

        calculate_months_units
        calculate_months_money

        calculate_total_vendors_money
        calculate_total_vendors_units

        calculate_last_n_vendors_units
        calculate_last_n_vendors_money
      end

      def total_units
        vendors.inject(0) {|sum, vendor| sum + vendor.units }
      end

      def total_last_n_units
        vendors.inject(0) {|sum, vendor| sum + vendor.last_n_units }
      end
      
      def total_money
        vendors.inject(Money.new(0, currency)) {|sum, vendor| sum + vendor.money }
      end

      def total_last_n_money
        vendors.inject(Money.new(0, currency)) {|sum, vendor| sum + vendor.last_n_money }
      end

      private
      def initialize_months
        # do not fail if required month out of 6 month scope
        @month_table = Hash.new do |hash, key|
          hash[key] = Month.new(key, 0, currency)
        end

        @months = (MONTHS-1).downto(0).collect do |m| 
          month = Month.new(Date.new(m.month.ago.year, m.month.ago.month), 0, currency)
          @month_table[month.date]# = month
        end
      end

      def calculate_total_vendors_units
        data = book.sales
                   .group("vendor_id")
                   .sum(:units)

        data.each do |vendor_id, units|
          next if units == 0

          if vendor = vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.units = units
          end
        end
      end

      def calculate_last_n_vendors_units
        data = book.sales
                   .where("date_of_sale > ?", MONTHS.month.ago.end_of_month)
                   .group("vendor_id")
                   .sum(:units)

        data.each do |vendor_id, units|
          next if units == 0

          if vendor = vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.last_n_units = units
          end
        end
      end

      def calculate_total_vendors_money
        data = book.sales
                   .where(:currency => currency)
                   .group("vendor_id")
                   .group("currency")
                   .sum(:amount)

        data.each do |group, amount|
          next if amount == 0

          vendor_id = group[0]
          currency  = group[1]

          if vendor = vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.money = Money.new(amount, currency)
          end
        end
      end

      def calculate_last_n_vendors_money
        data = book.sales
                   .where("date_of_sale > ? and currency = ?", MONTHS.month.ago.end_of_month, currency)
                   .group("vendor_id")
                   .group("currency")
                   .sum(:amount)

        data.each do |group, amount|
          next if amount == 0

          vendor_id = group[0]
          currency  = group[1]

          if vendor = vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.last_n_money = Money.new(amount, currency)
          end
        end
      end

      def month_table(date)
        @month_table[date]
      end

      def calculate_months_money
        data =  book.sales
                    .where("date_of_sale > ? and currency = ?", MONTHS.month.ago.end_of_month, currency)
                    .group("year(date_of_sale)")
                    .group("month(date_of_sale)")
                    .group("vendor_id")
                    .group("currency")
                    .sum(:amount)

        data.each do |group, amount|
          next if amount == 0

          sale_date = Date.new(group[0], group[1])
          vendor_id = group[2]
          currency  = group[3]

          if vendor = month_table(sale_date).vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.money = Money.new(amount, currency)
          end
        end
      end

      def calculate_months_units
        data =  book.sales
                    .where("date_of_sale > ?", MONTHS.month.ago.end_of_month)
                    .group("year(date_of_sale)")
                    .group("month(date_of_sale)")
                    .group("vendor_id")
                    .sum(:units)

        data.each do |group, units|
          sale_date = Date.new(group[0], group[1])
          vendor_id = group[2]

          if vendor = month_table(sale_date).vendors.find {|vendor| vendor.model.id == vendor_id }
            vendor.units = units
          end
        end
      end
    end
  end
end
