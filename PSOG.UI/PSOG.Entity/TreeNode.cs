using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class TreeNode
    {
        public string id;
        public string text;    //显示字段
        public string state;    //
        public List<TreeNode> children = new List<TreeNode>();    //子节点
        public bool isChecked;    //是否选中
        public string attributes;    //属性
        public string iconCls;    //图标样式
    }

    
}
