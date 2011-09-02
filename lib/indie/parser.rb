module Indie
  module Parser
    class << self
      def factory(file_path, user) 
        parser_class = detect_parser_by_file(file_path)
        parser_class.new(file_path, user)
      end

      private

      def detect_parser_by_file(file_path)
        case file_path
        when /bnsales.*xls$/i then Indie::Parser::BarnesNoble
        when /smashwords_salesreport.*xls$/i then Indie::Parser::Smashwords
        when /kdp-report.*xls$/i then Indie::Parser::Amazon
        end
      end
    end

    class Base
      attr_reader :user

      def initialize(file_path, user)
        @file_path = file_path
        @user = user
      end
    end
  end
end

