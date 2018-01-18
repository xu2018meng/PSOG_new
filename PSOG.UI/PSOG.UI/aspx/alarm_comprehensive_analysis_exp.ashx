<%@ WebHandler Language="C#" Class="alarm_comprehensive_analysis_exp" %>

using System;
using System.Web;
using PSOG.Common;
using System.IO;
using PSOG.Bizc;
using PSOG.Entity;
public class alarm_comprehensive_analysis_exp : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        String startTime = context.Request.Cookies["startTime"].Value.ToString();
        String endTime = context.Request.Cookies["endTime"].Value.ToString();
        String plantId = context.Request.Cookies["plantId"].Value.ToString();
        plantId = null == plantId ? "" : plantId;

        string DBName = BeanTools.getPlantDB(plantId).historyDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        if (null == startTime || null == endTime) return;
        MemoryStream ms = new AlarmAnalysis().expCompAnaly(startTime, endTime, plant);
        BeanTools.RenderToBrowser(ms, context, "报警综合分析" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}