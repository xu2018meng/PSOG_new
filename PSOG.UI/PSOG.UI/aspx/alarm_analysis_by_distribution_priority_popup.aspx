<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis_by_distribution_priority_popup.aspx.cs" Inherits="alarm_analysis_by_distribution_priority_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
       startTime = Request.QueryString["startTime"];
       endTime = Request.QueryString["endTime"];
       String dbSource = Request.QueryString["dbSource"];
        %>
    <title>报警优先级分布</title>
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
                $( "#container_distribution_time" ).tabs();
                $( "#container_distribution_area" ).tabs();
                $( "#container_distribution_priority" ).tabs();
                Highcharts.setOptions({  //更改主题颜色
                    colors: ["#ff0000", "#FF8000", "#F9f900", "#6699CC", "#99CC33", "#336633", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
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
        <table class="tblSearch" style="text-align:left">
            <tr style="height:auto;">                        
                <td class="leftTdSearch"  style="vertical-align:bottom; text-align:left;" nowrap="nowrap"> 
                时间范围：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input id="startTime" type="text" value='<%=startTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"   readonly="true" />                 ---
                <input id="endTime" type="text" value='<%=endTime %>' class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"   size="23"  readonly="true" /> 
                
               &nbsp;&nbsp;&nbsp;数据来源&nbsp;
                      <select id="dbSource" name="dbSource"  style="width:120px; height: 24px;padding-top:3px;">
                       <% if ("1".Equals(dbSource))
                          {%>
                          <option value="0">实时数据库</option>
                          <option value="1" selected>DCS报警日志</option>
                       <%}else{ %>
                          <option value="0" selected>实时数据库</option>
                          <option value="1">DCS报警日志</option>
                       <%} %>
                      </select>
                
                <br /><br />
                
                指标查询：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <div style="padding:5px 0;display:inline"><a id="distribution_priority" style=" border:none" title="报警优先级情况。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-distribution',size:'large',iconAlign:'top'"><b>优先级分布</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
					
					<div id="container_distribution_priority" style="height: 500px; margin: 0 auto;">
					    <ul>
                            <li><a href="#container_distribution_priority_all">整个装置分布</a></li>
                            <li><a href="#container_distribution_priority_area">各工段分布</a></li>
                        </ul>
					    <div id="container_distribution_priority_all" style=" height: 400px; margin: 0 auto;"></div>
					    <div id="container_distribution_priority_area" style=" height: 400px; margin: 0 auto;"></div>
					</div>
                    
                </td>
                <td  style="width:10%">
                </td>
            </tr>
        </table>
    </div>
    </form>
    <script type="text/javascript">
    var dbSource = '<%=dbSource %>';
    
    function showHistoryAlarm(starttime,endtime,dbSource){
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_history.aspx?plantId=<%=plantId %>&startTime=" + starttime + "&endTime=" + endtime,window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_history.aspx?plantId=<%=plantId %>&startTime=" + starttime + "&endTime=" + endtime,"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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
        var width_temp = 0;
        var flag = 0; 
        var startTime = '<%=startTime %>';
        var endTime = '<%=endTime %>';
		
		show_distribution_area();
		
		
		$('#distribution_priority').click(function (){   //报警参数等级分布
		    //数据通过ajax实现
		    startTime = $("#startTime").val();
            endTime = $("#endTime").val();

            if(startTime > endTime){
                alert("查询开始时间不能大于截止时间！");
                return;
            }
            
            dbSource = $("#dbSource").val();
            
		    show_distribution_area();
		});
		
		function show_distribution_area(){
            
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
            
            $('#container_distribution_priority_area').highcharts({
				chart: {
					type: 'column',
					width: width_temp
				},
				navigation: {
                    buttonOptions: {
                        enabled: false
                    }
                },
				title: {
					useHTML: true,
                    text: '<span style="font-size: large; color:Black; font-weight:bold">报警工段-优先级分布</span> <img id="tip_distribution_priority1" title="" src="../resource/img/question.png" style="cursor:pointer;"/>'
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
					plotShadow: false,
					width: width_temp
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
			
//			$.ajax({
//                type: "post",
//                url: 'alarm_analysis_by_distribution_priority.ashx?plantId=<%=plantId %>&startTime='+startTime+'&endTime='+endTime,
//                data: null,
//                dataType: "json",
//                success: function(data){
//                    var new_data = [];
//                    var categories = [];
//                    var arrayA = [];
//                    var arrayB = [];
//                    var arrayC = [];
//                    var arrayD = [];
//                    for(var o in data){
//                        new_data.push(['紧急', data[o].criticalPercent]);
//                        new_data.push(['高', data[o].highPercent]);
//                        new_data.push(['中', data[o].mediumPercent]);
//                        new_data.push(['低', data[o].lowPercent]);
//                        
//                        arrayA.push(data[o].criticalPercent);
//                        arrayB.push(data[o].highPercent);
//                        arrayC.push(data[o].mediumPercent);
//                        arrayD.push(data[o].lowPercent);
//                        
//                        categories.push(data[o].area);
//                    } 
//                    
//                    var chart_area = $('#container_distribution_priority_area').highcharts();
//                    chart_area.xAxis[0].setCategories(categories);
//                    chart_area.series[0].setData(arrayA);
//                    chart_area.series[1].setData(arrayB);
//                    chart_area.series[2].setData(arrayC);
//                    chart_area.series[3].setData(arrayD);
//                    
//                    var chart = $('#container_distribution_priority_all').highcharts();
//                    chart.series[0].setData(new_data);
//                }
//            });
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

var format = function(time, format){

    var t = new Date(time);

    var tf = function(i){return (i < 10 ? '0' : '') + i};

    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function(a){

        switch(a){

            case 'yyyy':

                return tf(t.getFullYear());

                break;

            case 'MM':

                return tf(t.getMonth() + 1);

                break;

            case 'mm':

                return tf(t.getMinutes());

                break;

            case 'dd':

                return tf(t.getDate());

                break;

            case 'HH':

                return tf(t.getHours());

                break;

            case 'ss':

                return tf(t.getSeconds());

                break;

        }

    })

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
