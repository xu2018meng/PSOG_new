<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree_plant_new2.aspx.cs" Inherits="aspx_tree_plant_new2" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head id="Head1" >
    <title>功能菜单</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/css/sysManageStyle.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    
     <style type="text/css">
      .tree-title{font-size:14px; top:4px;  font-weight:550;font-family: 微软雅黑;}
    </style>
    
</head>
<body style="margin:0px; padding:0px; overflow:hidden; background-color:#d1e5f0;background-size:210px 100%; background-position:left bottom; width:210px; height:100%;">
        <div style="margin:0px; padding:0px;padding-top:3px;width:210px;  height:100%; font-size:13px; overflow:auto">
           <ul id="tt"></ul>
        </div>
        
</body>
</html>
<script type="text/javascript">
  $(function(){
       var treeData = eval('(' + '<%=headMenuJson %>'+ ')')[0].children;
       for(var i=0;i<treeData.length;i++){
          var node = treeData[i];
          var nodeType = node.attributes.split(":")[1];
          if(nodeType=="plant"){
             window.parent.showPlantsPage(node.id);
             break;
          }
       }
  });
  
   
   $('#tt').tree({
        data: eval('(' + '<%=headMenuJson %>'+ ')'),
        checkbox:false,
        cascadeCheck:false,
        onlyLeafCheck:false,
        onClick: function (node){
            var nodeType = node.attributes.split(":")[1];
            parent.showMainPage(node.id,nodeType);
        },
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
    function getChildNodes(nodeId,nodeType){
        var node = "";
        $.ajax({
            url:'tree_plant_new_data2.ashx',
            data:{nodeId:nodeId,nodeType:nodeType},
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

