<%@ WebHandler Language="C#" Class="alarm_analysis_report_data_wx" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Diagnostics;

public class alarm_analysis_report_data_wx : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["action"] != null)
        {
            if (context.Request.Form["action"].Equals("deleteItem"))
            {
                string id = context.Request.Form["realTimeID"].ToString();
                String plantId = context.Request.Form["plantId"];
                plantId = null == plantId ? "" : plantId;
                //string DBName = BeanTools.getPlantDB(plantId).realTimeDB;    //数据库名
                //SysManage manage = new SysManage();
                //string message = manage.deleteAlarmParamenter(id, DBName);
                Plant plant = BeanTools.getPlantDB(plantId);
                SysManage manage = new SysManage();
                string message = manage.deleteAlarmParamenter(id, plant);
                context.Response.Write(message);
            }
        }
        else
        {
            String plantId = context.Request["plantId"];
            plantId = null == plantId ? "" : plantId;
            //string userName = context.Request.Form["svg"];
            String tSvg = context.Request["svg"];

            //highchart_export export_png = new highchart_export();
            //export_png.export_png(tSvg);
            
            //Process p = new Process();
            //try
            //{
            //    //p.StartInfo.WindowStyle = ProcessWindowStyle.Minimized;
            //    // Start the process
            //    string exeName = "D:\\PSOG版本\\C_ExportWord 2014-12-22\\ExportWord\\bin\\Release\\ExportWord.exe";
            //    p = System.Diagnostics.Process.Start(exeName, "1" + "xcfzsd");
            //    // Wait for process to be created and enter idle condition

            //}
            //catch
            //{ }

        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    
    

}