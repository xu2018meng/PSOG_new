<%@ Page Language="C#" AutoEventWireup="true" CodeFile="operation_quality_analysis_outline.aspx.cs" Inherits="operation_quality_analysis_outline" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>报警概述</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/jquery-ui/themes/smoothness/jquery-ui.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
    <script type="text/javascript" src="../resource/js/modules/exporting.js"></script>
    <link href="../resource/jquery/qTip2/jquery.qtip.min.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/qTip2/jquery.qtip.min.js"></script>  
    <script type="text/javascript" src="../resource/jquery/jquery-ui/jquery-ui.js"></script>
    <style type="text/css">
${demo.css}
		</style>
		<script type="text/javascript">
            $(function () {
                $( "#container_level_trend" ).tabs();
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#f45b5b", "#FF9933", "#FFCC00", "#6699CC", "#99CC33", "#336633", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
//                    chart: {
//                        borderWidth: 1
//                    }
                });
            
            });
            var plant = '';
            
            $.ajax({
                url: 'plant_list.html',
                dataType: "json",
                success: function(data){
                    var plantID = "<%=plantId %>";
                    for(var o in data){
                        if(plantID == data[o].plantID){
                            plant = data[o].plantName;
                            break;
                        }
                    }             
                }
             });
		</script>
    <style type="text/css">
        #qryDiv {padding-left:15px; padding-top:5px;}
        body {font-size:12px;font-family: 微软雅黑;}
    </style>
