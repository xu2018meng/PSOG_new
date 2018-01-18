<%@ WebHandler Language="C#" Class="craft_param_change_apply_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class craft_param_change_apply_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        string queryReason = context.Request.Form["queryReason"];
        string queryStartDate = context.Request.Form["queryStartDate"];
        string queryEndDate = context.Request.Form["queryEndDate"];
        string applyUserId = context.Request.Form["applyUserId"];
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


        EasyUIData grid = new SysManage().queryCraftParamApplyList(plantId, queryReason, queryStartDate, queryEndDate, pageNo, pageSize, applyUserId);

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}