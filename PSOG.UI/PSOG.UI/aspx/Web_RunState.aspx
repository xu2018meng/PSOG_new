<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_RunState.aspx.cs" Inherits="aspx_Web_RunState" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html style="overflow:auto;" >
 <head>
   <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  <%
     String plantId = Request.QueryString["plantId"];
     String clickUnusual = Request.QueryString["clickUnusual"];
     String modelId = Request.QueryString["modelId"];
     modelId = null == modelId ? "" : modelId;
      %>
  <title></title>
 
<%--    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>--%>
        <script type="text/javascript">
        
            function GetValue(obj)
            {
                var tabName = "异常工况";
                var id = 'iframe_1';
                var value=obj.getAttribute("value")
                var url = 'aspx/web_unusual_condition.aspx?modelId=<%=modelId%>&plantId=<%=plantId%>&value='+value;
                try{
                if (!window.parent.$('#tabsDiv').tabs('exists', tabName)) {
                            parent.window.chartAddTab(id, tabName, url); 
                        }
                else {
                            window.parent.$('#tabsDiv').tabs('select', "异常工况"); 
                        }
                        //定时执 行，0.4秒后执行showalert()
                             window.setTimeout(function(){
                                            //window.parent.window.frames["iframe_1"].$('#tabsDiv').tabs('select', obj.getAttribute("value"));
                                        window.parent.window.frames["iframe_1"].$('#tabsDiv').tabs('select', obj.getAttribute("value"));
                             },500);
                             }catch(exp){}
                              
                      try{
               var arr = obj.id.split(',');
		       window.external.ShowDetail(arr[0],arr[1],obj.innerText);
		       }catch(exp){}
            }
              function GetValue1(obj)
            {
                var tabName = "异常工况库";
                var id = '3';
                var url = 'aspx/Web_RunState_ASDB.aspx?modelId=<%=modelId%>&plantId=<%=plantId%>';
                try{
                parent.window.chartAddTab(id, tabName, url); 
                }catch(exp){}
                   try{
              
		       window.external.ShowFullAbnormal();
		       }catch(exp){}
            }
           function test(a,b) 
            {
                //alert(a);
                arr = a.split(',');  
                var len = arr.length;
                var table = document.getElementById("tableid");
                var row = table.insertRow(-1);
                var j = 0;
                if(1 == len){   //没有的时候不显示表格线
                    document.all("table_showBorder").border="0";
                }
                for(var i = 0; i < len; i++)
                {
                    if(i!=0&&i%9==0)
                    {
                        var cell = row.insertCell(3);
//                        var str = "<input type='button' id='test' value='更多' style='cursor:pointer'  onclick='test2()'/>";
                          var str = "<table  style='margin-top:25px;margin-left:-7px'><td style='margin-top:15px'><a  id='test'onclick='test2()' href='####' style='text-decoration:underline; color:#0080FF;' ><font size='2px'  style='font-weight:100;'>更多..</font></a></td></table>";
                          
                        cell.innerHTML=str;
                        break;
                    }
                    if(i%3==0)
                    {
                        if(i==len-1)
                         {
                            break;
                         }
                        row.height="30";
                        var cell = row.insertCell(j);
                       
                        var nodeInfo = arr[i+2].split(":");
                        cell.innerHTML = "<input type='button' id='"+arr[i]+","+arr[i+1]+"' value='"+nodeInfo[0]+"' nodeId='" + nodeInfo[1] + "' style='background-color:AntiqueWhite;color:black;cursor:pointer;width:114px; border:1px solid #FF0000; line-height:300%;' border-color='#FF0000'; onclick='GetValue(this)'/>";
                       
                        j = j+1;
                    }
//                     cell.innerHTML="<input value='全部' type='button'style='background-color:Crimson;color:white;height:20px;;width:104px;cursor:pointer;' onclick='GetValue1()'/>";
                }
                var chart = document.getElementById("chart");
                chart.innerHTML = "<iframe id='iframe_00' name='iframe_00' frameborder='0' width='99%' src='" + b + "' height='490px' ></iframe>";
              // cache();
            }
            
            function test2() 
            {  
                var len = arr.length;
                var table = document.getElementById("tableid");
                table.firstChild.removeNode(true)
                var row = table.insertRow(-1);
                var j = 0;
                
                for(var i = 0; i < len; i++)
                {
                    if(i!=0&&i%9==0)
                    {
                        row = table.insertRow(-1);
                        j=0;
                    }
                    if(i%3==0)
                    {
                        if(i==len-1)
                         {
                            break;
                         }
                         var nodeInfo = arr[i+2].split(":");
                        row.height="30";
                        var cell = row.insertCell(j);
//                        cell.innerHTML = "<input type='button' id='"+arr[i]+","+arr[i+1]+"' value='"+arr[i+2]+"' style='background-color:AntiqueWhite ;color:white;height:20px;width:104px;cursor:pointer;padding-left:5px;' onclick='GetValue(this)'/>";
                          cell.innerHTML = "<input type='button' id='"+arr[i]+","+arr[i+1]+"' value='"+nodeInfo[0]+"' style='background-color:AntiqueWhite;color:black;cursor:pointer;width:114px; border:1px solid red;line-height:200%;border-color:Red;' onclick='GetValue(this)'/>";
                        j = j+1;
                    }
                                       
                }
              
            }
        </script>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <link type="text/css" rel="stylesheet" href="../resource/js/skin/WdatePicker.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"></script>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
        <script language="javascript" type="text/javascript" src="../resource/js/WdatePicker.js"></script>
        <link type="text/css" rel="stylesheet" href="../resource/css/calendar.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/FusionCharts.js"></script>
        <style type="text/css">
		    html,body, #chartContainer  {
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
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
            }
           
	    </style>
 </head>
 <body style="overflow:auto; ">
        <!-- #include file="include_loading.aspx" -->
        <table   border="0" cellpadding="0" cellspacing="0" width="100%" >
            <tr style="padding-top:10px">
                <td style="width:92%;">
                    <label style=" margin-left:26px;font-size:13px; font-family:微软雅黑">异常工况</label>
                     <table id="table_showBorder"  cellpadding="0" cellspacing="0" width="100%" style="margin-left:26px;margin-top:7px; border:1px solid gray; ">
                        <tr>
                            <td>
                                <table   border="0" cellpadding="10px"  style="padding-bottom:25px;padding-top:25px;padding-left:5px;padding-right:5px"  id="tableid" >
                                    
                                </table>
                                
                            </td>
                          <td>
                                <input onclick='GetValue1()' style='background-color: ForestGreen; color: white; border:none;
                                    height: 45px; width: 95px; cursor: pointer; background-image: url(../resource/img/ycgkk.png)'
                                    type='button' />
                            </td>
                        </tr>
                    </table>
                </td>
                <td  style="width:20%;">
                </td>
            </tr>
        </table>
       
       <div id="chart" style="width:auto;height:auto;">
            
        </div>


 </body>
