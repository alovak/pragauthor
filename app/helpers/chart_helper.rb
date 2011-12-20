module ChartHelper
  def sales_chart(chart, options = {})
    container_id = options.delete(:render_to)

    if chart.show_trend?
      trend_series = %Q{
        series: {#{chart.data[:cols].size-3}: {type: "line"}, #{chart.data[:cols].size-2}: {type: "line"}}
      }
    end

    %Q{
      var dt = new google.visualization.DataTable(#{chart.data.to_json})

      // Create and draw the visualization.
      var ac = new google.visualization.ComboChart(document.getElementById('#{container_id}'));

      ac.draw(dt, {
        width: 710,
        height: 200,
        seriesType: "bars",
        chartArea: {left: 30, top: 4, width: 500, height: 180},
        fontSize: 11,
        fontName: 'PT Sans',
        pointSize: 3,
        tooltip: {textStyle: {color: '#726E6B'}},
        legend: {textStyle: {color: '#726E6B'}, position: 'right'},
        vAxis: {textStyle: {color: '#726E6B', fontSize: 10}, baselineColor: '#726E6B', textPosition: 'in', },
        hAxis: {textStyle: {color: '#726E6B'}},
        #{trend_series if chart.show_trend?}
      });
    }
  end
end
