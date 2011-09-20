module ApplicationHelper
  def controller_css_scope_name
    controller_name.gsub('/', '__')
  end

  def barchart(width, months )
    render :partial => 'line', :collection => bardata(width, months), :as => :record
  end

  def bardata(width, months)
    max = months.collect {|m| m.units}.max
    colors = %w(d67534 bb2b24 118793 92a489 d1ad58 714c94)

    [].tap do |bars|
      months.each_with_index do |month, index| 
        bars << { 
          :value => month.units,
          :color => "##{colors[index]}", 
          :width => month.units*width/max + 2,
          :label => month.name
        }
      end
    end
  end

end
