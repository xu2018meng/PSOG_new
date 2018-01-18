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
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public partial class aspx_web_run_state_main : System.Web.UI.Page
{
    public string url = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string DBName = Request.QueryString["realTimeDB"];
        string modelId = Request.QueryString["modelId"];

        
    }
}
