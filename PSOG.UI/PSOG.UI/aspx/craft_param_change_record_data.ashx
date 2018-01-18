<%@ WebHandler Language="C#" Class="craft_param_change_record_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class craft_param_change_record_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        string paramName = context.Request.Form["paramName"];
        string paramBitCode = context.Request.Form["paramBitCode"];
        string queryStartDate = context.Request.Form["queryStartDate"];
        string queryEndDate = context.Request.Form["queryEndDate"];
        string pageSizeStr = context.Request.Form["rows"];
        string pageNoStr = context.Request.Form["page"];
        int pageSize = 20, pageNo = 1;
        if (!string.IsNullOrEmpty(pageSizeStr) && !string.IsNullOrEmpty(pageNoStr))
        {
            try
            {
                pageSize = Convert.ToInt32(pageSizeStr);
                pageNo = Convert.ToInt32(pageNoStr);
            }
            catch (Exception exp)
            {
                pageSize = 20;
                pageNo = 1;
            }
        }


        EasyUIData grid = new SysManage().queryCraftParamChangeRecord(plantId, paramName, paramBitCode,queryStartDate,queryEndDate, pageNo, pageSize);

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}