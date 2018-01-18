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
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_knowledge_jump : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        String url = new SysManage().qryKnowledgeFunctionUrl(userId) + "?plantId=" + plantId;
        Response.Redirect(url, true);
    }
}
