<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis.aspx.cs" Inherits="aspx_alarm_analysis" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections.Generic" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <% 
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
         %>
    <title>报警分析</title>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style>
        body {font-size:12px;}
    </style>
</head>
<body>


    <!-- #include file="include_loading.aspx" -->
    <div id="tabsDiv" class="easyui-tabs" fit="true" style="width:100%; height:100%" data-options="onSelect:selPrivateTab" onSelect="showPage('Iframe0', 'alarm_parameter.aspx?plantId=<%=plantId %>')">
        <% for (int i = 0, size = functionList.Count; i < size; i++)
           { 
               FunctionNode node = functionList[i];
               %>
            <div title="<%=node.functionName %>" style="padding:10px" selected="true" src='<%=node.functionUrl %>?plantId=<%=plantId %>&sys_menu_code=<%=node.functionCode %>'>
                <iframe id='<%="iframe_" + i %>' src=""  height="100%" width="100%" frameborder="0"></iframe>
            </div>
        <%} %>
    </div>
</body>
</html>
<script type="text/javascript">
        
    function selPrivateTab(title, index){
        if("" == $('#iframe_' + index).attr("src")){
            $('#iframe_' + index).attr("src", $('div > [title]').eq(index).attr("src"));
        }
    }
</script>