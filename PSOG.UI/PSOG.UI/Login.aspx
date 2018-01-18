<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
  
    <title>石化装置安全运行监测与指导系统-登陆</title>
    <script type="text/javascript" src="./resource/jquery/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="./resource/js/login.js"></script>
    <script type="text/javascript" src="./resource/js/MD5.js"></script>
    <style type="text/css">
        body{background: url(./resource/img/login/login_bg.jpg) no-repeat ;
            width:98%;
            height:100%;
        }   
        #login_div{
            width:722px;
            height:576px; 
            margin-left:-361px;
            margin-top:-288px;
            position:absolute;
            top:50%;
            left:50%;
            
        }
        form1{
            width:100%;
            height:100%;
        }
        
        #username{
            width:165px;
            height:26px;
            position:relative;
            left:435px;
            top:112px;
            line-height:160%;
            font-size:17px;
            border:0px;
        }
        
        #password{
            width:165px;
            height:31px;
            position:relative;
            left:262px;
            top:161px;
            line-height:160%;
            font-size:17px;
            border:0px;            
        }
        
        #img_login{
            width:171px;
            height:38px;
            position:relative;
            left:433px;
            top:213px;
            
        }
        
        .checkLabel{
            font-weight:bold;
            position:relative;
            left:31px;
            top:206px;
            line-height:160%;
            font-size:14.9px;
            border:0px;   
        }
        
        .checkText{
            width:90px;
            height:26px;
            position:relative;
            left:36px;
            top:206px;
            line-height:160%;
            font-size:14.9px;
            border:0px;   
        }
        
        .checkPng{
            height:23px;
            position:relative;
            left:36px;
            top:211px;
            line-height:160%;
            font-size:17px;
            border:0px;   
        }
        
    </style>
</head>
<body>
    <form id="form1" action="">
    <!-- #include file="./aspx/include_loading.aspx" -->
    <div id="login_div" style="">
        <div style="background: url(./resource/img/login/login_logo.png) no-repeat; width:722px; height:84px;"></div>
        <div style="background: url(./resource/img/login/login.png) no-repeat; width:722px; height:492px;">
            <input type="text" id="username"  class="username" />
            <input type="password"  onkeydown="userInfoChange()" onchange="$('#password').val(hex_md5($('#password').val()));" onfocus="this.select()" id="password"  class="textB"/>
            <span class="checkLabel">验证码:</span>
            <input type="text" id="checkText"  class="checkText" />
             <img src="aspx/CheckPng.aspx" id="img" alt="换一张"  class="checkPng" onclick="f_refreshtype()" style="cursor:pointer"/>
            <br/>
            <img id="img_login" alt="登录" onmouseover="loginOver()" onclick="loginDown()" onmouseout="loginOut()" src="resource/img/login/entry.png"/>
        </div>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">
   

    //点击切换验证码
    function f_refreshtype() {
        var Image1 = document.getElementById("img");
        Image1.src = Image1.src + "?";
    } 

var isClick = false;
//划过登陆框
function loginOver(){
    $("#img_login").attr("src", "resource/img/login/entry_click.png");
}

//点击登陆框
function loginDown(){
    $("#img_login").attr("src", "resource/img/login/entry_click.png");
    if(false == isClick){
        isClick = true;
        loginDown = function (){};
    }
    loginAction();
}

var saveLogin = loginDown;

//划出登陆框
function loginOut(){
    if(false == isClick){
        $("#img_login").attr("src", "resource/img/login/entry.png");
    }
}

function backInit(){
    loginDown = saveLogin;
    isClick = false;
    $("#img_login").attr("src", "resource/img/login/entry.png");
}
function loginAction() {
 
    var userNameObj = document.getElementById("username");
    var passWordObj = document.getElementById("password");
    var checkCode = document.getElementById("checkText").value;
 
    var userName = userNameObj.value;
    var passWord = passWordObj.value;

    var passMd5 = '';

    if (userName == '') {
        alert("请输入用户名!");
        backInit();
        return false;
    } else if (passWord == '') {
        alert("请输入密码!");
        backInit();
        return false;
    } else if(checkCode==null || checkCode == ''){
        alert("请输入验证码!");
        backInit();
        return false;
    }else {
        //passMd5 = hex_md5(passWord);
        flag = "false";
        $.ajax({
        url:"./aspx/login_validate.ashx",
        method:"post",
        async:false,
        data:{userName:userName, password:passWord,checkCode:checkCode},
        success:function (data){
            flag = data;
            backInit();
        }
        });
        if (flag == "true") {            
            window.location.href = "Default.aspx";       
        } else if(flag == "checkCodeFalse"){
           alert("验证码输入错误!");
           f_refreshtype();
        }else {
            alert("用户名或密码错误!");
        }   

    }
}
</script>
