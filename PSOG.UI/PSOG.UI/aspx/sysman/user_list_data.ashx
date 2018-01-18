<%@ WebHandler Language="C#" Class="user_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class user_list_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String organCode = null == context.Request.Form["organCode"] ? context.Request.QueryString["organCode"] : context.Request.Form["organCode"];
        string deptCode = context.Request.Form["deptCode"];
        string pageSizeStr = context.Request.Form["rows"];
        string pageNoStr = context.Request.Form["page"];
        int pageSize = 30, pageNo = 1;
        if (!string.IsNullOrEmpty(pageSizeStr) && !string.IsNullOrEmpty(pageNoStr))
        {
            try
            {
                pageSize = Convert.ToInt32(pageSizeStr);
                pageNo = Convert.ToInt32(pageNoStr);
            }
            catch (Exception exp)
            {
                pageSize = 30;
                pageNo = 1;
            }
        }
        
        EasyUIData grid = new EasyUIData();

        if (!string.IsNullOrEmpty(organCode) || !string.IsNullOrEmpty(deptCode))
        {
            grid = new SysManage().qryUserList(organCode, deptCode, pageNo, pageSize);
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}