<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menu_manage_list.aspx.cs" Inherits="aspx_sysman_menu_manage_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <% %>
    <title>用户列表</title>
    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
    </style>
</head>
<body class="easyui-layout">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
        
        <table id="dg" style="width:auto;height:auto" fit="true" url="menu_manage_list_data.ashx"
            toolbar="#toolbar" idField="menuId" pagination="false"  data-options="onClickRow: onClickRow"
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="menuName" width="100" align="left" editor="{type:'validatebox',options:{required:true}}">菜单名/装置名</th>
                    <th field="menuUrl" width="100" align="left" editor="{type:'validatebox',options:{required:true}}">菜单地址/装置编码</th>
                    <th field="menuIndex" width="100" align="left" editor="{type:'validatebox',options:{required:true}}">菜单展示顺序/装置展示顺序</th>
                    <th field="menuId" width="0" align="right" hidden="true" editor="text"></th>
                </tr>
            </thead>
        </table>
        <div id="toolbar">       
            <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">增加</a>
            <a id="a_save" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">保存</a>
            <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
        </div>
    </div>    
</body>    
</html>


<script type="text/javascript"> 
    var editIndex = undefined;
    var parentMenuCode = "";
    
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#dg').datagrid('validateRow', editIndex)){
            saveData(editIndex);
            return true;
        } else {
            return false;
        }
    }
    function onClickRow(index){
        if (editIndex != index){
            if (endEditing()){
                $('#dg').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $('#dg').datagrid('selectRow', editIndex);
            }
        }
    }
    
    function append(){
        if (endEditing()){
            $('#dg').datagrid('appendRow',{});
            editIndex = $('#dg').datagrid('getRows').length-1;
            $('#dg').datagrid('selectRow', editIndex)
                    .datagrid('beginEdit', editIndex);
        }
    }
    
    function removeit(){
        if (editIndex == undefined){
            alert("请选中要删除的记录");
            return
        }
        
        var menuId = $('#dg').datagrid('getRows')[editIndex]["menuId"]
        if(undefined != menuId) //未保存过可以直接删除
        {
            if(!window.confirm("确定要删除本记录？")){
                return ;
            }
            
            deleteData(menuId);
        }
        
        
        
        $('#dg').datagrid('cancelEdit', editIndex)
                .datagrid('deleteRow', editIndex);
        editIndex = undefined;
    }
    
    function deleteData(menuId){       
         
        $.ajax({
            url : './menu_manage_oper.ashx',
            data : {
                menuId: menuId,
                isDel: 1
            },
            async:false,
            type:"post",
            success : function(data) {               
                
                $.messager.show({
                        title : '提示',
                        msg : data
                });
                
                parent.reloadTreeNode(parentMenuCode);
            }
        });
        
    }
    
    function accept(){
        if (endEditing()){
            if(undefined != editIndex){
                saveData(editIndex);
            }
        }
    }    
        
    function saveData(indexNo){
        editIndex = undefined;
        $('#dg').datagrid('acceptChanges');
        
        var rowData = $('#dg').datagrid('getRows')[indexNo];
        
        $.ajax({
            url : './menu_manage_oper.ashx',
            data : {
                menuId: rowData["menuId"],
                menuName: rowData["menuName"],
                menuUrl: rowData["menuUrl"],
                menuIndex: rowData["menuIndex"],
                isDel: 0
            },
            async:false,
            type:"post",
            success : function(data) {
                var message = data.split(":");
                rowData["menuId"] = message[1];               
                
                
                $.messager.show({
                    title : '提示',
                    msg : message[0]
                });
                
                parent.reloadTreeNode(parentMenuCode);
            }
        });
        
    }
    
                
    
    window.onerror = function () { return true; }

    function initStyle() {
        
        $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');

    }

    $('#dg').datagrid({ onLoadSuccess: initStyle });
    
    function reloadGrid(parentMenuCodeStr, nodeType){
       editIndex = undefined;
       parentMenuCode = parentMenuCodeStr;
       
       if("plant" == nodeType)
       {
           $("#a_add").show();
           $("#a_del").show();
           
       }else{
           $("#a_add").hide();
           $("#a_del").hide();
       }
       
       $('#dg').datagrid('load', {
            parentMenuCode: parentMenuCode
        });
    }
    
    $("#a_add").hide();
    $("#a_del").hide();
</script>

