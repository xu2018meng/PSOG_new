<%@ Page Language="C#" AutoEventWireup="true" CodeFile="art_mechanism_balance.aspx.cs" Inherits="aspx_art_mechanism_balance" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% string contextPath = Request.ApplicationPath;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId; %>;
    <title>机理衡算</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>
<body class="easyui-layout">
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%;" border="false">
        <table id="dg"  class="easyui-datagrid"  style="width:auto;height:auto" fit="true"
                url="art_mechanism_balance_list_data.ashx?plantId=<%=plantId %>" idField="limsPointMatCode"
                 pagination="true" pagesize="30"
                rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                <% if (Array.IndexOf(list, "002004describe") >= 0)
                    {%>
                    <th field="describe" width="250" align="left">描述</th>
                     <%} %>
                    <% if (Array.IndexOf(list, "002004state") >= 0)
                    {%>
                    <th field="state" width="45" align="center">状态</th>
                     <%} %>
                    <% if (Array.IndexOf(list, "002004valuation") >= 0)
                    {%>
                    <th field="valuation" width="50" align="right">估计值</th>
                     <%} %>
                    <% if (Array.IndexOf(list, "002004time") >= 0)
                    {%>
                    <th field="time" width="80" align="right">时间</th>
                     <%} %>
                    
                </tr>
            </thead>
        </table>
    </div>
</body>    
</html>
<script type="text/javascript">

function initGridCell() {    
    
    //标题居中
    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');    
}

$('#dg').datagrid({ onLoadSuccess: initGridCell });
    
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
