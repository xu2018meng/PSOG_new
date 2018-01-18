<%@ Page Language="C#" AutoEventWireup="true" CodeFile="plants_main_frame.aspx.cs" Inherits="aspx_plants_main_frame" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Bizc" %>
<%@ Import Namespace="PSOG.Entity" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>装置统计</title>
</head>
<style type="text/css">
body{
    overflow:auto;
    SCROLLBAR-FACE-COLOR: #cecece; 
    SCROLLBAR-HIGHLIGHT-COLOR: white; 
    SCROLLBAR-SHADOW-COLOR: white; 
    SCROLLBAR-3DLIGHT-COLOR: white; 
    SCROLLBAR-ARROW-COLOR: white; 
    SCROLLBAR-TRACK-COLOR: white; 
    SCROLLBAR-DARKSHADOW-COLOR: white; 
    font-size: 12px;
}
</style>
<body style="width:99%; height:98%;text-align:center; ">
    <% if(null != plantList && 1<= plantList.Count){
           foreach (Plant plant in plantList)
           { %>
        <iframe id='<%="iframe" + plant.id %>' src="plant_main_page.aspx?plantId=<%=plant.id %>&plantName=<%=plant.organtreeName %>" frameborder="0" width="1020px" height="354px"></iframe>
         <%}
    } %>
</body>
</html>
