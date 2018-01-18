<%@ WebHandler Language="C#" Class="alarm_hazop_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_hazop_list_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
       
        context.Response.ContentType = "text/plain";
        
        string plantId = context.Request.Form["plantId"];
        string bitId = context.Request.Form["bitId"];
        string bias = context.Request.Form["bias"];
        EasyUIData grid = new SysManage().queryBitHazopParamList(plantId, bitId, bias);
        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}