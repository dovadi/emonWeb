function setTimeWindow(element)
{
  var time   = $(element).attr('time');
  timeWindow = (3600000 * time);
};

function refreshGraph()
{
  till  = new Date().getTime();
  from  = till - timeWindow;

  fetchRealTimeData(apiKey, feedId, from, till);
};

function fetchRealTimeData(apiKey, feedId, from, till)
{
  $.ajax({                                      
    url: '/api',                           
    data: 'api_read_token=' + apiKey + '&feed_id=' + feedId + '&from=' + from + '&till=' + till,
    dataType: 'json',                           
    success: function(data) 
    { 
     $.plot($('#graph'),
        [{data: data, lines: { fill: true }}],
        {xaxis: { mode: 'time' },
        //grid: { show: true, hoverable: true, clickable: true },
        selection: { mode: 'xy' }
      })
    } 
  });
}

