using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    /// <summary>
    /// װ����
    /// </summary>
    public class Plant
    {
        public String id;
        public String organtreeName;
        public String level;    //1:��λ 2��װ��
        public String realTimeDB;   //ʵʱ��
        public String realTimeDBIP; //ʵʱ��IP
        public String realTimeDBPort;   //ʵʱ��˿�
        public String realTimeDBUser;   //ʵʱ���û�
        public String realTimeDBPass;   //ʵʱ������
        public String historyDB;    //��ʷ��
        public String historyDBIP;    //��ʷ��IP
        public String historyDBPort;   //��ʷ��˿�
        public String historyDBUser;   //��ʷ���û�
        public String historyDBPass;   //��ʷ������
        public string organtreeParentCode;
        public string organtreeCode;
        public bool isChecked;
    }
}
