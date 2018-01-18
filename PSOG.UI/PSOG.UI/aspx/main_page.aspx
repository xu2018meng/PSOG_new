<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main_page.aspx.cs" Inherits="aspx_main_page" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html >
 <head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
  <title>主页</title>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"/>
         <script language="javascript" type="text/javascript" src="..resource/js/jquery-1.6.2.min.js"></script>
         <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
         <script type="text/javascript" src="../resource/js/highcharts.js"></script>
        <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
        <script type="text/javascript">
            //工艺
            function getValue(obj, functionNo)
            {
                try{
                    url = "./aspx/art_check_main.aspx?plantId=<%=plantId %>&clickProcess="+obj.innerText;
                    
                    window.parent.window.showFunction('<%=plantId %>', functionNo,url);//点击按钮
                }catch(exp){}
                
                //给客户端使用
                try{
                    window.external.mainHomeProcessButton(obj.innerText);//点击按钮
                }catch(exp){};

            }
            //设备
            function getValue2(obj, functionNo)
            {   
                try{             
                    url = ("./aspx/device_check_main.aspx?plantId=<%=plantId %>&clickProcess="+obj.innerText);//点击按钮
                    window.parent.window.showFunction('<%=plantId %>', functionNo,url);//点击按钮
                }catch(exp){};
                
                //给客户端使用
                try{
                    window.external.mainHomeEquipButton(obj.innerText);//点击按钮

                }catch(exp){};
            }
            //仪表
            function getValue3(obj)
            {
            }
            //报警
            function getValue4(obj)
            {
            }
            //工艺检查下拉内容
            function downLIst(e)
            {
              var para=document.createElement("div");
               
            }
            
            var functionNos = ["002","003","004"];    //功能菜单编码
            function show(a)
            {
                var jsonStr = "["+a+"]";
               
                 jsonObj = eval(jsonStr);
                var len = jsonObj.length;
                //alert(len);
                var cell = null;
                var len2 = 0;
                var str = "";
               
                for(var i = 0;i<len;i++)
                {
                   //alert(jsonObj[i].name);
                   // alert(i);
                    if(jsonObj[i].name=="报警")
                    {
                        
                        cell = document.getElementById("Alarmcount");
                        if (null == jsonObj[i].content) {
                            var InsertTable = document.getElementById("Alarmtable");
                            for (var j = 0; j < 3; j++) {
                                var newRow = InsertTable.insertRow();
                            }
                            
                            if(undefined != document.documentMode){ //ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 8px; right:5px;font-size:12px;'>0个</span>";   
                            }else{  //非ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 7px; right: 5px;font-size:12px;'>0个</span>";
                            }
                            cell.style.display = "";
                            
                        }else{
                            len2 = jsonObj[i].content.length;
                            if(1 <= len2){
                                if(undefined != document.documentMode){ //ie浏览器
                                    cell.innerHTML = "<span style='position: absolute; top: 8px; right: 3px;font-size:11px;'>"+ len2 + "个</span>";   
                                }else{  //非ie浏览器
                                    cell.innerHTML = "<span style='position: absolute; top: 7px; right: 8px;font-size:11px;'>"+ len2 + "</span>";
                                }
                                cell.style.display = "";
                            }
                             if(len2>3)
                            {
                                len2 = 3;
                            }
                            str="";
    //                        var InsertTable=document.getElementById("Alarmtable");
                            for(var j = 0;j<3;j++)
                            {   
                                if(j<len2){
                                    var dataCell = jsonObj[i].content[j];
                                    var innerTR = '<tr style="height: 28px;"><td nowrap="nowrap">'+ dataCell.num +'</td><td nowrap="nowrap">'+ dataCell.item +'</td><td nowrap="nowrap">'+ dataCell.value +'</td><td nowrap="nowrap">'+ dataCell.state +'</td><td nowrap="nowrap">'+ dataCell.startTime +'</td></tr>';
                                    $("#Alarmtable tbody").append(innerTR);
                                }
                                else{
                                    var innerTR = '<tr style="height: 28px;"><td></td><td></td><td></td><td></td><td></td></tr>';
                                    $("#Alarmtable tbody").append(innerTR);
                                }
                            
                            }
                        }
                        
                    }
                    
                    if(jsonObj[i].name=="异常工况")
                    {
                        
                        cell = document.getElementById("AS_count");
                        if (null == jsonObj[i].content) {
                            var InsertTable_AS = document.getElementById("AS_table");
                            for (var j = 0; j < 3; j++) {
                                var newRow_1 = InsertTable_AS.insertRow();
                            }
                            if(undefined != document.documentMode){ //ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 8px; right: 5px;font-size:12px;'>0个</span>";   
                            }else{  //非ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 7px; right: 5px;font-size:12px;'>0个</span>";
                            }
                            cell.style.display = "";
                        }else{
                            len2 = jsonObj[i].content.length;
                           if(1 <= len2){
                                if(undefined != document.documentMode){ //ie浏览器
                                    cell.innerHTML = "<span style='position: absolute; top: 9px; right: 2px;font-size:10px;'>"+ len2 + "个</span>";   
                                }else{  //非ie浏览器
                                    cell.innerHTML = "<span style='position: absolute; top:7px; right: 4px;font-size:10px;'>"+ len2 + "</span>";
                                }
                                cell.style.display = "";
                            }
                            if(len2>3)
                            {
                                len2 = 3;
                            }
                            str="";
    //                        var InsertTable=document.getElementById("Alarmtable");
                            for(var j = 0;j<3;j++)
                            {   
                                if(j<len2){
                                    var dataCell = jsonObj[i].content[j];
                                    var innerTR = '<tr style="height: 28px;"><td nowrap="nowrap">'+ dataCell.id +'</td><td nowrap="nowrap">'+ dataCell.ASName +'</td><td nowrap="nowrap">'+ dataCell.status +'</td><td nowrap="nowrap">'+ dataCell.unit +'</td><td nowrap="nowrap">'+ dataCell.corrInstru +'</td><td nowrap="nowrap">'+ dataCell.duration +'</td><td nowrap="nowrap">'+ dataCell.startT +'</td></tr>';
                                    $("#AS_table tbody").append(innerTR);
                                }
                                else{
                                    var innerTR = '<tr style="height: 28px;"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                                    $("#AS_table tbody").append(innerTR);
                                }
                            
                            }
                        }
                        
                    }
                    
                }
                
                $.ajax({
                    url: 'alarm_analysis_outline_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>&id=2&dbSource=0',
                    //url: './alarm_level_data/<%=plantId %>'+startTime+endTime+'.html',
                    dataType: "json",
                    success: function(data){
                        var array = [];
                        var num = 0;
                        var array_area = [];
                        var array_level = [];
                        for(var o in data)
                        {
                            if(data[o].area == '装置')
                            {
                                level = '';
                                if (data[o].level == "超负荷的")
                                {
                                    level = '等级5';
                                }
                                if (data[o].level == "可预测的")
                                {
                                    level =  '等级1';
                                }
                                if (data[o].level == "鲁棒的")
                                {
                                    level =  '等级2';
                                }
                                if (data[o].level == "稳定的")
                                {
                                    level =  '等级3';
                                }
                                if (data[o].level == "反应性的")
                                {
                                    level =  '等级4';
                                }
                                $('#alarm_level_text').html(level);
                                $('#KPI_text').html( '<table style="width:100%; height:100%;"><tr><td style="width:33%;">'+data[o].averagerate+'(平均报警率)</td><td style="width:33%;">'+data[o].maxrate+'(峰值报警率)</td><td style="width:33%;">'+data[o].disturbrate+'(扰动率)</td><td style="width:1%;"></td></tr></table>');
                            }
                            else
                            {
                                num += 1;
                                var temp = [];
                                temp.push(data[o].averagerate);
                                temp.push(data[o].maxrate);
                                temp.push(data[o].disturbrate);
                                array.push(temp);
                                array_area.push(data[o].area);
                                array_level.push(data[o].level);
                            }
                            
                        }
                        
                        
                        var table_text = '<table style="width:100%;height:100%; vertical-align:middle;border-collapse:collapse;"><tr>';
                        var average_width = 100/num;
                        var text_second_row = '';
                        for(var i=0; i<num; i++)
                        {
                            level = '';
                            if (array_level[i] == "超负荷的")
                            {
                                level = '等级5';
                            }
                            if (array_level[i] == "可预测的")
                            {
                                level =  '等级1';
                            }
                            if (array_level[i] == "鲁棒的")
                            {
                                level =  '等级2';
                            }
                            if (array_level[i] == "稳定的")
                            {
                                level =  '等级3';
                            }
                            if (array_level[i] == "反应性的")
                            {
                                level =  '等级4';
                            }
                            table_text += '<td style="background-color:#fff;width:'+average_width+'%; height:80px; border:1px solid #000;border-right-style:none">';
                            table_text += '<table style="width:100%; height:100%;">';
                            table_text += '<tr>';
                            table_text += '<td style="width:33%;"></td>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+level+'</td>';
                            table_text += '<td style="width:34%;"></td>';
                            table_text += '</tr>';
                            table_text += '<tr>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+array[i][0]+'</td>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+array[i][1]+'</td>';
                            table_text += '<td style="width:34%;text-align:center;vertical-align:middle;border-width:0">'+array[i][2]+'</td>';
                            table_text += '</tr>';
                            table_text += '</table>';
                            table_text += '</td>';
                            
                            text_second_row += '<td style="width:'+average_width+'%; height:15px; text-align:center;vertical-align:middle;border:1px solid #000;border-right-style:none">'+array_area[i]+'</td>';
                        }
                        
                        table_text += '<td style="background-color:#fff;width:1px; height:80px; border:1px solid #000;border-left-style:none"></td></tr><tr>';
                        text_second_row += '<td style="width:1px; height:15px; text-align:center;vertical-align:middle;border:1px solid #000;border-left-style:none"></td>';
                        table_text += text_second_row;                                
                        
                        table_text += '</tr></table>';
                        
                        var alarm_table_id = $('#alarm_table_area');
                        alarm_table_id.html(table_text);
                        
//                                for(var i=0; i<num; i++)
//                                {
//                                    var alarm_id = 'alarm_id_'+i;
//                                    var alarm_container = document.getElementById(alarm_id);
//                                    level = '';
//                                    if (array_level[i] == "超负荷的")
//                                    {
//                                        level = '等级5';
//                                    }
//                                    if (array_level[i] == "可预测的")
//                                    {
//                                        level =  '等级1';
//                                    }
//                                    if (array_level[i] == "鲁棒的")
//                                    {
//                                        level =  '等级2';
//                                    }
//                                    if (array_level[i] == "稳定的")
//                                    {
//                                        level =  '等级3';
//                                    }
//                                    if (array_level[i] == "反应性的")
//                                    {
//                                        level =  '等级4';
//                                    }
//                                    $('#alarm_id_1').highcharts({
//                                        chart: {
//                                            type: 'column'
//                                        },
//                                        title: {
//                                            text: level,
//                                            style: {
//                                                fontSize: '10'
//                                            }
//                                        },
//                                        legend: {
//                                            enabled: false
//                                        },
//                                        series: [{
//                                            name: '',
//                                            data: array[i]
//                                        }]
//                                    });
//                                }
                    }
                });
                
                $.ajax({
                    url: 'operation_quality_main_page_data.ashx?plantId=<%=plantId %>&startTime=<%=startTime %>&endTime=<%=endTime %>',
                    //url: './alarm_level_data/<%=plantId %>'+startTime+endTime+'.html',
                    dataType: "json",
                    success: function(data){
                        var array = [];
                        var num = 0;
                        var array_area = [];
                        var array_level = [];
                        for(var o in data)
                        {
                            if(data[o].area == '装置')
                            {
                                level = '';
                                $('#OQI_score').html(data[o].allPercent);
                                $('#OQI_KPI').html( '<table style="width:100%; height:100%;"><tr><td style="width:33%;border-width:0">'+data[o].countPercent+'(合格率)</td><td style="width:33%;border-width:0">'+data[o].CPKPercent+'(操作指数)</td><td style="width:33%;border-width:0">'+data[o].score+'(得分)</td></tr></table>');
                            }
                            else
                            {
                                num += 1;
                                var temp = [];
                                temp.push(data[o].countPercent);
                                temp.push(data[o].CPKPercent);
                                temp.push(data[o].score);
                                array.push(temp);
                                array_area.push(data[o].area);
                                array_level.push(data[o].allPercent);
                            }
                            
                        }
                        
                        var table_text = '<table style="width:100%;height:100%; vertical-align:middle;border-collapse:collapse;"><tr>';
                        var average_width = 100/num;
                        average_width = Math.floor(average_width);
                        var text_second_row = '';
                        for(var i=0; i<num; i++)
                        {
                            level = '';

                            table_text += '<td style="background-color:#fff;width:'+average_width+'%; height:80px;border:1px solid #000;border-right-style:none">';
                            table_text += '<table style="width:100%; height:100%;">';
                            table_text += '<tr>';
                            table_text += '<td style="width:33%;"></td>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+array_level[i]+'</td>';
                            table_text += '<td style="width:34%;"></td>';
                            table_text += '</tr>';
                            table_text += '<tr>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+array[i][0]+'</td>';
                            table_text += '<td style="width:33%;text-align:center;vertical-align:middle;border-width:0">'+array[i][1]+'</td>';
                            table_text += '<td style="width:34%;text-align:center;vertical-align:middle;border-width:0">'+array[i][2]+'</td>';
                            table_text += '</tr>';
                            table_text += '</table>';
                            table_text += '</td>';
                            
                            text_second_row += '<td style="width:'+average_width+'%; height:15px; text-align:center;vertical-align:middle;border:1px solid #000; border-right-style:none">'+array_area[i]+'</td>';
                        }
                        
                        text_second_row += '<td style="width:1px; height:15px; text-align:center;vertical-align:middle;border:1px solid #000;border-left-style:none"></td>';
                        table_text += '<td style="background-color:#fff;width:1px; height:80px; border:1px solid #000;border-left-style:none"></td></tr><tr>';
                        table_text += text_second_row;                                
                        
                        table_text += '</tr></table>';
                        
                        var operation_table_id = $('#operation_table_area');
                        operation_table_id.html(table_text);
                    }
                });
            }
           function test(a,b) 
            {
                    
                
            }
            function test2() 
            {  
              
            }
            tech = 0;
            //工艺
            function extend(obj) 
            {  
                tech++;
             //   var jsonStr = "[{'id':2,'name':'工艺','state':'异常',content:[{'sid':'id','name':'反应','state':'0'},{'sid':'id2','name':'再生','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'堆积','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'},{'sid':'id2','name':'分馏','state':'1'}]}]";
              //  var jsonObj = eval(jsonStr);
                var len = jsonObj.length;
                var cell = null;
                var len2 = 0;
                var str = "";

                for(var i = 0;i<len;i++)
                {
                    if(jsonObj[i].name=="工艺")
                    {
                        cell = document.getElementById("technics");
                        //alert(cell.childNodes.length); 
                        len2 = jsonObj[i].content.length;
                         if(len2<6)
                        {
                            return null;
                        }
                        if(tech%2==0)
                        {
                            len2=6;
                        }
                        for(var j = 0;j<len2;j++)
                        {   
                            if(j%6==0&&j!=0)
                            {
                                str = str+"<br />";
                            }
                            if(len2%6!=0)
                            {
                                if(j!=len2-1&&j%6!=0)
                                {
                                    str = str+"<label style='cursor:pointer;' onclick='getValue(this)'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>";//竖线
                                }
                            }
                            if(jsonObj[i].content[j].state=="正常")
                            {
                                str = str + "<label  style='cursor:pointer;' onclick='getValue(this)'>"+jsonObj[i].content[j].name+"</label>";
                            }
                            else
                            {
                                str = str + "<label  style='color:red;fcursor:pointer;' onclick='getValue(this)'>"+jsonObj[i].content[j].name+"</label>";
                            }
                            if(len2%6==0)
                            {
                                if(j!=len2-1)
                                {
                                    str = str+"<label style='cursor:pointer;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>";//竖线
                                }
                            }

                            
                        }
                        cell.innerHTML =str;
                         
                    }
                 }
              //tech=1;
            }
            device = 0;
            //设备
            function extend2(obj)
            {
                device++;
                 var jsonStr = "[{'id':2,'name':'设备','state':'异常',content:[{'sid':'id','name':'反应器','state':'0'},{'sid':'id2','name':'加热炉','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'干燥器','state':'1'},{'sid':'id2','name':'反应堆','state':'1'},{'sid':'id2','name':'干馏器','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'碳堆积','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'},{'sid':'id2','name':'脱硫器','state':'1'}]}]";
                //var jsonObj = eval(jsonStr);
                  //alert(jsonObj);
                var len = jsonObj.length;
                var cell = null;
                var len2 = 0;
                var str = "";

                for(var i = 0;i<len;i++)
                {
                    if(jsonObj[i].name=="设备")
                        {
                            cell = document.getElementById("device");
                            //alert("设备"+cell.childNodes.length); 
                            len2 = jsonObj[i].content.length;
//                            if(obj.id!="设备")
//                            {
//                                if(len2>5)
//                                {
//                                    len2 = 5;
//                                 }
//                             }
                            if(len2<5)
                            {
                                return null;
                            }
                            if(device%2==0)
                            {
                                len2 = 5;
                            }
                            for(var j = 0;j<len2;j++)
                            {   
                                 if(j%5==0&&j!=0)
                                {
                                    str = str+"<br />";
                                }
                                if(j%5!=0)
                                {
                                    str = str+"<label style='cursor:pointer;'>&nbsp;&nbsp;&nbsp;&nbsp;</label>";
                                }
                                if(jsonObj[i].content[j].state=="正常")
                                {
                                    str = str + "<label  style='cursor:pointer;' onclick='getValue2(this)'>"+jsonObj[i].content[j].name+"</label>";
                                }
                                else
                                {
                                    str = str + "<label  style='color:red;cursor:pointe;r' onclick='getValue2(this)'>"+jsonObj[i].content[j].name+"</label>";
                                }

                            }
                            cell.innerHTML =str;
                        }
                    }
                    
            }
            appearence = 0;
            //仪表
            function extend3(obj)
            {
                appearence++;
                var jsonStr = "[{'id':2,'name':'仪表','state':'异常',content:[{'sid':'id','name':'FIC1201','state':'0'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'},{'sid':'id2','name':'FIC1201','state':'1'}]}]";
               // var jsonObj = eval(jsonStr);
                  //alert(jsonObj);
                var len = jsonObj.length;
                var cell = null;
                var len2 = 0;
                var str = "";
               
                for(var i = 0;i<len;i++)
                {
                   if(jsonObj[i].name=="仪表")
                    {
                        cell = document.getElementById("appearance");
                       // alert("仪表"+cell.childNodes.length); 
                        len2 = jsonObj[i].content.length;
//                        if(obj.id!="仪表")
//                        {
//                            if(len2>5)
//                            {
//                                len2 = 5;
//                             }
//                         }
                        if(len2<3)
                        {
                            return null;
                        }
                        if(appearence%2==0)
                        {
                            len2 = 3;
                        }
                        for(var j = 0;j<len2;j++)
                        {  
                            
                             if(j%3==0&&j!=0)
                            {
                                str = str+"<br />";
                            }
                            if(j%3!=0)
                            {
                                str = str+"<label style='font-size:small;'>&nbsp;&nbsp;|&nbsp;&nbsp;</label>";
                            }
                            str = str + "<label  style='font-size:small;' onclick='getValue3(this)'>"+jsonObj[i].content[j].name+"</label>";

                            
                        }
                        cell.innerHTML =str;
                    }
                    }
                   
            }
        </script>
        
        <style type="text/css">
		    html, body {
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
			    font-family:微软雅黑;
			    text-align:center;
		    }
		    
           body{
            overflow:auto;
            SCROLLBAR-FACE-COLOR: #cecece; 
            SCROLLBAR-HIGHLIGHT-COLOR: white; 
            SCROLLBAR-SHADOW-COLOR: white; 
            SCROLLBAR-3DLIGHT-COLOR: white; 
            SCROLLBAR-ARROW-COLOR: white; 
            SCROLLBAR-TRACK-COLOR: white; 
            SCROLLBAR-DARKSHADOW-COLOR: white; 
            font-size: 12px;
            font-family:微软雅黑;
            }
            #quality
            {
                border-right: solid 1px; border-right-color:rgb(225,224,228);
            }
           #quality tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
            border-top: solid 1px; border-top-color:rgb(225,224,228);
           }
           #quality tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            height:22px;
            font-family:微软雅黑;
           }
           #Alarmtable
           {
               /*border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);*/
               height:91px;
           }
           #Alarmtable tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #Alarmtable tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            font-family:微软雅黑;
            height:25px;
           }
           
           #AS_table
           {
               /*border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);*/
               height:91px;
           }
           #AS_table tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #AS_table tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            font-family:微软雅黑;
            height:22px;
           }
           
           #technics 
           {
               padding-top:3px; 
               border-top: solid 1px rgb(225,224,228);
               border-left: solid 1px rgb(225,224,228);
               border-right: solid 1px rgb(225,224,228);
               width:99%; 
               height:99px; 
           }
           
           #device 
           {
               padding-top:3px; 
               text-align:center;
               font-size: 13px; 
               padding-top:3px;
               border-top: solid 1px rgb(225,224,228);
               border-left: solid 1px rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);
               width:803px; 
               height:91px; 
           }
           #span_alarm_head
           {
               font-size:12pt;font-family:微软雅黑; 
               width:100%; 
               //text-align:center; 
               background-color: RGB(246,246,246);  
               padding:0px; 
               height:30px; 
               vertical-align:middle;
               line-height:180%;
               border-bottom: solid 1px; border-bottom-color: rgb(225,224,228);
           }
           
           #span_operation_head
           {
               font-size:12pt;font-family:微软雅黑; 
               width:100%; 
               //text-align:center; 
               background-color: RGB(246,246,246);  
               padding:0px; 
               height:30px; 
               vertical-align:middle;
               line-height:180%;
               border-bottom: solid 1px; border-bottom-color: rgb(225,224,228);
           }
           
           .span_bottom_5
           {
               height:23px;
               background-color: RGB(246,246,246);  
               border-top: solid 1px rgb(225,224,228);
               width:100%;
           }
           
           #table2, #table3, #table4 {display:none;}
	    </style>
 </head>
 <body>
       <!-- #include file="include_loading.aspx" --> 
       <div style="overflow:auto;padding-top:8px;margin-left:auto ; margin-right:auto;font-family:微软雅黑; text-align:center;">
           &nbsp;
           <%--<iframe src="http://10.206.1.81/iem/login.aspx?iemuser=iEMAdmin&&iempwd=qq1234&&inside=1&&iemloginmode=0&&inurl=Data.aspx&&urltype=0" style="display:none"></iframe>--%>
           
           <table border="0" cellpadding="5" cellspacing="0" style="width:100%;text-align:center;margin-left:auto ; margin-right:auto; border-collapse:collapse; border-spacing:0px 0px;" >
               <tr>
                   <td style="text-align:center; width: 100%;">
			        <table style="margin-left:auto ; margin-right:auto; padding:0px; border-collapse:collapse; border-spacing:0px 0px; border: solid 1px rgb(225,224,228); height:131px; width:965px; display:none" id="table2">
                        <tr style=" border-collapse:collapse; border-spacing:0px 0px;  padding:0px;">
                             <td  style="width:150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;"> 
                                <img src='../resource/img/plantMain/gyjc.png' onclick="imgClick('<%=plantId %>', '002')"  alt="工艺" style="width: 116px; height: 115px; cursor:pointer" id="IMG1"  /></td>
                             <td  style="text-align:left; width: 250px; vertical-align:top;text-align:center; border-collapse:collapse; border-spacing:0px 0px; padding:0px; " >
                                 <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246); padding:0px; height:30px; vertical-align:middle;line-height:180%;">
                                    运行状态</div>
                                  <div id="technics"></div>  
                                   <div class="span_bottom_5"></div> 
                             </td>
                             <td style="font-size:12pt; font-family: 微软雅黑; text-align:center; vertical-align:top; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                                <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246);  padding:0px; height:30px; vertical-align:middle;line-height:180%;">
                                    <label style="width:100%; height:100%; vertical-align:middle">质量分析</label>
                                </div>
                                                       
                                <table  id="quality"  style="text-align:center; display: inline; white-space:normal; width:570px;border-collapse:collapse; border-spacing:0px 0px; ">
                                    <tr style="background-image:url(../resource/img/plantMain/tab_top_bg.gif); height: 25px; background-repeat:repeat-x; border-collapse:separate; border-top: solid 1px;border-bottom: solid 1px;">
                                        <th style="width: 40px; font-family: 微软雅黑;  text-align: center;  font-weight:normal;"  nowrap="nowrap">
                                            序号</th>
                                        <th style="width: 110px; font-family: 微软雅黑; text-align: center;  font-weight:normal;"  nowrap="nowrap">
                                            样品名称</th>
                                        <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal;"  nowrap="nowrap">
                                            分析项目</th>
                                        <th style="width: 60px; font-family: 微软雅黑; text-align: center; font-weight:normal;"  nowrap="nowrap">
                                            实时值</th>
                                        <th style="width: 50px; font-family: 微软雅黑; text-align: center; font-weight:normal; "  nowrap="nowrap">
                                            单位</th>
                                        <th style="width: 50px; font-family: 微软雅黑; text-align: center; font-weight:normal; "  nowrap="nowrap">
                                            状态</th>
                                        <th style="width: 140px; font-family: 微软雅黑; text-align: center; border-right:  0px; font-weight:normal; "  nowrap="nowrap">
                                            时间
                                        </th>
                                    </tr>
                                </table> 
                                <div class="span_bottom_5"></div>                
                             </td>
                             <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                    </table>
                    <br />
                    <table style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:116px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; border: solid 1px rgb(225,224,228); display:none" id="table3">
                        <tr>
                            <td style="text-align:left;width:150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;"> 
                                <img src='../resource/img/plantMain/sbjc.png'  onclick="imgClick('<%=plantId %>', '003')" alt="设备" style="width: 116px; height: 116px; cursor:pointer" />
                                </td>
                            <td style="text-align:left; height: 14px;vertical-align:top; padding:0px;" >
                                <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246);  padding:0px; height:30px; vertical-align:top; text-align:center;;line-height:180%;">
                                    运行状态</div>
                                <div id="device" >
                                    
                                </div>
                                <div class="span_bottom_5"></div> 
                            </td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                    </table>
                     <br />
                    
                    
                    <table  id="table4" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:116px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                                <img  src='../resource/img/plantMain/bjfx.png'  onclick="imgClick('<%=plantId %>', '002')" alt="报警" style="width: 116px; height: 116px;cursor:pointer; display:none" />
                                <label style="font-size:small;color:White; font-family: 微软雅黑; width:31px; height: 31px; position:absolute; cursor:pointer; right:15px; top:23px; display:none; background-image: url(../resource/img/mainPage/showAlarmNum.png); "  onclick="imgClick('<%=plantId %>', '002')" id="Alarmcount" ></label>
                                <div style="font-size:25px; color:#168dcd; font-family:微软雅黑;">实 时<br />报 警</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: 微软雅黑;padding:0px; vertical-align:top;" >
                                <div id="" style="display:none">
                                    <label style="width:100%; height:100%; vertical-align:middle">报警分析</label>
                                </div>
                                <table  id="Alarmtable"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                                    <tr style="height: 25px; background-repeat:repeat-x; padding:0px; width:100%; background-color: RGB(246,246,246);">
                                        <th style="width: 15%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            序号</th>
                                        <th style="width: 25%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            位号</th>
                                        <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            实时值</th>
                                        <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            状态</th>
                                        <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            开始时间</th>
                                    </tr>
                                </table>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                        
                        
                    </table>
                    
                    <br /><br />
                    <table  id="table1" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:116px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;display:none">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                                <img  src='../resource/img/plantMain/bjfx.png'  onclick="loadUrl('ycgk')" alt="报警" style="width: 116px; height: 116px;cursor:pointer; display:none" />
                                <label style="font-size:small;color:White; font-family: 微软雅黑; width:31px; height: 31px; position:absolute; cursor:pointer; right:15px; top:23px; background-image: url(../resource/img/mainPage/showAlarmNum.png); "  onclick="loadUrl('ycgk')" id="AS_count" ></label>
                                <div style="font-size:25px; color:#168dcd; font-family:微软雅黑;">异 常<br />工 况</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: 微软雅黑;padding:0px; vertical-align:top;" >
                                <div id="Div1" style="display:none">
                                    <label style="width:100%; height:100%; vertical-align:middle">报警分析</label>
                                </div>
                                <table  id="AS_table"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                                    <tr style="height: 25px; background-repeat:repeat-x; padding:0px; width:100%; background-color: RGB(246,246,246);">
                                        <th style="width: 5%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            序号</th>
                                        <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            异常工况</th>
                                        <th style="width: 10%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            状态</th>
                                        <th style="width: 10%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                            单元</th>
                                        <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            关联仪表</th>
                                        <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            持续时间</th>
                                        <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            开始时间</th>
                                    </tr>
                                </table>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                    </table>
                   
 
 
                     <table  id="table5" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:160px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" onclick="loadUrl('bjpg')" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;cursor:pointer;"> 
                                <img  src='../resource/img/plantMain/bjfx.png'  onclick="loadUrl('bjpg')" alt="报警" style="width: 116px; height: 116px;cursor:pointer; display:none" />
                                <label style="font-size:small;color:White; font-family: 微软雅黑; width:41px; height: 41px; position:absolute; cursor:pointer; right:15px; top:8px; display:none; background-image: url(../resource/img/mainPage/showAlarmNum.png); "  onclick="loadUrl('bjpg')" id="Label2" ></label>
                                <div style="font-size:25px; color:#168dcd; font-family:微软雅黑;">报 警<br />评 估</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: 微软雅黑;padding:0px; vertical-align:top;background-color: RGB(246,246,246)" >
                                <div style="height:5px;"></div>
                                <div id="span_alarm_head" style="" class="">
                                    <table style="width:100%;height:100%; vertical-align:middle;border-collapse:collapse;">
                                        <tr>
                                            <td style="width:10%; border-width:thin; border-color:Black;border:1px solid #000;">报警等级</td>
                                            <td id="alarm_level_text" style="width:40%; background-color:White;border:1px solid #000;"></td>
                                            <td style="width:10%;border:1px solid #000;">KPI指标</td>
                                            <td id="KPI_text" style="width:40%; background-color:White;border:1px solid #000;border-right-style:none"></td>
                                            <td style="width:1px; background-color:White;border:1px solid #000; border-left-style:none"></td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="height:5px;"></div>
                                <div id="alarm_table_area" style="height:85px; width:100%"></div>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                    </table>
                    <br /><br />
                    
                    <table  id="table6" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:160px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;" >
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" onclick="loadUrl('czzl')" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;cursor:pointer;"> 
                                <img  src='../resource/img/plantMain/bjfx.png'  onclick="loadUrl('czzl')" alt="报警" style="width: 116px; height: 116px;cursor:pointer; display:none" />
                                <label style="font-size:small;color:White; font-family: 微软雅黑; width:41px; height: 41px; position:absolute; cursor:pointer; right:15px; top:8px; display:none; background-image: url(../resource/img/mainPage/showAlarmNum.png); "  onclick="loadUrl('czzl')" id="Label1" ></label>
                                <div style="font-size:25px; color:#168dcd; font-family:微软雅黑;">操 作<br />质 量</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: 微软雅黑;padding:0px; vertical-align:top;background-color: RGB(246,246,246)" >
                                <div style="height:5px;"></div>
                                <div id="span_operation_head" style="" class="">
                                    <table style="width:100%;height:100%; vertical-align:middle;border-collapse:collapse;">
                                        <tr>
                                            <td style="width:10%; border-width:thin; border:1px solid #000;">综合指标</td>
                                            <td id="OQI_score" style="width:40%; background-color:White;border:1px solid #000;"></td>
                                            <td style="width:10%;border:1px solid #000;">KPI指标</td>
                                            <td id="OQI_KPI" style="width:40%; background-color:White;border:1px solid #000;border-right-style:none"></td>
                                            <td style="width:1px; background-color:White;border:1px solid #000;border-left-style:none"></td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="height:5px;"></div>
                                <div id="operation_table_area" style="height:85px; width:100%"></div>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                        </tr>
                    </table>
                    
                        </td>
                    </tr>
            </table> 
         </div>  
 </body>
