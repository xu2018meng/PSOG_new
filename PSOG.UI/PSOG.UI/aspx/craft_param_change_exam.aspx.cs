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
using System.Web.Script.Serialization;
using System.Collections.Generic;

public partial class craft_param_change_exam : System.Web.UI.Page
{
    public String plantName = "";
    public String applyDate = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        plantName = new SysManage().getPlantName(plantId);
        applyDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
    }
}
