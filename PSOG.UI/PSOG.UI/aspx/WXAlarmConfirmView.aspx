<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WXAlarmConfirmView.aspx.cs" Inherits="WXAlarmConfirmView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PSOG异常联动报警信息</title>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    
     <style type="text/css">
        p {
           padding-top:10px;
           font-family:黑体,Arial,宋体,sans-scrif;
           font-size:16px;
           line-height:18px;
        }
     </style>
</head>
<body onload="init();">
    <p>
    </p>
    <div style="width:100%;text-align:center;padding-top:5px;">
       <a id="confirmBtn"  href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirm();" style="width: 60px">确定</a>
    </div>
</body>
    <script type="text/javascript">
    
       //初始化
       function init(){
         var message = '<%=message %>';
         message = "&nbsp;&nbsp;&nbsp;&nbsp;"+message;
         $("p").html(message);
         //是否已经确认
          var isConfirm = '<%=isConfirm %>';
          if(isConfirm == "1"){
            $("#confirmBtn").hide();
          }else{
             $("#confirmBtn").show();
          }
       }
    
       //信息确认
      function confirm(){
            var userId = '<%=userId %>';
            var plantId = '<%=plantId %>';
            var recordId = '<%=recordId %>';
            var messageType = '<%=messageType %>'; 
            $.ajax({
                url : './WXAlarm_Confirm_Data.ashx',
                data : {
                    recordId:'<%=recordId %>',
                    plantId:'<%=plantId %>',
                    messageType:'<%=messageType %>',
                    userId:'<%=userId %>'
                },
                async:false,
                type:"post",
                success : function(data) {
                    if(data=="1"){
                      $("#confirmBtn").hide();
                      alert("确认成功");
                    }else{
                      alert("确认失败"); 
                    }            
                }
          });
     }
    </script>
</html>
