<%@ WebHandler Language="C#" Class="save_role_menu_relation_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;

public class save_role_menu_relation_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        String menuCodes = context.Request.Form["menuCodes"];
        string roleCode = context.Request.Form["roleCode"];

        string message = new SysManage().addRoleMenuRelation(menuCodes, roleCode);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}