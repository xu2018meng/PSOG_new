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

public partial class aspx_Web_RunState_ASDB : System.Web.UI.Page
{
    public string jsonStr = "";
    public String plantName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        plantName = new SysManage().getPlantName(plantId);
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        jsonStr = new AlarmAnalysis().FaultTreeResult(plant);
    }
}
