<%@ Page Language="C#" AutoEventWireup="true" CodeFile="section_equip_Config_list.aspx.cs" Inherits="section_equip_Config_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
   
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
    <script type="text/javascript">
      function initGrid(){
           
           $("#dg").datagrid({
            url:'section_equip_Config_list_data.ashx',
            queryParams: {
                parentId: '',
                type:'',
                tagName:'',
                tagDesc:''
            }
           });
     }
    </script>
</head>
<body class="easyui-layout" onload="initGrid();">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
       
       <table id="dg" style="width:auto;height:auto" fit="true" url=""
            toolbar="#toolbar" idField="sectionId" pagination="true" pagesize="20" 
            rownumbers="true" fitColumns="true" singleSelect="false">
    
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'sectionName',width:240,align:'left',halign: 'center'">编码</th>
                  <th data-options="field:'sectionDesc',width:300,align:'left',halign: 'center'">名称</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param">
            <span style="margin-left: 5px"><b>编码:</b></span>
            <input id="queryName"  class="easyui-textbox" />
             <span style="margin-left: 5px"><b>名称:</b></span>
            <input id="queryDesc" class="easyui-textbox"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addSectionEquip()">新增</a>      
            <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="edit()">修改</a>                 
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
        </div>  
    </div>  
   
    <!--工段-->
     <div id="dlg" class="easyui-dialog" title="工段" style="width:500px;height:350px;padding:10px;text-align:center;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveData();
                    }
                }] ">
        <form id="fm"  method="post" action="" style="padding-top:10px;">
          <input id="sectionId" name="sectionId"  style="display:none"/>
            <table cellpadding="2">
                <tr style="height:40px;">
                    <td style="width:100px;">名称:</td>
                    <td><input id="sectionName" name="sectionName" style="width: 305px;height:23px;" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                 <tr style="height:60px;">
                    <td style="width:100px">描述:</td>
                    <td><input id="sectionDesc" name="sectionDesc" style="width: 305px;height:23px;" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                <tr style="height:40px;">
                    <td style="width:100px">备注:</td>
                    <td>
                    <textarea  id="sectionMark" name="sectionMark"  cols="1" rows="7" style="width: 300px;height:80px;"   maxlength="300">
                    </textarea>
                    
                    </td>
                </tr>
            </table>        
        </form>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 
    var nodeId = "";
    var nodeType = "";
    var queryType = "";
    var curNode = null;
     
    //加载列表数据
    function reloadGrid(id,type,node){
       nodeId = id;
       nodeType = type;
       curNode = node;
       
       if("plant" == nodeType)
       {
           queryType = "section";
           $('#dg').datagrid('load', {
             parentId:nodeId,
             type:queryType,
             tagName:"",
             tagDesc:""
           });
       }else if("unit" == nodeType){
           queryType = "device";
           $('#dg').datagrid('load', {
             parentId:nodeId,
             type:queryType,
             tagName:"",
             tagDesc:""
           });
       }else{
           queryType = "";
           $('#dg').datagrid('load', {
             parentId:"",
             type:queryType,
             tagName:"",
             tagDesc:""
           });
       }
       
    }
    
    
    //查询
    function queryResult(){
       var tagName = $("#queryName").val();
       var tagDesc = $("#queryDesc").val();
      $('#dg').datagrid('load', {
            parentId: nodeId,
            type:queryType,
            tagName:tagName,
            tagDesc:tagDesc
      });
    }
    
    //清空查询条件
    function clearParam(){
       $("#queryName").val("");
       $("#queryDesc").val("");
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
           arr.push(rows[i].sectionId);
         }
         
         $.messager.confirm('Confirm', '确定要删除吗?', function (r) {
           if(r){
               $.ajax({
                    url : './section_equip_deal_data.ashx',
                    data : {
                      flag:"delete",
                      parentId:nodeId,
                      type:queryType,
                      sectionInfo:JSON.stringify(arr)
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         if(result=="1"){
                              window.parent.reloadTreeNode(curNode);
                              $('#dg').datagrid('clearSelections');
                              $('#dg').datagrid('load', {
                                    parentId: nodeId,
                                    type:queryType,
                                    tagName:"",
                                    tagDesc:""
                              });     
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
    
    //新增工段设备
    function addSectionEquip(){
       if("plant" != nodeType && "unit" != nodeType){
            $.messager.alert('提示', '请先选择装置或工段');
            return false;
       }
       
       if("plant" == nodeType){
           $('#dlg').dialog({
                   onClose:function(){
                       $("#sectionId").val("");
                       $("#sectionName").val("");
                       $("#sectionDesc").val("");
                       $("#sectionMark")[0].value = "";
                   }
                 }).dialog('open').dialog('setTitle', '新增工段');
       
       }else{
          $('#dlg').dialog({
                        onClose:function(){
                           $("#sectionId").val("");
                           $("#sectionName").val("");
                           $("#sectionDesc").val("");
                           $("#sectionMark")[0].value = "";
                        }
                     }).dialog('open').dialog('setTitle', '新增设备');
       }
       
    }
    
    //保存工段信息
   function saveData(){
        var sectionId = $("#sectionId").val();
        var sectionName = $("#sectionName").val();
        var sectionDesc = $("#sectionDesc").val();
        var sectionMark = $("#sectionMark")[0].value;
        if(sectionName==null || sectionName.length<=0 || sectionDesc==null || sectionDesc.length<=0){
            $.messager.alert('提示', '名称和描述不能为空');
            return false;
        }
        
        $.ajax({
            url : './section_equip_deal_data.ashx',
            data :{
                flag:"save",
                parentId:nodeId,
                type:queryType,
                sectionId:sectionId,
                sectionName:sectionName,
                sectionDesc:sectionDesc,
                sectionMark:sectionMark
            },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                   window.parent.reloadTreeNode(curNode);
                   
                   $('#dg').datagrid('clearSelections');
                   $('#dg').datagrid('load', {
                        parentId: nodeId,
                        type:queryType,
                        tagName:"",
                        tagDesc:""
                   });
                   
                   
               
                   $('#dlg').dialog('close');
                   $.messager.show({
                        title : '提示',
                        msg : "保存成功"
                   });   
                   
                }else{
                    $.messager.show({
                        title : '提示',
                        msg : "保存失败"
                    });   
                }            
            }
        });
   } 
   
   //修改
   function edit(){
      var rows = $('#dg').datagrid('getSelections');
      if(rows == null || rows.length!=1){
          $.messager.alert('提示', '请选择一条待修改的数据');
          return false;
      }
   
     $("#sectionId").val(rows[0].sectionId);
     $("#sectionName").val(rows[0].sectionName);
     $("#sectionDesc").val(rows[0].sectionDesc);
     $("#sectionMark")[0].value = rows[0].sectionMark;
      if("plant" == nodeType){
           $('#dlg').dialog({
                   onClose:function(){
                       $("#sectionId").val("");
                       $("#sectionName").val("");
                       $("#sectionDesc").val("");
                       $("#sectionMark")[0].value = "";
                   }
                 }).dialog('open').dialog('setTitle', '编辑工段');
       
       }else{
          $('#dlg').dialog({
                        onClose:function(){
                           $("#sectionId").val("");
                           $("#sectionName").val("");
                           $("#sectionDesc").val("");
                           $("#sectionMark")[0].value = "";
                        }
                     }).dialog('open').dialog('setTitle', '编辑设备');
       }
        
   }
   
</script>

