<%@ Page Language="C#" AutoEventWireup="true" CodeFile="organ_left_tree.aspx.cs" Inherits="aspx_sysman_organ_left_tree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>�û���</title>
    <%
         %>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
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
        data: eval('(' + '<%=headOrganJson %>'+ ')'),
        checkbox:false,
        cascadeCheck:false,
        onlyLeafCheck:false,
        onClick: function (node){
            var nodeInfo = node.attributes.split(":");  //nodeInfo[0]�ӽڵ������nodeInfo[1]�ڵ�����ORGAN\USER
            parent.window.showRoleTree(node.id, nodeInfo[1]);
        },
        onBeforeExpand: expandChildrens
    });
    
    $('#tt').tree("expandAll");
    
    function expandChildrens(node){    //չ���ڵ�
        var childNodes = $('#tt').tree("getChildren", node.target);
        if(0 == childNodes.length){
            var nodes = getChildNodes(node.id); //h��̨��ȡ�ӽڵ�
            $('#tt').tree("append", {parent: node.target, data:eval("(" + nodes + ")")});
        }
        return true;
    }     
    
    //��ȡ�ӽڵ�
    function getChildNodes(nodeId){
        var node = "";
        $.ajax({
            url:'organ_left_tree_data.ashx',
            data:{parentOrganCode:nodeId},
            async:false,
            type:"post",
            success: function (data){
                node = data;
            }
        });
        return node;
    }
    
</script>