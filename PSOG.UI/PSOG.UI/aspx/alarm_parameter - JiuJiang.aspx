<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_parameter.aspx.cs" Inherits="aspx_alarm_parameter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% string contextPath = Request.ApplicationPath;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;%>
    <title>参数报警</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/easyui/jquery.easyui.min.js"></script>
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
</head>
<body   style="width:100%; "   >
    <div style="overflow-y:hidden;height:340px;width:99%" id="qryDiv"  region="north"  border="false">
        <!-- #include file="include_loading.aspx" -->
        
        <div id="gridDiv" fit="true" style="height: 340px; width:100%" border="false">
            <div id="headGrid" region="center"  style="height:340px; width:100% ">
                <table id="dg"  class="easyui-datagrid"  style="width:auto;height:340px"  
                        url="alarm_parameter_data.ashx?plantId=<%=plantId %>" idField="tableId" 
                         pagination="false"  
                        rownumbers="true" fitColumns="true" singleSelect="true">
                    <thead>
                        <tr> 
                            <th field="tableId" width="30" align="center" hidden="true"></th> 
                            <th field="space2" width="30" align="center">确认</th>                   
                            <th field="items" width="80" align="left">位号</th>
                            <th field="value" width="80" align="right">值</th>
                            <th field="state" width="60" align="left">状态</th>
                            <th field="alarmClass" width="60" align="left">危险性</th>
                            <th field="color" width="60" align="left" hidden="true">危险性颜色</th>
                            <th field="tempColor" width="10" align="left" hidden="true">偏离颜色</th>
                            <th field="strtext" width="60" align="left">偏离度</th>
                            <th field="duration" width="60" align="right">持续时间</th>
                            <th field="startTime" width="80" align="right">开始时间</th>
                            <th field="space1" width="30" align="center"></th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
     </div>   
        <div id="Div4"  region="center" style="padding: 5px; height:300px;width:99%" border="false"> 
            <div id="Div1"  style="width:auto" border="false">
                
                        <div id="Div3" region="north" style=" height: 50px;width:100%" border="false">
                            <table style="width:100%; height:100%">
                                <tr>
                                    <td style="width:25%">位&nbsp;&nbsp;号：<label id="itemId"></label></td>
                                    <td style="width:25%">当前值：<label id="value"></label></td>
                                    <td style="width:25%">状&nbsp;&nbsp;态：<label id="state"></label></td>
                                    <td style="width:25%">描&nbsp;&nbsp;述：<label id="describe"></label></td>
                                </tr>
                                <tr>
                                    <td>高高限：<label id="constraintHigh"></label></td>
                                    <td>高&nbsp;&nbsp;限：<label id="technicsHigh"></label></td>
                                    <td>低&nbsp;&nbsp;限：<label id="technicsLow"></label></td>
                                    <td>低低限：<label id="constraintLow"></label></td>
                                </tr>
                            </table>
                        </div>
                        <div id="Div2"   region="center"  style=" height: 240px;width:auto" border="true">
                            <table id="dg1"  class="easyui-datagrid"  style="width:auto;height:240px"
                                     idField="tableId" url="alarm_parameter_hazop.ashx?plantId=<%=plantId %>" 
                                     pagination="false" 
                                    rownumbers="false" fitColumns="true" singleSelect="true" nowrap="false">
                                <thead>
                                    <tr> 
                                        <th field="cause" width="10" align="left">可能原因</th>                   
                                        <th field="measure" width="10" align="left">建议措施</th>
                                        <th field="effect" width="10" align="left">不良后果</th>
                                        <th field="prevent" width="10" align="left">防范措施</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                 </div>
            
    </div>
    
</body>
</html>
<script type="text/javascript">

function initColor() {
    /* 设置颜色 */
    $('#headGrid .datagrid-body tr td[field="strtext"]').each(function () {

        //偏离度填充颜色
        var cell = $(this).prev().children().eq(0);
        if ("" != cell.text()) {
            var color = cell.text();
            if ("Yellow" == color) color = "Blue";
            $(this).css({ "color": color });
            var cellText = $(this).children().eq(0).html();
            $(this).children().eq(0).html("<span style='font-weight:700'>" + cellText + "</span>");
        }
        
        //危险性填充颜色
        cell = $(this).prev().prev().children().eq(0);
        if ("" != cell.text()) {
            var color = cell.text();
            if ("Yellow" == color) color = "Blue";
            $(this).prev().prev().prev().css({ "color": color });
            var cellText1 =$(this).prev().prev().prev().children().eq(0).html();
            $(this).prev().prev().prev().children().eq(0).html("<span style='font-weight:700'>" + cellText1 + "</span>");
            $(this).prev().prev().prev().prev().css({ "color": color }); //状态填充颜色
            var cellText2 = $(this).prev().prev().prev().prev().children().eq(0).html();
            $(this).prev().prev().prev().prev().children().eq(0).html("<span style='font-weight:700'>" + cellText2 + "</span>");
        }
                
    });
    /* 设置报表 */
    $('#headGrid .datagrid-body tr td[field="space1"]').each(function () {
        var id = $(this).parent().children().eq(0).children().text();
        $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;' onclick='makeOk('" + id + "')' ></input>");        
    });
    
    /* 设置确定项 */
    $('#headGrid .datagrid-body tr td[field="space2"]').each(function () {
         var id = $(this).parent().children().eq(2).children().text();
        $(this).children().eq(0).html("<input  type='button' style='width:46px' onclick='makeOk('" + id + "')' value='确定'></input>");        
    });

    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
}

