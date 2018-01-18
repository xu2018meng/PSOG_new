<%@ WebHandler Language="C#" Class="alarm_monitor_chart_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public class alarm_monitor_chart_data : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";


        HttpRequest request = context.Request;
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        String startTime = request.QueryString["startTime"];
        startTime = null == startTime ? "" : startTime;
        String endTime = request.QueryString["endTime"];
        endTime = null == endTime ? "" : endTime;
        String tableName = request.QueryString["tableName"];
        tableName = null == tableName ? "" : tableName; //表名
        String tagId = request.QueryString["tagId"];
        tagId = null == tagId ? "" : tagId; //表名

        String chartStr = new AlarmAnalysis().alarmMonitorchartLine(plant, startTime, endTime, tableName, tagId);
        context.Response.Write(chartStr);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}