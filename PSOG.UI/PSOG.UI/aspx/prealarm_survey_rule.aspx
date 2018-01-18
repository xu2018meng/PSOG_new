<%@ Page Language="C#" AutoEventWireup="true" CodeFile="prealarm_survey_rule.aspx.cs" Inherits="aspx_alarm_pre_survey_rule" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>预警监测规则</title>
     <% 
        String id = Request.QueryString["id"];
        String plantId = Request.QueryString["plantId"];
        String bitCode = Request.QueryString["bitCode"];
        bitCode = null == bitCode ? "" : bitCode;
        String tagDesc = Request.QueryString["tagDesc"];
        tagDesc = null == tagDesc ? "" : tagDesc;
        SysUser user = ((SysUser)Session[CommonStr.session_user]);
        String userId = user.userId;
        String userName = user.userName;
      %>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" /> 
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        *
        {
            margin: 0;
            padding: 0;
        }
        
        html,body, #form1 {
            font-size:12px;
            width:100%;
            height:100%;
        }
       
         .td_lable
        {
            text-align: center;
            width: 80px;
            height: 28px;
        }
        
        td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:6px 0px 6px 6px;height:28px;}
        table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
        
       input[type=checkbox] {
            display: inline-block;
            height: 21px;
            width: 21px;
            border: 1px solid #000;
            overflow: hidden;
            vertical-align: middle;
            text-align: left;
            -webkit-appearance: none;
            font: normal normal normal 14px/1 FontAwesome;
            outline: 0;
            background: 0 0;
       }
        input[type=checkbox]:checked:after {
            content: '√';
            font-size: 20px;
            text-align: left;
            vertical-align:bottom;
            line-height: 21px;
            color: #f00;
        }
        
    </style>
