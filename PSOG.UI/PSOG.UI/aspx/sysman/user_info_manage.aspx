<%@ Page Language="C#" AutoEventWireup="true" CodeFile="user_info_manage.aspx.cs" Inherits="aspx_sysman_user_info_manage" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>用户信息</title>
    <%
       string userId = Request.QueryString["userId"];
       SysUser user = ((SysUser)Session[CommonStr.session_user]);
       user = null == user ? new SysUser() : user;
         %>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/sysManageStyle.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../resource/js/MD5.js"></script>
    <style type="text/css">
        html,body, #form1 {
            font-size:12px;
            width:100%;
            height:100%;
        }
        .td_left{
            width:35%;
            text-align:right;
        }
        .td_right{
            width:50%;
            text-align:left;
        }
        
        input{
            width:140px;
        }
    </style>
</head>
<body>
    <form id="form1" >
        <div style="padding:10px;">
            <div style="font-size:14px; font-weight:700; color:#e36c02; padding-left:42%">用户信息修改</div>
            <div style="font-size:12px; padding-top:15px; ">
                <table cellpadding="5" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_left">用户名:</td>
                        <td class="td_right"><input class="easyui-textbox" type="text" id="userName" name="userName" value="<%=user.userName %>" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td class="td_left">登录名:</td>
                        <td class="td_right"><input class="easyui-textbox" type="text" id="userLoginName" name="userLoginName" value="<%=user.userLoginName %>" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td class="td_left">旧密码:</td>
                        <td class="td_right"><input class="easyui-textbox" type="password" id="oldPassword" name="oldPassword" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td class="td_left">新密码:</td>
                        <td class="td_right"><input class="easyui-textbox" type="password" id="newPassword" name="newPassword" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td class="td_left">确认密码:</td>
                        <td class="td_right"><input class="easyui-textbox" type="password" id="confirmPassword" name="confirmPassword" data-options="required:true"></input></td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center; padding-top:15px;">
                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">提交</a>
                <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">重置</a>
            </div>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">

    function submitForm(){
        var userName = document.getElementById("userName").value;
        var userLoginName = document.getElementById("userLoginName").value;
        var oldPassword = document.getElementById("oldPassword").value;
        var newPassword = document.getElementById("newPassword").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        
        if("" == userName){
            alert("用户名不能为空！");
            return ;
        }
        if("" == userLoginName){
            alert("登录名不能为空！");
            return ;
        }
        if("" == oldPassword){
            alert("旧密码不能为空！");
            return ;
        }
       
        if(newPassword != confirmPassword){
            alert("新密码与确认密码不一致！");
            return ;
        }
        
        $.ajax({
            url : './user_info_oper.ashx',
            data : {
                isDel:"1",
                userId: '<%=user.userId %>',
                userName: userName,
                userLoginName: userLoginName,
                oldPassword: hex_md5(oldPassword),
                newPassword: hex_md5(newPassword)
            },
            async:false,
            type:"post",
            success : function(data) {
                $.messager.show({
                        title : '提示',
                        msg : data.split(":")[0]
                        
                });                
            }
        });
    }
    
    function clearForm(){
        $('#form1').form('clear');
    }
</script>
