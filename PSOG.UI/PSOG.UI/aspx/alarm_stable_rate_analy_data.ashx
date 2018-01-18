<%@ WebHandler Language="C#" Class="alarm_stable_rate_analy" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_stable_rate_analy : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);
        
        EasyUIData grid = new EasyUIData();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            DateTime startDate = new DateTime(), endDate = new DateTime();
            if (null != startTime && "" != startTime) startDate = DateTime.Parse(startTime);
            if (null != endTime && "" != endTime) endDate = DateTime.Parse(endTime);

            grid = new AlarmAnalysis().StableRateAnaly(startDate, endDate, plant, page, rows);
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}