<%@ WebHandler Language="C#" Class="login_validate" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public class login_validate : IHttpHandler, System.Web.SessionState.IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String userName = request.Form["userName"];
        String password = request.Form["password"];
        String checkCode = request.Form["checkCode"];
        String checkPngCode = (String)context.Session["CheckCode"];
        if (!checkCode.Equals(checkPngCode))
        {
            String message = "checkCodeFalse";
            context.Response.Write(message);
        }
        else {
            string remoteAddr = request.ServerVariables["Remote_Addr"]; //客户端ip

            SysUser user = new SysUser();
            user.userLoginName = userName;
            user.userPassword = password;
            user.userIp = remoteAddr;

            string message = new MainPage().loginValidate(user);
            if ("true" == message)
            {
                context.Session[CommonStr.session_user] = user;    //将用户名存储到session
            }
            context.Response.Write(message);
        }
      
       
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}