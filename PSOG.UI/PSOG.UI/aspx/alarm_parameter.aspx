<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_parameter.aspx.cs" Inherits="aspx_alarm_parameter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;%>
    <title>参数报警</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <!-- <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" /> -->
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/datagrid-detailview.js"></script>
    <style type="text/css">
        .datagrid-row {
         height: 32px;
     }
     .datagrid-header-row td{font-size:30px;font-weight:bold;} 
        body{
            overflow:auto;
            font-size:12px;font-family: 微软雅黑;
            SCROLLBAR-FACE-COLOR: #cecece; 
            SCROLLBAR-HIGHLIGHT-COLOR: white; 
            SCROLLBAR-SHADOW-COLOR: white; 
            SCROLLBAR-3DLIGHT-COLOR: white; 
            SCROLLBAR-ARROW-COLOR: white; 
            SCROLLBAR-TRACK-COLOR: white; 
            SCROLLBAR-DARKSHADOW-COLOR: white; 
            }
     .panel-body {
          background-color: #000000;
        }
        .datagrid-row-selected {
          background: #000; //#0052A3
        }
        .datagrid-row-over,
        .datagrid-header td.datagrid-header-over {
          background: #000;
          color: #fff;
          cursor: default;
        }
        .datagrid-header,.datagrid-td-rownumber {
          background-color: #000;
          border-color: #222;
          background: -webkit-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: -moz-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: -o-linear-gradient(top,#4c4c4c 0,#3f3f3f 100%);
          background: linear-gradient(to bottom,#4c4c4c 0,#3f3f3f 100%);
          background-repeat: repeat-x;
          filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#4c4c4c,endColorstr=#3f3f3f,GradientType=0);
        }
        .panel-header, .panel-body {
            border-color: #000000;
        }
        .datagrid-htable {
            color: white;
        }
        .datagrid-header .datagrid-cell span{
            font-size:16px;font-weight:bold;
        }
        .datagrid-cell-rownumber {
            color:#fff;
        }
    </style>
    <script type="text/javascript"> 
            function setHeight()
            {
                 var max_height = document.documentElement.clientHeight; 
                 var primary = document.getElementByIdx_x('headGrid');
                 primary.style.minHeight = max_height+"px";
                 primary.style.maxHeight = max_height+"px";                                      
            }
            function Fkey(){ 
                var WsShell = new ActiveXObject('WScript.Shell') 
                WsShell.SendKeys('{F11}'); 
            } 
    </script>
</head>
<body   style="width:100%;overflow-y: hidden; font-size:medium;overflow-x: hidden;">
    <div style="overflow-y:hidden; min-height:100%;width:99%;overflow-x: hidden;" id="qryDiv"  region="north"  border="false">
        <!-- #include file="include_loading.aspx" -->
        <!-- <table id="dg"   style="width:auto;min-height:340px;"  class="easyui-datagrid" -->
        <!-- <a href="javascript:Fkey()" style=" color:Black">屏幕切换</a> -->
        <div id="gridDiv" fit="true" style=" width:100%; height:100%; overflow-y:hidden;overflow-x: hidden;" border="false">
            <div id="headGrid" region="center" style=" width:auto; height:100%; overflow-y: hidden;overflow-x: hidden;">
           
             <table id="dg"   style="overflow-x:hidden; " class="easyui-datagrid" 
                     idField="tableId"  url="alarm_parameter_data.ashx?plantId=<%=plantId %>&r=<%=DateTime.Now%>" 
                         pagination="false" data-options="method:'get',
                        rowStyler: function(index,row){
                            return 'color:#ffffff;';
                        }" 
                        rownumbers="true" fitColumns="true" singleSelect="true" remoteSort="false">
                    <thead>
                        <tr > 
                               <% if (Array.IndexOf(list, "009space2") >= 0)
                               {%>
                            <th data-options="field:'space2'" width="100" align="center">确认</th> 
                            <%} %>
                            <% if (Array.IndexOf(list, "009items") >= 0)
                               {%>                  
                            <th  data-options="field:'items',styler:cellStyler" width="150" align="center" sortable="true" >位号</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "009Desc") >= 0)
                               {%>                  
                            <th  data-options="field:'describe',styler:cellStyler" width="300" align="left" sortable="true" >描述</th>
                            <%} %>
                          
                            <% if (Array.IndexOf(list, "009value") >= 0)
                               {%>
                            <th data-options="field:'value',styler:cellStyler" width="100" align="center" sortable="false">实时值</th>
                            <%} %>
                            <th field="color" width="60" align="center" hidden="true">状态颜色</th>
                            <% if (Array.IndexOf(list, "009state") >= 0)
                               {%>
                            <th data-options="field:'state'" width="70" align="center">状态</th>
                            <%} %>
                            <th field="color" width="60" align="center" hidden="true">优先级颜色</th>
                             <% if (Array.IndexOf(list, "009alarmClass") >= 0)
                               {%>
                            <th field="alarmClass" width="70" align="center" sortable="true" sorter="numberSortPriority">优先级</th>
                            <%} %>         
                            
                            <th field="tempColor" width="10" align="center" hidden="true">偏离颜色</th>
                             <% if (Array.IndexOf(list, "009strtext") >= 0)
                               {%>
                            <th field="strtext" width="70" align="center">偏离度</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "009duration") >= 0)
                               {%>
                            <th field="duration" width="150" align="center" sortable="true" sorter="numberSort">持续时间(分钟)</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "009startTime") >= 0)
                               {%>
                            <th field="startTime" width="200" align="center" sortable="true">开始时间</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "009space1") >= 0)
                               {%>
                            <th field="space1" width="50" align="center"></th>
                            <%} %>
                            <th field="tableId" width="10" align="center" hidden="true">tableId</th>
                            <th field="id" width="10" align="center" hidden="true">instrumentId</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
     </div>  
    <!-- 
    <div id="Div4"  region="center" style="padding: 5px; height:300px;width:99%" border="false"> 
        <div id="Div1"  style="width:auto" border="false">
            <div id="Div2"   region="center"  style=" height: 240px;width:auto" border="true">
                <table id="dg1"  class="easyui-datagrid"  style="width:auto;height:240px"
                         idField="tableId" url="alarm_parameter_hazop.ashx?plantId=<%=plantId %>" 
                         pagination="false" 
                        rownumbers="false" fitColumns="true" singleSelect="true" nowrap="false">
                    <thead>
                        <tr> 
                            <th field="cause" width="10" align="left">可能原因</th>                   
                            <th field="measure" width="10" align="left">建议措施</th>
                            <th field="effect" width="10" align="left">不良后果</th>
                            <th field="prevent" width="10" align="left">防范措施</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
            
    </div>
    -->
    
