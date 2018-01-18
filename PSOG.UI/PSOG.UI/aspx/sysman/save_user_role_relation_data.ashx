<%@ WebHandler Language="C#" Class="save_user_role_relation_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;

public class save_user_role_relation_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        String roleCodes = context.Request.Form["roleCodes"];
        string userId = context.Request.Form["userId"];

        string message = new SysManage().addUserRoleRelation(roleCodes, userId);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}