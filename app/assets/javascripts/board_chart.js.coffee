class BoardChart
  constructor: (@id, @data) ->

    @data = [ {
       date: '2012/03/01',
       lists: { 'To Do': 7, 'Done': 0 }
      }, {
       date: '2012/03/02',
       lists: { 'To Do': 5, 'Done': 2 }
      }, {
       date: '2012/03/03',
       lists: { 'To Do': 5, 'Done': 2 }
      }, {
       date: '2012/03/04',
       lists: { 'To Do': 4, 'Done': 3 }
      }, {
       date: '2012/03/05',
       lists: { 'To Do': 2, 'Done': 5 }
      }, {
       date: '2012/03/06',
       lists: { 'To Do': 0, 'Done': 7 }
      }]

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
    console.log(@series())

  series: =>
    lists = {}
    for point in @data
      for name, work of point.lists
        lists[name] ||= []
        lists[name].push [new Date(point.date).getTime(), work]

    ({ name: name, data: data } for name, data of lists)

@TrelloBurndown ||= {}
@TrelloBurndown.BoardChart = BoardChart

