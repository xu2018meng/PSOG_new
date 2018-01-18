<%@ Page Language="C#" AutoEventWireup="true" CodeFile="process_monitor_state.aspx.cs" Inherits="aspx_web_runstate_notiem" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html style=" width:100%; height:100%;" >
 <head>
   <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
 <base target="_self" />
<%
        
        String plantCode = Request.QueryString["plantCode"];
        plantCode = null == plantCode ? "" : plantCode;
        //String modelName = Request.QueryString["modelName"];
        //modelName = null == modelName ? "" : modelName;
        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId;
         %>
  <title></title>

<link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
<link type="text/css" rel="stylesheet" href="../resource/js/skin/WdatePicker.css" />
<script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
<script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
<%--<!–[if lt IE9]> 
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]–>--%>
<script type="text/javascript"  src="../resource/js/html5.js"></script>
<link type="text/css" rel="stylesheet" href="../resource/css/calendar.css" />
<script type="text/javascript"  src="../resource/chartjs/AnyChart.js"></script>
<link href="../resource/jquery/qTip2/jquery.qtip.min.css" rel="stylesheet" />
<script src="../resource/jquery/qTip2/jquery.qtip.min.js"></script>

        <script type="text/javascript">
        var flag=0;
        window.onerror=function(){};
            var chart1 = new AnyChart('../resource/chartSwf/AnyChart.swf', '../resource/chartSwf/Preloader.swf');
           
            chart1.width = "100%";
            chart1.height = "100%";
            //chart1.wMode = "opaque";
            chart1.addEventListener("pointClick", function (e) {
                // e.data.Name 83.0425 e.data.YValue
                var tabName = "报警相关偏离点";
                var id = e.data.Name + "--" + e.data.YValue;
                var url = "aspx/alarm_monitordetail.aspx?plantId=<%=plantCode %>&modelId=<%=modelId %>&name=" + e.data.Name + "&yvalue=" + e.data.YValue;
                 try{
                parent.parent.window.chartAddTab(id, tabName, url); 
                }catch(exp){}
                 try{
		        window.external.ShowExcursionPoint(e.data.Name,e.data.YValue);
		        }catch(exp){}
            });

             function GetValue(obj)
            {
		        var arr = obj.id.split(',');
		        window.external.ShowDetail(arr[0],arr[1],obj.value);

            }
           function test(a,b,c) 
            {
               
                arr = a.split(',');  
                var len = arr.length;
                var table = document.getElementById("tableid");
                var row = table.insertRow(-1);
                var j = 0;
                for(var i = 0; i < len; i++)
                {
                    if(i!=0&&i%9==0)
                    {
                        var cell = row.insertCell(3);
                        //alert("1111");
                        var str = "<input type='button' id='test' value='更多' style='cursor:pointer'  onclick='test2()'/>";
                        cell.innerHTML=str;
                       // alert("22222");
                        break;
                    }
                    if(i%3==0)
                    {
                        if(i==len-1)
                         {
                            break;
                         }
                        row.height="30";
                        var cell = row.insertCell(j);
                        cell.innerHTML = "<input type='button' id='"+arr[i]+","+arr[i+1]+"' value='"+arr[i+2]+"' style='background-color:Crimson;color:white;cursor:pointer;width:114px' onclick='GetValue(this)'/>";
                        j = j+1;
                    }
                }

                $("#beginTime").val(b.split('$')[0]);
                $("#endTime").val(b.split('$')[1]);
                var chart = new AnyChart('resource/chartSwf/AnyChart.swf', 'resource/chartSwf/Preloader.swf');
                chart.width = "90%";
                chart.height = "80%";
                chart.wMode = "opaque";                
                chart.setData(c);         
                chart.write("chartContainer");
            }
            function test2() 
            {  

                var len = arr.length;
                var table = document.getElementById("tableid");
                table.firstChild.removeNode(true)
                var row = table.insertRow(-1);
                var j = 0;
                
                for(var i = 0; i < len; i++)
                {
                    if(i!=0&&i%9==0)
                    {
                        row = table.insertRow(-1);
                        j=0;
                    }
                    if(i%3==0)
                    {
                        if(i==len-1)
                         {
                            break;
                         }
                        row.height="30";
                        var cell = row.insertCell(j);
                        cell.innerHTML = "<input type='button' id='"+arr[i]+","+arr[i+1]+"' value='"+arr[i+2]+"' style='background-color:Crimson;color:white;height:20px;;width:104px;cursor:pointer' onclick='GetValue(this)'/>";
                        j = j+1;
                    }
                }
              
            }
			function DoAdd(a,b)
			{
				var result = a+b;
				return result;
			}
			 
			 
			 function getXMLData(startTime, endTime){
        	    var startTime = $("#beginTime").val();
                var endTime   = $("#endTime").val();
                
                var xmlData = "";
        	    $.ajax({
        	       url: "./process_monitor_state_data.ashx?"+ encodeURI( "plantCode=<%=plantCode %>&startTime=" + startTime + "&endTime=" + endTime) + "&random=" + Math.random(), 
        	       async: false,
        	       success: function(data){
        	        xmlData = data;
        	       }
        	   });
        	   return xmlData;
        	}	
        	
			function showLine2()
			{   
                
                var startTime = $("#beginTime").val();
                var endTime   = $("#endTime").val();
                
                if(startTime > endTime){
                    alert("开始时间不能大于截止时间！");
                    return ;
                }
                flag=1;
//                var url = "./process_monitor_state.aspx?"+ encodeURI( "plantCode=<%=plantCode %>&modelName=<%=modelName %>&startTime=" + beginTime + "&endTime=" + endTime) + "&modelId=<%=modelId %>&random=" + Math.random();              
//                window.location.href = url;
                  $.ajax({
                        url: "./process_monitor_state_data.ashx?" + encodeURI("plantCode=<%=plantCode %>&startTime=" + startTime + "&endTime=" + endTime) + "&modelId=<%=modelId %>&random=" + Math.random(),
                        async: true,
                        success: function (data) {
                            chart1.setData(data.replace(/\\n/g, "\n"));
                            }
                        });
                
			}

			

            //后台写入xml后调用的函数
			function showchart(xmlData)
			{
			    
			  //  $("#chartContainer").show();
                               // alert(xmldom);
			            
			    chart1.wMode = "transparent"; //防止flash覆盖DIV
			    
                chart1.setData(xmlData);   
                        
                chart1.write("chartContainer");
			}
        </script>
        
        <style type="text/css">
        html,body, #chartContainer  {
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
            font-family: 微软雅黑;
            SCROLLBAR-FACE-COLOR: #cecece; 
            SCROLLBAR-HIGHLIGHT-COLOR: white; 
            SCROLLBAR-SHADOW-COLOR: white; 
            SCROLLBAR-3DLIGHT-COLOR: white; 
            SCROLLBAR-ARROW-COLOR: white; 
            SCROLLBAR-TRACK-COLOR: white; 
            SCROLLBAR-DARKSHADOW-COLOR: white; 
            }
	    </style>
	
 </head>
 <body style="overflow:auto; width:97%; height:100%; font-size:12px;">
  <!-- #include file="include_loading.aspx" -->
        <table   border="0" cellpadding="0" cellspacing="0" width="100%" id="TABLE1" language="javascript" >            
            <tr>
                <td colspan="2" style="height: 24px;">
                       <div style="margin-top:6px; margin-left:50px">
                            <label style="color:Green;">
                                查询条件
                            </label>
                            &nbsp;
                            <input type="text" id="beginTime" name="beginTime" value="<%=startTime %>" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
                            &nbsp;&nbsp;—— &nbsp; &nbsp; 
                            <input type="text" id="endTime" name="endTime" value="<%=endTime %>" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" />&nbsp;&nbsp;&nbsp;
                           &nbsp; &nbsp; &nbsp; &nbsp;
                           &nbsp;<img alt="" id="label_qry" onclick="showLine2()" src="../resource/img/btn.gif" style="position:relative; top:6px; width: 70px;  height: 22px;cursor:pointer">&nbsp</img>&nbsp;&nbsp;&nbsp;&nbsp;<img id="tip" title="根据各参数的相互关联关系，通过对其实时数据的拟合，反映了工艺运行的状态。该值越大，工艺运行越平稳。" src="../resource/img/question.png" style="cursor:pointer;"></div>
                </td>
                
            </tr>          
        </table>
        <div style="height:85%;width:100%; padding:5px;">
         
            <div id="chartContainer" style=" z-index:2; height:100%;width:100%" ></div>
        </div>	
        <div id="chart" style="width:auto;height:auto;"> </div>
 </body>
