<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default1.aspx.cs" Inherits="_Default" %>
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
        #a_out {text-decoration:none; color:black;}
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
            //document.getElementById("main-region").src = "aspx/plants_main_frame.aspx?plantIds=" + plants;
            document.getElementById("main-region").src = "aspx/main_page.aspx?plantId=" + plants;
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
                <td style=""></td>
                <td id="img_head_right" style="width:325px; height:106px; z-index : 2;  background :no-repeat; background-image:url(./resource/img/mainPage/head_bg_right.png); background-position:left center "></td>
            </tr>
		</table>
		<div class="blackandwhite" style="position:absolute; width: 340px; height: 36px; font-size:22px;  left: 97px; float: left;z-index:1; top:30px">
	        石化装置安全运行监测与指导系统

	    </div>
		<div id="menutools1" style="background :no-repeat right center;position: absolute; z-index:2; width:100%; height:49px; top:60px; padding:0px;border:0px solid #ddd;margin: auto;text-align:right; ">
		   <%--<div id="Div1" style="width: auto; height: 36px; margin-top: 4px; right: 275px;  z-index:110;position:absolute; text-align: center">--%>
           <table style="width:100%; height:49px;" cellpadding="0" cellspacing="0"><tr>
           <td style="background-image:url(resource/img/mainPage/function_bg_left.png);background-position:right;background-repeat:no-repeat;"></td>
           <td id="table_function_center_td" style=" background-image:url(resource/img/mainPage/function_bg_center.png);background-repeat:repeat-x;">  
		        <div id="big_div" style="width:100%; height: 36px; margin-top:0px; right:  275px; text-align: center">
		   		  
		            <table style="width:480px; height:28px; text-align:center; margin-top:0px;margin-left:20px;" id="table_function">
		                <tr>
    		                
		                </tr>
		            </table>
		        </div>
		     </td><td  style="background-image:url(resource/img/mainPage/function_bg_right.png);background-position:left;background-repeat:no-repeat; width:50px;"></td></tr>
		   </table>
		      <%--  <img src="resource/img/mainPage/function_bg1.png" style=" width:100%; height: 36px" />
		    </div>--%>
		     
	    </div>
	    <div id="menutools2" style="display:none ;background :no-repeat right center;position: absolute; z-index:2; width:100%; height:49px; top:60px;background-image:url(resource/img/mainPage/function_bg_small.png);  padding:0px;border:0px solid #ddd;margin: auto;text-align:right; ">
		   <div id="small_div" style="width: 520px; height: 36px; margin-top: 6px; right: 162px;  z-index:110;position:absolute; text-align: center">
		        <table style="width:420px; height:28px; text-align:center; margin-left:40px;" id="table_function_s">
		            <tr>
		                
		            </tr>
		        </table>
		    </div>
	    </div>
	     <div style="position:absolute; width: 330px; height: 28px; margin-top: 10px; left: 97px; float: left;z-index:121;top:60px">
		        <table style="width:100%; height:100%; text-align:left;">
		            <tr>
		                <td style="width:20%; height:100%;">
		                    <span style="font-size:13px;">
		                        <%=dateStr %>&nbsp;&nbsp;&nbsp;&nbsp;你好：<%=((SysUser)Session[CommonStr.session_user]).userName%>&nbsp;&nbsp;|&nbsp;&nbsp;
		                        <a id="a_out"  href="javascript:userLogout()" onclick="userLogout()">退出</a>
		                    </span>
		                </td>
		            </tr>
		        </table>
		    </div>
	</div>
	
	<div data-options="region:'west'"  style="width:177px;  position:relative; height:100%; overflow:hidden; " border="false">
	    <iframe id="left_frame" name="left_frame" src="" style="overflow:hidden; position:absolute;" scrolling="no"  height="100%" width="170px" frameborder="0"></iframe>
	    <div id="leftRegionImg" isOpen="true" onclick="openOrHide(this)" style=" position:absolute; width:17px; height:100%; z-index : 2;left:161px; background :no-repeat; background-position:right center; background-image:url(./resource/img/mainPage/close.png); cursor:pointer;"></div>
	   
	</div>
	
	<div data-options="region:'center'" border="false" style="position:relative; height:100%;overflow:hidden;">
		<%--<div id="main-tabs" class="easyui-tabs" fit="true" border="false" style=" overflow:hidden;"></div> --%>
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
    $("#left_frame").attr("src", "aspx/tree_plant.aspx?plantId=<%=plantId %>"); 
}
changePlantItem("");

