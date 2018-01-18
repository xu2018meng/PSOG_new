<%@ Page Language="C#" AutoEventWireup="true" CodeFile="fault_tree_model.aspx.cs" Inherits="aspx_fault_tree_model" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <% 
        String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
       String modelId = Request.QueryString["name"];
       modelId = null == modelId ? "" : modelId;
         %>
    <title>故障树模型</title>
</head>
<body>
	<div id="ImgPanel" style=" ">
        <!--<input id="Img" type="image" name="图片" src=""  /> -->
        <img id="Img" alt="" style=""  src="../../resource/img/rolling.gif"/>
    </div>
</body>
</html>
<script type="text/javascript">
    document.getElementById("Img").src = '../web_get_ASImg.ashx?fileId=a&plantId=<%=plantId %>&name=<%=modelId %>';
</script>