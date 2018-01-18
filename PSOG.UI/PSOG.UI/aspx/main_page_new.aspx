<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main_page_new.aspx.cs" Inherits="aspx_main_page_new" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html >
 <head>
    <% 
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
        %>
  <title>Ö÷Ò³</title>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"/>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
         <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
         <script type="text/javascript" src="../resource/js/highcharts.js"></script>
        <script type="text/javascript" src="../resource/js/highcharts-more.js"></script>
        <script type="text/javascript">
           
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
                    if(jsonObj[i].name=="±¨¾¯¼à²â")
                    {
                       //Çå¿ÕÊý¾Ý
                       $('#Alarmtable tr').each(function (index) {
                            if(0 != index)
                                $(this).remove();
                        })
                        
                        if (null == jsonObj[i].content) {
                            var InsertTable_AS = document.getElementById("Alarmtable");
                            for (var j = 0; j < 3; j++) {
                                var newRow_1 = InsertTable_AS.insertRow();
                            }

                        }else{
                            len2 = jsonObj[i].content.length;
                            if(len2>3)
                            {
                                len2 = 3;
                            }
                            str="";
                            for(var j = 0;j<3;j++)
                            {   
                                if(j<len2){
                                    var dataCell = jsonObj[i].content[j];
                                    var innerTR = '<tr style="height: 22px;"><td nowrap="nowrap">'+ dataCell.alarmId +'</td><td nowrap="nowrap"><a href="#" style="font-weight:normal;" onclick="turnToAlarmRulePage(\''+dataCell.alarmRuleId+'\',\''+dataCell.alarmBitNo+'\',\''+dataCell.alarmTagDesc+'\');">'+ dataCell.alarmBitNo +'</a></td><td nowrap="nowrap">'+ dataCell.alarmRealValue +'</td><td nowrap="nowrap">'+ dataCell.alarmStatus +'</td><td nowrap="nowrap">'+ dataCell.alarmType+'</td><td nowrap="nowrap">'+dataCell.alarmSustainTime+'</td><td nowrap="nowrap">'+ dataCell.alarmStartTime +'</td></tr>';
                                    $("#Alarmtable tbody").append(innerTR);
                                }
                                else{
                                    var innerTR = '<tr style="height: 22px;"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                                    $("#Alarmtable tbody").append(innerTR);
                                }
                            
                            }
                        }
                        
                    }
                    
                    
                    if(jsonObj[i].name=="Ô¤¾¯¼à²â")
                    {   
                        //Çå¿ÕÊý¾Ý
                         $('#EarlyAlarmtable tr').each(function (index) {
                            if(0 != index)
                                $(this).remove();
                         })
    
                        if (null == jsonObj[i].content) {
                            var InsertTable_AS = document.getElementById("EarlyAlarmtable");
                            for (var j = 0; j < 3; j++) {
                                var newRow_1 = InsertTable_AS.insertRow();
                            }

                        }else{
                            len2 = jsonObj[i].content.length;
                            if(len2>3)
                            {
                                len2 = 3;
                            }
                            str="";
                            for(var j = 0;j<3;j++)
                            {   
                                if(j<len2){
                                    var dataCell = jsonObj[i].content[j];
                                   var innerTR = '<tr style="height: 22px;"><td nowrap="nowrap">'+ dataCell.earlyAlarmId +'</td><td nowrap="nowrap"><a href="#" style="font-weight:normal;" onclick="turnToEarlyAlarmRule(\''+dataCell.earlyAlarmRuleId+'\',\''+dataCell.earlyAlarmBitNo+'\',\''+dataCell.earlyAlarmTagDesc+'\')">'+ dataCell.earlyAlarmBitNo +'</a></td><td nowrap="nowrap">'+ dataCell.earlyAlarmRealValue +'</td><td nowrap="nowrap">'+ dataCell.earlyAlarmStatus +'</td><td nowrap="nowrap">'+ dataCell.earlyAlarmType+'</td><td nowrap="nowrap">'+dataCell.earlyAlarmSustainTime+'</td><td nowrap="nowrap">'+ dataCell.earlyAlarmStartTime +'</td></tr>';
                                    $("#EarlyAlarmtable tbody").append(innerTR);
                                }
                                else{
                                    var innerTR = '<tr style="height: 22px;"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                                    $("#EarlyAlarmtable tbody").append(innerTR);
                                }
                            
                            }
                        }
                        
                    }
                    
                    if(jsonObj[i].name=="Òì³£¼à²â")
                    {
                         //Çå¿ÕÊý¾Ý
                         $('#AS_table tr').each(function (index) {
                            if(0 != index)
                                $(this).remove();
                         })
                        
                        if (null == jsonObj[i].content) {
                            var InsertTable_AS = document.getElementById("AS_table");
                            for (var j = 0; j < 3; j++) {
                                var newRow_1 = InsertTable_AS.insertRow();
                            }

                        }else{
                            len2 = jsonObj[i].content.length;
                            if(len2>3)
                            {
                                len2 = 3;
                            }
                            str="";
                            for(var j = 0;j<3;j++)
                            {   
                                if(j<len2){
                                    var dataCell = jsonObj[i].content[j];
                                    var innerTR = '<tr style="height: 22px;"><td nowrap="nowrap">'+ dataCell.abStateId +'</td><td nowrap="nowrap"><a href="#" style="font-weight:normal;" onclick="turnToStateRule(\''+dataCell.abStateRuleId+'\',\''+dataCell.abStateName+'\',\''+dataCell.abStateDesc+'\')">'+ dataCell.abStateName +'</a></td><td nowrap="nowrap">'+ dataCell.abStateStatus +'</td><td nowrap="nowrap">'+ dataCell.abStateUnit +'</td><td nowrap="nowrap">'+ dataCell.abStateMeter +'</td><td nowrap="nowrap">'+ dataCell.abStateSustainTime +'</td><td nowrap="nowrap">'+ dataCell.abStateStartTime +'</td></tr>';
                                    $("#AS_table tbody").append(innerTR);
                                }
                                else{
                                    var innerTR = '<tr style="height: 22px;"><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                                    $("#AS_table tbody").append(innerTR);
                                }
                            
                            }
                        }
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
			    font-family:Î¢ÈíÑÅºÚ;
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
            font-family:Î¢ÈíÑÅºÚ;
            }
          
           #Alarmtable
           {
               /*border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);*/
               height:110px;
           }
           #Alarmtable tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #Alarmtable tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            font-family:Î¢ÈíÑÅºÚ;
            height:20px;
           }
           
           #EarlyAlarmtable
           {
               /*border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);*/
               height:110px;
           }
           #EarlyAlarmtable tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #EarlyAlarmtable tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            font-family:Î¢ÈíÑÅºÚ;
            height:20px;
           }
           
           #AS_table
           {
               /*border-left: 1px solid rgb(225,224,228);
               border-right: solid 1px; border-right-color:rgb(225,224,228);*/
               height:110px;
           }
           #AS_table tr th{
            /* border-right: solid 1px; border-right-color:rgb(255,255,255); */
           }
           #AS_table tr td{
            border-top: solid 1px; border-top-color: rgb(225,224,228);
            font-family:Î¢ÈíÑÅºÚ;
            height:20px;
           }
           
           .span_bottom_5
           {
               height:23px;
               background-color: RGB(246,246,246);  
               border-top: solid 1px rgb(225,224,228);
               width:100%;
           }
           
	    </style>
 </head>
 <body>
       <!-- #include file="include_loading.aspx" --> 
       <div style="overflow:auto;padding-top:3px;margin-left:auto ; margin-right:auto;font-family:Î¢ÈíÑÅºÚ; text-align:center;">
          
           <table border="0" cellpadding="5" cellspacing="0" style="width:100%;text-align:center;margin-left:auto ; margin-right:auto; border-collapse:collapse; border-spacing:0px 0px;" >
               
               <tr>
                 <td>
                   <div style="font-size:x-large; color:Black;font-weight:700;font-family:ËÎÌå ">Òì&nbsp;³£&nbsp;ÊÂ&nbsp;¼þ&nbsp;Áª&nbsp;¶¯</div>
                 </td>
               </tr>
               <tr>
                 <td style="text-align:center; width: 100%;">
                   <div style="font-size:18px; color:Black; padding-left:26%;font-weight:600;font-family:ËÎÌå">---×Ô¶¨Òå´¥·¢Ìõ¼þ£¬ÊµÏÖÒì³£ÊÂ¼þ¶¨ÖÆÍÆËÍ</div>
                   <br />
                 </td>
               </tr>
               
               <tr>
                   <td style="text-align:center; width: 100%;">
                    <table  id="table4" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:110px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                                <div style="font-size:28px; color:#168dcd; font-family:Î¢ÈíÑÅºÚ;">±¨ ¾¯<br />¼à ²â</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: Î¢ÈíÑÅºÚ;padding:0px; vertical-align:top;" >
                                <div id="" style="display:none">
                                    <label style="width:100%; height:100%; vertical-align:middle">±¨¾¯·ÖÎö</label>
                                </div>
                                <table  id="Alarmtable"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                                    <tr style="height: 25px; background-repeat:repeat-x; padding:0px; width:100%; background-color: RGB(246,246,246);">
                                        <th style="width: 10%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÐòºÅ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            Î»ºÅ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÊµÊ±Öµ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ×´Ì¬</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÀàÐÍ</th>
                                        <th style="width:  15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ³ÖÐøÊ±¼ä(·ÖÖÓ)</th>
                                        <th style="width:  15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ¿ªÊ¼Ê±¼ä</th>
                                    </tr>
                                </table>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:15px;background-color: RGB(246,246,246); ">
                               <div style="padding-top:106px;">
                                <a href="./alarm_realTime_list.aspx?plantId=<%=plantId %>"><img src="../resource/img/homeMore.png" border="0"/></a>
                               </div>
                            </td>
                        </tr>
                        
                    </table>
                    
                    <br />
                    
                    
                     <table  id="table5" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:110px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                                <div style="font-size:28px; color:#168dcd; font-family:Î¢ÈíÑÅºÚ;">Ô¤ ¾¯<br />¼à ²â</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: Î¢ÈíÑÅºÚ;padding:0px; vertical-align:top;" >
                                <div id="Div3" style="display:none">
                                    <label style="width:100%; height:100%; vertical-align:middle">Ô¤¾¯¼à²â</label>
                                </div>
                                <table  id="EarlyAlarmtable"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                                    <tr style="height: 25px; background-repeat:repeat-x; padding:0px; width:100%; background-color: RGB(246,246,246);">
                                        <th style="width: 10%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÐòºÅ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            Î»ºÅ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÊµÊ±Öµ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ×´Ì¬</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÀàÐÍ</th>
                                        <th style="width:  15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ³ÖÐøÊ±¼ä(·ÖÖÓ)</th>
                                        <th style="width:  15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ¿ªÊ¼Ê±¼ä</th>
                                    </tr>
                                </table>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:15px;background-color: RGB(246,246,246); ">
                               <div style="padding-top:106px;">
                                <a href="./earlyAlarm_realTime_list.aspx?plantId=<%=plantId %>"><img src="../resource/img/homeMore.png" border="0"/></a>
                               </div>
                            </td>
                        </tr>
                    </table>
                    
                      <br />
                    
                    <table  id="table1" style="text-align:left;margin-left:auto ; margin-right:auto; width: auto; height:110px;width: 965px; border-collapse:collapse; border-spacing:0px 0px; padding:0px;">
                        <tr style="border: solid 1px rgb(225,224,228);">
                            <td rowspan="2" style="text-align:left; width: 150px; background-color: RGB(246,246,246); text-align:center; vertical-align:middle;padding:0px;position:relative;"> 
                             <div style="font-size:28px; color:#168dcd; font-family:Î¢ÈíÑÅºÚ;">Òì ³£<br />¼à ²â</div>
                            </td>
                            <td style="width:5px;background-color: Blue; "></td>
                            <td style="width:10px;background-color: RGB(246,246,246); "></td>
                            <td style="text-align: left; font-family: Î¢ÈíÑÅºÚ;padding:0px; vertical-align:top;" >
                                <div id="Div1" style="display:none">
                                    <label style="width:100%; height:100%; vertical-align:middle">Òì³£¼à²â</label>
                                </div>
                                <table  id="AS_table"  style="text-align:center; display: inline; border-collapse:collapse; border-spacing:0px 0px; width:100%; padding:0px; ">
                                    <tr style="height: 25px; background-repeat:repeat-x; padding:0px; width:100%; background-color: RGB(246,246,246);">
                                        <th style="width: 10%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ÐòºÅ</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            Òì³£¹¤¿ö</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            ×´Ì¬</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px; ">
                                            µ¥Ôª</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ¹ØÁªÒÇ±í</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ³ÖÐøÊ±¼ä(·ÖÖÓ)</th>
                                        <th style="width: 15%; font-family: Î¢ÈíÑÅºÚ; text-align: center; font-weight:normal; font-size:15px;  border-right:  0px;">
                                            ¿ªÊ¼Ê±¼ä</th>
                                    </tr>
                                </table>
                                <div class="span_bottom_5"></div>
                            </td>
                            <td style="width:15px;background-color: RGB(246,246,246); ">
                               <div style="padding-top:106px;">
                                <a href="./abnormal_realTime_list.aspx?plantId=<%=plantId %>"><img src="../resource/img/homeMore.png" border="0"/></a>
                               </div>
                            </td>
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
        url: "./main_page_data_new.aspx?random=" + Math.random(),
        async: true,
        type: "post",
        data: { plantId: '<%=plantId %>' },
        success: function (data) {
            //Çå¿ÕÊý¾Ý
           // clearData();

            //Õ¹ÏÖÊý¾Ý
            show(data);
        }
    })
}

function clearData() {
    $('#Alarmtable tr').each(function (index) {
        if(0 != index)
            $(this).remove();
    })
    
     $('#EarlyAlarmtable tr').each(function (index) {
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

//Ìø×ªµ½±¨¾¯¹æÔòÒ³Ãæ
function turnToAlarmRulePage(id,bitCode,tagDesc){
  window.location.href ="./alarm_survey_rule.aspx?id=" + id+"&plantId=<%=plantId %>&bitCode="+bitCode+"&tagDesc="+tagDesc;
}

//Ìø×ªµ½Ô¤¾¯¹æÔòÒ³Ãæ
function turnToEarlyAlarmRule(id,bitCode,tagDesc){
   window.location.href = "./prealarm_survey_rule.aspx?id=" + id+"&plantId=<%=plantId %>&bitCode="+bitCode+"&tagDesc="+tagDesc;
}

//Ìø×ªÖÁÒì³£¹æÔòÒ³Ãæ
function turnToStateRule(id,bitCode,tagDesc){
  window.location.href = "./abnormal_survey_rule.aspx?id=" + id+"&plantId=<%=plantId %>&bitCode="+bitCode+"&tagDesc="+tagDesc;
}

</script>