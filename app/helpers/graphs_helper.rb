module GraphsHelper

  def draw_graph_raw_data(api_key, feed_id)
    "
      //----------------------------------------------------------------------------------------
      // These start time and end time set the initial graph view window 
      //----------------------------------------------------------------------------------------
      var timeWindow = (3600000*24.0);				//Initial time window
      var start = ((new Date()).getTime())-timeWindow;		//Get start time
      var end = (new Date()).getTime();				//Get end time

      var paverage;
      var npoints;

      $(function () {
        
        var placeholder = $('#graph');

        //----------------------------------------------------------------------------------------------
        // Operate buttons
        //----------------------------------------------------------------------------------------------

        $('#zoomout').click(function () 
        { 
         var time_window = end - start;
         var middle = start + time_window / 2;
         time_window = time_window * 2;                 // SCALE
         start = middle - (time_window/2);
         end = middle + (time_window/2);
         console.log('zoomout!!!!')
         vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);           //Get new data and plot graph
        });

        $('#zoomin').click(function () 
        {
         var time_window = end - start;
         var middle = start + time_window / 2;
         time_window = time_window * 0.5;                   // SCALE
         start = middle - (time_window/2);
         end = middle + (time_window/2);

        vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);           //Get new data and plot graph
        });

        $('#right').click(function () 
        {    
         var laststart = start; var lastend = end;
         var timeWindow = (end-start);
         var shiftsize = timeWindow * 0.2;
         start += shiftsize;
         end += shiftsize;
         
         vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);
        });

        $('#left').click(function ()
        {    
         var laststart = start; var lastend = end;
         var timeWindow = (end-start);
         var shiftsize = timeWindow * 0.2;
         start -= shiftsize;
         end -= shiftsize;
         
        vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);
        });

        $('.time').click(function () 
        {
         var time = $(this).attr('time');                   //Get timewindow from button
         start = ((new Date()).getTime())-(3600000*24*time);            //Get start time
         end = (new Date()).getTime();                  //Get end time
         
         vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);            //Get new data and plot graph
        });


        //----------------------------------------------------------------------------------------
        // Get window width and height from page size
        //----------------------------------------------------------------------------------------
        $('#graph').width($('#graph_bound').width());
        $('#graph').height($('#graph_bound').height());
        //----------------------------------------------------------------------------------------

        var graph_data = [];                              //data array declaration

        vis_feed_data('#{api_key}',#{feed_id},start,end, placeholder);
      });
    "
  end

end
