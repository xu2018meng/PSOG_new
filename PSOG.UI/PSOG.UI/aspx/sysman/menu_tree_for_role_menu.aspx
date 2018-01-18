<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menu_tree_for_role_menu.aspx.cs" Inherits="aspx_sysman_menu_tree_for_role_menu" %>
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
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        body {
            font-size:12px;
        }
    </style>
</head>
<body>
    <form id="form1" action="" style="padding: 8px">
        <input type="button" id="button_save" value="保存" onclick="saveAllData();"/>
        <div style="vertical-align:bottom">
            <label>装置<span style="color:red">*</span>：</label>&nbsp;
                <% foreach (Plant plant in plantList)
                   {
                       if (true == plant.isChecked)
                       {%>
                   <input type="checkbox" class="checkbox_plant" value="<%=plant.id %>" checked="checked" /><%=plant.organtreeName%>&nbsp;
                   <% }else{ %>
                   <input type="checkbox" class="checkbox_plant" value="<%=plant.id %>"  /><%=plant.organtreeName%>&nbsp;
                <% }
               }%>
        </div>
        <div style="margin-top:10px;">
            <ul id="tt"></ul>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    
    //获取所有选中的装置与菜单
    function saveAllData(){
        $("#button_save").attr("disabled", "true");
        var plants = "";
        var menuCodes = "";
        $(".checkbox_plant:checked").each(function (){
            if("" == plants) {
                plants = $(this).val();
            }
            else{
                plants += "," + $(this).val();
            }
        });
        
        if("" == plants){
            alert("请选择装置！");
            return ;
        }
        
        var menuNode = $('#tt').tree("getChecked");
        
        if(0 == menuNode.length){
            if(!confirm("要清空所有角色下的所有菜单？")){
                return ;
            }
        }
        
        for(var i=0,size=menuNode.length; i<size; i++){
            menuCodes += menuNode[i].id + ",";
        }
        menuCodes = menuCodes.substring(0, menuCodes.length-1);     
        
        menuCodes = plants + "," + menuCodes
         $.ajax({
            url:'save_role_menu_relation_data.ashx',
            data:{menuCodes:menuCodes,roleCode:'<%=roleId %>'},
            async:true,
            type:"post",
            success: function (data){
                $("#button_save").attr("disabled", false);
                $.messager.show({
                    title:'提示',
                    msg:data
                });
            }
         });
        return plants + "," + menuCodes;
    }

    $('#tt').tree({
        data: eval('(' + '<%=headMenuJson %>'+ ')'),
        checkbox:true,
        cascadeCheck:false,
        onlyLeafCheck:false,
        onClick: function (node){
            if("closed" == node.state && "0" != node.attributes)
            {
                $('#tt').tree("expandAll", node.target);
                //expandChildrens(node);
            }
            else
            {
                $('#tt').tree("collapseAll", node.target);
            }
        },
        onBeforeExpand: expandChildrens
    });
    
    $('#tt').tree("expandAll");
    
    function expandChildrens(node){    //展开节点
        var childNodes = $('#tt').tree("getChildren", node.target);
        if(0 == childNodes.length){
            var nodes = getChildNodes(node.id); //h后台获取子节点
            $('#tt').tree("append", {parent: node.target, data:eval("(" + nodes + ")"),onBeforeExpand: expandChildrens});
            $('#tt').tree("expandAll");
        }
        return true;
    }     
    
    //获取子节点
    function getChildNodes(nodeId){
        var node = "";
        $.ajax({
            url:'menu_tree_for_role_menu_data.ashx',
            data:{nodeId:nodeId,roleId:'<%=roleId %>'},
            async:false,
            type:"post",
            success: function (data){
                node = data;
            }
        });
        return node;
    }
    
</script>

