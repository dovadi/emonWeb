window.RealTimeGraph = class RealTimeGraph
  constructor: ->
    @timeWindow =  36000
    @apiKey     = ($ '#api_key').val()
    @feedId     = ($ '#feed_id').val()

  setTimeWindow: (element) ->
    time  = $(element).attr('time')
    @timeWindow = (3600000 * time)

  fetchRealTimeData: (from, till) ->
    $.ajax
      url: '/api'
      data: 'api_read_token=' + @apiKey + '&feed_id=' + @feedId + '&from=' + from + '&till=' + till
      dataType: 'json'
      success: (data) ->
        $.plot $('#graph'),
          [data: data, lines: { fill: true }]
          { xaxis: { mode: 'time' }
          selection: { mode: 'xy' }}

  refreshGraph: ->
    till  = new Date().getTime()
    from  = till - @timeWindow
    @fetchRealTimeData(from, till)
