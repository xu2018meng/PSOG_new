<%@ Page Language="C#" AutoEventWireup="true" CodeFile="craft_param_change_apply.aspx.cs" Inherits="craft_param_change_apply" %>
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
    %>
    <title>工艺参数台账变更申请</title>
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
        
        #headDiv1 td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:2px 0px 2px 0px;}
        #headDiv1 table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
        #footDiv1 td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:2px 0px 2px 0px;}
        #footDiv1 table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
    </style>
</head>
<body class="easyui-layout" onload="initGrid();">
           
    <div id="gridDiv"  region="center" style="width:auto;height:auto" border="false">   
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="processId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="false" >
         <thead>
                <tr>
                   <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'processReason',width:300,align:'left',halign: 'center',formatter:addLink">变更原因</th>
                   <th data-options="field:'processApplyDate',width:200,align:'center',halign: 'center'">申请时间</th>
                   <th data-options="field:'processExecuteDate',width:200,align:'center',halign: 'center'">实施时间</th>
                   <th data-options="field:'processRecoverDate',width:200,align:'center',halign: 'center'">恢复时间</th>
                   <th data-options="field:'processStatus',width:200,align:'center',halign: 'center'">状态</th>
                   <th data-options="field:'processProtectMeasure',width:200,align:'center',halign: 'center',hidden:'true'">安全措施</th>
                   <th data-options="field:'processToProductExamId',width:200,align:'center',halign: 'center',hidden:'true'">生产车间审核人ID</th>
                   <th data-options="field:'processToProductExamName',width:200,align:'center',halign: 'center',hidden:'true'">生产车间审核人</th>
                   <th data-options="field:'processToMeterExamId',width:200,align:'center',halign: 'center',hidden:'true'">仪表车间审核人ID</th>
                   <th data-options="field:'processToMeterExamName',width:200,align:'center',halign: 'center',hidden:'true'">仪表车间审核人</th>
                   <th data-options="field:'processToSatrapExamId',width:200,align:'center',halign: 'center',hidden:'true'">主管副经理ID</th>
                   <th data-options="field:'processToSatrapExamName',width:200,align:'center',halign: 'center',hidden:'true'">主管副经理</th>
                   <th data-options="field:'processPlantName',width:200,align:'center',halign: 'center',hidden:'true'">装置名称</th>
                   <th data-options="field:'processProductExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">生成车间审核意见</th>
                   <th data-options="field:'processMeterExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">仪表车间审核意见</th>
                   <th data-options="field:'processSatrapExamIdea',width:200,align:'center',halign: 'center',hidden:'true'">主管副经理审核意见</th>
                   
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:60px;">
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 8px"><b>变更原因:</b></span>
            <input id="queryReason"  class="easyui-textbox" style="height:19px;"/>
             <span style="margin-left: 15px"><b>申请时间:</b></span>
             <input type="text" id="queryStartDate" name="queryStartDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
             <span style=""><b>至</b></span>
               <input type="text" id="queryEndDate" name="queryEndDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新建</a>     
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="edit()">编辑</a>                   
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteData()">删除</a>
     </div> 
    </div>    
    
     <!--申请单 -->
    <div id="dlg" class="easyui-dialog" title="新增" style="width:1000px;height:520px;padding:10px" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveData();
                    }
                },{
                    text:'提交审核',
                    iconCls:'icon-ok',
                    handler:function(){
                        submitData();
                    }
                }] ">
        <form id="fm"  method="post" action="">
          <div id="headDiv" style="font-size:12px; padding-top:1px; ">
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>装置名称</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                            <label id="plantName"></label>
                        </td>
                         <td class="td_lable">
                           <label>申请时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="applyDate"></label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>实施时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input type="text" id="executeDate" name="executeDate"  size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
                        </td>
                        <td class="td_lable">
                           <label>恢复时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <input type="text" id="replyDate" name="replyDate"  size="23"  class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
       <div  region="center" style=" height: 300px; width:100%" border="false">   
        <table id="processTable" style="width:auto;height:auto" fit="true" url="craft_param_change_apply_child.ashx"
            toolbar="#dialogTool" idField="processChildId"  data-options="onClickRow: onClickRow"
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="processChildBitCode" width="150" align="center"  
                     editor="{type:'combobox',
                                 options:{
                                   required:true,
                                   valueField: 'label',
		                           textField: 'value',
                                   editable:false,
                                   panelHeight:'auto',
                                   onSelect:onBitSelect,
                                   url:'craft_param_change_bit_data.ashx?plantId=<%=plantId %>&flag=dict'
		                         }}">参数位号</th>
                    <th field="processChildParamName" width="200" align="center" editor="{type:'validatebox',options:{required:true}}">参数名称</th>
                    <th field="processChildUnit" width="150" align="center" editor="text">单位</th>
                    <th field="processChildControlRange" width="200" align="center" editor="text">量程</th>
                    <th field="processChildKPI" width="150" align="center" 
                        editor="{type:'combobox',
                                 options:{
                                   required:true,
                                   valueField: 'label',
		                           textField: 'value',
                                   editable:false,
                                   panelHeight:'auto',
                                   onSelect:onKPIChange,
		                           data: [{
			                            label: '高报',
			                            value: '高报'
		                            },{
			                            label: '高高报',
			                            value: '高高报'
		                            },{
			                        label: '低报',
			                        value: '低报'
			                        },{
			                        label: '低低报',
			                        value: '低低报'}
                                    ]
                                 }}">指标</th>
                    <th field="processChildAlarmType" width="150" align="center"  editor="text">报警类别</th>
                    <th field="processChildBeforeValue" width="150" align="center" editor="{type:'numberbox',options:{required:true}}">变更前报警值</th>
                    <th field="processChildAfterValue" width="150" align="center" editor="{type:'numberbox',options:{required:true}}">变更后报警值</th>
                </tr>
            </thead>
        </table>
        <div id="dialogTool">
           <a id="appendRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="appendRow()">新建</a>                     
           <a id="delRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delRow()">删除</a>
        </div>
    </div>    
    <br />
            
           <div id="footDiv" style="font-size:12px; padding-top:1px; ">
             <input id="processId" name="processId"  style="display:none"/>
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>变更原因</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="changeReason" name="changeReason"  cols="1" rows="7" style="width: 700px;height:90px;"   maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>变更期间安全保证措施</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="protectMeasure" name="protectMeasure"  cols="1" rows="7" style="width: 700px;height:90px;"   maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="2">
                           <label>审查单位会签</label>
                        </td>
                        <td class="td_lable" >
                           <label>生产车间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input id="productExamId" name="productExamId"  style="display:none"/>
                           <input id="productExamName" name="productExamName" class="easyui-searchbox" style="width:200px;height: 23px;" data-options="searcher:openProductUserDiv, editable:false"></input>
                           &nbsp;&nbsp;<span id="productExamLabel" style="display:none">审核意见：</span>&nbsp;<input id="productExam" name="productExam" class="easyui-textbox" disabled style="width:240px;height: 23px;display:none" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>仪表车间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input id="meterExamId" name="meterExamId"  style="display:none"/>
                           <input id="meterExamName" name="meterExamName" class="easyui-searchbox" style="width:200px;height: 23px;" data-options="searcher:openMeterUserDiv, editable:false"></input>
                           &nbsp;&nbsp;<span id="meterExamLabel" style="display:none">审核意见：</span>&nbsp;<input id="meterExam" name="meterExam" class="easyui-textbox" disabled style="width:240px;height: 23px;display:none" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" colspan="2">
                           <label>主管副经理</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input id="satrapExamId" name="satrapExamId"  style="display:none"/>
                           <input id="satrapExamName" name="satrapExamName" class="easyui-searchbox" style="width:200px;height: 23px;" data-options="searcher:openSatrapUserDiv, editable:false"></input>
                            &nbsp;&nbsp;<span id="satrapExamLabel" style="display:none">审核意见：</span>&nbsp;<input id="satrapExam" name="satrapExam" class="easyui-textbox" disabled style="width:240px;height: 23px;display:none" ></input>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </div>
    
     <div id="userDiv" class="easyui-dialog" closed="true" title="人员选择" style="width: 350px; height: 500px; overflow: hidden" buttons="#userDiv-buttons" modal="true">
        <iframe id='BitTree' name="BitTree" src="" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="userDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelect();" style="width: 70px">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#userDiv').dialog('close')" style="width: 70px">取消</a>
        </div>
    </div>
    
      <!--查看申请单 -->
    <div id="viewDlg" class="easyui-dialog" title="新增" style="width:1000px;height:520px;padding:10px" closed="true" modal="true">
        <form id="Form1"  method="post" action="">
           <div id="headDiv1" style="font-size:12px; padding-top:1px; ">
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>装置名称</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                            <label id="plantName1"></label>
                        </td>
                         <td class="td_lable">
                           <label>申请时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="applyDate1"></label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>实施时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <label id="executeDate1"></label>       
                        </td>
                        <td class="td_lable">
                           <label>恢复时间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="replyDate1"></label> 
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
           <div  region="center" style=" height: 300px; width:100%" border="false">   
            <table id="processTable1" style="width:auto;height:auto" fit="true" url="" idField="processChildId" 
                    fitColumns="true"  singleSelect="true">
                 <thead>
                        <tr>
                           <th data-options="field:'processChildBitCode',width:150,align:'center',halign: 'center'">参数位号</th>
                          <th data-options="field:'processChildParamName',width:200,align:'center',halign: 'center'">参数名称</th>
                          <th data-options="field:'processChildUnit',width:150,align:'center',halign: 'center'">单位</th>
                          <th data-options="field:'processChildControlRange',width:200,align:'center',halign: 'center'">量程</th>
                          <th data-options="field:'processChildKPI',width:150,align:'center',halign: 'center'">指标</th>
                          <th data-options="field:'processChildAlarmType',width:150,align:'center',halign: 'center'">报警类别</th>
                          <th data-options="field:'processChildBeforeValue',width:150,align:'center',halign: 'center'">变更前报警值</th>
                          <th data-options="field:'processChildAfterValue',width:150,align:'center',halign: 'center'">变更后报警值</th>
                           <th data-options="field:'processToProductExamId',width:200,align:'center',halign: 'center',hidden:'true'">生产车间审核人ID</th>
                           <th data-options="field:'processToProductExamName',width:200,align:'center',halign: 'center',hidden:'true'">生产车间审核人</th>
                           <th data-options="field:'processToMeterExamId',width:200,align:'center',halign: 'center',hidden:'true'">仪表车间审核人ID</th>
                           <th data-options="field:'processToMeterExamName',width:200,align:'center',halign: 'center',hidden:'true'">仪表车间审核人</th>
                           <th data-options="field:'processToSatrapExamId',width:200,align:'center',halign: 'center',hidden:'true'">主管副经理ID</th>
                           <th data-options="field:'processToSatrapExamName',width:200,align:'center',halign: 'center',hidden:'true'">主管副经理</th>
                        </tr>
                   </thead>
               </table>
          </div>    
          <br />
            
            <div id="footDiv1" style="font-size:12px; padding-top:1px; ">
             <input id="processId1" name="processId1"  style="display:none"/>
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>变更原因</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="changeReason1" name="changeReason1"  cols="1" rows="7" style="width: 700px;height:90px;" disabled  maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>变更期间安全保证措施</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:700px;height:90px;" colspan="2">
                            <textarea  id="protectMeasure1" name="protectMeasure1"  cols="1" rows="7" style="width: 700px;height:90px;" disabled   maxlength="500"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="2">
                           <label>审查单位会签</label>
                        </td>
                        <td class="td_lable" >
                           <label>生产车间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                           <input id="productExamName1" name="productExamName1" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                            &nbsp;&nbsp;<span id="productExamLabel1">审核意见：</span><input id="productExam1" name="productExam1" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>仪表车间</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                         <input id="meterExamName1" name="meterExamName1" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                           &nbsp;&nbsp;<span id="meterExamLabel1">审核意见：</span><input id="meterExam1" name="meterExam1" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                     <tr>
                        <td class="td_lable" colspan="2">
                           <label>主管副经理</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;" >
                            <input id="satrapExamName1" name="satrapExamName1" class="easyui-textbox" disabled style="width:120px;height: 23px;" ></input>
                             &nbsp;&nbsp;<span id="satrapExamLabel1">审核意见：</span><input id="satrapExam1" name="satrapExam1" class="easyui-textbox" disabled style="width:280px;height: 23px;" ></input>
                        </td>
                    </tr>
                </table>
            </div>
             
        </form>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 
   //鼠标单击多行文本框时将光标定在文本框最前面
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
   
   
   function initGrid(){
        $("#dg").datagrid({
            url:'craft_param_change_apply_data.ashx',
            queryParams: {
               plantId: '<%=plantId %>',
               applyUserId:'<%=userId %>',
               queryReason:'',
               queryStartDate:'',
               queryEndDate:''
            }
        });
   }
   
   //查询
   var queryReason = "";
   var queryStartDate = "";
   var queryEndDate = "";
   function queryResult(){
      queryReason = $("#queryReason").val();
      queryStartDate = $("#queryStartDate").val();
      queryEndDate = $("#queryEndDate").val();
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            applyUserId:'<%=userId %>',
            queryReason:queryReason,
            queryStartDate:queryStartDate,
            queryEndDate:queryEndDate
      });
   }
   
   //清空查询条件
   function clearParam(){
     queryReason = "";
     queryStartDate = "";
     queryEndDate = "";
     $("#queryReason").val("");
     $("#queryStartDate").val("");
     $("#queryEndDate").val("");
   }
   
   //删除数据
   function deleteData(){
       var rows = $('#dg').datagrid('getSelections');
       if(rows == null || rows.length == 0){
          $.messager.alert('提示', '请至少选择一条待删除的数据');
          return false;
       }
       var arr = new Array();
       for(var i=0;i<rows.length;i++){
          if(rows[i].processStatus == "审核中" || rows[i].processStatus == "完成"){
             $.messager.alert('提示', '审核中或者完成状态的数据不能删除，请重新选择');
             return false;
          }
          arr.push(rows[i].processId);
       }
         
       $.messager.confirm('Confirm', '确定要删除吗?', function (r) {
           if(r){
               $.ajax({
                    url : './craft_param_change_apply_deal.ashx',
                    data : {
                      flag:'delete',
                      plantId:'<%=plantId %>',
                      paramJson:JSON.stringify(arr)
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         if(result=="1"){
                               $('#dg').datagrid('load', {
                                    plantId: '<%=plantId %>',
                                    applyUserId:'<%=userId %>',
                                    queryReason:queryReason,
                                    queryStartDate:queryStartDate,
                                    queryEndDate:queryEndDate
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
   
   
    var editIndex = undefined;
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#processTable').datagrid('validateRow', editIndex)){
            $('#processTable').datagrid('acceptChanges');
            return true;
        } else {
            return false;
        }
    }
    function onClickRow(index){
        if (editIndex != index){
            if (endEditing()){
                $('#processTable').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $('#processTable').datagrid('selectRow', editIndex);
            }
        }
    }
    function appendRow(){
        if (endEditing()){
            $('#processTable').datagrid('appendRow',{
                
            });
            editIndex = $('#processTable').datagrid('getRows').length-1;
            $('#processTable').datagrid('selectRow', editIndex)
                    .datagrid('beginEdit', editIndex);
        }
    }
    
    //响应位号选择事件
    function onBitSelect(e){
       $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildParamName'] input")[0].value='';
       $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildUnit'] input")[0].value='';
       $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildControlRange'] input")[0].value='';
       var paramKPI = $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildKPI'] input[class='combo-value']")[0].value;
       var bitCode = e.value;
       //查询位号基本信息
       $.ajax({
                url : './craft_param_change_bit_data.ashx?flag=base',
                data : {
                  plantId:'<%=plantId %>',
                  bitCode:bitCode,
                  paramKPI:paramKPI
                },
                async:false,
                type:"post",
                success : function(result) {
                      var bitInfo = eval("("+result+")");  
                      $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildParamName'] input")[0].value=bitInfo.bitName;
                      $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildUnit'] input")[0].value=bitInfo.bitUnit;
                      $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildControlRange'] input")[0].value=bitInfo.bitRange;
                      if(bitInfo.kpiValue!=null && bitInfo.kpiValue.length>0){
                          $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildBeforeValue'] input")[0].value=bitInfo.kpiValue;
                      }
                }
            });
    }
    
    //指标改变事件
    function onKPIChange(e){
       $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildBeforeValue'] input")[0].value = "";
       var bitCode = $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildBitCode'] input[class='combo-value']")[0].value;
       var paramKPI = e.value;
       //查询位号基本信息
       $.ajax({
                url : './craft_param_change_bit_data.ashx?flag=base',
                data : {
                  plantId:'<%=plantId %>',
                  bitCode:bitCode,
                  paramKPI:paramKPI
                },
                async:false,
                type:"post",
                success : function(result) {
                      var bitInfo = eval("("+result+")");  
                      if(bitInfo.kpiValue!=null && bitInfo.kpiValue.length>0){
                          $("tr[datagrid-row-index='"+editIndex+"'] td[field='processChildBeforeValue'] input")[0].value=bitInfo.kpiValue;
                      }
                }
            });
    }
    
    //删除
    function delRow(){
        if (editIndex == undefined){
            alert("请选中要删除的记录");
            return
        }

        $('#processTable').datagrid('cancelEdit', editIndex)
                .datagrid('deleteRow', editIndex);
        editIndex = undefined;
    }
    
    function reject(){
        $('#Table1').datagrid('rejectChanges');
        editIndex = undefined;
    }
    
    function initStyle() {
        
        $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');

    }

    $('#processTable').datagrid({ onLoadSuccess: initStyle });
   
   //新增变更申请
   var applyDate = "";
   var plantName = "";
   function append(){
       plantName = '<%=plantName %>';
       applyDate = '<%=applyDate %>';
       $("#plantName").html(plantName);
       $("#applyDate").html(applyDate);
       
       $('#processTable').datagrid('load', {
            plantId: '<%=plantId %>',
            processId: ''
        });

       $('#dlg').dialog({
               onClose:function(){
                  $("#plantName").html("");
                  $("#applyDate").html("");
                  $("#processId").val("");
                  $("#executeDate").val("");
                  $("#replyDate").val("");
                  $("#changeReason").val("");
                  $("#protectMeasure").val("");
                  $("#productExamId").val("");
                  $("#productExamName").searchbox("setValue","");
                  $("#meterExamId").val("");
                  $("#meterExamName").searchbox("setValue","");
                  $("#satrapExamId").val("");
                  $("#satrapExamName").searchbox("setValue","");
               }
             }).dialog('open').dialog('setTitle', '新建');
   }
   
    //修改变更申请
    function edit(){
       var rows = $('#dg').datagrid('getSelections');
       if(rows == null || rows.length != 1){
          $.messager.alert('提示', '请选择一条待修改的数据');
          return false;
       }
       if(rows[0].processStatus=="审核中" || rows[0].processStatus=="完成"){
          $.messager.alert('提示', '审核中或完成状态的数据不能修改');
          return false;
       }
       
      plantName = rows[0].processPlantName;
      applyDate = rows[0].processApplyDate;
      $("#plantName").html(plantName);
      $("#applyDate").html(applyDate);
      $("#processId").val(rows[0].processId);
      $("#executeDate").val(rows[0].processExecuteDate);
      $("#replyDate").val(rows[0].processRecoverDate);
      $("#changeReason").val(rows[0].processReason);
      $("#protectMeasure").val(rows[0].processProtectMeasure);
      $("#productExamId").val(rows[0].processToProductExamId);
      $("#productExamName").searchbox("setValue",rows[0].processToProductExamName);
      $("#meterExamId").val(rows[0].processToMeterExamId);
      $("#meterExamName").searchbox("setValue",rows[0].processToMeterExamName);
      $("#satrapExamId").val(rows[0].processToSatrapExamId);
      $("#satrapExamName").searchbox("setValue",rows[0].processToSatrapExamName);
     
      var processStatus = rows[0].processStatus;
      if(processStatus=="退回"){
         $("#productExamLabel").show();
         $("#meterExamLabel").show();
         $("#satrapExamLabel").show();
         $("#productExam").show();
         $("#meterExam").show();
         $("#satrapExam").show();
         $("#productExam").val(rows[0].processProductExamIdea);
         $("#meterExam").val(rows[0].processMeterExamIdea);
         $("#satrapExam").val(rows[0].processSatrapExamIdea);
      }
     
       $('#processTable').datagrid('load', {
            plantId: '<%=plantId %>',
            processId: rows[0].processId
        });
        
      if(processStatus=="审核中" || processStatus=="结束"){
          $("#executeDate").attr("disabled","disabled");
          $("#replyDate").attr("disabled","disabled");
      }

       $('#dlg').dialog({
               onClose:function(){
                  $("#plantName").html("");
                  $("#applyDate").html("");
                  $("#executeDate").val("");
                  $("#replyDate").val("");
                  $("#changeReason").val("");
                  $("#protectMeasure").val("");
                  $("#productExamId").val("");
                  $("#productExamName").searchbox("setValue","");
                  $("#meterExamId").val("");
                  $("#meterExamName").searchbox("setValue","");
                  $("#satrapExamId").val("");
                  $("#satrapExamName").searchbox("setValue","");
                  
                 $("#productExamLabel").hide();
                 $("#meterExamLabel").hide();
                 $("#satrapExamLabel").hide();
                 $("#productExam").hide();
                 $("#meterExam").hide();
                 $("#satrapExam").hide();
                 $("#productExam").val("");
                 $("#meterExam").val("");
                 $("#satrapExam").val("");
               }
             }).dialog('open').dialog('setTitle', '编辑');
    }
   
   
    var manEditorName = "";
    var manEditorId = "";
    //生产车间
    function openProductUserDiv(value,name){
     manEditorName = "productExamName";
     manEditorId = "productExamId";
     $("#BitTree").attr("src","craft_user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
   //仪表车间
   function openMeterUserDiv(){
     manEditorName = "meterExamName";
     manEditorId = "meterExamId";
     $("#BitTree").attr("src","craft_user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
   //主管副经理
   function openSatrapUserDiv(){
     manEditorName = "satrapExamName";
     manEditorId = "satrapExamId";
     $("#BitTree").attr("src","craft_user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
     //确定选择
   function confirmSelect(){
      window.BitTree.confirmSelect();
   }
   
    //关闭人员选择框
   function closeDialog(userIds,userNames){
     $("#"+manEditorId).val(userIds);
     $("#"+manEditorName).searchbox("setValue",userNames);
     $('#userDiv').dialog('close');
   }
   
   //保存数据
   function saveData(){
       if (endEditing()){
               editIndex = undefined;
               $('#processTable').datagrid('acceptChanges');
               var paramArr = new Array();
               var rowsData = $('#processTable').datagrid('getRows');
               for(var i=0;i<rowsData.length;i++){
                  paramArr.push({
                     processChildBitCode:rowsData[i].processChildBitCode,
                     processChildParamName:rowsData[i].processChildParamName,
                     processChildUnit:rowsData[i].processChildUnit,
                     processChildControlRange:rowsData[i].processChildControlRange,
                     processChildKPI:rowsData[i].processChildKPI,
                     processChildAlarmType:rowsData[i].processChildAlarmType,
                     processChildBeforeValue:rowsData[i].processChildBeforeValue,
                     processChildAfterValue:rowsData[i].processChildAfterValue
                  });
               }
               
               //处理主表数据
              var executeDate = $("#executeDate").val();
              var replyDate = $("#replyDate").val();
              if(executeDate!=null && executeDate!="" && executeDate<applyDate){
                  $.messager.alert('提示', '实施时间不能小于申请时间');   
                  return false;  
              }
              if(replyDate!=null && replyDate!="" && replyDate<executeDate){
                  $.messager.alert('提示', '恢复时间不能小于实施时间');   
                  return false;  
              }
              var changeReason = $("#changeReason")[0].value;
              if(changeReason==null || changeReason.length<=0){
                  $.messager.alert('提示', '变更原因不能为空');   
                  return false;  
              }
              
              var protectMeasure = $("#protectMeasure")[0].value;
              var productExamId = $("#productExamId").val();
              var productExamName = $("#productExamName").searchbox("getValue");
              if(productExamName==null || productExamName.length<=0){
                  productExamId = "";
              }
              var meterExamId = $("#meterExamId").val();
              var meterExamName = $("#meterExamName").searchbox("getValue");
              if(meterExamName==null || meterExamName.length<=0){
                  meterExamId = "";
              }
              var satrapExamId = $("#satrapExamId").val();
              var satrapExamName = $("#satrapExamName").searchbox("getValue");
              if(satrapExamName==null || satrapExamName.length<=0){
                  satrapExamId = "";
              }
              
              var paramJson = "";
              if(paramArr.length>0){
                 paramJson = JSON.stringify(paramArr);
              }
                      
              $.ajax({
                url : './craft_param_change_apply_deal.ashx',
                data : {
                    flag:"saveOrSubmit",
                    plantId:'<%=plantId %>',
                    plantName:plantName,
                    processId:$("#processId").val(),
                    executeDate:executeDate,
                    replyDate:replyDate,
                    applyData:applyDate,
                    changeReason:changeReason,
                    protectMeasure:protectMeasure,
                    productExamId:productExamId,
                    productExamName:productExamName,
                    meterExamId:meterExamId,
                    meterExamName:meterExamName,
                    satrapExamId:satrapExamId,
                    satrapExamName:satrapExamName,
                    runIndex:'0',
                    applyUserId:'<%=userId %>',
                    paramJson:paramJson
                },
                async:false,
                type:"post",
                success : function(data) {
                   if(data!=null && data.length == 36){
                       $("#processId").val(data);
                       $('#dg').datagrid('load', {
                            plantId: '<%=plantId %>',
                            applyUserId:'<%=userId %>',
                            queryReason:queryReason,
                            queryStartDate:queryStartDate,
                            queryEndDate:queryEndDate
                       });
                       $('#dg').datagrid('clearSelections');
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
               
       }else{
          $.messager.alert('提示', '列表中信息填写不完整，请检查！');   
          return false;  
       }

     
   }
   
   
   //提交
   function submitData(){
     if (endEditing()){
               editIndex = undefined;
               $('#processTable').datagrid('acceptChanges');
               var paramArr = new Array();
               var rowsData = $('#processTable').datagrid('getRows');
               for(var i=0;i<rowsData.length;i++){
                  paramArr.push({
                     processChildBitCode:rowsData[i].processChildBitCode,
                     processChildParamName:rowsData[i].processChildParamName,
                     processChildUnit:rowsData[i].processChildUnit,
                     processChildControlRange:rowsData[i].processChildControlRange,
                     processChildKPI:rowsData[i].processChildKPI,
                     processChildAlarmType:rowsData[i].processChildAlarmType,
                     processChildBeforeValue:rowsData[i].processChildBeforeValue,
                     processChildAfterValue:rowsData[i].processChildAfterValue
                  });
               }
               
               //处理主表数据
              var executeDate = $("#executeDate").val();
              var replyDate = $("#replyDate").val();
              if(executeDate!=null && executeDate!="" && executeDate<applyDate){
                  $.messager.alert('提示', '实施时间不能小于申请时间');   
                  return false;  
              }
              if(replyDate!=null && replyDate!="" && replyDate<executeDate){
                  $.messager.alert('提示', '恢复时间不能小于实施时间');   
                  return false;  
              }
              var changeReason = $("#changeReason")[0].value;
               if(changeReason==null || changeReason.length<=0){
                  $.messager.alert('提示', '变更原因不能为空');   
                  return false;  
              }
              var protectMeasure = $("#protectMeasure")[0].value;
              var productExamId = $("#productExamId").val();
              var productExamName = $("#productExamName").searchbox("getValue");
              if(productExamName==null || productExamName.length<=0){
                  productExamId = "";
              }
              var meterExamId = $("#meterExamId").val();
              var meterExamName = $("#meterExamName").searchbox("getValue");
              if(meterExamName==null || meterExamName.length<=0){
                  meterExamId = "";
              }
              var satrapExamId = $("#satrapExamId").val();
              var satrapExamName = $("#satrapExamName").searchbox("getValue");
              if(satrapExamName==null || satrapExamName.length<=0){
                  satrapExamId = "";
              }
              
              if(productExamName==null || productExamName.length<=0 || meterExamName==null || meterExamName.length<=0
                                       || satrapExamName==null || satrapExamName.length<=0){
                  $.messager.alert('提示', '所有审核人都不能为空！');   
                  return false;  
              }
              
              var paramJson = "";
              if(paramArr.length>0){
                 paramJson = JSON.stringify(paramArr);
              }
                      
              $.ajax({
                url : './craft_param_change_apply_deal.ashx',
                data : {
                    flag:"saveOrSubmit",
                    plantId:'<%=plantId %>',
                    plantName:plantName,
                    processId:$("#processId").val(),
                    executeDate:executeDate,
                    replyDate:replyDate,
                    applyData:applyDate,
                    changeReason:changeReason,
                    protectMeasure:protectMeasure,
                    productExamId:productExamId,
                    productExamName:productExamName,
                    meterExamId:meterExamId,
                    meterExamName:meterExamName,
                    satrapExamId:satrapExamId,
                    satrapExamName:satrapExamName,
                    runIndex:'1',
                    applyUserId:'<%=userId %>',
                    paramJson:paramJson
                },
                async:false,
                type:"post",
                success : function(data) {
                   if(data!=null && data.length == 36){
                       $('#dg').datagrid('load', {
                            plantId: '<%=plantId %>',
                            applyUserId:'<%=userId %>',
                            queryReason:queryReason,
                            queryStartDate:queryStartDate,
                            queryEndDate:queryEndDate
                       });
                       $('#dg').datagrid('clearSelections');
                       $('#dlg').dialog('close'); 
                       $.messager.show({
                        title : '提示',
                        msg : "提交成功"
                       });   
                   }else{
                       $.messager.show({
                        title : '提示',
                        msg : "提交失败"
                       });   
                   }
                }
             });
               
       }else{
          $.messager.alert('提示', '列表中信息填写不完整，请检查！');   
          return false;  
       }
   }
   
   
   //添加超链接
    function addLink(val, row, index) {
        return '<a href="#" onclick="view(' + index + ')">' + val + '</a>';
    }
   //查看
   function view(index){
      var rows = $('#dg').datagrid('getRows');

      $("#plantName1").html(rows[index].processPlantName);
      $("#applyDate1").html(rows[index].processApplyDate);
      $("#processId1").val(rows[index].processId);
      $("#executeDate1").html(rows[index].processExecuteDate);
      $("#replyDate1").html(rows[index].processRecoverDate);
      $("#changeReason1").val(rows[index].processReason);
      $("#protectMeasure1").val(rows[index].processProtectMeasure);
      $("#productExam1").val(rows[index].processProductExamIdea);
      $("#meterExam1").val(rows[index].processMeterExamIdea);
      $("#satrapExam1").val(rows[index].processSatrapExamIdea);
      
      $("#productExamName1").val(rows[index].processToProductExamName);
      $("#meterExamName1").val(rows[index].processToMeterExamName);
      $("#satrapExamName1").val(rows[index].processToSatrapExamName);
     
       $("#processTable1").datagrid({
            url:'craft_param_change_apply_child.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
                processId: rows[index].processId
            }
        });
        
      

       $('#viewDlg').dialog({
               onClose:function(){
                  $("#plantName1").html("");
                  $("#applyDate1").html("");
                  $("#executeDate1").val("");
                  $("#replyDate1").val("");
                  $("#changeReason1").val("");
                  $("#protectMeasure1").val("");
                 
                  $("#productExam1").val("");
                  $("#meterExam1").val("");
                  $("#satrapExam1").val("");
                  
                  $("#productExamName1").val("");
                  $("#meterExamName1").val("");
                  $("#satrapExamName1").val("");
                 
                  $("#processTable1").datagrid({
                        url:'craft_param_change_apply_child.ashx'
                  });
               }
             }).dialog('open').dialog('setTitle', '查看');
    }
   
   
</script>

