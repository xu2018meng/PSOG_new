<%@ Page Language="C#" AutoEventWireup="true" CodeFile="organ_info.aspx.cs" Inherits="aspx_sysman_organ_info" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<% 
       String prentID = Request.QueryString["prentID"];
       prentID = (null == prentID ? "1" : prentID); %>
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../resource/js/WdatePicker.js"></script>
    
    <script language="javascript">
        function update(){
            var code = "<%=prentID%>";
            $.ajax({
                url : './organ_manage_main_data.ashx',
                data : {
                    action:"update",
                    SYS_ORGAN_CODE:code,
                    SYS_ORGAN_NAME:$('#SYS_ORGAN_NAME').val()
                },
                async:true,
                type:"post",
                beforeSend:function(){}, //添加loading信息
                dataType : 'json',
                success : function(data) {
                    if(data == 0){
                        $.messager.show({
                            title : '提示',
                            msg : "保存成功"
                        });
                        parent.window.refish(code,"");
                    }else{
                        alert("保存失败");
                    }
                },
                error:function(xhr){alert('发生错误：'+xhr.responseText);}
            });
        }
    </script>
</head>
<body id="art_check_body" class="easyui-layout" style="width:100%; height:100%; overflow:hidden" >
    <!-- #include file="../include_loading.aspx" -->
    <form id="ff"  method="post">
        <iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
        <div style="padding-top:5px;padding-left:30px;">
         <a href="javascript:void(0)" class="easyui-linkbutton"  onclick="update()">修改</a>
         </div>
         <div title="部门信息">
            <table cellspacing="0" cellpadding="2">
                <tr>
                    <td style="width:100px" align="center">部门名称</td>
                    <td><input id="SYS_ORGAN_NAME" style="width: 250px" value="<%=orgName %>" class="easyui-textbox" type="text"  name="SYS_ORGAN_NAME" data-options="required:true"/></td>
                </tr>
                <tr>
                    <td style="width:100px" align="center">创建时间</td>
                    <td><label><%=orgCreateTime %></label></td>
                </tr>
            </table>
            </div>
        </form>
</body>
</html>