</head>
<body onload="initInfo();" style="background-color:#eef6fe;">
    <form id="form1"  action="">
     <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:微软雅黑;">
     &nbsp;&nbsp;当前位置：<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new.aspx?plantId=<%=plantId %>">主页</a>
   &nbsp;>&nbsp;<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="earlyAlarm_realTime_list.aspx?plantId=<%=plantId %>">预警实时数据</a>
    &nbsp;>&nbsp;预警规则
    </div>
    
        <div style="padding-top:7px;width:850px;padding-left:13.5%;">
            <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px;">基本信息</div>
            <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="1" cellspacing="0"  style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>位&nbsp;&nbsp;号</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:28px;">
                           <label id="bitNo"></label>
                        </td>
                         <td class="td_lable" >
                           <label>状&nbsp;&nbsp;态</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:28px;">
                           <label id="status"></label>
                        </td>
                        <td class="td_lable">
                           <label>类&nbsp;&nbsp;型</label>
                        </td>
                        <td class="td_input" style="width:140px;height:28px;">
                           <label id="typeName"></label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>实时值</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:28px;">
                           <label id="realValue"></label>
                        </td>
                        <td class="td_lable">
                           <label>描&nbsp;&nbsp;述</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:240px;height:28px;" >
                           <label id="desc"></label>
                        </td>
                         <td class="td_lable">
                           <label>是否确认</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:28px;">
                           <label id="isConfirm"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
            <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px;">预警规则</div>
            <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="1" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>走平判断</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                          <input id="bitNo1" name="bitNo1" class="easyui-combobox" style="width:240px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto'
		                         "/> 
                        </td>
                        <td class="td_lable" style="text-align:center">
                          <input id="condition1" name="condition1" class="easyui-combobox" style="width:60px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '＞',
			                        value: '＞'
		                        },{
			                        label: '＝',
			                        value: '＝'
		                        },{
			                        label: '＜',
			                        value: '＜'
		                        }]" /> 
                          
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-textbox" style="width:88%; height: 20px;" id="ruleValue1" name="ruleValue1" value="" ></input>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                           <input type="checkbox" id="isCheck1" name="isCheck1" style="height:20px;width:20px;" value="1"   />
                        </td>
                       
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>升降趋势</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                            <input id="bitNo2" name="bitNo2" class="easyui-combobox" style="width:240px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto'
		                         "/> 
                        </td>
                        <td class="td_lable" style="text-align:center">
                            <input id="condition2" name="condition2" class="easyui-combobox" style="width:60px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '＞',
			                        value: '＞'
		                        },{
			                        label: '＝',
			                        value: '＝'
		                        },{
			                        label: '＜',
			                        value: '＜'
		                        }]" /> 
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-textbox" style="width:88%; height: 20px;" id="ruleValue2" name="ruleValue2" value="" ></input>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                           <input type="checkbox" id="isCheck2" name="isCheck2" style="height:20px;width:20px;" value="1"   />
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>变化幅度</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="bitNo3" name="bitNo3" class="easyui-combobox" style="width:240px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto'
		                         "/> 
                        </td>
                        <td class="td_lable" style="text-align:center">
                            <input id="condition3" name="condition3" class="easyui-combobox" style="width:60px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '＞',
			                        value: '＞'
		                        },{
			                        label: '＝',
			                        value: '＝'
		                        },{
			                        label: '＜',
			                        value: '＜'
		                        }]" /> 
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-textbox" style="width:88%; height: 20px;" id="ruleValue3" name="ruleValue3" value="" ></input>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                            <input type="checkbox" id="isCheck3" name="isCheck3" style="height:20px;width:20px;" value="1"   />
                        </td>
                      
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>归零判断</label>
                        </td>
                         <td class="td_input" style="text-align:center;width:33%;">
                            <input id="bitNo4" name="bitNo4" class="easyui-combobox" style="width:240px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto'
		                         "/>  
                        </td>
                        <td class="td_lable" style="text-align:center;">
                            <input id="condition4" name="condition4" class="easyui-combobox" style="width:60px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '＞',
			                        value: '＞'
		                        },{
			                        label: '＝',
			                        value: '＝'
		                        },{
			                        label: '＜',
			                        value: '＜'
		                        }]" /> 
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-textbox" style="width:88%; height: 20px;" id="ruleValue4" name="ruleValue4" value="" ></input>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                            <input type="checkbox" id="isCheck4" name="isCheck4" style="height:20px;width:20px;" value="1"   />
                        </td>
                      
                    </tr>
                </table>
            </div>
            
            <br />
              
             <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px;">通知规则</div>
             <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="1" cellspacing="0"  style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>预警开始</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input  class="easyui-numberbox" style="width:85%; height: 20px;"  id="alarmStartTime1" name="alarmStartTime1"  data-options="precision:0"></input>分钟
                        </td>
                        <td class="td_lable">
                           <label>通&nbsp;&nbsp;知</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan1" name="alarmStartMan1" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv, editable:false"></input>
                        </td>
                        <td class="td_lable" style="text-align:left" colspan='2'>
                           <input id="alarmStartMan1Id" name="alarmStartMan1Id" style="display:none"/>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>预警开始</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                          <input class="easyui-numberbox" style="width:85%; height: 20px;" id="alarmStartTime2" name="alarmStartTime2" value="" data-options="precision:0"></input>分钟
                        </td>
                        <td class="td_lable" >
                           <label>通&nbsp;&nbsp;知</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan2" name="alarmStartMan2" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv2, editable:false"></input>
                        </td>
                      
                        <td class="td_lable" style="text-align:right" colspan='2'>
                         <input id="alarmStartMan2Id" name="alarmStartMan2Id" style="display:none"/>
                        </td>
                        
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>预警开始</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-numberbox" style="width:85%; height: 20px;" id="alarmStartTime3" name="alarmStartTime3" value="" data-options="precision:0"></input>分钟
                        </td>
                        <td class="td_lable" >
                           <label>通&nbsp;&nbsp;知</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan3" name="alarmStartMan3" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv3, editable:false"></input>
                        </td>
                       
                        <td class="td_lable" style="text-align:right" colspan='2'>
                           <input id="alarmStartMan3Id" name="alarmStartMan3Id" style="display:none"/>
                        </td>
                       
                    </tr>
                </table>
            </div>
            <div style="padding-top:5px;padding-left:40%">
                <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-save" onclick="save();" id="a_save"  style="width: 70px">保存</a>
            </div>
        </div>
    </form>
    
     <div id="userDiv" class="easyui-dialog" closed="true" title="人员选择" style="width: 350px; height: 500px; overflow: hidden" buttons="#userDiv-buttons" modal="true">
        <iframe id='BitTree' name="BitTree" src="" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="userDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelect();" style="width: 70px">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#userDiv').dialog('close')" style="width: 70px">取消</a>
        </div>
    </div>
</body>
</html>

