<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree_left_function.aspx.cs" Inherits="aspx_tree_left_function" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="PSOG.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <% 
       string clickProcess = Request.QueryString["clickProcess"];
           clickProcess = null == clickProcess ? "" : clickProcess;
           String plantId = Request.QueryString["plantId"];
           plantId = null == plantId ? "" : plantId;
           String functionNos = Request.QueryString["functionNos"];
           functionNos = null == functionNos ? "" : functionNos; 
             %>
    <title>功能菜单</title>    
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <style type="text/css">
       .menuClass{background:url(../resource/img/菜单头.jpg) repeat-x; width:172px; height:32px;margin-left:1px; }
       .treeHead{background:url(../resource/img/下_21.gif) no-repeat; width:172px; height:32px; cursor:pointer; }
       .treeLeaf{background:  no-repeat; width:172px; height:32px; cursor:pointer;}
       .treeLeafText{position:relative ;left:40px; top:10px;}
    </style>
</head>
<body  style="margin:0px; padding:0px;width:100%; height:100%; font-size:12px; ">
    <form id="form1" >
    <div style="margin:0px; padding:0px; width:100%; height:100%;">
        <div id="Div1" class="menuClass"></div>
        <% for (int i = 0, size = functionList.Count; i < size; i++)
           { 
               FunctionNode node = functionList[i];
               if ("002001" == node.functionCode)
               {
               %>
                <div id="processState" class="treeHead" onmousedown="headMouseDown(this)">
                    <span style="position:relative ;left:25px; top:10px;"><%=node.functionName %></span></div>
                    <%  int j = 1;
                        foreach (Equipment bo in list)
                        {
                            string title = bo.monitorObject_Name;
                    %> 
                <div id="Div5" pid="processState" class="treeLeaf" url='<%="./web_run_state_main.aspx?modelId="+bo.id + "&plantId=" + plantId %>' isClick="false" onmouseover="leafMouseover(this)" onmousedown="leafMouseDown(this)" onmouseout="leafMouseOut(this)">
                    <span class="treeLeafText"><%=title%></span></div>
                    <%
                  }%>
               <%}else{ %>
               <div id='<%="Div"+i %>' class="treeHead" url="<%=node.functionUrl %>?plantId=<%=plantId %>&sys_menu_code=<%=node.functionCode %>" onmousedown="headMouseDown(this)">
            <span style="position:relative ;left:25px; top:10px;"><%=node.functionName %></span>
               </div>
        <%
            }
        } %>
    
    </form>
</body>
</html>
<script type="text/javascript">
var clickUnusualImgName = ""; //当前点击项的异常图
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
    e.setAttribute("isClick", "true");
    
    e.style.background = "url('../resource/img/dj.gif')";
    
    showFunctionPage(e.getAttribute("url")+"&clickUnusual=" + clickUnusualImgName);
    clickUnusualImgName = "";
}
function leafMouseOut(e){
    if("false" == e.getAttribute("isClick"))
        e.style.background = "";
}

/* 根节点事件 */
function headMouseDown(e){
    $(".treeHead").each(function (){
        this.children[0].style.color = "black";
    })
    var qryNodeStr = "div#" + e.getAttribute("id") ;
    if(-1 != e.style.background.indexOf("合.gif")){
        $(qryNodeStr).nextUntil(".treeHead").show();
        e.style.background = "url('../resource/img/下_21.gif')";
    }else{
        $(qryNodeStr).nextUntil(".treeHead").hide();
        e.style.background = "url('../resource/img/合.gif')";
    }
    e.children[0].style.color = "rgb(254,187,88)";
    showFunctionPage(e.getAttribute("url"));
}

//根据功能选中具体某项
function clickFunction(clickText, clickUnusual){
    $(".treeLeaf").each(function (){
        if(clickText == $(this).children().eq(0).text()){
            if(undefined != clickUnusual) clickUnusualImgName = clickUnusual;
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
