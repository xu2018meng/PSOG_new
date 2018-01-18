<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wx_report_setting_info.aspx.cs" Inherits="wx_report_setting_info" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Entity" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>报表推送配置信息</title>
    <% 
        string plantId = Request.QueryString["plantId"];
         %>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        body{
          font-size:14px;
        }
        .gz {
           height:18px;
           width:18px;
           vertical-align:text-top;
           margin-top:0;
        }
    </style>
</head>
<body onload="initInfo();">
    <form id="form1" action="" style="padding: 20px">
      
        <div style="vertical-align:middle;">
            <table>
              <tr>
                <td><span>通&nbsp;&nbsp;知：</span></td>
                <td>
                   <input id="alarmStartMan1" name="alarmStartMan1" class="easyui-searchbox" style="width:400px;height: 23px;" data-options="searcher:openUserDiv, editable:false"></input>
                </td>
                <td>
                  <input id="alarmStartMan1Id" name="alarmStartMan1Id" style="display:none"/>
                </td>
              </tr>
              <tr style="height:50px;">
                 <td colspan="2" style="text-align:center;"><input type="button" id="button_save" value="保存" onclick="saveAllData();"/></td>
              </tr>
            </table>
             
        </div>
         
       <div id="userDiv" class="easyui-dialog" closed="true" title="人员选择" style="width: 350px; height: 500px; overflow: hidden" buttons="#userDiv-buttons" modal="true">
        <iframe id='WXReportTree' name="WXReportTree" src="" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="userDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelect();" style="width: 70px">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#userDiv').dialog('close')" style="width: 70px">取消</a>
        </div>
      </div>
    
    </form>
</body>
</html>
<script type="text/javascript">
    //点击树，初始化配置信息
   function initInfo(){
      var configJson = '<%=configInfo %>';
      var configInfo = eval('('+configJson+')');
      $("#alarmStartMan1").searchbox("setValue",configInfo.WXReportConfigToUserName);
      $("#alarmStartMan1Id").val(configInfo.WXReportConfigToUserId);
   }
    
    
   var manEditorName = "";
   var manEditorId = "";
   //通知框1
   function openUserDiv(value,name){
     manEditorName = "alarmStartMan1";
     manEditorId = "alarmStartMan1Id";
     $("#WXReportTree").attr("src","../user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#WXReportTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '人员选择');
   }
   
    //确定选择
   function confirmSelect(){
      window.WXReportTree.confirmSelect();
   }
   
   //关闭人员选择框
   function closeDialog(userIds,userNames){
     $("#"+manEditorId).val(userIds);
     $("#"+manEditorName).searchbox("setValue",userNames);
     $('#userDiv').dialog('close');
   }
  
    
    //保存
    function saveAllData(){
       var manId1 = $("#alarmStartMan1Id").val();
       var man1 = $("#alarmStartMan1").searchbox("getValue");
       if(man1==null || man1.length==0){
         manId1 = "";
       }
            
       $.ajax({
            url:'wx_report_setting_deal.ashx',
            data:{
                toUserId:manId1,
                toUserName:man1,
                plantId:'<%=plantId %>'
                },
            async:true,
            type:"post",
            success: function (data){
                if(data=="1"){
                    $.messager.show({
                        title:'提示',
                        msg:"保存成功"
                    });
                }else{
                     $.messager.show({
                        title:'提示',
                        msg:"保存失败"
                     });
                }
            },
            error:function(){
               $.messager.show({
                    title:'提示',
                    msg:"保存失败"
                });
            }
         });

    }

    
</script>

