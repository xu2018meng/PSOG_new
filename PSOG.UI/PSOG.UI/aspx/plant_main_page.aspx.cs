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

public partial class aspx_plants_main_page : System.Web.UI.Page
{
    public String jsonStr = "";
    public string plantName = "";
    public String functionNos = ""; //主页要显示的各功能表单 形式如002,003；002代表工艺检测

    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;

        
        string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        plantName = BeanTools.getPlantDB(plantId).organtreeName;
        Plant plant = BeanTools.getPlantDB(plantId);
        jsonStr = new MainPage().getPageJson(plant);
        functionNos = new SysManage().qryFunctionNos(userId);
    }
}
