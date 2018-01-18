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

public partial class aspx_tree_plant_new : System.Web.UI.Page
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

                TreeNode mainNode = new TreeNode();
                mainNode.id = "main#" + plant.id;
                mainNode.text = "主页";
                mainNode.state = "open";
                mainNode.attributes = "0:main";
                mainNode.iconCls = "sysMan_homepage";
                node.children.Add(mainNode);


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


                //TreeNode modalNode = new TreeNode();
                //modalNode.id = "modal#" + plant.id;
                //modalNode.text = "模型查看";
                //modalNode.state = "closed";
                //modalNode.attributes = "2:modal";
                //modalNode.iconCls = "sysMan_gztype";

                //TreeNode stModalNode = new TreeNode();
                //stModalNode.id = "stmodal#" + plant.id;
                //stModalNode.text = "状态监测模型库";
                //stModalNode.state = "open";
                //stModalNode.attributes = "0:stmodal";
                //stModalNode.iconCls = "sysMan_leafnode";
                //modalNode.children.Add(stModalNode);

                //TreeNode baseModalNode = new TreeNode();
                //baseModalNode.id = "basemodal#" + plant.id;
                //baseModalNode.text = "根原因分析模型库";
                //baseModalNode.state = "open";
                //baseModalNode.attributes = "0:basemodal";
                //baseModalNode.iconCls = "sysMan_leafnode";
                //modalNode.children.Add(baseModalNode);

                //node.children.Add(modalNode);

                //TreeNode operatorNode = new TreeNode();
                //operatorNode.id = "operator#" + plant.id;
                //operatorNode.text = "操作质量";
                //operatorNode.state = "open";
                //operatorNode.attributes = "0:operator";
                //operatorNode.iconCls = "sysMan_leafnode";
                //node.children.Add(operatorNode);

                headNode.children.Add(node);
            }
        }


        List<TreeNode> treeList = new List<TreeNode>();
        treeList.Add(headNode);

        headMenuJson = BeanTools.ToJson(treeList);
    }

    //添加专业节点
    public List<TreeNode> AddSpecialNode(String parentCode)
    {
        List<TreeNode> list = new List<TreeNode>();

        TreeNode gyNode = new TreeNode();
        gyNode.id = "gy#" + parentCode;
        gyNode.text = "工艺";
        gyNode.state = "closed";
        gyNode.attributes = "1:type";
        gyNode.iconCls = "sysMan_sort";

        TreeNode zlNode = new TreeNode();
        zlNode.id = "zl#" + parentCode;
        zlNode.text = "质量";
        zlNode.state = "closed";
        zlNode.attributes = "1:type";
        zlNode.iconCls = "sysMan_sort";

        TreeNode shbNode = new TreeNode();
        shbNode.id = "sb#" + parentCode;
        shbNode.text = "设备";
        shbNode.state = "closed";
        shbNode.attributes = "1:type";
        shbNode.iconCls = "sysMan_sort";

        TreeNode gygcNode = new TreeNode();
        gygcNode.id = "gygc#" + parentCode;
        gygcNode.text = "公用工程";
        gygcNode.state = "closed";
        gygcNode.attributes = "1:type";
        gygcNode.iconCls = "sysMan_sort";


        list.Add(gyNode);
        list.Add(zlNode);
        list.Add(shbNode);
        list.Add(gygcNode);

        return list;
    }

}
