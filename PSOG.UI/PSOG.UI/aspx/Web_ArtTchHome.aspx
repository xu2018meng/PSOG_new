<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_ArtTchHome.aspx.cs" Inherits="aspx_Web_ArtTchHome" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
 <head>
 <% 
    String plantId = Request.QueryString["plantId"];   //实时库
    plantId = null == plantId ? "" : plantId;
     %>
  <title></title>
    <style type="text/css">
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
        <script type="text/javascript">
             function switchTab(ProTag, ProBox) {
                for (i = 1; i < 3; i++) {
                    if ("tab" + i == ProTag) {
                        document.getElementById(ProTag).getElementsByTagName("a")[0].className = "on";
                    } else {
                        document.getElementById("tab" + i).getElementsByTagName("a")[0].className = "";
                    }
                    if ("con" + i == ProBox) {
                        document.getElementById(ProBox).style.display = "";
                    } else {
                        document.getElementById("con" + i).style.display = "none";
                    }
                }
            }

            function GetValue(obj)
            {
               
            }
            function getValue2(obj)
            {  
               try{var n=obj["value"];
                    if(obj.innerText==null||obj.innerText==""){
                        window.parent.window.showFunctionPage("./Web_RunState.aspx?plantId=<%=plantId %>&clickProcess="+obj["value"], obj["value"]);
                        return;
                    }
                    window.parent.window.showFunctionPage("./Web_RunState.aspx?plantId=<%=plantId %>&clickProcess="+obj.innerText, obj.innerText);
                }catch(exp)
                {}
                
               try{
                   if(obj.innerText==null||obj.innerText==""){ window.external.leftButton(obj["value"]);return;}
		           window.external.leftButton(obj.innerText);//点击按钮
		       }catch(exp)
		       {}
            }
            function getValue3(obj)
            {
                try{
               var arr = obj.id.split(',');
		       window.external.ShowDetail(arr[0],arr[1],obj.innerText);
		       }catch(exp){}
		       
		       try{
                    window.parent.window.showFunctionPage("./Web_RunState.aspx?plantId=<%=plantId %>&clickProcess="+obj["clickText"]+"&clickUnusual=" + obj["value"], obj["clickText"], obj["value"]);
                    
                }catch(exp)
                {}
            }
           function show(a)
            {
                 var jsonStr = a;
                var jsonObj = eval(jsonStr);
                
                var len = jsonObj.length;
                var tableStr = "<tr>";    
                var j = 0;
                for(var i = 0; i < len; i++)
                {
                    if(i!=0&&i%3==0)
                    {
                        tableStr += "</tr><tr>";  
                        j=0;
                    }
                    
                    
                    if(jsonObj[i].state=="正常")
                    {
                        var str = "<table ><tr height='20'><td><img src='../resource/img/green.png' onclick='getValue2(this)' value='"+jsonObj[i].name+"'  style='height:40px;width:40px;cursor:pointer' alt='' /> <label style='color:green;cursor:pointer'  value='"+jsonObj[i].name+"' onclick='getValue2(this)'>"+jsonObj[i].name +"</label></td></tr><tr><td><label style='color:"+"green"+"'>运行状态："+"正常"+"</label></td></tr><tr height='20'><td>异常状况：<label>"+"无"+"</label></td></tr></table>";
                        tableStr += "<td style='height: auto; vertical-align: top;'>" + str + "</td>";
                    }
                    else if(jsonObj[i].state=="异常")
                    {
                        var str2 ="<table ><tr height='20' ><td ><img src='../resource/img/red.png' onclick='getValue2(this)'  value='"+jsonObj[i].name+"' style='height:40px;width:40px;cursor:pointer' alt='' /> <label style='color:red;cursor:pointer'  value='"+jsonObj[i].name+"' onclick='getValue2(this)'>"+jsonObj[i].name +"</label></td></tr><tr><td><label style='color:"+"red"+"'>运行状态："+"异常"+"</label></td></tr><tr height='20'><td>异常状况：<label></label></td></tr>";
      
                        var len2 = jsonObj[i].exc.length;
              
                        for(var k=0;k<len2;k++)
                        {
                            str2 =str2+ "<tr height='20'><td><label id='"+jsonObj[i].exc[k].twoID+"' clickText='"+jsonObj[i].name+"' value='"+jsonObj[i].exc[k].Text+"' onclick='getValue3(this)' style='color:red;cursor:pointer'>"+jsonObj[i].exc[k].Text+"</label></td></tr>";
                            
                        }
                        
                        str2 =str2+ "</table>";
                       tableStr += "<td style='height: auto; vertical-align: top;'>" + str2 + "</td>";
                       
                    }
                    else if (jsonObj[i].state == "预警") {
                        var str = "<table ><tr height='20'><td><img src='../resource/img/yellow.png' onclick='getValue2(this)' value='" + jsonObj[i].name + "'  style='height:40px;width:40px;cursor:pointer' alt='' /> <label style='color:rgb(250,179,9);cursor:pointer'  value='" + jsonObj[i].name + "' onclick='getValue2(this)'>" + jsonObj[i].name + "</label></td></tr><tr><td><label style='color:" + "rgb(250,179,9)" + "'>运行状态：" + "预警" + "</label></td></tr><tr height='20'><td>异常状况：<label>" + "无" + "</label></td></tr></table>";
                        tableStr += "<td style='height: auto; vertical-align: top;'>" + str + "</td>";
                    }
                    else
                    {
                        alert("数据有误！");
                    }
                    j = j+1;
                    
                }
                
                $("#tableid").append(tableStr+"</tr>");
            }
           function test(a,b) 
            {
                    
                
            }
            function test2() 
            {  
              
            }

                //初始化列表样式
	        function initTableStyle() {
		        $(".scTable tr:odd").css("background", "#eef9ff");
		        $(".scTable tr:odd input").css("background", "#eef9ff");
		        $(".scTable tr:even").css("background", "#ffffff");
		        $(".scTable tr:even input").css("background", "#ffffff");
	        }
        </script>
        <link href="../resource/css/mycss.css" rel="stylesheet" type="text/css" />
        <link type="text/css" rel="stylesheet" href="../resource/css/Style.css" />
        <script language="javascript" type="text/javascript" src="../resource/js/jquery.js"></script>
         <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>
        <style type="text/css">
		    html, body, #chartContainer {
			    width: 100%;
			    height: 98%;
			    padding: 0;
			    margin: 0;
		    }
            .scTable {
            border:1px #bebfbf solid;
            }
	        .scTable th {
		        background: #cfe3dc;
		        padding:6px;
		        border:1px #bfcfda solid;
		        font-weight: normal;
	        }
	        .scTable td {
				        border:1px #bfcfda solid;
		        text-align: center;
	        }
	        .scTable td a {
		        text-decoration: underline;
		        cursor: pointer;
	        }
	         #tabContainer
                {
                    margin: 5px;
                }
                #tabContainer li
                {
                    float: left;
                    width: 80px;
                    margin: 0 0px;
                   
                    text-align: center;
                }
                body{font-size:13px;}
                table{font-size:12px;}
	    </style>
	<script type="text/javascript"  src="../resource/chartjs/AnyChart.js"></script>
 </head>
 <body>
         <div style="padding:10 0 0 20;font-family:微软雅黑;">工艺监测总览</div> 
        <table border="0" cellpadding="0" style="padding-top:30;padding-right:20;padding-bottom:20;padding-left:60;;margin-left:auto;margin-right:auto"  cellspacing="0" width="90%" id="tableid"  >
        
        </table>
 </body>
</html>
<script type="text/javascript">
show('<%=dataJson %>');
</script>