<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarmDeviceConfig_list.aspx.cs" Inherits="alarmDeviceConfig_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <% %>
    <title>�豸�������б�</title>
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
            url:'alarmDeviceConfig_list_data.ashx',
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
       
       <table id="dg" style="width:auto;height:auto" fit="true" url=""
            toolbar="#toolbar" idField="bitId" pagination="true" pagesize="20" 
            rownumbers="true" fitColumns="true" singleSelect="false">
    
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'bitNo',width:240,align:'left',halign: 'center'">λ��</th>
                  <th data-options="field:'deviceName',width:300,align:'left',halign: 'center'">����</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param">
            <span style="margin-left: 5px"><b>λ��:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
             <span style="margin-left: 5px"><b>����:</b></span>
            <input id="queryDeviceName" class="easyui-textbox"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">����</a>                       
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">ɾ��</a>
           <a id="a1" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openRunIndexDialog()">״̬��������</a>                       
        </div>  
    </div>  
    
    <div id="bitDiv" class="easyui-dialog" closed="true" title="������ѡ��" style="width: 700px; height: 450px; overflow: hidden" buttons="#bitDiv-buttons" modal="true">
        <iframe id='BitGrid' name="BitGrid" src="alarmDeviceConfig_select_list.aspx" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="bitDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelectBit();" style="width: 70px">ȷ��</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#bitDiv').dialog('close')" style="width: 70px">ȡ��</a>
        </div>
    </div>
    
    <!--״̬��������-->
     <div id="dlg" class="easyui-dialog" title="����" style="width:340px;height:200px;padding:10px;text-align:center;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-save',
                toolbar: [{
                    text:'����',
                    iconCls:'icon-save',
                    handler:function(){
                        saveRunIndexData();
                    }
                }] ">
        <form id="fm"  method="post" action="" style="padding-top:30px;">
                      <input id="runId" name="runId"  style="display:none"/>
            ״̬������<input id="runIndex" name="runIndex" class="easyui-combobox" style="width:200px; height: 25px;" data-options="
		                        valueField: 'value',
		                        textField: 'text',
		                        panelHeight:'auto'
		                         "/> 
        </form>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 
    var nodeId = "";
    var nodeType = "";
     
    //�����б�����
    function reloadGrid(id,type){
       nodeId = id;
       nodeType = type;
       
       if("device" == nodeType)
       {
           $('#dg').datagrid('load', {
             parentId:nodeId,
             tagName:"",
             tagDesc:""
           });
           
           $.ajax({
                url : './alarmDeviceConfig_PCADict_data.ashx',
                data : {
                    flag:'selectDict',
                    parentId:id
                 },
                async:false,
                type:"post",
                success : function(data) {
                  var PCAJson = eval('('+data+')');
                  $("#runIndex").combobox("loadData",PCAJson);       
                }
            });
           
       }else{
           $('#dg').datagrid('load', {
             parentId:"",
             tagName:"",
             tagDesc:""
           });
       }
       
    }
    
      //λ��ѡ��
    function append(){
         if("device" != nodeType){
            $.messager.alert('��ʾ', '����ѡ���豸');
            return false;
         }
         $('#bitDiv').dialog({
               onClose:function(){
                 $("#BitGrid").attr("src","alarmDeviceConfig_select_list.aspx");
               }
             }).dialog('open').dialog('setTitle', '������ѡ��');
         window.frames["BitGrid"].reloadGrid(nodeId);
    }
    
    //ȷ��ѡ��
    function confirmSelectBit(){
       window.frames["BitGrid"].confirmSelectBit();
    }
    
    
    //�ر�ѡ���
    function closeDialog(){
        $('#dg').datagrid('load', {
             parentId:nodeId,
             tagName:"",
             tagDesc:""
        });
       $('#bitDiv').dialog('close');
    }
    
    //��ѯ
    function queryResult(){
       var bitNo = $("#queryBitNo").val();
       var deviceName = $("#queryDeviceName").val();
      $('#dg').datagrid('load', {
            parentId: nodeId,
            tagName:bitNo,
            tagDesc:deviceName
      });
    }
    
    //��ղ�ѯ����
    function clearParam(){
       $("#queryBitNo").val("");
       $("#queryDeviceName").val("");
    }
    
    //ɾ��
    function removeit(){
         var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('��ʾ', '������ѡ��һ����ɾ��������','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].bitId);
         }
         
         $.messager.confirm('Confirm', 'ȷ��Ҫɾ����?', function (r) {
           if(r){
               $.ajax({
                    url : './alarmDeviceConfig_select_confirm_data.ashx',
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
                                     tagName:"",
                                     tagDesc:""
                                });
                              $('#dg').datagrid('clearSelections');
                              $.messager.show({
                                 title : '��ʾ',
                                 msg : "ɾ���ɹ�"
                               });   
                         }  else{
                            $.messager.alert('��ʾ', 'ɾ��ʧ��');
                         }    
                    }
                });
           }
            
          });
    }
    
    //������ָ������ҳ��
    function openRunIndexDialog(){
       if("device" != nodeType){
            $.messager.alert('��ʾ', '����ѡ���豸');
            return false;
       }
       
        $.ajax({
                url : './alarmDeviceConfig_PCADict_data.ashx',
                data : {
                    flag:'selectRunIndex',
                    parentId:nodeId
                 },
                async:false,
                type:"post",
                success : function(data) {
                  var paramDict = eval('('+data+')');
                  $("#runId").val(paramDict.id);
                  $("#runIndex").combobox("setValue",paramDict.pcaId);       
                }
            });
       
        $('#dlg').dialog({
               onClose:function(){
                   $("#runId").val("");
                   $("#runIndex").combobox("setValue","");
               }
             }).dialog('open').dialog('setTitle', '״̬��������');
    }
    
    //��������ָ��������Ϣ
   function saveRunIndexData(){
        var runId = $("#runId").val();
        var pcaId = $("#runIndex").combobox("getValue");
        var pcaName = $("#runIndex").combobox("getText");
        if(pcaId==null || pcaId.length<=0){
            $.messager.alert('��ʾ', '��ѡ��״̬����');
            return false;
        }
        
        $.ajax({
            url : './alarmDeviceConfig_PCADict_data.ashx',
            data :{
                flag:"save",
                parentId:nodeId,
                runId:runId,
                pcaId:pcaId,
                pcaName:pcaName
            },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                   $('#dlg').dialog('close');
                   $.messager.show({
                        title : '��ʾ',
                        msg : "����ɹ�"
                   });   
                   
                }else{
                    $.messager.show({
                        title : '��ʾ',
                        msg : "����ʧ��"
                    });   
                }            
            }
        });
   } 
    
</script>

