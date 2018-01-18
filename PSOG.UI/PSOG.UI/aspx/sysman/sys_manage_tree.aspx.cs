using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;
using System.Collections.Generic;

public partial class aspx_sysman_sys_manage_tree : System.Web.UI.Page
{
    public string headMenuJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String userId = ((SysUser)Session[CommonStr.session_user]).userId;
        string parentMenuCode = Request.QueryString["parentMenuCode"];
        List<TreeNode> treeNodeList = new SysManage().loadManageTree(userId, parentMenuCode);
        headMenuJson = BeanTools.ToJson(treeNodeList);
    }
}
