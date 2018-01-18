<%@ Page Language="C#" AutoEventWireup="true" CodeFile="device_check_main.aspx.cs" Inherits="aspx_device_check_main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <title>设备检测</title>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <% string clickProcess = Request.QueryString["clickProcess"];
       clickProcess = null == clickProcess ? "" : clickProcess;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
         %>
</head>
<body id="art_check_body" class="easyui-layout" style="width:100%; height:100%; overflow:hidden" >
    <!-- #include file="include_loading.aspx" -->
    
	<div data-options="region:'center'" border="false" fit="true">
	    <div  class="easyui-layout"  style="width:100%; height:100%; padding:0px; margin:0px;" fit="true">
	        <div data-options="region:'west'"  style="width:176px; height:100%; overflow:hidden; "  border="true" style="border:2px solid; border-color: rgb(9,145,208)">
	            <iframe id="left_iframe" name="left_iframe" src="device_tree_function.aspx?plantId=<%=plantId %>&clickProcess=<%=clickProcess %>"  width="172px" height="100%" scrolling="no" frameborder="0" ></iframe>
	        </div>
	        <div data-options="region:'center'" border="false" style="position:relative; height:100%; overflow:hidden;">
		        <iframe id="right_iframe" src="" width="100%" height="100%" frameborder="0"></iframe> 
	        </div>
		</div>
	</div>
</body>
</html>
<script type="text/javascript">

document.all("right_iframe").src = "./web_equip_home.aspx?plantId=<%=plantId %>"; //初始右侧设备主页
//$('#art_check_body').

$(window).resize(function (){
    $("#left_iframe").width("100%");
    $("#right_iframe").height("100%");
});

function resize(){
    $("#left_iframe").width("100%");
    $("#right_iframe").height("100%");
}

//功能跳转
function showFunctionPage(url, clickText){
    try{
    window.frames["left_iframe"].clickFunction(clickText);
    //$("#right_iframe").attr("src", url);
    }catch(exp){};
}

//功能跳转
function showFunction(url){
    try{
    $("#right_iframe").attr("src", url);
    }catch(exp){};
}
</script>