</body>
</html>
<script type="text/javascript">
var flag = 0;
function cellStyler(value,row,index){
	return 'color:#ffffff;';
}
function initColor() {//初始化颜色
    /* 设置偏离度填充颜色 */
    $('#headGrid .datagrid-body tr td[field="strtext"]').each(function () {
       //偏离度填充颜色
       var cell = $(this).prev().children().eq(0);
        if ("" != cell.text()) {
           var color = cell.text();
            if ("Yellow" == color) color = "#F0E535";//005AB5
            if ("Red" == color) color="#D9231F";//ff3300
            if ("Orange" == color) color="#ED9028";
            $(this).css({ "color": color });
            var cellText = $(this).children().eq(0).html();
            $(this).children().eq(0).html("<span style='font-weight:600'>" + cellText + "</span>");
        } 
                
    });
    
    /* 设置报警状态颜色 */
    $('#headGrid .datagrid-body tr td[field="state"]').each(function () {
       
       var cell = $(this).prev().children().eq(0);
        if ("" != cell.text()) {
           var color = cell.text();
            if ("rgb(255,128,0)" == color) color = "#ED9028";
            if ("rgb(255,0,0)" == color) color="#D9231F";//
            if ("rgb(0,0,0)" == color) color="#ffffff";//
            if ("rgb(0,0,255)" == color) color = "#ED9028";
            $(this).css({ "color": color });
            var cellText = $(this).children().eq(0).html();
            $(this).children().eq(0).html("<span style='font-weight:600'>" + cellText + "</span>");
        }
          
    });
    
    /* 设置报警优先级颜色 */
    $('#headGrid .datagrid-body tr td[field="alarmClass"]').each(function () {
       //偏离度填充颜色
       var cell = $(this).prev().children().eq(0);
        if ("" != cell.text()) {
           var color = cell.text();
            if ("rgb(255,128,0)" == color) color = "#ED9028";
            if ("rgb(255,0,0)" == color) color="#D9231F";
            if ("rgb(0,0,0)" == color) color="#ffffff";
            if ("rgb(0,0,255)" == color) color = "#ED9028";
            $(this).css({ "color": color });
            var cellText = $(this).children().eq(0).html();
            $(this).children().eq(0).html("<span style='font-weight:600'>" + cellText + "</span>");
        } 
          
    });
     $(".datagrid-header-row td div span").each(function(i,th){        var val = $(th).text();         $(th).html("<label style='font-weight: 580;font-size:28'>"+val+"</label>");    });
    /* 设置报表 */
    $('#headGrid .datagrid-body tr td[field="space1"]').each(function () {
        var id = $(this).parent().children().eq(0).children().text();
        $(this).children().eq(0).html("<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:34px; height:24px;' onclick='makeOk('" + id + "')' ></input>");//不明白        
    });
    /* 设置确定项 */
    $('#headGrid .datagrid-body tr td[field="space2"]').each(function () {
         var id = $(this).parent().children().eq(2).children().text();
       // $(this).children().eq(0).html("<input  type='button' style='width:46px' onclick='makeOk('" + id + "')' value='确定'></input>");  
       $(this).children().eq(0).html("<a href='#' class='easyui-linkbutton'>确定</a>");     
    });

    $('table.datagrid-htable').find('.datagrid-cell').css("text-align", 'center');
   
}

