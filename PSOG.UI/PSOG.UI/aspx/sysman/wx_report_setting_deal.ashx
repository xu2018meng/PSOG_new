<%@ WebHandler Language="C#" Class="wx_report_setting_deal" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;

public class wx_report_setting_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string plantId = context.Request.Form["plantId"];
        string toUserId = context.Request.Form["toUserId"];
        string toUserName = context.Request.Form["toUserName"];

        string message = new SysManage().saveWXReportConfigInfo(plantId,toUserId,toUserName);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}