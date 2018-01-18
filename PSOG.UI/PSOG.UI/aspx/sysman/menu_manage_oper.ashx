<%@ WebHandler Language="C#" Class="menu_manage_oper" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class menu_manage_oper : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String isDel = request.Form["isDel"];
        String menuId = request.Form["menuId"];
        
        string message = "";
        if ("1" == isDel)   //删除数据
        {
            message = new SysManage().delMenuItem(menuId);
        }
        else //修改、新增数据
        {
            
            String menuName = request.Form["menuName"];
            String menuUrl = request.Form["menuUrl"];
            String menuIndex = request.Form["menuIndex"];
            message = new SysManage().updMenuItem(menuId, menuName, menuUrl, menuIndex);
        }
        

        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}