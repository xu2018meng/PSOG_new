using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    public class Alarm
    {
    }

    //平稳率分析
    public class StableRateAlarm
    {
        public String  insItems;    //位号
        public String insDescribe;    //描述
        public float insCpkUSL;    //Cpk上限USL
        public float insCpkLSL;    //Cpk下限LSL
        public float insTechnicsH;    //工艺上限
        public float insTechnicsL;    //工艺下限
        public String insAlarmClass;    //报警分级\类型
        public int insDataCount;    //数据总数
        public int insErrorDataCount;    //超标数
        public float insPercent;    //控制率
        public float insCpkCp;    //制程准确度
        public float insCpkCa;    //制程精准度
        public float insCpk;    //制程能力指数
        public float insCpkPrecent;    //CPK合格率
        public String insCpkType;    //CPK类型
        public String  id;    //
        public String  flagId;    //
    }

    /// <summary>
    /// 参数报警类
    /// </summary>
    public class AlarmRealTime
    {
        public string items;    //位号
        public string value;    //值
        public string  describe;    //
        public string  state;    //状态
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
        public string duration; //持续时间
        public string space1 = "";//空项
        public string space2 = "";//空项
        public string rowcount = "";//记录合并的行数
        public string prevent = ""; //防范措施
    }

    /// <summary>
    /// 报警历史记录
    /// </summary>
    public class AlarmHis
    {
        public string id;    //
        public string items;    //位号
        public string value;    //值
        public string describe;    //
        public string state;    //状态
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
        public long duration; //持续时间
    }

    /// <summary>
    /// 报警次数统计类
    /// </summary>
    public class AlarmHisStatis
    {
        public string itemNo;
        public int number;
        public string describe;
        public string flagId = "";
    }

    /// <summary>
    /// 报警偏离点
    /// </summary>
    public class MonitorDetail
    {
        public string point;
        public string desc;
        public string val;
        public string unit;
        public string time;
        public string tagId;
        public string tagDCS;   //dcs阀值区间
        public string tagXT;   //经验阈值区间
        public string transState;    //超限类型（取在上个页面点击的时刻，超DCS阈值、超经验阈值，二取一，
        //先看是否超DCS阈值即VResMSPC_TagDCSAlarmFlag<>0，再看是否超经验阈值即VResMSPC_TagXT2AlarmFlag<>0）
    }

    /// <summary>
    /// 综合分析
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
        public string ASName;//异常名称
        public string status;//状态
        public string unit;//单元
    }

    ////报警规则
    public class AlarmRule
    {
        public string topLevel;//上限
        public string lowLevel;//下限
        public string alarmTime1;//开始时间1
        public string alarmMan1;//发送至人员1
        public string alarmManName1;
        public string alarmTime2;
        public string alarmMan2;
        public string alarmManName2;
        public string alarmTime3;
        public string alarmMan3;
        public string alarmManName3;
    }

    ////预警规则
    public class EarlyAlarmRule {
        public string earlyAlarmId;
        public string earlyAlarmRule;
        public string earlyAlarmTime1;//开始时间1
        public string earlyAlarmMan1;//发送至人员1
        public string earlyAlarmManName1;
        public string earlyAlarmTime2;
        public string earlyAlarmMan2;
        public string earlyAlarmManName2;
        public string earlyAlarmTime3;
        public string earlyAlarmMan3;
        public string earlyAlarmManName3;
    }

    //异常规则
    public class AbnormalStateRule {
        public string abStateId;
        public string abStateRule;
        public string abStateTime1;//开始时间1
        public string abStateMan1;//发送至人员1
        public string abStateManName1;
        public string abStateTime2;
        public string abStateMan2;
        public string abStateManName2;
        public string abStateTime3;
        public string abStateMan3;
        public string abStateManName3;
    }
}
