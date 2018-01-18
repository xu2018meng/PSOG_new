<%@ Page Language="C#" AutoEventWireup="true" CodeFile="graphic_bit_select_list.aspx.cs" Inherits="graphic_bit_select_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <%  %>
    <title>位号选择列表</title>
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

    <div id="gridDiv"  style="width:100%;height:100%" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="bitId" 
        toolbar='#toolbar'   pagination="true" pagesize="10"  rownumbers="true"  fitColumns="true" singleSelect="true" >
         <thead>
                <tr>
                   <th data-options="field:'bitNo',width:140,align:'left',halign: 'center'">位号</th>
                  <th data-options="field:'deviceName',width:140,align:'left',halign: 'center'">描述</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param" action="">
            <span style="margin-left: 5px"><b>位号:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
             <span style="margin-left: 5px"><b>描述:</b></span>
            <input id="queryDeviceName" class="easyui-textbox"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
        
     </div> 
    </div>    
</body>    
</html>


<script type="text/javascript"> 
   var typeId =  "";
   function reloadGrid(parentId,tagName,deviceName){
      typeId = parentId;

       $("#dg").datagrid({
        url:'graphic_bit_select_list_data.ashx',
        queryParams: {
            parentId: parentId,
            tagName:tagName,
            deviceName:deviceName
        }
       });

   }
   
   //查询
   function queryResult(){
      var bitNo = $("#queryBitNo").val();
      var deviceName = $("#queryDeviceName").val();
      $('#dg').datagrid('load', {
            parentId: typeId,
            tagName:bitNo,
            deviceName:deviceName
      });
   }
   
   //清空查询条件
   function clearParam(){
     $("#queryBitNo").val("");
     $("#queryDeviceName").val("");
   }
   
   //确定选择
   function confirmSelectBit(){
     var rows = $('#dg').datagrid('getSelected');
     if(rows==null || rows.length==0){
       $.messager.alert('提示', '请选择一条数据');
       return false;
     }
    
     window.parent.closeBitSelectDiv(rows.bitNo);
      
   }
   
   
</script>

