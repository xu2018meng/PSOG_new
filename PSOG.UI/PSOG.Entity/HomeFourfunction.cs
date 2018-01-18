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
        public string modelName;//样品名称
        public string Cjname;//采样名称
        public string projectName;//分析项目
        public string value;//实际值
        public string units;//单位
        public string status;//状态
        public string high;//高限
        public string low;//低线
        public string time;//时间
    }

    /// <summary>
    /// 从数据库中读取 报警信息
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
        public string continuTime;//持续时间
    }

    /// <summary>
    /// 从数据库中读取 异常工况信息
    /// </summary>
    public class ASList
    {
        public string name;
        public List<ASInfo> content;
    }

    public class ASInfo
    {
        public string id;
        public string ASName;//异常名称
        public string status;//状态
        public string unit;//单元
        public string corrInstru;//关联仪表
        public string duration;//持续时间
        public string startT;//开始时间
    }

    public class NormalNodeList
    {
        public int ID;
        public float Index;
        public string Describe;
        public string Group;  //节点所属分组
        public string nodeState;    //节点状态
    }

    //主页报警
    public class HomeAlarmInfo {
        public String alarmId;
        public String alarmRuleId;//规则表主键
        public String alarmBitNo;
        public String alarmTagDesc;
        public String alarmRealValue;
        public String alarmStatus;
        public String alarmType;
        public String alarmStartTime;
        public String alarmSustainTime;
    }

    //主页预警
    public class HomeEarlyAlarmInfo
    {
        public String earlyAlarmId;
        public String earlyAlarmRuleId;//规则表主键
        public String earlyAlarmBitNo;
        public String earlyAlarmTagDesc;
        public String earlyAlarmRealValue;
        public String earlyAlarmStatus;
        public String earlyAlarmType;
        public String earlyAlarmStartTime;
        public String earlyAlarmSustainTime;
    }

    //主页异常
    public class HomeAbStateInfo
    {
        public String abStateId;
        public String abStateRuleId;//规则表主键
        public String abStateName;
        public String abStateDesc;
        public String abStateStatus;
        public String abStateUnit;
        public String abStateMeter;
        public String abStateStartTime;
        public String abStateSustainTime;
    }

    /// <summary>
    /// 从数据库中读取报警信息
    /// </summary>
    public class HomeAlarmList
    {
        public string name;
        public List<HomeAlarmInfo> content;
    }

    /// <summary>
    /// 从数据库中读取预警信息
    /// </summary>
    public class HomeEarlyAlarmList
    {
        public string name;
        public List<HomeEarlyAlarmInfo> content;
    }

    /// <summary>
    /// 从数据库中读取异常信息
    /// </summary>
    public class HomeAbStateList
    {
        public string name;
        public List<HomeAbStateInfo> content;
    }


}
