<%@ Page Language="C#" AutoEventWireup="true" CodeFile="organ_manage.aspx.cs" Inherits="aspx_sysman_organ_manage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <% 
       String prentID = Request.QueryString["prentID"];
       prentID = (null == prentID ? "1" : prentID); %>
    <title>无标题页</title>
<%--    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>--%>
    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../resource/js/WdatePicker.js"></script>
    
    <script type="text/javascript">  
    Date.prototype.Format = function (fmt) { //author: meizz 
            var o = {
                "M+": this.getMonth() + 1, //月份 
                "d+": this.getDate(), //日 
                "h+": this.getHours(), //小时 
                "m+": this.getMinutes(), //分 
                "s+": this.getSeconds(), //秒 
                "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
                "S": this.getMilliseconds() //毫秒 
            };
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
        }
        function initDiaglg(){
            $('#dlg').dialog('open');
            $("#SYS_ORGAN_CRT_TIME").val((new Date()).Format("yyyy-MM-dd hh:mm:ss"));
        }
        function deleteOrg(){
            var ids = "";
            var code = "<%=prentID%>";
            var row = $('#dg').datagrid('getSelections');
            for(var i=0; i<row.length; i++){
                ids += (row[i].ID);
                if(i<row.length-1){
                    ids += ",";
                }
            }
            $.ajax({
                url : './organ_manage_main_data.ashx',
                data : {
                    action:"delete",
                    ID:ids
                },
                async:true,
                type:"post",
                dataType : 'json',
                success : function(data) {
                    $.messager.show({
                        title : '提示',
                        msg : "删除成功"
                    });
                    parent.window.refish(code,"ORGAN");
                },
                error:function(xhr){alert('发生错误：'+xhr.responseText);}
            });
        }
         function alterOrg(){
        
           var row = $('#dg').datagrid('getSelections');
           if(row.length==0)
           {alert("选择一条进行修改");}
           else if(row.length==1)
           {
            $('#Div1').dialog('open');
            $('#SYS_ORGAN_NAME1').val(row[0].SYS_ORGAN_NAME);
            $('#SYS_ORGAN_TYPE1').val(row[0].SYS_ORGAN_TYPE);
            $('#SYS_ORGAN_CRT_TIME1').val(row[0].SYS_ORGAN_CRT_TIME);
            $('#SYS_ORGAN_ORDER1').val(row[0].SYS_ORGAN_ORDER);
           }
           else
           {alert("只能选一条进行修改")}
           
        }
         function upData(){
            var type =  $('#SYS_ORGAN_TYPE').val()=="单位"?"01":"02";
            var row = $('#dg').datagrid('getSelections');
            var code =row[0].SYS_ORGAN_CODE;
            var pcode = "<%=prentID%>";
            $.ajax({
                url : './organ_manage_main_data.ashx',
                data : {
                    action:"update",
                    SYS_ORGAN_CODE:code,
                    SYS_ORGAN_NAME : $('#SYS_ORGAN_NAME1').val(),
//                    SYS_ORGAN_TYPE : type,
                    SYS_ORGAN_CRT_TIME : $('#SYS_ORGAN_CRT_TIME1').val(),
                   SYS_ORGAN_ORDER:$('#SYS_ORGAN_ORDER1').val()
                },
                async:true,
                type:"post",
                dataType : 'json',
                success : function(data) {
                    //alert(data);
                     if(data == 0){
                        $('#dlg').dialog('close');
                        $.messager.show({
                            title : '提示',
                            msg : "修改成功"
                        });
                        parent.window.refish(pcode,"ORGAN");
                    }else{
                        alert("修改失败");
                    }
                },
                error:function(xhr){alert('发生错误：'+xhr.responseText);}
            });
        }
        function saveData(){
            var type =  $('#SYS_ORGAN_TYPE').val()=="单位"?"01":"02";
            var code = "<%=prentID%>";
            $.ajax({
                url : './organ_manage_main_data.ashx',
                data : {
                    action:"save",
                    SYS_ORGAN_P_CODE:code,
                    SYS_ORGAN_NAME : $('#SYS_ORGAN_NAME').val(),
                    SYS_ORGAN_TYPE : type,
                    SYS_ORGAN_CRT_TIME : $('#SYS_ORGAN_CRT_TIME').val(),
                    SYS_ORGAN_ORDER:$('#SYS_ORGAN_ORDER').val()
                },
                async:true,
                type:"post",
                dataType : 'json',
                success : function(data) {
                    //alert(data);
                    if(data == 1){
                        alert("组织机构编号以存在，请重新输入！");
                    }else if(data == 0){
                        $('#dlg').dialog('close');
                        $.messager.show({
                            title : '提示',
                            msg : "保存成功"
                        });
                        parent.window.refish(code,"ORGAN");
                    }else{
                        alert("保存失败");
                    }
                },
                error:function(xhr){alert('发生错误：'+xhr.responseText);}
            });
        }
        
        window.onerror = function () { return true; }

        function initStyle() {
            
            $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');

        }

        $('#dg').datagrid({ onLoadSuccess: initStyle });
        
    </script>
