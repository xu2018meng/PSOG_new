using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
   public class Abnormal
    {
       public string AS_Equipment_ID;
       public string AS_Equipment_Name;
       public string AS_Equipment_State;
       public string AS_Equipment_FileName;
    }

    public class PCAByTime
    {
        public string startTime;
        public double value;
    }

    public class PCAModelTags
    {
        public int id;
        public string tagName;
        public string tagDescription;
        public string tagUnit;
        public double HHLimit;
        public double HLimit;
        public double LLLimit;
        public double LLimit;
    }

    public class FTAHistoryModel
    {
        public int id;
        public string ftaStartTime;
        public string ftaEndTime;
        public string ftaDuration;
    }

    public class FTAModelTags
    {
        public int id;
        public string tagName;
        public string tagDescription;
        public string tagState;
        public string tagStartTime;
        public double Limit;
        public string limitFlag;
    }
}
