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
using System.Web.Script;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_main_page : System.Web.UI.Page
{
    public String jsonStr = "";
    public String functionNos = ""; //主页要显示的各功能表单 形式如002,003；002代表工艺检测
    public string startTime = "";
    public String endTime = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;
        endTime = time.ToString("yyyy-MM-dd HH:mm:ss");
        startTime = time.AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss");

        String plantId = Request.QueryString["plantId"];
        string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        jsonStr = new MainPage().getPageJson(plant);
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "message", "alert(1);window.onload = show('" + jsonStr + "')", true); //添加数据
        functionNos = new SysManage().qryFunctionNos(userId);
    }
}
