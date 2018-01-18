<%@ Page Language="C#" AutoEventWireup="true" CodeFile="user_list.aspx.cs" Inherits="aspx_sysman_user_list" %>
<%@ Import Namespace="PSOG.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
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
        
        <table id="dg" style="width:auto;height:auto" fit="true" url="user_list_data.ashx"
            toolbar="#toolbar" idField="userId" pagination="true" pagesize="30" data-options="
                onClickRow: onClickRow
            "
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="userName" width="150" align="left" editor="{type:'validatebox',options:{required:true}}">用户名</th>
                    <th field="userLoginName" width="150" align="left" editor="{type:'validatebox',options:{required:true}}">登录名</th>
                    <th field="userIp" width="150" align="center" editor="text">登陆IP</th>
                    <th field="userTel" width="200" align="center" editor="text">手机号</th>
                    <th data-options="field:'userSendMessage',width:150,align:'center',halign: 'center',editor:{
                                type:'combobox',
                                required:true,
                                options:{
                                valueField: 'label',
		                        textField: 'value',
                                editable:false,
                                panelHeight:'auto',
		                        data: [{
			                        label: '全部',
			                        value: '全部'
		                        },{
			                        label: '短信',
			                        value: '短信'
		                        },{
			                    label: '微信',
			                    value: '微信'}
                                ]
                        }}">消息推送</th>
                    <th field="userId" width="0" align="right" hidden="true" editor="text"></th>
                    <th field="userOrganId" width="0" align="right" hidden="true" editor="text"></th>
                    <th field="userDeptId" width="0" align="right" hidden="true" editor="text"></th>
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
    
    function isIP(strIP) {
        if (isNull(strIP)) return false;
        var re=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g //匹配IP地址的正则表达式
        if(re.test(strIP))
        {
        if( RegExp.$1 <256 && RegExp.$2<256 && RegExp.$3<256 && RegExp.$4<256) return true;
        }
        return false;
    }
    
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
        
        if(undefined != $('#dg').datagrid('getRows')[editIndex]["userId"]) //未保存过可以直接删除
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
            url : './add_user_data.ashx',
            data : {
                userId: rowData["userId"],
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
        var curOrganCode = '' == rowData["userOrganId"] ?  userOrganCode : rowData["userOrganId"];
        var curDeptCode = '' == userDeptCode ? rowData["userDeptId"] : userDeptCode;
        
        $.ajax({
            url : './add_user_data.ashx',
            data : {
                userId: rowData["userId"],
                userIp: rowData["userIp"],
                userName: rowData["userName"],
                userLoginName: rowData["userLoginName"],
                userOrganId: curOrganCode,
                userDeptId: curDeptCode,
                userTel:rowData["userTel"],
                sendMessage:rowData["userSendMessage"],
                isDel: 0
            },
            async:false,
            type:"post",
            success : function(data) {
                var dataInfo = data.split(":");
                if("<%=CommonStr.add_succ %>" == dataInfo[0]){       
                    //修改列表数据
                    rowData["userId"] = dataInfo[1];
                    rowData["userOrganId"] = rowData["userOrganId"];
                    rowData["userDeptId"] = curDeptCode;
                                 
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
    
    function reloadGrid(organCode, deptCode, isShowButton){
        if(true == isShowButton)
        {
            $("#toolbar").css("display","");
        }else{
            $("#toolbar").css("display","none");
        }
        
        editIndex = undefined;
       userOrganCode = organCode;
       userDeptCode = deptCode;
       
       $('#dg').datagrid('load', {
            organCode: organCode,
            deptCode: deptCode

        });
    }
    
    $("#toolbar").css("display","none");
</script>
