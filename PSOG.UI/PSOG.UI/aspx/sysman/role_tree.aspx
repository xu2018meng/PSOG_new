<%@ Page Language="C#" AutoEventWireup="true" CodeFile="role_tree.aspx.cs" Inherits="aspx_sysman_role_tree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head>
    <title>角色树</title>
    <% 
       string userId = Request.QueryString["userId"];
         %>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        html,body, #div_tree {
            font-size:12px;
            width:100%;
            height:100%;
        }
    </style>
</head>
<body>
    <form id="form1" action="">
    <div id="div_tree" style="padding-top:10px;">
        <input type="button" id="button_save" value="保存" onclick="saveAllData();"/>
        <ul id="tt"></ul>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">
//获取所有选中的装置与菜单
    function saveAllData(){
        $("#button_save").attr("disabled", "true");
        var roleCodes = "";
        
        
        var roleNode = $('#tt').tree("getChecked");
        
        if(0 == roleNode.length){
            if(!confirm("要清空当前用户下的所有角色？")){
                return ;
            }
        }
        
        for(var i=0,size=roleNode.length; i<size; i++){
            roleCodes += roleNode[i].id + ",";
        }
        roleCodes = roleCodes.substring(0, roleCodes.length-1);     
        
         $.ajax({
            url:'save_user_role_relation_data.ashx',
            data:{roleCodes:roleCodes, userId:'<%=userId %>'},
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
    }
    
    function clickOne(node){
        var cknodes = $('#tt').tree("getChecked");
        for(var i = 0 ; i < cknodes.length ; i++){
            $('#tt').tree("uncheck", cknodes[i].target);
        }
        $('#tt').tree("check", node.target);
    }

    $('#tt').tree({
        url:'role_tree_data.ashx?userId=<%=userId %>' ,
        checkbox:true,
        cascadeCheck:false,
        onlyLeafCheck:true,
        onSelect:function(node){
            clickOne(node);
        },
        onClick:function (node){},
        onLoadSuccess : function (node){
            $("#div_tree").height("100%");
            $("body").height("100%");
            $('.tree-checkbox').each(function (){
                $(this).unbind('click');
                $(this).bind('click', function(){ clickOne(this);});
            })
        }
    });
    
</script>
