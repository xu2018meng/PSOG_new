using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    class ArtTchEntity
    {
    }

    public class JasonSeri
    {
        public String name;
        public String state;
        public List<excNode> exc;
    }
    public class excNode
    {
        public String twoID;
        public String Text;
    }

    //�豸
    public class Equipment
    {
        public string id;
        public string equipmentProcess;
        public string monitorObject_Name;
        public string monitorObject_Type;
        public string monitorObject_Source;
        public string monitorObject_Status;
        public string monitorObject_Url;
    }

    public class ArtSoftMeasure
    {
        public string id;
        public string describe; //����
        public string valuation;    //��ֵ
        public string time;     //ʱ��
        public string trend;    //����
        public string state;    //״̬
    }
}
