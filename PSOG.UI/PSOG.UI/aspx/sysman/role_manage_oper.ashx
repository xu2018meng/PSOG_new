<%@ WebHandler Language="C#" Class="role_manage_oper" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class role_manage_oper : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String isDel = request.Form["isDel"];
        String roleId = request.Form["roleId"];
        String message = "";
        if ("0" == isDel)    //修改、增加记录
        {

            String roleName = request.Form["roleName"];

            message = new SysManage().addOrUpdateRole(roleId, roleName);
        }
        else//删除记录
        {
            message = new SysManage().delRole(roleId);
        }

        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}