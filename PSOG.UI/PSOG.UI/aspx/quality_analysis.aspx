<%@ Page Language="C#" AutoEventWireup="true" CodeFile="quality_analysis.aspx.cs" Inherits="aspx_quality_analysis" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId; %>;
    <title>质量分析</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>
<body class="easyui-layout">
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%;" border="false">
        <table id="dg"  class="easyui-datagrid"  style="width:auto;height:auto" fit="true"
                url="quality_analysis_data.ashx?plantId=<%=plantId %>" idField="limsPointMatCode"
                 pagination="true" pagesize="30"
                rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <% if (Array.IndexOf(list, "002002limsPointMatCode") >= 0)
                    {%>
                    <th field="limsPointMatCode" width="12" align="left">样品名称</th>
                     <%} %>
                    <th field="limsPointSamplePointDesc" width="12" align="left" hidden="true">采样点名称</th>
                     <% if (Array.IndexOf(list, "002002limsPointTestNo") >= 0)
                    {%>
                    <th field="limsPointTestNo" width="12" align="center">测试名称</th>
                     <%} %>
                     <% if (Array.IndexOf(list, "002002limsPointAnalyle") >= 0)
                    {%>
                    <th field="limsPointAnalyle" width="12" align="left">分析项目</th>
                     <%} %>
                     <% if (Array.IndexOf(list, "002002limsPointFValue") >= 0)
                    {%>
                    <th field="limsPointFValue" width="12" align="left">实时值</th>
                     <%} %>
                     <% if (Array.IndexOf(list, "002002limsPointUnits") >= 0)
                    {%>
                    <th field="limsPointUnits" width="8" align="center">单位</th>
                     <%} %>
                     <% if (Array.IndexOf(list, "002002status") >= 0)
                    {%>
                    <th field="status" width="8" align="left">状态</th>
                     <%} %>
                    <th field="limsPointHigh" width="8" align="left" hidden="true">高限</th>
                    <th field="limsPointLow" width="8" align="center" hidden="true">低限</th>
                     <% if (Array.IndexOf(list, "002002time") >= 0)
                    {%>
                    <th field="time" width="8" align="center">时间</th>
                     <%} %>
                </tr>
            </thead>
        </table>
    </div>
</body>    
</html>
<script type="text/javascript">

function initColor() {
    /* 设置颜色 */
    $('#gridDiv .datagrid-body tr td[field="status"]').each(function () {

        //偏离度填充颜色
        var cell = $(this);
        if ("异常" == cell.text()) {
            $(this).css({ "color": "Red" });
        }

    });

    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
    
}

$('#dg').datagrid({ onLoadSuccess: initColor});

</script>