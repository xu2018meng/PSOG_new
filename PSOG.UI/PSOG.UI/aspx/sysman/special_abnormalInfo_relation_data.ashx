<%@ WebHandler Language="C#" Class="special_abnormalInfo_relation_data" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class special_abnormalInfo_relation_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string id = context.Request.Form["id"];
        string tagId = context.Request.Form["tagId"];
        string tagName = context.Request.Form["tagName"];
        string tagDesc = context.Request.Form["tagDesc"];
        String message = new SysManage().saveTypeAbnormalInfo(id,tagId,tagName,tagDesc);
        context.Response.Write(message);  
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}