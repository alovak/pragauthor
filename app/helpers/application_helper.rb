module ApplicationHelper
  def controller_css_scope_name
    controller_name.gsub('/', '__')
  end

  def barchart(width, months )
    render :partial => 'line', :collection => bardata(width, months), :as => :record
  end

  def bardata(width, months)
    max = months.collect {|m| m.units}.max

    [].tap do |bars|
      months.each_with_index do |month, index| 
        bars << { 
          :value => month.units,
          :width => month.units*width/max + 2,
          :label => month.name
        }
      end
    end
  end

end