</html>
<script type="text/javascript">
var jsonStr = '<%=jsonStr %>';

if("" != jsonStr){
    show(jsonStr);
}

function refreshData(){
    $.ajax({
        url: "./main_page_data.aspx?random=" + Math.random(),
        async: true,
        type: "post",
        data: { plantId: '<%=plantId %>' },
        success: function (data) {
            //清空数据
            clearData();

            //展现数据
            show(data);
        }
    })
}

function clearData() {
    $('#technics').empty();
    $('#quality tr').each(function (index) {
        if (0 != index)
            $(this).remove();
    })
    $('#device').empty();
    $('#Alarmtable tr').each(function (index) {
        if(0 != index)
            $(this).remove();
    })
    $('#AS_table tr').each(function (index) {
        if(0 != index)
            $(this).remove();
    })
}

function intervall() {
    window.setInterval("refreshData()", 15000);
}
intervall();

var functionNos = "<%=functionNos %>"
if (-1 != functionNos.indexOf("002")) {
    // $("#table2").show();
}
if (-1 != functionNos.indexOf("003")) {
    // $("#table3").show();
}
if (-1 != functionNos.indexOf("004")) {
    $("#table4").show();
}

function imgClick(plantId, functionNo) {
    try{
        // parent.window.clickFunction(plantId, functionNo);
        parent.window.function_click_ZH("alarm_parameter.aspx?plantId=<%=plantId %>&sys_menu_code=009", "009");
    }catch(exp){}
    
    //给客户端使用
    try{
        window.external.mainPageFunctionImgClick(functionNo);//点击按钮
    }catch(exp){};
    
}

