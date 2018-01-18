<%@ Page Language="C#" AutoEventWireup="true" CodeFile="operation_quality_analysis_by_distribution.aspx.cs" Inherits="operation_quality_analysis_by_distribution" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>操作质量分布</title>
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
    <script type="text/javascript" src="..resource/jquery/jquery-ui/jquery-ui.js"></script>
    <style type="text/css">
${demo.css}
		</style>
		<script type="text/javascript">
            $(function () {
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#99CC33", "#009966","#6699CC","#FFCC00","#FF9933","#f45b5b","#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
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
                    指标查询：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="distribution_priority" title="等级分布情况。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>等级分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="distribution_process_priority" title="工段-等级情况。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>工段-等级分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="distribution_class_priority" title="班组-等级情况。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>班组-等级分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="distribution_time_priority" title="时间-等级情况。" style=" border:none" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>时间-等级分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                
                    <div id="container_distribution_priority" style="height: 500px; margin: 0 auto; display:block">
					</div>
					    
					<div id="container_distribution_process_priority" style="height: 500px; margin: 0 auto; display:none">
                    </div>
                    
                    <div id="container_distribution_class_priority" style="height: 500px; margin: 0 auto; display:none">
                    </div>
					
					<div id="container_distribution_time_priority" style="height: 500px; margin: 0 auto; display:none">
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
        
        show_distribution_priority();
        
        $('#distribution_process_priority').click(function (){   //操作质量指数工段-等级分布情况
		    $('#container_distribution_priority').hide();
            $('#container_distribution_process_priority').show();
            $('#container_distribution_class_priority').hide();
            $('#container_distribution_time_priority').hide();
            
            show_distribution_process_priority();
		});
		
		$('#distribution_time_priority').click(function (){   //操作质量指数时间-等级分布情况
		    $('#container_distribution_priority').hide();
            $('#container_distribution_process_priority').hide();
            $('#container_distribution_class_priority').hide();
            $('#container_distribution_time_priority').show();
            
            show_distribution_time_priority();
		});
		
		$('#distribution_priority').click(function (){   //操作质量指数等级分布情况
		    $('#container_distribution_priority').show();
            $('#container_distribution_process_priority').hide();
            $('#container_distribution_class_priority').hide();
            $('#container_distribution_time_priority').hide();
            
            show_distribution_priority();
			
		});
		
		$('#distribution_class_priority').click(function (){   //操作质量指数班组-等级分布情况
		    $('#container_distribution_priority').hide();
            $('#container_distribution_process_priority').hide();
            $('#container_distribution_class_priority').show();
            $('#container_distribution_time_priority').hide();
            
            show_distribution_class_priority();
			
		});
        
		function show_distribution_process_priority(){   //执行操作质量指数工段-等级分布功能
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
            
            $('#container_distribution_process_priority').highcharts({
		        chart: {
			        type: 'column',
			        width: width_temp
		        },
		        title: {
			        useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数工段-等级分布情况</span> <img id="tip_distribution_process_priority" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		        },
		        subtitle: {
                    text: sub_title
                },
		        xAxis: {
                    categories: [
                        '1#常减压装置',
                        '常压塔',
                        '减压塔',
                        '常压炉'
                    ]
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '等级分布'
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
		        navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
		        series: [{
                    name: 'A++',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [10, 5, 15, 21]

                }, {
                    name: 'A+',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [12, 20, 5, 4]

                }, {
                    name: 'A',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [55, 30, 65, 60]

                }, {
                    name: 'B',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }, {
                    name: 'C',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }, {
                    name: 'D',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }]
	        });
			$("#tip_distribution_process_priority").qtip({
                content: {
                    text: "<b>操作质量指数工段-等级分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            
            var chart = $('#container_distribution_process_priority').highcharts();
            chart.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_distribution_priority.ashx?id=3&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var categories = [];
                    var arrayAAA = [];
                    var arrayAA = [];
                    var arrayA = [];
                    var arrayB = [];
                    var arrayC = [];
                    var arrayD = [];
                    for(var o in data){
                        arrayAAA.push(data[o].AAAvalue);
                        arrayAA.push(data[o].AAvalue);
                        arrayA.push(data[o].Avalue);
                        arrayB.push(data[o].Bvalue);
                        arrayC.push(data[o].Cvalue);
                        arrayD.push(data[o].Dvalue);
                        categories.push(data[o].procName);
                    }
                    
                    var chart = $('#container_distribution_process_priority').highcharts();
                    chart.xAxis[0].setCategories(categories);
                    chart.series[0].setData(arrayAAA);
                    chart.series[1].setData(arrayAA);
                    chart.series[2].setData(arrayA);
                    chart.series[3].setData(arrayB);
                    chart.series[4].setData(arrayC);
                    chart.series[5].setData(arrayD);
                    
                    chart.hideLoading();
                }
            });
		}
		
		function show_distribution_class_priority(){   //执行操作质量指数班组-等级分布功能
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
            
            $('#container_distribution_class_priority').highcharts({
		        chart: {
			        type: 'column',
			        width: width_temp
		        },
		        title: {
			        useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数班组-等级分布情况</span> <img id="tip_distribution_class_priority" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		        },
		        subtitle: {
                    text: sub_title
                },
		        xAxis: {
                    categories: [
                        '一班',
                        '二班',
                        '三班',
                        '四班'
                    ]
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '等级分布'
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
		        navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
		        series: [{
                    name: 'A++',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [10, 5, 15, 21]

                }, {
                    name: 'A+',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [12, 20, 5, 4]

                }, {
                    name: 'A',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [55, 30, 65, 60]

                }, {
                    name: 'B',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }, {
                    name: 'C',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }, {
                    name: 'D',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="color:Black; font-weight:bold">{point.y}</span>'
                    }
//                    data: [23, 45, 15, 15]

                }]
	        });
			$("#tip_distribution_class_priority").qtip({
                content: {
                    text: "<b>操作质量指数班组-等级分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            
            
            var chart = $('#container_distribution_class_priority').highcharts();
            chart.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_distribution_priority.ashx?id=2&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var categories = [];
                    var arrayAAA = [];
                    var arrayAA = [];
                    var arrayA = [];
                    var arrayB = [];
                    var arrayC = [];
                    var arrayD = [];
                    for(var o in data){
                        arrayAAA.push(data[o].AAAvalue);
                        arrayAA.push(data[o].AAvalue);
                        arrayA.push(data[o].Avalue);
                        arrayB.push(data[o].Bvalue);
                        arrayC.push(data[o].Cvalue);
                        arrayD.push(data[o].Dvalue);
                        categories.push(data[o].procName);
                    }
                    
//                    var chart = $('#container_distribution_class_priority').highcharts();
                    chart.xAxis[0].setCategories(categories);
                    chart.series[0].setData(arrayAAA);
                    chart.series[1].setData(arrayAA);
                    chart.series[2].setData(arrayA);
                    chart.series[3].setData(arrayB);
                    chart.series[4].setData(arrayC);
                    chart.series[5].setData(arrayD);
                    
                    chart.hideLoading();
                }
            });
            
		}
		
		function show_distribution_time_priority(){   //执行操作质量指数分布时间-等级分布功能
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
            
            //var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime+", 班组: "+shift.attr("value");
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
            
            //var width_temp = document.getElementById("container_distribution_time").offsetWidth;
        
            
            $('#container_distribution_time_priority').highcharts({
				chart: {
					zoomType: 'x',
					width: width_temp
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数时间-等级分布</span> <img id="tip_distribution_time_priority" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
						text: '等级分布'
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
					name: '操作质量指数时间-等级分布',
					pointInterval: 3600 * 1000,
					pointStart: Date.UTC(2014, 12, 6),
					color: '#D9231F'
//					data: [10, 12, 13, 10, 15, 50, 35, 10]
				}]
			});
			$("#tip_distribution_time_priority").qtip({
                content: {
                    text: "<b>操作质量指数时间-等级分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            
            var chart = $('#container_distribution_time_priority').highcharts();
            chart.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_dis_priority_time.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var new_data = [];
                    for(var o in data){
                        var aa = Date.parse(data[o].startTime)+8*60*60*1000;
                        new_data.push([aa, data[o].OQICount]);  
                    } 
                    var chart = $('#container_distribution_time_priority').highcharts();
                    chart.series[0].setData(new_data);
                    chart.hideLoading();
                }
            });
		    
		}
		
		
		function show_distribution_priority(){
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
                width_temp = document.getElementById("container_distribution_priority").offsetWidth;
                flag = 1;    
            }
			
			$('#container_distribution_priority').highcharts({
				chart: {
					plotBackgroundColor: null,
					plotBorderWidth: null,
					plotShadow: false,
					width: width_temp
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数等级分布</span> <img id="tip_distribution_priority" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
				},
				subtitle: {
                    text: sub_title
                },
				tooltip: {
					pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
					enabled: true
				},
				plotOptions: {
					pie: {
						allowPointSelect: true,
						cursor: 'pointer',
						dataLabels: {
							enabled: true,
							format: '<b>{point.name}</b>: {point.percentage:.1f} %',
							style: {
								color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
							}
						}
					}
				},
				navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
				series: [{
					type: 'pie',
					name: '操作质量指数等级',
					data: [
//						['A++',   5.0],
//						['A+',       10],
//						{
//							name: 'A',
//							y: 15,
//							sliced: true,
//							selected: true
//						},
//						['B',    10],
//						['C',    30],
//						['D',    30]
					]
				}]
			});
			
			$("#tip_distribution_priority").qtip({
                content: {
                    text: "<b>操作质量指数等级分布情况。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
			
			$.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_distribution_priority.ashx?id=1&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var new_data = [];
                    for(var o in data){
                        new_data.push(['A++', data[o].AAAvalue]);
                        new_data.push(['A+', data[o].AAvalue]);
                        new_data.push(['A', data[o].Avalue]);
                        new_data.push(['B', data[o].Bvalue]);
                        new_data.push(['C', data[o].Cvalue]);
                        new_data.push(['D', data[o].Dvalue]);
                    } 
                    var chart = $('#container_distribution_priority').highcharts();
                    chart.series[0].setData(new_data);
                    chart.setTitle(null, { text: "装置: "+plant+", 时间: "+startTime+" --- "+ endTime});
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