</html> 
<script type="text/javascript">
window.onload = function (){
    test( '<%=dataStr[0] %>', '<%=dataStr[1] %>');
}

window.onerror = function (){return true;}
</script>
<%--为线形图表出现之前设置等待图标--%>
 <script type="text/javascript"> 
 var  setIntervalqdjxd;
 function cache()
 {
var a = document.getElementById("iframe_00"); 
var b = document.getElementById("load"); 
a.style.display = "none"; //隐藏 
b.style.display = "block"; //显示
//IE11去掉了监听事件
//a.onreadystatechange = function() { 
//if (this.readyState=="complete") { //最近才知道的。不然也写不出来。
////b.innerHTML = "load complete!"; 
//b.style.display = "none"; 
//a.style.display = "block"; 
//} 
//} 
 setIntervalqdjxd=setInterval("startRequestjxd()", 1000);
 
}
function startRequestjxd()
 {
       var a = document.getElementById("iframe_00"); 
       var b = document.getElementById("load"); 
      // alert(document.getElementById("iframe_00").readyState);//
     if (document.getElementById("iframe_00").readyState=="complete") { //最近才知道的。不然也写不出来。
    
     b.style.display = "none"; 
     a.style.display = "block"; 
      window.clearInterval(setIntervalqdjxd) ;

    }
   }
   

</script>
