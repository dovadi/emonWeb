window.RealTimeGraph = class RealTimeGraph
  constructor: (graph, width, height, apiKey, feedId) ->
    @timeWindow =  36000
    @apiKey     = apiKey
    @feedId     = feedId
    @graph      = graph
    @graph.width(width)
    @graph.height(height)

  setTimeWindow: (element) ->
    time  = $(element).attr('time')
    @timeWindow = (3600000 * time)

  fetchRealTimeData: (from, till) ->
    graph = @graph
    $.ajax
      url: '/api'
      data: 'api_read_token=' + @apiKey + '&feed_id=' + @feedId + '&from=' + from + '&till=' + till
      dataType: 'json'
      success: (data) ->
        $.plot graph,
          [data: data, lines: { fill: true }]
          { xaxis: { mode: 'time' }
          selection: { mode: 'xy' }}

  refreshGraph: ->
    till  = new Date().getTime()
    from  = till - @timeWindow
    @fetchRealTimeData(from, till)

window.rawDataGraph = class rawDataGraph
  constructor: (graph, width, height, apiKey, feedId) ->
    @timeWindow =  36000
    @apiKey     = apiKey
    @feedId     = feedId
    @from       = new Date().getTime()
    @till       = @from - (3600000 * 24.0)
    @graph      = graph
    @graph.width(width)
    @graph.height(height)

  plotGraph: (graph, data) ->
    $.plot graph,
     [ data: data, lines: { show: true, fill: true }]
     { xaxis: { mode: 'time' }, selection: { mode: 'xy' } }
    ($ '#loading').hide();

  fetchData: ->
    ($ '#loading').show();
    ($ '#stat').html('Loading...  please wait about 5s')
    plotGraph = @plotGraph
    graph     = @graph
    $.ajax
      url: '/api',
      data: 'api_read_token=' + @apiKey + '&feed_id=' + @feedId + '&from=' + @from + '&till=' + @till,
      dataType: 'json',
      success: (data) ->
        if data.length > 0
          pAverage  = 0
          nPoints   = data.length
          pAverage += parseFloat(z[1]) for z in data                  

          timeB = Number(data[0][0])/1000.0
          timeA = Number(data[data.length-1][0])/1000.0

          timeWindow = (timeB - timeA)
          timeWidth  = timeWindow / nPoints
          kwhWindow  = (timeWidth * pAverage) / 3600000

          pAverage = (pAverage / nPoints)
          ($ '#stat').html((pAverage).toFixed(1)+' W | '+(kwhWindow).toFixed(1)+' kWh')
        else
          ($ '#stat').html('No data')
        plotGraph(graph, data)

  plotSelected: (ranges) ->
    ranges.xaxis.to = ranges.xaxis.from + 0.00001 if (ranges.xaxis.to - ranges.xaxis.from < 0.00001)
    ranges.yaxis.to = ranges.yaxis.from + 0.00001 if (ranges.yaxis.to - ranges.yaxis.from < 0.00001) 
    @from = ranges.xaxis.from - 3600000
    @till = ranges.xaxis.to - 3600000
    @fetchData()
 
  setTime: (element) ->
    time  = $(element).attr('time')
    @till     = new Date().getTime()
    @from     = @till - (3600000 *24 * time);
    @fetchData()

  zoom: (factor) ->
    timeWindow = @till - @from
    middle     = @from + timeWindow / 2
    timeWindow = timeWindow * factor
    @from      = middle - (timeWindow / 2)
    @till      = middle + (timeWindow / 2)
    @fetchData()

  shift: (direction) ->
    timeWindow = @till - @from
    shiftsize  = timeWindow * 0.2
    if direction == 'right'
       @from += shiftsize
       @till += shiftsize
    else
      @from -= shiftsize
      @till -= shiftsize
    @fetchData()

jQuery ->
  if $('#real_time_graph').length > 0
    window.realTimeGraph = new RealTimeGraph ($ '#real_time_graph'),
      ($ '#graph_bound').width()
      ($ '#graph_bound').height()
      ($ '#api_key').val()
      ($ '#feed_id').val()

    ($ '#real_time_buttons .viewWindow').bind 'click', (e) ->
      window.realTimeGraph.setTimeWindow(e.currentTarget)

    window.realTimeGraph.refreshGraph()
    setInterval('window.realTimeGraph.refreshGraph()', 5000 )

  if $('#raw_data_graph').length > 0
    window.rawDataGraph = new rawDataGraph ($ '#raw_data_graph'),
      ($ '#graph_bound').width()
      ($ '#graph_bound').height()
      ($ '#api_key').val()
      ($ '#feed_id').val()

    ($ '#zoomout').bind 'click',     -> window.rawDataGraph.zoom 2
    ($ '#zoomin').bind  'click',     -> window.rawDataGraph.zoom 0.5
    ($ '#left').bind    'click',     -> window.rawDataGraph.shift 'left'
    ($ '#right').bind   'click',     -> window.rawDataGraph.shift 'right'
    ($ '.time').bind    'click', (e) -> window.rawDataGraph.setTime(e.currentTarget)
    ($ '#raw_data_graph').bind 'plotselected', (event, ranges) -> window.rawDataGraph.plotSelected(ranges)

    window.rawDataGraph.fetchData()
