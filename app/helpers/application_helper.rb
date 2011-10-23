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

end
