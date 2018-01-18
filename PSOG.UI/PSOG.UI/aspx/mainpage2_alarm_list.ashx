<%@ WebHandler Language="C#" Class="mainpage2_alarm_list" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class mainpage2_alarm_list : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        string deviceId = context.Request.Form["deviceId"];
        
        EasyUIData grid = new SysManage().queryDeviceAlarmList(plantId, deviceId);

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}