</head>
<body  class="easyui-layout" style="width:100%; height:100%;">
    <form id="form1" action="">
    <div style="padding-bottom: 5px;overflow-y:hidden;" id="qryDiv"  region="north"  border="false">
    <!-- #include file="include_loading.aspx" -->
        <iframe id="hidden_frame" name="hidden_frame" style="display:none"></iframe>
            <table class="tblSearch" style="text-align:left">
                <tr style="height:auto;">                        
                    <td class="leftTdSearch"  style="vertical-align:bottom; text-align:left;" nowrap="nowrap"> 
                    时间范围：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" />                     ---
                    <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" /> <br /><br />
                    <!-- 班组选择：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <input type="radio" name="shift" value="全部" checked="checked"/>全部
                              <input type="radio" name="shift" value="一班"/>一班
                              <input type="radio" name="shift" value="二班"/>二班<br /><br /> -->
                    指标查询：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline">
                                  <a id="LevelAssess" title="在指定时间范围内操作质量的整体状况评估。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-level',size:'large',iconAlign:'top'"><b>状态评估</b></a>
                              </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              
                    </td>
                </tr>
            </table> 
            <hr style="width:95%; color:#987cb9; size:5" />
    </div>
     
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; " border="false">
        <table width="100%" height="100%">
            <tr>
                <td style="width:10%">
                </td>
                <td style="border-width:1px; width:80%">
                    <div id="container" style=" height: 400px; margin: 0 auto"></div>

                    <div id="Div1"  region="center" style="padding: 5px; height: 300px; width" border="false">
                        <table id="dg" title="操作质量整体状况评估" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>
                                    <th data-options="field:'procName',width:80" align="left">工段</th>
                                    <th data-options="field:'value',width:150" align="left">日均</th>
                                    <th data-options="field:'valueOne',width:150" align="left">一班</th>
                                    <th data-options="field:'valueTwo',width:150" align="left">二班</th>
                                    <th data-options="field:'valuethree',width:150" align="left">三班</th>
                                    <th data-options="field:'valueFour',width:150" align="left">四班</th>
                                    <th data-options="field:'valueFive',width:150" align="left">五班</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    
                </td>
                <td  style="width:10%">
                </td>
            </tr>
        </table>
    </div>
    </form>
    <script type="text/javascript">
    $(function(){
        var width_temp = 0;
        var flag = 0; 
        
        if(flag == 0){
            width_temp = document.getElementById("container").offsetWidth;
            flag = 1;    
        }
        
        $('#container').highcharts({
		    chart: {
			    type: 'column',
			    width: width_temp
		    },
		    title: {
			    useHTML: true,
                text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量整体状态评估</span> '
		    },
		    navigation: {
                buttonOptions: {
                    enabled: false
                }
            },
		    subtitle: {
//                text: sub_title
            },
		    xAxis: {
                categories: [
                    '常减压装置',
                    '常压塔',
                    '减压塔',
                    '常压炉'
                ]
            },
            yAxis: {
                min: 50,
                title: {
                    text: '操作质量指数'
                }
            },
		    tooltip: {
			    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y}</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
		    },
		    plotOptions: {
			    column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
		    },
		    series: [{
                name: '日均',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [10, 5, 15, 21]

            }, {
                name: '一班',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [10, 5, 15, 21]

            }, {
                name: '二班',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [12, 20, 5, 4]

            }, {
                name: '三班',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [55, 30, 65, 60]

            }, {
                name: '四班',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [23, 45, 15, 15]

            }, {
                name: '五班',
                dataLabels: {
                    enabled: false,    //默认是false，即默认不显示数值
                    color: '#666',    //字体颜色
                    align: 'center',   //居柱子中间
                    format: '<span style="color:Black; ">{point.y}</span>'
                }
//                data: [23, 45, 15, 15]

            }]
	    });
        
        $('#dg').datagrid({
            url:'operation_quality_analysis_outline_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
            onLoadSuccess:function(){
                var arrayWhole = [];
                var arrayOne = [];
                var arrayTwo = [];
                var arrayThree = [];
                var arrayFour = [];
                var arrayFive = [];
                var categories = [];
                var min_data = 10000;
                var rows = $('#dg').datagrid('getRows');
                for(var i=0; i<rows.length; i++){
                    arrayWhole.push(rows[i].value);
                    arrayOne.push(rows[i].valueOne);
                    arrayTwo.push(rows[i].valueTwo);
                    arrayThree.push(rows[i].valuethree);
                    arrayFour.push(rows[i].valueFour);
                    arrayFive.push(rows[i].valueFive);
                    
                    if(min_data > rows[i].value){
                        min_data = rows[i].value;
                    }
                    if(min_data > rows[i].valueOne){
                        min_data = rows[i].valueOne;
                    }
                    if(min_data > rows[i].valueTwo){
                        min_data = rows[i].valueTwo;
                    }
                    if(min_data > rows[i].valuethree){
                        min_data = rows[i].valuethree;
                    }
                    if(min_data > rows[i].valueFour){
                        min_data = rows[i].valueFour;
                    }
                    if(min_data > rows[i].valueFive){
                        min_data = rows[i].valueFive;
                    }
                    categories.push(rows[i].procName);
                }
                
                var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();
                
                //var shift = $("[name='shift']").filter(":checked");
//                var plant = "<%=plantId %>";
//                if(plant == "JJSH_CJYYT"){
//                    plant = "常减压";
//                }
//                if(plant == "JJSH_CLHCJ"){
//                    plant = "催化裂化";
//                }
//                if(plant == "JJSH_YJHYT"){
//                    plant = "延迟焦化";
//                }                
			    
			    var chart = $('#container').highcharts();
			    chart.xAxis[0].setCategories(categories);
			    chart.yAxis[0].update({
                    min: min_data-5
                });
                chart.series[0].setData(arrayWhole);
                chart.series[1].setData(arrayOne);
                chart.series[2].setData(arrayTwo);
                chart.series[3].setData(arrayThree);
                chart.series[4].setData(arrayFour);
                chart.series[5].setData(arrayFive);
                var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
                chart.setTitle({text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量整体状态评估</span> <img id="tip_level" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'}, { text: sub_title});
                chart.hideLoading();
                
                $("#tip_level").qtip({
                    content: {
                        text: "<b>操作质量整体状态评估的相关解释。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
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
            $('#Div1').show();
            $('#container_level_trend').hide();
            
            var chart = $('#container').highcharts();
            chart.showLoading('正在加载数据...');
            
            $('#dg').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val()
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
