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
using PSOG.Bizc;

public partial class WXAlarmConfirmView : System.Web.UI.Page
{
    public string userId = "";
    public string message = "";
    public string plantId = "";
    public string recordId = "";
    public string messageType = "";
    public string isConfirm = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        plantId = Request.QueryString["plantId"];
        recordId = Request.QueryString["recordId"];
        message = Request.QueryString["message"];
        messageType = Request.QueryString["messageType"];
        string code = Request.QueryString["code"];
        code = code == null ? "" : code;
        if (!string.IsNullOrEmpty(code)) {
            WXWeb.WXService web = new WXWeb.WXService();
           // userId = web.GetOAuth2UserId(code);
        }
        //是否已确认
        isConfirm = new SysManage().AlarmRecordIsConfirmed(plantId,recordId,messageType);
    }
    
}
