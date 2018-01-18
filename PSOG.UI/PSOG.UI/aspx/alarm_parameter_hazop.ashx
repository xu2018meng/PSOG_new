<%@ WebHandler Language="C#" Class="alarm_parameter_hazop" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_parameter_hazop : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        //String instrumentId = context.Request.Form["instrumentId"];
        //String state = context.Request.Form["state"];
        String instrumentId = context.Request.QueryString["instrumentId"];
        String state = context.Request.QueryString["state"];
        String plantId = context.Request.QueryString["plantId"];

        if (state == "2")
        {
            state = "高";
        }
        else {
            state = "低";
        }
        
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        if (string.IsNullOrEmpty(instrumentId))
        {
            BeanTools.ToJson(context.Response.OutputStream, new EasyUIData());
        }
        else
        {
            EasyUIData grid = new AlarmAnalysis().qryAlarmHazop(plant, instrumentId, state); //page, rows

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}