<script type="text/javascript">
   
   //初始化信息
   var isHasEdit = "1";
   var bitNo = "";
   var curState= "";
   function initInfo(){
      var dictJson = '<%=dictJson %>';
      var bitDict = eval('('+dictJson+')');
      $("#bitNo1").combobox("loadData",bitDict);
      $("#bitNo2").combobox("loadData",bitDict);
      $("#bitNo3").combobox("loadData",bitDict);
      $("#bitNo4").combobox("loadData",bitDict);
    
       //基本信息
       var bitJson = '<%=bitJson %>';
       var bitInfo = eval('('+bitJson+')');
       bitNo = '<%=bitCode %>';
       var bitHtml = "<a href='#' onclick='showHistoryLine()'>"+bitNo+"</a>";
       $("#bitNo").html(bitHtml);
       curState = bitInfo.status;
       $("#typeName").html(bitInfo.typeName);
       $("#status").html(bitInfo.status);
       $("#realValue").html(bitInfo.realValue);
       $("#desc").html('<%=tagDesc %>');
       
        if(bitInfo.isConfirm == "已确认"){
           $("#isConfirm").html(bitInfo.isConfirm);
       }else{
           var html = "<a href='#' onclick='confirmAlarm()'>未确认</a>";
           $("#isConfirm").html(html);
       }
       
       //规则信息
       var ruleJson = '<%=ruleJson %>';
       var ruleInfo = eval('('+ruleJson+')');
       if(ruleInfo.earlyAlarmRule!=null && ruleInfo.earlyAlarmRule.length>0){
               var ruleRows = ruleInfo.earlyAlarmRule.split('#');
               var ruleCell1 = ruleRows[0].split('@');
               var ruleCell2 = ruleRows[1].split('@');
               var ruleCell3 = ruleRows[2].split('@');
               var ruleCell4 = ruleRows[3].split('@');
               
               $("#bitNo1").combobox("setValue",ruleCell1[1]);
               $("#condition1").combobox("setValue",ruleCell1[2]);
               $("#ruleValue1").val(ruleCell1[3]);
               if(ruleCell1[4]==1){
                   $("#isCheck1").attr("checked","true");
               }
               
               $("#bitNo2").combobox("setValue",ruleCell2[1]);
               $("#condition2").combobox("setValue",ruleCell2[2]);
               $("#ruleValue2").val(ruleCell2[3]);
               if(ruleCell2[4]==1){
                   $("#isCheck2").attr("checked","true");
               }
               
               $("#bitNo3").combobox("setValue",ruleCell3[1]);
               $("#condition3").combobox("setValue",ruleCell3[2]);
               $("#ruleValue3").val(ruleCell3[3]);
               if(ruleCell3[4]==1){
                   $("#isCheck3").attr("checked","true");
               }
               
               $("#bitNo4").combobox("setValue",ruleCell4[1]);
               $("#condition4").combobox("setValue",ruleCell4[2]);
               $("#ruleValue4").val(ruleCell4[3]);
               if(ruleCell4[4]==1){
                   $("#isCheck4").attr("checked","true");
               }
       }
      
       
       
       $("#alarmStartTime1").numberbox("setValue",ruleInfo.earlyAlarmTime1);
       $("#alarmStartMan1").searchbox("setValue",ruleInfo.earlyAlarmManName1);
       $("#alarmStartMan1Id").val(ruleInfo.earlyAlarmMan1);
       
       $("#alarmStartTime2").numberbox("setValue",ruleInfo.earlyAlarmTime2);
       $("#alarmStartMan2").searchbox("setValue",ruleInfo.earlyAlarmManName2);
       $("#alarmStartMan2Id").val(ruleInfo.earlyAlarmMan2);
       
       $("#alarmStartTime3").numberbox("setValue",ruleInfo.earlyAlarmTime3);
       $("#alarmStartMan3").searchbox("setValue",ruleInfo.earlyAlarmManName3);
       $("#alarmStartMan3Id").val(ruleInfo.earlyAlarmMan3);
       
       isHasEdit = '<%=isHasEdit %>';
       if(isHasEdit!="1"){
          $("form[id='form1'] table input").attr("disabled", "disabled");
          $("#bitNo1").combobox("disable");
          $("#condition1").combobox("disable");
          $("#bitNo2").combobox("disable");
          $("#condition2").combobox("disable");
          $("#bitNo3").combobox("disable");
          $("#condition3").combobox("disable");
          $("#bitNo4").combobox("disable");
          $("#condition4").combobox("disable");
          
          $("#a_save").hide();
       }
   }
   
    //确认报警
   function confirmAlarm(){
        if(curState==null || curState.length<=0){
           $.messager.alert('提示', '请在预警状态下确认');              
           return false;
        }
        $.messager.confirm('Confirm', '您要确认这条预警信息吗?', function (r) {
           if(r){
                $.ajax({
                   url : './prealarm_survey_rule_confirm.ashx',
                   data : {
                       id:'<%=id %>',
                       plantId:'<%=plantId %>',
                        userId:'<%=userId %>',
                       userName:'<%=userName %>'
                   },
                async:false,
                type:"post",
                success : function(data) {
                    if(data=="1"){
                      $("#isConfirm").html("已确认");
                       $.messager.show({
                            title : '提示',
                            msg : "确认成功"
                            
                       });   
                    }else{
                        $.messager.show({
                            title : '提示',
                            msg : "确认失败"
                            
                        });   
                    }            
                }
              });
           }
         });
  
   }
   

   var manEditorName = "";
   var manEditorId = "";
   //通知框1
   function openUserDiv(value,name){
      if(isHasEdit != "1"){
        return false;
      }
   
     manEditorName = "alarmStartMan1";
     manEditorId = "alarmStartMan1Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
   //通知框2
    function openUserDiv2(value,name){
      if(isHasEdit != "1"){
        return false;
      }
    
     manEditorName = "alarmStartMan2";
     manEditorId = "alarmStartMan2Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
   //通知框3
    function openUserDiv3(value,name){
      if(isHasEdit != "1"){
        return false;
      }
    
     manEditorName = "alarmStartMan3";
     manEditorId = "alarmStartMan3Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
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
    
  
     //保存
   function save(){
     var bitNo1 = $("#bitNo1").combobox("getValue");
     var condition1 = $("#condition1").combobox("getValue");
     var ruleValue1 = $("#ruleValue1").val();
     var isCheck1 = "0";
     if($("#isCheck1")[0].checked){
         isCheck1 = "1";
     }
     
     var bitNo2 = $("#bitNo2").combobox("getValue");
     var condition2 = $("#condition2").combobox("getValue");
     var ruleValue2 = $("#ruleValue2").val();
     var isCheck2 = "0";
     if($("#isCheck2")[0].checked){
         isCheck2 = "1";
     }
     
     var bitNo3 = $("#bitNo3").combobox("getValue");
     var condition3 = $("#condition3").combobox("getValue");
     var ruleValue3 = $("#ruleValue3").val();
     var isCheck3 = "0";
     if($("#isCheck3")[0].checked){
         isCheck3 = "1";
     }
     
     var bitNo4 = $("#bitNo4").combobox("getValue");
     var condition4 = $("#condition4").combobox("getValue");
     var ruleValue4 = $("#ruleValue4").val();
     var isCheck4 = "0";
     if($("#isCheck4")[0].checked){
         isCheck4 = "1";
     }
     
     var rule = "走平@"+bitNo1+"@"+condition1+"@"+ruleValue1+"@"+isCheck1
          +"#持续上升或下降@"+ bitNo2+"@"+condition2+"@"+ruleValue2+"@"+isCheck2
          +"#变化幅度过快@"+ bitNo3+"@"+condition3+"@"+ruleValue3+"@"+isCheck3
          +"#归零@"+ bitNo4+"@"+condition4+"@"+ruleValue4+"@"+isCheck4;
     
     var time1 = $("#alarmStartTime1").val();
     var manId1 = $("#alarmStartMan1Id").val();
     var man1 = $("#alarmStartMan1").searchbox("getValue");
     if(man1==null || man1.length==0){
        manId1 = "";
     }
     
     var time2 = $("#alarmStartTime2").val();
     var man2 = $("#alarmStartMan2").searchbox("getValue");
     var manId2 = $("#alarmStartMan2Id").val();
     if(man2==null || man2.length==0){
         manId2 = "";
     }
     
     var time3 = $("#alarmStartTime3").val();
     var man3 = $("#alarmStartMan3").searchbox("getValue");
     var manId3 = $("#alarmStartMan3Id").val();
     if(man3==null || man3.length==0){
         manId3 = "";
     }
     
     $.ajax({
            url : './prealarm_survey_rule_data.ashx',
            data : {
                id:'<%=id %>',
                plantId:'<%=plantId %>',
                rule:rule,
                time1:time1,
                man1:manId1,
                manName1:man1,
                time2:time2,
                man2:manId2,
                manName2:man2,
                time3:time3,
                man3:manId3,
                manName3:man3
            },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
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
   
  function showHistoryLine(){
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + bitNo + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + bitNo + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
    }
   }
   
   function getBrowserType() {
    var ua = navigator.userAgent.toLowerCase();

    if(ua.match(/msie ([\d.]+)/))return 1;

    if(ua.match(/firefox\/([\d.]+)/))return 2;

    if(ua.match(/chrome\/([\d.]+)/))return 3;

    if(ua.match(/opera.([\d.]+)/))return 4;

    if(ua.match(/version\/([\d.]+).*safari/))return 5;

    return 0;
}
    
</script>
