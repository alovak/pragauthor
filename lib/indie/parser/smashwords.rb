require 'csv'

module Indie
  module Parser
    class Smashwords < Base

      SKIP_ROWS       = 1
      SALE            = 0
      TITLE           = 5
      UNIT_NET_SALES  = 8
      DATE_OF_SALE    = 19

      def initialize(file_path)
        @file_path = file_path
      end

      def process
        @table = CSV.read(@file_path, :quote_char => '"', :col_sep =>"\t", :row_sep =>:auto)

        @table.drop(SKIP_ROWS).each do |row|
          if row[SALE] == 'sale'
            book = Book.find_or_create_by_title(row[TITLE])
            book.sales.create(:units => row[UNIT_NET_SALES], :vendor => vendor, :date_of_sale => convert_date(row[DATE_OF_SALE]))
          end
        end
      end

      private

      def vendor
        @vendor ||= Vendor.find_by_name('Smashwords')
      end

      def convert_date(date)
        DateTime.strptime(date, '%Y-%m-%d')
      end
    end
  end
end

