<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_realTime_list.aspx.cs" Inherits="alarm_realTime_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <title>λ��ѡ���б�</title>
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
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="alarmId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                   <th data-options="field:'alarmRuleId',width:140,align:'center',halign: 'center',hidden:true">���������</th>
                   <th data-options="field:'alarmBitNo',width:140,align:'center',halign: 'center',formatter:addLink">λ��</th>
                     <th data-options="field:'alarmTagDesc',width:140,align:'center',halign: 'center',hidden:'true'">����</th>
                  <th data-options="field:'alarmRealValue',width:140,align:'center',halign: 'center'">ʵʱֵ</th>
                  <th data-options="field:'alarmStatus',width:140,align:'center',halign: 'center'">״̬</th>
                  <th data-options="field:'alarmType',width:140,align:'center',halign: 'center'">����</th>
                  <th data-options="field:'alarmSustainTime',width:140,align:'center',halign: 'center'">����ʱ��</th>
                  <th data-options="field:'alarmStartTime',width:140,align:'center',halign: 'center'">��ʼʱ��</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:72px;">
        
        <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:΢���ź�;">
         &nbsp;&nbsp;��ǰλ�ã�<a style="font-size:16px;text-decoration: none;color:Blue;font-family:΢���ź�;" href="main_page_new.aspx?plantId=<%=plantId %>">��ҳ</a>
         &nbsp;>&nbsp;����ʵʱ����
        </div>
        
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 5px"><b>λ��:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" style="height:18px;"/>
             <span style="margin-left: 5px"><b>����:</b></span>
              <input id="queryTypeName" name="queryTypeName" class="easyui-combobox" style=" height: 22px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '����',
			                        value: '����'
		                        },{
			                        label: '����',
			                        value: '����'
		                        },{
			                        label: '�豸',
			                        value: '�豸'
		                        },
		                        {
			                        label: '���ù���',
			                        value: '���ù���'
		                        }]" /> 
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
            url:'alarm_realTime_list_data.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
               tagName:'',
               typeName:''
            }
        });
   }
   
   //��ѯ
   function queryResult(){
      var bitNo = $("#queryBitNo").val();
      var typeName = $("#queryTypeName").combobox("getValue");
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            tagName:bitNo,
            typeName:typeName
      });
   }
   
   //��ղ�ѯ����
   function clearParam(){
     $("#queryBitNo").val("");
     $("#queryTypeName").combobox("setValue","");
   }
   
    //������
    function addLink(val, row, index){
       return '<a href="#"  onclick="turnToAlarmRule(' + index + ')">' + val + '</a>';
    }
    
    //��ת����������ҳ��
    function turnToAlarmRule(index){
       var rows = $("#dg").datagrid("getRows");
       window.location.href ="./alarm_survey_rule.aspx?id=" + rows[index].alarmRuleId+"&plantId=<%=plantId %>&bitCode="+rows[index].alarmBitNo+"&tagDesc="+rows[index].alarmTagDesc;
    }
    
    //����
    function back(){
       window.history.back();
    }
   
</script>

