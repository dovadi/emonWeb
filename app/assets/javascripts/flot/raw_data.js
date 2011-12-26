//--------------------------------------------------------------------------------------
// Plot flot graph
//--------------------------------------------------------------------------------------
function plotGraph(start, end, placeholder)
{
  $.plot(placeholder,[                    
    {
      data: graph_data ,				//data
      lines: { show: true, fill: true }		//style
    }], {
    xaxis: {  mode: "time", min: ((start)), max: ((end)) },
    selection: { mode: "xy" }
    }); 
  $('#loading').hide();
};

//--------------------------------------------------------------------------------------
// Fetch Data
//--------------------------------------------------------------------------------------
function vis_feed_data(api_key,feed_id,from,till, placeholder)
{
 $('#loading').show();
 $("#stat").html("Loading...  please wait about 5s");
 $.ajax({                                       //Using JQuery and AJAX
   url: '/api',                         
   data: "api_read_token="+api_key+"&feed_id="+feed_id+"&from="+from+"&till=" + till,
   dataType: 'json',                            //and passes it through as a JSON    
   success: function(data) 
   {

      if (data!=0){
       
        paverage = 0;
        npoints = 0;

        for (var z in data)                     //for all variables
        {
          paverage += parseFloat(data[z][1]);
          npoints++;
        }  
        var timeB  = Number(data[0][0])/1000.0;
        var timeA  = Number(data[data.length-1][0])/1000.0;

        var timeWindow = (timeB-timeA);
        var timeWidth = timeWindow / npoints;

        var kwhWindow = (timeWidth * paverage)/3600000;

        paverage = paverage / npoints;
        $("#stat").html((paverage).toFixed(1)+" W | "+(kwhWindow).toFixed(1)+" kWh");
       
      } else {
        $("#stat").html("No data");
      }
      graph_data = [];   
      graph_data = data;

      plotGraph(start, end, placeholder);
     
    } 
  });
};
