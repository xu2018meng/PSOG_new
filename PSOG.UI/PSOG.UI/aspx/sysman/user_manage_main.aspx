﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="user_manage_main.aspx.cs" Inherits="aspx_sysman_user_manage_main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>用户角色管理</title>

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
	        <iframe id="left_frame" name="left_frame" src="user_manage.aspx" style="overflow:hidden; " scrolling="no"  height="100%" width="170px" frameborder="0"></iframe>
	    </div>
    	
	    <div data-options="region:'center'" border="true" style="height:100%;overflow:hidden;">
		    <%-- 主内容 aspx/main_page.aspx --%>
	        <iframe id="main-region" name="main-region" src="user_list.aspx"  height="100%" width="100%"  frameborder="0"></iframe>	    
	    </div>
    </form>
</body>
</html>
<script type="text/javascript">
function showUserList(parentCode, organCode, nodeType){
    if("ROOT" == nodeType)  //不需要展示菜单页
    {
        window.frames["main-region"].reloadGrid('', '', false);
    }
    else if("ORGAN" == nodeType){
        window.frames["main-region"].reloadGrid(organCode, '', false);
    }else{
        window.frames["main-region"].reloadGrid(parentCode, organCode, true);
    }
    
}
</script>