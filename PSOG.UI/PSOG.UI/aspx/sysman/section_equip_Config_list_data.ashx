<%@ WebHandler Language="C#" Class="section_equip_Config_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class section_equip_Config_list_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
       
        context.Response.ContentType = "text/plain";
        string parentId = context.Request.Form["parentId"];
        string type = context.Request.Form["type"];
        string tagName = context.Request.Form["tagName"];
        string tagDesc = context.Request.Form["tagDesc"];
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
        
        
        if (string.IsNullOrEmpty(parentId))
        {
            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else if ("section".Equals(type))
        {
            grid = new SysManage().querySectionList(parentId, tagName, tagDesc, pageNo, pageSize);
            BeanTools.ToJson(context.Response.OutputStream, grid);
        } else {
            grid = new SysManage().querySectionDeviceList(parentId, tagName, tagDesc, pageNo, pageSize);
            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}