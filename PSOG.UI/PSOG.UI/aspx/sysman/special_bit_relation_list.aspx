<%@ Page Language="C#" AutoEventWireup="true" CodeFile="special_bit_relation_list.aspx.cs" Inherits="aspx_sysman_specialbit_relation_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
  
    <title>λ��װ���б�</title>
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
            url:'specialbit_relation_list_data.ashx',
            queryParams: {
                parentId: '',
                tagName:'',
                deviceName:''
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
                   <th data-options="field:'bitNo',width:240,align:'left',halign: 'center'">����</th>
                  <th data-options="field:'deviceName',width:300,align:'left',halign: 'center'">����</th>
                  <th data-options="field:'typeName',width:200,align:'center',halign: 'center'">����</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar">
         <form id="param">
            <span style="margin-left: 5px"><b>����:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
             <span style="margin-left: 5px"><b>����:</b></span>
            <input id="queryDeviceName" class="easyui-textbox"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">����</a>     
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" style="display:none" onclick="edit()">�޸�</a>                   
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">ɾ��</a>
        </div>  
    </div>  
    
    <div id="bitDiv" class="easyui-dialog" closed="true" title="λ��ѡ��" style="width: 700px; height: 450px; overflow: hidden" buttons="#bitDiv-buttons" modal="true">
        <iframe id='BitGrid' name="BitGrid" src="bit_select_list.aspx" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="bitDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelectBit();" style="width: 70px">ȷ��</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#bitDiv').dialog('close')" style="width: 70px">ȡ��</a>
        </div>
    </div>
    
    <!--�쳣���� -->
    <div id="dlg" class="easyui-dialog" title="����" style="width:400px;height:250px;padding:10px" closed="true" modal="true"
            data-options="
                iconCls: 'icon-save',
                toolbar: [{
                    text:'����',
                    iconCls:'icon-save',
                    handler:function(){
                        saveAbnormalData();
                    }
                }] ">
        <form id="fm"  method="post" action="">
           <input id="id" name="id"  style="display:none"/>
            <table cellpadding="2">
                <tr>
                    <td style="width:30%">�쳣����:</td>
                    <td><input id="tagName" name="tagName" style="width: 250px" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                <tr>
                    <td>�쳣����:</td>
                    <td>
                    <textarea  id="tagDesc" name="tagDesc"  cols="1" rows="7" style="width: 250px;height:80px;"   maxlength="300"></textarea>
                    
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>    
</html>


<script type="text/javascript"> 
//��굥�������ı���ʱ����궨���ı�����ǰ��
 function locateCursor(elem, index) {
		if (elem.setSelectionRange) {
			elem.setSelectionRange(index, index);
		} else {
			var range = elem.createTextRange();
			var len = elem.value.length;
			range.moveStart('character', -len);
			range.moveEnd('character', -len);
			range.moveStart('character', index);
			range.moveEnd('character', 0);
			range.select();
		}
	}
    
    var nodeId = "";
    var nodeType = "";
     
    //�����б�����
    function reloadGrid(id,type){
       nodeId = id;
       nodeType = type;
       
       if("type" == nodeType)
       {
           var gzType = nodeId.split('#')[1];
           if("ycgz" == gzType){
              $("#a_edit").show();
           }else{
              $("#a_edit").hide();
           }
           
           $('#dg').datagrid('load', {
             parentId:nodeId,
             tagName:"",
             deviceName:""
           });
           
       }else{
           $("#a_edit").hide();
           $('#dg').datagrid('load', {
             parentId:"",
             tagName:"",
             deviceName:""
           });
       }
       
    }
    
      //λ��ѡ��
    function append(){
         if("type" != nodeType){
            $.messager.alert('��ʾ', '����ѡ������');
            return false;
         }
         var gzType = nodeId.split('#')[1];
         if(gzType == "ycgz"){//�쳣���
              $('#dlg').dialog({
               onClose:function(){
                   $("#id").val("");
                   $("#tagName").val("");
                   $("#tagDesc")[0].value = "";
               }
             }).dialog('open').dialog('setTitle', '����');
         }else{
               $('#bitDiv').dialog({
               onClose:function(){
                 $("#BitGrid").attr("src","bit_select_list.aspx");
               }
             }).dialog('open').dialog('setTitle', 'λ��ѡ��');
             window.frames["BitGrid"].reloadGrid(nodeId, "","");
         }
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
             deviceName:""
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
            deviceName:deviceName
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
                    url : './bit_select_delete_data.ashx',
                    data : {
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
                                     deviceName:""
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
    
    //�����쳣��Ϣ
    function saveAbnormalData(){
      var tagId = $("#id").val();
      var tagName = $("#tagName").val();
      var tagDesc = $("#tagDesc")[0].value;
      if(tagName==null || tagName.length==0){
          $.messager.alert('��ʾ', '�쳣���Ʋ���Ϊ�գ�');
          return false;
      }
       $.ajax({
            url : './special_abnormalInfo_relation_data.ashx',
            data : {
                id:nodeId,
                tagId:tagId,
                tagName:tagName,
                tagDesc:tagDesc
            },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                  $('#dg').datagrid('load', {
                         parentId:nodeId,
                         tagName:"",
                         deviceName:""
                    });
                  $('#dg').datagrid('clearSelections');
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
    
    //�༭
    function edit(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('��ʾ', '��ѡ��һ�����޸ĵ�����');
              return false;
          }
          $("#id").val(rows[0].bitId);
          $("#tagName").val(rows[0].bitNo);
          $("#tagDesc")[0].value = rows[0].deviceName;
          $('#dlg').dialog({
               onClose:function(){
                   $("#tagName").val("");
                   $("#tagDesc")[0].value = "";
               }
          }).dialog('open').dialog('setTitle', '�༭');
    }
   
</script>

