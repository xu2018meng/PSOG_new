<%@ Page Language="C#" AutoEventWireup="true" CodeFile="operation_quality_analysis_by_score.aspx.cs" Inherits="operation_quality_analysis_by_score" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>得分分布</title>
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
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#f45b5b", "#FF9933", "#FFCC00", "#6699CC", "#99CC33", "#336633", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
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
                    <!-- 工段选择：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="area" value="checkbox" id="area_choice" checked="checked"/>全部
                              <input type="checkbox" name="area1" value="checkbox" id="Checkbox1"/>常压塔
                              <input type="checkbox" name="area2" value="checkbox" id="Checkbox2"/>减压塔
                              <input type="checkbox" name="area3" value="checkbox" id="Checkbox3"/>常压炉
                              <input type="checkbox" name="area4" value="checkbox" id="Checkbox4"/>减压炉 <br /> -->
                    时间范围：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" />                     ---
                    <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" /> <br /><br />
                    指标查询：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="score_process" title="工段-得分分布。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>工段分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="score_class" title="班组-得分分布。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>班组分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="score_time" title="时间-得分分布。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>时间分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                
                    <div id="container_score_process" style="height: 500px; margin: 0 auto; display:block">
					</div>
                    
                    <div id="container_score_class" style="height: 500px; margin: 0 auto; display:none">
                    </div>
					
					<div id="container_score_time" style="height: 500px; margin: 0 auto; display:none">
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
        
        show_score_process();
        
        $('#score_process').click(function (){   //得分工段分布情况
		    $('#container_score_process').show();
            $('#container_score_class').hide();
            $('#container_score_time').hide();
            
            show_score_process();
		});
		
		$('#score_time').click(function (){   //得分时间分布情况
		    $('#container_score_process').hide();
            $('#container_score_class').hide();
            $('#container_score_time').show();
            
            show_score_time();
		});
		
		$('#score_class').click(function (){   //得分班组分布情况
		    $('#container_score_process').hide();
            $('#container_score_class').show();
            $('#container_score_time').hide();
            
            show_score_class();
			
		});
        
		function show_score_process(){   //执行得分工段分布功能
		    //数据通过ajax实现
		    var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
//            var plant = "<%=plantId %>";
//            if(plant == "JJSH_CJYYT"){
//                plant = "常减压";
//            }
//            if(plant == "JJSH_CLHCJ"){
//                plant = "催化裂化";
//            }
//            if(plant == "JJSH_YJHYT"){
//                plant = "延迟焦化";
//            }
            
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
            
            if(flag == 0){
                width_temp = document.getElementById("container_score_process").offsetWidth;
                flag = 1;    
            }
            
            $('#container_score_process').highcharts({
		        chart: {
			        type: 'column',
			        width: width_temp
		        },
		        title: {
			        useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">得分工段分布情况</span> <img id="tip_score_process" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		        },
		        subtitle: {
                    text: sub_title
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
		        xAxis: {
//                    categories: [
//                        '常减压装置',
//                        '常压塔',
//                        '减压塔',
//                        '常压炉'
//                    ]
                },
                yAxis: {
                    min: 60,
                    title: {
                        text: '得分'
                    }
                },
		        tooltip: {
			        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}分</b></td></tr>',
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
                    name: '得分',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [10, 5, 15, 21]

                }]
	        });
			$("#tip_score_process").qtip({
                content: {
                    text: "<b>得分工段分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            var chart = $('#container_score_process').highcharts();
            chart.showLoading('正在加载数据...');
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_score.ashx?id=1&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var array = [];  
                    var categories = [];
                    var min_data = 10000;
                    for(var o in data){
                        array.push(data[o].value);
                        categories.push(data[o].name);
                        
                        if(min_data > data[o].value){
                            min_data = data[o].value;
                        }
                    } 
                    chart.xAxis[0].setCategories(categories);
                    chart.yAxis[0].update({
                        min: min_data-5
                    });
                    chart.series[0].setData(array);
                    chart.setTitle(null, { text: "装置: "+plant+", 时间: "+startTime+" --- "+ endTime});
                    chart.hideLoading();
                }
            });
		}
		
		function show_score_class(){   //执行得分班组分布功能
		    //数据通过ajax实现
		    var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
//            var plant = "<%=plantId %>";
//            if(plant == "JJSH_CJYYT"){
//                plant = "常减压";
//            }
//            if(plant == "JJSH_CLHCJ"){
//                plant = "催化裂化";
//            }
//            if(plant == "JJSH_YJHYT"){
//                plant = "延迟焦化";
//            }
            
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
            
            $('#container_score_class').highcharts({
		        chart: {
			        type: 'column',
			        width: width_temp
		        },
		        title: {
			        useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">得分班组分布情况</span> <img id="tip_score_class" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		        },
		        subtitle: {
                    text: sub_title
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
		        xAxis: {
//                    categories: [
//                        '一班',
//                        '二班',
//                        '三班',
//                        '四班'
//                    ]
                },
                yAxis: {
                    min: 60,
                    title: {
                        text: '得分'
                    }
                },
		        tooltip: {
			        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}分</b></td></tr>',
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
                    name: '得分',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [10, 5, 15, 21]

                }]
	        });
			$("#tip_score_class").qtip({
                content: {
                    text: "<b>得分班组分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            var chart = $('#container_score_class').highcharts();
            chart.showLoading('正在加载数据...');
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_score.ashx?id=2&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var array = [];  
                    var categories = [];
                    var min_data = 10000;
                    for(var o in data){
                        array.push(data[o].value);
                        categories.push(data[o].name);
                        
                        if(min_data > data[o].value){
                            min_data = data[o].value;
                        }
                    } 
                    chart.xAxis[0].setCategories(categories);
                    chart.yAxis[0].update({
                        min: min_data-5
                    });
                    chart.series[0].setData(array);
                    chart.hideLoading();
                }
            });
		}
		
		function show_score_time(){   //执行得分时间分布功能
		    //数据通过ajax实现
		    var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
//            var plant = "<%=plantId %>";
//            if(plant == "JJSH_CJYYT"){
//                plant = "常减压";
//            }
//            if(plant == "JJSH_CLHCJ"){
//                plant = "催化裂化";
//            }
//            if(plant == "JJSH_YJHYT"){
//                plant = "延迟焦化";
//            }
            
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
        
            $('#container_score_time').highcharts({
				chart: {
					zoomType: 'x',
					width: width_temp
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">得分时间分布</span> <img id="tip_score_time" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
				},
				subtitle: {
                    text: sub_title
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
				xAxis: {
					type: 'datetime',
					dateTimeLabelFormats: {
                        hour: '%m月%d日 %H:%M',
                        day: '%m月%d日  %H:%M'
                    },
                    labels: {
                        rotation: -45
                    }
					//minRange: 14 * 24 * 3600000 // fourteen days
				},
				yAxis: {
					title: {
						text: '得分'
					}
				},
				legend: {
					enabled: false
				},
				plotOptions: {
					line: {
						fillColor: {
							linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
							stops: [
								[0, Highcharts.getOptions().colors[0]],
								[1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
							]
						},
						marker: {
							radius: 2
						},
						lineWidth: 1,
						states: {
							hover: {
								lineWidth: 1
							}
						},
						threshold: null
					}
				},

				series: [{
					type: 'line',
					name: '得分时间分布',
					pointInterval: 3600 * 1000,
					pointStart: Date.UTC(2014, 12, 6)
//					data: [10, 12, 13, 10, 15, 50, 35, 10]
				}]
			});
			$("#tip_score_time").qtip({
                content: {
                    text: "<b>得分时间分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            
            var chart = $('#container_score_time').highcharts();
            chart.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_score_time.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var new_data = [];
                    for(var o in data){
                        var aa = Date.parse(data[o].startTime)+8*60*60*1000;
                        new_data.push([aa, data[o].OQICount]);  
                    } 
                    chart.series[0].setData(new_data);
                    chart.hideLoading();
                }
            });
		    
		}
				
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
