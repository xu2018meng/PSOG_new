<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_analysis_by_order_top20_popup.aspx.cs" Inherits="alarm_analysis_by_order_top20_popup" %>

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
    <title>报警次数排行</title>
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
                          <div style="padding:5px 0;display:inline"><a id="Top20" style=" border:none" title="报警次数排行Top20。" class="easyui-linkbutton easyui-tooltip" data-options="iconCls:'icon-chattering',size:'large',iconAlign:'top'"><b>报警次数</b></a></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          
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
					
					<div id="container_Top20" style=" height: 600px; margin: 0 auto;"></div>
					<div id="Div_top20"  region="center" style="padding: 5px; height: 300px;" border="false">
                        <table id="dg_top20" title="报警次数Top 20统计" class="easyui-datagrid"  style="width:100%;height:100%;" fit="true"
                                 idField="zhStartTime" pagination="false" pagesize="10" rownumbers="true" fitColumns="true" singleSelect="true" nowrap="false" striped="true">
                            <thead>
                                <tr>                    
                                    <th data-options="field:'tagname',width:80" align="left">位号</th>
                                    <th data-options="field:'description',width:200" align="left">描述</th>
                                    <th data-options="field:'area',width:90" align="left">工段</th>
                                    <th data-options="field:'count',width:80" align="left">报警次数</th>
									<th data-options="field:'percent',width:80" align="left">占总数%</th>
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
    
    function initColor() {
        /* 设置趋势 */
        $('#Div_top20 .datagrid-body tr td[field="trend_field"]').each(function () {
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
        
        $('#dg_top20').datagrid({
           url:'alarm_analysis_by_order_top20.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&dbSource='+dbSource,
           onClickCell:function(rowIndex, field, value){
                if("trend_field" == field){
                    $('#Div_top20 .datagrid-body tr td[field="trend_field"]').eq(rowIndex).each(function () {
                        var items = $(this).parent().children().eq(0).children().text();
                        showHistoryLine(items);     //报表事件
                    });
                }
            },
           onLoadSuccess:function(){                  
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
                
                //var sub_title = "装置: "+plant+", 时间: "+startTime+" --- "+ endTime+", 班组: "+shift.attr("value");
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
//                            format: '<span style="font-size: large; color:Black; font-weight:bold">{point.y}%</span>'
                        }
                    }]
                    
                });
                var chart = $('#container_Top20').highcharts();
                chart.showLoading('正在加载数据...');
                
                var array = [];
                var categories = [];
                var rows = $('#dg_top20').datagrid('getRows');
                if(rows.length == 0){
                    $('#container_Top20').hide();
                }else{
                    for(var i=0; i<rows.length; i++){
                        categories[i] = rows[i].tagname;
                        array.push([rows[i].count]);
                    }
                    var chart = $('#container_Top20').highcharts();
                    chart.xAxis[0].setCategories(categories);
                    chart.series[0].setData(array);
                    chart.hideLoading();
                }
                
                
                $("#tip_topN").qtip({
                    content: {
                        text: "<b>Top 20报警次数统计：</b>在指定时间范围内，统计装置中报警次数排名前20位的位号。"
                      , title: "提示信息"
                    },
                    style: {
                        classes: 'qtip-light'
                    }
                });
                
                initColor();
           }
        });
        
        function show_distribution_top20(){   //执行报警空间分布功能
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
        
        $('#Top20').click(function (){ //点击Top20报警按钮
            show_distribution_top20();

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
