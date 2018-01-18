<%@ Page Language="C#" AutoEventWireup="true" CodeFile="abnormalDeviceConfig_select_list.aspx.cs" Inherits="abnormalDeviceConfig_select_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <%  %>
    <title></title>
    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
    </style>
</head>
<body >

    <div id="gridDiv"   style="width:100%;height:100%" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="bitId" 
        toolbar='#toolbar'   pagination="true" pagesize="10"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'bitNo',width:140,align:'left',halign: 'center'">名称</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param" action="">
            <span style="margin-left: 5px"><b>名称:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
        
     </div> 
    </div>    
</body>    
</html>


<script type="text/javascript"> 
   var typeId =  "";
   function reloadGrid(parentId){
      typeId = parentId;

       $("#dg").datagrid({
        url:'abnormalDeviceConfig_select_list_data.ashx',
        queryParams: {
            parentId: parentId,
            tagName:""
        }
       });

   }
   
   //查询
   function queryResult(){
      var bitNo = $("#queryBitNo").val();
      $('#dg').datagrid('load', {
            parentId: typeId,
            tagName:bitNo
      });
   }
   
   //清空查询条件
   function clearParam(){
     $("#queryBitNo").val("");
   }
   
   //确定选择
   function confirmSelectBit(){
     var rows = $('#dg').datagrid('getSelections');
     if(rows==null || rows.length==0){
       $.messager.alert('提示', '请至少选择一条数据');
       return false;
     }
     
     var arr = new Array();
     for(var i=0;i<rows.length;i++){
       arr.push({
         bitId:rows[i].bitId,
         bitNo:rows[i].bitNo
       });
     }
     
      $.ajax({
            url : './abnormalDeviceConfig_select_confirm_data.ashx',
            data : {
              flag:"add",
              parentId:typeId,
              bitInfo:JSON.stringify(arr)
            },
            async:false,
            type:"post",
            success : function(result) {
                 if(result=="1"){
                     window.parent.closeDialog();
                 }  else{
                    $.messager.alert('提示', '添加失败');
                 }    
            }
        });
   
   
      
   }
   
   
</script>

