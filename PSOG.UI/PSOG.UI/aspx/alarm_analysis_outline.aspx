<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis_outline.aspx.cs" Inherits="alarm_analysis_outline" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>

    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>报警概述</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
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
		    var width_temp = 0;
            var flag = 0;
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
            $(function () {
                $( "#container_level_trend" ).tabs();
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#f45b5b", "#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
//                    chart: {
//                        borderWidth: 1
//                    }
                });
                
                $('#container').highcharts({

                    chart: {
//                        type: 'arearange'
//                        zoomType: 'x'
                    },

                    title: {
                        useHTML: true,
                        text: '报警系统等级评估'
                    },
                    
                    subtitle: {
//                        text: '装置：常减压，时间：最近8小时，班组：全部'
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
                            text: '最大报警率(报警数/每10分钟)'
                        }
                    },

                    yAxis: {
			            type: 'logarithmic',
			            minorTickInterval: 1,
			            max: 1000,
			            min: 0.1,
                        title: {
                            text: '平均报警率(报警数/每10分钟)'
                        }
                    },

//                        tooltip: {
//                            enabled: true
//                        },

                    legend: {
                        enabled: true,
                        layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'middle'
                    },
					
					plotOptions: {
						scatter: {
							dataLabels: {
								enabled: true,
								format: '{point.name}'
							}
						}
					},
					
					exporting: {
                        // url:"http://localhost:8080/ExportingServer_java_Struts2/export/index"
                        enable: false
                    },

                    series: [{
                        type: 'arearange',
                        name: '1-可预测的',
			            color: 'rgb(44, 173, 55)',// 0,255,0,0.5
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
				            color: 'rgb(39, 141, 205)',// 0,0,255,0.5
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
				            color: 'rgb(240, 229, 53)',//255,255,0,0.5
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
				            color: 'rgb(237, 144, 40)',// 255,128,0,0.5
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
				            color: 'rgb(217, 35, 31)',// 227,23,13,0.5
							tooltip: {
								enabled: true,
								useHTML: true,
								headerFormat: '<span>',
								pointFormat: '{series.name}:' + '<b>操作人员无法准确的辨认和处理报警信息。</b>',
								footerFormat: '</span>'
//									formatter: function () {
//                                        return 'The value for <b>' + this.x +
//                                            '</b> is <b>' + this.y + '</b>';
//                                    }
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
			                    fillColor:'#000000',// '#7cb5ec'
			                    symbol:'triangle',
			                    radius: 4
			                    }
			            }
//			            {
//			                type:'scatter',
//			                name:'等级名称',
//							showInLegend: false,
//			                dataLabels: {
//                                enabled: true,
//                                useHTML: true,
//                                format: '<span style="font-size: large; color:Black; font-weight:bold">{point.name}</span>'
//                            },
//                            data: [{
//	                            'name': '1-可预测的',
//	                            x: 0.5,
//	                            y: 0.2
//                            }, {
//	                            'name': '2-鲁棒的',
//	                            x: 40,
//	                            y: 1
//                            }, {
//	                            'name': '3-稳定的',
//	                            x: 400,
//	                            y: 1
//                            }, {
//	                            'name': '4-反应性的',
//	                            x: 4000,
//	                            y: 10
//                            }, {
//	                            'name': '5-超负荷的',
//	                            x: 1000,
//	                            y: 200
//                            }],
//                            tooltip: {
//								enabled: false
//							},
//			                marker:{
//			                    enabled: false
//			                    }
//			            }
			            ]
                });
                if(flag == 0){
                    width_temp = document.getElementById("container_level_trend").offsetWidth;
                    flag = 1;    
                }

            });
		</script>
    <style type="text/css">
        #qryDiv {padding-left:15px; padding-top:5px;}
        body {font-size:12px;font-family: 微软雅黑;}
    </style>
