module Indie
  module Parser
    class BarnesNoble < Base
      TITLE = 3
      SKIP_ROWS = 1

      def initialize(file_path)
        @book = Spreadsheet.open(file_path)
      end

      def process
        sheet = @book.worksheet 0

        sheet.each(SKIP_ROWS) do |row|
          Book.find_or_create_by_title(row[TITLE])
        end
      end

    end
  end
end
