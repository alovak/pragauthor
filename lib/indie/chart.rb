module Indie
  module Chart

    class VendorSales < Base::Units
      private

      def items
        @items ||= Vendor.all
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <=?", @date_range.from_datetime, @date_range.to_datetime)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:vendor_id)
          .sum(:units)
      end
    end

    class Sales < Base::Units
      private
      def items
        @books ||= Book.order(:title).find(top_book_ids)
      end

      def raw_data
        @sales
          .where("date_of_sale >= ? and date_of_sale <= ? and book_id in (?)", @date_range.from_datetime, @date_range.to_datetime, top_book_ids)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:units)
      end

      def top_book_ids
        @sales
          .where("date_of_sale >= ? and date_of_sale <= ?", @date_range.from_datetime, @date_range.to_datetime)
          .group(:book_id)
          .order('sum_units DESC')
          .limit(@top_books)
          .sum(:units).keys
      end
    end
  end
end
