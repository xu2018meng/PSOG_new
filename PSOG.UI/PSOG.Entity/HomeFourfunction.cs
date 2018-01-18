using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class HomeFourfunction
    {
        public string name;
        public List<homeNode> content;
    }

    public class homeNode
    {
        public String name;
        public String state;
    }
    public class qualityList
    {
        public string name;
        public List<qualityInfo> content;
    }

    public class qualityInfo
    {
        public string num;
        public string modelName;//��Ʒ����
        public string Cjname;//��������
        public string projectName;//������Ŀ
        public string value;//ʵ��ֵ
        public string units;//��λ
        public string status;//״̬
        public string high;//����
        public string low;//����
        public string time;//ʱ��
    }

    /// <summary>
    /// �����ݿ��ж�ȡ ������Ϣ
    /// </summary>
    public class AlarmList
    {
        public string name;
        public List<AlarmInfo> content;
    }
    public class AlarmInfo
    {
        public string num;
        public string item;
        public string value;
        public string state;
        public string startTime;
        public string continuTime;//����ʱ��
    }

    /// <summary>
    /// �����ݿ��ж�ȡ �쳣������Ϣ
    /// </summary>
    public class ASList
    {
        public string name;
        public List<ASInfo> content;
    }

    public class ASInfo
    {
        public string id;
        public string ASName;//�쳣����
        public string status;//״̬
        public string unit;//��Ԫ
        public string corrInstru;//�����Ǳ�
        public string duration;//����ʱ��
        public string startT;//��ʼʱ��
    }

    public class NormalNodeList
    {
        public int ID;
        public float Index;
        public string Describe;
        public string Group;  //�ڵ���������
        public string nodeState;    //�ڵ�״̬
    }

    //��ҳ����
    public class HomeAlarmInfo {
        public String alarmId;
        public String alarmRuleId;//���������
        public String alarmBitNo;
        public String alarmTagDesc;
        public String alarmRealValue;
        public String alarmStatus;
        public String alarmType;
        public String alarmStartTime;
        public String alarmSustainTime;
    }

    //��ҳԤ��
    public class HomeEarlyAlarmInfo
    {
        public String earlyAlarmId;
        public String earlyAlarmRuleId;//���������
        public String earlyAlarmBitNo;
        public String earlyAlarmTagDesc;
        public String earlyAlarmRealValue;
        public String earlyAlarmStatus;
        public String earlyAlarmType;
        public String earlyAlarmStartTime;
        public String earlyAlarmSustainTime;
    }

    //��ҳ�쳣
    public class HomeAbStateInfo
    {
        public String abStateId;
        public String abStateRuleId;//���������
        public String abStateName;
        public String abStateDesc;
        public String abStateStatus;
        public String abStateUnit;
        public String abStateMeter;
        public String abStateStartTime;
        public String abStateSustainTime;
    }

    /// <summary>
    /// �����ݿ��ж�ȡ������Ϣ
    /// </summary>
    public class HomeAlarmList
    {
        public string name;
        public List<HomeAlarmInfo> content;
    }

    /// <summary>
    /// �����ݿ��ж�ȡԤ����Ϣ
    /// </summary>
    public class HomeEarlyAlarmList
    {
        public string name;
        public List<HomeEarlyAlarmInfo> content;
    }

    /// <summary>
    /// �����ݿ��ж�ȡ�쳣��Ϣ
    /// </summary>
    public class HomeAbStateList
    {
        public string name;
        public List<HomeAbStateInfo> content;
    }


}
