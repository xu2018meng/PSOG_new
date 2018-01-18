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
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_alarm_pre_survey_rule : System.Web.UI.Page
{
    public String dictJson = "";
    public String bitJson = "";
    public String ruleJson = "";
    public String isHasEdit = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        String id = Request.QueryString["id"];
        String bitCode = Request.QueryString["bitCode"];
        List<Dictionary<String, String>> list = new SysManage().queryEarlyAlarmBitDict(plantId,bitCode);
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        dictJson = jsonSerializer.Serialize(list);

        //基本信息
        bitJson = new SysManage().getEarlyAlarmBitInfo(plantId,id);
        //规则信息
        ruleJson = new SysManage().getEarlyAlarmRuleInfo(plantId, id);

        SysUser user = ((SysUser)Session[CommonStr.session_user]);
        string userId = user.userId;
        isHasEdit = new SysManage().isHasEditRule(userId, "yj");
    }
}
