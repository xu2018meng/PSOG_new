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

public partial class aspx_main_page_new2 : System.Web.UI.Page
{
    public String deviceJson = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        deviceJson = new MainPage().getHome2DeviceInfo(plantId);
    }
}
