<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main_page_new2.aspx.cs" Inherits="aspx_main_page_new2" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html >
 <head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
  <title>主页</title>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"/>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
         <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
         <script type="text/javascript" src="../resource/js/highcharts.js"></script>
        <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
        <script type="text/javascript">
                    
        </script>
        
        <style type="text/css">
		    html, body {
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
			    font-family:微软雅黑;
			    text-align:center;
		    }
		    
           
          .unit{
             font-size:16px;
             font-weight:bold;
            }
            
          .td_device{
            text-align:center;
            font-size:11px;
          }

	    </style>
 </head>
 <body style="background-color:#eef6fe;">
           
       <div style="overflow:auto; margin-right:auto;font-family:宋体; ">
          <div style=""><h1>工&nbsp;艺&nbsp;设&nbsp;备&nbsp;状&nbsp;态&nbsp;监&nbsp;测</h1></div>
          <div style="padding-left:27%;"><h2>---以DCS控制限为基础，实时监测装置运行状态</h2></div>     
       </div>
       
       <div id="contentDiv" style="overflow:auto;padding-top:12px;font-family:微软雅黑; width:980px;padding-left:11.8%">
       
       </div>  
 </body>
</html>
<script type="text/javascript">
var deviceJson = '<%=deviceJson %>'
if(deviceJson!=null && deviceJson.length>0){
      showData(deviceJson);
}

