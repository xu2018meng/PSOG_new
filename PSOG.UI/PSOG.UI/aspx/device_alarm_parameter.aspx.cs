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

public partial class device_alarm_parameter : System.Web.UI.Page
{
    public string[] list = new string[25];
    protected void Page_Load(object sender, EventArgs e)
    {
        string pageid = ConfigurationManager.AppSettings["AlarmMenuCode"]; ;//此处为实时报警的编码，如果数据库中编码变动需修改配置文件
        string userId = ((SysUser)Session[CommonStr.session_user]).userId;
        list = new SysManage().qryListLimit(userId, pageid);
    }
}
