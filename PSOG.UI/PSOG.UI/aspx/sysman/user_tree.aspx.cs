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
using System.Collections.Generic;
using PSOG.Common;

public partial class aspx_sysman_user_tree : System.Web.UI.Page
{
    public string headOrganJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        List<TreeNode> treeList = new List<TreeNode>();

        SysManage sysManage = new SysManage();

        treeList = sysManage.qryHeadOrganTree();

        headOrganJson = BeanTools.ToJson(treeList);

        if (null != BeanTools.ToJson(treeList))
        {
            headOrganJson = System.Text.RegularExpressions.Regex.Replace(headOrganJson, "isChecked", "checked");
        }


    }
}
