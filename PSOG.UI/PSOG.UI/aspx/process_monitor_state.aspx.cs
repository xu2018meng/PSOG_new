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
public partial class aspx_web_runstate_notiem : System.Web.UI.Page
{
    public string startTime = "";
    public String endTime = "";
    public String chartStr = "";
    public String modelName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;

        String plantCode = Request.QueryString["plantCode"];
       // String plantId = Request.QueryString["plantId"];
        String DBName = BeanTools.getPlantDB(plantCode).historyDB;
        Plant plant = BeanTools.getPlantDB(plantCode);
        endTime = Request.QueryString["endTime"];
        endTime = null == endTime ? time.ToString("yyyy-MM-dd HH:mm:ss") : endTime;
        startTime = Request.QueryString["startTime"];
        startTime = null == startTime ? time.AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss") : startTime;

        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId; //表名
        //String url = "%process_monitor_state.aspx?modelId=" + modelId +"&plantCode=" + plantCode;
        String url = "%process_monitor_state.aspx?modelId=" + modelId + "&%";
        //String modelName = Request.QueryString["modelName"];
        String modelName = Common.getEquipName(plant, url);
        modelName = null == modelName ? "" : modelName; //表名

        chartStr = new AlarmAnalysis().alarmNotIEMchartLine(plant, startTime, endTime, modelId, modelName);
    }
}
