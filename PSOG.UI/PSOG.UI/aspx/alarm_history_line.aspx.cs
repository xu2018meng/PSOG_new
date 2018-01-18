using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Bizc;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_Alarm_history_line : System.Web.UI.Page
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
        endTime = Request.QueryString["endTime"];
        endTime = null == endTime ? time.ToString("yyyy-MM-dd HH:mm:ss") : endTime;
        startTime = Request.QueryString["startTime"];
        startTime = null == startTime ? time.AddHours(-12).ToString("yyyy-MM-dd HH:mm:ss") : startTime;

        String tableName = Request.QueryString["tableName"];
        tableName = null == tableName ? "" : tableName; //表名

        String upLine = Request.QueryString["upLine"];
        String downLine = Request.QueryString["downLine"];

        chartStr = new AlarmAnalysis().alarmAnychartLine3(plant, startTime, endTime, tableName,upLine,downLine);
    }
}
