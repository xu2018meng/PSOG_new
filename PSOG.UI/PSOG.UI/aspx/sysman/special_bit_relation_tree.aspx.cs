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

public partial class aspx_sysman_specialBit_relation_tree : System.Web.UI.Page
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
                node.state = "closed";
                node.attributes = "3:plant";
                node.iconCls = "sysMan_plant_click";
               

                TreeNode bjgzNode = new TreeNode();
                bjgzNode.id = "bjgz#" + plant.id;
                bjgzNode.text = "报警规则";
                bjgzNode.state = "closed";
                bjgzNode.attributes = "4:gz";
                bjgzNode.iconCls = "sysMan_gztype";
                List<TreeNode> specialList = AddSpecialNode(bjgzNode.id);
                bjgzNode.children.AddRange(specialList);
                node.children.Add(bjgzNode);

                TreeNode yjgzNode = new TreeNode();
                yjgzNode.id = "yjgz#" + plant.id;
                yjgzNode.text = "预警规则";
                yjgzNode.state = "closed";
                yjgzNode.attributes = "4:gz";
                yjgzNode.iconCls = "sysMan_gztype";
                List<TreeNode> yjspecialList = AddSpecialNode(yjgzNode.id);
                yjgzNode.children.AddRange(yjspecialList);
                node.children.Add(yjgzNode);

                TreeNode ycgzNode = new TreeNode();
                ycgzNode.id = "ycgz#" + plant.id;
                ycgzNode.text = "异常规则";
                ycgzNode.state = "closed";
                ycgzNode.attributes = "4:gz";
                ycgzNode.iconCls = "sysMan_gztype";
                List<TreeNode> ycspecialList = AddSpecialNode(ycgzNode.id);
                ycgzNode.children.AddRange(ycspecialList);
                node.children.Add(ycgzNode);


                headNode.children.Add(node);
            }
        }


        List<TreeNode> treeList = new List<TreeNode>();
        treeList.Add(headNode);

        headMenuJson = BeanTools.ToJson(treeList);
    }

    //添加专业节点
    public List<TreeNode> AddSpecialNode(String parentCode) {
        List<TreeNode> list = new List<TreeNode>();

        TreeNode gyNode = new TreeNode();
        gyNode.id = "gy#" + parentCode;
        gyNode.text = "工艺";
        gyNode.state = "open";
        gyNode.attributes = "0:type";
        gyNode.iconCls = "sysMan_leafnode";

        TreeNode zlNode = new TreeNode();
        zlNode.id = "zl#" + parentCode;
        zlNode.text = "质量";
        zlNode.state = "open";
        zlNode.attributes = "0:type";
        zlNode.iconCls = "sysMan_leafnode";

        TreeNode shbNode = new TreeNode();
        shbNode.id = "sb#" + parentCode;
        shbNode.text = "设备";
        shbNode.state = "open";
        shbNode.attributes = "0:type";
        shbNode.iconCls = "sysMan_leafnode";

        TreeNode gygcNode = new TreeNode();
        gygcNode.id = "gygc#" + parentCode;
        gygcNode.text = "公用工程";
        gygcNode.state = "open";
        gygcNode.attributes = "0:type";
        gygcNode.iconCls = "sysMan_leafnode";


        list.Add(gyNode);
        list.Add(zlNode);
        list.Add(shbNode);
        list.Add(gygcNode);

        return list;
    }


    [System.Web.Services.WebMethod]
    public static string GetString(string name)
    {
        return "Hello " + name;
    }
}
