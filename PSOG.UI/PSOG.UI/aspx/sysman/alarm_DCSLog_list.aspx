<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_DCSLog_list.aspx.cs" Inherits="alarm_DCSLog_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <%  %>
    <title>DCS������־�б�</title>
    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script language="javascript" type="text/javascript" src="../../resource/js/WdatePicker.js"></script>
    <link type="text/css" rel="stylesheet" href="../../resource/css/calendar.css" />
    <link href="../../resource/uploadify-v3.1/uploadify.css" rel="stylesheet" />
    <script src="../../resource/uploadify-v3.1/jquery.uploadify-3.1.min.js"></script>
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
        .lable{
           width:90px;
           text-align:right;
        }
        .input{
          width:240px;
          height:23px;
        }
        .tr{
          height:35px;
        }
    </style>
    <script type="text/javascript">
      function initGrid(){
           $("#dg").datagrid({
            url:'alarm_DCSLog_list_data.ashx',
            queryParams: {
                plantId: '',
                tagName:'',
                startDate:'',
                endDate:''
            }
           });
     }
    </script>
</head>
<body class="easyui-layout" onload="initGrid();">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
       
       <table id="dg" style="width:auto;height:auto" fit="true" url=""
            toolbar="#toolbar" idField="alarmLogId" pagination="true" pagesize="20" 
            rownumbers="true" fitColumns="true" singleSelect="false">
    
         <thead>
                <tr>
                   <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'alarmLogBitCode',width:150,align:'left',halign: 'center'">λ��</th>
                  <th data-options="field:'alarmLogDescribe',width:320,align:'left',halign: 'center'">����</th>
                   <th data-options="field:'alarmLogState',width:120,align:'center',halign: 'center'">״̬</th>
                  <th data-options="field:'alarmLogStartTime',width:160,align:'center',halign: 'center'">��ʼʱ��</th>
                   <th data-options="field:'alarmLogEndTime',width:160,align:'center',halign: 'center'">����ʱ��</th>
                  <th data-options="field:'alarmLogRank',width:120,align:'center',halign: 'center'">�����ȼ�</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:4px;">
         <form id="param">
            <span style="margin-left: 5px"><b>λ��:</b></span>
            <input id="queryBitNo"  class="easyui-textbox"  style="width:130px;height:18px;"/>
            <span style="margin-left: 15px"><b>��ʼʱ��:</b></span>
             <input type="text" id="queryStartDate" name="queryStartDate" style="width:145px;" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
             <span style=""><b>��</b></span>
               <input type="text" id="queryEndDate" name="queryEndDate" style="width:145px;"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload',plain:true" onclick="append()">�ϴ�</a>     
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delData()">ɾ��</a>     
        </div>  
    </div>  
    
    <!--���뵥 -->
  <div id="dlg" class="easyui-dialog" title="����" style="width:750px;height:520px;padding:10px" closed="true" modal="true"
            data-options="
                iconCls: 'icon-upload',
                toolbar: [{
                    text:'����',
                    iconCls:'icon-save',
                    handler:function(){
                        saveData();
                    }
                }] ">
        <form id="fm"  method="post" action="">
            <div id="td_file">
                <input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>
            </div>
            <table id="upTb" style="width:100%;height:auto;" fit="true" url=""
            idField="alarmLogId"  pagination="true" pagesize="20" 
             rownumbers="true" fitColumns="true" singleSelect="false">
             <thead>
             
                    <tr>
                       <th data-options="field:'alarmLogBitCode',width:150,align:'left',halign: 'center'">λ��</th>
                      <th data-options="field:'alarmLogDescribe',width:320,align:'left',halign: 'center'">����</th>
                       <th data-options="field:'alarmLogState',width:120,align:'center',halign: 'center'">״̬</th>
                      <th data-options="field:'alarmLogStartTime',width:200,align:'center',halign: 'center'">��ʼʱ��</th>
                       <th data-options="field:'alarmLogEndTime',width:200,align:'center',halign: 'center'">����ʱ��</th>
                      <th data-options="field:'alarmLogRank',width:120,align:'center',halign: 'center'">�����ȼ�</th>
                    </tr>
                </thead>
        </table>
                
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
       
       if("plant" == nodeType)
       {
           $('#dg').datagrid('load', {
             plantId:nodeId,
             tagName:'',
             startDate:'',
             endDate:''
           });
           
       }else{
           $('#dg').datagrid('load', {
             plantId:'',
             tagName:'',
             startDate:'',
             endDate:''
           });
       }
    }
    
    
    //��ѯ
    function queryResult(){
       var bitNo = $("#queryBitNo").val();
       var startDate = $("#queryStartDate").val();
       var endDate = $("#queryEndDate").val();
       $('#dg').datagrid('load', {
            plantId: nodeId,
            tagName:bitNo,
            startDate:startDate,
            endDate:endDate
       });
    }
    
    //��ղ�ѯ����
    function clearParam(){
       $("#queryBitNo").val("");
       $("#queryStartDate").val("");
       $("#queryEndDate").val("");
    }
    
    //���ϴ���
    function append(){
        if("plant" != nodeType){
           $.messager.alert('��ʾ', '����ѡ��װ��');
           return false;
        }
        initFileUpload();
        
         $("#upTb").datagrid({
            url:'alarm_DCSLog_list_deal.ashx?flag=grid'
           });
        
        $('#dlg').dialog({
           onClose:function(){ 
              $.ajax({
                    url : './alarm_DCSLog_list_deal.ashx?flag=delTempFileData',
                    data : {
                      filePath:initFilePath,
                      flagId:initFlagId,
                      plantId:nodeId
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                        
                    }
               });
               
             initFilePath = "";
             initFlagId = "";
             initStartTime = "";
             initEndTime = "";
             document.getElementById("td_file").innerHTML = "";
             $("#td_file").append('<input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>');
             
             
           }
        }).dialog('open').dialog('setTitle', '�ϴ�');
    }
    
   var initFilePath = "";
   var initFlagId = "";
   var initStartTime = "";
   var initEndTime = "";
   function initFileUpload() {
     $('#file_upload').uploadify(
        {
            'buttonText': 'ѡ���ļ�',
            'swf': '../../resource/uploadify-v3.1/uploadify.swf',
            'uploader': 'alarm_DCSLog_list_deal.ashx',
            'method': 'get',
            auto: false,
            multi: false,
            fileTypeExts: '*.txt',
            removeCompleted: false,
            'onCancel': function (file) {
                queueSize = queueSize - 1;
            },
            'onDialogClose': function (swfuploadifyQueue) {
                  queueSize = swfuploadifyQueue.queueLength;
                  //���渽��
                  $("#file_upload").uploadify("settings", "formData", {'flag':'upload' });
                  $('#file_upload').uploadify('upload', '*');
            },
            onUploadSuccess: function (file, data, response) {
               initFilePath = data;
               $.ajax({
                    url : './alarm_DCSLog_list_deal.ashx?flag=uploadDCSLog',
                    data : {
                      filePath:data,
                      plantId:nodeId,
                      paramFlagId:initFlagId
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                        if(result!=null){
                            var resultInfo = result.split('#');
                            initFlagId = resultInfo[0];
                            if(initStartTime.length<=0 || resultInfo[1]<initStartTime){
                                 initStartTime = resultInfo[1];
                            }
                            
                            if(initEndTime<=0 || resultInfo[2]>initEndTime){
                                 initEndTime = resultInfo[2];
                            }
                           
                               
                            $("#upTb").datagrid({
                                url:'alarm_DCSLog_list_deal.ashx?flag=dataGrid',
                                queryParams: {
                                    plantId: nodeId,
                                    flagId:initFlagId
                                }
                           });
                           
                           
                           
                        }
                    }
               });
            }
        });
  }
  
  //������־
  function saveData(){
      if(initFlagId == ""){
         $.messager.alert('��ʾ', '�����ϴ���־�ļ�','info');
         return false;
      }
      //���жϸö�ʱ����DCS��־�Ƿ��Ѿ�����
       $.ajax({
            url : './alarm_DCSLog_list_deal.ashx?flag=isExistDCS',
            data : {
                      plantId:nodeId,
                      initStartTime:initStartTime,
                      initEndTime:initEndTime
                    },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                     $.messager.confirm('Confirm', '��ʱ����ڵ�DCS������־�Ѵ��ڣ�ȷ��Ҫ������?', function (r) {
                      if(r){
                         saveDCSLog();  
                      }else{
                          $('#dlg').dialog('close'); 
                      }
                    
                     });
          
                 
                }else{
                    saveDCSLog();  
                }             
            }
      }); 
     
  } 
  
  function saveDCSLog(){
        $.ajax({
            url : './alarm_DCSLog_list_deal.ashx?flag=saveDCS',
            data : {
                      flagId:initFlagId,
                      plantId:nodeId,
                      initStartTime:initStartTime,
                      initEndTime:initEndTime
                    },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                  $('#dg').datagrid('load', {
                     plantId:nodeId,
                     tagName:'',
                     startDate:'',
                     endDate:''
                   });
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
  
  //ɾ����־
  function delData(){
      var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('��ʾ', '������ѡ��һ����ɾ��������','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].alarmLogId);
         }
         
         $.messager.confirm('Confirm', 'ȷ��Ҫɾ����?', function (r) {
           if(r){
               $.ajax({
                    url : './alarm_DCSLog_list_deal.ashx?flag=delDCS',
                    data : {
                      flag:"delDCS",
                      plantId:nodeId,
                      logInfo:JSON.stringify(arr)
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         if(result=="1"){
                              $('#dg').datagrid('load', {
                                 plantId:nodeId,
                                 tagName:'',
                                 startDate:'',
                                 endDate:''
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
   
</script>

