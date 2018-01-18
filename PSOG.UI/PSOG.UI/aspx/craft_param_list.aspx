<%@ Page Language="C#" AutoEventWireup="true" CodeFile="craft_param_list.aspx.cs" Inherits="craft_param_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <title>���ղ���̨��</title>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
        }
    </style>
</head>
<body class="easyui-layout" onload="initGrid();">
           
    <div id="gridDiv"  region="center" style="width:auto;height:auto" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="limitId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                   <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'limitParamRank',width:120,align:'left',halign: 'center'">�����ȼ�</th>
                   <th data-options="field:'limitBitName',width:230,align:'left',halign: 'center'">��������</th>
                  <th data-options="field:'limitBitCode',width:140,align:'left',halign: 'center'">����λ��</th>
                  <th data-options="field:'limitUpLine',width:180,align:'left',halign: 'center'">���Ʒ�Χ</th>
                  <th data-options="field:'limitUnit',width:140,align:'left',halign: 'center'">��λ</th>
                  <th data-options="field:'limitHHigh',width:120,align:'right',halign: 'center'">�߸߱���(HH)</th>
                  <th data-options="field:'limitHigh',width:120,align:'right',halign: 'center'">�߱���(H)</th>
                   <th data-options="field:'limitLow',width:120,align:'right',halign: 'center'">�ͱ���(L)</th>
                  <th data-options="field:'limitLLow',width:120,align:'right',halign: 'center'">�͵ͱ���(LL)</th>
                  <th data-options="field:'limitRemark',width:160,align:'left',halign: 'center'">��ע</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:48px;">
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 5px"><b>��������:</b></span>
            <input id="queryParamName"  class="easyui-textbox" style="height:18px;"/>
             <span style="margin-left: 5px"><b>����λ��:</b></span>
              <input id="queryParamBitCode"  class="easyui-textbox" style="height:18px;"/>
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
            url:'craft_param_list_data.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
               paramName:'',
               paramBitCode:''
            }
        });
   }
   
   //��ѯ
   function queryResult(){
      var paramName = $("#queryParamName").val();
      var paramBitCode = $("#queryParamBitCode").val();
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            paramName:paramName,
            paramBitCode:paramBitCode
      });
   }
   
   //��ղ�ѯ����
   function clearParam(){
     $("#queryParamName").val("");
     $("#queryParamBitCode").val("");
   }
   
   
</script>

