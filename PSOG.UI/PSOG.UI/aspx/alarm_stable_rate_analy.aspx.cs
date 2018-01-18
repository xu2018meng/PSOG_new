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
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;

public partial class aspx_alarm_stable_rate_analy : System.Web.UI.Page
{
    public string startTime = "";
    public String endTime = "";
    protected string[] list = new string[25];
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;
        endTime = time.ToString("yyyy-MM-dd HH:mm:ss");
        startTime = time.AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss");
        string pageid = Request.QueryString["sys_menu_code"];
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        list = new SysManage().qryListLimit(userId, pageid);
    }
}
