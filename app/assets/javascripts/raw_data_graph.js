function plotGraph(from, till, placeholder)
{
  $.plot(placeholder,[
    {
      data: graphData,
      lines: { show: true, fill: true }
    }], {
      xaxis: { mode: 'time' },
      selection: { mode: 'xy' }
    }); 
  $('#loading').hide();
};

function fetchDataGraph(apiKey, feedID, from, till, placeholder)
{
 $('#loading').show();
 $('#stat').html('Loading...  please wait about 5s');
 $.ajax({ 
   url: '/api',
   data: 'api_read_token=' + apiKey + '&feed_id=' + feedID + '&from=' + from + '&till=' + till,
   dataType: 'json',
   success: function(data) 
   {
      if (data != 0){
        var pAverage = 0;
        var nPoints  = 0;
        for (var z in data)
        {
          pAverage += parseFloat(data[z][1]);
          nPoints++;
        }  
        var timeB = Number(data[0][0])/1000.0;
        var timeA = Number(data[data.length-1][0])/1000.0;

        var timeWindow = (timeB - timeA);
        var timeWidth  = timeWindow / nPoints;
        var kwhWindow  = (timeWidth * pAverage) / 3600000;

        pAverage = pAverage / nPoints;
        $('#stat').html((pAverage).toFixed(1)+' W | '+(kwhWindow).toFixed(1)+' kWh');

      } else {
        $('#stat').html('No data');
      }
      graphData = [];
      graphData = data;

      plotGraph(from, till, placeholder);
    } 
  });
};

function zoomGraph(placeholder, apiKey, feedID, factor) {
  var timeWindow = till - from;
  var middle     = from + timeWindow / 2;
  timeWindow     = timeWindow * factor;
  from           = middle - (timeWindow / 2);
  till           = middle + (timeWindow / 2);
  fetchDataGraph(apiKey, feedID, from, till, placeholder);
};

function shiftGraph(placeholder, apiKey, feedID, direction) {
  var timeWindow = till - from;
  var shiftsize  = timeWindow * 0.2;
  if (direction == 'right') {
    from += shiftsize;
    till += shiftsize;
  } else {
    from -= shiftsize;
    till -= shiftsize;
  };
  fetchDataGraph(apiKey, feedID, from, till, placeholder);
};

function setTimeGraph(element, placeholder, apiKey, feedID) {
  var time = $(element).attr('time');
  till     = new Date().getTime();
  from     = till - (3600000 *24 * time);
  fetchDataGraph(apiKey, feedID, from, till, placeholder);
};

function plotSelectedGraph(placeholder, apiKey, feedID, ranges) {
  if (ranges.xaxis.to - ranges.xaxis.from < 0.00001) ranges.xaxis.to = ranges.xaxis.from + 0.00001;
  if (ranges.yaxis.to - ranges.yaxis.from < 0.00001) ranges.yaxis.to = ranges.yaxis.from + 0.00001;
  from = ranges.xaxis.from - 3600000;
  till = ranges.xaxis.to - 3600000; 
  fetchDataGraph(apiKey, feedID, from, till, placeholder);
};