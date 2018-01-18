<%@ Page Language="C#" AutoEventWireup="true" CodeFile="art_check_main.aspx.cs" Inherits="aspx_art_check_main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"  >
<head >
    <title>工艺检测</title>
    <% string clickProcess = Request.QueryString["clickProcess"];
       clickProcess = null == clickProcess ? "" : clickProcess;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;      
         %>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
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
            }
    </style>
</head>
<body id="art_check_body" class="easyui-layout" style="width:100%; height:100%; overflow:hidden"  >
    <!-- #include file="include_loading.aspx" -->
    <div data-options="region:'center'" border="false" fit="true">
        <div  class="easyui-layout"  style="width:100%; height:100%; padding:0px; margin:0px;" fit="true">
            <div data-options="region:'west'"  style="width:176px; height:100%; overflow:hidden; "  border="true" style="border:2px solid; border-color: rgb(9,145,208)">
	            <iframe id="left_iframe" name="left_iframe" src="tree_left_function.aspx?plantId=<%=plantId %>&functionNos=<%=functionNos %>&clickProcess=<%=clickProcess %>" width="100%" height="100%" scrolling="no" frameborder="0" ></iframe>
	        </div>
	        <div data-options="region:'center'" border="false" style="position:relative; height:100%; overflow:hidden; ">
		        <iframe id="right_iframe" src="" width="100%" height="100%" frameborder="0"></iframe> 
	        </div>
	     </div>
	</div>
</body>
</html>
<script type="text/javascript">
var functionNos = '<%=functionNos %>';

//有运行状态权限才显示主页
if(-1 != functionNos.indexOf('002001')){
    document.all("right_iframe").src = "Web_ArtTchHome.aspx?plantId=<%=plantId %>";
}

var clickProcess = "<%=clickProcess %>";

$(window).resize(function (){
    $("#left_iframe").width("100%");
    $("#right_iframe").height("100%");
});

function resize(){
    $("#left_iframe").width("100%");
    $("#right_iframe").height("100%");
}

//功能跳转
function showFunctionPage(url, clickText,clickUnusual){
    try{
        window.frames["left_iframe"].clickFunction(clickText, clickUnusual);
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
