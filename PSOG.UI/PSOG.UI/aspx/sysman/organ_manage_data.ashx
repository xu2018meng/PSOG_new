<%@ WebHandler Language="C#" Class="organ_manage_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
public class organ_manage_data : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        String ID = null == context.Request.Form["prentID"] ? context.Request.QueryString["prentID"] : context.Request.Form["prentID"];
        string parentID = String.IsNullOrEmpty(ID) ? "C50218C1-45F4-49CB-8985-53704842A376" : ID;
        EasyUIData grid = new EasyUIData();
        grid.rows = new SysManage().getOrganiseList(parentID + "");
        BeanTools.ToJson(context.Response.OutputStream, grid);
    }

    public void getData(EasyUIData grid)
    {
        for (int i = 0; i < 10; i++)
        {
            grid.total = BeanTools.ObjectToInt(i);
            AlarmHis alarm = new AlarmHis();
            alarm.id = ""+i;
            alarm.items = "item"+i;
            alarm.value = "value"+i;
            alarm.describe = "describe"+i;
            alarm.state = "state"+i;
            alarm.historyId = "historyID"+i;
            alarm.cause = "cause"+i;
            alarm.measure ="measure"+i;
            alarm.alarmClass = "alarmClass"+i;
            alarm.type = "AlarmManager_History_Type";
            alarm.color = "AlarmManager_History_Color";
            alarm.isClear = "AlarmManager_History_IsClear";
            alarm.isSound = "AlarmManager_History_IsSound";
            alarm.isTwinkle = "AlarmManager_History_IsTwinkle";
            alarm.sound = "AlarmManager_History_Sound";
            alarm.isCanel = "AlarmManager_History_IsCanel";
            alarm.startTime = "AlarmManager_History_StartTime";
            alarm.endTime = "AlarmManager_History_EndTime";
            alarm.duration = i;
            grid.rows.Add(alarm);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

