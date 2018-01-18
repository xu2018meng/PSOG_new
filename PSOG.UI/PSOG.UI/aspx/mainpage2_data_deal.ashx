<%@ WebHandler Language="C#" Class="mainpage2_data_deal" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class mainpage2_data_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        string deviceId = context.Request.Form["deviceId"];

        string runIndexId = new SysManage().getDeviceRunIndexId(plantId,deviceId);

        BeanTools.ToJson(context.Response.OutputStream, runIndexId);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}