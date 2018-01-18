<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_history_statis.aspx.cs" Inherits="aspx_alarm_history_statis" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;  
       String startTime = Request.QueryString["startTime"];
       startTime = null == startTime ? "" : startTime;
       String endTime = Request.QueryString["endTime"];
       endTime = null == endTime ? "" : endTime; %>
    <title>历史查询</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <style type="text/css">
        td {text-align:left;}
        #qryDiv {padding-left:15px; padding-top:5px;}
    </style>
</head>
<body class="easyui-layout">
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">
        <table id="dg" title="报警次数统计" class="easyui-datagrid"  style="width:auto;height:auto" fit="true"
                url="alarm_history_statis_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>" idField="zhStartTime"
                 pagination="false" 
                rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>                    
                    <th field="itemNo" width="120" align="left">位号</th>
                    <th field="number" width="60" align="right">次数</th>
                    <th field="describe" width="120" align="left">描述</th>
                    <th field="flagId" width="60" align="center">趋势</th>
                </tr>
            </thead>
        </table>
    </div>
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


//列表外查询
function qryData() {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();

    $('#dg').datagrid('load', {
        startTime: $('#startTime').val(),
        endTime: $('#endTime').val()
    });
}

var clickTd = false;//记录是否点击确认按钮

$('#dg').datagrid({ onLoadSuccess: resizeGrid ,
        "onClickCell":function(rowIndex, field, value){
            if("flagId" == field){
                $('#gridDiv .datagrid-body tr td[field="flagId"]').eq(rowIndex).each(function () {
                    var items = $(this).parent().children().eq(0).children().text();
                    showHistoryLine(items);     //报表事件
                });
            }
        }});
    
function initReport() {    
    /* 设置报表 */
    $('#gridDiv .datagrid-body tr td[field="flagId"]').each(function () {
        var id = $(this).parent().children().eq(0).children().text();
        $(this).children().eq(0).html("<div style='width:auto;'><img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;'  ></input></div>");    //onclick='showHistoryLine(" + id + ")'    
    });
}

function resizeGrid() {
    initReport();    //将td转化为颜色值    
    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
}

function showHistoryLine(tableName){
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-610/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),"newWindow1", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
    }
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


window.onerror = function () { return true; }
</script>

