<%@ Page Language="C#" AutoEventWireup="true" CodeFile="art_soft_measure.aspx.cs" Inherits="aspx_art_soft_measure" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<script language="JavaScript">
function killErrors() {
return true;
}
window.onerror = killErrors;
</script>
    <% string contextPath = Request.ApplicationPath;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId; %>;
    <title>软测量</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>
<body class="easyui-layout">
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%;" border="false">
        <table id="dg"  class="easyui-datagrid"  style="width:auto;height:auto" fit="true"
                url="art_soft_measure_data.ashx?plantId=<%=plantId %>" idField="limsPointMatCode"
                 pagination="true" pagesize="30"
                rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                 <% if (Array.IndexOf(list, "002003describe") >= 0)
                    {%>
                    <th field="describe" width="250" align="left">描述</th>
                    <%} %>
                     <% if (Array.IndexOf(list, "002003valuation") >= 0)
                    {%>
                    <th field="valuation" styler:cellStyler width="50" align="right">估计值</th>
                    <%} %>
                     <% if (Array.IndexOf(list, "002003time") >= 0)
                    {%>
                    <th field="time" width="80" align="right">时间</th>
                    <%} %>
                     <% if (Array.IndexOf(list, "002003trend") >= 0)
                    {%>
                    <th field="trend" width="45" align="center">趋势</th>
                    <%} %>
                     <% if (Array.IndexOf(list, "002003space2") >= 0)
                    {%>
                     <th data-options="field:'space2'" width="100" align="center">确认</th> 
                     <%} %>
                </tr>
            </thead>
        </table>
    </div>
</body>    
</html>
<script type="text/javascript">

function initGridCell() {
    /* 设置趋势图 */
    $('#gridDiv .datagrid-body tr td[field="trend"]').each(function () {
        $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;' ></input>");        
    });    
    /* 设置确定项 */
    $('#gridDiv .datagrid-body tr td[field="space2"]').each(function () {
         var id = $(this).parent().children().eq(2);
        $(this).children().eq(0).html("<input  type='button' style='width:46px' onclick='makeOk('" + id + "')' value='确定'></input>");      
    });
    //标题居中
    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');    
}

$('#dg').datagrid({ 
                    onLoadSuccess: initGridCell,
                    "onClickCell":function(rowIndex, field, value){
                        if("trend" == field){
                                $('#gridDiv .datagrid-body tr td[field="trend"]').eq(rowIndex).each(function () {
                                var items = $(this).parent().children().eq(2).children().text();
                                showHistoryLine(items);     //报表事件
                                });
                        }
                        else if("space2" == field){  
                            clickTd = true;
                            makeOk(rowIndex,clickTd)
                         }
                    }
});
    //删除
function makeOk(rowIndex,clickTd){
      $('#gridDiv .datagrid-body tr td[field="valuation"]').eq(rowIndex).each(function () {
            var colorvalue =$(this).css("color");
            value="rgb(255,51,0)";
            if (value == colorvalue) {
             color="rgb(0,0,0)";
            }
            else{
            color="rgb(255,51,0)";
            }
            $(this).css({ "color": color });
            
      })
	
}
function showHistoryLine(tableName){
//    if(3 != getBrowserType()){
//        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
//    }else{
//        var windowLeft = (top.document.body.clientWidth)/2-850/2;
//        var windowTop = (top.document.body.clientHeight)/2-630/2;
//        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
//    }
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

</script>