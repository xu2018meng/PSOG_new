<%@ Page Language="C#" AutoEventWireup="true" CodeFile="web_show_ASImg.aspx.cs" Inherits="aspx_web_show_img" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"  style="width:100%; height:100%;  overflow:hidden;">
<head>
    <% string contextPath = Request.ApplicationPath;
       string path = Request.Url.Scheme + @"://" + Request.Url.Host + ":" + Request.Url.Port;
       string fileId = Request.QueryString["fileId"];
       string plantId = Request.QueryString["plantId"];
       string name = Request.QueryString["name"]; %>
    <title>�ޱ���ҳ</title>
    <script type="text/javascript" src="<%=contextPath %>/resource/jquery/jquery-1.6.min.js"></script>
</head>
<body style=" overflow:hidden; font-size:12px; font-family: ΢���ź�;">
    <div id="unusualDiv" align="center" style='width:99%; height:99%; background-repeat:no-repeat; overflow:hidden;vertical-align:middle; '>
       <img id="unusualImge" alt="" style=""  src='<%=path + contextPath + "/aspx/web_get_ASImg.ashx?fileId=" + fileId + "&plantId=" + plantId +"&name=" + name %>'/>
    </div>
</body>
</html>

<script>
//ҳ�洦��
$.ajax({
    url:"./img_exist.ashx?fileId=<%=fileId %>&plantId=<%=plantId %>&name=<%=name %>" ,
    async:true,
    success:function (data){
        if("yes" != data)
        {            
            $('#unusualImge').hide();
            $('#unusualDiv').html("<span style='color:red'>�쳣ͼ��ȱ����</span>");
        }
    }
});
</script>