//删除
function makeOk(rowIndex,rowData){
     //$("#dg").datagrid("deleteRow", rowIndex);
     $.ajax({
            url : './alarm_parameter_data.ashx',
            data : {
                action:"deleteItem",
                realTimeID:rowData.tableId,
                plantId:"<%=plantId %>"
            },
            async:false,
            type:"post",
            success : function(data) {
                $("#dg").datagrid("deleteRow", rowIndex);
                $.messager.show({
                        title : '提示',
                        msg : data
                });                
            }
        });
}

function showHistoryLine(tableName){
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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

var clickTd = false;//记录是否点击确认按钮
var lastInstrumentationId = "";

$('#dg').datagrid({ onLoadSuccess: initColor ,
    "onClickCell":function(rowIndex, field, value){
        if("space2" == field){
            $('#headGrid .datagrid-body tr td[field="space2"]').eq(rowIndex).each(function () {
                //var id = $(this).parent().children().eq(0).children().text();
                     
                clickTd = true;
            });
        }else if("space1" == field){
            $('#headGrid .datagrid-body tr td[field="space1"]').eq(rowIndex).each(function () {
                var items = $(this).parent().children().eq(2).children().text();
                showHistoryLine(items);     //报表事件
            });
        }
    },
    "onSelect": function (rowIndex, rowData){   //行选中事件
        if(true == clickTd){
            makeOk(rowIndex,rowData);    //确定事件
            clickTd = false;
            return ;
        }
        clickTd = false;
        $("#itemId").text(rowData["items"]);
        $("#value").text(rowData["value"]);
        $("#state").text(rowData["state"]);
        $("#describe").text(rowData["describe"]);
        $("#constraintHigh").text(rowData["constraintHigh"]);
        $("#technicsHigh").text(rowData["technicsHigh"]);
        $("#technicsLow").text(rowData["technicsLow"]);
        $("#constraintLow").text(rowData["constraintLow"]);
            
        //if(0 != $("#dg1").datagrid("getRows").length){
        //    $("#dg1").datagrid("deleteRow", 0);
        //}
        //if("" != rowData["cause"] || "" != rowData["measure"] || "" != rowData["effect"] ){
        //    $("#dg1").datagrid("insertRow", { index: 0, row: { "tableId": rowData["tableId"], "cause": rowData["cause"].replace(/\n/g, "<br />"), "measure": rowData["measure"].replace(/\n/g, "<br />"), "effect": rowData["effect"].replace(/\n/g, "<br />")} });
        //}

        var instrumentationId = rowData["id"];
        if (lastInstrumentationId == instrumentationId) {   //点击相同点不触发更新
            return;
        }

        $('#dg1').datagrid('load', {
            instrumentId: instrumentationId,
            state: rowData["state"].substring(0,1)

        });

        var i = 1;
        $('#dg1').datagrid({
            onLoadSuccess: function (rowData) {
                    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
                    if (1 > rowData.rows.length) return;
                    mergeCells(parseInt(rowData.rows[0].rowcount));
                    
            }
        });

        

        lastInstrumentationId = instrumentationId;
    }});


function mergeCells(rowSpan) {
    $('#dg1').datagrid('mergeCells', {
        index: 0,
        field: 'prevent',
        rowspan: rowSpan
    });
    $('#dg1').datagrid('mergeCells', {
        index: 0,
        field: 'effect',
        rowspan: rowSpan
    });
}

function resizeGrid() {
    $('#dg').datagrid('resize', {
        width: function () { return document.body.clientWidth * 100; }
    });
    $('#dg1').datagrid('resize', {
        width: function () { return document.body.clientWidth * 100; }
    });
}
$(window).resize(function () {
    resizeGrid();
});
/* 每五分钟重新加载一次 */
function intervall(){
    window.setInterval("reloadgrid()", 60000);
}

/* 重新加载列表 */
function reloadgrid(){
   $("#dg").datagrid("reload");
}

intervall();

window.onerror = function () { return true; };
</script>