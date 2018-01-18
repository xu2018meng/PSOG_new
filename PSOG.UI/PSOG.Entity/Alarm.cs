using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class Alarm
    {
    }

    //ƽ���ʷ���
    public class StableRateAlarm
    {
        public String  insItems;    //λ��
        public String insDescribe;    //����
        public float insCpkUSL;    //Cpk����USL
        public float insCpkLSL;    //Cpk����LSL
        public float insTechnicsH;    //��������
        public float insTechnicsL;    //��������
        public String insAlarmClass;    //�����ּ�\����
        public int insDataCount;    //��������
        public int insErrorDataCount;    //������
        public float insPercent;    //������
        public float insCpkCp;    //�Ƴ�׼ȷ��
        public float insCpkCa;    //�Ƴ̾�׼��
        public float insCpk;    //�Ƴ�����ָ��
        public float insCpkPrecent;    //CPK�ϸ���
        public String insCpkType;    //CPK����
        public String  id;    //
        public String  flagId;    //
    }

    /// <summary>
    /// ����������
    /// </summary>
    public class AlarmRealTime
    {
        public string items;    //λ��
        public string value;    //ֵ
        public string  describe;    //
        public string  state;    //״̬
        public string  historyID;    //
        public string  id;    //
        public string  cause;    //
        public string  measure;    //
        public string  alarmClass;    //
        public string  type;    //
        public string  color;    //
        public string  isClear;    //
        public string  isSound;    //
        public string  isTwinkle;    //
        public string  sound;    //
        public string  isCanel;    //
        public string  isClear1;    //
        public string  startTime;    //
        public string  endTime;    //
        public string  effect;    //
        public float  constraintHigh;    //
        public float constraintLow;    //
        public float technicsHigh;    //
        public float technicsLow;    //
        public String tableId;
        public string strtext;
        public string tempColor;
        public string duration; //����ʱ��
        public string space1 = "";//����
        public string space2 = "";//����
        public string rowcount = "";//��¼�ϲ�������
        public string prevent = ""; //������ʩ
    }

    /// <summary>
    /// ������ʷ��¼
    /// </summary>
    public class AlarmHis
    {
        public string id;    //
        public string items;    //λ��
        public string value;    //ֵ
        public string describe;    //
        public string state;    //״̬
        public string historyId;    //
        public string cause;    //
        public string measure;    //
        public string alarmClass;    //
        public string type;    //
        public string color;    //
        public string isClear;    //
        public string isSound;    //
        public string isTwinkle;    //
        public string sound;    //
        public string isCanel;    //
        public string startTime;    //
        public string endTime;    //
        public long duration; //����ʱ��
    }

    /// <summary>
    /// ��������ͳ����
    /// </summary>
    public class AlarmHisStatis
    {
        public string itemNo;
        public int number;
        public string describe;
        public string flagId = "";
    }

    /// <summary>
    /// ����ƫ���
    /// </summary>
    public class MonitorDetail
    {
        public string point;
        public string desc;
        public string val;
        public string unit;
        public string time;
        public string tagId;
        public string tagDCS;   //dcs��ֵ����
        public string tagXT;   //������ֵ����
        public string transState;    //�������ͣ�ȡ���ϸ�ҳ������ʱ�̣���DCS��ֵ����������ֵ����ȡһ��
        //�ȿ��Ƿ�DCS��ֵ��VResMSPC_TagDCSAlarmFlag<>0���ٿ��Ƿ񳬾�����ֵ��VResMSPC_TagXT2AlarmFlag<>0��
    }

    /// <summary>
    /// �ۺϷ���
    /// </summary>
    public class LevelAssess
    {
        public string area;
        public double averagerate;
        public double maxrate;
        public double disturbrate;
        public string level;
    }

    public class FaultTreeResult
    {
        public string id;
        public string ASName;//�쳣����
        public string status;//״̬
        public string unit;//��Ԫ
    }

    ////��������
    public class AlarmRule
    {
        public string topLevel;//����
        public string lowLevel;//����
        public string alarmTime1;//��ʼʱ��1
        public string alarmMan1;//��������Ա1
        public string alarmManName1;
        public string alarmTime2;
        public string alarmMan2;
        public string alarmManName2;
        public string alarmTime3;
        public string alarmMan3;
        public string alarmManName3;
    }

    ////Ԥ������
    public class EarlyAlarmRule {
        public string earlyAlarmId;
        public string earlyAlarmRule;
        public string earlyAlarmTime1;//��ʼʱ��1
        public string earlyAlarmMan1;//��������Ա1
        public string earlyAlarmManName1;
        public string earlyAlarmTime2;
        public string earlyAlarmMan2;
        public string earlyAlarmManName2;
        public string earlyAlarmTime3;
        public string earlyAlarmMan3;
        public string earlyAlarmManName3;
    }

    //�쳣����
    public class AbnormalStateRule {
        public string abStateId;
        public string abStateRule;
        public string abStateTime1;//��ʼʱ��1
        public string abStateMan1;//��������Ա1
        public string abStateManName1;
        public string abStateTime2;
        public string abStateMan2;
        public string abStateManName2;
        public string abStateTime3;
        public string abStateMan3;
        public string abStateManName3;
    }
}
