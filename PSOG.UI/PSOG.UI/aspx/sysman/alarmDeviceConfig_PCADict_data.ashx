<%@ WebHandler Language="C#" Class="alarmDeviceConfig_PCADict_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;

public class alarmDeviceConfig_PCADict_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string flag = context.Request.Form["flag"];
        string parentId = context.Request.Form["parentId"];
        if ("selectDict".Equals(flag))
        {
            String plantId = parentId.Split('#')[1];
            String PACJson = new SysManage().queryPCAModelDict(plantId);
            context.Response.Write(PACJson);
        }
        else if ("save".Equals(flag)) {
            string runId = context.Request.Form["runId"];
            string pcaId = context.Request.Form["pcaId"];
            string pcaName = context.Request.Form["pcaName"];
            String message = new SysManage().saveRunIndexParamInfo(parentId, runId, pcaId, pcaName);
            context.Response.Write(message);
        }
        else if ("selectRunIndex".Equals(flag)) {
            string paramJson = new SysManage().getRunIndexParamInfo(parentId);
            context.Response.Write(paramJson);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}