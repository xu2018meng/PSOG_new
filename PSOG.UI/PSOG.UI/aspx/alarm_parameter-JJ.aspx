<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarm_parameter.aspx.cs" Inherits="aspx_alarm_parameter" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% string contextPath = Request.ApplicationPath;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;%>
    <title>参数报警</title>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" />
    <link rel="stylesheet" type="text/css" href="../resource/css/WdatePicker.css"/>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/easyui/datagrid-detailview.js"></script>
    <style type="text/css">
        .datagrid-row {
         height: 32px;
     }
     .datagrid-header-row td{font-size:medium;} 
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
    </style>
    <script type="text/javascript"> 
            function setHeight()
            {
                 var max_height = document.documentElement.clientHeight; 
                 var primary = document.getElementByIdx_x('headGrid');
                 primary.style.minHeight = max_height+"px";
                 primary.style.maxHeight = max_height+"px";                                      
            }
    </script>
</head>
<body   style="width:100%;overflow-y: hidden; font-size:medium;">
    <div style="overflow-y:hidden; min-height:100%;width:99%" id="qryDiv"  region="north"  border="false">
        <!-- #include file="include_loading.aspx" -->
        <!-- <table id="dg"   style="width:auto;min-height:340px;"  class="easyui-datagrid" -->
        <div id="gridDiv" fit="true" style=" width:100%; height:100%; overflow-y:hidden;" border="false">
            <div id="headGrid" region="center" style=" width:auto; height:100%; overflow-y: hidden;">
           
             <table id="dg"   style="overflow-x:hidden;" class="easyui-datagrid" 
                     idField="tableId"  url="alarm_parameter_data.ashx?plantId=<%=plantId %>&r=<%=DateTime.Now%>" 
                         pagination="false" data-options="method:'get'" 
                        rownumbers="true" fitColumns="true" singleSelect="true" remoteSort="false">
                    <thead>
                        <tr > 
                               <% if (Array.IndexOf(list, "004001space2") >= 0)
                               {%>
                            <th data-options="field:'space2'" width="100" align="center">确认</th> 
                            <%} %>
                            <% if (Array.IndexOf(list, "004001items") >= 0)
                               {%>                  
                            <th  data-options="field:'items'" width="150" align="center" sortable="true" >位号</th>
                            <%} %>
                           <%-- <% if (((IList)list).Contains("111"))
                               { %>--%>
                            <% if (Array.IndexOf(list, "004001value") >= 0)
                               {%>
                            <th field="value" width="100" align="center" sortable="false">实时值</th>
                            <%} %>
                            <% if (Array.IndexOf(list, "004001state") >= 0)
                               {%>
                            <th field="state" width="70" align="center">状态</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "004001alarmClass") >= 0)
                               {%>
                            <th field="alarmClass" width="50" align="center" sortable="true" sorter="numberSortPriority">优先级</th>
                            <%} %>         
                            <th field="color" width="60" align="center" hidden="true">危险性颜色</th>
                            <th field="tempColor" width="10" align="center" hidden="true">偏离颜色</th>
                             <% if (Array.IndexOf(list, "004001strtext") >= 0)
                               {%>
                            <th field="strtext" width="70" align="center">偏离度</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "004001duration") >= 0)
                               {%>
                            <th field="duration" width="150" align="center" sortable="true" sorter="numberSort">持续时间(分钟)</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "004001startTime") >= 0)
                               {%>
                            <th field="startTime" width="200" align="center" sortable="true">开始时间</th>
                            <%} %>
                             <% if (Array.IndexOf(list, "004001space1") >= 0)
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
function initColor() {//初始化颜色
    /* 设置颜色 */
    $('#headGrid .datagrid-body tr td[field="strtext"]').each(function () {
       //偏离度填充颜色
       var cell = $(this).prev().children().eq(0);
        if ("" != cell.text()) {
           var color = cell.text();
            if ("Yellow" == color) color = "#005AB5";
            if ("Red" == color) color="#ff3300";
            $(this).css({ "color": color });
            var cellText = $(this).children().eq(0).html();
            $(this).children().eq(0).html("<span style='font-weight:600'>" + cellText + "</span>");
      } 
        //危险性填充颜色
        cell = $(this).prev().prev().children().eq(0);
        if ("" != cell.text()) {
            var color = cell.text();
            if ("rgb(0,0,255)" == color) color = "#005AB5";
            if ("rgb(255,0,0)" == color) color="#ff3300";
            $(this).prev().prev().prev().css({ "color": color });
            var cellText1 =$(this).prev().prev().prev().children().eq(0).html();
            $(this).prev().prev().prev().children().eq(0).html("<span style='font-weight:600'>" + cellText1 + "</span>");
            $(this).prev().prev().prev().prev().css({ "color": color }); //状态填充颜色
            var cellText2 = $(this).prev().prev().prev().prev().children().eq(0).html();
            $(this).prev().prev().prev().prev().children().eq(0).html("<span style='font-weight:600'>" + cellText2 + "</span>");
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
    debugger;

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
        window.showModalDialog("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),window, "dialogHeight=600px; dialogWidth=800px; center=true; scroll=no; resizable=no; status=no;");
    }else{
        var windowLeft = (top.document.body.clientWidth)/2-850/2;
        var windowTop = (top.document.body.clientHeight)/2-630/2;
        window.open("alarm_history_line.aspx?plantId=<%=plantId %>&tablename=" + tableName + "&random=" + Math.random(),"newWindow", "Height=610px,Width=800px,left="+windowLeft+",top="+windowTop+", scroll=no, resizable=no, status=no");
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
//        detailFormatter:function(index,row){
//            return '<div style="padding:2px"><table class="ddv" width = "80%"></table></div>';
//        },
        detailFormatter:function(index,row){return '<div class="ddv" style="padding:15px 0;weight:80%;height:100px;overflow-x:hidden;overflow:scroll; scrollBar-3dLight-color: orange;"></div>';},
        onSelect: function (rowIndex, rowData){
            $(this).datagrid('expandRow',rowIndex);
            
        },
        onExpandRow: function(index,row){
            //debugger;
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
             url: 'alarm_parameter_hazop.ashx?plantId=<%=plantId %>&instrumentId='+row.id+'&state='+stateflag,
             data: null,
             dataType: "json",
             success: function(data){
                         ddv.empty();   //清空resText里面的所有内容
                         var html = '<table style="width:100%;height:100px;margin-top:0px;border-style:none; overflow:scroll; border-left-style:none;"> <tr style="padding-top:3px;"><td style="width:22%;align:left;font-weight:600;border-style:none;border-left-style:none;">可能原因</td><td style="width:3%;border-style:none;border-left-style:none;"></td><td style="width:22%;align:left;font-weight:600;border-style:none;border-left-style:none;">建议措施</td><td style="width:3%;border-style:none;border-left-style:none;"></td><td style="width:22%;align:left;font-weight:600;border-style:none;border-left-style:none;">不良后果</td><td style="width:3%;border-style:none;border-left-style:none;"></td><td style="width:22%;align:left;font-weight:600;border-style:none;border-left-style:none;">防范措施</td></tr>'; 
                         $.each(data.rows, function(commentIndex, comment){
                          var length=data.rows.length;                     
                                   if(commentIndex==0)
                                   {
                                         if(length>2)
                                         {
                                            html +='<tr><td style="width:22%;height:34px;align:left;border:none;" > '+ comment['cause']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;border:none;">'+ comment['measure']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;valign:middle;border:none;" rowspan="'+length+'">'+ comment['effect']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;valign:middle;border:none;"rowspan='+length+';>'+ comment['prevent']+'</td></tr>';
                                         }
                                         else
                                         {
                                            html +='<tr><td style="width:22%;height:34px;align:left;border:none;" > '+ comment['cause']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;border:none;">'+ comment['measure']+'</td><td style="width:3%;border-style:none;border:none;"></td><td style="width:22%;height:34px;align:left;valign:middle;border:none;" rowspan="3">'+ comment['effect']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;valign:middle;border:none;"rowspan=3;>'+ comment['prevent']+'</td></tr>';
                                         }
                                   }                            
                                  else{
                                    if((commentIndex%2)==1){
                                        html += '<tr style="background-color: lightgoldenrodyellow;"><td style="width:22%;height:34px;align:left;border-right-style:none;border-left-style:none;" > '+ comment['cause']+'</td><td style="width:3%;border-right-style:none;border-left-style:none;"></td><td style="width:22%;height:34px;align:left;border-right-style:none;border-left-style:none;">'+ comment['measure']+'</td></tr>'
                                    }else{
                                        html += '<tr><td style="width:22%;height:34px;align:left;border:none;" > '+ comment['cause']+'</td><td style="width:3%;border:none;"></td><td style="width:22%;height:34px;align:left;border:none;">'+ comment['measure']+'</td></tr>'
                                    }
                                  }
                         });
                         if(data.rows.length==0){
                            for(var i=data.rows.length;i<3;i++){
                                 html += '<tr><td style="width:22%;height:34px;align:left;border-style:none;" ></td><td style="width:3%;border-style:none;"></td><td style="width:22%;height:34px;align:left;border-style:none;"></td></tr>'
                            }
                         }
                             html +='</table>'; 
                         ddv.html(html);
                         var datalength = data.rows.length<3?3:data.rows.length;
                         ddv.css("height",(60+34*datalength)+"px");
                         ddv.css("width","100%");
                        ddv.css("overflow","hidden");
                         //$('#dg').datagrid('fixDetailRowHeight',index);
                         setTimeout(function(){
                            //debugger;
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

//function resizeGrid( ) {
//    $('#dg').datagrid('resize', {
//        width: function () { return document.body.clientWidth * 100; },
//       height:function(){return document.body.clientHeight*50;},
//    });
//    $('#dg1').datagrid('resize', {
//        width: function () { return document.body.clientWidth * 100; }
//    });
//}
//$(window).resize(function () {
//    resizeGrid();
//});

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
    window.setInterval("reloadgrid()",60000);    
}

/* 重新加载列表 */
function reloadgrid(){
  $.ajax({
             type: "post",
             dataType: "json",
             url : './alarm_parameter_data.ashx',
             data:{     action:"update",
                        plantId:"<%=plantId %>"
                         },
          
             success: function(data){
                              $.each(data.rows, function(commentIndex, comment){ 
                                var count=0;
                                var MODEL_FILE = $("#dg").datagrid("getRows"); 
                                for (var i = 0; i < MODEL_FILE.length; i++) {
                                    if (MODEL_FILE[i].tableId == comment['tableId']) {
                                       break;
                                    }
                                    else {
                                        count++;
                                    }
                                }
                                    if(count==MODEL_FILE.length){
                                        $("#dg").datagrid('insertRow',{
	                                        index: 0,	// index start with 0
	                                        row: {
		                                    space2: "<a href='#' class='easyui-linkbutton' onclick='makeOk()'>确定</a>",
		                                    items: comment['items'],
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
                                        for (var i = 0; i < MODEL_FILE.length; i++) {
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
            }
     });
  // $("#dg").datagrid("reload");
    initColor();          

}
intervall();
window.onerror = function () { return true; };
</script>