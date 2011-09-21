module ApplicationHelper
  def controller_css_scope_name
    controller_name.gsub('/', '__')
  end

  def month_color(month)
    colors = {
      'Jan' => %w(d67534 d67534), 
      'Feb' => %w(bb2b24 bb2b24), 
      'Mar' => %w(118793 118793), 
      'Apr' => %w(92a489 92a489), 
      'May' => %w(d1ad58 d1ad58), 
      'Jun' => %w(714c94 714c94), 
      'Jul' => %w(d67534 d67534), 
      'Aug' => %w(bb2b24 bb2b24), 
      'Sep' => %w(118793 118793), 
      'Oct' => %w(92a489 92a489), 
      'Nov' => %w(d1ad58 d1ad58), 
      'Dec' => %w(714c94 714c94), 
    }
    month_name =  case month
                  when String then month
                  when Date then month.strftime('%b')
                  end


    dark, light = colors[month_name]
    { :dark => dark, :light => light }
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
          :color => "##{month_color(month.name)[:dark]}", 
          :width => month.units*width/max + 2,
          :label => month.name
        }
      end
    end
  end

end
