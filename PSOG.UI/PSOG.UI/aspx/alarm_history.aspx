<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_history.aspx.cs" Inherits="aspx_alarm_history" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       string startTimeQuery = Request.QueryString["startTime"];
       string endTimeQuery = Request.QueryString["endTime"];
       if (null != startTimeQuery){
            startTime = startTimeQuery;
       }
       if (null != endTimeQuery)
       {
           endTime = endTimeQuery;
       }
       plantId = null == plantId ? "" : plantId;
       string wnum = null;
        
    %>
    <title>历史查询</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css" />

    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>

    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>

    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>

    <style type="text/css">
        #qryDiv {padding-left:15px; padding-top:5px;}
        body {font-size:12px;font-family: 微软雅黑;}
    </style>
</head>
<body >
    <form id="form1" action="" class="easyui-layout" fit="true">
        <div style="padding-bottom: 5px; overflow-y: hidden;" id="qryDiv" region="north"
            border="false">
            <!-- #include file="include_loading.aspx" -->
            <iframe id="hidden_frame" name="hidden_frame" style="display: none"></iframe>
            <table class="tblSearch" style="text-align: left">
                <tr style="height: 25px;">
                    <td class="leftTdSearch" style="vertical-align: bottom; text-align: left;">
                        位号：<select id="seleweihao" style="width: 80px" onchange="change()">
                            <option id="opti" >--全部--</option>
                        </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="display: none">班组:</span><select
                            style="width: 80px; display: none">
                            <option></option>
                        </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 时间范围&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" size="23" readonly="true" />
                        ——
                        <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
                            size="23" readonly="true" />
                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数据来源&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="dbSource" name="dbSource"  style="width:120px; height: 24px;padding-top:3px;">
                           <option value="0">实时数据库</option>
                           <option value="1">DCS报警日志</option>
                          </select>  
                            
                        &nbsp;&nbsp;&nbsp; <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:qryData()">
                            查询</a>&nbsp;&nbsp;&nbsp; <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:expData()">
                                导出Execl</a>
                    </td>
                </tr>
            </table>
        </div>
        <div id="gridDiv" region="center" style="padding: 5px; height: 100%;" border="false">
            <table width="100%" height="100%">
                <tr>
                    <td width="100%">
                        <iframe id="leftIframe" name="leftIframe" src="alarm_history_list.aspx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&wnum=<%=wnum %>&dbSource=0"
                            frameborder="0" width="100%" height="100%"></iframe>
                    </td>
                    <!-- <td  width="35%">
                    <iframe id="rightIframe" src="alarm_history_statis.aspx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>"  frameborder="0" width="100%" height="100%"></iframe>
                </td> -->
                </tr>
            </table>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">

var dbSource = "0";

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
//给下拉框添加选项
window.onload = function addsele() {
        $.ajax({
            url: "./alarm_history.ashx?" + encodeURI("plantId=<%=plantId %>"),
            async: true,
            type: "get",
            dataType: 'json',
            success: function (data) {
                    if(data.length > 0){
                    for(var i = 0;i < data.length;i++)
                    {
                       $("#seleweihao").append("<option value="+ data[i]+">"+ data[i]+"</option>"); 
                    }
                }
            }
            //error: function (xhr) { alert('发生错误：' + xhr.responseText); }
        });
    }

function change(){
    wnum = $("#seleweihao").find("option:selected").text();
    var src = "alarm_history_list.aspx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&wnum=" + wnum+"&dbSource="+dbSource;
    $("#leftIframe").setAttribute("src",src);
}

//列表外查询
function qryData() {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();

    if(startTime > endTime){
        alert("查询开始时间不能大于截止时间！");
        return;
    }
    
    dbSource = $("#dbSource").val();
    
    var startTime = $('#startTime').val();
    var endTime = $('#endTime').val();
    var wnum = $('#seleweihao').val();
    window.frames["leftIframe"].reload(startTime,endTime,wnum,dbSource);
}

//导出
function expData(){
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    
    if(startTime > endTime){
        alert("查询开始时间不能大于截止时间！");
        return;
    }
    
    dbSource = $("#dbSource").val();
    
    /* 通过cookie传值 */
    var date=new Date(); 
    date.setTime(date.getTime() + 60*1000); 
    document.cookie = "plantId=<%=plantId %>; expirse=" + date.toGMTString();
    document.cookie = "startTime="+startTime + "; expirse=" + date.toGMTString();
    document.cookie = "endTime=" + endTime + "; expirse=" + date.toGMTString();
    
    document.forms[0].target = "hidden_frame";
    
    var url = "./alarm_history_exp.ashx?plantId=<%=plantId %>&startTime="+startTime + "&endTime=" + endTime+"&dbSource="+dbSource;
    //window.open(url);
    document.forms["form1"].action = url;
    document.forms["form1"].method = "GET";
    document.forms["form1"].submit();
    document.forms["form1"].target = "";
}

</script>

