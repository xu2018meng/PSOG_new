<%@ Page Language="C#" AutoEventWireup="true" CodeFile="craft_param_change_record.aspx.cs" Inherits="craft_param_change_record" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <title>���ղ���̨�˱����¼</title>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
     <script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
     <link type="text/css" rel="stylesheet" href="../resource/css/calendar.css" />
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
    </style>
</head>
<body class="easyui-layout" onload="initGrid();">
           
    <div id="gridDiv"  region="center" style="width:auto;height:auto" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="craftId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                   <th data-options="field:'craftParamRank',width:100,align:'left',halign: 'center',hidden:true">�����ȼ�</th>
                   <th data-options="field:'craftParamName',width:230,align:'left',halign: 'center'">��������</th>
                  <th data-options="field:'craftParamBitCode',width:140,align:'left',halign: 'center'">����λ��</th>
                  <th data-options="field:'craftUnit',width:100,align:'left',halign: 'center'">��λ</th>
                  <th data-options="field:'craftAlarmType',width:100,align:'left',halign: 'center'">�������</th>
                  <th data-options="field:'craftKPI',width:100,align:'center',halign: 'center'">ָ��</th>
                  <th data-options="field:'craftBeforeValue',width:100,align:'right',halign: 'center'">���ǰ����ֵ</th>
                   <th data-options="field:'craftAfterValue',width:100,align:'right',halign: 'center'">����󱨾�ֵ</th>
                  <th data-options="field:'craftReason',width:260,align:'left',halign: 'center'">���ԭ��</th>
                  <th data-options="field:'craftDate',width:160,align:'center',halign: 'center'">���ʱ��</th>
                  <th data-options="field:'craftRemark',width:160,align:'left',halign: 'center',hidden:true">��ע</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:48px;">
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 5px"><b>��������:</b></span>
            <input id="queryParamName"  class="easyui-textbox" style="height:18px;"/>
             <span style="margin-left: 5px"><b>����λ��:</b></span>
              <input id="queryParamBitCode"  class="easyui-textbox" style="height:18px;"/>
              <span style="margin-left: 15px"><b>���ʱ��:</b></span>
             <input type="text" id="queryStartDate" name="queryStartDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
             <span style=""><b>��</b></span>
               <input type="text" id="queryEndDate" name="queryEndDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">��ѯ</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">���</a>
        </form>
     </div> 
    </div>    
</body>    
</html>


<script type="text/javascript"> 
   
   function initGrid(){
        $("#dg").datagrid({
            url:'craft_param_change_record_data.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
               paramName:'',
               paramBitCode:'',
               queryStartDate:'',
               queryEndDate:''
            }
        });
   }
   
   //��ѯ
   function queryResult(){
      var paramName = $("#queryParamName").val();
      var paramBitCode = $("#queryParamBitCode").val();
      var queryStartDate = $("#queryStartDate").val();
      var queryEndDate = $("#queryEndDate").val();
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            paramName:paramName,
            paramBitCode:paramBitCode,
            queryStartDate:queryStartDate,
            queryEndDate:queryEndDate
      });
   }
   
   //��ղ�ѯ����
   function clearParam(){
     $("#queryParamName").val("");
     $("#queryParamBitCode").val("");
     $("#queryStartDate").val("");
     $("#queryEndDate").val("");
   }
   
   
</script>

