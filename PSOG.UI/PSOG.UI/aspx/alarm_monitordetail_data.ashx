<%@ WebHandler Language="C#" Class="alarm_monitordetail_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_monitordetail_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String plantId = context.Request.QueryString["plantId"];
        String modelId = context.Request.QueryString["modelId"];
        String name = context.Request.QueryString["name"];
        String yvalue = context.Request.QueryString["yvalue"];
        
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        //String page = context.Request.Form["page"];
        //String rows = context.Request.Form["rows"];  //每页展示多少行

        EasyUIData grid = new AlarmAnalysis().monitorDetail(plant, modelId, name, yvalue); //page, rows

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}