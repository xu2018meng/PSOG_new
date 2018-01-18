<%@ Page Language="C#" AutoEventWireup="true" CodeFile="user_select_tree.aspx.cs" Inherits="aspx_user_select_tree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>用户选择树</title>

    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
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
        <div style="margin-top:10px; overflow:auto;height:100%;width:100%;">
            <ul id="tt"></ul>
        </div>
</body>
</html>
<script type="text/javascript">

     $('#tt').tree({
        data: eval('(' + '<%=headOrganJson %>'+ ')'),
        checkbox:true,
        cascadeCheck:true,
        onlyLeafCheck:false,
        onBeforeExpand: expandChildrens
    });
    
    function expandChildrens(node){    //展开节点
        var childNodes = $('#tt').tree("getChildren", node.target);
        if(0 == childNodes.length){
            var nodeType = node.attributes.split(":")[1];
            var nodes = getChildNodes(node.id,nodeType); //h后台获取子节点
            $('#tt').tree("append", {parent: node.target, data:eval("(" + nodes + ")")});
        }
        return true;
    }     
    
    //获取子节点
    function getChildNodes(nodeId,type){
        var node = "";
        $.ajax({
            url:'user_select_tree_data.ashx',
            data:{nodeId:nodeId,type:type},
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
    
    //确定选择
    function confirmSelect(){
         var userIds = "";
         var userNames = "";
         var treeNodes = $('#tt').tree("getChecked");
         for(var i=0;i<treeNodes.length;i++){
             var nodeType = treeNodes[i].attributes.split(":")[1];
             if("USER" == nodeType){
                userIds += treeNodes[i].id+",";
                userNames += treeNodes[i].text+",";
             }else{
                continue;
             }
         }
         if(userIds.length==0){
             $.messager.alert('提示', '请选择要通知的人员');
             return false;
         }
         userIds = userIds.substring(0,userIds.length-1);
         userNames = userNames.substring(0,userNames.length-1);
         window.parent.closeDialog(userIds,userNames);
    } 
    
</script>
