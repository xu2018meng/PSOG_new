<%@ Page Language="C#" AutoEventWireup="true" CodeFile="web_unusual_condition.aspx.cs" Inherits="aspx_web_unusual_condition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <% 
        String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
       String value = Request.QueryString["value"];
         %>
    <title>异常工况</title>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
</head>        
<body > 
 
    <div id="tabsDiv" class="easyui-tabs" fit="true" style="width:100%; height:100%;text-align:center;vertical-align:middle; " data-options="onSelect:selPrivateTab" onSelect="showPage('iframe_0')">
        <% for (int i = 0, size = AbnormalList.Count; i < size; i++)
           {
               PSOG.Entity.Abnormal node = AbnormalList[i];  
                          
               %>
            <div title="<%=node.AS_Equipment_Name %>" style="padding:10px;text-align:center;" selected="true" src='web_show_ASImg.aspx?fileId=a&plantId=<%=plantId %>&name=<%=node.AS_Equipment_ID %>'>
                <iframe id='<%="iframe_" + i %>' src=''  height="100%" width="100%" frameborder="0" onload="this.height=this.contentWindow.document.documentElement.scrollHeight;"></iframe>
            </div>
           
        <%} %>
    </div>
</body>
</html>
<script type="text/javascript"> 
    function selPrivateTab(title, index){
       // if("" == $('#iframe_' + index).attr("src")){
            $('#iframe_' + index).attr("src", $('div > [title]').eq(index).attr("src"));
        //}
    }
// $(tabsDiv).ready(function(){ 
//       window.$('#tabsDiv').tabs('select',<%=value %>);
//                      
//         })
</script>
<%--<script type="text/javascript">
 

function addTab(id, tabName, url) {
    if (!$('#tabsDiv').tabs('exists', tabName)) {
        $('#tabsDiv').tabs('add', {
            title: tabName,
            content: '<iframe id="i' + id + '" name="i' + id + '"  style="width:100%; height:99%;" src="' + url + '"  frameborder="0"  border="0" ></iframe>',
            closable: true,
            fit: true
        });
    } else {
        $('#tabsDiv').tabs('select', tabName);
        //刷新
        
    }    
}

</script>

--%>