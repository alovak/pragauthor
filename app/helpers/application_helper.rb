module ApplicationHelper
  def controller_css_scope_name
    controller_name.gsub('/', '__')
  end

  def barchart(height, months)
    render :partial => 'line', :collection => bardata(height, months), :as => :record
  end

  def bardata(height, months)
    max = months.collect {|m| m.units}.max

    [].tap do |bars|
      months.each_with_index do |month, index| 

        line_height = (max == 0) ? 0 : (month.units*height/max)

        bars << { 
          :value => month.units,
          :height => line_height,
          :spacer => (height - line_height),
          :label => month.name
        }
      end
    end
  end

  def raw_data(sales)
    data = Hash.new do |hash, key|
      hash[key] = []
    end

    report = Indie::SalesReport.new(sales)
    res_books = []

    report.books_top(5).each_with_index do |book, index|
      stat = Indie::Report.create(book)

      if stat.months
        res_books << book
        stat.months.each do |month|
          data[month.name][index] = month.units
        end
      end
    end

    res = []

    data.each do |key, val|
      sum = val.inject(0, :+)
      average = (sum / val.size)
      val << sum << average  
      res << ([key] + val).to_a.flatten.to_json
    end

    "var rowData = 
      [ 
        [ 'Month', 
          #{ res_books.uniq.collect {|b| %Q{"#{b.title}"}}.join(",\n") },
          'Totals',
          'Average'],
        #{res.join(",\n")},
      ]
    "
  end
end
