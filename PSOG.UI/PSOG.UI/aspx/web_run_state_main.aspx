<%@ Page Language="C#" AutoEventWireup="true" CodeFile="web_run_state_main.aspx.cs" Inherits="aspx_web_run_state_main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <% 
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
       String modelId = Request.QueryString["modelId"];
       modelId = null == modelId ? "" : modelId;
       String clickUnusual = Request.QueryString["clickUnusual"];
       clickUnusual = null == clickUnusual ? "" : clickUnusual;  %>
    <title>设备状态</title>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
<%--     <script language="javascript" type="text/javascript" src="../resource/js/jquery-1.6.2.min.js"></script>--%>
    <script  type="text/javascript"src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>
<body>
    <!-- #include file="include_loading.aspx" -->
    <div id="tabsDiv" class="easyui-tabs" fit="true" style="width:100%; height:100%">
        <div title="运行状态" style="padding:10px" >
            <iframe id="iframe_0" src=""  height="100%" selected="true" width="100%" frameborder="0"></iframe>
        </div>
        <div id="unusual_div" title="异常工况" closable="true" style="padding:10px; " hide="true">
            <iframe id="iframe_1" src=""  height="100%" width="100%" frameborder="0"></iframe>
        </div>
        <%-- <div id="Div1" title="异常工况库" closable="true"  style="padding:10px; " hide="true" >
            <iframe id="iframe_2" src=""  height="100%" width="100%" frameborder="0"></iframe>
        </div>--%>
    </div>
</body>
</html>
<script type="text/javascript">
window.onerror=function(){};
document.all("iframe_0").src = './Web_RunState.aspx?modelId=<%=modelId%>&plantId=<%=plantId%>' ;



$('#tabsDiv').tabs({   
    
    onSelect:function(title){  
    if(title=="异常工况"){
    //alert(title+' is selected'); 
    document.all("iframe_1").src = './web_unusual_condition.aspx?modelId=<%=modelId%>&plantId=<%=plantId%>'; 
      } 
      }   
}); 
   
function selPrivateTab(title, index){
    if("" == $('#iframe_' + index).attr("src")){
        $('#iframe_' + index).attr("src", $('div > [title]').eq(index).attr("src"));
    }
}

var clickUnusual = '<%=clickUnusual %>';

//添加tab页var ycTabId = "";
function chartAddTab(id, tabName, url) {
    ycTabId = id;
    if (!$('#tabsDiv').tabs('exists', tabName)) {
        $('#tabsDiv').tabs('add', {
            title: tabName,
            content: '<iframe id="i' + id + '" name="i' + id + '"  style="width:100%; height:99%;" src="' + url + '"  frameborder="0"  border="0" ></iframe>',
            closable: true,
            fit: true
        });
    } else {
        $('#tabsDiv').tabs('select', tabName);
    }
}

//根原因分析模型库的点击事件
function function_click_ZH(url, functionNo){
 // $("#i"+ycTabId).attr("src", url);
}

</script>
