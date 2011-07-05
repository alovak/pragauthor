module Indie
  module Parser
    class BarnesNoble < Base
      TITLE = 3
      SKIP_ROWS = 1
      UNIT_NET_SALES = 8

      def initialize(file_path)
        @book = Spreadsheet.open(file_path)
      end

      def process
        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          book = Book.find_or_create_by_title(row[TITLE])
          book.sales.create(:units => row[UNIT_NET_SALES])
        end
      end

    end
  end
end
