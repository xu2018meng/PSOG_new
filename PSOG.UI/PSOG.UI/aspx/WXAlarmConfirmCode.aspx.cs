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
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

public partial class WXAlarmConfirmCode : System.Web.UI.Page
{
    public string authUrl = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string plantId = Request.QueryString["plantId"];
        string recordId = Request.QueryString["recordId"];
        string message = Request.QueryString["message"];
        string messageType = Request.QueryString["messageType"];
        string DomainHack = ConfigurationManager.AppSettings["DomainHack"];
        string projectPath = ConfigurationManager.AppSettings["ApplicationPath"];
        string url = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmView.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + recordId + "&messageType=" + messageType;
        WXWeb.WXService web = new WXWeb.WXService();
        //authUrl = web.GetOAuth2Url(url, "Alarm");
    }
    
}
