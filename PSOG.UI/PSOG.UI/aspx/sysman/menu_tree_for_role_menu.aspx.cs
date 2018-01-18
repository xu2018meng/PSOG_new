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

public partial class aspx_sysman_menu_tree_for_role_menu : System.Web.UI.Page
{
    public string headMenuJson = "[]";
    public List<Plant> plantList = new List<Plant>();
    public string roleId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        roleId = Request.QueryString["roleId"];

        List<TreeNode> treeList = new List<TreeNode>();
        SysManage sysManage = new SysManage();

        treeList = sysManage.qrtHeadMenuTree(roleId);

        headMenuJson =  BeanTools.ToJson(treeList);

        if (null != headMenuJson)
        {
            headMenuJson = System.Text.RegularExpressions.Regex.Replace(headMenuJson, "isChecked", "checked");
        }

        plantList = sysManage.qryPlantByRole(roleId);
    }
}
