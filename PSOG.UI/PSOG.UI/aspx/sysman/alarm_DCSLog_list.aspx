<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_DCSLog_list.aspx.cs" Inherits="alarm_DCSLog_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <%  %>
    <title>DCS报警日志列表</title>
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
                   <th data-options="field:'alarmLogBitCode',width:150,align:'left',halign: 'center'">位号</th>
                  <th data-options="field:'alarmLogDescribe',width:320,align:'left',halign: 'center'">描述</th>
                   <th data-options="field:'alarmLogState',width:120,align:'center',halign: 'center'">状态</th>
                  <th data-options="field:'alarmLogStartTime',width:160,align:'center',halign: 'center'">开始时间</th>
                   <th data-options="field:'alarmLogEndTime',width:160,align:'center',halign: 'center'">结束时间</th>
                  <th data-options="field:'alarmLogRank',width:120,align:'center',halign: 'center'">报警等级</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:4px;">
         <form id="param">
            <span style="margin-left: 5px"><b>位号:</b></span>
            <input id="queryBitNo"  class="easyui-textbox"  style="width:130px;height:18px;"/>
            <span style="margin-left: 15px"><b>开始时间:</b></span>
             <input type="text" id="queryStartDate" name="queryStartDate" style="width:145px;" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
             <span style=""><b>至</b></span>
               <input type="text" id="queryEndDate" name="queryEndDate" style="width:145px;"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-upload',plain:true" onclick="append()">上传</a>     
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delData()">删除</a>     
        </div>  
    </div>  
    
    <!--申请单 -->
  <div id="dlg" class="easyui-dialog" title="新增" style="width:750px;height:520px;padding:10px" closed="true" modal="true"
            data-options="
                iconCls: 'icon-upload',
                toolbar: [{
                    text:'保存',
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
                       <th data-options="field:'alarmLogBitCode',width:150,align:'left',halign: 'center'">位号</th>
                      <th data-options="field:'alarmLogDescribe',width:320,align:'left',halign: 'center'">描述</th>
                       <th data-options="field:'alarmLogState',width:120,align:'center',halign: 'center'">状态</th>
                      <th data-options="field:'alarmLogStartTime',width:200,align:'center',halign: 'center'">开始时间</th>
                       <th data-options="field:'alarmLogEndTime',width:200,align:'center',halign: 'center'">结束时间</th>
                      <th data-options="field:'alarmLogRank',width:120,align:'center',halign: 'center'">报警等级</th>
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
     
    //加载列表数据
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
    
    
    //查询
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
    
    //清空查询条件
    function clearParam(){
       $("#queryBitNo").val("");
       $("#queryStartDate").val("");
       $("#queryEndDate").val("");
    }
    
    //打开上传框
    function append(){
        if("plant" != nodeType){
           $.messager.alert('提示', '请先选择装置');
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
        }).dialog('open').dialog('setTitle', '上传');
    }
    
   var initFilePath = "";
   var initFlagId = "";
   var initStartTime = "";
   var initEndTime = "";
   function initFileUpload() {
     $('#file_upload').uploadify(
        {
            'buttonText': '选择文件',
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
                  //保存附件
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
  
  //保存日志
  function saveData(){
      if(initFlagId == ""){
         $.messager.alert('提示', '请先上传日志文件','info');
         return false;
      }
      //先判断该段时间内DCS日志是否已经存在
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
                     $.messager.confirm('Confirm', '该时间段内的DCS报警日志已存在，确定要覆盖吗?', function (r) {
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
  
  //删除日志
  function delData(){
      var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('提示', '请至少选择一条待删除的数据','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].alarmLogId);
         }
         
         $.messager.confirm('Confirm', '确定要删除吗?', function (r) {
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

