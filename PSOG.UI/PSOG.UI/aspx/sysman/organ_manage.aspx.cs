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

public partial class aspx_sysman_organ_manage : System.Web.UI.Page
{
    public String orgType= null;
    public String prentID = null;
    public String orgOrder = null;
    protected void Page_Load(object sender, EventArgs e)
    {
       // string contextPath = Request.ApplicationPath;
        prentID = Request.QueryString["prentID"];
        prentID = (null == prentID ? "1" : prentID);
        if (prentID.Equals("9B758C25-11AE-492A-8229-3EDCECB47A9C"))
        {
            orgType = "单位";
        }
        else
        {
            orgType = "部门";
        }
        orgOrder = new SysManage().getMaxOrder(prentID);
    }
}