</html>
<script type="text/javascript">
var chartStr = '<%=chartStr %>';

showchart(chartStr);

/* 每五分钟重新加载一次 */
function intervall() {

    window.setInterval("reloadChart()", 60000);
   
}
intervall();
window.onerror = function () { return true; }

function reloadChart() {
if(flag==0)
{
    refreshtime();
    getChartData();
    }
}
Date.prototype.format = function(format){
var o = {
"M+" : this.getMonth()+1, //month
"d+" : this.getDate(), //day
"h+" : this.getHours(), //hour
"m+" : this.getMinutes(), //minute
"s+" : this.getSeconds(), //second
"q+" : Math.floor((this.getMonth()+3)/3), //quarter
"S" : this.getMilliseconds() //millisecond
}

if(/(y+)/.test(format)) {
format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
}

for(var k in o) {
if(new RegExp("("+ k +")").test(format)) {
format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
}
}
return format;
} 
function refreshtime() {
   var yesterday=GetDateStr(-1);
   $("#beginTime").val(yesterday);
   var myDate = new Date().format("yyyy-MM-dd hh:mm:ss"); 
   $("#endTime").val(myDate);
}
function GetDateStr(AddDayCount) {
    var dd = new Date();
    dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期
//    var y = dd.getFullYear();
//    var m = dd.getMonth()+1;//获取当前月份的日期
//    if(m<10)
//    {m="0"+m}
//    var d = dd.getDate();
//    if(d<10)
//    {d="0"+d}
//    var time =new Date().toLocaleTimeString();
//    return y+"-"+m+"-"+d+" "+time;
var time=dd.format("yyyy-MM-dd hh:mm:ss");
return time;
}
function getChartData() {
    var startTime = $("#beginTime").val();
    var endTime = $("#endTime").val();
    
    $.ajax({
        url: "./process_monitor_state_data.ashx?" + encodeURI("plantCode=<%=plantCode %>&startTime=" + startTime + "&endTime=" + endTime) + "&modelId=<%=modelId %>&random=" + Math.random(),
        async: true,
        success: function (data) {
            chart1.setData(data.replace(/\\n/g, "\n"));
        }
    });
}

//后台写入xml后调用的函数
function showchartLine() {
    var dataXml = getChartData();
}

$("#tip").qtip({
    content: {
        text: "<b>工艺运行状态指数：</b>根据各参数的相互关联关系，通过对其实时数据的拟合，反映了工艺运行的状态。该值越大，工艺运行越平稳。<br><b>计算方式：</b>选取工段的关键操作参数，以其平稳运行状态下的历史数据为样本，进行多维状态空间分析，找到各参数内在的关联关系，建立具有在线自动更新能力的运行状态监测模型。在线监测时，将各参数的实时数据代入到监测模型中，拟合得到工段的工艺运行状态指数。<br><b>变色规则：</b>绿色--正常、黄色--预警、红色--异常。"
      , title: "提示信息"
    },
    style: {
        classes: 'qtip-light'
    }
});

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