<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default_new2.aspx.cs" Inherits="_Default_new" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <link href="./resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="./resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="./resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="./resource/jquery/easyui/jquery.easyui.min.js"></script>
    <title>石化装置安全运行监测与指导系统</title>
    <style type="text/css">
        .psog_function {text-decoration:none; color:white; font-size:14px; blr:expression(this.onFocus=this.blur()); }
        #table_function a { outline: none; } 
        #table_function_s a { outline: none; } 
        .a {text-decoration:none; color:white;}
        .blackandwhite{
	        font-family: '微软雅黑';
	        color: black;
	        text-align: left;
        }
        .sizscolor {
            font-family: '微软雅黑';
            position:absolute;
            padding:1px;
            font-weight:500;
            filter:glow(color=white,strength=1)
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
       html, body {font-family: '微软雅黑'; width:100%; height:100%; margin:0px; padding:0px;} 
    </style>
    <%
        String plantId = Request.Params["plantId"];
        plantId = null == plantId ? "" : plantId;
        
     %>
     <script type="text/javascript">
     //显示多装置主页

        function showPlantsPage(plants){
            document.getElementById("main-region").src = "aspx/main_page_new.aspx?plantId=" + plants;
        }
     </script>
</head>
<body style="overflow:hidden"  id="layoutBody"  class="easyui-layout" fit="true" border="0">
    <form action="" method="post"  style="width:100%; height:100%;">
    <!-- #include file="./aspx/include_loading.aspx" -->
    <img alt="" src="./resource/img/mainPage/function_click_bg.png" style="display:none" /> <%-- 加载图片 --%>    
    <input id="div_plant" style="display:none" plantId="" realTimeDB="" historyDB=""/>
	<div data-options="region:'north',border:false" style="height:106px;padding:0px;vertical-align: bottom;overflow:hidden;">
	    
		<table style="width:100%;border-collapse:collapse; overflow:hidden;margin-top:-1px; background :no-repeat;height:106px; width:100%; z-index : 1; background-image:url(./resource/img/mainPage/head_bg.png) ;background-position:left center;background-size:100% 100%; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='./resource/img/mainPage/head_bg.png',sizingMethod='scale'); " >
            <tr>
               <td id="Td1" style="width:120px; height:106px; z-index : 2;  background :no-repeat; background-image:url(./resource/img/mainPage/sinopec.png); background-position:center center "></td>
                <td style=""></td>
                <td id="img_head_right" style="width:325px; height:106px; z-index : 2;  background :no-repeat; background-image:url(./resource/img/mainPage/head_bg_right.png); background-position:left center "></td>
            </tr>
		</table>
		<div class="blackandwhite" style="position:absolute; width: 340px; height: 36px; font-size:22px;  left: 120px; float: left;z-index:1; top:30px">
	        石化装置安全运行监测与指导系统

	    </div>
	     <div style="position:absolute; width: 460px; height: 28px; margin-top: 10px; right:90px; float: right;z-index:121;top:60px">
		        <table style="width:100%; height:100%; text-align:right;">
		            <tr>
		                <td style="width:70%; height:100%;">
		                    <span style="font-size:16px;color:White">
		                        <%=dateStr %>&nbsp;&nbsp;&nbsp;&nbsp;你好：<%=((SysUser)Session[CommonStr.session_user]).userName%>&nbsp;&nbsp;|&nbsp;&nbsp;
		                        <a id="a_set" class="a"  href="#" onclick="showSystemManagePage()">设置</a>&nbsp;&nbsp;
		                        <a id="a_change" class="a"  href="#" onclick="changeHomePage()">视图</a>&nbsp;&nbsp;
		                        <a id="a_out" class="a"  href="#" onclick="userLogout()">退出</a>
		                    </span>
		                </td>
		            </tr>
		        </table>
		    </div>
	</div>
	
	<div data-options="region:'west'"  style="width:210px;  position:relative; height:100%; overflow:hidden; " border="false">
	    <iframe id="left_frame" name="left_frame" src="" style="overflow:hidden; position:absolute;" scrolling="no"  height="100%" width="210px" frameborder="0"></iframe>
	    <div id="leftRegionImg" isOpen="true" onclick="openOrHide(this)" style=" position:absolute; width:17px; height:100%; z-index : 2;left:200px; background :no-repeat; background-position:right center; background-image:url(./resource/img/mainPage/close.png); cursor:pointer;"></div>
	   
	</div>
	
	<div data-options="region:'center'" border="false" style="position:relative; height:100%;overflow:hidden;">
		<%-- 主内容 aspx/main_page.aspx --%>
	    <iframe id="main-region" name="main-region" src=""  height="100%" width="100%"  frameborder="0"></iframe>	    
	</div>
	<div data-options="region:'south'" style="height:47px; overflow:hidden; background:url(./resource/img/mainPage/bottom_bg.png) repeat-x; background-position:0 0px; border:0px;">
	    <table id="bottom_large" style="width:100%; height:100%;border-collapse:collapse;border-spacing:0px;  z-index : 3; background-image:url(./resource/img/mainPage/bottom_middle.png); background-position:center 0px; background-repeat:no-repeat" > 
            <tr style="">
                <td id="img_bottom_left" style="width:323px;background :no-repeat; background-position:0 0px; height:47px; z-index : 1; background-image:url(./resource/img/mainPage/bottom_left.png)"></td>
                
                <td id="img_bottom_right" style="width:319px; height:47px; z-index : 2; float:right; background :no-repeat; background-position:right 0px; background-image:url(./resource/img/mainPage/bottom_right.png); "></td>
            </tr>
		</table>
		<table id="bottom_small" style="display:none; width:100%; height:100%; background:url(./resource/img/mainPage/bottom_left.png); background :no-repeat; background-position:left center;" > 
            <tr>
                <td style="width:100%; height:100%;  z-index : 3; background-image:url(./resource/img/mainPage/bottom_middle.png); background-position:center -3px; background-repeat:no-repeat"></td>
            </tr>
		</table>
	</div>
	</form>
</body>
</html>
<script type="text/javascript">
window.onload =function(){
    $("#left_frame").attr("src", "aspx/tree_plant_new.aspx"); 
}

//左边装置是否隐藏
function openOrHide(elem){
    $('#layoutBody').layout('collapse','west');  
}

//在主区域显示不同的页面
function showMainPage(id,type,name,tagDesc){
   if("main" == type){//点击主页
       var parentInfos = id.split("#");
       var plantId = parentInfos[1];
       document.getElementById("main-region").src = "aspx/main_page_new.aspx?plantId=" +plantId;
   }else if("bit" == type){//点击位号
       var parentInfos = id.split("#");
       var gzCode = parentInfos[2];
       if("bjgz" == gzCode){//报警规则
           document.getElementById("main-region").src = "aspx/alarm_survey_rule.aspx?id=" + parentInfos[0]+"&plantId="+parentInfos[3]+"&bitCode="+name+"&tagDesc="+tagDesc;
       }else if("yjgz" == gzCode){//预警规则
           document.getElementById("main-region").src = "aspx/prealarm_survey_rule.aspx?id=" + parentInfos[0]+"&plantId="+parentInfos[3]+"&bitCode="+name+"&tagDesc="+tagDesc;
       }else if("ycgz" == gzCode){//
           document.getElementById("main-region").src = "aspx/abnormal_survey_rule.aspx?id=" + parentInfos[0]+"&plantId="+parentInfos[3]+"&bitCode="+name+"&tagDesc="+tagDesc;
       }
   }else if("basemodal" == type){//根原因分析模型库
       var parentInfos = id.split("#");
       var plantId = parentInfos[1];
       document.getElementById("main-region").src = "aspx/Web_RunState_ASDB.aspx?plantId="+plantId;
   }else if("operator" == type){//操作质量
       var parentInfos = id.split("#");
       var plantId = parentInfos[1];
       document.getElementById("main-region").src = "aspx/operation_quality_analysis.aspx?plantId="+plantId;
      
   }else if("stmodal" == type){//状态监测模型库
       var parentInfos = id.split("#");
       var plantId = parentInfos[1];
       document.getElementById("main-region").src = "aspx/art_check_main.aspx?plantId="+plantId;
   }
}

//点击设置---展示系统管理页面
function showSystemManagePage(){
   $("#main-region").attr("src", "aspx/sysman/sys_manage_main.aspx?parentMenuCode=007");
}

//切换
function changeHomePage(){
   window.location = "./Default.aspx";
}

//退出
function userLogout(){
    document.forms[0].action = "Login.aspx";
    document.forms[0].submit();
}

////根原因分析模型库的点击事件
function function_click_ZH(url, functionNo){
  $("#main-region").attr("src", "aspx/"+url);
}


</script>
