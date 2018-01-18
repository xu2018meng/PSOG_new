<%@ Page Language="C#" AutoEventWireup="true" CodeFile="abnormalDeviceConfig_list.aspx.cs" Inherits="abnormalDeviceConfig_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <%  %>
    <title>设备报警点列表</title>
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
    <script type="text/javascript">
      function initGrid(){
           
           $("#dg").datagrid({
            url:'abnormalDeviceConfig_list_data.ashx',
            queryParams: {
                parentId: '',
                tagName:'',
                tagDesc:''
            }
           });
     }
    </script>
</head>
<body class="easyui-layout" onload="initGrid();">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
    <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="bitId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'bitNo',width:240,align:'left',halign: 'center'">名称</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param">
            <span style="margin-left: 5px"><b>名称:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">增加</a>                       
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
        </div>  
    </div>  
    
    <div id="bitDiv" class="easyui-dialog" closed="true" title="异常点选择" style="width: 700px; height: 450px; overflow: hidden" buttons="#bitDiv-buttons" modal="true">
        <iframe id='BitGrid' name="BitGrid" src="abnormalDeviceConfig_select_list.aspx" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="bitDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelectBit();" style="width: 70px">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#bitDiv').dialog('close')" style="width: 70px">取消</a>
        </div>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 
    var nodeId = "";
    var nodeType = "";
     
    //加载列表数据
    function reloadGrid(id,type){
       nodeId = id;
       nodeType = type;
       
       if("device" == nodeType)
       {
           $('#dg').datagrid('load', {
             parentId:nodeId,
             tagName:""
           });
           
       }else{
           $('#dg').datagrid('load', {
             parentId:"",
             tagName:""
           });
       }
       
    }
    
      //位号选择
    function append(){
         if("device" != nodeType){
            $.messager.alert('提示', '请先选择设备');
            return false;
         }
         $('#bitDiv').dialog({
               onClose:function(){
                 $("#BitGrid").attr("src","abnormalDeviceConfig_select_list.aspx");
               }
             }).dialog('open').dialog('setTitle', '报警点选择');
         window.frames["BitGrid"].reloadGrid(nodeId);
    }
    
    //确定选择
    function confirmSelectBit(){
       window.frames["BitGrid"].confirmSelectBit();
    }
    
    
    //关闭选择框
    function closeDialog(){
        $('#dg').datagrid('load', {
             parentId:nodeId,
             tagName:""
        });
       $('#bitDiv').dialog('close');
    }
    
    //查询
    function queryResult(){
       var bitNo = $("#queryBitNo").val();
       var deviceName = $("#queryDeviceName").val();
      $('#dg').datagrid('load', {
            parentId: nodeId,
            tagName:bitNo
      });
    }
    
    //清空查询条件
    function clearParam(){
       $("#queryBitNo").val("");
    }
    
    //删除
    function removeit(){
         var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('提示', '请至少选择一条待删除的数据','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].bitId);
         }
         
         $.messager.confirm('Confirm', '确定要删除吗?', function (r) {
           if(r){
               $.ajax({
                    url : './abnormalDeviceConfig_select_confirm_data.ashx',
                    data : {
                      flag:"delete",
                      parentId:nodeId,
                      bitInfo:JSON.stringify(arr)
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         if(result=="1"){
                               $('#dg').datagrid('load', {
                                     parentId:nodeId,
                                     tagName:""
                                });
                              $('#dg').datagrid('clearSelections');
                              $.messager.show({
                                 title : '提示',
                                 msg : "删除成功"
                               });   
                         }  else{
                            $.messager.alert('提示', '删除失败');
                         }    
                    }
                });
           }
            
          });
    }
    
</script>

