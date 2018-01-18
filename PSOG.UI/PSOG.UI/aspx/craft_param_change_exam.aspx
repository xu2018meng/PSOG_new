<%@ Page Language="C#" AutoEventWireup="true" CodeFile="craft_param_change_exam.aspx.cs" Inherits="craft_param_change_exam" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
       SysUser user = ((SysUser)Session[CommonStr.session_user]);
       String userId = user.userId;
       String userName = user.userName;
    %>
    <title>���ղ���̨�˱������</title>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
      <script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
     <link type="text/css" rel="stylesheet" href="../resource/css/calendar.css" />
    <style type="text/css">
        *
        {
            margin: 0;
            padding: 0;
        }
        html, body{
            width:100%;
            height:100%;
        }
        
        .td_lable
        {
            text-align: center;
            width: 80px;
            height: 35px;
        }
        
        #headDiv td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:2px 0px 2px 0px;}
        #headDiv table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
        #footDiv td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:2px 0px 2px 0px;}
        #footDiv table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
    </style>
</head>
<body class="easyui-layout" onload="initGrid();">
           
    <div id="gridDiv"  region="center" style="width:auto;height:auto" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="processId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="false" >
         <thead>
                <tr>
                   <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'processReason',width:300,align:'left',halign: 'center'">���ԭ��</th>
                   <th data-options="field:'processApplyDate',width:200,align:'center',halign: 'center'">����ʱ��</th>
                   <th data-options="field:'processExecuteDate',width:200,align:'center',halign: 'center'">ʵʩʱ��</th>
                   <th data-options="field:'processRecoverDate',width:200,align:'center',halign: 'center'">�ָ�ʱ��</th>
                   <th data-options="field:'processProtectMeasure',width:200,align:'center',halign: 'center',hidden:'true'">��ȫ��ʩ</th>
                   <th data-options="field:'processToProductExamId',width:200,align:'center',halign: 'center',hidden:'true'">�������������ID</th>
                   <th data-options="field:'processToMeterExamId',width:200,align:'center',halign: 'center',hidden:'true'">�Ǳ��������ID</th>
                   <th data-options="field:'processToSatrapExamId',width:200,align:'center',halign: 'center',hidden:'true'">���ܸ�����ID</th>
                   <th data-options="field:'processProductExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">���ɳ���������</th>
                   <th data-options="field:'processMeterExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">�Ǳ���������</th>
                   <th data-options="field:'processSatrapExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">���ܸ�����������</th>
                   <th data-options="field:'processPlantName',width:200,align:'center',halign: 'center',hidden:'true'">װ������</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:60px;">
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 8px"><b>���ԭ��:</b></span>
            <input id="queryReason"  class="easyui-textbox" style="height:19px;"/>
             <span style="margin-left: 15px"><b>����ʱ��:</b></span>
             <input type="text" id="queryStartDate" name="queryStartDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
             <span style=""><b>��</b></span>
               <input type="text" id="queryEndDate" name="queryEndDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
        </form>   
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="exam()">���</a>                   
      </div> 
    </div>    
    
     <!--���뵥 -->
    <div id="dlg" class="easyui-dialog" title="����" style="width:1000px;height:520px;padding:10px" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                toolbar: [{
                    text:'ͬ��',
                    iconCls:'icon-ok',
                    handler:function(){
                        submitData();
                    }
                },{
                    text:'��ͬ��',
                    iconCls:'icon-back',
                    handler:function(){
                        backData();
                    }
                }] ">
        <form id="fm"  method="post" action="">
           <div id="headDiv" style="font-size:12px; padding-top:1px; ">
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>װ������</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                            <label id="plantName"></label>
                        </td>
                         <td class="td_lable">
                           <label>����ʱ��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="applyDate"></label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>ʵʩʱ��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <label id="executeDate"></label>       
                        </td>
                        <td class="td_lable">
                           <label>�ָ�ʱ��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="replyDate"></label> 
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
           <div  region="center" style=" height: 300px; width:100%" border="false">   
            <table id="processTable" style="width:auto;height:auto" fit="true" url="" idField="processChildId" 
                    fitColumns="true"  singleSelect="true">
                 <thead>
                        <tr>
                           <th data-options="field:'processChildBitCode',width:150,align:'center',halign: 'center'">����λ��</th>
                          <th data-options="field:'processChildParamName',width:200,align:'center',halign: 'center'">��������</th>
                          <th data-options="field:'processChildUnit',width:150,align:'center',halign: 'center'">��λ</th>
                          <th data-options="field:'processChildControlRange',width:200,align:'center',halign: 'center'">����</th>
                          <th data-options="field:'processChildKPI',width:150,align:'center',halign: 'center'">ָ��</th>
                          <th data-options="field:'processChildAlarmType',width:150,align:'center',halign: 'center'">�������</th>
                          <th data-options="field:'processChildBeforeValue',width:150,align:'center',halign: 'center'">���ǰ����ֵ</th>
                          <th data-options="field:'processChildAfterValue',width:150,align:'center',halign: 'center'">����󱨾�ֵ</th>
                           <th data-options="field:'processToProductExamId',width:200,align:'center',halign: 'center',hidden:'true'">�������������ID</th>
                           <th data-options="field:'processToProductExamName',width:200,align:'center',halign: 'center',hidden:'true'">�������������</th>
                           <th data-options="field:'processToMeterExamId',width:200,align:'center',halign: 'center',hidden:'true'">�Ǳ��������ID</th>
                           <th data-options="field:'processToMeterExamName',width:200,align:'center',halign: 'center',hidden:'true'">�Ǳ��������</th>
                           <th data-options="field:'processToSatrapExamId',width:200,align:'center',halign: 'center',hidden:'true'">���ܸ�����ID</th>
                           <th data-options="field:'processToSatrapExamName',width:200,align:'center',halign: 'center',hidden:'true'">���ܸ�����</th>
                        </tr>
                   </thead>
               </table>
          </div>    
          <br />
            
            <div id="footDiv" style="font-size:12px; padding-top:1px; ">
             <input id="processId" name="processId"  style="display:none"/>
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>���ԭ��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="changeReason" name="changeReason"  cols="1" rows="7" style="width: 700px;height:90px;" disabled  maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>����ڼ䰲ȫ��֤��ʩ</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="protectMeasure" name="protectMeasure"  cols="1" rows="7" style="width: 700px;height:90px;" disabled   maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="2">
                           <label>��鵥λ��ǩ</label>
                        </td>
                        <td class="td_lable" >
                           <label>��������</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input id="productExamName" name="productExamName" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                            &nbsp;&nbsp;<span id="productExamLabel">��������</span><input id="productExam" name="productExam" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>�Ǳ���</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                         <input id="meterExamName" name="meterExamName" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                           &nbsp;&nbsp;<span id="meterExamLabel">��������</span><input id="meterExam" name="meterExam" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" colspan="2">
                           <label>���ܸ�����</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                            <input id="satrapExamName" name="satrapExamName" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                             &nbsp;&nbsp;<span id="satrapExamLabel">��������</span><input id="satrapExam" name="satrapExam" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                </table>
            </div>
             
        </form>
    </div>

