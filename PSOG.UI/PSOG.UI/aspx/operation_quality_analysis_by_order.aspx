<%@ Page Language="C#" AutoEventWireup="true" CodeFile="operation_quality_analysis_by_order.aspx.cs" Inherits="operation_quality_analysis_by_order" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    
    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
    <title>操作质量排行</title>
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
                $( "#container_OQITop" ).tabs();
                $( "#container_MeanTop" ).tabs();
                $( "#container_VarianceTop" ).tabs();
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
                    时间范围：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" />                     ---
                    <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" /> <br /><br />
                    <!-- 班组选择：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <input type="radio" name="shift" value="全部" checked="checked"/>全部
                              <input type="radio" name="shift" value="一班"/>一班
                              <input type="radio" name="shift" value="二班"/>二班<br /><br /> -->
                    指标查询：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="OQITop" style=" border:none" title="操作质量指数排行Top10。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-chattering',size:'large',iconAlign:'top'"><b>操作质量指数</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="MeanTop" style=" border:none" title="均值偏离度排行Top10。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-chattering',size:'large',iconAlign:'top'"><b>均值偏离度</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <div style="padding:5px 0;display:inline"><a id="VarianceTop" style=" border:none" title="数据集中度排行Top10。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-chattering',size:'large',iconAlign:'top'"><b>数据集中度</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              
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
                
                    <div id="container_OQITop" style="height: 500px; margin: 0 auto; display:block">
					    <ul>
                            <li><a href="#container_OQITop_bad">最差Top10</a></li>
                            <li><a href="#container_OQITop_good">最好Top10</a></li>
                        </ul>
                        <div id="container_OQITop_good" style="height: 400px; margin: 0 auto;"></div>
                        <div id="container_OQITop_bad" style="height: 400px; margin: 0 auto;"></div>
					</div>
					
					<div id="container_MeanTop" style="height: 500px; margin: 0 auto; display:none">
					    <ul>
                            <li><a href="#container_MeanTop_bad">最差Top10</a></li>
                            <li><a href="#container_MeanTop_good">最好Top10</a></li>
                        </ul>
                        <div id="container_MeanTop_good" style="height: 400px; margin: 0 auto;"></div>
                        <div id="container_MeanTop_bad" style="height: 400px; margin: 0 auto;"></div>
					</div>
					
					<div id="container_VarianceTop" style="height: 500px; margin: 0 auto; display:none">
					    <ul>
                            <li><a href="#container_VarianceTop_bad">最差Top10</a></li>
                            <li><a href="#container_VarianceTop_good">最好Top10</a></li>
                        </ul>
                        <div id="container_VarianceTop_good" style="height: 400px; margin: 0 auto;"></div>
                        <div id="container_VarianceTop_bad" style="height: 400px; margin: 0 auto;"></div>
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
        var width_temp = 0;  //用于固定tab页的宽度
        var flag = 0; 
        
        show_OQITop();
        
        $('#OQITop').click(function (){ //点击操作质量指数排行
            
            $('#container_OQITop').show();
            $('#container_MeanTop').hide();
            $('#container_VarianceTop').hide();
            
            show_OQITop();

        });
        
        $('#MeanTop').click(function (){ //点击均值偏离度排行按钮
            
            $('#container_OQITop').hide();
            $('#container_MeanTop').show();
            $('#container_VarianceTop').hide();
            
            show_MeanTop();

        });
        
        $('#VarianceTop').click(function (){ //点击数据集中度排行按钮
            
            $('#container_OQITop').hide();
            $('#container_MeanTop').hide();
            $('#container_VarianceTop').show();
            
            show_VarianceTop();

        });
        
        function show_OQITop(){   //执行操作质量指数排行top10功能
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
                width_temp = document.getElementById("container_OQITop").offsetWidth;
                flag = 1;    
            }
            
            $('#container_OQITop_good').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数最好排行Top 10</span> <img id="tip_chattering" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
	            },
	            subtitle: {
                    text: sub_title
                },
	            xAxis: {
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
                    title: {
                        text: '操作质量指数'
                    }
                },
	            tooltip: {
		            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y} </b></td></tr>',
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
                    name: '操作质量指数'
//                    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1]
                }]
                
            });
            
            $('#container_OQITop_bad').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">操作质量指数最差排行Top 10</span> <img id="tip_OQITop" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
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
                    name: '操作质量指数'
