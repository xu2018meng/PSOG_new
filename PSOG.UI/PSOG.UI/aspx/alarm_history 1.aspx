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
                        
                        navigation: {
                            buttonOptions: {
                                enabled: false
                            }
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
                            enabled: false
                        },

                        legend: {
                            enabled: true
                        },

                        series: [{
                            name: '可预测的',
				            color: 'rgba(0,255,0,0.5)',
				            showInLegend: false,
                            data: [[0.1, 0.1, 1],
					              [10, 0.1, 1]]
				            },
				            {
					            type: 'arearange',
					            name: '鲁棒的',
					            color: 'rgba(0,0,255,0.5)',
					            showInLegend: false,
					            data: [[0.1, 1, 10],
							            [10, 1, 10],
							            [10, 0.1, 10],
							            [100, 0.1, 10]]
				            },
				            {
					            type: 'arearange',
					            name: '稳定的',
					            color: 'rgba(255,255,0,0.5)',
					            showInLegend: false,
					            data: [[100, 0.1, 10],
							            [1000, 0.1, 10]]
				            },
				            {
					            type: 'arearange',
					            name: '反应性的',
					            color: 'rgba(255,128,0,0.5)',
					            showInLegend: false,
					            data: [[0.1, 10, 100],
							            [1000, 10, 100],
							            [1000, 0.1, 100],
							            [10000, 0.1, 100]]
				            },
				            {
					            type: 'arearange',
					            name: '超负荷的',
					            color: 'rgba(227,23,13,0.5)',
					            showInLegend: false,
					            data: [[0.1, 100, 1000],
							            [10000, 100, 1000]]
				            },
				            {
				                type:'scatter',
				                name:'等级评估',
				                dataLabels: {
                                    enabled: true,
                                    format: '{name}'
                                },
				                marker:{
				                    enabled: true,
				                    symbol:'triangle',
				                    radius: 8
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
    <!-- <form id="form1" action="" class="easyui-layout" fit="true"> -->
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
                              <button id="distribution" >报警分布（按时间、工段、优先级）</button>&nbsp;&nbsp;&nbsp;
							  <button id="Top10" >Top 10报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="Chattering" >重复报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="Standing" >持续报警</button>&nbsp;&nbsp;&nbsp;
                              <button id="LevelTrend">报警系统等级趋势变化</button>&nbsp;&nbsp;&nbsp;
                    
                    </td>
                </tr>
            </table>
            <HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="100%" color=#987cb9 SIZE=3>
       
    </div>
     
    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; " border="false">
        <table width="100%" height="100%">
            <tr>
                <td  width="10%">
                </td>
                <td  width="80%">
                    <div id="container" style="width: 100%; height: 400px; margin: 0 auto"></div>
                    <div id="container_distribution_time" style="width: 50%; height: 300px; margin: 0 auto; display:none"></div>
					<div id="container_distribution_area" style="width: 50%; height: 300px; margin: 0 auto; display:none"></div>
					<div id="container_distribution_priority_area" style="width: 50%; height: 300px; margin: 0 auto; display:none"></div>
					<div id="container_distribution_priority_all" style="width: 50%; height: 300px; margin: 0 auto; display:none"></div>
					
					<div id="container_Top10" style="width: 100%; height: 400px; margin: 0 auto; display:none"></div>
					<div id="container_chattering" style="width: 100%; height: 400px; margin: 0 auto; display:none"></div>
					<div id="container_standing" style="width: 100%; height: 400px; margin: 0 auto; display:none"></div>
					<div id="container_level_trend" style="width: 100%; height: 400px; margin: 0 auto; display:none"></div>
                    <div id="Div1"  region="center" style="padding: 5px; height: 300px; width:100%" border="false">
                        <table id="dg" title="报警系统等级评估" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
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
                    <div id="Div_top10"  region="center" style="padding: 5px; height: 300px; width:100%; display:none" border="false">
                        <table id="dg_top10" title="Top 10报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="true" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'averagerate',width:80" align="left">位号</th>
                                    <th data-options="field:'area',width:150" align="left">工段</th>
                                    <th data-options="field:'maxrate',width:150" align="left">报警次数</th>
									<th data-options="field:'disturbrate',width:150" align="left">占总数%</th>
                                </tr>
                            </thead>     
                        </table>
                    </div>
					<div id="Div_chattering"  region="center" style="padding: 5px; height: 300px; width:100%; display:none" border="false">
                        <table id="dg_chattering" title="重复报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="true" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'averagerate',width:80" align="left">位号</th>
                                    <th data-options="field:'area',width:150" align="left">工段</th>
                                    <th data-options="field:'maxrate',width:150" align="left">报警重复次数</th>
									<th data-options="field:'disturbrate',width:150" align="left">占总数%</th>
                                </tr>
                            </thead>     
                        </table>
                    </div>
					<div id="Div_standing"  region="center" style="padding: 5px; height: 300px; width:100%; display:none" border="false">
                        <table id="dg_standing" title="持续报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="true" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'averagerate',width:80" align="left">位号</th>
                                    <th data-options="field:'area',width:150" align="left">工段</th>
                                    <th data-options="field:'maxrate',width:150" align="left">报警持续次数</th>
									<th data-options="field:'disturbrate',width:150" align="left">报警持续时间(小时)</th>
                                </tr>
                            </thead>     
                        </table>
                    </div>
                </td>
                <td  width="10%">
                </td>
            </tr>
        </table>
    </div>
    <!-- </form> -->
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
            $('#container_Top10').hide();
            $('#Div1').show();
            $('#Div_top10').hide();
            $('#container_distribution_time').css('display','none');
            $('#container_distribution_area').css('display','none');
            $('#container_distribution_priority_area').css('display','none');
            $('#container_distribution_priority_all').css('display','none');
            $('#container_chattering').hide();
            $('#Div_chattering').hide();
            $('#container_standing').hide();
            $('#Div_standing').hide();
            $('#container_level_trend').hide();
            
            $('#dg').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val()
            });
        });
        
        $('#Top10').click(function (){ //点击Top10报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container').hide();
            $('#container_Top10').show();
            $('#Div1').hide();
            $('#Div_top10').show();
            $('#container_distribution_time').css('display','none');
            $('#container_distribution_area').css('display','none');
            $('#container_distribution_priority_area').css('display','none');
            $('#container_distribution_priority_all').css('display','none');
            $('#container_chattering').hide();
            $('#Div_chattering').hide();
            $('#container_standing').hide();
            $('#Div_standing').hide();
            $('#container_level_trend').hide();
            
            $('#dg_top10').datagrid({
               url:'alarm_histroy_list_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
               onLoadSuccess:function(){                    
                    var array = [];
                    var rows = $('#dg_top10').datagrid('getRows');
                    for(var i=0; i<rows.length; i++){
                        var temp = [rows[i].area, rows[i].averagerate];
                        array.push(temp);
                    }
                    $('#container_Top10').highcharts({
                        chart: {
                            type: 'bar'
                        },

                        title: {
                            text: 'Top 10报警统计'
                        },

                        xAxis: {
				            categories: [
                                'FI101',
                                'PIC104',
                                'TIC203',
                                'PI402',
                                'FI103',
                                'LIC104',
                                'PIC203',
                                'TI402',
                                'FI302',
                                'PI503'
                            ]
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
                            name: 'Top 10',
                            data: [100, 68, 55, 50, 44, 40, 30, 23, 20, 12]
                        }]
                        
                    });
               }
            });

        });
		
		$('#distribution').click(function (){ //点击报警分布按钮
			var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container').hide();
            $('#container_Top10').hide();
            $('#container_distribution_time').css('display','inline');
            $('#container_distribution_area').css('display','inline');
            $('#container_distribution_priority_area').css('display','inline');
            $('#container_distribution_priority_all').css('display','inline');
            $('#Div1').hide();
            $('#Div_top10').hide();
            $('#container_chattering').hide();
            $('#Div_chattering').hide();
            $('#container_standing').hide();
            $('#Div_standing').hide();
            $('#container_level_trend').hide();
			
            $('#container_distribution_time').highcharts({
				chart: {
					zoomType: 'x'
				},
				title: {
					text: '报警分布(按时间)'
				},
				xAxis: {
					type: 'datetime'
					//minRange: 14 * 24 * 3600000 // fourteen days
				},
				yAxis: {
					title: {
						text: '报警次数'
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
					name: '报警分布(按时间)',
					pointInterval: 3600 * 1000,
					pointStart: Date.UTC(2014, 12, 6),
					data: [10, 12, 13, 10, 15, 50, 35, 10]
				}]
			});

            $('#container_distribution_area').highcharts({
				chart: {
					plotBackgroundColor: null,
					plotBorderWidth: 1,//null,
					plotShadow: false
				},
				title: {
					text: '报警分布(按工段)'
				},
				tooltip: {
					//pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
					enabled: false
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
				series: [{
					type: 'pie',
					name: '报警分布(按工段)',
					data: [
						['常压塔',   45.0],
						['减压塔',       26.8],
						{
							name: '常压炉',
							y: 12.8,
							sliced: true,
							selected: true
						},
						['减压炉',    8.5],
						['吸收稳定',     6.2],
						['其它',   0.7]
					]
				}]
			});
			
			$('#container_distribution_priority_area').highcharts({
				chart: {
					type: 'column'
				},
				title: {
					text: '报警分布(按优先级)'
				},
				xAxis: {
                    categories: [
                        '常压塔',
                        '减压塔',
                        '常压炉',
                        '减压炉'
                    ]
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '优先级百分数'
                    }
                },
				tooltip: {
					headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}%</b></td></tr>',
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
                    name: '紧急',
                    data: [10, 5, 15, 21]

                }, {
                    name: '高',
                    data: [12, 20, 5, 4]

                }, {
                    name: '中',
                    data: [55, 30, 65, 60]

                }, {
                    name: '低',
                    data: [23, 45, 15, 15]

                }]
			});
			
			$('#container_distribution_priority_all').highcharts({
				chart: {
					plotBackgroundColor: null,
					plotBorderWidth: 1,//null,
					plotShadow: false
				},
				title: {
					text: '报警分布(按优先级)'
				},
				tooltip: {
					//pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
					enabled: false
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
				series: [{
					type: 'pie',
					name: '报警分布(按优先级)',
					data: [
						['紧急',   5.0],
						['高',       20],
						{
							name: '中',
							y: 15,
							sliced: true,
							selected: true
						},
						['低',    60]
					]
				}]
			});
		});
		
		$('#Chattering').click(function (){ //点击重复报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container_chattering').show();
            $('#Div_chattering').show();
            $('#container_standing').hide();
            $('#Div_standing').hide();
            $('#container_level_trend').hide();
            $('#container').hide();
            $('#container_Top10').hide();
            $('#Div1').hide();
            $('#Div_top10').hide();
            $('#container_distribution_time').css('display','none');
            $('#container_distribution_area').css('display','none');
            $('#container_distribution_priority_area').css('display','none');
            $('#container_distribution_priority_all').css('display','none');
            $('#dg_chattering').datagrid({
               url:'alarm_histroy_list_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
               onLoadSuccess:function(){                    
                    var array = [];
                    var rows = $('#dg_chattering').datagrid('getRows');
                    for(var i=0; i<rows.length; i++){
                        var temp = [rows[i].area, rows[i].averagerate];
                        array.push(temp);
                    }
                    $('#container_chattering').highcharts({
                        chart: {
					        type: 'column'
				        },
				        title: {
					        text: '重复报警分布'
				        },
				        xAxis: {
                            categories: [
                                '常压塔',
                                '减压塔',
                                '常压炉',
                                '减压炉'
                            ]
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '重复报警个数'
                            }
                        },
				        tooltip: {
					        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                '<td style="padding:0"><b>{point.y} 个</b></td></tr>',
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
                            name: '重复报警',
                            data: [10, 5, 5, 2]

                        }]
                        
                    });
               }
            });

        });
        
        $('#Standing').click(function (){ //点击持续报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container_standing').show();
            $('#Div_standing').show();
            $('#container_level_trend').hide();
            $('#container_chattering').hide();
            $('#Div_chattering').hide();
            $('#container').hide();
            $('#container_Top10').hide();
            $('#Div1').hide();
            $('#Div_top10').hide();
            $('#container_distribution_time').css('display','none');
            $('#container_distribution_area').css('display','none');
            $('#container_distribution_priority_area').css('display','none');
            $('#container_distribution_priority_all').css('display','none');
            $('#dg_standing').datagrid({
               url:'alarm_histroy_list_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
               onLoadSuccess:function(){                    
                    var array = [];
                    var rows = $('#dg_standing').datagrid('getRows');
                    for(var i=0; i<rows.length; i++){
                        var temp = [rows[i].area, rows[i].averagerate];
                        array.push(temp);
                    }
                    $('#container_standing').highcharts({
                        chart: {
					        type: 'column'
				        },
				        title: {
					        text: '持续报警分布'
				        },
				        xAxis: {
                            categories: [
                                '常压塔',
                                '减压塔',
                                '常压炉',
                                '减压炉'
                            ]
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '持续报警个数'
                            }
                        },
				        tooltip: {
					        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                '<td style="padding:0"><b>{point.y} 个</b></td></tr>',
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
                            name: '持续报警',
                            data: [1, 15, 5, 8]

                        }]
                        
                    });
               }
            });

        });
        
        $('#LevelTrend').click(function (){
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container_standing').hide();
            $('#Div_standing').hide();
            $('#container_level_trend').show();
            $('#container_chattering').hide();
            $('#Div_chattering').hide();
            $('#container').hide();
            $('#container_Top10').hide();
            $('#Div1').hide();
            $('#Div_top10').hide();
            $('#container_distribution_time').css('display','none');
            $('#container_distribution_area').css('display','none');
            $('#container_distribution_priority_area').css('display','none');
            $('#container_distribution_priority_all').css('display','none');
            
            $('#container_level_trend').highcharts({
                chart: {
                    zoomType: 'xy'
                },
                title: {
                    text: '报警系统等级趋势变化'
                },
                xAxis: [{
                    categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                }],
                yAxis: [{ // Primary yAxis
                    labels: {
                        format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    title: {
                        text: '平均报警率',
                        style: {
                            color: Highcharts.getOptions().colors[2]
                        }
                    },
                    opposite: true

                }, { // Secondary yAxis
                    gridLineWidth: 0,
                    title: {
                        text: '报警系统等级',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    },
                    labels: {
                        format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    }

                }, { // Tertiary yAxis
                    gridLineWidth: 0,
                    title: {
                        text: '最大报警率',
                        style: {
                            color: Highcharts.getOptions().colors[1]
                        }
                    },
                    labels: {
                        format: '{value}',
                        style: {
                            color: Highcharts.getOptions().colors[1]
                        }
                    },
                    opposite: true
                }],
                tooltip: {
                    shared: true
                },
                legend: {
                    layout: 'vertical',
                    align: 'left',
                    x: 120,
                    verticalAlign: 'top',
                    y: 20,
                    floating: true,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'
                },
                series: [{
                    name: '报警系统等级',
                    type: 'column',
                    yAxis: 1,
                    data: [5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 2, 3],
                    tooltip: {
                        valueSuffix: ' '
                    }

                }, {
                    name: '最大报警率',
                    type: 'spline',
                    yAxis: 2,
                    data: [50, 16, 101, 35.5, 442.3, 69.5, 79.6, 60.2, 53.1, 36.9, 28.2, 26.7],
                    marker: {
                        enabled: true,
                        symbol:'triangle'
                    },
                    tooltip: {
                        valueSuffix: ' '
                    }

                }, {
                    name: '平均报警率',
                    type: 'spline',
                    data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],
                    tooltip: {
                        valueSuffix: ' '
                    }
                }]
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
