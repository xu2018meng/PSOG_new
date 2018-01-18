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

public partial class aspx_sysman_organ_manage_main : System.Web.UI.Page
{
    public string code = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String prentID = Request.QueryString["prentID"];
    }
}