//                    data: [19.9, 31.5, 16.4, 29.2, 44.0, 76.0, 35.6, 48.5, 16.4, 94.1]
                }]
                
            });
            
            var chart_bad = $('#container_OQITop_bad').highcharts();
            chart_bad.showLoading('正在加载数据...');
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_order.ashx?id=1&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var array_HI = [];
                    var categories_HI = [];
                    var array_LO = [];
                    var categories_LO = [];
                    var flag = 0;
                    for(var o in data){
                        if(data[o].name == "flag_HI2LO"){
                            flag = 1;
                            continue;
                        }
                        if(flag == 0){
                            categories_HI.push([data[o].name]);
                            array_HI.push([data[o].value]);
                        }
                        if(flag == 1){
                            categories_LO.push([data[o].name]);
                            array_LO.push([data[o].value]);
                        } 
                    } 
                    var chart_good = $('#container_OQITop_good').highcharts();
                    chart_good.xAxis[0].setCategories(categories_HI);
                    chart_good.series[0].setData(array_HI);
                    chart_good.setTitle(null, { text: "装置: "+plant+", 时间: "+startTime+" --- "+ endTime});
                    
                    chart_bad.xAxis[0].setCategories(categories_LO);
                    chart_bad.series[0].setData(array_LO);
                    chart_bad.hideLoading();
                    chart_bad.setTitle(null, { text: "装置: "+plant+", 时间: "+startTime+" --- "+ endTime});
                }
            });
            
            $("#tip_OQITop").qtip({
                content: {
                    text: "<b>操作质量指数排行top10。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
        }
        
        function show_MeanTop(){   //执行均值偏离度排行功能
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
            
            $('#container_MeanTop_good').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">均值偏离度最好排行Top 10</span> <img id="tip_MeanTop" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
                    title: {
                        text: '均值偏离度'
                    }
                },
	            tooltip: {
		            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y} </b></td></tr>',
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
                    name: '均值偏离度'
//                    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1]
                }]
                
            });
            
            $('#container_MeanTop_bad').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">均值偏离度最差排行Top 10</span> <img id="tip_MeanTop" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
                    title: {
                        text: '均值偏离度'
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
                    name: '均值偏离度'
//                    data: [19.9, 31.5, 16.4, 29.2, 44.0, 76.0, 35.6, 48.5, 16.4, 94.1]
                }]
                
            });
            
            var chart_bad = $('#container_MeanTop_bad').highcharts();
            chart_bad.showLoading('正在加载数据...');
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_order.ashx?id=2&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var array_HI = [];
                    var categories_HI = [];
                    var array_LO = [];
                    var categories_LO = [];
                    var flag = 0;
                    for(var o in data){
                        if(data[o].name == "flag_HI2LO"){
                            flag = 1;
                            continue;
                        }
                        if(flag == 0){
                            categories_HI.push([data[o].name]);
                            array_HI.push([data[o].value]);
                        }
                        if(flag == 1){
                            categories_LO.push([data[o].name]);
                            array_LO.push([data[o].value]);
                        } 
                    } 
                    var chart_good = $('#container_MeanTop_good').highcharts();
                    chart_good.xAxis[0].setCategories(categories_HI);
                    chart_good.series[0].setData(array_HI);
                    
                    chart_bad.xAxis[0].setCategories(categories_LO);
                    chart_bad.series[0].setData(array_LO);
                    chart_bad.hideLoading();
                }
            });
            
            $("#tip_MeanTop").qtip({
                content: {
                    text: "<b>均值偏离度排行top10。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
                }
            });
        }
        
        
        function show_VarianceTop(){   //执行数据集中度排行功能
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
            
            $('#container_VarianceTop_good').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">数据集中度最好排行Top 10</span> <img id="tip_VarianceTop" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
                    title: {
                        text: '数据集中度'
                    }
                },
	            tooltip: {
		            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y} </b></td></tr>',
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
                    name: '数据集中度'
//                    data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1]
                }]
                
            });
            
            $('#container_VarianceTop_bad').highcharts({
                chart: {
		            type: 'bar',
			        width: width_temp
	            },
	            title: {
		            useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">数据集中度最差排行Top 10</span> <img id="tip_VarianceTop" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
//	                categories:['FI101', 'TI102','PI101','LI101','FI102','FI103','TI101','FI107','FI121','FI301']
	            },
                yAxis: {
                    min: 0,
                    title: {
                        text: '数据集中度'
                    }
                },
	            tooltip: {
		            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y} </b></td></tr>',
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
                    name: '数据集中度'
//                    data: [19.9, 31.5, 16.4, 29.2, 44.0, 76.0, 35.6, 48.5, 16.4, 94.1]
                }]
                
            });
            
            var chart_bad = $('#container_VarianceTop_bad').highcharts();
            chart_bad.showLoading('正在加载数据...');
            $.ajax({
                type: "post",
                url: 'operation_quality_analysis_by_order.ashx?id=3&plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
                data: null,
                dataType: "json",
                success: function(data){
                    var array_HI = [];
                    var categories_HI = [];
                    var array_LO = [];
                    var categories_LO = [];
                    var flag = 0;
                    for(var o in data){
                        if(data[o].name == "flag_HI2LO"){
                            flag = 1;
                            continue;
                        }
                        if(flag == 0){
                            categories_HI.push([data[o].name]);
                            array_HI.push([data[o].value]);
                        }
                        if(flag == 1){
                            categories_LO.push([data[o].name]);
                            array_LO.push([data[o].value]);
                        } 
                    } 
                    var chart_good = $('#container_VarianceTop_good').highcharts();
                    chart_good.xAxis[0].setCategories(categories_HI);
                    chart_good.series[0].setData(array_HI);
                    
                    chart_bad.xAxis[0].setCategories(categories_LO);
                    chart_bad.series[0].setData(array_LO);
                    chart_bad.hideLoading();
                }
            });
            
            $("#tip_VarianceTop").qtip({
                content: {
                    text: "<b>数据集中度排行top10。"
                  , title: "提示信息"
                },
                style: {
                    classes: 'qtip-light'
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
