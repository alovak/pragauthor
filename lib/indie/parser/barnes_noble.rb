module Indie
  module Parser
    class BarnesNoble < Base
      SKIP_ROWS = 1
      TITLE = 3
      UNIT_NET_SALES = 8

      def initialize(file_path)
        @book = Spreadsheet.open(file_path)
      end

      def process
        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          if !row[TITLE].blank?
            book = Book.find_or_create_by_title(row[TITLE])
            book.sales.create(:units => row[UNIT_NET_SALES], :vendor => vendor)
          end
        end
      end

      private

      def vendor
        @vendor ||= Vendor.find_by_name('Barnes&Noble')
      end

    end
  end
end
