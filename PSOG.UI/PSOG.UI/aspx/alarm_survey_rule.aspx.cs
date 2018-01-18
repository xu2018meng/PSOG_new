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
using System.Web.Script;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_alarm_survey_rule : System.Web.UI.Page
{
    public String jsonStr = "";
    public String ruleJsonStr = "";
    public String isHasEdit = "";
    public String limitJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String id = Request.QueryString["id"];
        String plantId = Request.QueryString["plantId"];
        String bitCode = Request.QueryString["bitCode"];

        jsonStr = new SysManage().getAlarmBitInfo(plantId,id);
        ruleJsonStr = new SysManage().getAlarmRuleInfo(plantId, id);
        limitJson = new SysManage().getAlarmLimitValue(plantId, bitCode);

        SysUser user = ((SysUser)Session[CommonStr.session_user]);
        string userId = user.userId;
        isHasEdit = new SysManage().isHasEditRule(userId,"bj");
    }
}
