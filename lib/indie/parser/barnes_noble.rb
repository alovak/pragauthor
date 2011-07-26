module Indie
  module Parser
    class BarnesNoble < Base
      SKIP_ROWS = 1
      DATE_OF_SALE = 0
      TITLE = 3
      UNIT_NET_SALES = 8

      def initialize(file_path)
        @file_path = file_path
      end

      def process
        @book = Spreadsheet.open(@file_path)

        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          unless row[TITLE].blank?
            book = Book.find_or_create_by_title(row[TITLE])
            book.sales.create(:units => row[UNIT_NET_SALES], :vendor => vendor, :date_of_sale => convert_date(row[DATE_OF_SALE]))
          end
        end
      end

      private

      def vendor
        @vendor ||= Vendor.find_by_name('Barnes&Noble')
      end

      # TODO get information about date format
      def convert_date(date)
        DateTime.strptime(date, '%m/%d/%Y')
      end
    end
  end
end


