<%@ WebHandler Language="C#" Class="alarm_parameter_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_parameter_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string s = context.Request.Form["action"];
        if (context.Request.Form["action"] != null)
        {
            if (context.Request.Form["action"].Equals("deleteItem"))
            {
                string id = context.Request.Form["realTimeID"].ToString();
                String plantId = context.Request.Form["plantId"];
                plantId = null == plantId ? "" : plantId;
                string DBName = BeanTools.getPlantDB(plantId).realTimeDB;    //数据库名
                Plant plant = BeanTools.getPlantDB(plantId);
                SysManage manage = new SysManage();
                string message = manage.deleteAlarmParamenter(id, plant);
                context.Response.Write(message);
            }
            if (context.Request.Form["action"].Equals("update"))
            {
                String plantId = context.Request.Form["plantId"];
                plantId = null == plantId ? "" : plantId;
                string DBName = BeanTools.getPlantDB(plantId).realTimeDB;    //数据库名
                Plant plant = BeanTools.getPlantDB(plantId);
                EasyUIData grid = new AlarmAnalysis().parameterAlarm(plant); //page, rows
                BeanTools.ToJson(context.Response.OutputStream, grid);
            }
        }
        else
        {
            String plantId = context.Request.QueryString["plantId"];
            plantId = null == plantId ? "" : plantId;
            string DBName = BeanTools.getPlantDB(plantId).realTimeDB;    //数据库名
            //String page = context.Request.Form["page"];
            //String rows = context.Request.Form["rows"];  //每页展示多少行
            Plant plant = BeanTools.getPlantDB(plantId);
            EasyUIData grid = new AlarmAnalysis().parameterAlarm(plant); //page, rows

            BeanTools.ToJson(context.Response.OutputStream, grid.rows);
            //BeanTools.ToJson(context.Response.OutputStream, null);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    
    

}