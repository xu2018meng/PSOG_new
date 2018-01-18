<%@ Page Language="C#" AutoEventWireup="true" CodeFile="graphic_monitor.aspx.cs" Inherits="graphic_monitor" %>

<html>
<head id="Head1">
    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <title></title>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        html, body{            
         width:100%;
         height:100%;
         padding:0px;
         margin:0px;
        }
        
        td{
         border:1px solid #00F
        }
        
        .tdImg{
           width:185px;
           height:280px;
        }
        
        .td_lable
        {
            text-align: center;
            width: 80px;
            height: 30px;
        }
        #infoDiv td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:6px 6px 6px 6px;height:28px;}
        #infoDiv table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
    </style>
</head>
<body>
  <table style="padding-top:10%;padding-left:2px;">
     <tr id="imgtr">
     
     </tr>
  </table>

   <!--监控点 -->
    <div id="pointDiv" class="easyui-dialog" title="图形监控" style="width:1200px;height:560px;overflow:hidden;" closed="true" modal="true" 
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true">
        <svg version="1.1" id="svg1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                width="100%" height="100%"  enable-background="new 0 0 100% 100%" xml:space="preserve"
                style="background-size: 100% 100%;" ondrag="return false;">
                  <defs>
                    <pattern id="greenDialog" width="100%" height="100%" patternContentUnits="objectBoundingBox">
                        <image width="1" height="1" xlink:href="../resource/img/绿位号.png" />
                    </pattern>
                    
                     <pattern id="redDialog" width="100%" height="100%" patternContentUnits="objectBoundingBox">
                        <image width="1" height="1" xlink:href="../resource/img/红位号.png" />
                    </pattern>
                </defs>
            </svg>
    </div>
    
    
      <div id="infoDiv" class="easyui-dialog" title="监测信息" style="width:600px;height:400px;" closed="true" modal="true"
            data-options=" iconCls: 'icon-add',
                resizable:true">
             <table cellpadding="1" cellspacing="0" style=" text-align:center; vertical-align:middle;margin-left:25px;margin-top:7%; width:90%; ">
                    <tr>
                        <td class="td_lable">
                           <label>位&nbsp;&nbsp;号</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="tagName"></label>
                        </td> 
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>描&nbsp;&nbsp;述</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="tagDesc"></label>
                        </td> 
                    </tr>
                     <tr>
                        <td class="td_lable">
                           <label>实时值</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="realValue"></label>
                        </td> 
                    </tr>
                     <tr>
                        <td class="td_lable">
                           <label>报警类型</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="alarmType"></label>
                        </td> 
                    </tr>
                     <tr>
                        <td class="td_lable">
                           <label>报警开始时间</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="alarmStartTime"></label>
                        </td> 
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>持续时长</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="alarmInterval"></label>
                        </td> 
                    </tr>
          </table>
    </div>

</body>    
</html>