function imgClickAS(plantId, functionNo) {
    try{
        //parent.window.clickFunction(plantId, functionNo);clickFunction_ZH
        //parent.window.function_click_ZH("aspx/alarm_parameter.aspx?plantId=<%=plantId %>&sys_menu_code=004001", "002");
        parent.window.clickFunction_ZH(plantId, functionNo);
    }catch(exp){}
    
    //给客户端使用
    try{
        window.external.mainPageFunctionImgClick(functionNo);//点击按钮
    }catch(exp){};
    
}

function loadUrl(type){
   if(type == "czzl"){
      window.location.href = "./operation_quality_analysis.aspx?plantId=<%=plantId %>";
   }else if(type == "bjpg"){
      window.location.href = "./alarm_analysis.aspx?plantId=<%=plantId %>";
   }else if(type == "ycgk"){
      window.location.href = "./Web_RunState_ASDB.aspx?plantId=<%=plantId %>";
   }
}

if(undefined != document.documentMode){
    if (document.documentMode >= 10) // IE8
    {
        $("#technics").css("height", "87px");
    }else  if (document.documentMode == 9) // IE8
    {
        $("#technics").css("height", "96px");
    }else{
        $("#technics").css("height", "91px");
    }
}else{
    $("#technics").css("height", "87px");
}
</script>