﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_stable_rate_analy.aspx.cs" Inherits="aspx_alarm_stable_rate_analy" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId; %>
    <title>操作质量分析</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <link href="../resource/jquery/qTip2/jquery.qtip.min.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/qTip2/jquery.qtip.min.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
    <script type="text/javascript" src="../resource/js/modules/exporting.js"></script>
    <style type="text/css">
        td {text-align:left;}
        #qryDiv {padding-left:15px; padding-top:5px;}
        body {font-size:12px; font-family: 微软雅黑;}
        .qtip-0-content
        {
            width:100% !important;
        }
    </style>
</head>

<body class="easyui-layout" style="width:100%; height:100%;" >
    <form id="form1" action="" style="width:100%; height:100%;" >
            <div style="padding-bottom: 5px;overflow-y:hidden;" id="qryDiv"  region="north"  border="false">
            
                <iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
                    <table class="tblSearch" style="text-align:left; width:100%;padding:0px;">
                        <tr style="height:25px;width:100%" >                        
                            <td class="leftTdSearch"  style="vertical-align:bottom; width:100%" nowrap="nowrap">
                                <span style="width:80px; height:30px;">
                                    <select style="width:80px; height:20px; border:#999 solid 1px; position:relative;   " onchange="isRealTime(this)">
                                        <option value="1" selected="selected" style="height:16px; line-height:150%">实时监测</option>
                                        <option value="0" style="height:16px; line-height:150%">历史查询</option>                             
                                    </select>
                                </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                时间范围&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="startTime" type="text"  value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="line-height: 150%;height:16px;"  size="23" readonly="true"/> 
                                ---
                                <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="line-height: 150%;height:16px;"  size="23" readonly="true"/> &nbsp;&nbsp;&nbsp;
                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:qryData()">查询</a>&nbsp;&nbsp;&nbsp;
                                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:expData()">导出Excel</a>&nbsp;&nbsp;<span style="color:Red; font-size:12px;"></span>
                                <img id="tip" onclick="showHelpWindow();" src="../resource/img/question.png" style="cursor:pointer;">
                            </td>
                        </tr>
                    </table>
               
            </div>
                
            <div id="gridDiv"  region="center" style="padding: 5px; height: 100%;" border="false">
                <table id="dg"  class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                    url="alarm_stable_rate_analy_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>" idField="id"
                     pagination="true" pagesize="30" 
                    rownumbers="true" fitColumns="true" singleSelect="true">
                    <thead>
                        <tr>                    
                            <th field="insItems" width="100" align="left">位号</th>
                            <th field="insDescribe" width="200" align="left">描述</th>
                            <th field="insAlarmClass" width="50" align="left" hidden="true">类型</th>
                            <th field="insTechnicsH" width="70" align="right">工艺上限</th>
                            <th field="insTechnicsL" width="70" align="right">工艺下限</th>
                            <th field="insCpkUSL" width="70" align="right" hidden="true">上限USL</th>
                            <th field="insCpkLSL" width="80" align="right" hidden="true">下限LSL</th>
                            <th field="insDataCount" width="70" align="right">数据总数</th>
                            <th field="insErrorDataCount" width="70" align="right">超标数</th>
                            <th field="insPercent" width="70" align="right">合格率</th>
                            <th field="insCpkCa" width="70" align="right">均值偏离度</th>
                            <th field="insCpkCp" width="70" align="right">数据集中度</th>
                            <th field="insCpk" width="100" align="right">操作质量指数</th>
                            <th field="flagID" width="50" align="center">趋势</th>
                        </tr>
                    </thead>
                </table>
            </div>
        <%--</div>    --%>
    </form>

    <div id="win" iconCls="icon-save" title="提示" >  
        <iframe src='../aspx/tip.htm' width='640px' height='720px'  scrolling='no' frameborder='0'></iframe>
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

    function showHelpWindow() {
        $('#win').window({   
           width:660,   
            height:400,   
            modal: true,
            collapsible: false,
            minimizable: false,
            maximizable: false
        }); 
    }

    //列表外查询
    function qryData() {
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();

        if (startTime > endTime) {
            alert("查询开始时间不能大于截止时间！");
            return;
        }

        $('#dg').datagrid('load', {
            startTime: $('#startTime').val(),
            endTime: $('#endTime').val()
        });
    }

    //导出
    function expData() {
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();

        /* 通过cookie传值 */
        var date = new Date();
        date.setTime(date.getTime() + 60 * 1000);
        document.cookie = "plantId=<%=plantId %>; expirse=" + date.toGMTString();
    document.cookie = "startTime=" + startTime + "; expirse=" + date.toGMTString();
    document.cookie = "endTime=" + endTime + "; expirse=" + date.toGMTString();

    document.forms[0].target = "hidden_frame";

    var url = "./alarm_stable_rate_analy_exp.ashx?plantId=<%=plantId %>&startTime=" + startTime + "&endTime=" + endTime;
    //window.open(url);
    document.forms["form1"].action = url;
    document.forms["form1"].method = "GET";
    document.forms["form1"].submit();
    document.forms["form1"].target = "";
}

var clickTd = false;//记录是否点击确认按钮

$('#dg').datagrid({
    onLoadSuccess: function(data){
//        var array = [];
//        var rows = $('#dg').datagrid('getRows');
//        for(var i=0; i<rows.length; i++){
//            var temp = [rows[i].area, rows[i].averagerate];
//            array.push(temp);
//        }
        resizeGrid();
    },
    "onClickCell": function (rowIndex, field, value) {
        if ("flagID" == field) {
            $('#gridDiv .datagrid-body tr td[field="flagID"]').eq(rowIndex).each(function () {
                var items = $(this).parent().children().eq(0).children().text();
                showHistoryLine(items);     //报表事件
            });
        }
    }
});

function initReport() {

    /* 设置报表 */
    $('#gridDiv .datagrid-body tr td[field="flagID"]').each(function () {
        var id = $(this).parent().children().eq(0).children().text();
        $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;'  ></input>");    //onclick='showHistoryLine(" + id + ")'    
    });
}

function resizeGrid() {
    initReport();    //将td转化为颜色值    
    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
}

function showHistoryLine(tableName) {
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(), window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(), "newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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

var intervalId = "";
/* 每10分钟重新加载一次 */
function intervall() {
    intervalId = window.setInterval("reloadgrid()", 600000);
}

/* 重新加载列表 */
function reloadgrid() {
    $("#dg").datagrid("reload");
}

intervall();

function isRealTime(elem) {
    var selectValue = $(elem).val();
    if ("1" == selectValue) {
        if ("" == intervalId) {
            intervall();
        }
    } else {
        if ("" != intervalId) {
            window.clearInterval(intervalId);
            intervalId = "";
        }
    }
}

window.onerror = function(){return true;}
</script>