</head>
<body class="easyui-layout" style="width:100%; height:100%;">
    <form id="form1" action="">
    <div style="padding-bottom: 5px;overflow-y:hidden;" id="qryDiv"  region="north"  border="false">
        <table class="tblSearch" style="padding-left:10%">
            <tr style="height:auto;">                        
                <td class="leftTdSearch"  style="vertical-align:middle; text-align:left;font-weight:bold;font-size:18px;" nowrap="nowrap"> 
                   <div style="float:left;padding-top:5px;"><img src="../resource/img/timeRange.png"  /></div>
                   <div style="float:left;font-weight:bold;font-size:18px;padding-top:3px;">&nbsp;时间范围&nbsp;&nbsp;&nbsp;</div>
                    
                    
                    <input id="startTime" type="text" style="font-size:12px;" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" /> 
                    ---
                    <input id="endTime" type="text" style="font-size:12px;" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" />
                    <div style="float:right;font-weight:bold;font-size:18px;padding-top:3px;">&nbsp;&nbsp;&nbsp;数据来源&nbsp;
                      <select id="dbSource" name="dbSource"  style="width:120px; height: 24px;padding-top:3px;">
                       <option value="0">实时数据库</option>
                       <option value="1">DCS报警日志</option>
                      </select>
                        
                    </div>
                    
                <br /><br />
                   <div style="float:left;padding-top:10px;"><img src="../resource/img/indexQuery.png" style="vertical-align:middle;" /></div>
                   <div style="float:left;font-weight:bold;font-size:18px;padding-top:9px;">   &nbsp;指标查询&nbsp;&nbsp;&nbsp;</div>
                 
                          <div style="padding:5px 0;display:inline;">
                            <a id="LevelAssess" style=" border:none" title="报警系统等级评估。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-level-new',size:'large',iconAlign:'left'"><b>等级评估</b></a>
                           
                          </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <div style="padding:5px 0;display:inline">
                              <a id="LevelTrend" style=" border:none" title="报警系统等级趋势变化情况。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-trend-new',size:'large',iconAlign:'left'"><b>等级趋势</b></a>
                          </div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                          
                </td>
            </tr>
        </table> 
        <hr style="width:95%; color:#987cb9; size:5" />
    </div>
    
    <div id="gridDiv" region="center"  style="padding: 5px; height: 100%; overflow-y:scroll; z-index:10; " border="false">
        
                    <div id="container"  style=" height: 400px; width:80%; margin: 0 auto"></div>
					
					<div id="container_level_trend"  style="display:none;width:80%;margin: 0 auto">
                      <ul>
                        <li><a id="level_trend_name" href="#container_level_trend_1"></a></li>
                        <!-- <li><a href="#container_level_trend_2">常压塔</a></li> -->
                      </ul>
                      <div id="container_level_trend_1" region="center" style="height: 400px; margin: 0 auto;"></div>
                      <!-- <div id="container_level_trend_2" style="height: 400px; margin: 0 auto; "></div> -->
                    </div>

                    <div id="Div1"   style="padding: 5px; width:80%; padding-left: 10%; min-height: 380px; z-index:-1;" border="false">
                        <table id="dg" title="报警系统等级评估" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="id" rownumbers="true" fitColumns="false" singleSelect="true" nowrap="false" striped="true">
                            <thead>
                                <tr>
                                    <!-- <th data-options="field:'area'" style="width:10%" align="left" rowspan="2">工段</th>
                                    <th colspan="2">平均报警率</th>
                                    <th colspan="2">最大报警率</th>
                                    <th colspan="2">扰动率</th>
                                    <th colspan="2">等级评估</th>
                                    </tr><tr>
                                    <th data-options="field:'averagerate',formatter:formatAverage" style="width:11%" align="left">当前值</th>
                                    <th data-options="field:'averagerate_goal'" style="width:11%" align="left">目标值</th>
                                    <th data-options="field:'maxrate',formatter:formatMax" style="width:11%" align="left">当前值</th>
                                    <th data-options="field:'maxrate_goal'" style="width:11%" align="left">目标值</th>
                                    <th data-options="field:'disturbrate',formatter:formatDisturbance" style="width:11%" align="left">当前值</th>
                                    <th data-options="field:'disturbrate_goal'" style="width:11%" align="left">目标值</th>
                                    <th data-options="field:'level',formatter:formatLevel" style="width:11%" align="left">当前等级</th>
                                    <th data-options="field:'level_goal'" style="width:15%" align="left">目标等级</th> -->
                                    
                                    <th data-options="field:'index_name'" style="width:20%" align="center">KPI</th>
                                    <th data-options="field:'plant_num',styler:cellStyler,formatter:formatValue" style="width:25%" align="center">当前值</th>
                                    <th data-options="field:'index_goal'" style="width:25%" align="center">目标值</th>
                                    <th data-options="field:'remark'" style="width:29%; font-size:medium; font-weight:bold" align="center">备注</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
              
    </div> 
    
    </form>
    <script type="text/javascript">
    
    var dbSource = "0";
    
	function formatValue(val,row){        
	    var rowIndex = $('#dg').datagrid('getRowIndex', row);
	    //报警系统等级
		if (rowIndex == 0 && val != '可预测的'){
			return val+"（偏低）";
		}
		//平均报警率
		if (rowIndex == 1 && parseFloat(val) > 1.0 && parseFloat(val) < 10.0){
			return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 1 && parseFloat(val) >= 10.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 1 && parseFloat(val) <= 1.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"</a>";
		}
		//最大报警率
		if (rowIndex == 2 && parseFloat(val) > 10.0 && parseFloat(val) < 30.0){
			return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 2 && parseFloat(val) >= 30.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 2 && parseFloat(val) <= 10.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"</a>";
		}
		//扰动率
		if (rowIndex == 3 && parseFloat(val) > 5.0 && parseFloat(val) < 10.0){
			return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 3 && parseFloat(val) >= 10.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 3 && parseFloat(val) <= 5.0){
		    return "<a href='javascript:void(0);' onclick='showTimeDetail();'>"+val+"</a>";
		}
		//优先级分布
		var HI = parseFloat(val.split("为")[1]);
		var ME = parseFloat(val.split("为")[2]);
		var LO = parseFloat(val.split("为")[3]);
		if (rowIndex == 4){
		    if(HI > 10){
		        return "<a href='javascript:void(0);' onclick='showPriorityDetail();'>"+val+"（报警优先级分布不合理）</a>";
		    }else{
		        return "<a href='javascript:void(0);' onclick='showPriorityDetail();'>"+val+"</a>";
		    }
		}
		//Top10报警次数百分比
		if (rowIndex == 5 && parseFloat(val) > 5.0 && parseFloat(val) < 50.0){
			return "<a href='javascript:void(0);' onclick='showTop20Detail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 5 && parseFloat(val) >= 50.0){
		    return "<a href='javascript:void(0);' onclick='showTop20Detail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 5 && parseFloat(val) <= 5.0){
		    return "<a href='javascript:void(0);' onclick='showTop20Detail();'>"+val+"</a>";
		}
		//报警持续时间超8小时个数
		if (rowIndex == 6 && parseFloat(val) > 5.0 && parseFloat(val) < 20.0){
			return "<a href='javascript:void(0);' onclick='showStandingDetail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 6 && parseFloat(val) >= 20.0){
		    return "<a href='javascript:void(0);' onclick='showStandingDetail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 6 && parseFloat(val) <= 5.0){
		    return "<a href='javascript:void(0);' onclick='showStandingDetail();'>"+val+"</a>";
		}
		//重复报警个数
		if (rowIndex == 7 && parseFloat(val) > 0.0 && parseFloat(val) < 10.0){
			return "<a href='javascript:void(0);' onclick='showChatteringDetail();'>"+val+"（偏高）</a>";
		}else if(rowIndex == 7 && parseFloat(val) >= 10.0){
		    return "<a href='javascript:void(0);' onclick='showChatteringDetail();'>"+val+"（过高）</a>";
		}else if(rowIndex == 7 && parseFloat(val) == 0.0){
		    return "<a href='javascript:void(0);' onclick='showChatteringDetail();'>"+val+"</a>";
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
	
	function showPriorityDetail(){
	    var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_analysis_by_distribution_priority_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,window, "dialogHeight=750px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_analysis_by_distribution_priority_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,"newWindow", "Height=750px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
        }
    }
    function showTimeDetail(){
	    var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_analysis_by_distribution_time_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,window, "dialogHeight=750px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_analysis_by_distribution_time_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,"newWindow", "Height=750px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
        }
    }
    function showTop20Detail(){
	    var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_analysis_by_order_top20_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,window, "dialogHeight=750px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_analysis_by_order_top20_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,"newWindow", "Height=750px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
        }
    }
    function showChatteringDetail(){
	    var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_analysis_by_order_chattering_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,window, "dialogHeight=750px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_analysis_by_order_chattering_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,"newWindow", "Height=750px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
        }
    }
    function showStandingDetail(){
	    var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_analysis_by_order_standing_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,window, "dialogHeight=750px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_analysis_by_order_standing_popup.aspx?plantId=<%=plantId %>&startTime="+startTime+"&endTime="+endTime+"&dbSource="+dbSource,"newWindow", "Height=750px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
        }
    }
    function getBrowserType() {
        var ua = navigator.userAgent.toLowerCase();

        if(ua.match(/msie ([\d.]+)/))return 1;

        if(ua.match(/firefox\/([\d.]+)/))return 2;

        if(ua.match(/chrome\/([\d.]+)/))return 3;

        if(ua.match(/opera.([\d.]+)/))return 4;

        if(ua.match(/version\/([\d.]+).*safari/))return 5;

        return 0;
    }
    
    $(function(){      
        $('#dg').datagrid({
            url:'alarm_analysis_outline_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&id=1&dbSource='+dbSource,//id=1表示一起计算全部8个指标
            onLoadSuccess:function(){
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
                
                document.getElementById('level_trend_name').innerHTML = plant;
                var chart = $('#container').highcharts();
                //chart.showLoading('正在加载数据...');
                
                var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();
                
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
            }
        });
        $('#LevelAssess').click(function (){  //点击等级评估按钮
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            var chart = $('#container').highcharts();
            chart.showLoading('正在加载数据...');
            
            $('#container').show();
            $('#Div1').show();
            $('#container_level_trend').hide();
            dbSource = $("#dbSource").val();
            
            $('#dg').datagrid('load', {
                startTime: $('#startTime').val(),
                endTime: $('#endTime').val(),
                dbSource:dbSource
            });
        });
        
        $('#LevelTrend').click(function (){   //点击等级趋势变化按钮
            //通过Ajax异步获取数据
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            $('#container_level_trend').show();
            $('#container').hide();
            $('#Div1').hide();
            
            var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime;
            
           dbSource = $("#dbSource").val();
            
            $('#container_level_trend_1').highcharts({
                chart: {
                    zoomType: 'xy',
                    width: width_temp
                },
                title: {
			        useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警系统等级趋势变化</span> <img id="tip_level_trend" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
		        },
		        subtitle: {
                    text: sub_title
                },
                xAxis: {
                    labels: {
                        rotation: -45
                    }
                },
                navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
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
//                        format: '{value}',
                        formatter: function() {
                            if(this.value == 1){
                                return this.value+'-可预测的';
                            }
                            if(this.value == 2){
                                return this.value+'-鲁棒的';
                            }
                            if(this.value == 3){
                                return this.value+'-稳定的';
                            }
                            if(this.value == 4){
                                return this.value+'-反应性的';
                            }
                            if(this.value == 5){
                                return this.value+'-超负荷的';
                            }
                        },
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
//                    data: [5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 2, 3],
                    tooltip: {
                        valueSuffix: ' '
                    }

                }, {
                    name: '最大报警率',
                    type: 'spline',
                    yAxis: 2,
//                    data: [50, 16, 101, 35.5, 442.3, 69.5, 79.6, 60.2, 53.1, 36.9, 28.2, 26.7],
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
//                    data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],
                    tooltip: {
                        valueSuffix: ' '
                    }
                }]
            });
            
            var chart = $('#container_level_trend_1').highcharts();
            chart.showLoading('正在加载数据...');
            
            $.ajax({
                type: "post",
                url: 'alarm_analysis_outline_level_trend.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime+"&dbSource="+dbSource,
                data: null,
                dataType: "json",
                success: function(data){
                    var array_level = [];  //报警等级
                    var array_average = [];  //平均报警
                    var array_max = [];    //最大报警
                    var categories = [];
                    for(var o in data){
                        array_level.push(data[o].level);
                        array_average.push(Math.round(data[o].averagerate*100)/100);
                        array_max.push(data[o].maxrate);
                        categories.push(data[o].startTime);
                    } 
                    var chart = $('#container_level_trend_1').highcharts();
                    chart.xAxis[0].setCategories(categories);
                    chart.series[0].setData(array_level);
                    chart.series[1].setData(array_max);
                    chart.series[2].setData(array_average);
                    chart.hideLoading();
                }
            });
            
            
            $("#tip_level_trend").qtip({
                content: {
                    text: "<b>报警系统等级趋势变化：</b>报警系统等级应逐渐向“可预测的”靠近。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
        });
    });
    
    //监听窗口大小改变
    function adjust(obj){
        var width= document.body.clientWidth; //获取窗体宽度
        width_temp = 0.75*width;
        if($("#container").highcharts()){
            var height_top20= $("#container").height(); //获取窗体宽度
            $("#container").highcharts().setSize(0.8*width, height_top20);
        }
        if($("#container_level_trend_1").highcharts()){
            var height_top20= $("#container_level_trend_1").height(); //获取窗体宽度
            $("#container_level_trend_1").highcharts().setSize(0.75*width, height_top20);
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
        endTime: $('#endTime').val(),
        dbSource:dbSource
    });
    rightIframe.$('#dg').datagrid('load', {
        startTime: $('#startTime').val(),
        endTime: $('#endTime').val(),
        dbSource:dbSource
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
    
    var url = "./alarm_history_exp.ashx?plantId=<%=plantId %>&startTime="+startTime + "&endTime=" + endTime+"&dbSource="+dbSource;
    //window.open(url);
    document.forms["form1"].action = url;
    document.forms["form1"].method = "GET";
    document.forms["form1"].submit();
    document.forms["form1"].target = "";
}


</script>

</body>    
</html>