function showData(eJson){
   var dict = eval('('+eJson+')');
   for(var key in dict){
      var unitInfo = key.split("@");
      var deviceInfo = dict[""+key]; 
      var rows = deviceInfo.length/4+1;
      var runIndex0 = 0;
      var alarmIndex0 = 0;
      var earlyAlarmIndex0 = 0;
      if(deviceInfo[0].runIndex!=null && deviceInfo[0].runIndex.length>0){
          runIndex0 = deviceInfo[0].runIndex;
      }
      if(deviceInfo[0].alarmIndex!=null && deviceInfo[0].alarmIndex.length>0){
          alarmIndex0 = deviceInfo[0].alarmIndex;
      }
      if(deviceInfo[0].earlyAlarmIndex!=null && deviceInfo[0].earlyAlarmIndex.length>0){
          earlyAlarmIndex0 = deviceInfo[0].earlyAlarmIndex;
      }
      
      var html= '<table border="0" cellpadding="0" cellspacing="0" style="width:100%;text-align:center;margin-left:auto ; margin-right:auto; border-collapse:collapse; border-spacing:0px 0px;border:1px;" >'
             + '<tr><td style="text-align:center; width:1px;border:solid #268BBA; border-width:1px 1px 1px 1px;  padding:10px 5px 10px 5px;background-color:#268BBA;color:#ffffff;" class="unit" rowspan="'+rows+'">'+unitInfo[1]+'</td>'
             +'<td style="height:60px;padding-left:10px">'
             +'   <table style="width:220px;height:100%;border:solid #268BBA;border-width:1px 1px 1px 1px;" cellpadding="0" cellspacing="0">'
             +'       <tr style="height:25px;">   '
             +'         <td class="td_device" style="border:solid #268BBA; background-color:#268BBA; border-width:0px 0px 1px 0px;color:#ffffff;cursor:pointer;" colspan="3" onclick="turnToDetailPage(this.id)" id="'+deviceInfo[0].deviceId+'">'+deviceInfo[0].deviceName+'</td>'
             +'       </tr>'
             +'       <tr style="height:28px;">'
             +'          <td style="width:15%"></td>'
             +'          <td style="text-align:left;width:50%">运行状态指数：</td>'
             +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="#" onclick="turnToRunIndexPage(\''+deviceInfo[0].deviceId+'\')">'+runIndex0+'</a></td>'
             +'       </tr>'
             +'        <tr style="height:28px;">'
             +'          <td style="width:15%"></td>'
             +'          <td style="text-align:left;width:50%">报警点个数：</td>'
             +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="./device_alarm_parameter.aspx?plantId=<%=plantId %>&deviceId='+deviceInfo[0].deviceId+'&alarmFlag=alarm">'+alarmIndex0+'</a></td>'
             +'       </tr>'
             +'        <tr style="height:28px;">'
             +'          <td style="width:15%"></td>'
             +'          <td style="text-align:left;width:50%">预警点个数：</td>'
             +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="./device_alarm_parameter.aspx?plantId=<%=plantId %>&deviceId='+deviceInfo[0].deviceId+'&alarmFlag=earlyAlarm">'+earlyAlarmIndex0+'</a></td>'
             +'       </tr>'
             +'   </table>'
             +'</td>';
      
      var brMark = "0"; 
      var num = 1;                 
      for(var i=1;i<deviceInfo.length;i++){
          var runIndex = 0;
          var alarmIndex = 0;
          var earlyAlarmIndex = 0;
          if(deviceInfo[i].runIndex!=null && deviceInfo[i].runIndex.length>0){
              runIndex = deviceInfo[i].runIndex;
          }
          if(deviceInfo[i].alarmIndex!=null && deviceInfo[i].alarmIndex.length>0){
              alarmIndex = deviceInfo[i].alarmIndex;
          }
          if(deviceInfo[i].earlyAlarmIndex!=null && deviceInfo[i].earlyAlarmIndex.length>0){
              earlyAlarmIndex = deviceInfo[i].earlyAlarmIndex;
          }
      
          var innerHtml = '   <table style="width:220px;height:100%;border:solid #268BBA;border-width:1px 1px 1px 1px;" cellpadding="0" cellspacing="0">'
                     +'       <tr style="height:25px;">   '
                     +'         <td class="td_device" style="border:solid #268BBA; background-color:#268BBA; border-width:0px 0px 1px 0px;color:#ffffff;cursor:pointer;" colspan="3" onclick="turnToDetailPage(this.id)" id="'+deviceInfo[i].deviceId+'">'+deviceInfo[i].deviceName+'</td>'
                     +'       </tr>'
                     +'       <tr style="height:28px;">'
                     +'          <td style="width:15%"></td>'
                     +'          <td style="text-align:left;width:50%">运行状态指数：</td>'
                     +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="#" onclick="turnToRunIndexPage(\''+deviceInfo[i].deviceId+'\')">'+runIndex+'</a></td>'
                     +'       </tr>'
                     +'        <tr style="height:28px;">'
                     +'          <td style="width:15%"></td>'
                     +'          <td style="text-align:left;width:50%">报警点个数：</td>'
                     +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="./device_alarm_parameter.aspx?plantId=<%=plantId %>&deviceId='+deviceInfo[i].deviceId+'&alarmFlag=alarm">'+alarmIndex+'</a></td>'
                     +'       </tr>'
                     +'        <tr style="height:28px;">'
                     +'          <td style="width:15%"></td>'
                     +'          <td style="text-align:left;width:50%">预警点个数：</td>'
                     +'          <td style="text-align:left;width:35%"><a style="font-weight:normal;" href="./device_alarm_parameter.aspx?plantId=<%=plantId %>&deviceId='+deviceInfo[i].deviceId+'&alarmFlag=earlyAlarm">'+earlyAlarmIndex+'</a></td>'
                     +'       </tr>'
                     +'   </table>'
                     +'</td>';
           if(brMark == "1"){
               html += '</tr> <tr><td style="height:60px;padding-left:10px;padding-top:5px;">'+innerHtml;
               brMark = "0";
               num = 1;
           }else{
               num++;
               if(i>4){
                 html += '<td style="height:60px;padding-top:5px;">'+innerHtml;
               }else{
                 html += '<td style="height:60px;">'+innerHtml;
               }
               
               if((i+1)%4==0){
                  brMark = "1";
               }
           }
      }
      for(var j=0;j<4-num;j++){
        html += '<td style="height:60px;padding-left:10px;padding-top:5px;width:220px;"></td>';
      }
      html += "</tr></table><br /> ";
      $("#contentDiv").append(html);  
   }
}

//点击设备号，跳转至设备详情页面
function turnToDetailPage(id){
   window.parent.document.getElementById("main-region").src = "aspx/main_page_new2_detail.aspx?plantId=<%=plantId %>&deviceId="+id;
}

//跳转至运行监测页面(图3-2)
function turnToRunIndexPage(id){
    $.ajax({
            url : './mainpage2_data_deal.ashx',
            data : {
              plantId:'<%=plantId %>',
              deviceId:id
            },
            async:false,
            type:"post",
            success : function(result) {
             var runIndexId = eval("("+result+")");
             window.location.href="./Web_RunState_Device_Monitoring.aspx?modelId="+runIndexId+"&plantCode=<%=plantId %>&deviceId="+id;
            }
        });
}

</script>