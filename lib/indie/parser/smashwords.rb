require 'csv'

module Indie
  module Parser
    class Smashwords < Base

      VENDOR_NAME     = 'Smashwords'

      SKIP_ROWS       = 1
      SALE            = 0
      TITLE           = 5
      UNIT_NET_SALES  = 8
      DATE_OF_SALE    = 19

      def process
        @table = CSV.read(@file_path, :quote_char => '"', :col_sep =>"\t", :row_sep =>:auto)

        @table.drop(SKIP_ROWS).each do |row|
          if row[SALE] == 'sale'
            book = find_or_create_book(row[TITLE])
            create_sale(book, :units => row[UNIT_NET_SALES], :date_of_sale => convert_date(row[DATE_OF_SALE]))
          end
        end
      end

      private

      def convert_date(date)
        DateTime.strptime(date, '%Y-%m-%d')
      end
    end
  end
end

