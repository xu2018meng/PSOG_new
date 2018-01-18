<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_limit_list.aspx.cs" Inherits="alarm_limit_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1">
    <%  %>
    <title>报警限列表</title>
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
            url:'alarm_limit_list_data.ashx',
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
            toolbar="#toolbar" idField="limitId" pagination="true" pagesize="20" 
            rownumbers="true" fitColumns="false" singleSelect="false">
    
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'limitBitCode',width:160,align:'left',halign: 'center'">位号</th>
                  <th data-options="field:'limitDCSCode',width:120,align:'left',halign: 'center'">DCS位号</th>
                  <th data-options="field:'limitBitName',width:200,align:'left',halign: 'center'">描述</th>
                   <th data-options="field:'limitUnit',width:150,align:'left',halign: 'center'">单位</th>
                  <th data-options="field:'limitType',width:100,align:'left',halign: 'center',formatter:formatType">仪表类型</th>
                  <th data-options="field:'limitLineId',width:120,align:'left',halign: 'center',hidden:'hidden'">所属工段ID</th>
                  <th data-options="field:'limitLineName',width:120,align:'left',halign: 'center'">所属工段</th>
                   <th data-options="field:'limitDeviceId',width:120,align:'left',halign: 'center',hidden:'hidden'">所属设备ID</th>
                   <th data-options="field:'limitDeviceName',width:120,align:'left',halign: 'center'">所属设备</th>
                  <th data-options="field:'limitUpLine',width:120,align:'right',halign: 'center'">量程上限</th>
                  <th data-options="field:'limitDownLine',width:120,align:'right',halign: 'center'">量程下限</th>
                   <th data-options="field:'limitHHigh',width:120,align:'right',halign: 'center'">DCS高高报</th>
                  <th data-options="field:'limitHigh',width:120,align:'right',halign: 'center'">DCS高报</th>
                  <th data-options="field:'limitLow',width:120,align:'right',halign: 'center'">DCS低报</th>
                   <th data-options="field:'limitLLow',width:120,align:'right',halign: 'center'">DCS低低报</th>
                  <th data-options="field:'limitEditDate',width:120,align:'center',halign: 'center'">编辑时间</th>
                  <th data-options="field:'limitRemark',width:200,align:'left',halign: 'center'">仪表备注</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:2px;">
         <form id="param">
            <span style="margin-left: 5px"><b>位号:</b></span>
            <input id="queryBitNo"  class="easyui-textbox" />
             <span style="margin-left: 5px"><b>描述:</b></span>
            <input id="queryDeviceName" class="easyui-textbox"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">增加</a>     
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true"  onclick="edit()">修改</a>                   
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
           <a id="a_hazop" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-fenxi',plain:true" onclick="configHazop()">参数报警分析</a>     
        </div>  
    </div>  
    
    
    <!--报警限信息 -->
    <div id="dlg" class="easyui-dialog" title="新增" style="width:750px;height:410px;padding-left:3px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveLimitData();
                    }
                }] ">
        <form id="fm"  method="post" action="" style="padding-top:10px;">
           <input id="limitId" name="limitId"  style="display:none"/>
            <table cellpadding="2">
                <tr class="tr">
                    <td class="lable">位号:</td>
                    <td><input id="limitBitCode" name="limitBitCode" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">DCS位号:</td>
                    <td><input id="limitDCSCode" name="limitDCSCode" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                <tr class="tr">
                    <td class="lable">描述:</td>
                    <td colspan="3">
                    <input id="limitBitName" name="limitBitName" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/>
                    </td>
                </tr>
                <tr class="tr">
                    <td class="lable">单位:</td>
                    <td><input id="limitUnit" name="limitUnit" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">仪表类型:</td>
                    <td>
                     <input id="limitType" name="limitType" class="easyui-combobox"  style="width:242px; height: 26px;" data-options="
		                        valueField: 'value',
		                        textField: 'label',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '',
			                        value: ''
		                        },{
			                        label: '现场仪表',
			                        value: '1'
		                        },{
			                        label: '虚拟仪表',
			                        value: '2'
		                        },{
			                        label: '分析仪表',
			                        value: '3'
		                        },{
			                        label: '自定义类型',
			                        value: '4'
		                        },{
			                        label: '固定类型',
			                        value: '5'
		                        },{
			                        label: '持续时间',
			                        value: '6'
		                        },
		                        {
			                        label: '瞬时值',
			                        value: '7'
		                        }]" /> 
                          
                  </td>
                </tr>
                <tr class="tr">
                    <td class="lable">所属工段:</td>
                    <td>
                     <input id="limitLineId" name="limitLineId" class="easyui-combobox" class="input" style="width:242px; height: 26px;" data-options="
		                        valueField: 'value',
		                        textField: 'text',
		                        panelHeight:'auto',
		                        onSelect:initDeviceDict
		                         "/> 
                    </td>
                    <td class="lable">所属设备:</td>
                    <td>
                    <input id="limitDeviceId" name="limitDeviceId" class="easyui-combobox" class="input" style="width:242px; height: 26px;" data-options="
		                        valueField: 'value',
		                        textField: 'text',
		                        panelHeight:'auto'
		                         "/> 
                    </td>
                </tr>
                <tr class="tr">
                    <td class="lable">量程上限:</td>
                    <td><input id="limitUpLine" name="limitUpLine" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">量程下限:</td>
                    <td><input id="limitDownLine" name="limitDownLine" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                <tr class="tr">
                    <td class="lable">DCS高高报:</td>
                    <td><input id="limitHHigh" name="tagNalimitHHighme" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">DCS高报:</td>
                    <td><input id="limitHigh" name="limitHigh" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                 <tr class="tr">
                    <td class="lable">DCS低低报:</td>
                    <td><input id="limitLLow" name="limitLLow" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">DCS低报:</td>
                    <td><input id="limitLow" name="limitLow" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                </tr>
                <tr class="tr">
                    <td class="lable">仪表备注:</td>
                    <td colspan="3">
                    <input id="limitRemark" name="limitRemark" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    
     <!--HAZOP参数 -->
    <div id="hazopDiv" class="easyui-dialog" title="新增" style="width:750px;height:530px;padding-left:3px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-fenxi',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveHazopData();
                    }
                }] ">
        <form id="hazopFm"  method="post" action="" style="padding-top:5px;">
         <label style="font-size:16px; font-weight:bold">高&nbsp;报</label>
         <br />
     <div  style=" height: 200px; width:100%;padding-top:5px;" border="false">      
       <table id="processTable" style="width:auto;height:auto;" fit="true" url=""
            toolbar="#dialogTool" idField="hazopId"  data-options="onClickRow: onClickRow"
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="hazopReason" width="200" align="center" editor="text">可能原因</th>
                    <th field="hazopI" width="150" align="center" data-options="formatter:formatReasonRank"
                        editor="{type:'combobox',
                                 options:{
                                   valueField: 'value',
		                           textField: 'label',
                                   editable:false,
                                   panelHeight:'auto',
		                           data: [{
			                            label: '高报',
			                            value: 'H'
		                            },{
			                            label: '高高报',
			                            value: 'HH'
		                            }
                                    ]
                                 }}">原因等级</th>
                    <th field="hazopMeasure" width="150" align="center"  editor="text">建议措施</th>
                </tr>
            </thead>
        </table>
          <div id="dialogTool">
           <a id="appendRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="appendRow()">增加</a>                     
           <a id="delRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delRow()">删除</a>
        </div>
       </div> 
        
         <table cellpadding="2">
                <tr class="tr">
                    <td class="lable">偏离值</td>
                    <td><input id="hazopBiasValueH" name="hazopBiasValueH" style="width:240px;height:22px;" maxlength="50" class="easyui-numberbox" type="text" /></td>
                    <td class="lable">RR(风险等级)</td>
                    <td><input id="hazopRRH" name="hazopRRH" class="input" maxlength="50" class="easyui-textbox" type="text" /></td>
                </tr>
                <tr class="tr">
                    <td class="lable">F(潜在事故频率等级)</td>
                    <td><input id="hazopFH" name="hazopFH" class="input" maxlength="50" class="easyui-textbox" type="text" /></td>
                    <td class="lable">S(事故后果严重等级)</td>
                    <td><input id="hazopSH" name="hazopSH" class="input" maxlength="50" class="easyui-textbox" type="text" /></td>
                </tr>
                <tr class="tr">
                    <td class="lable">不利后果</td>
                    <td colspan="3">
                    <input id="hazopConseqH" name="hazopConseqH" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" />
                    </td>
                </tr>
                <tr class="tr">
                    <td class="lable">防范措施</td>
                    <td colspan="3">
                    <input id="hazopPreventH" name="hazopPreventH" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" />
                    </td>
                </tr>
          </table>      
        
        <br />
        <label style="font-size:16px; font-weight:bold">低&nbsp;报</label>
         <br />
         
      <div  style=" height: 200px; width:100%;padding-top:5px;" border="false">      
       <table id="lowTb" style="width:auto;height:auto;" fit="true" url=""
            toolbar="#lowTool" idField="hazopId"  data-options="onClickRow: onClickRowLow"
            rownumbers="true" fitColumns="true" singleSelect="true">
            <thead>
                <tr>
                    <th field="hazopReason" width="200" align="center" editor="text">可能原因</th>
                    <th field="hazopI" width="150" align="center" data-options="formatter:formatReasonRank"
                        editor="{type:'combobox',
                                 options:{
                                   valueField: 'value',
		                           textField: 'label',
                                   editable:false,
                                   panelHeight:'auto',
		                           data: [{
			                            label: '低报',
			                            value: 'L'
		                            },{
			                            label: '低低报',
			                            value: 'LL'
		                            }
                                    ]
                                 }}">原因等级</th>
                    <th field="hazopMeasure" width="150" align="center"  editor="text">建议措施</th>
                </tr>
            </thead>
        </table>
          <div id="lowTool">
           <a id="appendLowRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="appendRowLow()">增加</a>                     
           <a id="delLowRow" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delRowLow()">删除</a>
        </div>
       </div> 
       
         <table cellpadding="2">
                <tr class="tr">
                    <td class="lable">偏离值</td>
                    <td><input id="hazopBiasValueL" name="hazopBiasValueL"  maxlength="50" class="easyui-numberbox" style="width:240px;height:22px;" type="text" /></td>
                    <td class="lable">RR(风险等级)</td>
                    <td><input id="hazopRRL" name="hazopRRL" class="input" maxlength="50" class="easyui-textbox" type="text"/></td>
                </tr>
                <tr class="tr">
                    <td class="lable">F(潜在事故频率等级)</td>
                    <td><input id="hazopFL" name="hazopFL" class="input" maxlength="50" class="easyui-textbox" type="text" /></td>
                    <td class="lable">S(事故后果严重等级)</td>
                    <td><input id="hazopSL" name="hazopSL" class="input" maxlength="50" class="easyui-textbox" type="text" /></td>
                </tr>
                <tr class="tr">
                    <td class="lable">不利后果</td>
                    <td colspan="3">
                    <input id="hazopConseqL" name="hazopConseqL" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" />
                    </td>
                </tr>
                <tr class="tr">
                    <td class="lable">防范措施</td>
                    <td colspan="3">
                    <input id="hazopPreventL" name="hazopPreventL" style="width: 582px;height:23px;" maxlength="50" class="easyui-textbox" type="text" />
                    </td>
                </tr>
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
             parentId:nodeId,
             tagName:"",
             deviceName:""
           });
           
       }else{
           $('#dg').datagrid('load', {
             parentId:"",
             tagName:"",
             deviceName:""
           });
       }
       
    }
    
    
    //查询
    function queryResult(){
       var bitNo = $("#queryBitNo").val();
       var deviceName = $("#queryDeviceName").val();
      $('#dg').datagrid('load', {
            parentId: nodeId,
            tagName:bitNo,
            deviceName:deviceName
      });
    }
    
    //清空查询条件
    function clearParam(){
       $("#queryBitNo").val("");
       $("#queryDeviceName").val("");
    }
    
    //增加
    var initBitCode = "";
    function append(){
      if(nodeType != "plant"){
         $.messager.alert('提示', '请先选择装置','info');
         return false;
      }
      initBitCode = "";
      //查询工段
      $.ajax({
                url : './alarm_limit_deal_data.ashx',
                data : {
                  flag:"lineDict",
                  plantId:nodeId
                },
                async:false,
                type:"post",
                success : function(result) {
                     var lineDict = eval("("+result+")");  
                     $("#limitLineId").combobox("loadData",lineDict);
                }
            });

      
       $('#dlg').dialog({
               onClose:function(){
                      $("#limitId").val('');
                      $("#limitBitCode").val('');
                      $("#limitDCSCode").val('');
                      $("#limitBitName").val('');
                      $("#limitUnit").val('');
                      $("#limitType").combobox("setValue","");
                      $("#limitLineId").combobox("setValue","");
                      $("#limitDeviceId").combobox("setValue","");
                      $("#limitUpLine").val('');
                      $("#limitDownLine").val('');
                      $("#limitHHigh").val('');
                      $("#limitHigh").val('');
                      $("#limitLLow").val('');
                      $("#limitLow").val('');
                      $("#limitRemark").val('');
               }
          }).dialog('open').dialog('setTitle', '新增');
      
    }
    
    //删除
    function removeit(){
         var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('提示', '请至少选择一条待删除的数据','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].limitId);
         }
         
         $.messager.confirm('Confirm', '确定要删除吗?', function (r) {
           if(r){
               $.ajax({
                    url : './alarm_limit_deal_data.ashx',
                    data : {
                      flag:"delete",
                      plantId:nodeId,
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
    
    //保存报警限信息
    function saveLimitData(){
      var limitBitCode = $("#limitBitCode").val();
      //校验位号是否已经存在
      if(initBitCode == limitBitCode){
           saveData(limitBitCode);
      }else{
           $.ajax({
                url : './alarm_limit_deal_data.ashx',
                data : {
                  flag:"checkIsExist",
                  plantId:nodeId,
                  bitCode:limitBitCode
                },
                async:false,
                type:"post",
                success : function(result) {
                   if(result == "1"){
                      $.messager.alert('提示', '位号'+limitBitCode+"已经存在！");
                      return false;
                   }else{
                       saveData(limitBitCode);
                   }
                }
        });
      }
    }
    
    function saveData(limitBitCode){
      var limitId = $("#limitId").val();
      var limitDCSCode = $("#limitDCSCode").val();
      var limitBitName = $("#limitBitName").val();
      var limitUnit = $("#limitUnit").val();
      var limitType = $("#limitType").combobox("getValue");
      var limitLineId = $("#limitLineId").combobox("getValue");
      var limitDeviceId = $("#limitDeviceId").combobox("getValue");
      var limitUpLine = $("#limitUpLine").val();
      var limitDownLine = $("#limitDownLine").val();
      var limitHHigh = $("#limitHHigh").val();
      var limitHigh = $("#limitHigh").val();
      var limitLLow = $("#limitLLow").val();
      var limitLow = $("#limitLow").val();
      var limitRemark = $("#limitRemark").val();
      
       $.ajax({
            url : './alarm_limit_deal_data.ashx',
            data : {
                flag:"save",
                plantId:nodeId,
                limitId:limitId,
                limitBitCode:limitBitCode,
                limitDCSCode:limitDCSCode,
                limitBitName:limitBitName,
                limitUnit:limitUnit,
                limitType:limitType,
                limitLineId:limitLineId,
                limitDeviceId:limitDeviceId,
                limitUpLine:limitUpLine,
                limitDownLine:limitDownLine,
                limitHHigh:limitHHigh,
                limitHigh:limitHigh,
                limitLLow:limitLLow,
                limitLow:limitLow,
                limitRemark:limitRemark
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
    
    //编辑
    function edit(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('提示', '请选择一条待修改的数据');
              return false;
          }
          initBitCode = rows[0].limitBitCode;
           //查询工段
           $.ajax({
                url : './alarm_limit_deal_data.ashx',
                data : {
                  flag:"lineDict",
                  plantId:nodeId
                },
                async:false,
                type:"post",
                success : function(result) {
                     var lineDict = eval("("+result+")");  
                     $("#limitLineId").combobox("loadData",lineDict);
                }
            });
          
          $("#limitId").val(rows[0].limitId);
          $("#limitBitCode").val(rows[0].limitBitCode);
          $("#limitDCSCode").val(rows[0].limitDCSCode);
          $("#limitBitName").val(rows[0].limitBitName);
          $("#limitUnit").val(rows[0].limitUnit);
          $("#limitType").combobox("setValue",rows[0].limitType);
          $("#limitLineId").combobox("setValue",rows[0].limitLineId);
          
           $("#limitDeviceId").combobox("clear");
           $('#limitDeviceId').combobox('loadData', {});
           //查询设备
           $.ajax({
                    url : './alarm_limit_deal_data.ashx',
                    data : {
                      flag:"deviceDict",
                      plantId:nodeId,
                      lineId:rows[0].limitLineId
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         var deviceDict = eval("("+result+")");  
                         $("#limitDeviceId").combobox("loadData",deviceDict);
                    }
                });
          $("#limitDeviceId").combobox("setValue",rows[0].limitDeviceId);
          
          
          $("#limitUpLine").val(rows[0].limitUpLine);
          $("#limitDownLine").val(rows[0].limitDownLine);
          $("#limitHHigh").val(rows[0].limitHHigh);
          $("#limitHigh").val(rows[0].limitHigh);
          $("#limitLLow").val(rows[0].limitLLow);
          $("#limitLow").val(rows[0].limitLow);
          $("#limitRemark").val(rows[0].limitRemark);
          $('#dlg').dialog({
               onClose:function(){
                      $("#limitId").val('');
                      $("#limitBitCode").val('');
                      $("#limitDCSCode").val('');
                      $("#limitBitName").val('');
                      $("#limitUnit").val('');
                      $("#limitType").combobox("setValue","");
                      $("#limitLineId").combobox("setValue","");
                      $("#limitDeviceId").combobox("setValue","");
                      $("#limitUpLine").val('');
                      $("#limitDownLine").val('');
                      $("#limitHHigh").val('');
                      $("#limitHigh").val('');
                      $("#limitLLow").val('');
                      $("#limitLow").val('');
                      $("#limitRemark").val('');
               }
          }).dialog('open').dialog('setTitle', '编辑');
    }
    
    //格式化仪表类型
    function formatType(val, row){
       if(val == "1"){
         return "现场仪表";
       }else if(val == "2"){
         return "虚拟仪表";
       }else if(val == "3"){
         return "分析仪表";
       }else if(val == "4"){
         return "自定义类型";
       }else if(val == "5"){
         return "固定类型";
       }else if(val == "6"){
         return "持续时间";
       }else if(val == "7"){
         return "瞬时值";
       }
    }
    
    //加载所属设备下拉框
    function initDeviceDict(e){
       $("#limitDeviceId").combobox("clear");
       $('#limitDeviceId').combobox('loadData', {});
       var lineId = e.value;
       //查询设备
       $.ajax({
                url : './alarm_limit_deal_data.ashx',
                data : {
                  flag:"deviceDict",
                  plantId:nodeId,
                  lineId:lineId
                },
                async:false,
                type:"post",
                success : function(result) {
                     var deviceDict = eval("("+result+")");  
                     $("#limitDeviceId").combobox("loadData",deviceDict);
                }
            });
    }
    
    //HAZOP参数配置
    var hazopBitId = "";
    function configHazop(){
      var rows = $('#dg').datagrid('getSelections');
      if(rows == null || rows.length!=1){
          $.messager.alert('提示', '请选择一条待配置的数据');
          return false;
      }
      hazopBitId = rows[0].limitId;
      
      $.ajax({
            url : './alarm_hazop_data_deal.ashx',
            data : {
                flag:"baseInfo",
                plantId:nodeId,
                bitId:hazopBitId
            },
            async:false,
            type:"post",
            success : function(data) {
              var baseInfo = eval('('+data+')');
              $("#hazopBiasValueH").val(baseInfo.biasValueH);
              $("#hazopRRH").val(baseInfo.hazopRRH);
              $("#hazopFH").val(baseInfo.hazopFH);
              $("#hazopSH").val(baseInfo.hazopSH);
              $("#hazopConseqH").val(baseInfo.conseqH);
              $("#hazopPreventH").val(baseInfo.preventH);
           
              $("#hazopBiasValueL").val(baseInfo.biasValueL);
              $("#hazopRRL").val(baseInfo.hazopRRL);
              $("#hazopFL").val(baseInfo.hazopFL);
              $("#hazopSL").val(baseInfo.hazopSL);
              $("#hazopConseqL").val(baseInfo.conseqL);
              $("#hazopPreventL").val(baseInfo.preventL);
            }
         });
      
       $("#processTable").datagrid({
            url:'alarm_hazop_list_data.ashx',
            queryParams: {
                plantId:nodeId,
                bitId:rows[0].limitId,
                bias:'高'
            }
           });
       
      $("#lowTb").datagrid({
            url:'alarm_hazop_list_data.ashx',
            queryParams: {
                plantId:nodeId,
                bitId:rows[0].limitId,
                bias:'低'
            }
       });    
           
      
      $('#hazopDiv').dialog({
               onClose:function(){
                  $("#hazopBiasValueH").val("");
                  $("#hazopRRH").val("");
                  $("#hazopFH").val("");
                  $("#hazopSH").val("");
                  $("#hazopConseqH").val("");
                  $("#hazopPreventH").val("");
               
                  $("#hazopBiasValueL").val("");
                  $("#hazopRRL").val("");
                  $("#hazopFL").val("");
                  $("#hazopSL").val("");
                  $("#hazopConseqL").val("");
                  $("#hazopPreventL").val("");
               }
          }).dialog('open').dialog('setTitle', '参数报警分析');
    
    }
    
    //---高报--start
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
    function delRow(){
        if (editIndex == undefined){
            alert("请选中要删除的记录");
            return
        }

        $('#processTable').datagrid('cancelEdit', editIndex)
                .datagrid('deleteRow', editIndex);
        editIndex = undefined;
    }
    //---高报--end
    
    //---低报--start
    var editIndexlow = undefined;
    function endEditinglow(){
        if (editIndexlow == undefined){return true}
        if ($('#lowTb').datagrid('validateRow', editIndexlow)){
            $('#lowTb').datagrid('acceptChanges');
            return true;
        } else {
            return false;
        }
    }
    function onClickRowLow(index){
        if (editIndexlow != index){
            if (endEditinglow()){
                $('#lowTb').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                editIndexlow = index;
            } else {
                $('#lowTb').datagrid('selectRow', editIndexlow);
            }
        }
    }
    function appendRowLow(){
        if (endEditinglow()){
            $('#lowTb').datagrid('appendRow',{
                
            });
            editIndexlow = $('#lowTb').datagrid('getRows').length-1;
            $('#lowTb').datagrid('selectRow', editIndexlow)
                    .datagrid('beginEdit', editIndexlow);
        }
    } 
    
   function delRowLow(){
        if (editIndexlow == undefined){
            alert("请选中要删除的记录");
            return
        }

        $('#lowTb').datagrid('cancelEdit', editIndexlow)
                .datagrid('deleteRow', editIndexlow);
        editIndexlow = undefined;
    }
    //---低报--end
    
    
    //保存hazop数据
    function saveHazopData(){
        if (endEditing() && endEditinglow()){
           editIndex = undefined;
           $('#processTable').datagrid('acceptChanges');
           
           editIndexlow = undefined;
           $('#lowTb').datagrid('acceptChanges');
           
           var paramArr = new Array();
           var rowsData = $('#processTable').datagrid('getRows');
           for(var i=0;i<rowsData.length;i++){
              paramArr.push({
                 hazopReason:rowsData[i].hazopReason,
                 hazopI:rowsData[i].hazopI,
                 hazopMeasure:rowsData[i].hazopMeasure
              });
           }
          var paramJson = "";
          if(paramArr.length>0){
             paramJson = JSON.stringify(paramArr);
          }
           
           var paramArrLow = new Array();
           var rowsDataLow = $('#lowTb').datagrid('getRows');
           for(var i=0;i<rowsDataLow.length;i++){
              paramArrLow.push({
                 hazopReason:rowsDataLow[i].hazopReason,
                 hazopI:rowsDataLow[i].hazopI,
                 hazopMeasure:rowsDataLow[i].hazopMeasure
              });
           }
           var paramJsonLow = "";
           if(paramArrLow.length>0){
             paramJsonLow = JSON.stringify(paramArrLow);
           }
           
           var hazopBiasValueH = $("#hazopBiasValueH").val();
           var hazopRRH = $("#hazopRRH").val();
           var hazopFH = $("#hazopFH").val();
           var hazopSH = $("#hazopSH").val();
           var hazopConseqH = $("#hazopConseqH").val();
           var hazopPreventH = $("#hazopPreventH").val();
           
           var hazopBiasValueL = $("#hazopBiasValueL").val();
           var hazopRRL = $("#hazopRRL").val();
           var hazopFL = $("#hazopFL").val();
           var hazopSL = $("#hazopSL").val();
           var hazopConseqL = $("#hazopConseqL").val();
           var hazopPreventL = $("#hazopPreventL").val();
           
         
                  
          $.ajax({
            url : './alarm_hazop_data_deal.ashx',
            data : {
                flag:"save",
                plantId:nodeId,
                bitId:hazopBitId,
                hazopBiasValueH:hazopBiasValueH,
                hazopRRH:hazopRRH,
                hazopFH:hazopFH,
                hazopSH:hazopSH,
                hazopConseqH:hazopConseqH,
                hazopPreventH:hazopPreventH,
                hazopBiasValueL:hazopBiasValueL,
                hazopRRL:hazopRRL,
                hazopFL:hazopFL,
                hazopSL:hazopSL,
                hazopConseqL:hazopConseqL,
                hazopPreventL:hazopPreventL,
                paramJson:paramJson,
                paramJsonLow:paramJsonLow
            },
            async:false,
            type:"post",
            success : function(data) {
               if(data!=null && data == "1"){
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
    }
    
    //格式化原因等级
    function formatReasonRank(val, row){
    debugger;
       if(val == "H"){
          return "高报";
       }else if(val == "HH"){
          return "高高报";
       }else if(val == "L"){
          return "低报";
       }else if(val == "LL"){
          return "低低报";
       }
    }
   
</script>

