<%@ Page Language="C#" AutoEventWireup="true" CodeFile="role_tree_forMenu.aspx.cs" Inherits="aspx_sysman_role_tree_forMenu" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>角色树</title>
  
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding-top:10px;">
        <ul id="tt"></ul>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">

    $('#tt').tree({
        url:'role_tree_data.ashx',
        checkbox:false,
        cascadeCheck:false,
        onlyLeafCheck:true,
        onClick: function (node){
            parent.window.showMenuTree(node.id);
        }
    });
    
    function getAllData(){
        var roleNode = $('#tt').tree("getSelected");
        if(0 == roleNode.length){
            alert("请选择");
            return ;
        }
        return roleNode[0].id;
    }
</script>