</body>    
</html>


<script type="text/javascript"> 
   
   function initGrid(){
        $("#dg").datagrid({
            url:'craft_param_change_exam_data.ashx',
            queryParams: {
               plantId: '<%=plantId %>',
               queryReason:'',
               queryStartDate:'',
               queryEndDate:'',
               userId:'<%=userId %>'
            }
        });
   }
   
   //��ѯ
   var queryReason = "";
   var queryStartDate = "";
   var queryEndDate = "";
   function queryResult(){
      queryReason = $("#queryReason").val();
      queryStartDate = $("#queryStartDate").val();
      queryEndDate = $("#queryEndDate").val();
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            queryReason:queryReason,
            queryStartDate:queryStartDate,
            queryEndDate:queryEndDate,
             userId:'<%=userId %>'
      });
   }
   
   //��ղ�ѯ����
   function clearParam(){
     queryReason = "";
     queryStartDate = "";
     queryEndDate = "";
     $("#queryReason").val("");
     $("#queryStartDate").val("");
     $("#queryEndDate").val("");
   }
   
    //���
    function exam(){
       var rows = $('#dg').datagrid('getSelections');
       if(rows == null || rows.length != 1){
          $.messager.alert('��ʾ', '��ѡ��һ������˵�����');
          return false;
       }

      $("#plantName").html(rows[0].processPlantName);
      $("#applyDate").html(rows[0].processApplyDate);
      $("#processId").val(rows[0].processId);
      $("#executeDate").html(rows[0].processExecuteDate);
      $("#replyDate").html(rows[0].processRecoverDate);
      $("#changeReason").val(rows[0].processReason);
      $("#protectMeasure").val(rows[0].processProtectMeasure);
      $("#productExam").val(rows[0].processProductExamIdea);
      $("#meterExam").val(rows[0].processMeterExamIdea);
      $("#satrapExam").val(rows[0].processSatrapExamIdea);
      
      $("#productExamName").val(rows[0].processToProductExamName);
      $("#meterExamName").val(rows[0].processToMeterExamName);
      $("#satrapExamName").val(rows[0].processToSatrapExamName);
     
       $("#processTable").datagrid({
            url:'craft_param_change_apply_child.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
                processId: rows[0].processId
            }
        });
        
       var userId = '<%=userId %>';
       if(userId == rows[0].processToProductExamId){
          $("#productExam").removeAttr("disabled");
       }else if(userId == rows[0].processToMeterExamId){
          $("#meterExam").removeAttr("disabled");
       }else if(userId == rows[0].processToSatrapExamId){
          $("#satrapExam").removeAttr("disabled");
       }

       $('#dlg').dialog({
               onClose:function(){
                  $("#plantName").html("");
                  $("#applyDate").html("");
                  $("#executeDate").val("");
                  $("#replyDate").val("");
                  $("#changeReason").val("");
                  $("#protectMeasure").val("");
                 
                  $("#productExam").val("");
                  $("#meterExam").val("");
                  $("#satrapExam").val("");
                  
                  $("#productExamName").val("");
                  $("#meterExamName").val("");
                  $("#satrapExamName").val("");
                 
                  $("#processTable").datagrid({
                        url:'craft_param_change_apply_child.ashx'
                  });
               }
             }).dialog('open').dialog('setTitle', '���');
    }
   
   
   
     //�ύ
     function submitData(){
          var productExam = $("#productExam").val();
          var meterExam = $("#meterExam").val();
          var satrapExam = $("#satrapExam").val();
          
          var isFinal = "0";
          var rows = $('#dg').datagrid('getSelections');
          var userId = '<%=userId %>';
          if(userId == rows[0].processToProductExamId){
//              if(productExam==null || productExam.length<=0){
//                  $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//                  return false; 
//              }
              
          }else if(userId == rows[0].processToMeterExamId){
//              if(meterExam==null || meterExam.length<=0){
//                  $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//                  return false; 
//              }
          }else if(userId == rows[0].processToSatrapExamId){
//              if(satrapExam==null || satrapExam.length<=0){
//                  $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//                  return false; 
//              }
              isFinal = "1";
          }    
                  
          $.ajax({
            url : './craft_param_change_exam_deal.ashx',
            data : {
                flag:"submit",
                plantId:'<%=plantId %>',
                processId:$("#processId").val(),
                productExam:productExam,
                meterExam:meterExam,
                satrapExam:satrapExam,
                isFinal:isFinal
            },
            async:false,
            type:"post",
            success : function(data) {
               if(data == "1"){
                   $('#dg').datagrid('load', {
                         plantId: '<%=plantId %>',
                         queryReason:queryReason,
                         queryStartDate:queryStartDate,
                         queryEndDate:queryEndDate,
                         userId:'<%=userId %>'
                   });
                   $('#dg').datagrid('clearSelections');
                   $('#dlg').dialog('close'); 
                   $.messager.show({
                    title : '��ʾ',
                    msg : "�ύ�ɹ�"
                   });   
               }else{
                   $.messager.show({
                    title : '��ʾ',
                    msg : "�ύʧ��"
                   });   
               }
            }
         });
   }
   
   //�˻�
   function backData(){
      var productExam = $("#productExam").val();
      var meterExam = $("#meterExam").val();
      var satrapExam = $("#satrapExam").val();
     
      var rows = $('#dg').datagrid('getSelections');
      var userId = '<%=userId %>';
      if(userId == rows[0].processToProductExamId){
//          if(productExam==null || productExam.length<=0){
//              $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//              return false; 
//          }
          
      }else if(userId == rows[0].processToMeterExamId){
//          if(meterExam==null || meterExam.length<=0){
//              $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//              return false; 
//          }
      }else if(userId == rows[0].processToSatrapExamId){
//          if(satrapExam==null || satrapExam.length<=0){
//              $.messager.alert('��ʾ', '����������Ϊ�գ�');   
//              return false; 
//          }
      }    
     
     $.ajax({
            url : './craft_param_change_exam_deal.ashx',
            data : {
                flag:"back",
                plantId:'<%=plantId %>',
                processId:$("#processId").val(),
                productExam:productExam,
                meterExam:meterExam,
                satrapExam:satrapExam
            },
            async:false,
            type:"post",
            success : function(data) {
               if(data == "1"){
                   $('#dg').datagrid('load', {
                         plantId: '<%=plantId %>',
                         queryReason:queryReason,
                         queryStartDate:queryStartDate,
                         queryEndDate:queryEndDate,
                         userId:'<%=userId %>'
                   });
                   $('#dg').datagrid('clearSelections');
                   $('#dlg').dialog('close'); 
                   $.messager.show({
                    title : '��ʾ',
                    msg : "�˻سɹ�"
                   });   
               }else{
                   $.messager.show({
                    title : '��ʾ',
                    msg : "�˻�ʧ��"
                   });   
               }
            }
         });
   }
   
   
</script>

