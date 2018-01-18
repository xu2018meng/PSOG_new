<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis_report_wx.aspx.cs" Inherits="alarm_analysis_report_wx" %>

<!DOCTYPE html>
<html>
<head id="Head1">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
   
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
    <script type="text/javascript" src="../resource/js/json2.js"></script>
    <style type="text/css">
${demo.css}
		</style>
		<script type="text/javascript">
		    var plant = ''; 
            $(function () {
                $.ajax({
                    url: 'plant_list.html',
                    dataType: "json",
                    success: function(data){
                        var plantID = "<%=plantId %>";
                        for(var o in data){
                            if(plantID == data[o].plantID){
                                plant = data[o].plantName;
                                document.getElementById('plant_report_title').innerHTML = data[o].plantName;
                                document.getElementById('plant_report_part1').innerHTML = data[o].plantName;
                                break;
                            }
                        }             
                    }
                 });
                
                Highcharts.wrap(Highcharts.Chart.prototype, 'getSVG', function (proceed) {
		            return proceed.call(this)
		                .replace(
		                    /(fill|stroke)="rgba\(([ 0-9]+,[ 0-9]+,[ 0-9]+),([ 0-9\.]+)\)"/g, 
		                    '$1="rgb($2)" $1-opacity="$3"'
		                );
		        });
                $( "#container_level_trend" ).tabs();
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#ff0000", "#FF8000", "#F9f900", "#6699CC", "#99CC33", "#336633", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
//                    chart: {
//                        borderWidth: 1
//                    }
                });
                
                $('#container').highcharts({

                    chart: {
                    },

                    title: {
                        useHTML: true,
                        text: '报警系统等级评估'
                    },
                    
                    subtitle: {
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

                    legend: {
                        enabled: true
                    },
					
					plotOptions: {
						scatter: {
							dataLabels: {
								enabled: true,
								format: '{point.name}'
							}
						}
					},
                    series: [{
                        type: 'arearange',
                        name: '1-可预测的',
			            color: 'rgba(0,255,0,0.5)',
						tooltip: {
							enabled: true,
							useHTML: true,
							headerFormat: '<span>',
							pointFormat: '{series.name}:' + '<b>操作人员可以提前发现并报告，有足够时间处理报警。</b>',
							footerFormat: '</span>'
						},
                        data: [[0.1, 0.1, 1],
				              [10, 0.1, 1]]
			            },
			            {
				            type: 'arearange',
				            name: '2-鲁棒的',
				            color: 'rgba(0,0,255,0.5)',
							tooltip: {
								enabled: true,
								useHTML: true,
								headerFormat: '<span>',
								pointFormat: '{series.name}:' + '<b>干扰信息不再出现，报警信息被准确识别。</b>',
								footerFormat: '</span>'
							},
				            data: [[0.1, 1, 10],
						            [10, 1, 10],
						            [10, 0.1, 10],
						            [100, 0.1, 10]]
			            },
			            {
				            type: 'arearange',
				            name: '3-稳定的',
				            color: 'rgba(255,255,0,0.5)',
							tooltip: {
								enabled: true,
								useHTML: true,
								headerFormat: '<span>',
								pointFormat: '{series.name}:' + '<b>报警信息得到稳定的控制。</b>',
								footerFormat: '</span>'
							},
				            data: [[100, 0.1, 10],
						            [1000, 0.1, 10]]
			            },
			            {
				            type: 'arearange',
				            name: '4-反应性的',
				            color: 'rgba(255,128,0,0.5)',
							tooltip: {
								enabled: true,
								useHTML: true,
								headerFormat:  '<span>',
								pointFormat: '{series.name}:' + '<b>已报警的信息得不到有效地控制。</b>',
								footerFormat:  '</span>'
							},
				            data: [[0.1, 10, 100],
						            [1000, 10, 100],
						            [1000, 0.1, 100],
						            [10000, 0.1, 100]]
			            },
			            {
				            type: 'arearange',
				            name: '5-超负荷的',
				            color: 'rgba(227,23,13,0.5)',
							tooltip: {
								enabled: true,
								useHTML: true,
								headerFormat: '<span>',
								pointFormat: '{series.name}:' + '<b>操作人员无法准确的辨认和处理报警信息。</b>',
								footerFormat: '</span>'
							},
				            data: [[0.1, 100, 1000],
						            [10000, 100, 1000]]
			            },
			            {
			                type:'scatter',
			                name:'等级评估',
							showInLegend: false,
			                dataLabels: {
                                enabled: true,
                                useHTML: true,
                                format: '<span style="color:Black; font-weight:bold">{point.name}</span>'
                            },
                            tooltip: {
                                enabled: false,
							    useHTML: true,
							    headerFormat: '<span>',
								pointFormat: '{point.name}：' + '<b>{point.level}</b>',
								footerFormat: '</span>'
							},
			                marker:{
			                    enabled: true,
			                    fillColor:'#7cb5ec',
			                    symbol:'triangle',
			                    radius: 8
			                    }
			            },
			            {
			                type:'scatter',
			                name:'等级名称',
							showInLegend: false,
			                dataLabels: {
                                enabled: true,
                                useHTML: true,
                                format: '<span style="font-size: large; color:Black; font-weight:bold">{point.name}</span>'
                            },
                            data: [{
	                            'name': '1-可预测的',
	                            x: 0.5,
	                            y: 0.2
                            }, {
	                            'name': '2-鲁棒的',
	                            x: 40,
	                            y: 1
                            }, {
	                            'name': '3-稳定的',
	                            x: 400,
	                            y: 1
                            }, {
	                            'name': '4-反应性的',
	                            x: 4000,
	                            y: 10
                            }, {
	                            'name': '5-超负荷的',
	                            x: 1000,
	                            y: 200
                            }],
                            tooltip: {
								enabled: false
							},
			                marker:{
			                    enabled: false
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
<body  class="easyui-layout" style="width:100%; height:100%;">
    <!-- <form id="form1" action=""> -->
        <div style="padding-bottom: 5px;overflow-y:hidden;" id="qryDiv"  region="north"  border="false">
            <table class="tblSearch" style="padding-left:5%">
                <tr style="height:auto;">                        
                  <td class="leftTdSearch"  style="vertical-align:middle; text-align:center;" nowrap="nowrap"> 
                   <div style="float:left;font-weight:bold;font-size:14px;padding-top:3px;">时间范围&nbsp;&nbsp;</div>
                    <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="18"   readonly="true" /> 
                    ---
                    <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="18"  readonly="true" /> 
                  </td>
                </tr>
                <tr>
                   <td>
                     <div style="font-weight:bold;font-size:14px;padding-top:0px;">数据来源&nbsp;&nbsp;
                         <select id="dbSource" name="dbSource"  style="width:137px; height: 24px;padding-top:5px;">
                           <option value="0">实时数据库</option>
                           <option value="1">DCS报警日志</option>
                          </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; <a id="generate_report"  href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-search" plain="true" style="font-weight:bold;font-size:16px;" >查询</a>
                    </div>
                   </td>
                </tr>
            </table> 
            <hr style="width:95%; color:#987cb9; size:5" />
        </div>
         
        <div id="gridDiv"  region="center" style="padding: 5px; height: 100%;" border="false">
            <table width="100%" height="100%">
                <tr id="page_report">
                    <td style="width:10%">
                    </td>
                    <td style=" width:60%">
                        <div style=" text-align:center; font-size:x-large; font-weight:bolder;" ><span id="plant_report_title" style=" text-align:center; font-size:x-large; font-weight:bolder"></span>装置<br />报警分析报表<br /></div>
                        <div id="time_text" style=" text-align:center; font-size:larger; font-weight:bolder"></div>
                        <div style=" text-align:left; font-size:larger;">
                            <span style=" font-weight:bold;font-size:larger;">术语定义</span><br />
                            <span style=" font-weight:bold;font-size:larger;">报警次数：</span>将某一个参数从开始报警到结束报警的完整的一个时间段称为1次报警。<br />
                            <span style=" font-weight:bold;font-size:larger;">报警个数：</span>某一时间段内发生报警的参数的个数。一个参数多次报警，视为报警个数为1个。<br /><br />
                            <span style=" font-weight:bold;font-size:larger;">一、综合评估</span><br />
                            对于<span id="plant_report_part1" style=" font-weight:bold;font-size:larger;"></span>装置，在指定时间范围内报警系统的整体状况评估如下：<br />
                        </div>
                        
                        <div id="Div1" style="padding: 5px; min-height: 400px;" border="false">
                            <table id="dg" title="报警系统等级评估" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                     idField="id" rownumbers="true" fitColumns="true" singleSelect="true" nowrap="false" striped="true">
                                <thead>
                                    <tr>
                                        <th data-options="field:'index_name'" style="width:20%" align="left"></th>
                                        <th data-options="field:'plant_num',styler:cellStyler,formatter:formatValue" style="width:23%" align="left">当前值</th>
                                        <th data-options="field:'index_goal'" style="width:22%" align="left">目标值</th>
                                        <th data-options="field:'remark'" style="width:35%" align="left">备注</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        
                        <div style=" text-align:left; font-size:larger;">
                            <br /><br />
                            <span style=" font-weight:bold;font-size:larger;">二、详细分析</span><br />
                            <span style=" font-weight:bold;font-size:large;">1、报警系统等级评估</span><br />
                            在指定时间范围内，以平均报警率和最大报警率为指标，对报警系统进行等级评估，等级从高到低分别为“可预测的”、“鲁棒的”、“稳定的”、“反应性的”和“超负荷的”。<br />
                        </div>
                        <div id="container" style=" height: 400px; margin: 0 auto"></div>
                        <div id="container_hide" style=" height: 400px; margin: 0 auto; display:none"></div>
                        <div style=" text-align:left; font-size:larger;">
                            <span style=" font-weight:bold;font-size:large;">2、报警分布</span><br />
                            <span style=" font-size:large;">（1）报警单元分布</span><br />
                        </div>
                        <div id="container_distribution_area" style="height: 300px; margin: 0 auto"></div>
                        <div id="container_chattering" style=" height: 400px; margin: 0 auto; "></div>
					    <div id="container_standing" style=" height: 400px; margin: 0 auto; "></div>
					    
                        <div style=" text-align:left; font-size:larger;">
                            <br /><span style=" font-size:large;">（2）报警时间分布</span><br />
                        </div>
                        <div id="container_distribution_time" style="height: 300px; margin: 0 auto;"></div>
                        
                        <div id="priority_flag" style=" text-align:left; font-size:larger;">
                            <br /><span style=" font-size:large;">（3）报警优先级分布</span><br />
                            注：在国际标准里，报警优先级分布的目标是<span style="color:Red; font-size:larger">“紧急”次数小于5个，“高”比例约5%，“中”比例约15%，“低”比例约80%。</span>
                        </div>
                        <div id="container_distribution_priority_all" style=" height: 300px; margin: 0 auto;"></div>
                        <div id="container_distribution_priority_area" style=" height: 300px; margin: 0 auto; "></div>
                        
                        <div id="Top20_flag" style=" text-align:left; font-size:larger;">
                            <br /><span style=" font-weight:bold;font-size:large;">3、报警排行</span><br />
                            <span style=" font-size:large;">（1）报警次数排行Top20</span><br />
                            指定时间范围内，Top10报警次数占报警总数百分比为<span id="top10_percent" style="color:Red; font-size:larger"></span>。在国际标准里，Top10报警次数占报警总数百分比目标为<span style="color:Red; font-size:larger">约1%~5%</span>。
                        </div>
                        <div id="container_Top20" style=" height: 600px; margin: 0 auto; "></div>
                        <div id="Div_top20"   style="padding: 5px; height: 300px;" border="false">
                            <table id="dg_top20" title="Top 20报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                     idField="zhStartTime" pagination="false" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true" nowrap="false" striped="true">
                                <thead>
                                    <tr>                    
                                        <th data-options="field:'tagname',width:80" align="left">位号</th>
                                          <th data-options="field:'description',width:200" align="left">描述</th>
                                        <th data-options="field:'area',width:90" align="left">工段</th>
                                        <th data-options="field:'count',width:80" align="left">报警次数</th>
									    <th data-options="field:'percent',width:80" align="left">占总数%</th>
									  
                                    </tr>
                                </thead>     
                            </table>
                        </div>
                        
                        <div id="standing_flag" style=" text-align:left; font-size:larger;">
                            <br /><span style=" font-size:large;">（2）报警持续时间排行TopN</span><br />
                            指定时间范围内，单次报警持续时间长度排行，其中持续时间达到8小时的报警次数为<span id="standing_count_order" style="color:Red; font-size:larger"></span>个。
                            在国际标准里，任意一天中持续时间达到8小时的报警次数应<span style="color:Red; font-size:larger">小于5个</span>。<br />
                        </div>
                        <div id="Div_standing"  style="padding: 5px; height: 300px;" border="false">
                            <table id="dg_standing" title="持续报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                     idField="zhStartTime" pagination="false" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true" striped="true">
                                <thead>
                                    <tr>                    
                                        <th data-options="field:'tagname',width:80" align="left">位号</th>
                                         <th data-options="field:'description',width:200" align="left">描述</th>
                                        <th data-options="field:'area',width:150" align="left">工段</th>
                                        <th data-options="field:'startTime',width:150" align="left">报警开始时间</th>
                                        <th data-options="field:'endTime',width:150" align="left">报警结束时间</th>
									    <th data-options="field:'alarmInterval',width:150" align="left">报警持续时间(分钟)</th>
									   
                                    </tr>
                                </thead>     
                            </table>
                        </div>
                        
                        <div id="chattering_flag" style=" text-align:left; font-size:larger;">
                            <span style=" font-weight:bold;font-size:medium;">参数报警持续时间较长可能原因及措施：</span><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;a. 仪表失灵，一直处于报警状态，对于重要监测参数应及时更换仪表；<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;b. 装置该段生产过程处于停工状态，报警已无实际意义，建议屏蔽该监测参数；<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;c. 报警上下限设置不合理，监测参数长期运行在报警上下限以外，则该报警上下限已无作用，建议根据工艺参数运行情况以及工艺参数安全边界设置新的报警上下限。<br /><br />
                            <span style=" font-size:large;">（3）重复报警排行TopN</span><br />
                            对于单一变量，在短时间内报警触发2次或以上，称为重复报警。本系统指定任意连续5分钟内，报警触发2次或以上，为一次重复报警。<br />
                            指定时间范围内，重复报警个数为<span id="chattering_count_order" style="color:Red; font-size:larger"></span>个，在国际标准里，重复报警个数应<span style="color:Red; font-size:larger">约0个</span>。<br />
                        </div>
                        <div id="Div_chattering"  style="padding: 5px; height: 300px;" border="false">
                            <table id="dg_chattering" title="重复报警统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                     idField="zhStartTime" pagination="false" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true" striped="true">
                                <thead>
                                    <tr>                    
                                        <th field="tagname" width="150" align="center" >位号</th>
                                         <th data-options="field:'description',width:200" align="left">描述</th>
									    <th field="area" width="150" align="center" >工段</th>
									    <th field="chatteringCount" width="150" align="center" >重复报警次数</th>
									    <th field="totalCount" width="150" align="center" >报警总次数</th>
									    <th field="percent" width="150" align="center" >重复报警率（重复报警次数/总报警次数）</th>
									   
                                    </tr>
                                </thead>     
                            </table>
                        </div>
                        <div style=" text-align:left; font-size:larger;">
                            <span style=" font-weight:bold;font-size:medium;">参数报警频繁的可能原因：</span><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;a. 装置该段时间内不稳定，导致监测参数波动较大，频繁触发报警上下限；<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;b. 装置运行工况改变，监测参数原有报警上下限已失效；<br />
                            &nbsp;&nbsp;&nbsp;&nbsp;c. 监测参数仪表存在失灵状况，采集数据跳动较大。<br />
                            <span style=" font-weight:bold;font-size:medium;">建议措施：</span><br />
                            &nbsp;&nbsp;&nbsp;&nbsp;查看监测参数的历史数据，根据装置运行状况，查看仪表是否正常，设置合理报警上下限等。<br /><br />
                        </div>
                        
					    
					    
                    </td>
                    <td  style="width:10%">
                    </td>
                </tr>
                <tr>
                    <td style="width:10%">
                    </td>
                    <td style=" width:80%">
                        <div id="reportHistory"   style="padding: 5px; height: 100%; display:none" border="false">
                            <div style=" text-align:left; font-size:larger;">
                                报警报表历史查询
                            </div>
                        </div>
                    </td>
                    <td  style="width:10%">
                    </td>
                </tr>
            </table>
        </div>
        <iframe name="myIframe" style="display:none"></iframe>
        
    <!-- </form> -->
    <script type="text/javascript">
    
    var dbSource = "0";
    
    var startDateOfGenRpt = $("#startTime").val();  //记录当前页面的报表日期范围
    var endDateOfGenRpt = $("#endTime").val();
    
    
    function formatValue(val,row){
	    var rowIndex = $('#dg').datagrid('getRowIndex', row);
	    //报警系统等级
		if (rowIndex == 0 && val != '可预测的'){
			return "<a href='#container'>"+val+"（偏低）</a>";
		}else if(rowIndex == 0){
		    return "<a href='#container'>"+val+"</a>";
		}
		//平均报警率
		if (rowIndex == 1 && parseFloat(val) > 1.0 && parseFloat(val) < 10.0){
			return "<a href='#container_distribution_time'>"+val+"（偏高）</a>";
		}else if(rowIndex == 1 && parseFloat(val) >= 10.0){
		    return "<a href='#container_distribution_time'>"+val+"（过高）</a>";
		}else if(rowIndex == 1 && parseFloat(val) <= 1.0){
		    return "<a href='#container_distribution_time'>"+val+"</a>";
		}
		//最大报警率
		if (rowIndex == 2 && parseFloat(val) > 10.0 && parseFloat(val) < 30.0){
			return "<a href='#container_distribution_time'>"+val+"（偏高）</a>";
		}else if(rowIndex == 2 && parseFloat(val) >= 30.0){
		    return "<a href='#container_distribution_time'>"+val+"（过高）</a>";
		}else if(rowIndex == 2 && parseFloat(val) <= 10.0){
		    return "<a href='#container_distribution_time'>"+val+"</a>";
		}
		//扰动率
		if (rowIndex == 3 && parseFloat(val) > 5.0 && parseFloat(val) < 10.0){
			return "<a href='#container_distribution_time'>"+val+"（偏高）</a>";
		}else if(rowIndex == 3 && parseFloat(val) >= 10.0){
		    return "<a href='#container_distribution_time'>"+val+"（过高）</a>";
		}else if(rowIndex == 3 && parseFloat(val) <= 5.0){
		    return "<a href='#container_distribution_time'>"+val+"</a>";
		}
		//优先级分布
		var HI = parseFloat(val.split("为")[1]);
		var ME = parseFloat(val.split("为")[2]);
		var LO = parseFloat(val.split("为")[3]);
		if (rowIndex == 4){
		    if(HI > 10){
		        return "<a href='#priority_flag'>"+val+"（报警优先级分布不合理）</a>";
		    }else{
		        return "<a href='#priority_flag'>"+val+"</a>";
		    }
		}
		//Top10报警次数百分比
		if (rowIndex == 5 && parseFloat(val) > 5.0 && parseFloat(val) < 50.0){
			return "<a href='#Top20_flag'>"+val+"（偏高）</a>";
		}else if(rowIndex == 5 && parseFloat(val) >= 50.0){
		    return "<a href='#Top20_flag'>"+val+"（过高）</a>";
		}else if(rowIndex == 5 && parseFloat(val) <= 5.0){
		    return "<a href='#Top20_flag'>"+val+"</a>";
		}
		//报警持续时间超8小时个数
		if (rowIndex == 6 && parseFloat(val) > 5.0 && parseFloat(val) < 20.0){
			return "<a href='#standing_flag'>"+val+"（偏高）</a>";
		}else if(rowIndex == 6 && parseFloat(val) >= 20.0){
		    return "<a href='#standing_flag'>"+val+"（过高）</a>";
		}else if(rowIndex == 6 && parseFloat(val) <= 5.0){
		    return "<a href='#standing_flag'>"+val+"</a>";
		}
		//重复报警个数
		if (rowIndex == 7 && parseFloat(val) > 0.0 && parseFloat(val) < 10.0){
			return "<a href='#chattering_flag'>"+val+"（偏高）</a>";
		}else if(rowIndex == 7 && parseFloat(val) >= 10.0){
		    return "<a href='#chattering_flag'>"+val+"（过高）</a>";
		}else if(rowIndex == 7 && parseFloat(val) == 0.0){
		    return "<a href='#chattering_flag'>"+val+"</a>";
		}
		return val;
	}
	function cellStyler(value,row,index){
		//报警系统等级
		if (index == 0 && value != '可预测的'){
			return 'background-color:#ff5151;font-weight:bold;';
		}
		//平均报警率
		if (index == 1 && parseFloat(value) > 1.0 && parseFloat(value) < 10.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 1 && parseFloat(value) >= 10.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		//最大报警率
		if (index == 2 && parseFloat(value) > 10.0 && parseFloat(value) < 30.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 2 && parseFloat(value) >= 30.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		//扰动率
		if (index == 3 && parseFloat(value) > 5.0 && parseFloat(value) < 10.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 3 && parseFloat(value) >= 10.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		//优先级分布
		var HI = parseFloat(value.split("为")[1]);
		var ME = parseFloat(value.split("为")[2]);
		var LO = parseFloat(value.split("为")[3]);
		if (index == 4){
		    if(HI > 10){
		        return 'background-color:#ff5151;font-weight:bold;';
		    }
		}
		//Top10报警次数百分比
		if (index == 5 && parseFloat(value) > 5.0 && parseFloat(value) < 50.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 5 && parseFloat(value) >= 50.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		//报警持续时间超8小时个数
		if (index == 6 && parseFloat(value) > 5.0 && parseFloat(value) < 20.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 6 && parseFloat(value) >= 20.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		//重复报警个数
		if (index == 7 && parseFloat(value) > 0.0 && parseFloat(value) < 10.0){
			return 'background-color:#ff8000;font-weight:bold;';
		}else if(index == 7 && parseFloat(value) >= 10.0){
		    return 'background-color:#ff5151;font-weight:bold;';
		}
		return 'background-color:#82d900;font-weight:bold;';
	}
    $(function(){
            
         $('#generate_report').click(function (){
            startDateOfGenRpt = $("#startTime").val();
            endDateOfGenRpt = $("#endTime").val();
            
            var chart_hide = $('#container_hide').highcharts();
            var svg_hide = chart_hide.getSVG();
            
            showLevelAssess();
        });
        
        $('#report_history').click(function (){
            var startDateOfGenRpt = $("#startTime").val();
            var endDateOfGenRpt = $("#endTime").val();
            
            $('#page_report').hide();
            $('#reportHistory').show();
        });
        
        
        $('#dg').datagrid({
            url:'alarm_analysis_outline_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&id=1&dbSource='+dbSource,//alarm_analysis_outline_data
            onLoadSuccess:function(){
		        var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();

                if(startTime > endTime){
                    alert("查询开始时间不能大于截止时间！");
                    return;
                }		

                
                var chart = $('#container').highcharts();
                //chart.showLoading('正在加载数据...');
                var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
                chart.setTitle({text: '<span style="font-size: large; color:Black; font-weight:bold">报警系统等级评估</span> <img id="tip_level" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'}, { text: sub_title});
                
                startTime = startTime.replace(/:/g,'').replace(/-/g,'').replace(/ /g,'');
                endTime = endTime.replace(/:/g,'').replace(/-/g,'').replace(/ /g,'');
                $.ajax({
                    url: './alarm_level_data/<%=plantId %>'+startTime+endTime+'.html',
                    dataType: "json",
                    success: function(data){
                        var array = [];
                        for(var o in data)
                        {
                            var tempMax = data[o].maxrate;
                            if(tempMax < 0.1){
                                tempMax = 0.1;
                            }
                            var tempAverage = data[o].averagerate;
                            if(tempAverage < 0.1){
                                tempAverage = 0.1;
                            }
                            var temp = {'name':data[o].area, x:tempMax, y:tempAverage, 'level':data[o].level};
                            array.push(temp);
                        }
                        var chart = $('#container').highcharts();
                        chart.series[5].setData(array);
                        
                        chart.hideLoading();
                    }
                });
                $("#tip_level").qtip({
                    content: {
                        text: "<b>报警系统等级评估:</b>报警系统等级分为5级，即可预测的、鲁棒的、稳定的、反应性的和超负荷的。评估标准以平均报警率和最大报警率为依据，目标为可预测的。",
                        title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
                
                showTop20();
                showDistribution();
                showChattering();
                showStanding();
            }
        });
        showLevelAssess();
        function showLevelAssess(){  //点击等级评估按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            dbSource = $("#dbSource").val();
            
            $('#export_report_button').linkbutton('disable');
            var chart = $('#container').highcharts();
            chart.showLoading('正在加载数据...');
		    document.getElementById('time_text').innerHTML=startTime+"---"+endTime;
            $('#container_hide').highcharts({        //隐藏
				chart: {
			        type: 'column'
		        },
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警单元分布</span> '
				},
				subtitle: {
                },
				xAxis: {
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '报警次数'
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
                    name: '报警次数'

                }]
			});

            
            $('#dg').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val(),
                dbSource:dbSource
            });
        }
        
        $('#export_report').click(function (){
            var chart = $('#container_distribution_priority_all').highcharts();
            var svg_temp = chart.getSVG();
            console.log(svg_temp);
            $.ajax({
                type: "post",
                url: 'alarm_analysis_report_data_wx.ashx',
                data: {"plantId":"sasa", "svg":svg_temp},
                dataType: "json",
                success: function(data){
                    
                }
            });

        });
        
        $('#dg_top20').datagrid({
           url:'alarm_analysis_by_order_top20.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&dbSource='+dbSource,
           onLoadSuccess:function(){                     
                var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();
                
                var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
                
                $('#container_Top20').highcharts({
                    chart: {
                        type: 'bar'
                    },

                    title: {
                        useHTML: true,
                        text: '<span style="font-size: large; color:Black; font-weight:bold">报警次数Top 20统计</span> <img id="tip_topN" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
                    },
                    navigation: {
                        buttonOptions: {
                            enabled: false
                        }
                    },
                    subtitle: {
                        text: sub_title
                    },

                    xAxis: {
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
                        dataLabels: {
                            enabled: true,    //默认是false，即默认不显示数值
                            color: '#FFFFFF',    //字体颜色
                            align: 'right',   //居柱子中间
                            x: 0
                        }
                    }]
                    
                });
                var chart_top20 = $('#container_Top20').highcharts();
                chart_top20.showLoading('正在加载数据...');
                
                var array = [];
                var categories = [];
                var rows = $('#dg_top20').datagrid('getRows');
                for(var i=0; i<rows.length; i++){
                    categories[i] = rows[i].tagname;
                    array.push([rows[i].count]);
                }
                
                var top10_percent = 0;
                for(var i=0; i<rows.length && i<10; i++){
                    top10_percent = top10_percent + rows[i].percent;
                }
                document.getElementById('top10_percent').innerHTML = Math.round((top10_percent*100))/100+"%";
                
                chart_top20.xAxis[0].setCategories(categories);
                chart_top20.series[0].setData(array);
                chart_top20.hideLoading();
                
                
                $("#tip_topN").qtip({
                    content: {
                        text: "<b>报警次数Top 20统计：</b>在指定时间范围内，统计装置中报警次数排名前20位的位号。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
           }
        });
        function showTop20(){ //点击Top20报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            dbSource = $("#dbSource").val();
            
            
            $('#dg_top20').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val(),
                dbSource:dbSource
            });
        }
		
		function showDistribution(){ //点击报警分布按钮
			var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
             dbSource = $("#dbSource").val();
            
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
	
            $('#container_distribution_time').highcharts({
				chart: {
					zoomType: 'x'
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警时间分布</span> <img id="tip_distribution_time" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
					name: '报警分布(按时间)'
				}]
			});
			$("#tip_distribution_time").qtip({
                content: {
                    text: "<b>报警时间分布：</b>在指定时间范围内，报警次数随着时间的变化，其中以10分钟为单位时间段。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });

           $('#container_distribution_area').highcharts({        //报警次数分布
				chart: {
			        type: 'column'
		        },
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警单元分布</span> <img id="tip_distribution_area" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '报警次数'
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
                    name: '报警次数',
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}</span>'
                    }

                }]
			});
			$("#tip_distribution_area").qtip({
                content: {
                    text: "<b>报警单元分布：</b>在指定时间范围内，对装置各单元的报警次数进行统计分析。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
            
            var chart_time = $('#container_distribution_time').highcharts();
            chart_time.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'alarm_analysis_by_distribution_time.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime+"&dbSource="+dbSource,
                data: null,
                dataType: "json",
                success: function(data){
                    var new_data = []; //用于报警时间分布
                    for(var o in data){
                        var aa = Date.parse(data[o].startTime)+8*60*60*1000;
                        new_data.push([aa, data[o].alarmCount]);  
                    } 
                    var chart_time = $('#container_distribution_time').highcharts();
                    chart_time.series[0].setData(new_data);
                    chart_time.hideLoading();
                }
            });
            
            var chart_area = $('#container_distribution_area').highcharts();
            chart_area.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'alarm_analysis_by_distribution_process.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime+"&dbSource="+dbSource,
                data: null,
                dataType: "json",
                success: function(data){
                    var array_alarm = [];  //报警次数
                    var categories = [];
                    for(var o in data){
                        array_alarm.push(data[o].alarmCount);
                        categories.push(data[o].area);
                    } 
			var chart_area = $('#container_distribution_area').highcharts();
                    chart_area.xAxis[0].setCategories(categories);
                    chart_area.series[0].setData(array_alarm);
                    chart_area.hideLoading();
                    
                    $('#export_report_button').linkbutton('enable');
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $('#export_report_button').linkbutton('enable');
                }
            });
			
			$('#container_distribution_priority_area').highcharts({
				chart: {
					type: 'column'
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警工段-优先级分布</span> <img id="tip_distribution_priority1" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
				},
				navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
				subtitle: {
                    text: sub_title
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
                    data: [10, 5, 15, 21],
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}%</span>'
                    }

                }, {
                    name: '高',
                    data: [12, 20, 5, 4],
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}%</span>'
                    }

                }, {
                    name: '中',
                    data: [55, 30, 65, 60],
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}%</span>'
                    }

                }, {
                    name: '低',
                    data: [23, 45, 15, 15],
                    dataLabels: {
                        enabled: true,    //默认是false，即默认不显示数值
                        color: '#666',    //字体颜色
                        align: 'center',   //居柱子中间
                        format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}%</span>'
                    }

                }]
			});
			$("#tip_distribution_priority1").qtip({
                content: {
                    text: "<b>报警工段-优先级分布：</b>在指定时间范围内，对装置各工段中每个优先级的报警次数百分比分布统计。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
			
			$('#container_distribution_priority_all').highcharts({
				chart: {
					plotBackgroundColor: null,
					plotBorderWidth: 1,//null,
					plotShadow: false
				},
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警优先级分布</span> <img id="tip_distribution_priority2" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
				},
				navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
				subtitle: {
                    text: sub_title
                },
				tooltip: {
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
					name: '报警优先级分布',
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
			
			$("#tip_distribution_priority2").qtip({
                content: {
                    text: "<b>报警优先级分布：</b>在指定时间范围内，对装置每个优先级的报警次数百分比分布统计。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
		
		}
		
		$('#dg_chattering').datagrid({
           url:'alarm_analysis_by_order_chattering.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&dbSource='+dbSource,
           onLoadSuccess:function(){       
                var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();

                if(startTime > endTime){
                    alert("查询开始时间不能大于截止时间！");
                    return;
                }
                
                var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
                
                $('#container_chattering').highcharts({
                    chart: {
			            type: 'column'
		            },
		            title: {
			            useHTML: true,
                        text: '<span style="font-size: large; color:Black; font-weight:bold">重复报警分布</span> <img id="tip_chattering" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		            },
		            navigation: {
                        buttonOptions: {
                            enabled: false
                        }
                    },
		            subtitle: {
                        text: sub_title
                    },
		            xAxis: {},
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
                        dataLabels: {
                            enabled: true,    //默认是false，即默认不显示数值
                            color: '#666',    //字体颜色
                            align: 'center',   //居柱子中间
                            format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}</span>'
                        }
                    }]
                    
                });
                
                var chart_chattering = $('#container_chattering').highcharts();
                chart_chattering.showLoading('正在加载数据...');
                
                var array = [];
                var categories = [];
                var areaTemp = "";
                var rows = $('#dg_chattering').datagrid('getRows');
                var total_num = 0;
                for(var i=0; i<rows.length; i++){
                    if(rows[i].chatteringCount > 0){
                        areaTemp = rows[i].area;
                        for(var j=0; j<categories.length; j++){
                            if(categories[j] == areaTemp){
                                array[j] = array[j]+1;
                                break;
                            }
                        }
                        if(j == categories.length){
                            categories[j] = rows[i].area;
                            array[j] = 1;
                        }
                        total_num = total_num+1;
                    }
                }
                if(total_num == 0){
                    document.getElementById('chattering_count_order').innerHTML = total_num;
                }
                else if(total_num < 20){
                    document.getElementById('chattering_count_order').innerHTML = total_num;
                }else{
                    document.getElementById('chattering_count_order').innerHTML = "不小于20";
                }
                
                chart_chattering.xAxis[0].setCategories(categories);
                chart_chattering.series[0].setData(array);
                chart_chattering.hideLoading();
                
                $("#tip_chattering").qtip({
                    content: {
                        text: "<b>重复报警分布：</b>在指定时间范围内，对装置各工段中重复报警个数的统计。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
           }
        });
		function showChattering(){ //点击重复报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            dbSource = $("#dbSource").val();
            
            $('#dg_chattering').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val(),
                dbSource:dbSource
            });

        }
        
        $('#dg_standing').datagrid({
           url:'alarm_analysis_by_order_standing.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&dbSource='+dbSource,
           onLoadSuccess:function(){
		        var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();

                if(startTime > endTime){
                    alert("查询开始时间不能大于截止时间！");
                    return;
                }			
                
                var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
                
                $('#container_standing').highcharts({
                    chart: {
				        type: 'column'
			        },
			        title: {
				        useHTML: true,
                        text: '<span style="font-size: large; color:Black; font-weight:bold">报警持续时间Top 20统计</span> <img id="tip_standing" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
                            text: '报警个数'
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
                        name: '报警个数',
                        data: [1, 15, 5, 8],
                        dataLabels: {
                            enabled: true,    //默认是false，即默认不显示数值
                            color: '#666',    //字体颜色
                            align: 'center',   //居柱子中间
                            format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}</span>'
                        }

                    }]
                    
                });
                
                var chart_standing = $('#container_standing').highcharts();
                chart_standing.showLoading('正在加载数据...');
                
                var array = [];
                var categories = [];
                var areaTemp = "";
                var rows = $('#dg_standing').datagrid('getRows');
                var standing_num = 0;
                for(var i=0; i<rows.length; i++){
                    if(rows[i].alarmInterval > -1){
                        areaTemp = rows[i].area;
                        for(var j=0; j<categories.length; j++){
                            if(categories[j] == areaTemp){
                                array[j] = array[j]+1;
                                break;
                            }
                        }
                        if(j == categories.length){
                            categories[j] = rows[i].area;
                            array[j] = 1;
                        } 
                    }
                    if(rows[i].alarmInterval > 8*60){
                        standing_num = standing_num+1;   
                    }
                }
                if(array.length == 0){
                    categories.push("装置");
                    array.push(0);
                }
                if(standing_num < 5){
                    document.getElementById('standing_count_order').innerHTML = standing_num;
                }else if(standing_num < 20){
                    document.getElementById('standing_count_order').innerHTML = standing_num;
                }else{
                    document.getElementById('standing_count_order').innerHTML = "不小于20";
                }
                chart_standing.xAxis[0].setCategories(categories);
                chart_standing.series[0].setData(array);
                chart_standing.hideLoading();
                
                $("#tip_standing").qtip({
                    content: {
                        text: "<b>报警持续时间Top 20统计：</b>在指定时间范围内，对装置各工段中报警持续时间Top 20统计。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
           }
        });
        function showStanding(){ //点击持续报警按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            dbSource = $("#dbSource").val();
            
            
            $('#dg_standing').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val(),
                dbSource:dbSource
            });

        }
        
    });
    
    //监听窗口大小改变
    function adjust(obj){
        var width= document.body.clientWidth; //获取窗体宽度
        if($("#container").highcharts()){
            var height_top20= $("#container").height(); //获取窗体宽度
            $("#container").highcharts().setSize(0.8*width, height_top20);
        }
        if($("#container_chattering").highcharts()){
            var height_chattering= $("#container_chattering").height(); //获取窗体宽度
            $("#container_chattering").highcharts().setSize(0.8*width, height_chattering);
        }
        if($("#container_standing").highcharts()){
            var height_standing= $("#container_standing").height(); //获取窗体宽度
            $("#container_standing").highcharts().setSize(0.8*width, height_standing);
        }
        if($("#container_distribution_area").highcharts()){
            var height_standing= $("#container_distribution_area").height(); //获取窗体宽度
            $("#container_distribution_area").highcharts().setSize(0.8*width, height_standing);
        }
        if($("#container_distribution_time").highcharts()){
            var height_standing= $("#container_distribution_time").height(); //获取窗体宽度
            $("#container_distribution_time").highcharts().setSize(0.8*width, height_standing);
        }
        if($("#container_distribution_priority_area").highcharts()){
            var height_standing= $("#container_distribution_priority_area").height(); //获取窗体宽度
            $("#container_distribution_priority_area").highcharts().setSize(0.8*width, height_standing);
        }
        if($("#container_distribution_priority_all").highcharts()){
            var height_standing= $("#container_distribution_priority_all").height(); //获取窗体宽度
            $("#container_distribution_priority_all").highcharts().setSize(0.8*width, height_standing);
        }
        if($("#container_Top20").highcharts()){
            var height_standing= $("#container_Top20").height(); //获取窗体宽度
            $("#container_Top20").highcharts().setSize(0.8*width, height_standing);
        }
    }
    window.onload=function(){
        window.onresize = adjust;
        adjust();
    }
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
    if (/(y+)/.test(fmt)) 
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o){
        if (new RegExp("(" + k + ")").test(fmt)) 
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    }
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
        endTime: $('#endTime').val(),
        dbSource:dbSource
    });
    rightIframe.$('#dg').datagrid('load', {
        startTime: $('#startTime').val(),
        endTime: $('#endTime').val(),
        dbSource:dbSource
    });
}


</script>

</body>    
</html>
