<%@ WebHandler Language="C#" Class="craft_param_change_bit_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class craft_param_change_bit_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string flag = context.Request.QueryString["flag"];
        if ("dict".Equals(flag)) {
            string plantId = context.Request.QueryString["plantId"];
            List<Dictionary<String, String>> list = new SysManage().queryBitDict(plantId);
            BeanTools.ToJson(context.Response.OutputStream, list);
        }else if("base".Equals(flag)){
            String plantId = context.Request.Form["plantId"];
            String bitCode = context.Request.Form["bitCode"];
            String paramKPI = context.Request.Form["paramKPI"];
            string resultInfo = new SysManage().queryBitInfoByCode(plantId, bitCode, paramKPI);
            context.Response.Write(resultInfo);
        }
        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}