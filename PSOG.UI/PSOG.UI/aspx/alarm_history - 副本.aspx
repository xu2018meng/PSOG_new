<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_history.aspx.cs" Inherits="aspx_alarm_history" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head id="Head1">
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>历史查询</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
    <script type="text/javascript" src="../resource/js/modules/exporting.js"></script>
    <style type="text/css">
${demo.css}
		</style>
		<script type="text/javascript">
            $(function () {

                    $('#container').highcharts({

                        chart: {
                            type: 'arearange',
                            zoomType: 'x'
                        },

                        title: {
                            text: '报警系统等级评估'
                        },

                        xAxis: {
                            type: 'logarithmic',
				            minorTickInterval: 1,
				            max: 10000,
				            min: 0.1,
				            title: {
                                text: '最大报警率'
                            }
                        },

                        yAxis: {
				            type: 'logarithmic',
				            minorTickInterval: 1,
				            max: 1000,
				            min: 0.1,
                            title: {
                                text: '平均报警率'
                            }
                        },

                        tooltip: {
                        },

                        legend: {
                            enabled: true
                        },

                        series: [{
                            name: '可预测的',
				            color: 'rgba(0,255,0,0.5)',
                            data: [[0.1, 0.1, 1],
					              [10, 0.1, 1]]
				            },
				            {
					            type: 'arearange',
					            name: '鲁棒的',
					            color: 'rgba(0,0,255,0.5)',
					            data: [[0.1, 1, 10],
							            [10, 1, 10],
							            [10, 0.1, 10],
							            [100, 0.1, 10]]
				            },
				            {
					            type: 'arearange',
					            name: '稳定的',
					            color: 'rgba(255,255,0,0.5)',
					            data: [[100, 0.1, 10],
							            [1000, 0.1, 10]]
				            },
				            {
					            type: 'arearange',
					            name: '反应性的',
					            color: 'rgba(255,128,0,0.5)',
					            data: [[0.1, 10, 100],
							            [1000, 10, 100],
							            [1000, 0.1, 100],
							            [10000, 0.1, 100]]
				            },
				            {
					            type: 'arearange',
					            name: '超负荷的',
					            color: 'rgba(227,23,13,0.5)',
					            data: [[0.1, 100, 1000],
							            [10000, 100, 1000]]
				            },
				            {
				                type:'scatter',
				                name:'等级评估',
				                marker:{
				                    enabled: true,
				                    symbol:'triangle'
				                    }
				            }]
                    });


            });
		</script>
    <style type="text/css">
        #qryDiv {padding-left:15px; padding-top:5px;}
        body {font-size:12px;font-family: 微软雅黑;}
    </style>
