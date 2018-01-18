<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sys_manage_tree.aspx.cs" Inherits="aspx_sysman_sys_manage_tree" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Common" %>
<%@ Import Namespace="PSOG.Entity" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% 
       string clickProcess = Request.QueryString["clickProcess"];
           clickProcess = null == clickProcess ? "" : clickProcess;
           String plantId = Request.QueryString["plantId"];
           plantId = null == plantId ? "" : plantId;
           String userId = ((SysUser)Session[CommonStr.session_user]).userId;
             %>
    <title>功能菜单</title>    
     <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
       .menuClass{background:url(../../resource/img/菜单头.jpg) repeat-x; width:175px; height:32px;margin-left:1px; }
       .treeHead{background:url(../../resource/img/合.gif) no-repeat; width:175px; height:32px; cursor:pointer;}
       .treeLeaf{background:  no-repeat; width:175px; height:32px;}
       .treeLeafText{position:relative ;left:40px; top:10px;}
       tree-title{font-size:14px; top:6px;  font-weight:550;width:175px;font-family: 微软雅黑;}
    </style>
</head>
<body  style="margin:0px; padding:0px;width:100%; height:100%; font-size:12px; ">
    <form id="form1" action="">
        <div style="margin-top:5px; overflow:auto;height:96%;width:200px;">
            <ul id="tt"></ul>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">

function leafMouseover(elem){
}

function leafMouseDown(e){
    var qryNodeStr = "div#" + e.getAttribute("pid") ;
    $("[isClick='true']").each(function (headCell){
        
        this.style.background = "url('../../resource/img/合.gif')";
        this.setAttribute("isClick", "false");
        this.children[0].style.color = "black";
    })
    e.setAttribute("isClick", "true");
    e.children[0].style.color = "rgb(254,187,88)";
    e.style.background = "url('../../resource/img/下_21.gif')";
    
    parent.window.showFunctionPage(e.getAttribute("url"));
}

function leafMouseOut(elem){
}

 $('#tt').tree({
        data: eval('(' + '<%=headMenuJson %>'+ ')'),
        checkbox:false,
        cascadeCheck:false,
        onlyLeafCheck:false,
        onClick: function (node){
           var url = node.attributes;
           if(url!= "#"){
            parent.window.showFunctionPage(url);
           }
        },
        onBeforeExpand: expandChildrens
    });
    
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
      var userId = '<%=userId %>';
        var node = "";
        $.ajax({
            url:'sys_manage_tree_data.ashx',
            data:{nodeId:nodeId,userId:userId},
            async:false,
            type:"post",
            success: function (data){
                node = data;
            }
        });
        return node;
    }

</script>
