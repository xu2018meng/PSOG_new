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
using PSOG.Entity;
using PSOG.Common;

public partial class aspx_comprehensive_analysis : System.Web.UI.Page
{
    public CompAnaly compAnaly = new CompAnaly();
    public string startTime = "";
    public String endTime = "";
    public string[] list = new string[25];
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;

        string plantId = Request.QueryString["plantId"];
        String DBName = BeanTools.getPlantDB(plantId).historyDB; ;  //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        endTime = Request.QueryString["endTime"];
        endTime = null == endTime ? time.ToString("yyyy-MM-dd HH:mm:ss") : endTime;
        startTime = Request.QueryString["startTime"];
        startTime = null == startTime ? time.AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss") : startTime;


        compAnaly = new AlarmAnalysis().comprehensiveAnaysis(startTime, endTime, plant);

        string pageid = Request.QueryString["sys_menu_code"];
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        list = new SysManage().qryListLimit(userId, pageid);
    }
}
