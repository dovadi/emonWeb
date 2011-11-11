module WidgetsHelper

  def dial_javascript(id)
    "$(document).ready(function () {
    function update()
    {
      an += 0.01;
      value2 = curveValue(value2,parseFloat(value),0.02);
      draw_gauge(ctx, 320/2,200,120,value2,1000,'W');
    };

    function getvalue(id)
    {
      $.ajax({
        url: '/feeds/' + #{id},
        dataType: 'json',
        success: function(data) 
        {
          value = data['last_value'];
        }
      });
    };

    function curveValue(start,end,rate)
    {
      return start + ((end-start)*rate);
    };

    var ctx = $('#canvas')[0].getContext('2d'); ctx.clearRect(0,0,360,400);

    var position = 0; var an = 0; var value = 0; var value2 = 0; var max_value = 500;

    setInterval(update,20);
    setInterval(getvalue,5000);
    getvalue();

    });"
  end
end
