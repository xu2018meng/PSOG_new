<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis_by_order_standing_popup.aspx.cs" Inherits="alarm_analysis_by_order_standing_popup" %>

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
    <title>持续报警排行</title>
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
                    colors: ["#ff0000", "#FF8000", "#F9f900", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee", "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"]
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
                          <div style="padding:5px 0;display:inline"><a id="Standing" style=" border:none" title="报警持续时间排行。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-chattering',size:'large',iconAlign:'top'"><b>持续时间</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          
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
					
					<div id="container_standing" style=" height: 400px; margin: 0 auto;"></div>
					<div id="Div_standing"  region="center" style="padding: 5px; height: 300px;" border="false">
                        <table id="dg_standing" title="报警持续时间Top 20统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="false" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true" striped="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'tagname',width:80" align="left">位号</th>
                                    <th data-options="field:'description',width:200" align="left">描述</th>
                                    <th data-options="field:'area',width:150" align="left">工段</th>
                                    <th data-options="field:'startTime',width:150" align="left">报警开始时间</th>
                                    <th data-options="field:'endTime',width:150" align="left">报警结束时间</th>
									<th data-options="field:'alarmInterval',width:150" align="left">报警持续时间(分钟)</th>
									<th data-options="field:'trend_field',width:50" align="center">趋势</th>
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
    
    var dbSource = '<%=dbSource %>';
    
    function initColor_standing() {
        /* 设置趋势 */
        
        $('#Div_standing .datagrid-body tr td[field="trend_field"]').each(function () {
            var id = $(this).parent().children().eq(0).children().text();
            $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:34px; height:24px;' onclick='makeOk('" + id + "')' ></input>");        
        });
       
    }
    
    function showHistoryLine(tableName){
        if(3 != getBrowserType()){
            window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random()+"&startTime="+$("#startTime").val()+"&endTime="+$("#endTime").val(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
            window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random()+"&startTime="+$("#startTime").val()+"&endTime="+$("#endTime").val(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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
        //show_distribution_top20();
        
        $('#dg_standing').datagrid({
           url:'alarm_analysis_by_order_standing.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&dbSource='+dbSource,
           onClickCell:function(rowIndex, field, value){
                if("trend_field" == field){
                    $('#Div_standing .datagrid-body tr td[field="trend_field"]').eq(rowIndex).each(function () {
                        var items = $(this).parent().children().eq(0).children().text();
                        showHistoryLine(items);     //报表事件
                    });
                }
            },
           onLoadSuccess:function(){
                var startTime = $("#startTime").val();
                var endTime = $("#endTime").val();

                if(startTime > endTime){
                    alert("查询开始时间不能大于截止时间！");
                    return;
                }
                
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
                
                var chart = $('#container_standing').highcharts();
                chart.showLoading('正在加载数据...');
                
                var array = [];
                var categories = [];
                var areaTemp = "";
                var rows = $('#dg_standing').datagrid('getRows');
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
                }
                if(array.length == 0){
                    categories.push("装置");
                    array.push(0);
                }
                
                chart.xAxis[0].setCategories(categories);
                chart.series[0].setData(array);
                chart.hideLoading();
                
                $("#tip_standing").qtip({
                    content: {
                        text: "<b>持续报警分布：</b>在指定时间范围内，对装置各工段中持续报警个数的统计。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
                
                initColor_standing();
           }
        });
        
        function show_distribution_standing(){   //执行报警空间分布功能
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
        
        $('#Standing').click(function (){ //点击Top20报警按钮
            show_distribution_standing();

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
