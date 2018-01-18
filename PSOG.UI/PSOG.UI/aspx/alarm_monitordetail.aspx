<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_monitordetail.aspx.cs" Inherits="aspx_alarm_monitordetail" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;

       String modelId = Request.QueryString["modelId"];
       modelId = null == modelId ? "" : modelId;
        
       String name = Request.QueryString["name"];
       name = null == name ? "" : name;

       String yvalue = Request.QueryString["yvalue"];
       yvalue = null == yvalue ? "" : yvalue;
    %>

    <title>报警相关偏离点</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        body{
           overflow:auto;
           font-size:12px;font-family: 微软雅黑;
            SCROLLBAR-FACE-COLOR: #cecece; 
            SCROLLBAR-HIGHLIGHT-COLOR: white; 
            SCROLLBAR-SHADOW-COLOR: white; 
            SCROLLBAR-3DLIGHT-COLOR: white; 
            SCROLLBAR-ARROW-COLOR: white; 
            SCROLLBAR-TRACK-COLOR: white; 
            SCROLLBAR-DARKSHADOW-COLOR: white; 
            }
    </style>
    <SCRIPT language=javascript> 

window.onerror=function(){return true;} 

</SCRIPT> 

</head>
<body   style="width:100%; "  class="easyui-layout"  fit="true">
        <!-- #include file="include_loading.aspx" -->
        
        <div id="gridDiv" style="height: 100%; width:100%"  region="center"  fit="true" border="false">
            <table id="dg"  class="easyui-datagrid"  style="width:auto;height:auto"  
                    url="alarm_monitordetail_data.ashx?plantId=<%=plantId %>&modelId=<%=modelId %>&name=<%=name %>&yvalue=<%=yvalue %>" idField="tableId" 
                        pagination="false"   fit="true"
                    rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                    <tr> 
                        <th field="tagId" width="" hidden="true" align="left">报警位号</th>
                        <th field="point" width="100" align="left">报警位号</th>
                        <th field="desc" width="200" align="left">描述</th>
                        <th field="val" width="60" align="right">当前值</th>
                        <th field="tagDCS" width="120" align="right">DCS阈值</th>
                        <th field="tagXT" width="120" align="right">经验阈值</th>
                        <th field="transState" width="70" align="right">超限类型</th>
                        <th field="unit" width="40" align="left">单位</th>                            
                        <th field="time" width="130" align="right">时间</th>
                        <th field="space1" width="45" align="center">趋势图</th>
                    </tr>
                </thead>
            </table>
        </div>
        
</body>
</html>
<script type="text/javascript">
 
function initColor() {
    /* 设置报表 */
    $('#gridDiv .datagrid-body tr td[field="space1"]').each(function () {
        var id = $(this).parent().children().eq(0).children().text();
        $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;' onclick='makeOk('" + id + "')' ></input>");
    });

    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
}

function showHistoryLine(tagId, tableName) {
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_monitor_chart.aspx?plantId=<%=plantId %>&time=<%=name %>&realValue=<%=yvalue %>&tagId=" + tagId + "&tableName=" + tableName + "&random=" + Math.random(), window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_monitor_chart.aspx?plantId=<%=plantId %>&time=<%=name %>&realValue=<%=yvalue %>&tagId=" + tagId + "&tableName=" + tableName + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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


$('#dg').datagrid({ onLoadSuccess: initColor,
    "onClickCell": function (rowIndex, field, value) {
        if ("space1" == field) {
            $('#gridDiv .datagrid-body tr td[field="space1"]').eq(rowIndex).each(function () {
                var tagId = $(this).parent().children().eq(0).children().text();
                var tableName = $(this).parent().children().eq(1).children().text();
                showHistoryLine(tagId, tableName); //报表事件
            });
        }
    }
});
function resizeGrid() {
    $('#dg').datagrid('resize', {
        width: function () { return document.body.clientWidth ; }
    });
}
$(window).resize(function () {
    resizeGrid();
});    
</script>
