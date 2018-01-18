<%@ WebHandler Language="C#" Class="graphic_maintain_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class graphic_maintain_list_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
       
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        if (string.IsNullOrEmpty(plantId))
        {
            EasyUIData grid = new EasyUIData();

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else {
            EasyUIData grid = new EasyUIData();
            grid = new SysManage().queryAlarmGraphicRecordList(plantId);

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}