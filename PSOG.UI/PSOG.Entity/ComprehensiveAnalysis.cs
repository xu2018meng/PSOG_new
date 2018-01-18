using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace PSOG.Entity
{
    /// <summary>
    /// ×ÛºÏ±¨¾¯·ÖÎö
    /// </summary>
    public class ComprehensiveAnalysis
    {
        public String zhStartTime;
        public String zhEndtime;
        public String zhAlarmNumbers;
        public double zhPercent;
        public String zhAlarmItems;
    }

    public class AlarmLevel
    {
        public double maxrate;
        public double disturbrate;
        public double averagerate;
        public string area;
        public string level;
        public double disturbrate_goal;
        public double averagerate_goal;
        public double maxrate_goal;
        public string level_goal;
    }

    public class AlarmLevelTotal
    {
        public string plant_num;
        public string index_name;
        public string index_goal;
        public string remark;
    }

    public class AlarmLevelTrend
    {
        public double maxrate;
        public double averagerate;
        public string area;
        public int level;
        public string startTime;
    }

    public class AlarmTop20
    {
        public int count;
        public double percent;
        public string tagname;
        public string description;
        public string area;
    }

    public class AlarmChattering
    {
        public int chatteringCount;
        public int totalCount;
        public double percent;
        public string tagname;
        public string description;
        public string area;
    }

    public class AlarmStanding
    {
        public string startTime;
        public string endTime;
        public double alarmInterval;
        public string tagname;
        public string description;
        public string area;
    }

    public class AlarmPriority
    {
        public double lowPercent;
        public double mediumPercent;
        public double highPercent;
        public double criticalPercent;
        public string area;
    }

    public class AlarmDistributionByTime
    {
        public string startTime;
        public string endTime;
        public int alarmCount;
        public string area;
        public int tagCount;
    }

    public class CompAnaly
    {
        public float maxpercent;
        public float perturbationRate;
        public string chartStr;
        public string pieStr;
        public IList zhList = new ArrayList();
    }

    public class IndexOrder
    {
        public float value;
        public string name;
    }

    public class OQIOutline
    {
        public float value;
        public string procName;
        public float valueFive;
        public float valueFour;
        public float valuethree;
        public float valueTwo;
        public float valueOne;
    }

    public class OQIMainPage
    {
        public float allPercent;
        public string area;
        public float countPercent;
        public float CPKPercent;
        public float score;
    }

    public class OQIPriority
    {
        public int AAAvalue;
        public int AAvalue;
        public int Avalue;
        public int Bvalue;
        public int Cvalue;
        public int Dvalue;
        public string procName;
    }

    public class PassrateDistributionByTime
    {
        public string startTime;
        public string endTime;
        public float OQICount;
        public string area;
    }
}
