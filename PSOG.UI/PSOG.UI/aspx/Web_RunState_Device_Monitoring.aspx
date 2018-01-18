<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_RunState_Device_Monitoring.aspx.cs" Inherits="aspx_Web_RunState_Device_Monitoring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <% 
        String plantId = Request.QueryString["plantCode"];
       plantId = null == plantId ? "" : plantId;
       String modelId = Request.QueryString["modelId"];
       modelId = null == modelId ? "" : modelId;
       String deviceId = Request.QueryString["deviceId"];
       deviceId = null == deviceId ? "" : deviceId;
       DateTime dt = DateTime.Now;
       //DateTime dt = new DateTime(2014,12,30,21,2,40);
       string dtStr = dt.ToString();
       String endT = dt.ToString("yyyy-MM-dd HH:mm:ss");
       String startT = dt.AddMinutes(-5).ToString("yyyy-MM-dd HH:mm:ss");
       String tagStartT = dt.AddHours(-12).ToString("yyyy-MM-dd HH:mm:ss");
         %>
    <title>设备监测运行界面</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link href="../resource/css/button_style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
    <script type="text/javascript" src="../resource/js/modules/exporting.js"></script>
    <script type="text/javascript" src="../resource/js/modules/no-data-to-display.js"></script>
    <script type="text/javascript" src="../resource/js/highchart_dark.js"></script>
    <script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
    <script type="text/javascript">
        function stringToJson(stringValue)
        {
           eval("var theJsonValue = "+stringValue);
           return theJsonValue;
        }
        var tagsNameJson = stringToJson('<%=pcaModelJson %>');
        var flag = 0;
        var nowShowList = [];
        var tagStartTimeFlag = '<%=tagStartT %>';
        var tagEndTimeFlag = '<%=endT %>';
        
        $(function(){
	        
		});
    </script>
    <style type="text/css">
        #totalGraph .panel-body {
          background-color: #000000;
        }
        #totalGraph .datagrid-row-selected {
          background: #0052A3;
        }
        #totalGraph .datagrid-row-over,
        .datagrid-header td.datagrid-header-over {
          background: #777;
          color: #fff;
          cursor: default;
        }
        #totalGraph .datagrid-header {
          background-color: #000;
          border-color: #222;
          background: -webkit-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: -moz-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: -o-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: linear-gradient(to bottom,#4c4c4c 0,#3f3f3f 100%);
          background-repeat: repeat-x;
          filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#4c4c4c,endColorstr=#3f3f3f,GradientType=0);
        }
        #totalGraph .panel-header, .panel-body {
            border-color: #000000;
        }
        #totalGraph .datagrid-htable {
            color: white;
        }
        #totalGraph .datagrid-td-rownumber {
            background-color: #444;
            background: -webkit-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
            background: -moz-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
            background: -o-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
            background: linear-gradient(to bottom,#4c4c4c 0,#3f3f3f 100%);
            background-repeat: repeat-x;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#4c4c4c,endColorstr=#3f3f3f,GradientType=0);
        }
        #totalGraph .datagrid-cell-rownumber {
            color: #fff;
        }
    </style>
