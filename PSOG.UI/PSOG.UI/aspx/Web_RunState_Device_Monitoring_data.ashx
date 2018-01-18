<%@ WebHandler Language="C#" Class="Web_RunState_Device_Monitoring_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections;

public class Web_RunState_Device_Monitoring_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        
        DateTime time = DateTime.Now;
        string startTime = "";
        String endTime = "";
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        endTime = context.Request.QueryString["endTime"];
        endTime = null == endTime ? time.ToString("yyyy-MM-dd HH:mm:ss") : endTime;
        startTime = context.Request.QueryString["startTime"];
        startTime = null == startTime ? time.AddHours(-12).ToString("yyyy-MM-dd HH:mm:ss") : startTime;

        String tableName = context.Request.QueryString["tableName"];
        tableName = null == tableName ? "" : tableName; //表名

        //chartStr = new AlarmAnalysis().alarmAnychartLine(plant, startTime, endTime, tableName);
        IList list = new ArrayList();
        list = new AlarmAnalysis().alarmAnychartLineNew(plant, startTime, endTime, tableName);

        BeanTools.ToJson(context.Response.OutputStream, list);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}