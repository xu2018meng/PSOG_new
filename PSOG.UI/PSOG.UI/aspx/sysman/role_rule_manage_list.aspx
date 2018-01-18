<%@ Page Language="C#" AutoEventWireup="true" CodeFile="role_rule_manage_list.aspx.cs" Inherits="role_rule_manage_list" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Entity" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>角色树</title>
    <% 
       string roleId = Request.QueryString["roleId"];
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
<body onload="init();">
    <form id="form1" action="" style="padding: 8px">
        <input type="button" id="button_save" value="保存" onclick="saveAllData();"/>
        <div style="vertical-align:middle;">
            <div style="padding-top:10px;"><label>规则<span style="color:red">*</span>：</label></div>
            <div style="padding-left:30px;">
                <p><input type="checkbox" class="gz" name="category" value="bj" id="bj" />报警规则 </p>   
                <p><input type="checkbox" class="gz" name="category" value="yj" id="yj" />预警规则</p>
                <p><input type="checkbox" class="gz" name="category" value="yc" id="yc" />异常规则</p>   
            </div> 
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
   
    //初始化
    function init(){
       var alarmRule = '<%=alarmRule %>';
       var rules = alarmRule.split(',');
       for(var i=0;i<rules.length;i++){
           $("#"+rules[i]).attr("checked","true");
       }
    }
  
    
    //保存
    function saveAllData(){
         var rule = "";
         $("input:checkbox").each(function(){
            if($(this)[0].checked==true){
               rule += $(this).val() +",";
            }
         });
         if(rule.length>0){
            rule = rule.substring(0,rule.length-1);
         }
            
         $.ajax({
            url:'role_rule_manage_deal.ashx',
            data:{rule:rule,roleCode:'<%=roleId %>'},
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

