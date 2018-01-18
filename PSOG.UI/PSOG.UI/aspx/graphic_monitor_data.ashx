<%@ WebHandler Language="C#" Class="graphic_monitor_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class graphic_monitor_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String plantId = request.Form["plantId"];
        Dictionary<string, Dictionary<string, List<Dictionary<string, string>>>> dict = new SysManage().queryGraphicMonitorInfo(plantId);
        BeanTools.ToJson(context.Response.OutputStream, (object)dict);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}