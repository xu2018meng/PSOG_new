using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    /// <summary>
    /// 装置类
    /// </summary>
    public class Plant
    {
        public String id;
        public String organtreeName;
        public String level;    //1:单位 2：装置
        public String realTimeDB;   //实时库
        public String realTimeDBIP; //实时库IP
        public String realTimeDBPort;   //实时库端口
        public String realTimeDBUser;   //实时库用户
        public String realTimeDBPass;   //实时库密码
        public String historyDB;    //历史库
        public String historyDBIP;    //历史库IP
        public String historyDBPort;   //历史库端口
        public String historyDBUser;   //历史库用户
        public String historyDBPass;   //历史库密码
        public string organtreeParentCode;
        public string organtreeCode;
        public bool isChecked;
    }
}
