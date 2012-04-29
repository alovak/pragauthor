module Indie
  module Chart

    class VendorSales < Base::Units
      private

      def items
        @items ||= Vendor.all
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=?", @date_range.from_date, @date_range.to_date)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:vendor_id)
          .sum(:units)
      end
    end

    class VendorMoney < Base::Money
      private

      def items
        @items ||= Vendor.all
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=? and currency = ?", @date_range.from_date, @date_range.to_date, @currency)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:vendor_id)
          .sum(:amount)
      end
    end


    class VendorUnitsShare < Base::Units
      private

      def items
        @vendors ||= Vendor.order(:name)
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=? and currency = ?", @date_range.from_date, @date_range.to_date, @currency)
          .group(:vendor_id)
          .sum(:units)
      end

      def cols
        [].tap do |cols|
          cols << { label: 'Vendor', type: 'string' }

          items.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }
        end
      end

      def rows
        [].tap do |rows|
          items.each do |vendor|
            row = { c: [] }

            row[:c] << { v: vendor.name }

            sum = 0

            units = raw_data[vendor.id] || 0

            row[:c] << { v: units }

            rows << row
          end
        end
      end
    end

    class VendorMoneyShare < Base::Money
      private

      def items
        @vendors ||= Vendor.order(:name)
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=? and currency = ?", @date_range.from_date, @date_range.to_date, @currency)
          .group(:vendor_id)
          .sum(:amount)
      end

      def cols
        [].tap do |cols|
          cols << { label: 'Vendor', type: 'string' }

          items.inject(cols) { |acc, b| acc << {label: b.title, type: 'number'} }
        end
      end

      def rows
        [].tap do |rows|
          items.each do |vendor|
            row = { c: [] }

            row[:c] << { v: vendor.name }

            sum = 0

            units = raw_data[vendor.id] || 0

            row[:c] << { v: ::Money.new(units, @currency).dollars, f: ::Money.new(units, @currency).format }

            rows << row
          end
        end
      end
    end

    class Sales < Base::Units
      private
      def items
        @books ||= Book.order(:title).find(top_book_ids)
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <= ? and book_id in (?)", @date_range.from_date, @date_range.to_date, top_book_ids)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:units)
      end

      def top_book_ids
        @sales
          .where("date_of_sale >= ? and date_of_sale <= ?", @date_range.from_date, @date_range.to_date)
          .group(:book_id)
          .order('sum_units DESC')
          .limit(@top_books)
          .sum(:units).keys
      end
    end
  end
end