var arr = {"a":"b","b":"a"};
var hideElemType = ""; //当前点击的功能菜单的隐藏菜单项（分大菜单栏、小菜单栏）
var hideElemId = "";
var elemType = "";
var elemId ="";

if(undefined != document.documentMode){
    if (document.documentMode>=8) // IE8
    {
        $("#table_function").css("margin-left", "35px");
        $("#table_function_s").css("margin-left", "40px");
    }else{
        $("#table_function").css("margin-left", "15px");
        $("#table_function_s").css("margin-left", "-15px");
    }
}else{
    $("#table_function").css("margin-left", "35px");
    $("#table_function_s").css("margin-left", "40px");
}

//功能点击,页面不跳转

function functionClick(elem){
    elemType = elem.id.substring(0,1);
    hideElemType = arr[elemType];
    elemId = elem.id.substring(1,2);
    hideElemId = elemId;
    $("#table_function A").each(function (){    //其他功能项取消蓝色字体

        this.style.color = "white";
    });
     $("#table_function_s A").each(function (){    //其他功能项取消蓝色字体

        this.style.color = "white";
    });
    
    if(undefined != document.documentMode){
        if (document.documentMode>=8) // IE8
        {
           if("a" == elemType){    //大功能框
                var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-18;
                $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"});
            }else{
                var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-14;
                $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"});
            }
        }else 
        {
           if("a" == elemType){    //大功能框
                var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-13;
                $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x": offsetNum , "background-position-y":" 0"});
                
            }else{
                var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-13;
                $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum , "background-position-y":" 0"});
            }
        }  
    }else{
        if("a" == elemType){    //大功能框
            var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-18;
            $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"});
            
        }else{
            var offsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-14;
            $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"});
        }
    }
    
    elem.style.color = "rgb(219,232,38)";
    var otherElem = "#"+ hideElemType + elemId;
    $(otherElem).css("color", "rgb(219,232,38)");    
    
}


//功能点击
function function_click(elem){
    functionClick(elem) //选中功能样式变更  
    

    //功能跳转
    var url = "";
    if(-1 == elem.getAttribute("url").indexOf("?")){
        var url = elem.getAttribute("url") + "?plantId=" + document.all("div_plant").plantId; 
    }else{
        var url = elem.getAttribute("url") + "&plantId=" + document.all("div_plant").plantId; 
    }
    if(elem.getAttribute("menucode") == '009'){
        url += '&sys_menu_code=009';
    }
    showFunctionPage(url, elem.innerText); 
}


//左边装置是否隐藏
function openOrHide(elem){
    $('#layoutBody').layout('collapse','west');  
}

//功能跳转
function showFunctionPage(url){
    $("#main-region").attr("src", url);
}

//跳转到设备检测

function showDevicePage(url){
     $("#main-region").attr("src", url);
}

window.onresize = function (){
    try{
        //调整窗口图片
        setTimeout(resizeWindow,800);
        window.frames["main-region"].resize();
    }
    catch(exp){}
}

function resizeWindow(){
    var clientWidth = document.body.clientWidth;
    
    //控制顶部功能栏显示

    if(1165 >= clientWidth){
        $("#menutools2").show();
        $("#menutools1").hide()
        $("#img_head_right").width("235px");
        changeClickImg();
        
    }else{
        $("#menutools2").hide();
        $("#menutools1").show();
        $("#img_head_right").width("325px");
        changeClickImg();
    }
    
    //控制底部图片防止出现文字遮挡
    if(937 >= clientWidth){
        $("#bottom_large").css("display", "none");
        $("#bottom_small").css("display", "");       
    }else{
        $("#bottom_large").css("display", "");
        $("#bottom_small").css("display", "none");       
    }
}

