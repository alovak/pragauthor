module Indie
  module Parser
    class << self
      def factory(file_path) 
        parser_class = detect_parser_by_file(file_path)
        parser_class.new(file_path)
      end

      private

      def detect_parser_by_file(file_path)
        case file_path
        when /bnsales.*xls$/i then Indie::Parser::BarnesNoble
        when /smashwords_salesreport.*xls$/i then Indie::Parser::Smashwords
        end
      end
    end

    class Base
    end
  end
end

