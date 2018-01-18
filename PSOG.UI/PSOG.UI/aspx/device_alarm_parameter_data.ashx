<%@ WebHandler Language="C#" Class="device_alarm_parameter_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class device_alarm_parameter_data : IHttpHandler
{
    
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
            else if (context.Request.Form["action"].Equals("update"))
            {
                String deviceId = context.Request.Form["deviceId"];
                String alarmFlag = context.Request.Form["alarmFlag"];
                String plantId = context.Request.Form["plantId"];
                Plant plant = BeanTools.getPlantDB(plantId);
                EasyUIData grid = new AlarmAnalysis().parameterDeviceAlarm(plant, deviceId, alarmFlag); //page, rows
                BeanTools.ToJson(context.Response.OutputStream, grid);
            }
        }
        else
        {
            String deviceId = context.Request.QueryString["deviceId"];
            String alarmFlag = context.Request.QueryString["alarmFlag"];
            String plantId = context.Request.QueryString["plantId"];
            Plant plant = BeanTools.getPlantDB(plantId);
            EasyUIData grid = new AlarmAnalysis().parameterDeviceAlarm(plant,deviceId,alarmFlag); //page, rows

            BeanTools.ToJson(context.Response.OutputStream, grid.rows);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    
    

}