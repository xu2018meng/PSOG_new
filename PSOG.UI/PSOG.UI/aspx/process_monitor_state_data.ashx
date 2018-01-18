<%@ WebHandler Language="C#" Class="web_runstate_notiem_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public class web_runstate_notiem_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        
        
        HttpRequest request = context.Request;
        String plantCode = request.QueryString["plantCode"];
        string DBName = BeanTools.getPlantDB(plantCode).historyDB;  //数据库名
        Plant plant = BeanTools.getPlantDB(plantCode);
        String startTime = request.QueryString["startTime"];
        startTime = null == startTime ? "" : startTime;
        String endTime = request.QueryString["endTime"];
        endTime = null == endTime ? "" : endTime;

        String modelId = request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId; //表名
        
        //String modelName = request.QueryString["modelName"];
        //modelName = null == modelName ? "" : modelName; //表名
        String url = "%process_monitor_state.aspx?modelId=" + modelId + "&%";
      
        String modelName = Common.getEquipName(plant, url);
        //String modelName = "haha";
        String chartStr = new AlarmAnalysis().alarmNotIEMchartLine(plant, startTime, endTime, modelId, modelName);
        context.Response.Write(chartStr);
        context.Response.Flush();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}