</head>
<body class="easyui-layout">
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">
        <div style="padding-bottom:5px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="initDiaglg()">新增</a>
         <a href="javascript:void(0)" class="easyui-linkbutton" onclick="alterOrg()">修改</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteOrg()">删除</a>
       
        </div>
        <table id="dg" title="组织机构" class="easyui-datagrid"  style="width:auto;height:auto" fit="true"
                url="organ_manage_data.ashx?prentID=<%=prentID %>" style="width:100%;height:99%"
                rownumbers="true" fitColumns="true">
            <thead>
                <tr> 
                    <th data-options="field:'ck',checkbox:true"></th>
                    <th field="SYS_ORGAN_NAME" width="60%" align="left">名称</th>
                    <th field="SYS_ORGAN_TYPE" width="20%" align="left">类型</th>
                    <th field="SYS_ORGAN_CRT_TIME" width="20%" align="right">创建时间</th>
                </tr>
            </thead>
        </table>
    </div>
    <div id="dlg" class="easyui-dialog" title="新增" style="width:400px;height:250px;padding:10px" closed="true" runat="server"
            data-options="
                iconCls: 'icon-save',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveData();
                    }
                }] ">
        <form id="ff"  method="post">
        <iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
            <table cellpadding="2">
                <tr>
                    <td style="width:30%">单位名称:</td>
                    <td><input id="SYS_ORGAN_NAME" style="width: 250px" maxlength="50" class="easyui-textbox" type="text"  name="SYS_ORGAN_NAME" data-options="required:true"/></td>
                </tr>
                <tr>
                    <td>单位类型:</td>
                    <td>
                        <input id="SYS_ORGAN_TYPE" class="easyui-textbox" value="<%=orgType%>" style="width: 250px" name="SYS_ORGAN_TYPE" readonly="readonly"></input>
                    </td>
                </tr>
                <tr>
                    <td>登记时间:</td>
                    <td><input class="easyui-textbox" style="width: 250px" type="text" id="SYS_ORGAN_CRT_TIME"  name="SYS_ORGAN_CRT_TIME" data-options="required:true"  readonly="readonly"/></td>
                </tr>
                <tr>
                    <td>排列顺序:</td>
                    <td><input id="SYS_ORGAN_ORDER" style="width: 250px" value="<%=orgOrder %>" class="easyui-textbox" type="text" name="SYS_ORGAN_ORDER" data-options="required:true"/></td>
                </tr>
            </table>
        </form>
    </div>
    <div id="Div1" class="easyui-dialog" title="修改" style="width:400px;height:250px;padding:10px" closed="true" runat="server"
            data-options="
                iconCls: 'icon-save',
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        upData();
                    }
                }] ">
        <form id="Form1"  method="post">
        <iframe id="Iframe1" name="hidden_frame" style="display:none"></iframe>
            <table cellpadding="2">
                <tr>
                    <td style="width:30%">单位名称:</td>
                    <td><input id="SYS_ORGAN_NAME1" style="width: 250px" maxlength="50" class="easyui-textbox" type="text"  name="SYS_ORGAN_NAME1" data-options="required:true"/></td>
                </tr>
                <tr>
                    <td>单位类型:</td>
                    <td>
                        <input id="SYS_ORGAN_TYPE1" class="easyui-textbox" style="width: 250px" name="SYS_ORGAN_TYPE1" disabled="disabled"></input>
                    </td>
                </tr>
                <tr>
                    <td>登记时间:</td>
                    <td><input class="easyui-textbox" style="width: 250px" type="text" id="SYS_ORGAN_CRT_TIME1"  name="SYS_ORGAN_CRT_TIME1" data-options="required:true"  disabled="disabled"/></td>
                </tr>
                <tr>
                    <td>排列顺序:</td>
                    <td><input id="SYS_ORGAN_ORDER1" style="width: 250px"  class="easyui-textbox" type="text" name="SYS_ORGAN_ORDER1" data-options="required:true" /></td>
                </tr>
            </table>
        </form>
    </div>
</body>    
</html>

