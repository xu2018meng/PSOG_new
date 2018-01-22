<%@ Page Language="C#" AutoEventWireup="true" CodeFile="abnormal_realTime_list.aspx.cs" Inherits="abnormal_realTime_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1">
    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <title>实时数据</title>
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
      <table id="dg" style="width:auto;height:auto" fit="true" url="" idField="abStateId" 
        toolbar='#toolbar'   pagination="true" pagesize="20"  rownumbers="true"  fitColumns="true" >
         <thead>
                <tr>
                   <th data-options="field:'abStateRuleId',width:140,align:'center',halign: 'center',hidden:true">规则表主键</th>
                   <th data-options="field:'abStateName',width:140,align:'center',halign: 'center',formatter:addLink">异常名称</th>
                   <th data-options="field:'abStateDesc',width:140,align:'center',halign: 'center',hidden:'true'">异常描述</th>
                  <th data-options="field:'abStateStatus',width:140,align:'center',halign: 'center'">状态</th>
                  <th data-options="field:'abStateUnit',width:140,align:'center',halign: 'center'">单元</th>
                  <th data-options="field:'abStateMeter',width:140,align:'center',halign: 'center'">关联仪表</th>
                  <th data-options="field:'abStateSustainTime',width:140,align:'center',halign: 'center'">持续时间</th>
                  <th data-options="field:'abStateStartTime',width:140,align:'center',halign: 'center'">开始时间</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="height:75px;">
          <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:微软雅黑;">
           &nbsp;&nbsp;当前位置：<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new.aspx?plantId=<%=plantId %>">主页</a>
         &nbsp;>&nbsp;异常实时数据
        </div>
       
        
         <form id="param" action="" style="margin-top:9px;">
            <span style="margin-left: 5px"><b>异常名称:</b></span>
            <input id="queryName"  class="easyui-textbox" style="height:19px;"/>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" onclick="queryResult()">查询</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-clear" plain="true" onclick="clearParam()">清空</a>
        </form>
        
     </div> 
    </div>    
</body>    
</html>


<script type="text/javascript"> 
   
   function initGrid(){
        $("#dg").datagrid({
            url:'abnormal_realTime_list_data.ashx',
            queryParams: {
                plantId: '<%=plantId %>',
               tagName:''
            }
        });
   }
   
   //查询
   function queryResult(){
      var queryName = $("#queryName").val();
      $('#dg').datagrid('load', {
            plantId: '<%=plantId %>',
            tagName:queryName
      });
   }
   
   //清空查询条件
   function clearParam(){
     $("#queryName").val("");
   }
   
    //超链接
    function addLink(val, row, index){
       return '<a href="#"  onclick="turnToAlarmRule(' + index + ')">' + val + '</a>';
    }
    
    //跳转至报警规则页面
    function turnToAlarmRule(index){
       var rows = $("#dg").datagrid("getRows");
       window.location.href ="./abnormal_survey_rule.aspx?id=" + rows[index].abStateRuleId+"&plantId=<%=plantId %>&bitCode="+rows[index].abStateName+"&tagDesc="+rows[index].abStateDesc;
    }
    
     //后退
    function back(){
       window.history.back();
    }
   
   
</script>

