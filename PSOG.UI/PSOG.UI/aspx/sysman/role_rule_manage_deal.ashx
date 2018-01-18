<%@ WebHandler Language="C#" Class="role_rule_manage_deal" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;

public class role_rule_manage_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        String rule = context.Request.Form["rule"];
        string roleCode = context.Request.Form["roleCode"];

        string message = new SysManage().addRoleRule(rule,roleCode);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}