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


    class Money < Base::Money
      private

      def items
        @books ||= Book.order(:title).find(top_book_ids)
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=? and book_id in (?) and currency = ?", @date_range.from_date, @date_range.to_date, top_book_ids, @currency)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:amount)
      end

      def top_book_ids
        @sales
          .where("date_of_sale >= ? and date_of_sale <= ? and currency = ?", @date_range.from_date, @date_range.to_date, @currency)
          .group(:book_id)
          .order('sum_amount DESC')
          .limit(@top_books)
          .sum(:amount).keys
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