<script type="text/javascript"> 
   
    var plantId = '<%=plantId %>';
    var pointJson = '<%=pointJson %>';
    var pointDict = eval('('+pointJson+')');//监测点
       
    var picJson = '<%=picJson %>';
    var picList = eval('('+picJson+')');//图
   $(function(){
       initMonitor();
   });
   
   function initMonitor(){
        for(var i=0;i<picList.length;i++){
          var html = '<td> <svg version="1.1"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"'
                   +' id="'+picList[i].picId+'" class="tdImg"  enable-background="new 0 0 100% 100%" xml:space="preserve"'
                   + 'style="background-size: 100% 100%;background-image:url(..' + picList[i].picPath + ')" onclick="onSvgClick(evt)" ondrag="return false;">'
                   + '<defs><pattern id="elecgreen" width="100%" height="100%" patternContentUnits="objectBoundingBox">'
                   + '<image width="1" height="1" xlink:href="../resource/img/红位号.png" /></pattern></defs>'
                   + '</svg></td>';
          $("#imgtr").append(html);
          //加载报警点
          if(pointDict!=null && pointDict[""+picList[i].picId]!=null){
              var alarmList = pointDict[""+picList[i].picId].alarm;
              if(alarmList!=null){
                  for(var j=0;j<alarmList.length;j++){
                    var d = document.createElementNS("http://www.w3.org/2000/svg", "rect");      
                    d.setAttribute("id", alarmList[j].pointId+"out");
                    d.setAttribute("name", alarmList[j].pointId);
                    d.setAttribute("x", alarmList[j].pointX + '%');
                    d.setAttribute("y", alarmList[j].pointY + '%');
                    d.setAttribute("width", "12");
                    d.setAttribute("height", "10");
                   // d.ondblclick = function (evt) { EditLocation(evt); };
                    d.setAttribute("fill", "url(#elecgreen)");
                    $("#"+picList[i].picId).append(d);
                    
                  }
              }
          }
       }
   }
   
   
   //点击缩略图
   function onSvgClick(evt){
       var picId = evt.currentTarget.id;
       var picSvg = $("#"+picId);
       //设置背景
       var imgUrl = picSvg[0].style["background-image"];
       document.getElementById("svg1").setAttribute("style", 'background-image:' + imgUrl + ';background-size:100% 100%;');
       //设置监测点
      if(pointDict!=null && pointDict[""+picId]!=null){
         //报警点
          var alarmList = pointDict[""+picId].alarm;
          if(alarmList!=null){
              for(var i=0;i<alarmList.length;i++){
                var d = document.createElementNS("http://www.w3.org/2000/svg", "rect");      
                d.setAttribute("id", alarmList[i].pointId);
                var pointName = alarmList[i].bitDes+"#"+alarmList[i].alarmValue+"#"+alarmList[i].alarmState+"#"+alarmList[i].alarmStartTime
                              + "#"+alarmList[i].alarmInterval;
                d.setAttribute("name",pointName );
                d.setAttribute("x", alarmList[i].pointX + '%');
                d.setAttribute("y", alarmList[i].pointY + '%');
                d.setAttribute("width", "22");
                d.setAttribute("height", "20");
                d.setAttribute("fill", "url(#redDialog)");
                d.onclick = function (evt) { ViewPointInfo(evt,'alarm'); };
                $("#svg1").append(d);
                
                var bit = document.createElementNS("http://www.w3.org/2000/svg", "text");
                bit.setAttribute("id", alarmList[i].pointId + "1");
                bit.setAttribute("name", pointName);
                bit.setAttribute("x", (parseFloat(alarmList[i].pointX)-1) + '%');
                bit.setAttribute("y", (parseFloat(alarmList[i].pointY)+6) + '%');
                bit.setAttribute("style","fill:blue");
                bit.textContent = alarmList[i].bitNo;
                $("#svg1").append(bit);
              }
          }
          //正常点
          var normalList = pointDict[""+picId].normal;
          if(normalList!=null){
              for(var i=0;i<normalList.length;i++){
                var d = document.createElementNS("http://www.w3.org/2000/svg", "rect");      
                d.setAttribute("id", normalList[i].pointId);
                 var pointName = normalList[i].bitDes+"#"+normalList[i].alarmValue+"#"+normalList[i].alarmState+"#"+normalList[i].alarmStartTime
                              + "#"+normalList[i].alarmInterval;
                d.setAttribute("name", pointName);
                d.setAttribute("x", normalList[i].pointX + '%');
                d.setAttribute("y", normalList[i].pointY + '%');
                d.setAttribute("width", "22");
                d.setAttribute("height", "20");
                d.setAttribute("fill", "url(#greenDialog)");
                d.onclick = function (evt) { ViewPointInfo(evt,'normal'); };
                $("#svg1").append(d);
                
                var bit = document.createElementNS("http://www.w3.org/2000/svg", "text");
                bit.setAttribute("id", normalList[i].pointId + "1");
                bit.setAttribute("name", pointName);
                bit.setAttribute("x", (parseFloat(normalList[i].pointX)-1) + '%');
                bit.setAttribute("y", (parseFloat(normalList[i].pointY)+6) + '%');
                bit.setAttribute("style","fill:blue");
                bit.textContent = normalList[i].bitNo;
                $("#svg1").append(bit);
                
              }
          }
      }

       var bodyWidth = document.body.clientWidth-100;  
       var bodyHeight = document.body.clientHeight-20;
       $('#pointDiv').dialog({
               height:bodyHeight,
               width:bodyWidth,
               onClose:function(){
//                  var html = '<defs><pattern id="greenDialog" width="100%" height="100%" patternContentUnits="objectBoundingBox">'
//                           + '<image width="1" height="1" xlink:href="../../resource/img/绿位号.png" /> </pattern></defs>'
//                           + '<defs><pattern id="redDialog" width="100%" height="100%" patternContentUnits="objectBoundingBox">'
//                           + '<image width="1" height="1" xlink:href="../../resource/img/红位号.png" /> </pattern></defs>';    
//                  document.getElementById("svg1").innerHTML = "";
//                  $("#svg1").append(html); 
                   if(alarmList!=null){
                       for(var i=0;i<alarmList.length;i++){
                           var point = document.getElementById(alarmList[i].pointId);
                           var pointText = $("#" + alarmList[i].pointId+"1")[0]; 
                           point.parentNode.removeChild(point);
                           pointText.parentNode.removeChild(pointText);
                      }
                   }
                   if(normalList!=null){
                       for(var i=0;i<normalList.length;i++){
                           document.getElementById("svg1").removeChild(document.getElementById(normalList[i].pointId));
                           document.getElementById("svg1").removeChild(document.getElementById(normalList[i].pointId+"1"));
                      }
                   }

               }
          }).dialog('open').dialog('setTitle', '图形监控');
   }
   
   //查看监测信息
   function ViewPointInfo(evt,flag){
      var pointId = evt.currentTarget.id;
      var info = $("#"+pointId+"1")[0].attributes.name.nodeValue;
      var infoArr = info.split('#');
     
      
      $("#tagName")[0].innerText = $("#"+pointId+"1")[0].textContent;
      
      $("#tagDesc")[0].innerText = infoArr[0];
      $("#realValue")[0].innerText = infoArr[1];
      $("#alarmType")[0].innerText = infoArr[2];
      $("#alarmStartTime")[0].innerText = infoArr[3];
      $("#alarmInterval")[0].innerText = infoArr[4];
      
      
      $('#infoDiv').dialog({
               onClose:function(){
                      $("#tagDesc")[0].innerText = "";
                      $("#realValue")[0].innerText = "";
                      $("#alarmType")[0].innerText = "";
                      $("#alarmStartTime")[0].innerText = "";
                      $("#alarmInterval")[0].innerText = "";
               }
        }).dialog('open').dialog('setTitle', '监测信息');
      
   }
   
   //加载监测点
   function loadMonitorPoint(){
        //加载监控点
       $.ajax({
        url : './graphic_monitor_data.ashx',
        data : {
                  plantId:plantId
                },
        async:false,
        type:"post",
        success: function (result) {   
            pointDict = eval('('+result+')');
            $("#imgtr")[0].innerHTML = "";
            initMonitor();
        },
        error: function () {
            $.messager.show({
                title: 'Info',
                msg: "获取失败"
            });
        }
    });
   }
   
   setInterval("loadMonitorPoint()",300000);
</script>

