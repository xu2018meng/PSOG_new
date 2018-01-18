<%@ WebHandler Language="C#" Class="comprehensive_analysis_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class comprehensive_analysis_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String page = null == context.Request.Form["page"] ? "0" : context.Request.Form["page"];
        String rows = null == context.Request.Form["rows"] ? "30" : context.Request.Form["rows"];  //每页展示多少行
        String plantId = context.Request.QueryString["plantId"];
        string DBName = BeanTools.getPlantDB(plantId).historyDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        EasyUIData grid = new EasyUIData();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            grid = new AlarmAnalysis().comprehensiveAnaysisList(startTime, endTime, plant, int.Parse(page), int.Parse(rows));
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}