</head>        
<body style="text-align:center">

 <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:微软雅黑;">
 &nbsp;&nbsp;当前位置：<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new2.aspx?plantId=<%=plantId %>">主页</a>
 &nbsp;>&nbsp;<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new2_detail.aspx?plantId=<%=plantId %>&deviceId=<%=deviceId %>">工艺设备监测点信息</a>
 &nbsp;>&nbsp;运行状态监测
           </div>
           
           <%-- <div title="title1" style="padding:10px;text-align:center;" selected="true" src='web_show_img.aspx?fileId=a&plantId=<%=plantId %>'>
                <iframe id='ifram1' src=''  height="100%" width="100%" frameborder="0"></iframe>
            </div>--%>
             <div title="" style="padding:10px;text-align:center;   width:1200px; margin-left:auto; margin-right:auto" selected="true" >
              <!-- <iframe id='Iframe1'  height="100%"  width="100%";  src='web_show_ASImg.aspx?fileId=a&plantId=<%=plantId %>&name=<%=plantId %>' scrolling="no" frameborder="0" onload="this.height=this.contentWindow.document.documentElement.scrollHeight;"></iframe>-->
                 
                 <table style="width:100%; height:100%">
                   <%-- <tr>
                        <td style="border-width:1px; width:100%; text-align:left; font-size:large; background-color:#3399CC; height:40px">
                            异常：<span id="name1" style="font-size:large"></span>运行状态
                        </td>
                    </tr>--%>
                    <tr>
                        <td style="border-width:1px; width:100%; vertical-align:top">
                            <div id="fault_tab_page" class="easyui-tabs" style="width:1200px;">
                            <div title="状态监测" style="padding:10px">
                            <table id="totalGraph" style="width:100%;">
                                <tr>
                                    <td style="width:55%; vertical-align:top">
                                        <table style="width:100%">
                                            <tr style="height:380px; width:100%; vertical-align:top">
                                                <td style="background-color:Black; position:relative" align=left>
                                                    <div style="height:100px">
                                                        <div style="color:White; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:dotted; padding-bottom:5px">
                                                            监测对象：<span id="name3" style="color:White"></span>综合状态监测
                                                        </div>
                                                        <div style="color:White; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:dotted">
                                                            当前状态：<%=pcaState %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;开始时间：<%=pcaStateStartTime %>
                                                        </div>
                                                    </div>
                                                    <%--<iframe src="./fault_tree_models/fault_tree_model1.html" style="width:100%;height:240px;"></iframe>--%>
                                                    
                                                    <div style="height:280px">
                                                        <span style="color:White; font-weight:bold; font-size:large;">关键变量异常状态</span>
	                                                    <table id="dg_tags_monitoring_1"  class="easyui-datagrid"  style="width:100%;height:250px"  
                                                                url="device_monitoring_alarms_detail.ashx?plantId=<%=plantId %>&modelId=<%=modelId %>&startT=<%=startT %>&endT=<%=endT %>&id=1" idField="tableId" 
                                                                    pagination="false"   fit="true"
                                                                rownumbers="true" fitColumns="true" singleSelect="true" data-options="
                                                                    rowStyler: function(index,row){
	                                                                    return 'color:#ffffff;';
                                                                    }
                                                                ">
                                                            <thead>
                                                                <tr> 
                                                                    <th field="point" width="100" align="left">位号</th>
                                                                    <th field="desc" width="200" align="left">描述</th>
                                                                    <th field="transState" width="100" align="left">状态</th>
                                                                    <th field="val" width="60" align="left">当前值</th>
                                                                    <th field="unit" width="40" align="left">单位</th>    
                                                                </tr>
                                                            </thead>
                                                        </table>
                                                    </div>
                                                    
                                                    <div id="no_data" style="display:none; color:White; text-align:center; position:absolute; top:400px; left:100px">
                                                        没有相关记录！
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height:400px; width:100%; vertical-align:top">
                                                <td>
                                                    <iframe id="pcaCurve" height="450px" width="100%" src="" scrolling="no" frameborder="0"></iframe>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width:1%"></td>
                                    <td style="width:44%; background-color:Black; vertical-align:top">
                                        <table style="width:100%; ">
                                            <tr style="height:30px;">
                                                <td style="color:White; font-size:medium; font-weight:bold" align="center">
                                                    <span id="name2" style="font-size:medium; font-weight:bold"></span>综合状态监控变量趋势分析
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart1" style="height:180px;width:100%;text-align:center; ">
                                                        <div id="chartContainer1" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart2" style="height:180px;width:100%;text-align:center; ">
                                                        <div id="chartContainer2" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart3" style="height:180px;width:100%;text-align:center; ">
                                                        <div id="chartContainer3" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart4" style="height:180px;width:100%;text-align:center; ">
                                                        <div id="chartContainer4" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="vertical-align:middle">
                                                    <label style="color:White;">时间选择: </label>
                                                    &nbsp;
                                                    <input type="text" id="tagStartTime" name="tagStartTime" value="<%=tagStartT %>" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  readonly="readonly" />
                                                    &nbsp;&nbsp;—&nbsp; &nbsp; 
                                                    <input type="text" id="tagEndTime" name="tagEndTime" value="<%=endT %>" size="23" class="input_short Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" /><br /><br />
                                                    
                                                    <label id="messageTitle" style="color:White;">变量搜索：</label>
                                                    <input style="width:320px;height:40px;" id="tags" class="easyui-combobox" name="language" data-options="
                                                        method:'get',
				                                        valueField: 'id',
				                                        textField: 'tagName',
				                                        panelWidth: 320,
				                                        panelHeight: '200',
				                                        multiple:true,
				                                        formatter: formatItem
			                                        " /> 
			                                        <!--<a id="submitButton" style=" border:none" title="变量趋势查询" class="easyui-linkbutton easyui-tooltip" "><b>查询</b></a>-->
			                                        <input id="submitButton" type="button" style=" border:none" value="查询" /><br />
			                                        <label id="messageShow" style="color:Red; font-size:small; display:none">最多可查看4个变量。</label><br />
			                                        <label id="messageIsInList" style="color:Red; font-size:small; display:none">所选变量已显示。</label>
                                                </td>
                                            </tr> 
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            </div>
                            <div title="报告" style="padding:10px">
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">1、状态描述</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <span style="font-weight:bold">监测名称：</span><span id="name4"></span>综合状态监测 <br />
                                    <span style="font-weight:bold">当前状态：</span><%=pcaState %> <br />
                                    <span style="font-weight:bold">开始时间：</span><%=pcaStateStartTime %> <br />
                                    <span style="font-weight:bold">当前时间：</span><%=dtStr %> <br />
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">2、模型变量状态</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;width:780px;height:250px">
                                    <table id="dg_critical_tags"  class="easyui-datagrid"  style=""  
                                            url="device_monitoring_alarms_detail.ashx?plantId=<%=plantId %>&modelId=<%=modelId %>&startT=<%=startT %>&endT=<%=endT %>&id=2" idField="tableId" 
                                                pagination="false"   fit="true"
                                            rownumbers="true" fitColumns="true" singleSelect="true" >
                                        <thead>
                                            <tr> 
                                                <th field="point" width="100" align="left">位号</th>
                                                <th field="desc" width="200" align="left">描述</th>
                                                <th field="transState" width="100" align="left">状态</th>
                                                <th field="val" width="60" align="left">当前值</th>
                                                <th field="unit" width="40" align="left">单位</th> 
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">3、关键变量异常状态</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;width:780px;height:250px">
                                    <table id="dg_tags_monitoring_2"  class="easyui-datagrid"  style=""  
                                            url="device_monitoring_alarms_detail.ashx?plantId=<%=plantId %>&modelId=<%=modelId %>&startT=<%=startT %>&endT=<%=endT %>&id=1" idField="tableId" 
                                                pagination="false"   fit="true"
                                            rownumbers="true" fitColumns="true" singleSelect="true" >
                                        <thead>
                                            <tr> 
                                                <th field="point" width="100" align="left">位号</th>
                                                <th field="desc" width="200" align="left">描述</th>
                                                <th field="transState" width="100" align="left">状态</th>
                                                <th field="val" width="60" align="left">当前值</th>
                                                <th field="unit" width="40" align="left">单位</th>    
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">4、异常历史</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <table id="dg_pca_history" class="easyui-treegrid" style="width:780px;height:230px;"
                                            data-options="
                                                nowrap:false,
                                                rownumbers: false,
                                                idField: 'id',
                                                treeField: 'reason',
                                                fitColumns:true
                                            ">
                                        <thead>
                                            <tr>
                                                <th data-options="field:'id'" width="40">编号</th>
                                                <th data-options="field:'ftaStartTime'" width="200">异常起始时间</th>
                                                <th data-options="field:'ftaEndTime'" width="200">异常终止时间</th>
                                                <th data-options="field:'ftaDuration'" width="100">持续时间(h)</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                                
                            
                            </div>
                        </td>
                    </tr>
                 </table>
            </div>
