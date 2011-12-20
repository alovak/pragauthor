module Indie
  module Chart
    class Sales
      def initialize(sales, options = {})
        @sales = sales
        @top_books = options[:top] || 5
        @period = options[:period] || 6
      end

      def data
        { cols: [ { label: 'Month', type: 'string' } ] + build_cols,
          rows: build_rows
        }
      end

      private

      def build_cols
        books = Book.order(:title).find(top_book_ids)

        books.collect { |b| {label: b.title, type: 'number'} }
      end

      def build_rows
        books = Book.order(:title).find(top_book_ids)

        [].tap do |rows|
          months.each do |month|
            row = { c: [] }

            row[:c] << { v: month.strftime('%b') }

            books.each do |book|
              raw_key = [month.year, month.month, book.id]
              units = raw_data[raw_key] || 0
              row[:c] << { v: units }
            end

            rows << row
          end
        end
      end

      def months
        @months ||= (@period-1).downto(0).collect { |m| Date.new(m.month.ago.year, m.month.ago.month) }
      end

      def raw_data
        @sales
          .where("date_of_sale > ? and book_id in (?)", @period.month.ago.end_of_month, top_book_ids)
          .group("year(date_of_sale)")
          .group("month(date_of_sale)")
          .group(:book_id)
          .sum(:units)
      end

      def top_book_ids
        @sales
          .where("date_of_sale > ?", @period.month.ago.end_of_month)
          .group(:book_id)
          .order('sum_units DESC')
          .limit(@top_books)
          .sum(:units).keys
      end
    end
  end
end
