<%@ Page Language="C#" AutoEventWireup="true" CodeFile="special_bit_relation_main.aspx.cs" Inherits="aspx_sysman_specialbit_relaiton_main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>专业类型与位号关系主页面</title>

    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        body {
            font-size:12px;
        }
    </style>
</head>
<body class="easyui-layout" border="1" >
    <form id="form1" action="">
        <!-- #include file="../include_loading.aspx" -->
        <div data-options="region:'west'"  style="width:177px;  position:relative; height:100%; overflow:hidden; " border="true">
	        <iframe id="left_frame" name="left_frame" src="special_bit_relation_tree.aspx" style="overflow:hidden; position:absolute;" scrolling="no"  height="100%" width="170px" frameborder="0"></iframe>
	    </div>
    	
	    <div data-options="region:'center'" border="true" style="position:relative; height:100%;overflow:hidden;">
		    <%-- 主内容 aspx/main_page.aspx --%>
	        <iframe id="main-region" name="main-region" src="special_bit_relation_list.aspx"  height="100%" width="100%"  frameborder="0"></iframe>	    
	    </div>
    </form>
</body>
</html>
<script type="text/javascript">
function showBitList(id, nodeType){
    window.frames["main-region"].reloadGrid(id, nodeType);
}

function reloadTreeNode(nodeId){
    window.frames["left_frame"].reloadTreeNode(nodeId);
}
</script>
