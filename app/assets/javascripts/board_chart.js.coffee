class BoardChart
  constructor: (@id, @data) ->
    @chart = new Highcharts.Chart
      chart:
        renderTo: @id
        type: 'area'
      title:
        text: 'Burndown chart'
      xAxis:
        title:
          text: 'Date'
        type: 'datetime'
        dateTimeLabelFormats:
          day: '%e of %b'
          hour: ' '
      yAxis:
        title:
          text: 'Days of work'
        labels:
          formatter: -> @value
      tooltip:
        formatter: -> "#{Highcharts.dateFormat('%e of %b', this.x)}: '#{this.series.name}' had #{this.y} days of work"
      plotOptions:
        area:
          marker:
            enabled: false
            symbol: 'circle'
            radius: 2
      series: @series()

  series: =>
    lists = {}
    for point in @data
      for name, work of point.lists
        lists[name] ||= []
        lists[name].push [new Date(point.date).getTime(), work]

    ({ name: name, data: data } for name, data of lists)

@TrelloBurndown ||= {}
@TrelloBurndown.BoardChart = BoardChart

