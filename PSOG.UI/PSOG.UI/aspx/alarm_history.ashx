<%@ WebHandler Language="C#" Class="alarm_history" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class alarm_history : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
  
        HttpRequest Request = context.Request;
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        List<string> list = new AlarmAnalysis().qryhisnum(DBName);
        String jsonStr = BeanTools.ToJson(list);
        context.Response.Write(jsonStr);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}