//删除
function makeOk(rowIndex,rowData){

     //$("#dg").datagrid("deleteRow", rowIndex);
     $.ajax({
            url : './alarm_parameter_data.ashx',
            data : {
                action:"deleteItem",
                realTimeID:rowData.tableId,
                plantId:"<%=plantId %>"
            },
            async:false,
            type:"post",
            success : function(data) {
                $("#dg").datagrid("deleteRow", rowIndex);
                $.messager.show({
                        title : '提示',
                        msg : data
                });                
            }
        });
}

function numberSort(a,b){   //持续时间排序
    var number1 = parseFloat(a);  
    var number2 = parseFloat(b);  

    return (number1 > number2 ? 1 : -1);
}  

function numberSortPriority(a,b){   //优先级排序
    var number1 = 1;  //1代表低，2代表中，3代表高，4代表紧急
    var number2 = 1;
    
    if(a=='紧急'){
        number1 = 4;
    }
    if(a=='高'){
        number1 = 3;
    }
    if(a=='中'){
        number1 = 2;
    }
    
    if(b=='紧急'){
        number2 = 4;
    }
    if(b=='高'){
        number2 = 3;
    }
    if(b=='中'){
        number2 = 2;
    }
    
    if(number1 != number2){
        return (number1 > number2 ? 1 : -1);
    }
    
}

