﻿<%@ WebHandler Language="C#" Class="alarm_analysis_by_order_top20" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_analysis_by_order_top20 : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名

        String dbSource = null == context.Request.Form["dbSource"] ? context.Request.QueryString["dbSource"] : context.Request.Form["dbSource"];
        
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);

        EasyUIData grid = new EasyUIData();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            grid = new AlarmAnalysis().alarmAnaysisTop20(startTime, endTime, DBName,dbSource);
        }

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}