<%@ Page Language="C#" EnableViewState="false" EnableViewStateMac="false" ValidateRequest="false" EnableEventValidation="false" AutoEventWireup="true" CodeFile="alarm_comprehensive_analysis.aspx.cs" Inherits="aspx_comprehensive_analysis" %>

<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
         %>
    <title>综合分析</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <script type="text/javascript"  src="../resource/chartjs/AnyChart.js"></script>
    <style type="text/css">
        #qryDiv {padding-top:5px;}        
        body{
           overflow:auto;
           width:100%;
           font-size:12px;
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
<body  >    
<iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
    <form id="comp_form" name="comp_form" action="" method="get" >
    
    <div style="padding-bottom: 5px;overflow-y:hidden; height:575px;width:100%;" id="qryDiv"  border="false">
            
        <table class="tblSearch" style="text-align:left">
            <tr style="height:25px;">                        
                <td class="leftTdSearch"  style="vertical-align:bottom; text-align:left;">时间范围&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input id="startTime" type="text"  class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  value='<%=startTime %>' size="23"   readonly="true"/> 
                ---
                <input id="endTime" type="text"  class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   value='<%=endTime %>' size="23"  readonly="true"/> &nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:qryData()">查询</a>&nbsp;&nbsp;&nbsp;
                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:expData()">导出Execl</a>&nbsp;&nbsp;<span style="color:Red; font-size:12px;"></span>
                </td>
            </tr>
            <tr style="height:25px; text-align:left;">      
                <td class="leftTdSearch "  style="vertical-align:bottom; text-align:left;" >
                    峰值报警率&nbsp;&nbsp;<input id="Text3" type="text" value='<%=compAnaly.maxpercent %>' readonly="true" style="border: solid #999 1px;height:20px;"/> &nbsp;&nbsp;
                    扰动率&nbsp;&nbsp;<input id="Text4" type="text"  value='<%=compAnaly.perturbationRate %>' readonly="true" style="border: solid #999 1px;height:20px;" /> 
                </td>
            </tr>
        </table>
       <div>
            <div style="height:250px;width:99%;">
                <div style="height:100%;width:100%;">
                    <div id="chartContainer" style="z-index:2;border:1px solid; border-color: rgb(9,145,208); height:100%;width:100%" ></div>
                </div>
            </div>
           <div style="height:250px;width:99%;">
                <div style="height:100%;width:100%;">
                    <div id="pie_div" style=" z-index:2;border-left:1px solid;border-right:1px solid; border-bottom:1px solid;  border-color: rgb(9,145,208); height:100%;width:100%" ></div>
                </div>
            </div>
        </div>
    </div>
        
    <div id="gridDiv" style=" height: 310px;width:99%" border="false">        
        <table id="dg"    style="width:auto;height:310px; " 
                url="alarm_comprehensive_analysis_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>" idField="zhStartTime"
                 pagination="true"  fit="true" pagesize="10"  nowrap="true"
                rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr> 
                    <% if (Array.IndexOf(list, "004003zhStartTime") >= 0)
                    {%>                     
                    <th field="zhStartTime" width="80" align="right">开始时间</th>
                    <%} %>
                      <% if (Array.IndexOf(list, "004003zhEndtime") >= 0)
                    {%>  
                    <th field="zhEndtime" width="80" align="right">结束时间</th>
                    <%} %>
                      <% if (Array.IndexOf(list, "004003zhAlarmNumbers") >= 0)
                    {%>  
                    <th field="zhAlarmNumbers" width="80" align="right">报警个数</th>
                    <%} %>
                      <% if (Array.IndexOf(list, "004003zhPercent") >= 0)
                    {%>  
                    <th field="zhPercent" width="80" align="right">10Min平均报警率</th>
                    <%} %>
                      <% if (Array.IndexOf(list, "004003zhAlarmItems") >= 0)
                    {%>  
                    <th field="zhAlarmItems" width="200" align="left">报警位号</th>
                    <%} %>
                </tr>
            </thead>
        </table>
    </div>
    </form>
</body>    
</html>
<script type="text/javascript">
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}



function expData(){
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    
    /* 通过cookie传值 */
    var date=new Date(); 
    date.setTime(date.getTime() + 60*1000); 
    document.cookie = "plantId=<%=plantId %>; expirse=" + date.toGMTString();
    document.cookie = "startTime="+startTime + "; expirse=" + date.toGMTString();
    document.cookie = "endTime=" + endTime + "; expirse=" + date.toGMTString();
    
    document.forms[0].target = "hidden_frame";
    
    var url = "./alarm_comp_analysis_exp.ashx?a=1";
    //window.open(url);
    document.forms["comp_form"].action = url;
    document.forms["comp_form"].method = "GET";
    document.forms["comp_form"].submit();
    document.forms["comp_form"].target = "";
}

//列表外查询
function qryData() {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();

    if(startTime > endTime){
        alert("查询开始时间不能大于截止时间！");
        return;
    }
    
    
    window.location.href = "./alarm_comprehensive_analysis.aspx?plantId=<%=plantId %>&startTime=" + startTime + "&endTime=" + endTime;
}

$('#dg').datagrid({ onLoadSuccess: function () { $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center'); } });

function getXMLData(){
    var startTime = $("#startTime").val();
    var endTime   = $("#endTime").val();
    
    if(startTime > endTime){
        alert("开始时间不能大于截止时间！");
        return ;
    }
    
    var xmlData = "";
   
   return xmlData;
}	
	
function showLine()
{   
    /* 网页版调用 */
    try{
        showchart();
    }catch(exp){}
    
    /* 预留给客户端调用 */
    try{
        window.external.ShowTime(beginTime,endTime);//调用后台写入xml
    }catch(exp){};
}

//后台写入xml后调用的函数
function showchart()
{
    /* 线图 */
    var chart = new AnyChart('../resource/chartSwf/AnyChart.swf', '../resource/chartSwf/Preloader.swf');
    chart.width = "100%";
    chart.height = "100%";
    chart.wMode = "opaque";
    chart.setData('<%=compAnaly.chartStr %>');         
    chart.write("chartContainer");
    
    /* 饼图 */
    var chart = new AnyChart('../resource/chartSwf/AnyChart.swf', '../resource/chartSwf/Preloader.swf');
    chart.width = "100%";
    chart.height = "100%";
    chart.wMode = "opaque";
    chart.setData('<%=compAnaly.pieStr %>');          
    chart.write("pie_div");
}

showchart();

function initGrid(){
//    <% if(null != compAnaly.zhList && 1 <= compAnaly.zhList.Count){ %>
//        $("#dg").datagrid("insertRow",{index:0, row:{"zhStartTime": rowData["tableId"],"cause": rowData["zhEndtime"],
//        "zhAlarmNumbers": rowData["zhAlarmNumbers"],"zhPercent": rowData["effect"],"zhPercent": rowData["effect"]}});
//    <%} %>
}

function resizeGrid() {
    $('#dg').datagrid('resize', {
        width: function () { return document.body.clientWidth * 100; }
    });
}
$(window).resize(function () {
    resizeGrid();
});

window.onerror =function (){return true;};

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
