using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class TreeNode
    {
        public string id;
        public string text;    //��ʾ�ֶ�
        public string state;    //
        public List<TreeNode> children = new List<TreeNode>();    //�ӽڵ�
        public bool isChecked;    //�Ƿ�ѡ��
        public string attributes;    //����
        public string iconCls;    //ͼ����ʽ
    }

    
}
