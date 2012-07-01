class RealTimeGraph
  constructor: (graph, width, height, apiKey, feedId) ->
    @timeWindow = 36000
    @apiKey     = apiKey
    @feedId     = feedId
    @graph      = graph
    @graph.width(width)
    @graph.height(height)

  setTimeWindow: (element) ->
    time  = $(element).attr('time')
    @timeWindow = (3600000 * time)

  plotGraph: (data) ->
    $.plot @graph,
      [data: data, lines: { show: true, fill: true }]
      { xaxis: { mode: 'time' }
      selection: { mode: 'xy' }}

  fetchData: ->
    self = @
    $.ajax
      url: '/api'
      data: 'api_read_token=' + @apiKey + '&feed_id=' + @feedId + '&from=' + @from + '&till=' + @till
      dataType: 'json'
      success: (data) -> self.plotGraph(data)

  refreshGraph: ->
    @till  = new Date().getTime()
    @from  = @till - @timeWindow
    @fetchData()

class RawDataGraph extends RealTimeGraph
  constructor: (graph, width, height, apiKey, feedId) ->
    super
    @state = 'year'
    @till  = new Date().getTime()
    @from  = @till - (3600000 * 24.0 * 365)

  plotGraph: (data) ->
    calculateAverage(data)
    super

  plotSelected: (ranges) ->
    ranges.xaxis.to = ranges.xaxis.from + 0.00001 if (ranges.xaxis.to - ranges.xaxis.from < 0.00001)
    ranges.yaxis.to = ranges.yaxis.from + 0.00001 if (ranges.yaxis.to - ranges.yaxis.from < 0.00001) 
    @from = ranges.xaxis.from - 3600000
    @till = ranges.xaxis.to - 3600000
    @fetchData()
 
  setTime: (element) ->
    time  = $(element).attr('time')
    @till = new Date().getTime()
    @from = @till - (3600000 * 24 * time);
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

  calculateAverage = (data) ->
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

class BarGraph extends RawDataGraph
  constructor: (graph, width, height, apiKey, feedId) ->
    super
    @pAverage  = 0
    @kwhWindow = 0
    @price     = 0.14
    @botKwhdText = ''
    $('#loading').hide()
    @fetchData()

  plotGraph: (data) ->
    @data = data
    tKwh  = 0
    nDays = data.length
    tKwh += parseFloat(z[1]) for z in data
    @renderWeekView(data)  if @state == 'week'
    @renderMonthView(data) if @state == 'month'
    @renderYearView(data)  if @state == 'year'
    @botKwhdText = kWhText(tKwh, nDays, @price)

  kWhText= (tKwh, nDays, price) ->
    text  = 'Total: ' + (tKwh).toFixed(0)
    text += ' kWh : €' + (tKwh * price).toFixed(0)
    text += ' | Average: ' + (tKwh / nDays).toFixed(1)
    text += ' kWh : €' + ((tKwh / nDays) * price).toFixed(2)
    text += ' | €' + ((tKwh / nDays) * price * 7).toFixed(0)
    text += ' a week, €' + ((tKwh / nDays) * price * 365).toFixed(0)
    text += ' a year | Unit price: €' + price
    text

  renderMonthView: (data) ->
    $("#out").html('')
    data = getDays(data)
    @renderBarGraph(data, 3600 * data.length)
    ($ '#out2').html('Month overview')
    $("#bot_out").html(@botKwhdText)

  renderYearView: (data) ->
    $("#out").html('')
    data = getMonths(data)
    @renderBarGraph(data, 3600 * 650)
    ($ '#out2').html('Year overview')
    $("#bot_out").html(@botKwhdText)

  renderBarGraph: (data, width) ->
    $('#axislabely').html("Energy<br/ >(kWh)")
    $.plot @graph,
     [ data: data, color: "#0096ff"]
     bars: { show: true, align: 'center', barWidth: width * 1000 , fill: true }
     valueLabels: { show: false }
     grid: { show: true }
     xaxis: { mode: 'time' }

  setTime: (element) ->
    time  = $(element).attr('time')
    ($ '.time').removeAttr('disabled')
    @state = 'day'   if time == '1'
    @state = 'week'  if time == '7'
    @state = 'month' if time == '30'
    @state = 'year'  if time == '365'
    $(element).attr('disabled', 'disabled')
    @till = new Date().getTime()
    @from = @till - (3600000 * 24 * time);
    @fetchData()

  getDays = (data) ->
    hash  = {}
    array = []
    self = @
    for z in data
      do (z) ->
        timeStamp = cleanDate(z[0]).getTime()
        if hash[timeStamp] == undefined
          hash[timeStamp] = [z[1], 1]
        else
          hash[timeStamp][0] += z[1]
          hash[timeStamp][1]++
    array.push [k, (v[0] / v[1]) * 24] for k,v of hash
    array

  getMonths = (data) ->
    hash  = hashWithMonthTimestamps(data)
    array = []
    self = @
    for z in data
      do (z) ->
        timeStamp = getMonthTimestamp(z[0])
        if hash[timeStamp] == undefined
        else
          hash[timeStamp][0] += z[1]
          hash[timeStamp][1]++
    array.push [k, (v[0] / v[1]) * 24] for k,v of hash
    array

  cleanDate = (timeStamp) ->
    date = new Date(timeStamp)
    new Date(date.getFullYear(), date.getMonth(), date.getDate())

  hashWithMonthTimestamps = (data) ->
    hash  = {}
    array = []
    array.push(z[0]) for z in data
    last = Math.max.apply(null, array)
    for num in [1..12]
      do (num) ->
        date  = new Date(last)
        month = (date.getMonth() + 1 - num)
        year  = date.getFullYear()
        hash[new Date(year, month, 1).getTime()] = [0,0]
    hash

  getMonthTimestamp = (time) ->
    date  = new Date(time)
    month = date.getMonth() + 1
    year  = date.getFullYear()
    new Date(year, month, 1).getTime()

jQuery ->
  if $('#real_time_graph').length > 0
    window.graph = new RealTimeGraph ($ '#real_time_graph'),
      ($ '#graph_bound').width()
      ($ '#graph_bound').height()
      ($ '#api_key').val()
      ($ '#feed_id').val()

    ($ '#real_time_buttons .viewWindow').bind 'click', (e) ->
      window.graph.setTimeWindow(e.currentTarget)

    window.graph.refreshGraph()
    setInterval('window.graph.refreshGraph()', 5000 )

  if $('#raw_data_graph').length > 0
    graph = new RawDataGraph ($ '#raw_data_graph'),
      ($ '#graph_bound').width()
      ($ '#graph_bound').height()
      ($ '#api_key').val()
      ($ '#feed_id').val()

    ($ '#raw_data_graph').bind 'plotselected', (event, ranges) -> graph.plotSelected(ranges)

    graph.fetchData()

  if $('#bar_graph').length > 0
    graph = new BarGraph ($ '#bar_graph'),
      ($ '#graph_bound').width()
      ($ '#graph_bound').height()
      ($ '#api_key').val()
      ($ '#feed_id').val()

  ($ '#zoomout').bind 'click',     -> graph.zoom 2
  ($ '#zoomin').bind  'click',     -> graph.zoom 0.5
  ($ '#left').bind    'click',     -> graph.shift 'left'
  ($ '#right').bind   'click',     -> graph.shift 'right'
  ($ '.time').bind    'click', (e) -> graph.setTime(e.currentTarget)
