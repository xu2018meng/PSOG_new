<%@ WebHandler Language="C#" Class="specialbit_relation_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class specialbit_relation_list_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
       
        context.Response.ContentType = "text/plain";
        string parentId = context.Request.Form["parentId"];
        if (string.IsNullOrEmpty(parentId))
        {
            EasyUIData grid = new EasyUIData();

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else {
            string tagName = context.Request.Form["tagName"];
            string deviceName = context.Request.Form["deviceName"];
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

            EasyUIData grid = new EasyUIData();
            grid = new SysManage().querySelectedBit(parentId, tagName, deviceName, pageNo, pageSize);

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}