</head>
<body  >
    <form id="form1" action="" class="easyui-layout" fit="true">
    <div style="padding-bottom: 5px;overflow-y:hidden;" id="qryDiv"  region="north"  border="false">
    <!-- #include file="include_loading.aspx" -->
        <iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
            <table class="tblSearch" style="text-align:left">
                <tr style="height:25px;">                        
                    <td class="leftTdSearch"  style="vertical-align:bottom; text-align:left;">
                    工段选择：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="area" value="checkbox" id="area_choice" checked="checked"/>全部
                              <input type="checkbox" name="area1" value="checkbox" id="Checkbox1"/>常压塔
                              <input type="checkbox" name="area2" value="checkbox" id="Checkbox2"/>减压塔
                              <input type="checkbox" name="area3" value="checkbox" id="Checkbox3"/>常压炉
                              <input type="checkbox" name="area4" value="checkbox" id="Checkbox4"/>减压炉 <br />
                    时间范围：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <input type="checkbox" name="area" value="checkbox" id="Checkbox5" checked="checked"/>八小时
                              <input type="checkbox" name="area1" value="checkbox" id="Checkbox6"/>一天
                              <input type="checkbox" name="area2" value="checkbox" id="Checkbox7"/>一周
                              <input type="checkbox" name="area2" value="checkbox" id="Checkbox8"/>任意时间范围&nbsp;&nbsp;&nbsp;
                    <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" /> 
                    <input id="line" type="text" value="---" />
                    <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" /> <br /><br />
                    指标选择：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <button id="LevelAssess">等级评估</button>&nbsp;&nbsp;&nbsp;
                              <button id="Top20" >Top 20报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="Priority" >报警优先级分布</button>&nbsp;&nbsp;&nbsp;
                              <button id="Chattering" >重复报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="Standing" >常驻报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="LevelTrend">报警等级趋势变化</button>&nbsp;&nbsp;&nbsp;
                    
                    </td>
                </tr>
            </table>
            <HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="100%" color=#987cb9 SIZE=3>
       
    </div>
     
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; " border="false">
        <table width="100%" height="100%">
            <tr>
                <td  width="20%">
                </td>
                <td  width="60%">
                    <div id="container" style="width: 100%; height: 400px; margin: 0 auto"></div>
                    <div id="container_Top20" style="width: 100%; height: 400px; margin: 0 auto; display:none"></div>
                    <div id="Div1"  region="center" style="padding: 5px; height: 300px; width:100%" border="false">
                        <table id="dg" title="报警历史统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="true" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'area',width:80" align="left">工段</th>
                                    <th data-options="field:'averagerate',width:150" align="left">平均报警率</th>
                                    <th data-options="field:'maxrate',width:150" align="left">最大报警率</th>
                                    <th data-options="field:'disturbrate',width:100" align="left">扰动率</th>
                                    <th data-options="field:'level',width:100" align="right">等级评估</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div id="Div2"  region="center" style="padding: 5px; height: 300px; width:100%; display:none" border="false">
                        <table id="dg_top20" title="报警历史统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="true" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'area',width:80" align="left">工段</th>
                                    <th data-options="field:'averagerate',width:150" align="left">平均报警率</th>
                                    <th data-options="field:'maxrate',width:150" align="left">最大报警率</th>
                                </tr>
                            </thead>     
                        </table>
                    </div>
                </td>
                <td  width="20%">
                </td>
            </tr>
        </table>
    </div>
    </form>
    <script type="text/javascript">
    $(function(){
        $('#dg').datagrid({
            url:'alarm_histroy_list_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
            onLoadSuccess:function(){
                var array = [];
                var rows = $('#dg').datagrid('getRows');
                for(var i=0; i<rows.length; i++){
                    var temp = [rows[i].maxrate, rows[i].averagerate];
                    array.push(temp);
                }
                var chart = $('#container').highcharts();
                chart.series[5].setData(array);
            }
        });
        $('#LevelAssess').click(function (){  //点击等级评估按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            $('#container').show();
            $('#container_Top20').hide();
            $('#Div1').show();
            $('#Div2').hide();
            $('#dg').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val()
            });
        });
        
        $('#Top20').click(function (){ //点击Top20报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container').hide();
            $('#container_Top20').show();
            $('#Div1').hide();
            $('#Div2').show();
            $('#dg_top20').datagrid({
               url:'alarm_histroy_list_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
               onLoadSuccess:function(){                    
                    var array = [];
                    var rows = $('#dg_top20').datagrid('getRows');
                    for(var i=0; i<rows.length; i++){
                        var temp = [rows[i].area, rows[i].disturbrate];
                        array.push(temp);
                    }
                    var chart = $('#container_Top20').highcharts({
                        chart: {
                            type: 'bar'
                        },

                        title: {
                            text: 'Top 20报警统计'
                        },

                        xAxis: {
				            title: {
                                text: null
                            }
                        },

                        yAxis: {
				            min: 0,
                            title: {
                                text: '报警次数',
                                align: 'high'
                            },
                            labels: {
                                overflow: 'justify'
                            }
                        },

                        tooltip: {
                            valueSuffix: ' 次'
                        },
                        
                        series: [{
                            name: 'Top 20',
                            data: array
                        }]
                        
                    });
               }
            });

        });
    });
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


//列表外查询
function qryData() {
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();

    if(startTime > endTime){
        alert("查询开始时间不能大于截止时间！");
        return;
    }
    
    leftIframe.$('#dg').datagrid('load', {
        startTime: $('#startTime').val(),
        endTime: $('#endTime').val()
    });
    rightIframe.$('#dg').datagrid('load', {
        startTime: $('#startTime').val(),
        endTime: $('#endTime').val()
    });
}

//导出
function expData(){
    var startTime = $("#startTime").val();
    var endTime = $("#endTime").val();
    
    /* 通过cookie传值 */
    var date=new Date(); 
    date.setTime(date.getTime() + 60*1000); 
    document.cookie = "plantId=<%=plantId %>; expirse=" + date.toGMTString();
    document.cookie = "startTime="+startTime + "; expirse=" + date.toGMTString();
    document.cookie = "endTime=" + endTime + "; expirse=" + date.toGMTString();
    
    document.forms[0].target = "hidden_frame";
    
    var url = "./alarm_history_exp.ashx?plantId=<%=plantId %>&startTime="+startTime + "&endTime=" + endTime;
    //window.open(url);
    document.forms["form1"].action = url;
    document.forms["form1"].method = "GET";
    document.forms["form1"].submit();
    document.forms["form1"].target = "";
}


</script>

</body>    
</html>
