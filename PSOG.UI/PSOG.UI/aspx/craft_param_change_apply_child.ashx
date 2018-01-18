<%@ WebHandler Language="C#" Class="craft_param_change_apply_child" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class craft_param_change_apply_child : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        string processId = context.Request.Form["processId"];

        EasyUIData grid = new EasyUIData();

        if (!string.IsNullOrEmpty(processId))
        {
            grid = new SysManage().queryProcessChildList(plantId, processId);
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}