function showHistoryLine(tableName){
    if(3 != getBrowserType()){
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=yes; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=yes, status=no");
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

var clickTd = false;//记录是否点击确认按钮
var lastInstrumentationId = "";
$(function(){  //展开
    $('#dg').datagrid({
        onLoadSuccess: initColor,
        onClickCell:function(rowIndex, field, value){
            if("space2" == field){
                $('#headGrid .datagrid-body tr td[field="space2"]').eq(rowIndex).each(function () {
                    //var id = $(this).parent().children().eq(0).children().text();
                    clickTd = true;
                });
            }else if("space1" == field){
                $('#headGrid .datagrid-body tr td[field="space1"]').eq(rowIndex).each(function () {
                    var items = $(this).parent().children().eq(1).children().text();
                    showHistoryLine(items);     //报表事件
                });
            }
        },
        view: detailview,
        detailFormatter:function(index,row){return '<div class="ddv" style="padding:0px 0 0 0px;weight:80%;height:100px;overflow-x:hidden;overflow:scroll; scrollBar-3dLight-color: orange;"></div>';},
        onSelect: function (rowIndex, rowData){
            $(this).datagrid('expandRow',rowIndex);
            
        },
        onExpandRow: function(index,row){
            if(true == clickTd){
                makeOk(index,row);    //确定事件
                clickTd = false; 
                return ;
            }
            clickTd = false;
            var instrumentationId = row.id;
            if (lastInstrumentationId == instrumentationId) {   //点击相同点不触发更新
                return;
            }
            lastInstrumentationId = instrumentationId;
            
            var stateflag = 1; //1是低低报,2是低报
            if(row["state"] == '高高报' || row["state"] == '高报'){
                stateflag = 2;
            }
            var ddv = $(this).datagrid('getRowDetail',index).find('div.ddv');
            $.ajax({
                type: "GET",
                url: 'alarm_parameter_hazop.ashx?plantId=<%=plantId %>&instrumentId='+row.items+'&state='+stateflag,
                data: null,
                dataType: "json",
                success: function(data){                    ddv.empty();   //清空resText里面的所有内容                    var reason_and_measure = '<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="width:48%;height:34px;align:left;font-weight:bold;font-size:14px;color:lightgoldenrodyellow;border-width: 0px 1px 1px 0px;">可能原因</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;align:left;font-weight:bold;font-size:14px;border-width: 0px 0px 1px 0px;color:lightgoldenrodyellow;">建议措施</td></tr>';
                    var conseq_and_instru = '<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="width:48%;height:34px;align:left;font-weight:bold;font-size:14px;color:lightgoldenrodyellow;border-width: 0px 1px 1px 0px;">不良后果</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;align:left;font-weight:bold;font-size:14px;border-width: 0px 0px 1px 0px;color:lightgoldenrodyellow;">关联仪表</td></tr>';
                    var instru ='<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse">';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '</table>';
                    $.each(data.rows, function(commentIndex, comment){
                        var length=data.rows.length;
                        reason_and_measure += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" > '+ comment['cause']+'</td><td style="width:4%;border:none;"></td><td style="width:48%;height:34px;align:left;border:none;">'+ comment['measure']+'</td></tr>';
                        if(commentIndex==0)
                        {
                            if(length>2)
                            {
                                conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="'+length+'" > '+ comment['effect']+'</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                            }
                            else
                            {
                                conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="3" > '+ comment['effect']+'</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                            }
                        }
                        
                        
                    });
                    
                    if(data.rows.length==0)
                    {
                        reason_and_measure += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" > 无</td><td style="width:4%;border:none;"></td><td style="width:48%;height:34px;align:left;border:none;">无</td></tr>';
                        conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="3" >无</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                    }
                    
                    reason_and_measure +='</table>';
                    conseq_and_instru +='</table>';
                    var html = '<table style="width:100%;height:34px;margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="border-width: 0px 0px 1px 0px;">'+reason_and_measure+'</td></tr><tr><td style="border-width: 0px 0px 0px 0px;">'+conseq_and_instru+'</td></tr></table>'; 

                    ddv.html(html);
                    //var datalength = data.rows.length<3?3:data.rows.length;
                    var datalength = data.rows.length;
                    if(data.rows.length==0)
                    {
                        datalength = 1;
                    }
                    ddv.css("height",(73+34*datalength+3*34)+"px");
                    ddv.css("width","100%");
                    ddv.css("overflow","hidden");
                    var left = $('.datagrid-view1').find('div.datagrid-row-detail');
                    var left_index = left[index];
                    var left_table = '<table style="width:100%;height:'+(73+34*datalength+3*34)+'px;margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="border:none;width:50%"></td><td style="width:5px;background-color:#fff"></td><td style="border:none;"></td></tr></table>';
                    left_index.innerHTML = left_table;
                    left_index.style.width="100%";
                    left_index.style.height=(73+34*datalength+3*34)+"px";
                    left_index.style.overflow="hidden";
                    setTimeout(function(){
                        $('#dg').datagrid('fixDetailRowHeight',index);
                        $('#dg').datagrid('fixRowHeight', index);
                     },2);
                }
            });


            
        }
    });
});

function mergeCells(rowSpan) {
    $('#dg1').datagrid('mergeCells', {
        index: 0,
        field: 'prevent',
        rowspan: rowSpan
    });
    $('#dg1').datagrid('mergeCells', {
        index: 0,
        field: 'effect',
        rowspan: rowSpan
    });
}


$(function() {  
    var datagridId = 'dg';  
  
    // 其他代码  
  
    // 第一次加载时自动变化大小  
    $('#' + datagridId).resizeDataGrid(10, 15, 300, 600);  
  
    // 当窗口大小发生变化时，调整DataGrid的大小  
    $(window).resize(function() {  
        $('#' + datagridId).resizeDataGrid(10, 15, 300, 600);  
    });  
});  
$.fn.extend({  
    resizeDataGrid : function(heightMargin, widthMargin, minHeight, minWidth) {  
        var height = document.documentElement.clientHeight  - heightMargin;  
        var width = $(document.body).width() - widthMargin;  
  
        height = height < minHeight ? minHeight : height;  
        width = width < minWidth ? minWidth : width;  
  
        $(this).datagrid('resize', {  
            height : height,  
            width : width  
        });  
    }  
});  

/* 每五分钟重新加载一次 */
function intervall(){
    window.setInterval("reloadgrid()",120000);  //2分钟  
}

/* 重新加载列表 */
function reloadgrid(){
    $.ajax({
         type: "post",
         dataType: "json",
         url : './alarm_parameter_data.ashx',
         data:{    
                 action:"update",
                 plantId:"<%=plantId %>"
               },
      
         success: function(data){
            $.each(data.rows, function(commentIndex, comment){
            
                var count=0;
                var MODEL_FILE = $("#dg").datagrid("getRows"); 
                for (var i = 0; i < MODEL_FILE.length; i++) {
               
                    if (MODEL_FILE[i].tableId == comment['tableId']) {
                   
                        $('#dg').datagrid('updateRow',{
	                        index: i,
	                        row: {
		                        space2: "<a href='#' class='easyui-linkbutton' onclick='makeOk()'>确定</a>",
                                items: comment['items'],
                                describe:comment['describe'],
                                value: comment['value'],
                                state: comment['state'],
                                alarmClass: comment['alarmClass'],
                                color: comment['color'],
                                tempColor: comment['tempColor'],
                                strtext: comment['strtext'],
                                duration: comment['duration'],
                                startTime:comment['startTime'],
                                space1: "<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:34px; height:24px;' onclick='makeOk()' ></input>",
                                tableId:comment['tableId'],
                                id:comment['id']
	                        }
                        });
                        
                        
                       break;
                    }
                    else {
                        count++;
                    }
                }
                if(count==MODEL_FILE.length){
                    $("#dg").datagrid('insertRow',{
                        index: 0,	// index start with 0
                        row: 
                        {
                            space2: "<a href='#' class='easyui-linkbutton' onclick='makeOk()'>确定</a>",
                            items: comment['items'],
                            describe:comment['describe'],
                            value: comment['value'],
                            state: comment['state'],
                            alarmClass: comment['alarmClass'],
                            color: comment['color'],
                            tempColor: comment['tempColor'],
                            strtext: comment['strtext'],
                            duration: comment['duration'],
                            startTime:comment['startTime'],
                            space1: "<img src='../resource/img/alarm/PSOGDataCurve.ico' style='width:34px; height:24px;' onclick='makeOk()' ></input>",
                            tableId:comment['tableId'],
                            id:comment['id']
                        }
                    });
                }    
            });
            var MODEL_FILE = $("#dg").datagrid("getRows");
            for (var i = 0; i < MODEL_FILE.length; i++){
               var count=0;
               $.each(data.rows, function(commentIndex, comment){ 
                   if (MODEL_FILE[i].tableId == comment['tableId']) {
                       return false;
                   }
                   else {
                       count++;
                   }
               })
               if(count==data.rows.length){
                   $("#dg").datagrid("deleteRow", i);
               }
            }
            initColor();          
        }
     });
   $("#dg").datagrid("reload");
               

}
intervall();
window.onerror = function () { return true; };


function loadHazopParam(index,row){
         if(true == clickTd){
                makeOk(index,row);    //确定事件
                clickTd = false; 
                return ;
         }
         clickTd = false;
          
            
            var stateflag = 1; //1是低低报,2是低报
            if(row["state"] == '高高报' || row["state"] == '高报'){
                stateflag = 2;
            }
            var ddv = $("#dg").datagrid('getRowDetail',index).find('div.ddv');
            $.ajax({
                type: "GET",
                url: 'alarm_parameter_hazop.ashx?plantId=<%=plantId %>&instrumentId='+row.items+'&state='+stateflag,
                data: null,
                dataType: "json",
                success: function(data){                    ddv.empty();   //清空resText里面的所有内容                    var reason_and_measure = '<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="width:48%;height:34px;align:left;font-weight:bold;font-size:14px;color:lightgoldenrodyellow;border-width: 0px 1px 1px 0px;">可能原因</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;align:left;font-weight:bold;font-size:14px;border-width: 0px 0px 1px 0px;color:lightgoldenrodyellow;">建议措施</td></tr>';
                    var conseq_and_instru = '<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="width:48%;height:34px;align:left;font-weight:bold;font-size:14px;color:lightgoldenrodyellow;border-width: 0px 1px 1px 0px;">不良后果</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;align:left;font-weight:bold;font-size:14px;border-width: 0px 0px 1px 0px;color:lightgoldenrodyellow;">关联仪表</td></tr>';
                    var instru ='<table style="width:100%;height:34px;margin-top:0px;border-style:none;overflow:scroll; color:#fff;border-collapse:collapse">';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '<tr>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:40%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '<td style="width:20%;height:34px;align:left;border-width:0px 0 1px 0;"></td>';
                    instru += '</tr>';
                    instru += '</table>';
                    $.each(data.rows, function(commentIndex, comment){
                        var length=data.rows.length;
                        reason_and_measure += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" > '+ comment['cause']+'</td><td style="width:4%;border:none;"></td><td style="width:48%;height:34px;align:left;border:none;">'+ comment['measure']+'</td></tr>';
                        if(commentIndex==0)
                        {
                            if(length>2)
                            {
                                conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="'+length+'" > '+ comment['effect']+'</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                            }
                            else
                            {
                                conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="3" > '+ comment['effect']+'</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                            }
                        }
                        
                        
                    });
                    
                    if(data.rows.length==0)
                    {
                        reason_and_measure += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" > 无</td><td style="width:4%;border:none;"></td><td style="width:48%;height:34px;align:left;border:none;">无</td></tr>';
                        conseq_and_instru += '<tr><td style="width:48%;height:34px;align:left;border-width: 0px 1px 0px 0px;" rowspan="3" >无</td><td style="width:4%;border-width: 0px 0px 1px 0px;"></td><td style="width:48%;height:34px;align:left;border:none;">'+instru+'</td></tr>';
                    }
                    
                    reason_and_measure +='</table>';
                    conseq_and_instru +='</table>';
                    var html = '<table style="width:100%;height:34px;margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="border-width: 0px 0px 1px 0px;">'+reason_and_measure+'</td></tr><tr><td style="border-width: 0px 0px 0px 0px;">'+conseq_and_instru+'</td></tr></table>'; 

                    ddv.html(html);
                    //var datalength = data.rows.length<3?3:data.rows.length;
                    var datalength = data.rows.length;
                    if(data.rows.length==0)
                    {
                        datalength = 1;
                    }
                    ddv.css("height",(73+34*datalength+3*34)+"px");
                    ddv.css("width","100%");
                    ddv.css("overflow","hidden");
                    var left = $('.datagrid-view1').find('div.datagrid-row-detail');
                    var left_index = left[index];
                    var left_table = '<table style="width:100%;height:'+(73+34*datalength+3*34)+'px;margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse"> <tr style="padding-top:3px;"><td style="border:none;width:50%"></td><td style="width:5px;background-color:#fff"></td><td style="border:none;"></td></tr></table>';
                    left_index.innerHTML = left_table;
                    left_index.style.width="100%";
                    left_index.style.height=(73+34*datalength+3*34)+"px";
                    left_index.style.overflow="hidden";
                    setTimeout(function(){
                        $('#dg').datagrid('fixDetailRowHeight',index);
                        $('#dg').datagrid('fixRowHeight', index);
                     },2);
                }
            });
  }
</script>