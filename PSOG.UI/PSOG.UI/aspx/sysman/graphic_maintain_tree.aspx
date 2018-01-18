<%@ Page Language="C#" AutoEventWireup="true" CodeFile="graphic_maintain_tree.aspx.cs" Inherits="graphic_maintain_tree" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Entity" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>装置树</title>
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
            var nodeType = node.attributes.split(":")[1];
            parent.showRecordList(node.id,nodeType);
        },
        onBeforeExpand: expandChildrens
    });
    
    function expandChildrens(node){    //展开节点
        var childNodes = $('#tt').tree("getChildren", node.target);
        return true;
    }     
    
    
    function reloadTreeNode(nodeId)
    {
        $('#tt').tree("reload",$('#tt').tree("getParent",$('#tt').tree("find",nodeId).target).target);
        $('#tt').tree("reload",$('#tt').tree("find",nodeId).target);
    }
    
</script>
