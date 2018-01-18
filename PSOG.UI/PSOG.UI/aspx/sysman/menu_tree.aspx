<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menu_tree.aspx.cs" Inherits="aspx_sysman_menu_tree" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Entity" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>角色树</title>
    <% 
         %>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        body {
            font-size:12px;
        }
        html,body,form{
            height: 100%;
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" action="" style="padding: 8px">
        <div style="margin-top:10px; overflow:auto;height:96%;width:162px;">
            <ul id="tt"></ul>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $('#tt').tree({
        data: eval('(' + '<%=headMenuJson %>'+ ')'),
        checkbox:false,
        cascadeCheck:false,
        onlyLeafCheck:false,
        onClick: function (node){
//            if("closed" == node.state && "0" != node.attributes)
//            {
//                $('#tt').tree("expandAll", node.target);
//            }
//            else
//            {
//                $('#tt').tree("collapseAll", node.target);
//            }
            var nodeType = node.attributes.split(":")[1];
            parent.showMenuList(node.id, nodeType);
        },
        onBeforeExpand: expandChildrens
    });
    
    //$('#tt').tree("expandAll");
    
    function expandChildrens(node){    //展开节点
        var childNodes = $('#tt').tree("getChildren", node.target);
        if(0 == childNodes.length){
            var nodes = getChildNodes(node.id); //h后台获取子节点
            $('#tt').tree("append", {parent: node.target, data:eval("(" + nodes + ")")});
        }
        return true;
    }     
    
    //获取子节点
    function getChildNodes(nodeId){
        var node = "";
        $.ajax({
            url:'menu_tree_data.ashx',
            data:{nodeId:nodeId},
            async:false,
            type:"post",
            success: function (data){
                node = data;
            }
        });
        return node;
    }
    
    function reloadTreeNode(nodeId)
    {
        $('#tt').tree("reload",$('#tt').tree("getParent",$('#tt').tree("find",nodeId).target).target);
        $('#tt').tree("reload",$('#tt').tree("find",nodeId).target);
    }
    
</script>
