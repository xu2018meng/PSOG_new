<%@ Page Language="C#" AutoEventWireup="true" CodeFile="device_tree_function.aspx.cs" Inherits="aspx_device_tree_function" %>

<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections.Generic" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" >
    <title>功能菜单</title>
    <% 
       string clickProcess = Request.QueryString["clickProcess"];
       clickProcess = null == clickProcess ? "" : clickProcess;
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
    %>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <style type="text/css">
       .menuClass{background:url(../resource/img/菜单头.jpg) no-repeat; width:172px; height:32px; }
       .treeHead{background:url(../resource/img/下_21.gif) no-repeat; width:172px; height:32px; font-size:12px;}
       .treeLeaf{background:  no-repeat; width:172px; height:32px; font-size:12px;}
       .treeLeafText{position:relative ;left:40px; top:10px;}
    </style>
</head>
<body  style="margin:0px; padding:0px;width:100%; height:100%; ">
    <form id="form1" >
     <div style="margin:0px; padding:0px; width:173px; height:500px; overflow-y:auto;">
        <div id="Div1" class="menuClass"></div>
        <div id="processState" class="treeHead" onmousedown="headMouseDown(this)">
            <span style="position:relative ;left:25px; top:10px;">运行状态</span></div>
        <%  int i=1;
                foreach(Equipment bo in list){
                    string title = bo.monitorObject_Name;
            %>     
        <div id="treeLeaf<%=i++ %>" pid="processState" class="treeLeaf" url="<%="./web_run_state_main.aspx?modelId="+bo.id + "&plantId=" + plantId %>" isClick="false" onmouseover="leafMouseover(this)" onmousedown="leafMouseDown(this)" onmouseout="leafMouseOut(this)">
            <span class="treeLeafText"><%=title %></span></div>
         <%} %>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">

/* 叶子节点事件 */
function leafMouseover(e){
    e.style.background = "url('../resource/img/dj.gif')";
}
function leafMouseDown(e){
    var qryNodeStr = "div#" + e.getAttribute("pid") ;
    $(qryNodeStr).nextUntil(".treeHead").each(function (headCell){
        if(null != this.style.background && "" != this.style.background && -1 != this.style.background.indexOf("dj.gif") && this != e)
            this.style.background = "";
        this.setAttribute("isClick", "false");
    })
    e.setAttribute("isClick","true");
    e.style.background = "url('../resource/img/dj.gif')";
    
    showFunctionPage(e.getAttribute("url"));
}
function leafMouseOut(e){
    if("false" == e.getAttribute("isClick"))
        e.style.background = "";
}

/* 根节点事件 */
function headMouseDown(e){
    var qryNodeStr = "div#" + e.getAttribute("id") ;
    if(-1 != e.style.background.indexOf("合.gif")){
        $(qryNodeStr).nextUntil(".treeHead").show();
        e.style.background = "url('../resource/img/下_21.gif')";
    }else{
        $(qryNodeStr).nextUntil(".treeHead").hide();
        e.style.background = "url('../resource/img/合.gif')";
    }
    
    showFunctionPage(e.getAttribute("url"));
}

//根据功能选中具体某项
function clickFunction(clickText){
    $(".treeLeaf").each(function (){
        if(clickText == $(this).children().eq(0).text()){
            leafMouseDown(this);
            return false;
        }
    })
}

//选择某项功能
function showFunctionPage(url){

    if(null != url || "" != url)
        parent.window.showFunction(url);
}

var clickProcess = "<%=clickProcess %>";
//初始访问页面
if("" != clickProcess){
    clickFunction(clickProcess);
}

window.onerror =function (){return true;};
</script>

