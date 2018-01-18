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

public partial class aspx_sysman_menu_tree : System.Web.UI.Page
{
    public string headMenuJson = "[]";
    public List<Plant> plantList = new List<Plant>();

    protected void Page_Load(object sender, EventArgs e)
    {
        

        List<TreeNode> treeList = new List<TreeNode>();
        SysManage sysManage = new SysManage();
        treeList = sysManage.qrtMenuAndPlantTree();

        headMenuJson = BeanTools.ToJson(treeList);
    }

    [System.Web.Services.WebMethod]
    public static string GetString(string name)
    {
        return "Hello " + name;
    }
}
