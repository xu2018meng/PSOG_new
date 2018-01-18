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
using System.Collections.Generic;
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;

public partial class aspx_alarm_analysis : System.Web.UI.Page
{
    protected List<FunctionNode> functionList = new List<FunctionNode>();
    protected void Page_Load(object sender, EventArgs e)
    {
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        functionList = new SysManage().qryFunctionNode(userId);
    }
}
