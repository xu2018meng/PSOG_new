<%@ WebHandler Language="C#" Class="login_out" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public class login_out: IHttpHandler, System.Web.SessionState.IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Session[CommonStr.session_user] = null;
        SysUser user = (SysUser)context.Session[CommonStr.session_user];
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}