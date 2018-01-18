<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_sendInfo_record_list.aspx.cs" Inherits="alarm_sendInfo_record_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <%  %>
    <title>��Ϣ��־�б�</title>
    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
      <script language="javascript" type="text/javascript" src="../../resource/js/WdatePicker.js"></script>
     <link type="text/css" rel="stylesheet" href="../../resource/css/calendar.css" />
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
        .param {
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
            url:'alarm_sendInfo_record_list_data.ashx',
            queryParams: {
                plantId: ''
            }
           });
     }
    </script>
</head>
<body class="easyui-layout" onload="initGrid();">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
       
       <table id="dg" style="width:auto;height:auto" fit="true" url=""
            toolbar="#toolbar" idField="MessageRecordId" pagination="true" pagesize="20" 
            rownumbers="true" fitColumns="false" singleSelect="false">
    
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'MessageRecordTagName',width:160,align:'left',halign: 'center'">λ��</th>
                  <th data-options="field:'MessageRecordTagDesc',width:200,align:'left',halign: 'center'">����</th>
                   <th data-options="field:'MessageRecordType',width:100,align:'center',halign: 'center'">����</th>
                  <th data-options="field:'MessageRecordState',width:120,align:'center',halign: 'center'">״̬</th>
                  <th data-options="field:'MessageRecordStartDate',width:160,align:'center',halign: 'center'">��ʼʱ��</th>
                  <th data-options="field:'MessageRecordSustainTime',width:120,align:'center',halign: 'center'">����ʱ��</th>
                  <th data-options="field:'MessageRecordValue',width:120,align:'center',halign: 'center'">ʵʱֵ</th>
                   <th data-options="field:'MessageRecordSendDate',width:160,align:'center',halign: 'center'">����ʱ��</th>
                   <th data-options="field:'MessageRecordToUserName',width:120,align:'center',halign: 'center'">������</th>
                  <th data-options="field:'MessageRecordSendMethod',width:100,align:'center',halign: 'center'">���շ�ʽ</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:2px;">
         <form id="param" action="">
             <table>
               <tr>
                 <td class="param"><span><b>λ��:</b></span></td>
                 <td><input id="queryTagName"  class="easyui-textbox" /></td>
                 <td class="param"><span><b>����:</b></span></td>
                 <td><input id="queryTagDesc" class="easyui-textbox"/></td>
                 <td class="param"><span><b>����:</b></span></td>
                 <td><input id="queryType" class="easyui-combobox" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '����',
			                        value: '����'
		                        },{
			                        label: 'Ԥ��',
			                        value: 'Ԥ��'
		                        },{
			                        label: '�쳣',
			                        value: '�쳣'
		                        }]" /> 
		         </td>
                 <td></td>
               </tr>
               <tr style="height:30px;">
                 <td class="param"><span><b>������:</b></span></td>
                 <td><input id="queryRecevier" class="easyui-textbox"/></td>
                 <td class="param"><span><b>����ʱ��:</b></span></td>
                 <td><input type="text" id="queryStartDate" name="queryStartDate"  size="20" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" /></td>
                 <td style="text-align:center"><span><b>��</b></span></td>
                 <td> <input type="text" id="queryEndDate" name="queryEndDate"  size="20" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" /></td>
                 <td style="padding-left:5px;">
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
                    <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
                 </td>
               </tr>
             </table>
        </form>
       </div>  
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
             tagName:"",
             tagDesc:"",
             type:"",
             toUserName:"",
             startTime:"",
             endTime:""
           });
           
       }else{
           $('#dg').datagrid('load', {
              plantId:""
           });
       }
       
    }
    
    
    //��ѯ
    function queryResult(){
       var tagName = $("#queryTagName").val();
       var tagDesc = $("#queryTagDesc").val();
       var type = $("#queryType").combobox("getValue");
       var toUserName = $("#queryRecevier").val();
       var startTime = $("#queryStartDate").val();
       var endTime = $("#queryEndDate").val();
       $('#dg').datagrid('load', {
             plantId:nodeId,
             tagName:tagName,
             tagDesc:tagDesc,
             type:type,
             toUserName:toUserName,
             startTime:startTime,
             endTime:endTime
           });
    }
    
    //��ղ�ѯ����
    function clearParam(){
       $("#queryTagName").val("");
       $("#queryTagDesc").val("");
       $("#queryType").combobox("setValue","");
       $("#queryRecevier").val("");
       $("#queryStartDate").val("");
       $("#queryEndDate").val("");
    }
    
    
</script>