function changeClickImg(){    //调整选中背景图片位置
    if("" == hideElemType) return ;
    var hideElem = "b" + hideElemId;
    var clickElem = "a" + elemId;
    var elem = document.getElementById(clickElem);
    var smallElem = document.getElementById(hideElem);
    
    if(undefined != document.documentMode){
        if (document.documentMode>=8) // IE8
        {
            
            var bigOffsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-18;
            $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":bigOffsetNum, "background-position-y":" 0"});
            
            var offsetNum = smallElem.parentNode.clientWidth/2 + smallElem.parentNode.offsetLeft + smallElem.parentNode.parentNode.offsetLeft-14;
            $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"});            
            
        }else{
            var bigOffsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-13;
            $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":bigOffsetNum , "background-position-y":" 0"});
            
            var offsetNum = smallElem.parentNode.clientWidth/2 + smallElem.parentNode.offsetLeft + smallElem.parentNode.parentNode.offsetLeft-13;
            $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum , "background-position-y":" 0"}); 
        }
    }else{
        var bigOffsetNum = elem.parentNode.clientWidth/2 + elem.parentNode.offsetLeft + elem.parentNode.parentNode.offsetLeft-18;
        $("#big_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":bigOffsetNum , "background-position-y":" 0"});
        
        var offsetNum = smallElem.parentNode.clientWidth/2 + smallElem.parentNode.offsetLeft + smallElem.parentNode.parentNode.offsetLeft-14;
        $("#small_div").css({"background":"url(./resource/img/mainPage/function_click_bg.png) no-repeat", "background-position-x":offsetNum, "background-position-y":" 0"}); 
    }
}

function changePlant(){
    $('#' + elemType + elemId).trigger("click");
}

resizeWindow();

//切换装置能见功能项

function changePlantItem(plantId){
    $.ajax({
        url: "./aspx/qry_plant_item_data.ashx?plantId=" + plantId,
        async: true,
        success: function (data){
            //debugger;
            var htmlstr = data.split('*');
            $("#table_function").children(0).empty().append(htmlstr[0]);
            var s = htmlstr[0]; 
            var re = new RegExp("<td","g");
            var arr = s.match(re);
            var l = (null==arr?0:arr.length);
            $("#table_function_center_td").css('width',(l*80+50)+'px');
            $("#table_function").css('width',(l*80)+'px');
            $("#table_function_s").children(0).empty().append(htmlstr[1]);
        }
    });
}



function userLogout(){
    document.forms[0].action = "Login.aspx";
    document.forms[0].submit();
}

function clickFunction(plantId, functionNo){
    document.frames["left_frame"].clickPlant(plantId, functionNo);//选中装置
    //document.all("div_plant").plantId = plantId;
    function_click($("[menuCode='" + functionNo+"']").get(0));
    
    
}

function showFunction(plantId, functionNo,url){
    window.frames["left_frame"].clickPlant(plantId, functionNo);//选中装置
    //document.all("div_plant").plantId = plantId;
    functionClick($("[menuCode='" + functionNo+"']").get(0));
    
    showFunctionPage(url);
}

////功能点击
function function_click_ZH(url, functionNo){
    functionClick($("[menuCode='" + functionNo+"']").get(0)); //选中功能样式变更  
    

    //功能跳转
//    var url = "";
//    if(-1 == elem.getAttribute("url").indexOf("?")){
//        var url = elem.getAttribute("url") + "?plantId=" + document.all("div_plant").plantId; 
//    }else{
//        var url = elem.getAttribute("url") + "&plantId=" + document.all("div_plant").plantId; 
//    }
    showFunctionPage(url); 
}

////功能跳转异常工况
function clickFunction_ZH(plantId, functionNo){
    function_click($("[menuCode='" + functionNo+"']").get(0));
}
</script>
