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
