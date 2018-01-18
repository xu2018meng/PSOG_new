<%@ WebHandler Language="C#" Class="device_monitoring_alarms_detail" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class device_monitoring_alarms_detail : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String plantId = context.Request.QueryString["plantId"];
        String modelId = context.Request.QueryString["modelId"];
        String startT = context.Request.QueryString["startT"];
        String endT = context.Request.QueryString["endT"];
        String id = context.Request.QueryString["id"];
        
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        //String page = context.Request.Form["page"];
        //String rows = context.Request.Form["rows"];  //每页展示多少行


        EasyUIData grid = new AlarmAnalysis().monitorDeviceDetail(plant, modelId, startT, endT, id); //page, rows

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}