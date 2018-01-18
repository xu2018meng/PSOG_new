<%@ WebHandler Language="C#" Class="qryRemoteIp" %>

using System;
using System.Web;

public class qryRemoteIp : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string ip = context.Request.ServerVariables.Get("Remote_Addr").ToString();
        context.Response.Write(ip);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}