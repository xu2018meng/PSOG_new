<%@ WebHandler Language="C#" Class="alarmDeviceConfig_select_confirm_data" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class alarmDeviceConfig_select_confirm_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string flag = context.Request.Form["flag"];
        if ("add".Equals(flag)) {
            string parentId = context.Request.Form["parentId"];
            string bitInfo = context.Request.Form["bitInfo"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<BitDevice> objectList = js.Deserialize<List<BitDevice>>(bitInfo);

            String message = new SysManage().InsertDeviceAbnormal(parentId, objectList);

            context.Response.Write(message);
        }
        else if ("delete".Equals(flag)) {
            string parentId = context.Request.Form["parentId"];
            string bitInfo = context.Request.Form["bitInfo"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Object> objectList = js.Deserialize<List<Object>>(bitInfo);

            String message = new SysManage().deleteDeviceAbnormal(parentId, objectList); ;

            context.Response.Write(message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}