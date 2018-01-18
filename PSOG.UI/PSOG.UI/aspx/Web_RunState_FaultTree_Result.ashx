<%@ WebHandler Language="C#" Class="Web_RunState_FaultTree_Result" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections;

public class Web_RunState_FaultTree_Result : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;

        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);

        IList list = new ArrayList();
        //list = new AlarmAnalysis().FaultTreeResult(plant);

        BeanTools.ToJson(context.Response.OutputStream, list);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}