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

public partial class graphic_maintain_tree : System.Web.UI.Page
{
    public string headMenuJson = "[]";
    public IList plantList = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        String userId = ((SysUser)Session[CommonStr.session_user]).userId;
        String plantIds = new SysManage().qryPlantsByUserId(userId);
        plantList = new MainPage().qryPlantList(plantIds);


        TreeNode headNode = new TreeNode();
        for (int i = 0; i < plantList.Count; i++)
        {
            Plant plant = (Plant)plantList[i];
            TreeNode node = new TreeNode();
            if ("1".Equals(plant.level))
            {
                headNode.id = plant.organtreeCode;
                headNode.text = plant.organtreeName;
                headNode.state = "open";
                headNode.attributes = "0:root";
                headNode.iconCls = "sysMan_organ";
            }
            else
            {
                node.id = plant.id;
                node.text = plant.organtreeName;
                node.state = "open";
                node.attributes = "0:plant";
                node.iconCls = "sysMan_plant_click";
                headNode.children.Add(node);
            }
        }


        List<TreeNode> treeList = new List<TreeNode>();
        treeList.Add(headNode);

        headMenuJson = BeanTools.ToJson(treeList);
    }


    [System.Web.Services.WebMethod]
    public static string GetString(string name)
    {
        return "Hello " + name;
    }
}
