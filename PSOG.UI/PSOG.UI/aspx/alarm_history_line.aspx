<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_history_line.aspx.cs" Inherits="aspx_Alarm_history_line" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
 <head>
    <base target="_self" />
  <title>历史数据查询</title>
        <%
            String plantId = Request.QueryString["plantId"];
            plantId = null == plantId ? "" : plantId;
            String tableName = Request.QueryString["tableName"];
            tableName = null == tableName ? "" : tableName;
            
            string ruleUpline = Request.QueryString["upLine"];
            ruleUpline = null == ruleUpline ? "" : ruleUpline;
            string ruleDownline = Request.QueryString["downLine"];
            ruleDownline = null == ruleDownline ? "" : ruleDownline;
             %>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <link type="text/css" rel="stylesheet" href="../resource/js/skin/WdatePicker.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"></script>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
        <script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
        <link type="text/css" rel="stylesheet" href="../resource/css/calendar.css" />
        <script type="text/javascript"  src="../resource/chartjs/AnyChart.js"></script>
	    <script type="text/javascript">
        	function getXMLData(){
        	    var startTime = $("#beginTime").val();
                var endTime   = $("#endTime").val();
                
                if(startTime > endTime){
                    alert("开始时间不能大于截止时间！");
                    return ;
                }
                
                var xmlData = "";
        	    $.ajax({
        	       url: "alarm_history_line_data.ashx?plantId=<%=plantId %>&tableName=<%=tableName %>&startTime=" + startTime + "&endTime=" + endTime, 
        	       async: false,
        	       success: function(data){
        	        xmlData = data;
        	       }
        	   });
        	   return xmlData;
        	}		
			function showLine()
			{   
			    var startTime = $("#beginTime").val();
                var endTime   = $("#endTime").val();
                
                if(startTime > endTime){
                    alert("开始时间不能大于截止时间！");
                    return ;
                }
			    /* 网页版调用 */
			    try{
                    var url = "./alarm_history_line.aspx?"+ encodeURI( "plantId=<%=plantId %>&tableName=<%=tableName %>&startTime=" + startTime + "&endTime=" + endTime+"&upLine=<%=ruleUpline %>&downLine=<%=ruleDownline %>") + "&random=" + Math.random();              
                    document.forms[0].action = url;
                    document.forms[0].submit();
                    //window.location.href = url;
                }catch(exp){}
                
                /* 预留给客户端调用 */
                try{
                    window.external.ShowTime(beginTime,endTime);//调用后台写入xml
                }catch(exp){};
		    }
		    
			//后台写入xml后调用的函数
			function showchart(xmlData)
			{
                var chart = new AnyChart('../resource/chartSwf/AnyChart.swf', '../resource/chartSwf/Preloader.swf');
                chart.width = "100%";
                chart.height = "100%";
               // chart.wMode = "opaque";                
                
                if("false" == xmlData){
                    alert("采集到的数据量超过5000条，加载时间过长已终止，建议缩小时间范围");
                    chart.setXMLData("../resource/chartXml/alarmChart.xml"); 
                }else{
                    chart.setData(xmlData);    
                }
                   
                chart.write("chartContainer");
			}
			
                //初始化列表样式
	        function initTableStyle() {
		        $(".scTable tr:odd").css("background", "#eef9ff");
		        $(".scTable tr:odd input").css("background", "#eef9ff");
		        $(".scTable tr:even").css("background", "#ffffff");
		        $(".scTable tr:even input").css("background", "#ffffff");
	        }
        </script>
       
         <style type="text/css">
		    html, body{
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
		    }
            .scTable {
            border:1px #bebfbf solid;
            }
	        .scTable th {
		        background: #cfe3dc;
		        padding:6px;
		        border:1px #bfcfda solid;
		        font-weight: normal;
	        }
	        .scTable td {
				        border:1px #bfcfda solid;
		        text-align: center;
	        }
	        .scTable td a {
		        text-decoration: underline;
		        cursor: pointer;
	        }
	         #tabContainer
                {
                    margin: 5px;
                }
                #tabContainer li
                {
                    float: left;
                    width: 80px;
                    margin: 0 0px;
                   
                    text-align: center;
                }
            body{
               overflow:auto;
               
                SCROLLBAR-FACE-COLOR: #cecece; 
                SCROLLBAR-HIGHLIGHT-COLOR: white; 
                SCROLLBAR-SHADOW-COLOR: white; 
                SCROLLBAR-3DLIGHT-COLOR: white; 
                SCROLLBAR-ARROW-COLOR: white; 
                SCROLLBAR-TRACK-COLOR: white; 
                SCROLLBAR-DARKSHADOW-COLOR: white; 
                font-size:12px;
                font-family: 微软雅黑;
            }
	    </style>
 </head>
 <body >   
    <form action="" method="post">
        <div style="padding:5 5 5 5;margin:0 5 5  0">
           <div style="padding-left:15px;">
                <label style="color:Green;font-size:13px">
                    查询条件
                </label>
                &nbsp;
                <input type="text" id="beginTime" name="beginTime" value="<%=startTime %>"  size="25" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
                &nbsp;——&nbsp;
                <input type="text" id="endTime" name="endTime" value="<%=endTime %>"  size="25" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" />&nbsp;&nbsp;&nbsp;
               &nbsp;
                <img alt="" id="img_qry" src="../resource/img/btn.gif" onclick="showLine()" style="position:relative; top:6px; background-repeat: no-repeat;cursor:pointer; background-position: left bottom;  width: 70px;  height: 22px;"></img></div>
         </div>
        <div id="div_chart" style="height:550px;width:98%;text-align:center; padding-left:5px;padding-right:5px;margin-left:auto; margin-right:auto;">
            <div id="chartContainer" style=" z-index:2;border:1px solid; border-color: rgb(9,145,208); height:100%;width:100%" ></div>
        </div>	
    </form>
 </body>
</html>
<script type="text/javascript">
var chartStr = '<%=chartStr %>';
try{
    showchart(chartStr);
}
catch(exp){
}

if(1 == getBrowserType()){
    $("#div_chart").css("padding-left","14px");
    $("#div_chart").css("padding-right","0px");
}

function getBrowserType() {
    
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/msie ([\d.]+)/))return 1;

    if(ua.match(/firefox\/([\d.]+)/))return 2;

    if(ua.match(/chrome\/([\d.]+)/))return 3;

    if(ua.match(/opera.([\d.]+)/))return 4;

    if(ua.match(/version\/([\d.]+).*safari/))return 5;

    return 0;
}

function flashChecker() {
    var hasFlash = 0; //是否安装了flash
    var flashVersion = 0; //flash版本
    if (document.all) {
      var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
      if (swf) {
        hasFlash = 1;
      }
    } else {
      if (navigator.plugins && navigator.plugins.length > 0) {
        var swf = navigator.plugins["Shockwave Flash"];
        if (swf) {
          hasFlash = 1;
        }
      }
    }
    return hasFlash;
}

var fls = flashChecker();
if (0 == fls) alert("本页面需要Flash插件，请安装后查看！"); 

</script>