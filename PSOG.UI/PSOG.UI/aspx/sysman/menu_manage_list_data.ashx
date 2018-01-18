<%@ WebHandler Language="C#" Class="menu_manage_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class menu_manage_list_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";        
        string parentMenuCode = context.Request.Form["parentMenuCode"];

        EasyUIData grid = new SysManage().qryMenuItemList(parentMenuCode);

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}