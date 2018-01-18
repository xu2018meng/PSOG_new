using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace PSOG.Entity
{
    /// <summary>
    /// 组织机构类

    /// </summary>
    public class OrganiseUnit
    {
        public String ID;
        public String SYS_ORGAN_CODE;       //组织机构CODE
        public String SYS_ORGAN_P_CODE;     //父组织CODE
        public String SYS_ORGAN_NAME;       //名称
        public String SYS_ORGAN_TYPE;       //类型
        public string SYS_ORGAN_CRT_TIME;   //创建时间
        public string SYS_ORGAN_ORDER;      //排序
        public string SYS_ORGAN_is_use;     //是否有效
    }
}
