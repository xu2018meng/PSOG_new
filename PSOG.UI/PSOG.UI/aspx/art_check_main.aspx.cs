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

public partial class aspx_art_check_main : System.Web.UI.Page
{
    public string functionNos = ""; //存储工艺检测能查看的菜单

    protected void Page_Load(object sender, EventArgs e)
    {
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        functionNos = new SysManage().qryArtFunctionNos(userId);
    }
}
