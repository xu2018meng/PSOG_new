<%@ Page Language="C#" AutoEventWireup="true" CodeFile="plant_main_page.aspx.cs" Inherits="aspx_plants_main_page" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html >
 <head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
  <title>主页</title>

        <script type="text/javascript">
            //工艺t
            function getValue(obj, functionNo)
            {
                try{
                    var url = "./aspx/art_check_main.aspx?plantId=<%=plantId %>&clickProcess="+obj.innerText;
                      window.parent.parent.window.showFunction('<%=plantId %>', functionNo,url);//点击按钮
                    
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
                    var url = ("./aspx/device_check_main.aspx?plantId=<%=plantId %>&clickProcess="+obj.innerText);//点击按钮
                    window.parent.parent.window.showFunction('<%=plantId %>', functionNo,url);//点击按钮
                }catch(exp){};
                
                //给客户端使用
                try{
                    window.external.mainHomeEquipButton(obj.innerText);//点击按钮

                }catch(exp){};
            }
            
            var functionNos = ["002","003","004"];  //功能菜单编码
            function show(a)
            {
                var jsonStr = "["+a+"]";
               
                 jsonObj = eval(jsonStr);
                var len = jsonObj.length;
                var cell = null;
                var len2 = 0;
                var str = "";
               
                for(var i = 0;i<len;i++)
                {
                    if(jsonObj[i].name=="工艺")
                    {
                    
                        cell = document.getElementById("technics");
                        if(null == jsonObj[i].content) continue;
                        len2 = jsonObj[i].content.length;
                        if(len2>10)
                        {
                            len2 = 10;
                        }
                        for(var j = 0;j<len2;j++)
                        {   if(jsonObj[i].content[j].state=="正常" )
                            {
                                str = str + "<label  onclick='getValue(this, \"" + functionNos[0] + "\")' style='cursor:pointer;font-family:微软雅黑;'>"+jsonObj[i].content[j].name+"</label>";
                            }
                            else if (jsonObj[i].content[j].state == "异常") {
                                str = str + "<label onclick='getValue(this, \"" + functionNos[0] + "\")' style='color:red;cursor:pointer;font-family:微软雅黑;'>" + jsonObj[i].content[j].name + "</label>";//<img style='height:11px;' onclick='downLIst(this)' src='resource/img/sj_03.png' />
                               
                            }
                            else {
                                str = str + "<label onclick='getValue(this, \"" + functionNos[0] + "\")' style='color:rgb(250,179,9);cursor:pointer;font-family:微软雅黑;'>" + jsonObj[i].content[j].name + "</label>";//<img style='height:11px;' onclick='downLIst(this)' src='resource/img/sj_03.png' />
                                
                            }
                            if(j!=len2-1)
                            {
                                str = str+"<label style='cursor:pointer;font-family:微软雅黑;'>&nbsp;&nbsp;&nbsp;&nbsp;</label>";//竖线
                            }
                        }
                       
                        cell.innerHTML =str;
                         
                    }
                            else if(jsonObj[i].name=="设备")
                    {
                        cell = document.getElementById("device");
                        if(null == jsonObj[i].content) continue;
                        len2 = jsonObj[i].content.length;
                       // alert(len2);
//                        if(len2>5)
//                        {
//                            len2 = 5;
//                        }
                        str="";
                        for(var j = 0;j<len2;j++)
                        {   
                        
                          if(j%10==0&&j!=0)
                                {
                                    str = str+"<br />";
                                }
                            if(jsonObj[i].content[j].state=="正常")
                            {
                                str = str + "<label  onclick='getValue2(this, \"" + functionNos[1] + "\")' style='cursor:pointer;font-family:微软雅黑;'>"+jsonObj[i].content[j].name+"</label>";
                            }
                            else if (jsonObj[i].content[j].state == "异常") {
                                str = str + "<label onclick='getValue2(this, \"" + functionNos[1] + "\")' style='color:red;cursor:pointer;font-family:微软雅黑;'>" + jsonObj[i].content[j].name + "</label>";//<img style='height:11px;' onclick='downLIst(this)' src='resource/img/sj_03.png' />
                            }
                            else {
                                str = str + "<label  onclick='getValue2(this, \"" + functionNos[1] + "\")' style='color:rgb(250,179,9);cursor:pointer;font-family:微软雅黑;'>" + jsonObj[i].content[j].name + "</label>";
                            }
                            if(j!=len2-1)
                            {
                                str = str+"<label style='cursor:pointer;font-family:微软雅黑;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>";
                            }
                        }
                        if(len2>0){
                        cell.innerHTML =str;
                        }
                    }
                    else if(jsonObj[i].name=="报警")
                    {
                        
                        cell = document.getElementById("Alarmcount");
                        if (null == jsonObj[i].content) {
                            var InsertTable = document.getElementById("Alarmtable");
                            for (var j = 0; j < 3; j++) {
                                var newRow = InsertTable.insertRow();
                            }
                            continue;
                        }
                        len2 = jsonObj[i].content.length;
                        if(1 <= len2){
                            if(undefined != document.documentMode){ //ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 9px; right: 4px;'>"+ len2 + "个</span>";   
                            }else{  //非ie浏览器
                                cell.innerHTML = "<span style='position: absolute; top: 11px; right: 6px;'>"+ len2 + "个</span>";
                            }
                            
                            cell.style.display = "";
                        }
                         if(len2>3)
                        {
                            len2 = 3;
                        }
                        str="";
                        var InsertTable=document.getElementById("Alarmtable");
                        for(var j = 0;j<3;j++)
                        {   
                            if(j<len2){
                                var dataCell = jsonObj[i].content[j];
                                var innerTR = '<tr style="height: 22px;"><td nowrap="nowrap">'+ dataCell.num +'</td><td nowrap="nowrap">'+ dataCell.item +'</td><td nowrap="nowrap">'+ dataCell.value +'</td><td nowrap="nowrap">'+ dataCell.value +'</td><td nowrap="nowrap">'+ dataCell.startTime +'</td></tr>';
                                $("#Alarmtable tbody").append(innerTR);
                            }
                            else{
                                var innerTR = '<tr style="height: 22px;"><td></td><td></td><td></td><td></td><td></td></tr>';
                                $("#Alarmtable tbody").append(innerTR);
                            }
                        }
                        
                      }
                    else if(jsonObj[i].name=="质量分析")
                    {
                        if(null == jsonObj[i].content) continue;
                        len2 = jsonObj[i].content.length;
                        if(len2>3)
                        {
                            len2 = 3;
                        }
                        str="";
                        var InsertTable=document.getElementById("quality");
                        for(var j = 0;j<3;j++)
                        {
                            if(j<len2){
                                var dataCell = jsonObj[i].content[j];
                                var status = jsonObj[i].content[j].status;
                                if ("异常" == status) {
                                    status = "<span style='color:red'>" + dataCell.status + "</span>";
                                } else {
                                    status = status;
                                }
                                var innerTR = '<tr style="height: 22px;"><td nowrap="nowrap">'+ dataCell.num +'</td><td nowrap="nowrap">'+ dataCell.modelName +'</td><td nowrap="nowrap">'+ dataCell.projectName +'</td><td nowrap="nowrap">'+ dataCell.value +'</td><td nowrap="nowrap">'+ dataCell.units +'</td><td>' + status + '</td><td nowrap="nowrap">'+dataCell.time +'</td></tr>';
                                $("#quality tbody").append(innerTR);
                            }else{
                                var innerTR = '<tr style="height: 22px;"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                                $("#quality tbody").append(innerTR);
                            }
                        }
                    }
                }
            }
           
            tech = 0;
            //工艺
            function extend(obj) 
            {  
                tech++;
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
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"/>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js">
</script>
        <style type="text/css">
		    html, body, #chartContainer {
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
			    font-family:微软雅黑;
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
            font-family:微软雅黑;
           }
           #quality tr td{
            height:22px;
           }
           #Alarmtable
           {
               border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);
               height:91px;
           }
           #Alarmtable tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #Alarmtable tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            height:22px;
            font-family:微软雅黑;
           }
           
           #technics 
           {
               padding-top:3px; 
               border-top: solid 1px rgb(225,224,228);
               border-left: solid 1px rgb(225,224,228);
               border-right: solid 1px rgb(225,224,228);
               width:99%; 
               height:91px; 
           }
           
           #device 
           {
               padding-top:3px; 
               text-align:center;
               font-size: 13px; 
               border-top: solid 1px rgb(225,224,228);
               border-left: solid 1px rgb(225,224,228);
               border-right: solid 1px rgb(225,224,228);
               width:803px; 
               height:91px; 
           }
           #span_alarm_head
           {
               font-size:12pt;font-family:微软雅黑; 
               width:100%; 
               text-align:center; 
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
 <body  style=" width:auto;text-align: center;">
       <!-- #include file="include_loading.aspx" --> 
       <table style="text-align:left;margin:0 auto auto 0; width: auto; height:31px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; " id="table0">
            <tr style="border-collapse:collapse; border-spacing:0px 0px;">
                <td style="; height:31px; text-align:center; font-size:15px; font-weight: 700;" > 
                &nbsp;&nbsp; <%=plantName %> &nbsp;&nbsp;                           
                </td>
            </tr>
        </table>
           <table border="0" cellpadding="5" cellspacing="0" style="width:auto;text-align:center;margin-left:auto ; margin-right:auto; border-collapse:collapse; border-spacing:0px 0px;" >
           
           <tr>
           <td id="td" style="height: auto; width: auto;">
			<table style="text-align:center;margin-left:auto ; margin-right:auto; padding:0px; border-collapse:collapse; border-spacing:0px 0px; border: solid 1px rgb(225,224,228); height:131px; width:965px;" id="table2">
                <tr style=" border-collapse:collapse; border-spacing:0px 0px;  padding:0px;">
                     <td  style="width:150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;"> 
                        <img src='../resource/img/plantMain/gyjc.png'  onclick="imgClick('<%=plantId %>', '002')"  alt="工艺" style="width: 116px; height: 115px; cursor:pointer" id="IMG1"  /></td>
                     <td  style="text-align:left; width: 250px; vertical-align:top;text-align:center; border-collapse:collapse; border-spacing:0px 0px; padding:0px; " >
                         <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246); padding:0px; height:30px; vertical-align:middle;line-height:180%;">
                            运行状态</div>
                          <div id="technics">
                           </div>  
                           <div class="span_bottom_5"></div> 
                     </td>
                     <td style="font-size:12pt; font-family: 微软雅黑; text-align:center; vertical-align:top; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246);  padding:0px; height:30px; vertical-align:middle;line-height:180%;">
                            <label style="width:100%; height:100%; vertical-align:middle">质量分析</label>
                        </div>
                                               
                        <table  id="quality"  style="text-align:center; height:91px; display: inline; white-space:normal; width:570px;border-collapse:collapse; border-spacing:0px 0px; table-layout:fixed;">
                            <tr style="background-image:url(../resource/img/plantMain/tab_top_bg.gif); height:25px; background-repeat:repeat-x; border-collapse:separate; border-top: solid 1px; border-bottom: solid 1px;">
                                <th style="width: 40px; font-family: 微软雅黑; text-align: center;  font-weight:normal;">
                                    序号</th>
                                <th style="width: 110px; font-family: 微软雅黑; text-align: center;  font-weight:normal;">
                                    样品名称</th>                                
                                <th style="width: 160px; font-family: 微软雅黑; text-align: center; font-weight:normal;">
                                    分析项目</th>
                                <th style="width: 60px; font-family: 微软雅黑;  text-align: center; font-weight:normal;">
                                    实时值</th>
                                <th style="width: 50px; font-family: 微软雅黑; text-align: center; font-weight:normal; ">
                                    单位</th>
                                <th style="width: 50px; font-family: 微软雅黑; text-align: center; font-weight:normal; ">
                                    状态</th>
                                <th style="width: 140px; font-family: 微软雅黑;  text-align: center; border-right:  0px; font-weight:normal; ">
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
            <table style="text-align:center;margin-left:auto ; margin-right:auto; width: auto; width: 965px; border-collapse:collapse; border-spacing:0px 0px; border: solid 1px rgb(225,224,228);" id="table3">
                <tr>
                    <td style="text-align:left;width:150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;"> 
                        <img src='../resource/img/plantMain/sbjc.png'  onclick="imgClick('<%=plantId %>', '003')"  alt="设备" style="width: 116px; height: 116px; cursor:pointer" />
                        </td>
                    <td style="text-align:left; height: 14px;vertical-align:top; padding:0px;" >
                        <div style="font-size:12pt;font-family:微软雅黑; width:100%; background-color: RGB(246,246,246);  padding:0px; height:30px; vertical-align:top; text-align:center;;line-height:180%;">
                            运行状态</div>
                            
                        <div id="device"></div>
                        <div class="span_bottom_5"></div> 
                    </td>
                    <td style="width:10px;background-color: RGB(246,246,246); border:0px;"></td>
                </tr>
            </table>
             <br />
            
            
            <table  id="table4" style="text-align:center;margin-left:auto ; margin-right:auto; width: auto; height:116px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                <tr  style="border: solid 1px rgb(225,224,228);">
                    <td rowspan="2" style="text-align:left; width: 150px; height:auto; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                        <img  src='../resource/img/plantMain/bjfx.png'  onclick="imgClick('<%=plantId %>', '004')"  alt="报警" style="width: 116px; height: 116px; cursor:pointer" />
                        <label style="font-size:small;color:White; font-family: 微软雅黑; width:41px; height: 41px; position:absolute; right:15px; top:8px; display:none; cursor:pointer; background-image: url(../resource/img/mainPage/showAlarmNum.png); "  onclick="imgClick('<%=plantId %>', '004')"  id="Alarmcount" ></label>
                    </td>
                    <td style="text-align: left; font-family: 微软雅黑;padding:0px; vertical-align:top;" >
                        <div id="span_alarm_head">
                            <label style="width:100%; height:100%; vertical-align:middle">报警分析</label>
                        </div>
                        <table  id="Alarmtable"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                            <tr style="background-image:url(../resource/img/plantMain/tab_top_bg.gif);background-repeat:repeat-x; padding:0px; height: 25px; ">
                                <th style="width: 15%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                    序号</th>
                                <th style="width: 25%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                    位号</th>
                                <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                    值</th>
                                <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px; ">
                                    状态</th>
                                <th style="width: 20%; font-family: 微软雅黑; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                    开始时间</th>
                            </tr>
                        </table>
                        <div class="span_bottom_5"></div> 
                    </td>
                    <td style="width:10px;background-color: RGB(246,246,246); "></td>
                </tr>
                
                
                </table>
                </td>
                </tr>
            </table> 
 </body>
</html>
<script type="text/javascript">
var jsonStr = '<%=jsonStr %>';

if("" != jsonStr){
    show(jsonStr);
}

var functionNos = "<%=functionNos %>"
var functionNo = 0;
if (-1 != functionNos.indexOf('002')) {
    $("#table2").show();
    functionNo++;
}
if (-1 != functionNos.indexOf('003')) {
    $("#table3").show();
    functionNo++;
}
if (-1 != functionNos.indexOf('004')) {
    $("#table4").show();
    functionNo++;
}

parent.window.document.all("iframe<%=plantId %>").height = functionNo * 178 + 48;

function imgClick(plantId, functionNo) {
    parent.parent.window.clickFunction(plantId, functionNo);
}

function refreshData() {
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
        if (0 != index)
            $(this).remove();
    })
}

function intervall() {
    window.setInterval("refreshData()", 15000);
}

intervall();

if(undefined != document.documentMode){
    if (document.documentMode >=10) // IE8
    {
        $("#technics").css("height", "87px");
    }else if (document.documentMode == 9) // IE8
    {
        $("#technics").css("height", "96px");
    }else{
        $("#technics").css("height", "91px");
    }
}else{
    $("#technics").css("height", "87px");
}

</script>