</body>
</html>
<script type="text/javascript">
    function initColor() {
        /* 设置报表 */
        $('#gridDiv .datagrid-body tr td[field="space1"]').each(function () {
            var id = $(this).parent().children().eq(0).children().text();
            $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:24px; height:24px;' onclick='makeOk('" + id + "')' ></input>");
        });

        $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
    }

    function showHistoryLine(tagId, tableName) {
        if(3 != getBrowserType()){
        }else{
            var windowLeft = (top.document.body.clientWidth)/2-850/2;
            var windowTop = (top.document.body.clientHeight)/2-630/2;
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


    $('#dg_critical_tags').datagrid({ onLoadSuccess: initColor,
        "onClickCell": function (rowIndex, field, value) {
            if ("space1" == field) {
                $('#gridDiv .datagrid-body tr td[field="space1"]').eq(rowIndex).each(function () {
                    var tagId = $(this).parent().children().eq(0).children().text();
                    var tableName = $(this).parent().children().eq(1).children().text();
                    showHistoryLine(tagId, tableName); //报表事件
                });
            }
        }
    });
    function loadingCurve(){   //初始化4个变量趋势图
        for(var o in tagsNameJson){
            if(flag == 0){
                nowShowList.push(tagsNameJson[o].tagName);
                tagAjax(tagsNameJson[o].tagName, "chartContainer1");
            }
            if(flag == 1){
                nowShowList.push(tagsNameJson[o].tagName);
                tagAjax(tagsNameJson[o].tagName, "chartContainer2");
            }
            if(flag == 2){
                nowShowList.push(tagsNameJson[o].tagName);
                tagAjax(tagsNameJson[o].tagName, "chartContainer3");
            }
            if(flag == 3){
                nowShowList.push(tagsNameJson[o].tagName);
                tagAjax(tagsNameJson[o].tagName, "chartContainer4");
                break;
            }
            
            flag = flag + 1;
        }
        
        var ifr = document.getElementById("pcaCurve"); //初始化设备监测曲线
        ifr.src = "web_run_state_main.aspx?modelid=<%=modelId %>&plantId=<%=plantId %>&clickUnusual ="; //http://localhost:25509/PSOG.UI/aspx/
        if (ifr.attachEvent){
            ifr.attachEvent("onload", function(){
                //loadingCurve();
            });
        } else {
            ifr.onload = function(){
                //loadingCurve();
            };
        }
    }
    
    function LimitOfTag(str, limitFlag){    //获取位号str在已知变量数组里的上下限,limitFlag为1，上限；limitFlag为2，下限；
        for(var o in tagsNameJson){
            if(str == tagsNameJson[o].tagName){
                if(limitFlag == 1){
                    return tagsNameJson[o].HLimit;
                }else{
                    return tagsNameJson[o].LLimit;
                }
            }
        }
    }
    function DescribeOfTag(str){    //获取位号str在已知变量数组里的描述
        for(var o in tagsNameJson){
            if(str == tagsNameJson[o].tagName){
                return tagsNameJson[o].tagDescription;
            }
        }
    }
    function UnitOfTag(str){    //获取位号str在已知变量数组里的单位
        for(var o in tagsNameJson){
            if(str == tagsNameJson[o].tagName){
                return tagsNameJson[o].tagUnit;
            }
        }
    }
    
    
    function tagAjax(tagName, divId){  //ajax加载变量趋势图，tagName为位号名称，divId为相应div的id
    
        if(document.getElementById('tagStartTime')){
            var startTemp = $("#tagStartTime").val();
            var endTemp = $("#tagEndTime").val();
            
            if(startTemp > endTemp){
                alert("开始时间不能大于截止时间！");
                return ;
            }
            
            var High = LimitOfTag(tagName, 1);
            var Low = LimitOfTag(tagName, 2);
            
            $.ajax({
                type: "post",
                url: 'Web_RunState_Device_Monitoring_data.ashx?plantId=<%=plantId %>&tablename='+tagName+'&random=' + Math.random() + '&startTime='+ startTemp +'&endTime='+endTemp,
                data: null,
                dataType: "json",
                success: function(data){
                    var chart = $('#'+divId).highcharts();
                    chart.showLoading('正在加载数据...');
                    var new_data = [];
                    var High_data = [];
                    var Low_data = [];
                    for(var o in data){
                        var str = data[o].startTime.replace(/-/g,'/');
                        var aa = Date.parse(str)+8*60*60*1000;
                        var value = Math.round(data[o].value*100)/100;
                        new_data.push([aa, value]);  
                        High_data.push([aa, High]);
                        Low_data.push([aa, Low]);
                    }
                    chart.series[0].setData(new_data);
                    if(High <= 999999){
                        chart.series[1].setData(High_data);
                    }else{
                        chart.series[1].setData(null);
                    }
                    if(Low >= -999999){
                        chart.series[2].setData(Low_data);
                    }else{
                        chart.series[2].setData(null);
                    }
                    
                    chart.yAxis[0].setTitle({
                        text: DescribeOfTag(tagName)+'<br />'+tagName+','+UnitOfTag(tagName)
                    });
                    chart.hideLoading();                 
                }
             });
        }
        else{
            $.ajax({
                type: "post",
                url: 'Web_RunState_Device_Monitoring_data.ashx?plantId=<%=plantId %>&tablename='+tagName+'&random=' + Math.random(),// + '&startTime='+ startT +'&endTime='+endT,
                data: null,
                dataType: "json",
                success: function(data){
                    var chart = $('#'+divId).highcharts();
                    chart.showLoading('正在加载数据...');
                    var new_data = [];
                    var High_data = [];
                    var Low_data = [];
                    for(var o in data){
                        var str = data[o].startTime.replace(/-/g,'/');
                        var aa = Date.parse(str)+8*60*60*1000;
                        var value = Math.round(data[o].value*100)/100;
                        new_data.push([aa, value]);  
                        High_data.push([aa, High]);
                        Low_data.push([aa, Low]);
                    }
                    chart.series[0].setData(new_data);
                    if(High <= 999999){
                        chart.series[1].setData(High_data);
                    }else{
                        chart.series[1].setVisible(false);
                    }
                    if(Low >= -999999){
                        chart.series[2].setData(Low_data);
                    }
                    chart.yAxis[0].setTitle({
                        text: tagName
                    });
                    chart.hideLoading();                 
                }
             });
        }
        
        
    }
    
    
    $.ajax({
        url: 'device_monitoring_list.html',
        dataType: "json",
        success: function(data){
            var modelID = '<%=modelId %>';
            for(var o in data){
                if(modelID == data[o].modelID){
                    document.getElementById("name1").innerHTML = data[o].name;
                    document.getElementById("name2").innerHTML = data[o].name;
                    document.getElementById("name3").innerHTML = data[o].name;
                    document.getElementById("name4").innerHTML = data[o].name;
                    //document.getElementById("imageURI").src = "../resource/img/device_monitoring_image/"+data[o].ImageID+".jpg";
                }
            }
        }
     });
    
    function formatItem(row){    //渲染Combobox列表
		var s = '<span style="font-weight:bold">' + row.tagName + '</span><br/>' +
				'<span style="color:#888">' + row.tagDescription + '</span>';
		return s;
	}
	
    function IsInList(str){    //判断位号str是否在已知变量数组里
        for(var i=0; i<nowShowList.length; i++){
            if(str == nowShowList[i]){
                break;
            }
        }
        if(i == nowShowList.length){
            return false;
        }else{
            return true;
        }
    }
	$(function(){	   
        $('#chartContainer1').highcharts({   //第一个变量趋势图
			chart: {
				zoomType: 'x'
			},
			title: {
				text:null
			},
			xAxis: {
				type: 'datetime',
				dateTimeLabelFormats: {
                    hour: '%m月%d日 %H:%M',
                    day: '%m月%d日  %H:%M'
                },
                labels: {
                    rotation: 0
                }
			},
			yAxis: {
				title: {
					text: "",
					margin:20
				},
				style: {
                    fontWeight: 'large'
                }
			},
			legend: {
				enabled: false
			},
			exporting: {
                enabled: false
            },
            lang: {
                noData: "无记录"
            },
            noData: {
                style: {
                    fontWeight: 'bold',
                    fontSize: '15px',
                    color: '#FFFFFF'
                }
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
				},
				series: {
                    color: '#EEC900'
                }
			},
			tooltip:{
			    pointFormat: '数值: <b>{point.y}</b><br/>',
			    xDateFormat: '%Y-%m-%d %H:%M'
			},
			legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'top',
                borderWidth: 0
            },
			series: [{
				type: 'line',
				name: '趋势值'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '报警上限'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '报警下限'
			}]
		});
		
		$('#chartContainer2').highcharts({  //第二个变量趋势图
			chart: {
				zoomType: 'x'
			},
			title: {
				text:null
			},
			xAxis: {
				type: 'datetime',
				dateTimeLabelFormats: {
                    hour: '%m月%d日 %H:%M',
                    day: '%m月%d日  %H:%M'
                },
                labels: {
                    rotation: 0
                }
			},
			yAxis: {
				title: {
					text: "",
					margin:20
				},
				style: {
                    fontWeight: 'large'
                }
			},
			legend: {
				enabled: false
			},
			exporting: {
                enabled: false
            },
            lang: {
                noData: "无记录"
            },
            noData: {
                style: {
                    fontWeight: 'bold',
                    fontSize: '15px',
                    color: '#FFFFFF'
                }
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
				},
				series: {
                    color: '#EEC900'
                }
			},
			tooltip:{
			    pointFormat: '数值: <b>{point.y}</b><br/>',
			    xDateFormat: '%Y-%m-%d %H:%M'
			},
			series: [{
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			}]
		});
		
		$('#chartContainer3').highcharts({  //第三个变量趋势图
			chart: {
				zoomType: 'x'
			},
			title: {
				text:null
			},
			xAxis: {
				type: 'datetime',
				dateTimeLabelFormats: {
                    hour: '%m月%d日 %H:%M',
                    day: '%m月%d日  %H:%M'
                },
                labels: {
                    rotation: 0
                }
			},
			yAxis: {
				title: {
					text: "",
					margin:20
				},
				style: {
                    fontWeight: 'large'
                }
			},
			legend: {
				enabled: false
			},
			exporting: {
                enabled: false
            },
            lang: {
                noData: "无记录"
            },
            noData: {
                style: {
                    fontWeight: 'bold',
                    fontSize: '15px',
                    color: '#FFFFFF'
                }
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
				},
				series: {
                    color: '#EEC900'
                }
			},
			tooltip:{
			    pointFormat: '数值: <b>{point.y}</b><br/>',
			    xDateFormat: '%Y-%m-%d %H:%M'
			},
			series: [{
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			}]
		});
		
		$('#chartContainer4').highcharts({  //第四个变量趋势图
			chart: {
				zoomType: 'x'
			},
			title: {
				text:null
			},
			xAxis: {
				type: 'datetime',
				dateTimeLabelFormats: {
                    hour: '%m月%d日 %H:%M',
                    day: '%m月%d日  %H:%M'
                },
                labels: {
                    rotation: 0
                }
			},
			yAxis: {
				title: {
					text: "",
					margin:20
				},
				style: {
                    fontWeight: 'large'
                }
			},
			legend: {
				enabled: false
			},
			exporting: {
                enabled: false
            },
            lang: {
                noData: "无记录"
            },
            noData: {
                style: {
                    fontWeight: 'bold',
                    fontSize: '15px',
                    color: '#FFFFFF'
                }
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
				},
				series: {
                    color: '#EEC900'
                }
			},
			tooltip:{
			    pointFormat: '数值: <b>{point.y}</b><br/>',
			    xDateFormat: '%Y-%m-%d %H:%M'
			},
			series: [{
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			},{
			    color:'#ED561B',
				type: 'line',
				name: '变量历史趋势'
			}]
		});
		
        loadingCurve();  //初始化4个变量趋势图
        
	    $('#tags').combobox('loadData',stringToJson('<%=pcaModelJson %>'));//加载变量搜索显示框
	    $('#tags').combobox({
	        onSelect: function(param){
	            if(IsInList(param.tagName)){
	                $('#tags').combobox('unselect', param.id);
	                document.getElementById("messageIsInList").style.display="inline";
	            }else{
	                document.getElementById("messageIsInList").style.display="none";
	                var temp = $('#tags').combobox('getText');
		            var tagNames = temp.split(',');
		            if(tagNames.length >= 5){
		                $('#tags').combobox('unselect', param.id);
		                document.getElementById("messageShow").style.display="inline";
		            }
	            }
	        }
        });
        
        $('#submitButton').click(function (){  //点击查询按钮
            var startTemp = $("#tagStartTime").val();
            var endTemp = $("#tagEndTime").val();
            
            if(startTemp > endTemp){
                alert("开始时间不能大于截止时间！");
                return ;
            }
            
            if(startTemp == tagStartTimeFlag && endTemp == tagEndTimeFlag){
                document.getElementById("messageIsInList").style.display="none";
                document.getElementById("messageShow").style.display="none";
                var temp = $('#tags').combobox('getText');
                var tagNames = temp.split(',');
                var random1, random2, random3, random4;
                if(tagNames.length == 1 && tagNames[0] != ""){
                    tagAjax(tagNames[0], "chartContainer1");
                    nowShowList[0] = tagNames[0];
	            }
	            if(tagNames.length == 2){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    nowShowList[0] = tagNames[0];
                    nowShowList[1] = tagNames[1];
	            }
	            if(tagNames.length == 3){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    tagAjax(tagNames[2], "chartContainer3");
                    nowShowList[0] = tagNames[0];
                    nowShowList[1] = tagNames[1];
                    nowShowList[2] = tagNames[2];
	            }
	            if(tagNames.length == 4){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    tagAjax(tagNames[2], "chartContainer3");
                    tagAjax(tagNames[3], "chartContainer4");
                    nowShowList[1] = tagNames[1];
                    nowShowList[2] = tagNames[2];
                    nowShowList[3] = tagNames[3];
                    nowShowList[0] = tagNames[0];
	            }
            }else{ //有一个不相等的
                document.getElementById("messageIsInList").style.display="none";
                document.getElementById("messageShow").style.display="none";
                var temp = $('#tags').combobox('getText');
                var tagNames = temp.split(',');
                var random1, random2, random3, random4;
                if(tagNames.length == 1 && tagNames[0] == ""){
                    tagAjax(nowShowList[0], "chartContainer1");
                    tagAjax(nowShowList[1], "chartContainer2");
                    tagAjax(nowShowList[2], "chartContainer3");
                    tagAjax(nowShowList[3], "chartContainer4");
	            }
                if(tagNames.length == 1 && tagNames[0] != ""){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(nowShowList[1], "chartContainer2");
                    tagAjax(nowShowList[2], "chartContainer3");
                    tagAjax(nowShowList[3], "chartContainer4");
                    nowShowList[0] = tagNames[0];
	            }
	            if(tagNames.length == 2){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    tagAjax(nowShowList[2], "chartContainer3");
                    tagAjax(nowShowList[3], "chartContainer4");
                    nowShowList[0] = tagNames[0];
                    nowShowList[1] = tagNames[1];
	            }
	            if(tagNames.length == 3){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    tagAjax(tagNames[2], "chartContainer3");
                    tagAjax(nowShowList[3], "chartContainer4");
                    nowShowList[0] = tagNames[0];
                    nowShowList[1] = tagNames[1];
                    nowShowList[2] = tagNames[2];
	            }
	            if(tagNames.length == 4){
                    tagAjax(tagNames[0], "chartContainer1");
                    tagAjax(tagNames[1], "chartContainer2");
                    tagAjax(tagNames[2], "chartContainer3");
                    tagAjax(tagNames[3], "chartContainer4");
                    nowShowList[1] = tagNames[1];
                    nowShowList[2] = tagNames[2];
                    nowShowList[3] = tagNames[3];
                    nowShowList[0] = tagNames[0];
	            }
	            
	            tagStartTimeFlag = startTemp; 
	            tagEndTimeFlag = endTemp;
            }
            
	        $('#tags').combobox('clear');
        });
        
        $('#dg_pca_history').datagrid('loadData', stringToJson('<%=pcaHistory %>'));
        
        $('#dg_tags_monitoring_1').datagrid({
            onLoadSuccess:function(data){
                if (data.rows.length == 0)
                {
                   // document.getElementById("no_data").style.display = "block";
                }
            }
        });
	});
	
</script>