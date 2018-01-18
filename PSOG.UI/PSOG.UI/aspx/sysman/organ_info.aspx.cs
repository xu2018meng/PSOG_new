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
using PSOG.Entity;
using PSOG.Common;

public partial class aspx_sysman_organ_info : System.Web.UI.Page
{
    public String orgName = null;
    public String orgCode = null;
    public String orgOrder = null;
    public String orgCreateTime = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        //string contextPath = Request.ApplicationPath;
        string prentID = Request.QueryString["prentID"];
        prentID = (null == prentID ? "1" : prentID);
        
        //得到部门信息
        OrganiseUnit org = new OrganiseUnit();
        org = new SysManage().getOrganiseInfo(prentID);
        orgName = org.SYS_ORGAN_NAME;
        orgCode = org.SYS_ORGAN_CODE;
        orgOrder = org.SYS_ORGAN_ORDER;
        orgCreateTime = org.SYS_ORGAN_CRT_TIME;
    }
}
