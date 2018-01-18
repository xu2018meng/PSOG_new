using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using PSOG.Bizc;
using System.Web.Script;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_main_page_data_new : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.Form["plantId"];
        string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        MainPage mainPage = new MainPage();
        String returnStr = mainPage.getNewPageJson(plant);

        Response.Write(returnStr);
    }
}