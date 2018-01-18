<%@ WebHandler Language="C#" Class="operation_quality_main_page_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections;
using System.Text;
using System.Data;
using System.IO;

public class operation_quality_main_page_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        String id = context.Request.QueryString["id"];
        
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);

        IList list = new ArrayList();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            list = new OQIAnalysis().OQIAnaysisMainPage(startTime, endTime, DBName);
        }

        BeanTools.ToJson(context.Response.OutputStream, list);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}