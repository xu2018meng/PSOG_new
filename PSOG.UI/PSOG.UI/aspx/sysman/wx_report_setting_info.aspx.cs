using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using PSOG.Common;

public partial class wx_report_setting_info : System.Web.UI.Page
{
    public string configInfo = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        string plantId = Request.QueryString["plantId"];

        configInfo = (new SysManage()).queryWXReportConfigInfo(plantId);
    }
}
