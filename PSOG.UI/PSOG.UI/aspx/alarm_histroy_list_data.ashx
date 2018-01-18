<%@ WebHandler Language="C#" Class="alarm_histroy_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_histroy_list_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;

        //String wnum = context.Request.QueryString["wnum"] : context.Request.Form["endTime"];
        String wnum = null == context.Request.Form["wnum"] ? context.Request.QueryString["wnum"] : context.Request.Form["wnum"];
        wnum = null == wnum ? "" : wnum;

        String dbSource = null == context.Request.Form["dbSource"] ? context.Request.QueryString["dbSource"] : context.Request.Form["dbSource"];
        
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);

        EasyUIData grid = new EasyUIData();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime )
        {
            if (wnum == "--全部--" || wnum == "")
            {
                grid = new AlarmAnalysis().qryhis(startTime, endTime, page, rows, DBName,dbSource);
            }
            else
            {
                grid = new AlarmAnalysis().qryhis2(startTime, endTime, page, rows, DBName,wnum,dbSource);
            }
            //grid = new AlarmAnalysis().qryhisCopy(startTime, endTime, page, rows, DBName);
        }
        
        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}