require 'csv'

module Indie
  module Parser
    class Smashwords < Base
      def initialize(file_path)
        @file = CSV.read(file_path, :quote_char => '"', :col_sep =>"\t", :row_sep =>:auto)
      end
    end
  end
end

