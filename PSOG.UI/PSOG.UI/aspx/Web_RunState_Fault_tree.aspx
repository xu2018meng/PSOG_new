<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_RunState_Fault_tree.aspx.cs" Inherits="aspx_Web_RunState_Fault_tree" %>

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
       string dtStr = dt.ToString();
         %>
    <title>故障树运行界面</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/demo.css" />
    <%--<link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/black/easyui.css"/>--%>
    <link href="../resource/css/button_style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts.js"></script>
    <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
    <script type="text/javascript" src="../resource/js/modules/exporting.js"></script>
    <script type="text/javascript" src="../resource/js/modules/no-data-to-display.js"></script>
    <script type="text/javascript" src="../resource/js/highchart_dark.js"></script>
    <script type="text/javascript">
        var FT_modelID = "";
        function stringToJson(stringValue)
        {
            eval("var theJsonValue = "+stringValue);
            //var theJsonValue = eval('(' + stringValue + ')');
            return theJsonValue;
        }
        var tagsNameJson = stringToJson('<%=pcaModelJson %>');
        var flag = 0;
        var nowShowList = [];
        
        
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
    </style>
</head>        
<body style="text-align:center">
    
<%-- <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:微软雅黑;">
 &nbsp;&nbsp;当前位置：<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new2.aspx?plantId=<%=plantId %>">主页</a>
  <% if (!string.IsNullOrEmpty(deviceId))
     { %>
 &nbsp;>&nbsp;<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="main_page_new2_detail.aspx?plantId=<%=plantId %>&deviceId=<%=deviceId %>">工艺设备监测点信息</a>
 <%}
   else
   {%>
  &nbsp;>&nbsp;<a style="font-size:16px;text-decoration: none;color:Blue;font-family:微软雅黑;" href="Web_RunState_ASDB.aspx?plantId=<%=plantId %>">根原因分析模型库</a>
  <%} %>
 &nbsp;>&nbsp;异常工况监测
           </div>--%>

           
           <%-- <div title="title1" style="padding:10px;text-align:center;" selected="true" src='web_show_img.aspx?fileId=a&plantId=<%=plantId %>'>
                <iframe id='ifram1' src=''  height="100%" width="100%" frameborder="0"></iframe>
            </div>--%>
        
            
             <div title="" style="padding:10px;text-align:center;   width:1200px; margin-left:auto; margin-right:auto" selected="true" >
              <!-- <iframe id='Iframe1'  height="100%"  width="100%";  src='web_show_ASImg.aspx?fileId=a&plantId=<%=plantId %>&name=<%=plantId %>' scrolling="no" frameborder="0" onload="this.height=this.contentWindow.document.documentElement.scrollHeight;"></iframe>-->
                 
                 <table style="width:1200px; height:100%">
                    <%--<tr>
                        <td style="border-width:1px; width:1200px; text-align:left; font-size:large; background-color:#3399CC; height:40px">
                            异常：<span id="name1" style="font-size:large"></span>
                        </td>
                    </tr>--%>
                    <tr>
                        
                        <td style="border-width:1px; width:1200px; vertical-align:top">
                          <div id="fault_tab_page" class="easyui-tabs" style="width:1200px;">
                            <div title="故障监测" style="padding:10px">
                            <table id="totalGraph" style="width:100%;">
                                <tr>
                                    <td style="width:55%">
                                        <table style="width:100%">
                                            <%--<tr style="height:40px;vertical-align:top">
                                                <td>
                                                    设备综合状态监控曲线
                                                </td>
                                            </tr>--%>
                                            <tr style="height:380px; width:100%; vertical-align:top">
                                                <td style="background-color:Black" align=left>
                                                    <%--<input type="button" onclick="openwin()" style="position:relative;left:83%; background-color:#156482; color:White; border:none; cursor:pointer;margin-top:5px;height:25px;" value="查看模型" />--%>
                                                    <div style="height:120px">
                                                        <div style="color:White; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:dotted; padding-bottom:5px">
                                                            监测对象：<span id="name3" style="color:White"></span>
                                                        </div>
                                                        <div style="color:White; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:dotted">
                                                            当前状态：<%=ftaState %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;开始时间：<%=ftaStateStartTime %>
                                                        </div>
                                                    </div>
                                                    <%--<iframe src="./fault_tree_models/fault_tree_model1.html" style="width:100%;height:240px;"></iframe>--%>
                                                    <table id="dg_root_cause_monitoring" class="easyui-treegrid" style="width:100%;height:230px;"
			                                                data-options="
				                                                nowrap:false,
				                                                rownumbers: false,
				                                                idField: 'id',
				                                                treeField: 'reason',
				                                                fitColumns:true,
				                                                rowStyler: function(index,row){
	                                                                return 'color:#ffffff;';
                                                                }
			                                                ">
		                                                <thead>
			                                                <tr>
				                                                <th data-options="field:'reason',styler:cellStyler" width="300">根原因</th>
				                                                <th data-options="field:'action',styler:cellStyler" width="300">建议措施</th>
			                                                </tr>
		                                                </thead>
	                                                </table>
                                                </td>
                                            </tr>
                                            <tr style="height:400px; width:100%; vertical-align:top">
                                                <td style="text-align:center">
                                                  <div style="overflow:auto;width:600px;height:auto;">
                                                      <img id="imageURI" alt="" style=""  src="../resource/img/rolling.gif"/>
                                                  </div>
                                                   
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width:1%"></td>
                                    <td style="width:44%; background-color:Black; vertical-align:top">
                                        <table style="width:100%; ">
                                            <tr style="height:30px;">
                                                <td style="color:White; font-size:medium; font-weight:bold" align="center">
                                                    <%--<span id="name2" style="font-size:medium; font-weight:bold"></span>--%>故障树变量趋势分析
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart1" style="height:160px;width:100%;text-align:center; ">
                                                        <div id="chartContainer1" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart2" style="height:160px;width:100%;text-align:center; ">
                                                        <div id="chartContainer2" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart3" style="height:160px;width:100%;text-align:center; ">
                                                        <div id="chartContainer3" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="div_chart4" style="height:160px;width:100%;text-align:center; ">
                                                        <div id="chartContainer4" style=" z-index:2; height:100%;width:100%;" ></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="vertical-align:middle">
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
                            <!-- 第二个页卡 -->
                            <div title="报告" style="padding:10px;">
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">1、故障描述</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <span style="font-weight:bold">故障名称：</span><span id="name4"></span> <br />
                                    <span style="font-weight:bold">当前状态：</span><%=ftaState %> <br />
                                    <span style="font-weight:bold">开始时间：</span><%=ftaStateStartTime %> <br />
                                    <span style="font-weight:bold">当前时间：</span><%=dtStr %> <br />
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">2、故障根原因</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <table id="dg_root_cause_report" class="easyui-treegrid" style="width:780px;height:230px;"
                                            data-options="
                                                nowrap:false,
                                                rownumbers: false,
                                                idField: 'id',
                                                treeField: 'reason',
                                                fitColumns:true
                                            ">
                                        <thead>
                                            <tr>
                                                <th data-options="field:'reason',styler:cellStyler" width="300">根原因</th>
                                                <th data-options="field:'action',styler:cellStyler" width="150">建议措施</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">3、关键变量状态</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <table id="dg_tag_state" class="easyui-treegrid" style="width:780px;height:230px;"
                                            data-options="
                                                nowrap:false,
                                                rownumbers: false,
                                                idField: 'id',
                                                fitColumns:true
                                            ">
                                        <thead>
                                            <tr>
                                                <th data-options="field:'id',styler:cellStyler" width="50"></th>
                                                <th data-options="field:'tagName',styler:cellStyler" width="200">位号</th>
                                                <th data-options="field:'tagDescription',styler:cellStyler" width="300">位号描述</th>
                                                <th data-options="field:'tagState',styler:cellStyler" width="100">状态</th>
                                                <th data-options="field:'tagStartTime',styler:cellStyler" width="200">开始时间</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">4、故障演变过程</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <img id="Img" alt="" style=""  src="../resource/img/rolling.gif"/>
                                </div>
                                <div style=" width:800px; margin-top:20px; margin-left:20px; margin-right:20px; border-bottom-style:solid; border-bottom-width:thin; padding-bottom:5px">
                                    <span style="font-size:large; font-weight:bold">5、故障历史</span>
                                </div>
                                <div style="margin-top:10px;margin-left:30px;">
                                    <table id="dg_fta_history" class="easyui-treegrid" style="width:780px;height:230px;"
                                            data-options="
                                                nowrap:false,
                                                rownumbers: false,
                                                idField: 'id',
                                                fitColumns:true
                                            ">
                                        <thead>
                                            <tr>
                                                <th data-options="field:'id',styler:cellStyler" width="40">编号</th>
                                                <th data-options="field:'ftaStartTime',styler:cellStyler" width="200">异常起始时间</th>
                                                <th data-options="field:'ftaEndTime',styler:cellStyler" width="200">异常终止时间</th>
                                                <th data-options="field:'ftaDuration',styler:cellStyler" width="100">持续时间(h)</th>
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
    function cellStyler(value,row,index){
		return 'border:none;';
	}
	function openwin(){
	    windowOpen("./fault_tree_models/fault_tree_model.aspx?plantId=<%=plantId %>&name=<%=modelId %>", '_blank');
	}
	//打开新链接方法实现
    function windowOpen(url, target){
        var a = document.createElement("a");
        a.setAttribute("href", url);
        if(target == null){
            target = '';
        }
        a.setAttribute("target", target);
        document.body.appendChild(a);
        if(a.click){
            a.click();
        }else{
            try{
                var evt = document.createEvent('Event');
                a.initEvent('click', true, true);
                a.dispatchEvent(evt);
            }catch(e){
                window.open(url);
            }
        }
        document.body.removeChild(a);
    }
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

    }
    
    function LimitOfTag(str){    //获取位号str在已知变量数组里的报警限
        for(var o in tagsNameJson){
            if(str == tagsNameJson[o].tagName){
                return tagsNameJson[o].Limit;
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
    function SymbolOfTag(str){    //获取位号str在已知变量数组里的描述
        for(var o in tagsNameJson){
            if(str == tagsNameJson[o].tagName){
                return tagsNameJson[o].limitFlag;
            }
        }
    }
    
    function tagAjax(tagName, divId){  //ajax加载变量趋势图，tagName为位号名称，divId为相应div的id
        var Limit = LimitOfTag(tagName);
        $.ajax({
            type: "post",
            url: 'Web_RunState_Device_Monitoring_data.ashx?plantId=<%=plantId %>&tablename='+tagName+'&random=' + Math.random(),//+ '&startTime=2014-12-27 00:00:00&endTime=2014-12-27 08:00:00',
            data: null,
            dataType: "json",
            success: function(data){
                var chart = $('#'+divId).highcharts();
                chart.showLoading('正在加载数据...');
                var new_data = [];
                var Limit_data = [];
                for(var o in data){
                    var str = data[o].startTime.replace(/-/g,'/');
                    var aa = Date.parse(str)+8*60*60*1000;
                    var value = Math.round(data[o].value*100)/100;
                    new_data.push([aa, value]);  
                    Limit_data.push([aa, Limit]);
                }
                chart.series[0].setData(new_data);
                chart.series[1].setData(Limit_data);
                if(SymbolOfTag(tagName) == '1'){
                    chart.series[1].update({
                        name: '报警下限'
                    });
                }
                if(SymbolOfTag(tagName) == '-1'){
                    chart.series[1].update({
                        name: '报警上限'
                    });
                }
                chart.yAxis[0].setTitle({
                    text: DescribeOfTag(tagName)+'<br />'+tagName
                });
                chart.hideLoading();                 
            }
         });
    }
    
   
    document.getElementById("name3").innerHTML = '<%=ftaName %>';


    function pagerFilter(data){
		if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
			data = {
				total: data.length,
				rows: data
			}
		}
		var dg = $(this);
		var opts = dg.datagrid('options');
		var pager = dg.datagrid('getPager');
		pager.pagination({
			onSelectPage:function(pageNum, pageSize){
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh',{
					pageNumber:pageNum,
					pageSize:pageSize
				});
				dg.datagrid('loadData',data);
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
		return data;
	}

    //加载根原因列表
    $.ajax({
        url: "./FT_Jsons/<%=modelId %>.html",
        dataType: "json",
        success: function(data){
            //故障监测中的根原因列表
            $('#dg_root_cause_monitoring').datagrid({loadFilter:pagerFilter}).datagrid('loadData', data);
            //报告中的根原因列表      
            $('#dg_root_cause_report').datagrid('loadData', data);
           
           //故障演变过程 
           document.getElementById("Img").style.width = 780+'px';
           document.getElementById("Img").style.height = 400+'px';
           document.getElementById("Img").src = '../resource/img/ZHLH_FT/<%=modelId %>.bmp';
           
            //故障监测左下的图片
//            document.getElementById("imageURI").style.width = 640+'px';
//           document.getElementById("imageURI").style.height = 400+'px';
            document.getElementById("imageURI").src = '../resource/img/ZHLH_FT/<%=modelId %>.bmp';
                 
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
				name: ' '
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
				name: ' '
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
				name: ' '
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
				name: ' '
			}]
		});
		
        loadingCurve();  //初始化4个变量趋势图
        
	    //$('#tags').combobox('loadData',stringToJson('<%=pcaModelJson %>'));//加载变量搜索显示框
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
	        $('#tags').combobox('clear');
        });
        
        //关键变量状态
        $('#dg_tag_state').datagrid('loadData', stringToJson('{"rows":'+'<%=pcaModelJson %>'+'}'));
        //故障历史
        $('#dg_fta_history').datagrid('loadData', stringToJson('<%=ftaHistory %>'));
        
	});
	$(function(){
          
	});
</script>