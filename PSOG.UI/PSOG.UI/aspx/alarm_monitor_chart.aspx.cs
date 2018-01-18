using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_alarm_monitor_chart : System.Web.UI.Page
{
    public string chartStr = "";
    public string startTime = "";
    public String endTime = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;

        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        string midTime = Request.QueryString["time"];
        if (!string.IsNullOrEmpty(midTime))
        {
            time = Convert.ToDateTime(midTime);
            endTime = time.AddHours(6).ToString("yyyy-MM-dd HH:mm:ss");
            startTime = time.AddHours(-6).ToString("yyyy-MM-dd HH:mm:ss") ;
        }
        else
        {
            endTime = Request.QueryString["endTime"];
            endTime = null == endTime ? time.ToString("yyyy-MM-dd HH:mm:ss") : endTime;
            startTime = Request.QueryString["startTime"];
            startTime = null == startTime ? time.AddHours(-12).ToString("yyyy-MM-dd HH:mm:ss") : startTime;
        }
        

        String tableName = Request.QueryString["tableName"];
        tableName = null == tableName ? "" : tableName; //表名
        String tagId = Request.QueryString["tagId"];
        tagId = null == tagId ? "" : tagId; //仪器主键

        chartStr = new AlarmAnalysis().alarmMonitorchartLine(plant, startTime, endTime, tableName, tagId);
    }
}