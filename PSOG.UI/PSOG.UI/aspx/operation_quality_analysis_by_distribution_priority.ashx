<%@ WebHandler Language="C#" Class="operation_quality_analysis_by_distribution_priority" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections;

public class operation_quality_analysis_by_distribution_priority : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        String id = context.Request.QueryString["id"];
        
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);

        IList grid = new ArrayList();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            grid = new OQIAnalysis().OQIAnaysisDistributionByPriority(id, startTime, endTime, DBName);
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}