<%@ Page Language="C#" AutoEventWireup="true" CodeFile="role_manage_list.aspx.cs" Inherits="aspx_sysman_role_manage_list" %>

<%@ Import Namespace="PSOG.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html >
<head id="Head1">
   
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
    <!-- #include file="../include_loading.aspx" -->  
        <table id="dg" style="width:auto;height:auto" fit="true" url="role_manage_data.ashx"
            toolbar="#toolbar" idField="roleId"  data-options="onClickRow: onClickRow"
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="roleName" width="200" align="left" editor="{type:'validatebox',options:{required:true}}">角色名</th>
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
    var userOrganCode = "";
    var userDeptCode = "";
    
    
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
            $('#dg').datagrid('appendRow',{status:'P'});
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
        
        if(undefined != $('#dg').datagrid('getRows')[editIndex]["roleId"]) //未保存过可以直接删除
        {
            if(!window.confirm("确定要删除本记录？")){
                return ;
            }
            
            deleteData(editIndex);
        }        
        
        
        $('#dg').datagrid('cancelEdit', editIndex)
                .datagrid('deleteRow', editIndex);
        editIndex = undefined;
    }
    function accept(){
        if (endEditing()){
            if(undefined != editIndex){
                saveData(editIndex);
            }
        }
    }
    
    function deleteData(indexNo){       
        var rowData = $('#dg').datagrid('getRows')[indexNo];
         
        $.ajax({
            url : './role_manage_oper.ashx',
            data : {
                roleId: rowData["roleId"],
                isDel: 1
            },
            async:false,
            type:"post",
            success : function(data) {
                $.messager.show({
                        title : '提示',
                        msg : data
                });
            }
        });
        
    }
    
    function saveData(indexNo){
        editIndex = undefined;
        $('#dg').datagrid('acceptChanges');
        
        var rowData = $('#dg').datagrid('getRows')[indexNo];
        
        $.ajax({
            url : './role_manage_oper.ashx',
            data : {
                roleId: rowData["roleId"],
                roleName: rowData["roleName"],
                isDel: 0
            },
            async:false,
            type:"post",
            success : function(data) {
                var dataInfo = data.split(":");
                if("<%=CommonStr.add_succ %>" == dataInfo[0]){       
                    //修改列表数据
                    rowData["roleId"] = dataInfo[1];
                                 
                    $.messager.show({
                            title : '提示',
                            msg : "保存成功！"
                    });
                }else if("<%=CommonStr.add_fail %>" == dataInfo[0]){
                    $.messager.show({
                            title : '提示',
                            msg : "保存失败！"
                    });
                }else{
                    $.messager.show({
                            title : '提示',
                            msg : dataInfo[0]
                    });
                    onClickRow(indexNo);//重新激活编辑
                    return;
                }
                
                
                
            }
        });
        
    }
    function reject(){
        $('#dg').datagrid('rejectChanges');
        editIndex = undefined;
    }
                
    
    window.onerror = function () { return true; }

    function initStyle() {
        
        $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');

    }

    $('#dg').datagrid({ onLoadSuccess: initStyle });
    
</script>
