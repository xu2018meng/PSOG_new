<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_monitor_chart.aspx.cs" Inherits="aspx_alarm_monitor_chart" %>

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
            String tagId = Request.QueryString["tagId"];
            tagId = null == tagId ? "" : tagId;
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
	        function getXMLData() {
	            var startTime = $("#beginTime").val();
	            var endTime = $("#endTime").val();

	            if (startTime > endTime) {
	                alert("开始时间不能大于截止时间！");
	                return;
	            }

	            var xmlData = "";
	            $.ajax({
	                url: "alarm_monitor_chart_data.ashx?plantId=<%=plantId %>&tagId=<%=tagId%>&tableName=<%=tableName %>&startTime=" + startTime + "&endTime=" + endTime,
	                async: false,
	                success: function (data) {
	                    xmlData = data;
	                }
	            });
	            return xmlData;
	        }
	        function showLine() {
	            var startTime = $("#beginTime").val();
	            var endTime = $("#endTime").val();

	            if (startTime > endTime) {
	                alert("开始时间不能大于截止时间！");
	                return;
	            }
	            /* 网页版调用 */
	            try {
	                var url = "./alarm_monitor_chart.aspx?" + encodeURI("plantId=<%=plantId %>&tagId=<%=tagId%>&tableName=<%=tableName %>&startTime=" + startTime + "&endTime=" + endTime) + "&random=" + Math.random();
	                document.forms[0].action = url;
	                document.forms[0].submit();
	                //window.location.href = url;
	            } catch (exp) { }

	            /* 预留给客户端调用 */
	            try {
	                window.external.ShowTime(beginTime, endTime); //调用后台写入xml
	            } catch (exp) { };
	        }

	        //后台写入xml后调用的函数
	        function showchart(xmlData) {
	            var chart = new AnyChart('../resource/chartSwf/AnyChart.swf', '../resource/chartSwf/Preloader.swf');
	            chart.width = "100%";
	            chart.height = "100%";
	            //chart.wMode = "opaque";

	            if ("false" == xmlData) {
	                alert("采集到的数据量超过5000条，加载时间过长已终止，建议缩小时间范围");
	                chart.setXMLData("../resource/chartXml/alarmChart.xml");
	            } else {
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
                <img onclick="showLine()" src="../resource/img/btn.gif" style="cursor:pointer; background-position: left bottom;  width: 70px;  height: 22px;"/></div>
         </div>
        <div style="height:540px;width:98%; padding:5px;">
            <div id="chartContainer" style=" z-index:2;border:1px solid; border-color: rgb(9,145,208); height:100%;width:100%" ></div>
        </div>	
    </form>
 </body>
</html>
<script>
    var chartStr = '<%=chartStr %>';
    try {
        
        showchart(chartStr);
    }
    catch (exp) {
    }
</script>