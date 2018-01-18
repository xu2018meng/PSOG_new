<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main_page_new2_detail.aspx.cs" Inherits="main_page_new2_detail" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>首页B详情页面</title>
    <% 
       String plantId = Request.QueryString["plantId"];
       String deviceId = Request.QueryString["deviceId"];
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
        
        html,body{
            font-size:12px;
            width:100%;
            height:100%;
        }
       
         .td_lable
        {
            text-align: center;
            width: 80px;
            height: 35px;
        }
        
         .tableStyle{
            border:1px solid #fff;
            padding:2px 0px 2px 4px;
        }
        
        td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:2px 0px 2px 0px;}
        table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
        
        
    </style>
</head>
<body  style="background-color:#eef6fe;" onload="initData();">    

 <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:微软雅黑;">
 &nbsp;&nbsp;当前位置：<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new2.aspx?plantId=<%=plantId %>">主页</a>
 &nbsp;>&nbsp;工艺设备监测点信息
           </div>

        <div style="padding-top:8px;width:850px;padding-left:13.3%;">
            <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:23px;padding-top:8px;padding-left:15px;">基本信息</div>
            <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="0" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>设备号</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="deviceName"></label>
                        </td>
                         <td class="td_lable">
                           <label>运行状态指数</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="runIndex"></label>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="td_lable" >
                           <label>描&nbsp;&nbsp;述</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;padding:2px 0px 2px 4px;" colspan="3">
                           <label id="desc"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
            <div style=" font-weight:700; color:#eeeeee; background-color: #268BBA;height:23px;padding-top:6px;padding-left:15px;"><a href="./device_alarm_parameter.aspx?plantId=<%=plantId %>&deviceId=<%=deviceId %>&alarmFlag=all" style="color:#222222;font-size:16px;">预/报警点</a></div>
            <div style="font-size:12px; padding-top:1px;height: 220px;">
               <table id="dg" style="width:auto;height:100%;overflow:hidden" fit="true" url="" idField="alarmId" 
                   pagination="false" pagesize="10"  rownumbers="true"  fitColumns="true" >
                 <thead>
                        <tr>
                           <th data-options="field:'alarmBitNo',width:130,align:'center',halign: 'center'">位号</th>
                          <th data-options="field:'alarmRealValue',width:130,align:'center',halign: 'center'">实时值</th>
                          <th data-options="field:'alarmStatus',width:130,align:'center',halign: 'center'">状态</th>
                        </tr>
                   </thead>
               </table>
            </div>
            
              <br />
              
             <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:23px;padding-top:8px;padding-left:15px;">异常工况</div>
             <div id="abnormalDiv" style="font-size:12px;color:Black; text-align:left; padding-top:1px; height:auto">
               
            </div>
            
        </div>
</body>
</html>

<script type="text/javascript">
//初始化数据
function initData(){
   var baseJson = '<%=baseJson %>';
   var baseInfo = eval('('+baseJson+')');
   $("#deviceName").html(baseInfo.deviceName);
   if(baseInfo.runIndex!=null && baseInfo.runIndex.length>0){
       var runHtml = '<a href="./Web_RunState_Device_Monitoring.aspx?modelId=<%=runIndexId %>&plantCode=<%=plantId %>&deviceId=<%=deviceId %>">'+baseInfo.runIndex+'</a>';
       $("#runIndex").html(runHtml);
   }
  
   $("#desc").html(baseInfo.deviceDesc);
 
   $("#dg").datagrid({
        url:'mainpage2_alarm_list.ashx',
        queryParams: {
             plantId: '<%=plantId %>',
             deviceId:'<%=deviceId %>'
        }
  });
  
   //异常信息
   showAbnormalData();
}

//展示异常信息
 function showAbnormalData(){
        var abnormalJson = '<%=abnormalJson %>';
        var abnormalInfo = eval('('+abnormalJson+')');
        if(abnormalInfo==null || abnormalInfo.length<=0){
           return false;
        }
        var NumTemp = 0;
        htmlStr = '<table style="margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse;border-color:White"><tr>';
        for(var i=0; i<abnormalInfo.length; i++){
            var abnormal = abnormalInfo[i];
            NumTemp += 1;
            if(NumTemp > 5){
                htmlStr += '</tr><tr style="height:5px"></tr><tr><td class="tableStyle" id='+abnormal.abStateId+' onclick="turnToAbnormalPage(this.id)" style="background-color:#f4f4f4;width:170px;height:50px; border-color:#268BBA;cursor:pointer;font-size:12px;color:Black">'+abnormal.abStateName+'</td><td style="width:5px;border-width:0"></td>';
                NumTemp = 1;
            }else{
                if(NumTemp==5){
                  htmlStr += '<td class="tableStyle" id='+abnormal.abStateId
                         +' onclick="turnToAbnormalPage(this.id)" style="background-color:#f4f4f4;width:170px;height:50px;border-color:#268BBA;cursor:pointer;font-size:12px;color:Black">'+abnormal.abStateName+'</td><td style="width:0px;border-width:0"></td>';
                }else{
                   htmlStr += '<td class="tableStyle" id='+abnormal.abStateId
                           +' onclick="turnToAbnormalPage(this.id)" style="background-color:#f4f4f4;width:170px;height:50px;border-color:#268BBA;cursor:pointer;font-size:12px;color:Black">'+abnormal.abStateName+'</td><td style="width:5px;border-width:0"></td>';
                }
            }
        }
        var ddv = document.getElementById('abnormalDiv');
        ddv.innerHTML = htmlStr;
    }
    
    //跳转至异常工况详情页面
    function turnToAbnormalPage(id){
      window.location.href = "./Web_RunState_Fault_tree.aspx?plantCode=<%=plantId %>&modelId="+id+"&deviceId=<%=deviceId %>";
    }
    
   
   
</script>
