 /*
   All emon_widgets code is released under the GNU General Public License v3.
   See COPYRIGHT.txt and LICENSE.txt.

    ---------------------------------------------------------------------
    Part of the OpenEnergyMonitor project:
    http://openenergymonitor.org

    Author: Trystan Lea: trystan.lea@googlemail.com
    If you have any questions please get in touch, try the forums here:
    http://openenergymonitor.org/emon/forum
    */

  function draw_gauge(ctx,x,y,size,position,maxvalue,units)
  {
    if (position<0) position = 0;
    if (position>maxvalue) position = maxvalue;
    var a = 1.75 - ((position/maxvalue) * 1.5);

  ctx.clearRect(0,0,500,400);
  var c=3*0.785;
  var width = 0.785; 
  var pos = 0; 
  var inner = size * 0.48;

  ctx.fillStyle = "#046b34";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  pos += width;
  ctx.fillStyle = "#378d42";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  pos += width;
  ctx.fillStyle = "#87c03f";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  pos += width;
  ctx.fillStyle = "#f8a01b";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  pos += width;
  ctx.fillStyle = "#f46722";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  pos += width;
  ctx.fillStyle = "#bf2025";
  ctx.beginPath();
  ctx.arc(x,y,size,c+pos,c+pos+width,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.fill();

  ctx.lineWidth = (size*0.058).toFixed(0);
  pos += width;
  ctx.strokeStyle = "#fff";
  ctx.beginPath();
  ctx.arc(x,y,size,c,c+pos,false);
  ctx.lineTo(x,y); 
  ctx.closePath();
  ctx.stroke();

  /* SHADOW
  ctx.fillStyle = "rgba(0,0,0,0.2)";
  ctx.beginPath();
  ctx.arc(x,y,inner+(size*0.043),0,Math.PI*2,true);
  ctx.closePath();
  ctx.fill();*/

  ctx.fillStyle = "#666867";
  ctx.beginPath();
  ctx.arc(x,y,inner,0,Math.PI*2,true);
  ctx.closePath();
  ctx.fill();

  ctx.lineWidth = (size*0.052).toFixed(0);
  //---------------------------------------------------------------
  ctx.beginPath();
  ctx.moveTo(x+Math.sin(Math.PI*a-0.2)*inner,y+Math.cos(Math.PI*a-0.2)*inner); 
  ctx.lineTo(x+Math.sin(Math.PI*a)*size,y+Math.cos(Math.PI*a)*size); 
  ctx.lineTo(x+Math.sin(Math.PI*a+0.2)*inner,y+Math.cos(Math.PI*a+0.2)*inner); 
  ctx.arc(x,y,inner,1-(Math.PI*a-0.2),1-(Math.PI*a+5.4),true);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();
  
  //---------------------------------------------------------------

  ctx.fillStyle = "#fff";
  ctx.textAlign    = "center";
  ctx.font = "bold "+(size*0.32)+"px arial";
  ctx.fillText(position.toFixed(0)+units,x,y+(size*0.125));

  }
