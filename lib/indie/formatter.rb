module Indie
  class Formatter
    # options is a hash of the following options for each column
    #
    #   type: string or number (default)
    #   formatter: lambda
    def self.to_data_table(data, options)
      columns = options.keys

      {}.tap do |data_table|

        data_table[:cols] = options.collect { |key, value| {label: value[:label], type: value[:type] || 'number'} }
        data_table[:rows] = []

        data.each do |item|
          row = { c: [] }

          columns.each do |column|
            {}.tap do |cell|

              # if we need to process value with proc
              cell[:v] =  if options[column][:v]
                            options[column][:v].call(item[column])
                          else
                            item[column]
                          end

              # if we need to process format with proc
              cell[:f] = options[column][:f].call(item[column]) if options[column][:f]

              row[:c] << cell
            end
          end

          data_table[:rows] << row
        end
      end
    end
  end
end
