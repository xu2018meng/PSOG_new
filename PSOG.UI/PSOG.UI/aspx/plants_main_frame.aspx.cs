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
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;
using System.Collections.Generic;

public partial class aspx_plants_main_frame : System.Web.UI.Page
{
    public List<Plant> plantList = new List<Plant>();
    protected void Page_Load(object sender, EventArgs e)
    {
        string plants = Request.QueryString["plantIds"];
        //String userId = ((SysUser)Session[CommonStr.session_user]).userId;
        //string plants = new SysManage().qryPlantsByUserId(userId);
        plantList = new MainPage().loadPlantsInfo(plants);
    }
}
