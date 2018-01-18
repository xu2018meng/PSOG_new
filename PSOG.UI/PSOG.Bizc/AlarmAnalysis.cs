using System;
using System.Collections.Generic;
using System.Text;
using PSOG.Entity;
using PSOG.DAO;
using PSOG.DAO.impl;
using System.Data;
using PSOG.Common;
using System.Collections;
using System.Data.SqlClient;
using Anychart;
using System.Xml;
using System.Web.Script.Serialization;
using System.Globalization;

namespace PSOG.Bizc
{
    /// <summary>
    /// 报警分析
    /// </summary>
    public class AlarmAnalysis
    {
        public System.Data.DataTable skinDataGridViewZH = new System.Data.DataTable();
        public System.Data.DataTable ALARMSQLTab = new System.Data.DataTable();
        GraphData m_ZHGraphData = new GraphData();
        List<DateTime> SearchTime = new List<DateTime>();
        bool ZHFlag = false;
        double Maxpercent = 0, Prpercent = 0;
        XmlDocument XMLDoc;
        XmlNode seriesNode;
        string CheckBuildingId = null;
        string hasPie = null;
        XmlNode pieSeriesNode;
        string anychartName = "";


        #region 参数分析
        /// <summary>
        /// 参数分析
        /// </summary>
        public EasyUIData parameterAlarm(Plant plant)  //int page, int rows
        {
            Dao dao = new Dao(plant,false);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            String sql = "select * from RTResEx_AlarmRealTime  where IsClear = 0 order by id ";    //, count(1) over() rowno
            DataSet ds = dao.executeQuery(sql); //, page, rows
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int ss = ds.Tables[0].Rows.Count;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmRealTime alarm = new AlarmRealTime();
                    alarm.items = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Items"]);
                    float temp = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_Value"]);
                    alarm.value = Convert.ToString(Math.Round(temp,4));
                    alarm.describe = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Describe"]);
                    alarm.state = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_State"]);
                    alarm.historyID = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_HistoryID"]);
                    alarm.id = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_ID"]);
                    alarm.cause = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Cause"]);
                    alarm.measure = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Measure"]);
                    String AlarmClass = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_AlarmClass"]);
                    alarm.type = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Type"]);
                    alarm.color = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Color"]);
                    alarm.isClear = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsClear"]);
                    alarm.isSound = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsSound"]);
                    alarm.isTwinkle = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsTwinkle"]);
                    alarm.sound = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Sound"]);
                    alarm.isCanel = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsCanel"]);
                    alarm.isClear1 = BeanTools.ObjectToString(dr["IsClear"]);
                    alarm.startTime = BeanTools.DataTimeToString(dr["RTResEx_AlarmRealTime_StartTime"]);
                    alarm.effect = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Effect"]);
                    float constraintHigh = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_constraintHigh"]);
                    alarm.constraintHigh = constraintHigh;
                    float constraintLow = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_ConstraintLow"]);
                    alarm.constraintLow = constraintLow;
                    float technicsHigh = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_TechnicsHigh"]);
                    alarm.technicsHigh = technicsHigh;
                    float technicsLow = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_TechnicsLow"]);
                    alarm.technicsLow = technicsLow;
                    alarm.tableId = BeanTools.ObjectToString(dr["ID"]);

                    switch (AlarmClass)
                    {
                        case "A":
                            AlarmClass = "高";
                            break;
                        case "B":
                            AlarmClass = "低";
                            break;
                        case "C":
                            AlarmClass = "";
                            break;
                    }
                    alarm.alarmClass = AlarmClass;

                    String strstate = alarm.state;
                    String tempColor = "", strtext = "";
                    switch (strstate)
                    {
                        case "高高报":
                            tempColor = "Red";
                            strtext = "高高";
                            break;
                        case "高报":
                            if (temp < technicsHigh + (constraintHigh - technicsHigh) / 3)
                            {
                                tempColor = "Yellow";
                                strtext = "低";
                            }
                            else if (temp < technicsHigh + 2 * (constraintHigh - technicsHigh) / 3)
                            {
                                tempColor = "Orange";
                                strtext = "高";
                            }
                            else
                            {
                                tempColor = "Red";
                                strtext = "高高";
                            }
                            break;
                        case "低报":
                            if (temp > technicsLow - (technicsLow - constraintLow) / 3)
                            {
                                tempColor = "Yellow";
                                strtext = "低";
                            }
                            else if (temp > technicsHigh - 2 * (technicsLow - constraintLow) / 3)
                            {
                                tempColor = "Orange";
                                strtext = "高";
                            }
                            else
                            {
                                tempColor = "Yellow";
                                strtext = "高高";
                            }
                            break;
                        case "低低报":
                            tempColor = "Red";
                            strtext = "高高";
                            break;
                    }
                    alarm.tempColor = tempColor;
                    alarm.strtext = strtext;
                    alarm.duration = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_DurationMin"]);//((DateTime.Now.Ticks - DateTime.Parse(alarm.startTime).Ticks) / 555000000).ToString();
                    System.Drawing.Color color = System.Drawing.Color.FromArgb(Int32.Parse(alarm.color));
                    alarm.color = "rgb(" + color.R + "," + color.G + "," + color.B + ")";
                    list.Add(alarm);
                }                
            }
            grid.rows = list;
            return grid;
        }

        #endregion


        #region 设备相关的预报警点参数分析
        /// <summary>
        /// 设备相关的预报警点参数分析
        /// </summary>
        public EasyUIData parameterDeviceAlarm(Plant plant,string deviceId,string alarmFlag)  //int page, int rows
        {
            IDao dao = new Dao(plant, false);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            StringBuilder sql = new StringBuilder();
            if ("alarm".Equals(alarmFlag)) {
                sql.Append("select t.* from RTResEx_AlarmRealTime t");
                sql.AppendFormat(" INNER JOIN {0}.dbo.PSOG_AbnormalAlarmDeviceConfig d",plant.historyDB);
                sql.Append(" on t.RTResEx_AlarmRealTime_ID = d.AlarmDeviceConfig_TagId");
                sql.AppendFormat(" and d.AlarmDeviceConfig_DeviceId='{0}'",deviceId);
                sql.Append(" where t.IsClear = 0 ORDER BY t.ID");
            }
            else if ("earlyAlarm".Equals(alarmFlag))
            {
                sql.Append("select t.* from RTResEx_AlarmRealTime t");
                sql.AppendFormat(" INNER JOIN {0}.dbo.PSOG_AbnormalEarlyWarnDeviceConfig d", plant.historyDB);
                sql.Append(" on t.RTResEx_AlarmRealTime_ID = d.EarlyWarnDeviceConfig_TagId");
                sql.AppendFormat(" and d.EarlyWarnDeviceConfig_DeviceId='{0}'", deviceId);
                sql.Append(" where t.IsClear = 0 ORDER BY t.ID");
            }
            else {
                sql.Append("select t.* from RTResEx_AlarmRealTime t");
                sql.AppendFormat(" INNER JOIN {0}.dbo.PSOG_AbnormalAlarmDeviceConfig d", plant.historyDB);
                sql.Append(" on t.RTResEx_AlarmRealTime_ID = d.AlarmDeviceConfig_TagId");
                sql.AppendFormat(" and d.AlarmDeviceConfig_DeviceId='{0}'", deviceId);
                sql.Append(" where t.IsClear = 0 ");
                sql.Append(" UNION ");
                sql.Append("select t1.* from RTResEx_AlarmRealTime t1");
                sql.AppendFormat(" INNER JOIN {0}.dbo.PSOG_AbnormalEarlyWarnDeviceConfig d", plant.historyDB);
                sql.Append(" on t1.RTResEx_AlarmRealTime_ID = d.EarlyWarnDeviceConfig_TagId");
                sql.AppendFormat(" and d.EarlyWarnDeviceConfig_DeviceId='{0}'", deviceId);
                sql.Append(" where t1.IsClear = 0");
                sql.Append(" ORDER BY ID");
            }
            DataSet ds = dao.executeQuery(sql.ToString()); //, page, rows
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmRealTime alarm = new AlarmRealTime();
                    alarm.items = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Items"]);
                    float temp = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_Value"]);
                    alarm.value = Convert.ToString(Math.Round(temp, 4));
                    alarm.describe = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Describe"]);
                    alarm.state = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_State"]);
                    alarm.historyID = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_HistoryID"]);
                    alarm.id = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_ID"]);
                    alarm.cause = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Cause"]);
                    alarm.measure = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Measure"]);
                    String AlarmClass = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_AlarmClass"]);
                    alarm.type = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Type"]);
                    alarm.color = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Color"]);
                    alarm.isClear = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsClear"]);
                    alarm.isSound = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsSound"]);
                    alarm.isTwinkle = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsTwinkle"]);
                    alarm.sound = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Sound"]);
                    alarm.isCanel = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_IsCanel"]);
                    alarm.isClear1 = BeanTools.ObjectToString(dr["IsClear"]);
                    alarm.startTime = BeanTools.DataTimeToString(dr["RTResEx_AlarmRealTime_StartTime"]);
                    alarm.effect = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Effect"]);
                    float constraintHigh = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_constraintHigh"]);
                    alarm.constraintHigh = constraintHigh;
                    float constraintLow = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_ConstraintLow"]);
                    alarm.constraintLow = constraintLow;
                    float technicsHigh = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_TechnicsHigh"]);
                    alarm.technicsHigh = technicsHigh;
                    float technicsLow = BeanTools.ObjectToFloat(dr["RTResEx_AlarmRealTime_TechnicsLow"]);
                    alarm.technicsLow = technicsLow;
                    alarm.tableId = BeanTools.ObjectToString(dr["ID"]);

                    switch (AlarmClass)
                    {
                        case "A":
                            AlarmClass = "高";
                            break;
                        case "B":
                            AlarmClass = "低";
                            break;
                        case "C":
                            AlarmClass = "";
                            break;
                    }
                    alarm.alarmClass = AlarmClass;

                    String strstate = alarm.state;
                    String tempColor = "", strtext = "";
                    switch (strstate)
                    {
                        case "高高报":
                            tempColor = "Red";
                            strtext = "高高";
                            break;
                        case "高报":
                            if (temp < technicsHigh + (constraintHigh - technicsHigh) / 3)
                            {
                                tempColor = "Yellow";
                                strtext = "低";
                            }
                            else if (temp < technicsHigh + 2 * (constraintHigh - technicsHigh) / 3)
                            {
                                tempColor = "Orange";
                                strtext = "高";
                            }
                            else
                            {
                                tempColor = "Red";
                                strtext = "高高";
                            }
                            break;
                        case "低报":
                            if (temp > technicsLow - (technicsLow - constraintLow) / 3)
                            {
                                tempColor = "Yellow";
                                strtext = "低";
                            }
                            else if (temp > technicsHigh - 2 * (technicsLow - constraintLow) / 3)
                            {
                                tempColor = "Orange";
                                strtext = "高";
                            }
                            else
                            {
                                tempColor = "Yellow";
                                strtext = "高高";
                            }
                            break;
                        case "低低报":
                            tempColor = "Red";
                            strtext = "高高";
                            break;
                    }
                    alarm.tempColor = tempColor;
                    alarm.strtext = strtext;
                    alarm.duration = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_DurationMin"]);//((DateTime.Now.Ticks - DateTime.Parse(alarm.startTime).Ticks) / 555000000).ToString();
                    System.Drawing.Color color = System.Drawing.Color.FromArgb(Int32.Parse(alarm.color));
                    alarm.color = "rgb(" + color.R + "," + color.G + "," + color.B + ")";
                    list.Add(alarm);
                }
            }
            grid.rows = list;
            return grid;
        }

        #endregion




        #region 平稳率分析
        /// <summary>
        /// 平稳率分析
        /// </summary>
        public EasyUIData StableRateAnaly(DateTime starttime, DateTime endtime, Plant plant, int page, int rows)
        {
            IDao dao = new Dao(plant,true);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList(); 

            if (null != starttime && null != endtime)
            {
                SqlParameter[] parames = new SqlParameter[3];
                parames[0] = new SqlParameter("@SearchStartTime", starttime.ToString("yyyy-MM-dd HH:mm:ss"));
                parames[1] = new SqlParameter("@SearchEndTime", endtime.ToString("yyyy-MM-dd HH:mm:ss"));
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;

                SqlDataReader dr = dao.executeProc("procInsSearch_10HisData", parames);
                if (null != dr)
                {
                    int i = 1;
                    int minRow = (page-1) * rows + 1;
                    int maxRow = page * rows;
                    while (dr.Read())
                    {
                        StableRateAlarm alarm = new StableRateAlarm();
                        alarm.id = BeanTools.ObjectToString(dr["id"]);
                        alarm.insItems = BeanTools.ObjectToString(dr["insItems"]);
                        alarm.insDescribe = BeanTools.ObjectToString(dr["insDescribe"]);
                        alarm.insCpkUSL = BeanTools.ObjectToFloat(dr["insCpkUSL"]);
                        alarm.insCpkLSL = BeanTools.ObjectToFloat(dr["insCpkLSL"]);
                        alarm.insTechnicsH = BeanTools.ObjectToFloat(dr["insTechnicsH"]);
                        alarm.insTechnicsL = BeanTools.ObjectToFloat(dr["insTechnicsL"]);
                        alarm.insAlarmClass = BeanTools.ObjectToString(dr["insAlarmClass"]);
                        alarm.insDataCount = BeanTools.ObjectToInt(dr["insDataCount"]);
                        alarm.insErrorDataCount = BeanTools.ObjectToInt(dr["insErrorDataCount"]);
                        alarm.insPercent = (float)Math.Round(BeanTools.ObjectToFloat(dr["insPercent"]), 7);
                        alarm.insCpkCp = (float)Math.Round(BeanTools.ObjectToFloat(dr["insCpkCp"]), 7);
                        alarm.insCpkCa = (float)Math.Round(BeanTools.ObjectToFloat(dr["insCpkCa"]), 7);
                        alarm.insCpk = (float)Math.Round(BeanTools.ObjectToFloat(dr["insCpk"]), 7);
                        alarm.insCpkPrecent = (float)Math.Round(BeanTools.ObjectToFloat(dr["insCpkPrecent"]), 7);
                        alarm.insCpkType = BeanTools.ObjectToString(dr["insCpkType"]);
                        alarm.flagId = BeanTools.ObjectToString(dr["flagId"]);

                        if (maxRow >= i && minRow <= i)
                        {
                            list.Add(alarm);
                        }
                        i++;                        

                    }
                    grid.total = --i;
                }
            }
            dao.closeConn();
            grid.rows = list;
            return grid;
        }

        #endregion

        /// <summary>
        /// 综合评估(最新)
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData alarmAnaysisOutline(String starttime, String endtime, String DBName,String dbSource)
        {

            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_Grade '" + starttime + "','" + endtime + "'," + dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_Grade");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        for (i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            AlarmLevel compAnaly = new AlarmLevel();
                            double averageRate = double.Parse(ds.Tables[0].Rows[i]["AvrPercent"].ToString());
                            double maxRate = (double)ds.Tables[0].Rows[i]["MaxPercent"];
                            double disturbRate = (double)ds.Tables[0].Rows[i]["PerturbationRate"];
                            compAnaly.averagerate = averageRate;
                            compAnaly.maxrate = maxRate;
                            compAnaly.disturbrate = disturbRate;
                            compAnaly.level = alarmLevelAnaysis(averageRate, maxRate);
                            compAnaly.area = ds.Tables[0].Rows[i]["PlantName"].ToString();
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            compAnaly.averagerate_goal = 1.0;
                            compAnaly.maxrate_goal = 10.0;
                            compAnaly.disturbrate_goal = 5;
                            compAnaly.level_goal = "可预测的";
                            list.Add(compAnaly);
                        }

                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }

            dao.closeConn();

            grid.rows = list;
            return grid;
        }
        /// <summary>
        /// 综合评估趋势
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList alarmAnaysisOutlineTrend(String starttime, String endtime, String DBName,String dbSource)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);
            string[] split_start = starttime.Split(' ');
            string[] split_end = endtime.Split(' ');
            string startDay = split_start[0] + " 00:00:00";
            string endDay = split_end[0] + " 23:59:59";

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHSearch_HisData '" + startDay + "','" + endDay + "',"+dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHSearch_10HisData");
                if (ds != null)
                {
                    try
                    {
                        int standardNum = 6 * 24;
                        int int_flag = ds.Tables[0].Rows.Count / standardNum;
                        int point_flag = ds.Tables[0].Rows.Count % standardNum;
                        for (int di = 0; di <= int_flag; di++)
                        {
                            double maxrate = 0.0;
                            double averagerate = 0.0;
                            int level = 0;
                            string startTime = "";
                            AlarmLevelTrend compAnaly = new AlarmLevelTrend();
                            int j = 0;
                            for (j = di * standardNum; j < (di + 1) * standardNum && j < ds.Tables[0].Rows.Count; j++)
                            {
                                if (j == di * standardNum)
                                {
                                    string[] temp = ds.Tables[0].Rows[j]["ZHStartTime"].ToString().Split(' ');
                                    startTime = temp[0];
                                }
                                averagerate = averagerate + (int)ds.Tables[0].Rows[j]["ZHErrorCount"];
                                if (maxrate < (int)ds.Tables[0].Rows[j]["ZHErrorCount"])
                                {
                                    maxrate = (int)ds.Tables[0].Rows[j]["ZHErrorCount"];
                                }
                            }
                            if (j - di * standardNum == 0)
                            {
                                continue;
                            }
                            averagerate = averagerate / (j - di * standardNum);
                            string level_str = alarmLevelAnaysis(averagerate, maxrate);
                            if (level_str == "超负荷的")
                            {
                                level = 5;
                            }
                            if (level_str == "可预测的")
                            {
                                level = 1;
                            }
                            if (level_str == "鲁棒的")
                            {
                                level = 2;
                            }
                            if (level_str == "稳定的")
                            {
                                level = 3;
                            }
                            if (level_str == "反应性的")
                            {
                                level = 4;
                            }

                            compAnaly.area = "";
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}

                            compAnaly.averagerate = averagerate;
                            compAnaly.maxrate = maxrate;
                            compAnaly.level = level;
                            compAnaly.startTime = startTime;
                            list.Add(compAnaly);
                        }
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }

            dao.closeConn();
            return list;
        }

        /// <summary>
        /// 报警等级划分
        /// </summary>
        /// <param name="averageRate"></param>
        /// <param name="maxRate"></param>
        /// <returns></returns>
        public string alarmLevelAnaysis(double averageRate, double maxRate)
        {
            string level = "超负荷的";
            if(maxRate <= 10 && averageRate <= 1)
            {
                level = "可预测的";
            }
            if ((maxRate > 10 && maxRate <= 100 && averageRate <= 10) || (maxRate <= 10 && averageRate > 1 && averageRate <= 10))
            {
                level = "鲁棒的";
            }
            if (maxRate > 100 && maxRate <= 1000 && averageRate <= 10)
            {
                level = "稳定的";
            }
            if ((maxRate > 1000 && maxRate <= 10000 && averageRate <= 100) || (maxRate <= 1000 && averageRate > 10 && averageRate <= 100))
            {
                level = "反应性的";
            }
            return level;
        }
        /// <summary>
        /// 报警次数Top20(最新)
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData alarmAnaysisTop20(String starttime, String endtime, String DBName,String dbSource)
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_Top20 '" + starttime + "','" + endtime + "'," + dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_Top20");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //遍历一个表多行多列
                        for (int di = 0; di < ds.Tables[0].Rows.Count; di++)
                        {
                            AlarmTop20 compAnaly = new AlarmTop20();
                            compAnaly.tagname = ds.Tables[0].Rows[di]["TOP10_History_Items"].ToString();
                            compAnaly.count = (int)ds.Tables[0].Rows[di]["TOP10_History_Count"];
                            compAnaly.percent = double.Parse(ds.Tables[0].Rows[di]["TOP10_History_Prevent"].ToString());
                            compAnaly.description = ds.Tables[0].Rows[di]["TOP10_History_Describe"].ToString();
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            compAnaly.area = ds.Tables[0].Rows[di]["TOP10_History_Process"].ToString();
                            list.Add(compAnaly);
                        }
                        grid.rows = list;
                        grid.total = list.Count;

                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }
                }

            }
            dao.closeConn();
            return grid;
        }
        /// <summary>
        /// 重复报警查询
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData alarmAnaysisChattering(String starttime, String endtime, String DBName,String dbSource)
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_ChatterAlarm '" + starttime + "','" + endtime + "',"+dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_ChatterAlarm");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //遍历一个表多行多列
                        for (int di = 0; di < ds.Tables[0].Rows.Count; di++)
                        {
                            AlarmChattering compAnaly = new AlarmChattering();
                            compAnaly.tagname = ds.Tables[0].Rows[di]["ChatterAlarm_Items"].ToString();
                            compAnaly.chatteringCount = (int)ds.Tables[0].Rows[di]["ChatterAlarm_ChatterCount"];
                            compAnaly.totalCount = (int)ds.Tables[0].Rows[di]["ChatterAlarm_Count"];
                            compAnaly.percent = double.Parse(ds.Tables[0].Rows[di]["ChatterAlarm_Prevent"].ToString());
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            compAnaly.area = ds.Tables[0].Rows[di]["ChatterAlarm_Process"].ToString();
                            compAnaly.description = ds.Tables[0].Rows[di]["ChatterAlarm_Describe"].ToString();
                            list.Add(compAnaly);
                        }
                        grid.rows = list;
                        grid.total = list.Count;
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }
            dao.closeConn();
            return grid;
        }


        /// <summary>
        /// 持续报警查询
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData alarmAnaysisStanding(String starttime, String endtime, String DBName,String dbSource)
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_StandAlarm '" + starttime + "','" + endtime + "'," + dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_StandAlarm");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //遍历一个表多行多列
                        for (int di = 0; di < ds.Tables[0].Rows.Count; di++)
                        {
                            AlarmStanding compAnaly = new AlarmStanding();
                            compAnaly.tagname = ds.Tables[0].Rows[di]["StandAlarm_Item"].ToString();
                            compAnaly.description = "";
                            compAnaly.alarmInterval = double.Parse(ds.Tables[0].Rows[di]["StandAlarm_StandTime"].ToString());
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            compAnaly.area = ds.Tables[0].Rows[di]["StandAlarm_Process"].ToString();
                            compAnaly.startTime = ds.Tables[0].Rows[di]["StandAlarm_StartTime"].ToString();
                            compAnaly.endTime = ds.Tables[0].Rows[di]["StandAlarm_EndTime"].ToString();
                            compAnaly.description = ds.Tables[0].Rows[di]["StandAlarm_Describe"].ToString();
                            list.Add(compAnaly);
                        }
                        grid.rows = list;
                        grid.total = list.Count;
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }
            dao.closeConn();
            return grid;
        }

        /// <summary>
        /// 报警分布查询，按时间，空间
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList alarmAnaysisDistributionByTime(String starttime, String endtime, String DBName,String dbSource)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHSearch_HisData '" + starttime + "','" + endtime + "',"+dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //遍历一个表多行多列
                        for (int di = 0; di < ds.Tables[0].Rows.Count; di++)
                        {
                            AlarmDistributionByTime compAnaly = new AlarmDistributionByTime();
                            compAnaly.startTime = ds.Tables[0].Rows[di]["ZHStartTime"].ToString();
                            compAnaly.endTime = ds.Tables[0].Rows[di]["ZHEndTime"].ToString();
                            compAnaly.alarmCount = (int)ds.Tables[0].Rows[di]["ZHErrorCount"];
                            compAnaly.tagCount = (int)ds.Tables[0].Rows[di]["ZHCount"];
                            compAnaly.area = "";
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            list.Add(compAnaly);
                        }
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }
            dao.closeConn();
            return list;
        }
        /// <summary>
        /// 报警分布查询，按空间
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList alarmAnaysisDistributionByProcess(String starttime, String endtime, String DBName,String dbSource)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_GradeDistribution '" + starttime + "','" + endtime + "',"+dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_GradeDistribution");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //遍历一个表多行多列
                        for (int di = 0; di < ds.Tables[0].Rows.Count; di++)
                        {
                            AlarmDistributionByTime compAnaly = new AlarmDistributionByTime();
                            compAnaly.alarmCount = (int)ds.Tables[0].Rows[di]["AlarmCount"];
                            compAnaly.tagCount = (int)ds.Tables[0].Rows[di]["ItemCount"];
                            compAnaly.area = ds.Tables[0].Rows[di]["PlantName"].ToString();
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                            //{
                            //    compAnaly.area = "常减压";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                            //{
                            //    compAnaly.area = "催化裂化";
                            //}
                            //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                            //{
                            //    compAnaly.area = "延迟焦化";
                            //}
                            list.Add(compAnaly);
                        }
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }
            dao.closeConn();
            return list;
        }

        /// <summary>
        /// 报警分布查询，按优先级
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList alarmAnaysisDistributionByPriority(String starttime, String endtime, String DBName,String dbSource)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procAlarmZHHisSearch_Priority '" + starttime + "','" + endtime + "',"+dbSource;
                DataSet ds = dao.executeProcDS(strSQL, "procAlarmZHHisSearch_Priority");
                if (ds != null)
                {
                    try
                    {
                        AlarmPriority compAnaly = new AlarmPriority();
                        compAnaly.criticalPercent = 0.0;
                        compAnaly.highPercent = (double)ds.Tables[0].Rows[0]["AlarmClass_Prevent"];
                        compAnaly.mediumPercent = (double)ds.Tables[0].Rows[1]["AlarmClass_Prevent"];
                        compAnaly.lowPercent = 0.0;
                        if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                        {
                            compAnaly.area = "常减压";
                        }
                        if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                        {
                            compAnaly.area = "催化裂化";
                        }
                        if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                        {
                            compAnaly.area = "延迟焦化";
                        }
                        list.Add(compAnaly);
                    }
                    catch (Exception e)
                    {
                        string str = e.Message;
                    }

                }

            }
            dao.closeConn();
            return list;
        }
        /// <summary>
        /// 综合分析
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public CompAnaly comprehensiveAnaysis(String starttime, String endtime, Plant plant)
        {
            IDao dao = new Dao(plant,true);
            CompAnaly compAnaly = new CompAnaly();

            IList list = new ArrayList();

            if (null != starttime && null != endtime)
            {
                SqlParameter[] parames = new SqlParameter[5];
                parames[0] = new SqlParameter("@SearchStartTime", starttime);
                parames[1] = new SqlParameter("@SearchEndTime", endtime);
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[3] = new SqlParameter("@MaxPercent", "0");
                parames[4] = new SqlParameter("@PerturbationRate", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;
                parames[3].Direction = ParameterDirection.Output;
                parames[4].Direction = ParameterDirection.Output;

                SqlDataReader dr = dao.executeProc("procAlarmZHSearch_10HisData", parames);

                if (null != dr)
                {
                    
                    /* 线图 */
                    XMLDoc = new XmlDocument();
                    String lineFilePath = CommonStr.physicalPath + @"resource\chartXml\alarmCompChartLine.xml";
                    XMLDoc.Load(lineFilePath);
                    seriesNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data");
                    seriesNode.RemoveAll();
                    seriesNode.InnerText = "";

                    while (dr.Read())
                    {
                        String itemName = BeanTools.DataTimeToString(dr["zhstarttime"]);
                        string errorCount = BeanTools.ObjectToString(dr["ZHPercent"]);
                        CreateAlarmChart(itemName, errorCount);
                    }


                    compAnaly.chartStr = XMLDoc.InnerXml;

                    if (dr.NextResult())
                    {
                        
                       

                        /* 饼图 */
                        XmlDocument pieXMLDoc = new XmlDocument();
                        String pieFilePath = CommonStr.physicalPath + @"resource\chartXml\alarmCompChartPie.xml";
                        pieXMLDoc.Load(pieFilePath);
                        pieSeriesNode = pieXMLDoc.SelectSingleNode("/anychart/charts/chart/data");
                        pieSeriesNode.RemoveAll();
                        pieSeriesNode.InnerText = "";

                        while (dr.Read())
                        {
                            String itemName = BeanTools.ObjectToString(dr["tagName"]);
                            string errorCount = BeanTools.ObjectToString(dr["AlarmCount"]);
                            try
                            {
                                if (0 != Convert.ToDouble(errorCount))
                                {
                                    CreateAlarmPie(pieXMLDoc, itemName, errorCount);
                                }
                            }
                            catch (Exception exp)   //防止出现转换错误
                            {
                            }
                        }


                        compAnaly.pieStr = pieXMLDoc.InnerXml;
                    }
                    if (dr.NextResult())    //峰值
                    {
                        if (dr.Read())
                        {
                            float @MaxPercent = BeanTools.ObjectToFloat(BeanTools.ObjectToString(dr[0]));  //峰值
                            compAnaly.maxpercent = @MaxPercent;
                        }
                    }
                    if (dr.NextResult())    //平稳率
                    {
                        if (dr.Read())
                        {
                            float @PerturbationRate = BeanTools.ObjectToFloat(BeanTools.ObjectToString(dr[0]));    //平稳率
                            compAnaly.perturbationRate = @PerturbationRate;
                        }
                    }
                }
            }

            dao.closeConn();

            return compAnaly;
        }

        /// <summary>
        /// 综合分析
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData comprehensiveAnaysisList(String starttime, String endtime, Plant plant, int page, int rows)
        {
            IDao dao = new Dao(plant,true);
            EasyUIData grid = new EasyUIData();

            IList list = new ArrayList();

            if (null != starttime && null != endtime)
            {
                SqlParameter[] parames = new SqlParameter[5];
                parames[0] = new SqlParameter("@SearchStartTime", starttime);
                parames[1] = new SqlParameter("@SearchEndTime", endtime);
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[3] = new SqlParameter("@MaxPercent", "0");
                parames[4] = new SqlParameter("@PerturbationRate", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;
                parames[3].Direction = ParameterDirection.Output;
                parames[4].Direction = ParameterDirection.Output;

                SqlDataReader dr = dao.executeProc("procAlarmZHSearch_10HisData", parames);

                if (null != dr)
                {
                    int i = 1;
                    int pageStart = (page-1)*rows;
                    int pageEnd = page*rows;
                    while (dr.Read())
                    {
                        if (i > pageStart && i <= pageEnd)  //当前页中数据
                        {
                            ComprehensiveAnalysis bo = new ComprehensiveAnalysis();

                            bo.zhStartTime = BeanTools.DataTimeToString(dr["zhstarttime"]);
                            bo.zhEndtime = BeanTools.DataTimeToString(dr["zhendtime"]);
                            bo.zhAlarmNumbers = BeanTools.ObjectToString(dr["zherrorcount"]);
                            bo.zhPercent = Math.Round(BeanTools.ObjectToDouble(dr["zhpercent"]), 7);
                            bo.zhAlarmItems = BeanTools.ObjectToString(dr["zhalarmitems"]);

                            list.Add(bo);
                        }
                        i++;
                    }
                    grid.total = i-1;
                }
            }

            grid.rows = list;
            
            dao.closeConn();

            return grid;
        }

        #region 综合分析(废弃)
        /// <summary>
        /// 综合分析（废弃）
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        public EasyUIData comprehensiveAnaysis1(DateTime starttime, DateTime endtime, String DBName)
        {
            IDao dao = new Dao(DBName);
            EasyUIData grid = new EasyUIData();
            initSkinDataGridViewZHColumn();
            m_ZHGraphData.GraphName = "10Min平均报警率";
            m_ZHGraphData.Yalname = "";
            m_ZHGraphData.Xalname = "时间";
            m_ZHGraphData.pYName.Add("报警率");

            String sql = "select * from PSOG_AlarmManager order by AlarmManager_Name ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                initALARMSQLTabColumn();
                
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ALARMSQLTab.Rows.Add(dr["ID"].ToString(),
                             dr["AlarmManager_Name"].ToString(),
                             dr["AlarmManager_TechnicsHigh"].ToString(),
                             dr["AlarmManager_TechnicsLow"].ToString(),
                             dr["AlarmManager_ConstraintHigh"].ToString(),
                             dr["AlarmManager_ConstraintLow"].ToString(), 0
                             );
                }
            }

            int zhcount = 0;
            while (starttime.Ticks < endtime.Ticks)
            {
                SearchTime.Add(starttime);
                zhcount++;
                m_ZHGraphData.pXName.Add(zhcount.ToString());
                starttime = starttime.AddMinutes(10);
            }
            SearchTime.Add(starttime);

            m_ZHGraphData.pData = new float[m_ZHGraphData.pXName.Count, m_ZHGraphData.pYName.Count];

            int rowNum = 0;
            if (SearchTime.Count > 1)
            {
                rowNum = SearchTime.Count - 1;
                skinDataGridViewZH.Rows.Add(rowNum);
                grid.total = rowNum;
            }

            grid.rows = SearchZH(rowNum, dao);
            return grid;
        }
        
        /// <summary>
        /// 初始化表中列
        /// </summary>
        private void initALARMSQLTabColumn()
        {
            ALARMSQLTab.Columns.Add("ID");
            ALARMSQLTab.Columns.Add("AlarmManager_Name");
            ALARMSQLTab.Columns.Add("AlarmManager_TechnicsHigh");
            ALARMSQLTab.Columns.Add("AlarmManager_TechnicsLow");
            ALARMSQLTab.Columns.Add("AlarmManager_constraintHigh");
            ALARMSQLTab.Columns.Add("AlarmManager_ConstraintLow");
            ALARMSQLTab.Columns.Add("showOrder");
        }

        private void initSkinDataGridViewZHColumn()
        {
            skinDataGridViewZH.Columns.Add("ZHStartTime");
            skinDataGridViewZH.Columns.Add("ZHEndTime");
            skinDataGridViewZH.Columns.Add("ZHAlarmNumbers");
            skinDataGridViewZH.Columns.Add("ZHPercent");
            skinDataGridViewZH.Columns.Add("ZHAlarmItems");
            skinDataGridViewZH.Columns.Add("");
        }

        public IList SearchZH(int rowCount, IDao dao)
        {
            IList list = new ArrayList();
            int prcount = 0;
            for (int si = 0; si < rowCount; si++)  //列表值
            {
                ComprehensiveAnalysis bo = new ComprehensiveAnalysis();
                skinDataGridViewZH.Rows[si]["ZHStartTime"] = SearchTime[si].ToString();
                skinDataGridViewZH.Rows[si]["ZHEndTime"] = SearchTime[si + 1].ToString();
                skinDataGridViewZH.Rows[si]["ZHAlarmNumbers"] = "0";
                skinDataGridViewZH.Rows[si]["ZHPercent"] = "0";
                skinDataGridViewZH.Rows[si]["ZHAlarmItems"] = "";

                bo.zhStartTime = SearchTime[si].ToString();
                bo.zhEndtime = SearchTime[si + 1].ToString();
                bo.zhAlarmNumbers = "0";
                bo.zhPercent = 0;
                bo.zhAlarmItems = "";

                list.Add(bo);
            }
            string strcond = " (RealTime_Time>='" + SearchTime[0].ToString() + "' AND RealTime_Time<'" + SearchTime[SearchTime.Count - 1].ToString() + "') ";
            int acount = 0;
            int BarZHIndex = 0;
            string alarmitems = "";
            for (int ai = 0; ai < ALARMSQLTab.Rows.Count; ai++)
            {
                bool flag = false;
                BarZHIndex = ai;
                try
                {
                    int i = 0;
                    DateTime dttemp;
                    string strname = ALARMSQLTab.Rows[ai]["AlarmManager_Name"].ToString();
                    strname = strname.Replace(".", "_");
                    strname = strname.Replace("-", "_");

                     String sql = "select * from PSOG_HisData_" + strname + strcond + " order by RealTime_Time ASC ";
                    DataSet ds = dao.executeQuery(sql);
                    if (BeanTools.DataSetIsNotNull(ds))
                    {
                        
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            double dtemp = (double)dr["RealTime_Value"];
                            dttemp = (DateTime)dr["RealTime_Time"];
                            if (dttemp.Ticks > SearchTime[i + 1].Ticks)
                            {
                                acount = Int32.Parse(skinDataGridViewZH.Rows[i]["ZHAlarmNumbers"].ToString());
                                alarmitems = skinDataGridViewZH.Rows[i]["ZHAlarmItems"].ToString();
                                if (flag)
                                {
                                    acount++;
                                    if (alarmitems != "")
                                        alarmitems += "、";
                                    alarmitems += ALARMSQLTab.Rows[ai]["AlarmManager_Name"].ToString();
                                    ALARMSQLTab.Rows[ai]["AlarmNumbers"] = (int)ALARMSQLTab.Rows[ai]["AlarmNumbers"] + 1;
                                }
                                skinDataGridViewZH.Rows[i]["ZHAlarmNumbers"] = acount.ToString();
                                skinDataGridViewZH.Rows[i]["ZHPercent"] = Math.Round((double)acount / ALARMSQLTab.Rows.Count, 2).ToString();
                                skinDataGridViewZH.Rows[i]["ZHAlarmItems"] = alarmitems;
                                m_ZHGraphData.pData[i, 0] = (float)Math.Round((double)acount / ALARMSQLTab.Rows.Count, 2);
                                flag = false;
                                i++;
                            }
                            if (dtemp > double.Parse(ALARMSQLTab.Rows[ai]["AlarmManager_TechnicsHigh"].ToString()) || (dtemp < double.Parse(ALARMSQLTab.Rows[ai]["AlarmManager_TechnicsLow"].ToString())))
                            {
                                flag = true;
                            }
                        }
                    }

                    if (i < SearchTime.Count)
                    {
                        acount = Int32.Parse(skinDataGridViewZH.Rows[i]["ZHAlarmNumbers"].ToString());
                        alarmitems = skinDataGridViewZH.Rows[i]["ZHAlarmItems"].ToString();
                        if (flag)
                        {
                            acount++;
                            if (alarmitems != "")
                                alarmitems += "、";
                            alarmitems += ALARMSQLTab.Rows[ai]["AlarmManager_Name"].ToString();
                            ALARMSQLTab.Rows[ai]["AlarmNumbers"] = (int)ALARMSQLTab.Rows[ai]["AlarmNumbers"] + 1;
                        }
                        skinDataGridViewZH.Rows[i]["ZHAlarmNumbers"] = acount.ToString();
                        skinDataGridViewZH.Rows[i]["ZHPercent"] = Math.Round((double)acount / ALARMSQLTab.Rows.Count, 2).ToString();
                        skinDataGridViewZH.Rows[i]["ZHAlarmItems"] = alarmitems;
                        m_ZHGraphData.pData[i, 0] = (float)Math.Round((double)acount / ALARMSQLTab.Rows.Count, 2);
                        flag = false;
                        i++;
                    }
                }
                catch(Exception exp)
                {
                    
                }
            }

            for (int si = 0; si < skinDataGridViewZH.Rows.Count; si++)
            {
                double datemp = double.Parse(skinDataGridViewZH.Rows[si]["ZHPercent"].ToString());
                m_ZHGraphData.pData[si, 0] = (float)Math.Round(datemp, 2);
                if (Maxpercent < datemp)
                {
                    Maxpercent = datemp;
                }
                if (acount >= Int32.Parse(skinDataGridViewZH.Rows[si]["ZHAlarmNumbers"].ToString()))
                {
                    prcount++;
                }
            }
            Prpercent = (double)prcount / (SearchTime.Count - 1);
            ZHFlag = true;

            return list;
        }
        #endregion

        #region 报警次数统计
        /// <summary>
        /// 报警次数统计
        /// </summary>
        public EasyUIData hisStatis(String starttime, String endtime, Plant plant)
        {
            IDao dao = new Dao(plant,true);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            if (null != starttime && null != endtime)
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("select h.alarmmanager_history_items,count(1) statisNo,a.alarmmanager_describe ");
                sql.Append("from PSOG_AlarmManager_History h,psog_alarmManager a ");
                sql.Append("where a.alarmmanager_name = h.alarmmanager_history_items ");
                if (!string.IsNullOrEmpty(endtime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime < '{0}' ", endtime);
                }
                if (!string.IsNullOrEmpty(starttime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime > '{0}' ", starttime);
                }
                sql.Append("group by h.alarmmanager_history_items,a.id,a.alarmmanager_describe ");
                sql.Append("order by count(1) desc ");

                DataSet ds = dao.executeQuery(sql.ToString());

                if (BeanTools.DataSetIsNotNull(ds))
                {
                    //grid.total = ds.Tables[0].Rows[0]["rowno"];
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        AlarmHisStatis alarm = new AlarmHisStatis();
                        alarm.itemNo = BeanTools.ObjectToString(dr["alarmmanager_history_items"]);
                        alarm.number = BeanTools.ObjectToInt(dr["statisNo"]);
                        alarm.describe = BeanTools.ObjectToString(dr["alarmmanager_describe"]);
                        alarm.flagId = alarm.describe;
                        list.Add(alarm);
                    }
                }
            }
            grid.rows = list;
            return grid;
        }

        #endregion

        /// <summary>
        /// 报警历史记录位号查询
        /// </summary>

        public List<string> qryhisnum(String DBName)
        {
            IDao dao = new Dao(DBName);
            List<string> list = new List<string>();
            StringBuilder sql = new StringBuilder();
            sql.Append("select distinct AlarmManager_History_Items from PSOG_AlarmManager_History order by AlarmManager_History_Items asc ");
            DataSet ds = dao.executeQuery(sql.ToString());

            if (BeanTools.DataSetIsNotNull(ds))
            {
                //grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["rowno"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    list.Add(BeanTools.ObjectToString(dr["AlarmManager_History_Items"]));
                }
            }
            return list;
        }


        #region 报警历史记录查询
        /// <summary>
        /// 报警历史记录查询
        /// </summary>
        public EasyUIData qryhis(String starttime, String endtime, int page, int rows, String DBName,String dbSource)
        {
            IDao dao = new Dao(DBName);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            if (null != starttime && null != endtime)
            {
                String tableName = "PSOG_AlarmManager_History";
                if ("1".Equals(dbSource)) {
                    tableName = "PSOG_AlarmManager_History_FromDCSLog";
                }

                StringBuilder sql = new StringBuilder();
                sql.Append("select *,count(1) over() rowno ");
                sql.AppendFormat("from {0} h ",tableName);
                sql.Append(" where ID is not null ");
                if (!string.IsNullOrEmpty(endtime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime < '{0}' ", endtime);
                }
                if (!string.IsNullOrEmpty(starttime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime > '{0}' ", starttime);
                }
                sql.Append("order by h.id asc ");

                DataSet ds = dao.executeQuery(sql.ToString(), page, rows);

                if (BeanTools.DataSetIsNotNull(ds))
                {
                    grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["rowno"]);
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        AlarmHis alarm = new AlarmHis();
                        alarm.id = BeanTools.ObjectToString(dr["id"]);
                        alarm.items = BeanTools.ObjectToString(dr["AlarmManager_History_Items"]);
                        alarm.value = BeanTools.ObjectToString(dr["AlarmManager_History_Value"]);
                        alarm.describe = BeanTools.ObjectToString(dr["AlarmManager_History_Describe"]);
                        alarm.state = BeanTools.ObjectToString(dr["AlarmManager_History_State"]);
                        alarm.historyId = BeanTools.ObjectToString(dr["AlarmManager_History_ID"]);
                        alarm.cause = BeanTools.ObjectToString(dr["AlarmManager_History_Cause"]);
                        alarm.measure = BeanTools.ObjectToString(dr["AlarmManager_History_Measure"]);
                        alarm.alarmClass = BeanTools.ObjectToString(dr["AlarmManager_History_AlarmClass"]);
                        alarm.type = BeanTools.ObjectToString(dr["AlarmManager_History_Type"]);
                        alarm.color = BeanTools.ObjectToString(dr["AlarmManager_History_Color"]);
                        alarm.isClear = BeanTools.ObjectToString(dr["AlarmManager_History_IsClear"]);
                        alarm.isSound = BeanTools.ObjectToString(dr["AlarmManager_History_IsSound"]);
                        alarm.isTwinkle = BeanTools.ObjectToString(dr["AlarmManager_History_IsTwinkle"]);
                        alarm.sound = BeanTools.ObjectToString(dr["AlarmManager_History_Sound"]);
                        alarm.isCanel = BeanTools.ObjectToString(dr["AlarmManager_History_IsCanel"]);
                        alarm.startTime = BeanTools.DataTimeToString(dr["AlarmManager_History_StartTime"]);
                        alarm.endTime = BeanTools.DataTimeToString(dr["AlarmManager_History_EndTime"]);
                        alarm.duration = (string.IsNullOrEmpty(alarm.endTime) ? DateTime.Now.Ticks : DateTime.Parse(alarm.endTime).Ticks - DateTime.Parse(alarm.startTime).Ticks) / 555000000;

                        list.Add(alarm);
                    }
                }
            }
            grid.rows = list;
            return grid;
        }

        public EasyUIData qryhis2(String starttime, String endtime, int page, int rows, String DBName,string wnum,String dbSource)
        {
            IDao dao = new Dao(DBName);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();

            if (null != starttime && null != endtime)
            {
                String tableName = "PSOG_AlarmManager_History";
                if ("1".Equals(dbSource))
                {
                    tableName = "PSOG_AlarmManager_History_FromDCSLog";
                }

                StringBuilder sql = new StringBuilder();
                sql.Append("select *,count(1) over() rowno ");
                sql.AppendFormat(" from {0} h ",tableName);
                sql.Append("where ID is not null  ");
                sql.AppendFormat(" and h.AlarmManager_History_Items = '{0}'", wnum);
                if (!string.IsNullOrEmpty(endtime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime < '{0}' ", endtime);
                }
                if (!string.IsNullOrEmpty(starttime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime > '{0}' ", starttime);
                }
                sql.Append("order by h.id asc ");

                DataSet ds = dao.executeQuery(sql.ToString(), page, rows);

                if (BeanTools.DataSetIsNotNull(ds))
                {
                    grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["rowno"]);
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        AlarmHis alarm = new AlarmHis();
                        alarm.id = BeanTools.ObjectToString(dr["id"]);
                        alarm.items = BeanTools.ObjectToString(dr["AlarmManager_History_Items"]);
                        alarm.value = BeanTools.ObjectToString(dr["AlarmManager_History_Value"]);
                        alarm.describe = BeanTools.ObjectToString(dr["AlarmManager_History_Describe"]);
                        alarm.state = BeanTools.ObjectToString(dr["AlarmManager_History_State"]);
                        alarm.historyId = BeanTools.ObjectToString(dr["AlarmManager_History_ID"]);
                        alarm.cause = BeanTools.ObjectToString(dr["AlarmManager_History_Cause"]);
                        alarm.measure = BeanTools.ObjectToString(dr["AlarmManager_History_Measure"]);
                        alarm.alarmClass = BeanTools.ObjectToString(dr["AlarmManager_History_AlarmClass"]);
                        alarm.type = BeanTools.ObjectToString(dr["AlarmManager_History_Type"]);
                        alarm.color = BeanTools.ObjectToString(dr["AlarmManager_History_Color"]);
                        alarm.isClear = BeanTools.ObjectToString(dr["AlarmManager_History_IsClear"]);
                        alarm.isSound = BeanTools.ObjectToString(dr["AlarmManager_History_IsSound"]);
                        alarm.isTwinkle = BeanTools.ObjectToString(dr["AlarmManager_History_IsTwinkle"]);
                        alarm.sound = BeanTools.ObjectToString(dr["AlarmManager_History_Sound"]);
                        alarm.isCanel = BeanTools.ObjectToString(dr["AlarmManager_History_IsCanel"]);
                        alarm.startTime = BeanTools.DataTimeToString(dr["AlarmManager_History_StartTime"]);
                        alarm.endTime = BeanTools.DataTimeToString(dr["AlarmManager_History_EndTime"]);
                        alarm.duration = (string.IsNullOrEmpty(alarm.endTime) ? DateTime.Now.Ticks : DateTime.Parse(alarm.endTime).Ticks - DateTime.Parse(alarm.startTime).Ticks) / 555000000;

                        list.Add(alarm);
                    }
                }
            }
            grid.rows = list;
            return grid;
        }

        public EasyUIData qryhisCopy(String starttime, String endtime, int page, int rows, String DBName)
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            LevelAssess level = new LevelAssess();
            level.area = "常压塔";
            level.averagerate = 3;
            level.disturbrate = 0.5;
            level.maxrate = 15;
            level.level = "可预测的";
            list.Add(level);
            LevelAssess level1 = new LevelAssess();
            level1.area = "常压炉";
            level1.averagerate = 106;
            level1.disturbrate = 0.5;
            level1.maxrate = 500;
            level1.level = "可预测的";
            list.Add(level1);
            LevelAssess level2 = new LevelAssess();
            level2.area = "减压塔";
            level2.averagerate = 13;
            level2.disturbrate = 0.5;
            level2.maxrate = 50;
            level2.level = "鲁棒的";
            list.Add(level2);
            grid.rows = list;
            return grid;
        }

        #endregion

        #region 报警分析历史曲线
        public String alarmAnychartLine(Plant plant, String startTime, String endTime, String tableName) //显示报警限
        {
            IDao dao = new Dao(plant,true);

            LoadXML();
            anychartName = tableName;
            tableName = tableName.Replace(".", "_");

            StringBuilder sql = new StringBuilder();
            sql.Append("select count(1) from sys.objects where name = 'PSOG_HisData_").Append(tableName).Append("'");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                seriesNode.RemoveAll(); //清空历史节点
                seriesNode.InnerText = "";
                XmlElement Series = XMLDoc.CreateElement("series");
                Series.SetAttribute("name", anychartName+"实时值");
                Series.SetAttribute("color", "green");
                seriesNode.AppendChild(Series);
                XmlElement Series4 = XMLDoc.CreateElement("series");
                Series4.SetAttribute("name", "高高限");
                Series4.SetAttribute("color", "RGB(255,0,0)");
                seriesNode.AppendChild(Series4);
                XmlElement Series2 = XMLDoc.CreateElement("series");
                Series2.SetAttribute("name", "高限");
                Series2.SetAttribute("color", "RGB(255,0,255)");
                seriesNode.AppendChild(Series2);
                XmlElement Series3 = XMLDoc.CreateElement("series");
                Series3.SetAttribute("name", "低限");
                Series3.SetAttribute("color", "RGB(0,255,255)");
                seriesNode.AppendChild(Series3);
                XmlElement Series5 = XMLDoc.CreateElement("series");
                Series5.SetAttribute("name", "低低限");
                Series5.SetAttribute("color", "RGB(0,0,255)");
                seriesNode.AppendChild(Series5);

                if (1 <= BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]))    //存在表记录
                {
                    //查找上下限
                    String sql_str = "select * from dbo.PSOG_Instrumentation where Instrumentation_Code='" + anychartName + "'";
                    ds = dao.executeQuery(sql_str.ToString());

                    sql.Length = 0;
                    SqlParameter[] sqlParas = new SqlParameter[3];
                    sqlParas[0] = new SqlParameter("@startTime", startTime);
                    sqlParas[1] = new SqlParameter("@endTime", endTime);
                    sqlParas[2] = new SqlParameter("@tableName", tableName);
                    sqlParas[0].Direction = ParameterDirection.Input;
                    sqlParas[1].Direction = ParameterDirection.Input;
                    sqlParas[2].Direction = ParameterDirection.Input;

                    SqlDataReader dr = dao.executeProc("procHisAlarmChart", sqlParas);

                    if (BeanTools.DataSetIsNotNull(ds))
                    {
                        string HHLimit = ds.Tables[0].Rows[0]["Instrumentation_HHigh"].ToString();
                        string HILimit = ds.Tables[0].Rows[0]["Instrumentation_High"].ToString();
                        string LOLimit = ds.Tables[0].Rows[0]["Instrumentation_Low"].ToString();
                        string LLLimit = ds.Tables[0].Rows[0]["Instrumentation_LLow"].ToString();
                        if (null != dr)
                        {
                            while (dr.Read())
                            {
                                CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), BeanTools.ObjectToString(dr["RealTime_Value"]).Trim(), "Green", "1");
                                if (HHLimit != "1000000")
                                {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), HHLimit.Trim(), "RGB(255,0,0)", "2");
                                }
                                if (HILimit != "1000000")
                                {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), HILimit.Trim(), "RGB(255,0,255)", "3");
                                }
                                if (LOLimit != "-1000000")
                                {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), LOLimit.Trim(), "RGB(0,255,255)", "4");
                                }
                                if (LLLimit != "-1000000")
                                {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), LLLimit.Trim(), "RGB(0,0,255)", "5");
                                }
                            }
                        }
                    }
                    else
                    {
                        if (null != dr)
                        {
                            while (dr.Read())
                            {
                                CreateXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), BeanTools.ObjectToString(dr["RealTime_Value"]).Trim());
                            }
                        }
                    }
                    
                    dao.closeConn();
                }
                else//创建空节点
                {
                    XmlElement Point = XMLDoc.CreateElement("point");
                    Point.SetAttribute("name", "无记录");
                    Point.SetAttribute("y", "0");
                    Series.AppendChild(Point);
                }
            }
            return XMLDoc.InnerXml;
            
        }

        public String alarmAnychartLine2(Plant plant, String startTime, String endTime, String tableName) //不显示报警限
        {
            IDao dao = new Dao(plant, true);

            LoadXML();
            anychartName = tableName;
            tableName = tableName.Replace(".", "_");

            //获取位号的描述
            string bitDesc = getBitDesc(plant, anychartName);

            StringBuilder sql = new StringBuilder();
            sql.Append("select count(1) from sys.objects where name = 'PSOG_HisData_").Append(tableName).Append("'");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                seriesNode.RemoveAll(); //清空历史节点
                seriesNode.InnerText = "";
                XmlElement Series = XMLDoc.CreateElement("series");
                Series.SetAttribute("name", anychartName + "(" + bitDesc+")");
                seriesNode.AppendChild(Series);

                if (1 <= BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]))    //存在表记录
                {
                    sql.Length = 0;
                    SqlParameter[] sqlParas = new SqlParameter[3];
                    sqlParas[0] = new SqlParameter("@startTime", startTime);
                    sqlParas[1] = new SqlParameter("@endTime", endTime);
                    sqlParas[2] = new SqlParameter("@tableName", tableName);
                    sqlParas[0].Direction = ParameterDirection.Input;
                    sqlParas[1].Direction = ParameterDirection.Input;
                    sqlParas[2].Direction = ParameterDirection.Input;

                    SqlDataReader dr = dao.executeProc("procHisAlarmChart", sqlParas);
                    if (null != dr)
                    {
                        while (dr.Read())
                        {
                            CreateXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), BeanTools.ObjectToString(dr["RealTime_Value"]).Trim());
                        }
                    }
                    dao.closeConn();
                }
                else//创建空节点
                {
                    XmlElement Point = XMLDoc.CreateElement("point");
                    Point.SetAttribute("name", "无记录");
                    Point.SetAttribute("y", "0");
                    Series.AppendChild(Point);
                }
            }
            return XMLDoc.InnerXml;

        }

        public String alarmAnychartLine3(Plant plant, String startTime, String endTime, String tableName,String upLine,String downLine) //显示报警限
        {
            IDao dao = new Dao(plant, true);

            LoadXML();
            anychartName = tableName;
            tableName = tableName.Replace(".", "_");

            //获取位号的描述
            string bitDesc = getBitDesc(plant, anychartName);

            StringBuilder sql = new StringBuilder();
            sql.Append("select count(1) from sys.objects where name = 'PSOG_HisData_").Append(tableName).Append("'");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                seriesNode.RemoveAll(); //清空历史节点
                seriesNode.InnerText = "";
                XmlElement Series = XMLDoc.CreateElement("series");
                Series.SetAttribute("name", anychartName + "(" + bitDesc + ")");
                Series.SetAttribute("color", "RGB(0,0,255)");
                seriesNode.AppendChild(Series);

                //查询历史记录
                sql.Length = 0;
                SqlParameter[] sqlParas = new SqlParameter[3];
                sqlParas[0] = new SqlParameter("@startTime", startTime);
                sqlParas[1] = new SqlParameter("@endTime", endTime);
                sqlParas[2] = new SqlParameter("@tableName", tableName);
                sqlParas[0].Direction = ParameterDirection.Input;
                sqlParas[1].Direction = ParameterDirection.Input;
                sqlParas[2].Direction = ParameterDirection.Input;
                SqlDataReader dr = dao.executeProc("procHisAlarmChart", sqlParas);

                if (1 <= BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]) && dr.HasRows)    //存在表记录
                {

                    //查找上下限
                    String sql_str = "select * from dbo.PSOG_Instrumentation where Instrumentation_Code='" + anychartName + "'";
                    DataSet dss = dao.executeQuery(sql_str.ToString());

                   
                    if (BeanTools.DataSetIsNotNull(dss))
                    {
                        string HILimit = dss.Tables[0].Rows[0]["Instrumentation_High"].ToString();
                        string LOLimit = dss.Tables[0].Rows[0]["Instrumentation_Low"].ToString();
                        if (!string.IsNullOrEmpty(upLine)) {
                            HILimit = upLine;
                        }
                        if (!string.IsNullOrEmpty(downLine)) {
                            LOLimit = downLine;
                        }

                        if (!"1000000".Equals(HILimit) && "-1000000".Equals(LOLimit))
                        {
                            XmlElement Series2 = XMLDoc.CreateElement("series");
                            Series2.SetAttribute("name", "高限");
                            Series2.SetAttribute("color", "RGB(255,0,255)");
                            seriesNode.AppendChild(Series2);
                        }
                        else if ("1000000".Equals(HILimit) && !"-1000000".Equals(LOLimit))
                        {
                            XmlElement Series2 = XMLDoc.CreateElement("series");
                            Series2.SetAttribute("name", "低限");
                            Series2.SetAttribute("color", "RGB(0,255,255)");
                            seriesNode.AppendChild(Series2);
                        }
                        else if (!"1000000".Equals(HILimit) && !"-1000000".Equals(LOLimit))
                        {
                            XmlElement Series2 = XMLDoc.CreateElement("series");
                            Series2.SetAttribute("name", "高限");
                            Series2.SetAttribute("color", "RGB(255,0,255)");
                            seriesNode.AppendChild(Series2);

                            XmlElement Series3 = XMLDoc.CreateElement("series");
                            Series3.SetAttribute("name", "低限");
                            Series3.SetAttribute("color", "RGB(0,255,255)");
                            seriesNode.AppendChild(Series3);
                        }        

                        if (null != dr)
                        {
                            while (dr.Read())
                            {
                                CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), BeanTools.ObjectToString(dr["RealTime_Value"]).Trim(), "RGB(0,0,255)", "1");
                               
                                if (!"1000000".Equals(HILimit) && "-1000000".Equals(LOLimit))
                                {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), HILimit.Trim(), "RGB(255,0,255)", "2");
                                }
                                else if ("1000000".Equals(HILimit) && !"-1000000".Equals(LOLimit)) {
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), LOLimit.Trim(), "RGB(0,255,255)", "2");
                                }
                                else if (!"1000000".Equals(HILimit) && !"-1000000".Equals(LOLimit)) {
                                   
                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), HILimit.Trim(), "RGB(255,0,255)", "2");

                                    CreateInstruXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), LOLimit.Trim(), "RGB(0,255,255)", "3");
                                }                   
         
                            }
                        }
                    }
                    else
                    {
                        if (null != dr)
                        {
                            while (dr.Read())
                            {
                                CreateXml(BeanTools.DataTimeToString(dr["RealTime_Time"]).Trim(), BeanTools.ObjectToString(dr["RealTime_Value"]).Trim());
                            }
                        }
                    }
                    dao.closeConn();
                }
                else//创建空节点
                {
                    XmlElement Point = XMLDoc.CreateElement("point");
                    Point.SetAttribute("name", "无记录");
                    Point.SetAttribute("y", "0");
                    Series.AppendChild(Point);
                }
            }
            return XMLDoc.InnerXml;

        }
      

        /// <summary>
        /// 获取位号的描述
        /// </summary>
        /// <param name="bitCode"></param>
        /// <returns></returns>
        public string getBitDesc(Plant plant,string bitCode) {
            string bitDesc = "";
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("select t.Instrumentation_Name from PSOG_Instrumentation t where t.Instrumentation_Code='{0}'", bitCode);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    bitDesc = dr["Instrumentation_Name"].ToString();
                }
            }
            return bitDesc;
        }


        private string getSqlStr(String startTime, String endTime)
        {
            StringBuilder sql = new StringBuilder();
            if (!string.IsNullOrEmpty(startTime))
            {
                sql.AppendFormat(" and RealTime_Time >= '{0}'", startTime);
            }
            if (!string.IsNullOrEmpty(endTime))
            {
                sql.AppendFormat("and RealTime_Time <= '{0}'", endTime);
            }
            return sql.ToString();
        }
        
        public void LoadXML()
        {
            XMLDoc = new XmlDocument();
            XMLDoc.Load(CommonStr.physicalPath + @"resource\chartXml\alarmChartLine.xml");
            seriesNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data");
            //seriesNode.RemoveAll();
            //seriesNode.InnerText = "";
        }
        
        #endregion

        public void LoadXML(String filePath)
        {
            XMLDoc = new XmlDocument();
            XMLDoc.Load(CommonStr.physicalPath + filePath);
            seriesNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data");
            //seriesNode.RemoveAll();
            //seriesNode.InnerText = "";
            
           
           
        }

        public void CreateXml(string name, string y)
        {

            //if (CheckBuildingId == null)
            //{
                

            //    XmlElement Point = XMLDoc.CreateElement("point");
            //    Point.SetAttribute("name", name);
            //    Point.SetAttribute("y", y);
            //    Series.AppendChild(Point);
            //}
            //else if (CheckBuildingId == anychartName)
            //{

                XmlNode pointNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data/series[last()]");
                XmlElement Point = XMLDoc.CreateElement("point");
                Point.SetAttribute("name", name);
                Point.SetAttribute("y", y);
                pointNode.AppendChild(Point);
            //}
            
        }

        public void CreateInstruXml(string name, string y, string pointColor, string seriesNo)
        {
            XmlNode pointNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data/series[" + seriesNo + "]");
            XmlElement Point = XMLDoc.CreateElement("point");
            Point.SetAttribute("name", name);
            Point.SetAttribute("y", y);
            pointNode.AppendChild(Point);
        }

        public void CreateAlarmChart(string name, string y)
        {

            if (CheckBuildingId == null)
            {
                seriesNode.RemoveAll(); //清空历史节点
                seriesNode.InnerText = "";

                CheckBuildingId = "10Min平均报警率";
                XmlElement Series = XMLDoc.CreateElement("series");

                Series.SetAttribute("name", "10Min平均报警率");

                seriesNode.AppendChild(Series);

                XmlElement Point = XMLDoc.CreateElement("point");
                Point.SetAttribute("name", name);
                Point.SetAttribute("y", y);
                Series.AppendChild(Point);
            }
            else if (CheckBuildingId == "10Min平均报警率")
            {

                XmlNode pointNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data/series[last()]");
                XmlElement Point = XMLDoc.CreateElement("point");
                Point.SetAttribute("name", name);
                Point.SetAttribute("y", y);
                pointNode.AppendChild(Point);
            }

        }

        public void CreateAlarmPie(XmlDocument pieXMLDoc, string name, string y)
        {

            if (hasPie == null)
            {
                pieSeriesNode.RemoveAll(); //清空历史节点
                pieSeriesNode.InnerText = "";

                hasPie = "报警次数TOP10";
                XmlElement Series = pieXMLDoc.CreateElement("series");

                Series.SetAttribute("name", "报警次数TOP10");

                pieSeriesNode.AppendChild(Series);

                XmlElement Point = pieXMLDoc.CreateElement("point");
                Point.SetAttribute("name", name);
                Point.SetAttribute("y", y);
                Series.AppendChild(Point);
            }
            else if (hasPie == "报警次数TOP10")
            {

                XmlNode pointNode = pieXMLDoc.SelectSingleNode("/anychart/charts/chart/data/series[last()]");
                XmlElement Point = pieXMLDoc.CreateElement("point");
                Point.SetAttribute("name", name);
                Point.SetAttribute("y", y);
                pointNode.AppendChild(Point);
            }

        }

        #region 导出-综合分析
        /// <summary>
        /// 导出-综合分析
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public System.IO.MemoryStream expCompAnalysis(string startTime, string endTime, string DBName)
        {
            IDao dao = new Dao(DBName);
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            try
            {
                SqlParameter[] parames = new SqlParameter[5];
                parames[0] = new SqlParameter("@SearchStartTime", startTime);
                parames[1] = new SqlParameter("@SearchEndTime", endTime);
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[3] = new SqlParameter("@MaxPercent", "0");
                parames[4] = new SqlParameter("@PerturbationRate", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;
                parames[3].Direction = ParameterDirection.Output;
                parames[4].Direction = ParameterDirection.Output;

                SqlDataReader dr = dao.executeProc("procAlarmZHSearch_10HisData", parames);

                if (null != dr)
                {
                    ms = BeanTools.RenderToExcel(dr);
                }
            }
            catch (Exception exp)
            {
            }
            dao.closeConn();
            return ms;
        }
        #endregion;

        #region 导出-综合分析
        /// <summary>
        /// 导出-平稳率分析
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public System.IO.MemoryStream expStableRateAnaly(string starttime, string endtime, Plant plant)
        {
            IDao dao = new Dao(plant,true);
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            if (null != starttime && null != endtime)
            {
                SqlParameter[] parames = new SqlParameter[3];
                parames[0] = new SqlParameter("@SearchStartTime", starttime);
                parames[1] = new SqlParameter("@SearchEndTime", endtime);
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;

                SqlDataReader dr = dao.executeProc("procInsSearch_10HisData", parames);
                if (null != dr)
                {
                    ms = ExpExecl.stableRateToExcel(dr);
                }
            }
            dao.closeConn();
            return ms;
        }
        #endregion;

        #region 导出-历史查询
        /// <summary>
        /// 导出-历史查询
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public System.IO.MemoryStream expAlarmHistory(string starttime, string endtime, Plant plant)
        {
            IDao dao = new Dao(plant,true);
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            if (null != starttime && null != endtime)
            {
                //报警历史统计
                StringBuilder sql = new StringBuilder();
                sql.Append("select *,count(1) over() rowno ");
                sql.Append("from PSOG_AlarmManager_History h ");
                sql.Append("where 1=1 ");
                if (!string.IsNullOrEmpty(endtime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime < '{0}' ", endtime);
                }
                if (!string.IsNullOrEmpty(starttime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime > '{0}' ", starttime);
                }
                sql.Append("order by h.id asc ");

                DataSet ds1 = dao.executeQuery(sql.ToString());

                //报警次数统计
                sql = new StringBuilder();
                sql.Append("select h.alarmmanager_history_items,count(1) statisNo,a.alarmmanager_describe ");
                sql.Append("from PSOG_AlarmManager_History h,psog_alarmManager a ");
                sql.Append("where a.alarmmanager_name = h.alarmmanager_history_items ");
                if (!string.IsNullOrEmpty(endtime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime < '{0}' ", endtime);
                }
                if (!string.IsNullOrEmpty(starttime))
                {
                    sql.AppendFormat("and h.alarmManager_history_starttime > '{0}' ", starttime);
                }
                sql.Append("group by h.alarmmanager_history_items,a.id,a.alarmmanager_describe ");
                sql.Append("order by count(1) desc ");

                DataSet ds2 = dao.executeQuery(sql.ToString());


                ms = ExpExecl.ToExcel(ds1.Tables[0], ds2.Tables[0]);
            }
            dao.closeConn();
            return ms;
        }
        #endregion;


        public System.IO.MemoryStream expCompAnaly(string starttime, string endtime,Plant plant)
        {
            IDao dao = new Dao(plant,true);
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            if (null != starttime && null != endtime)
            {
                SqlParameter[] parames = new SqlParameter[5];
                parames[0] = new SqlParameter("@SearchStartTime", starttime);
                parames[1] = new SqlParameter("@SearchEndTime", endtime);
                parames[2] = new SqlParameter("@IsUseUnusualTime", "0");
                parames[3] = new SqlParameter("@MaxPercent", "0");
                parames[4] = new SqlParameter("@PerturbationRate", "0");
                parames[0].Direction = ParameterDirection.Input;
                parames[1].Direction = ParameterDirection.Input;
                parames[2].Direction = ParameterDirection.Input;
                parames[3].Direction = ParameterDirection.Output;
                parames[4].Direction = ParameterDirection.Output;

                SqlDataReader dr = dao.executeProc("procAlarmZHSearch_10HisData", parames);
                if (null != dr)
                {
                    ms = ExpExecl.CompToExcel(dr);
                }
            }
            dao.closeConn();
            return ms;
        }

        /// <summary>
        /// 运行状态图标
        /// </summary>
        /// <param name="DBName"></param>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <param name="modalName">那个模块下</param>
        /// <param name="anychartName">图标名称</param>
        /// <returns></returns>
        public string alarmNotIEMchartLine(Plant plant, string startTime, string endTime, string modelId, string anychartName)
        {
            IDao dao = new Dao(plant,true);

            LoadXML(@"resource\chartXml\alarmChart.xml");
            //测试标题
            //XmlNode titleNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/chart_settings/title");
            //if (titleNode == null)
            //{
            //    titleNode = XMLDoc.CreateElement("title");
            //    XmlNode chartSetNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/chart_settings");
            //    chartSetNode.AppendChild(titleNode);
            //}
            //XmlNode titleTextNode = titleNode.SelectSingleNode("text");
            //if (titleTextNode == null)
            //{
            //    titleTextNode = XMLDoc.CreateElement("text");
            //    titleNode.AppendChild(titleTextNode);
            //}
            ////XmlNode titleFontNode = XMLDoc.CreateElement("font");
            ////titleNode.AppendChild(titleFontNode);
            ////XmlElement font = (XmlElement)titleFontNode;
            ////font.SetAttribute("render_as_html", "true");
            //XmlElement el = (XmlElement)titleNode;
            //el.SetAttribute("enabled", "true");
            //el.SetAttribute("padding", "15");

            //titleTextNode.InnerText = anychartName;

            seriesNode.RemoveAll(); //清空历史节点
            seriesNode.InnerText = "";
            XmlElement Series = XMLDoc.CreateElement("series");
            Series.SetAttribute("name", anychartName);
            seriesNode.AppendChild(Series);

            SqlParameter[] sqlPara = new SqlParameter[3];
            sqlPara[0] = new SqlParameter("@startTime", startTime);
            sqlPara[1] = new SqlParameter("@endTime", endTime);
            sqlPara[2] = new SqlParameter("@modelId", modelId);
            sqlPara[0].Direction = ParameterDirection.Input;
            sqlPara[1].Direction = ParameterDirection.Input;
            sqlPara[2].Direction = ParameterDirection.Input;


            SqlDataReader dr = dao.executeProc("procMonitorLimitNumData", sqlPara);

            //createAlarmLine(dao);//填充警戒线

            if (null != dr)
            {
                if (!dr.HasRows)
                {
                    XmlElement Point = XMLDoc.CreateElement("point");//创建空节点
                    Point.SetAttribute("name", "无记录");
                    Point.SetAttribute("y", "0");
                    Series.AppendChild(Point);
                }

                string curTime = "";
                int DCSAlarmNum = 0; //正常值
                int XT2AlarmNum = 0;    //经验值
                int i = 0;  //记录第多少条记录
                String showTitle = "";
                bool isFirstRecord = true ;
                string pointColor = "green"; //当前点颜色
                string modelTimeLast = "", realValueLast = "", showTitleLast = "", pointColorLast = "", dcsTitleLast = "", xtTitleLast="";
                String dcsTitle = "";
                string xtTitle = "";
                while (dr.Read())
                {

                    double recordvalue = Math.Round(Convert.ToDouble(BeanTools.ObjectToString(dr["VResMSPC_T2RealValue"]).Trim()), 4);
                    string realValue = BeanTools.ObjectToString(recordvalue);   //数值
                    string modelTime = BeanTools.DataTimeToString(dr["VResMSPC_ModelTime"]).Trim();   //时间
                    string tagXT2AlarmFlag = BeanTools.ObjectToString(dr["VResMSPC_TagXT2AlarmFlag"]).Trim();//经验
                    string tagDCSAlarmFlag = BeanTools.ObjectToString(dr["VResMSPC_TagDCSAlarmFlag"]).Trim();//正常
                    string tagName = BeanTools.ObjectToString(dr["VResMSPC_TagName"]).Trim();   //仪器
                    string tagDesc = BeanTools.ObjectToString(dr["VResMSPC_TagDesc"]).Trim();   //描述
                    string RTDataBias = BeanTools.ObjectToString(dr["VResMSPC_TagRTDataBias"]).Trim();   //偏离值--,
                    string tagRTData = BeanTools.ObjectToString(dr["VResMSPC_TagRTData"]).Trim();
                    string alarmFlag = BeanTools.ObjectToString(dr["VResMSPC_ModelAlarmFlag"]).Trim();   //是否偏离

                    if (95 <= recordvalue)
                    {
                        pointColor = "green";
                    }
                    else if (85 <= recordvalue)
                    {
                        pointColor = "Yellow";
                    }
                    else if (85 > recordvalue && 0 == DCSAlarmNum)
                    {
                        pointColor = "Yellow";
                    }
                    else
                    {
                        pointColor = "Red";
                    }

                    if ("" == curTime || curTime != modelTime)//时间段内首个点
                    {
                        DCSAlarmNum = 0;
                        XT2AlarmNum = 0;
                        dcsTitle = "";
                        xtTitle = "";
                        
                        showTitle = "当前评分：" + realValue + @"\n" + "当前时间：" + modelTime + @"";
                        //showTitle += @"\n当前状态: " + ("1" == alarmFlag ? "异常" : "正常") + @" ";
                        showTitle += @"\n当前状态: " + ("green" == pointColor ? "正常" : "异常") + @" ";
                        curTime = modelTime;

                        if ("0" != alarmFlag)
                        {
                            if ("0" != tagDCSAlarmFlag && 2 >= DCSAlarmNum)
                            {
                                dcsTitle += @"\n偏离DCS阈值点：";
                                dcsTitle += @"\n" + tagName + @" " + ("1" == tagXT2AlarmFlag ? "偏高" : "偏低") + "（" + tagDesc + " " + tagRTData + "）";
                                DCSAlarmNum++;
                            }

                            if ("0" != tagXT2AlarmFlag && 2 >= XT2AlarmNum && "0" == tagDCSAlarmFlag)
                            {
                                xtTitle += @"\n偏离经验阈值点：";
                                xtTitle += @"\n" + tagName + @" " + ("1" == tagXT2AlarmFlag ? "偏高" : "偏低") + "（" + tagDesc + " " + tagRTData + "）";
                                XT2AlarmNum++;
                            }
                        }
                        

                        i = 0;  //新的时间点重置记录数；
                    }
                    else
                    {
                        if ("0" != alarmFlag)
                        {
                            if ("0" != tagDCSAlarmFlag && 2 >= DCSAlarmNum)
                            {
                                if (0 == DCSAlarmNum)
                                {
                                    dcsTitle += @"\n偏离DCS阈值点：";
                                }
                                dcsTitle += @"\n" + tagName + @" " + ("1" == tagXT2AlarmFlag ? "偏高" : "偏低") + "（" + tagDesc + " " + tagRTData + "）";
                                DCSAlarmNum++;
                            }

                            if ("0" != tagXT2AlarmFlag && 2 >= XT2AlarmNum && "0" == tagDCSAlarmFlag)
                            {
                                if (0 == XT2AlarmNum)
                                {
                                    xtTitle += @"\n偏离经验阈值点：";
                                }
                                xtTitle += @"\n" + tagName + @" " + ("1" == tagXT2AlarmFlag ? "偏高" : "偏低") + "（" + tagDesc + " " + tagRTData + "）";
                                XT2AlarmNum++;
                            }
                        }

                        
                        i++;    //新记录加1；
                    }

                    if (0 == i && false == isFirstRecord)
                    {
                        CreateNotIEMchartXml(modelTimeLast, realValueLast, showTitleLast + dcsTitleLast + xtTitleLast, pointColorLast);
                    }

                    //记录历史值
                    modelTimeLast = modelTime;
                    realValueLast = realValue;
                    showTitleLast = showTitle;
                    pointColorLast = pointColor;
                    dcsTitleLast = dcsTitle;
                    xtTitleLast = xtTitle;

                    isFirstRecord = false;
                }

                //记录最后一个点
                if ("" != modelTimeLast)
                {
                    CreateNotIEMchartXml(modelTimeLast, realValueLast, showTitleLast, pointColorLast);
                }
            }
            else
            {
                XmlElement Point = XMLDoc.CreateElement("point");//创建空节点
                Point.SetAttribute("name", "无记录");
                Point.SetAttribute("y", "0");
                Series.AppendChild(Point);
            }
            dao.closeConn();
    
            return XMLDoc.InnerXml;
        }

        public void createAlarmLine(IDao dao)
        {
            String sql =  "select max(fdpca_t2threshold) from RTResEx_FDPCA_T2 ";
            sql += " where time = (select max(time) from RTResEx_FDPCA_T2) ";

            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                string lineNum = BeanTools.ObjectToString(ds.Tables[0].Rows[0][0]);
                XmlNode pointNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/chart_settings/axes/y_axis/axis_markers/lines");
                if (null != lineNum && "" != lineNum)
                {
                    pointNode.RemoveAll();

                    String nodeText = "<line value='" + lineNum + "' thickness='1' color='Blue' caps='Square' dashed='false'>" +
                                    "<label enabled='True' multi_line_align='Center' position='Far' padding='10'>" +
                                        "<font bold='true' color='Blue' size='11' />" +
                                        "<format>{%Value}</format>" +
                                    "</label>" +
                                "</line>";
                    pointNode.InnerXml = nodeText;
                }
            }
        }

        public void CreateNotIEMchartXml(string value, string y, string title, string pointColor)
        {

            //if (CheckBuildingId == null)
            //{
                
            //    XmlElement Point = XMLDoc.CreateElement("point");
            //    Point.SetAttribute("name", value);
            //    Point.SetAttribute("y", y);
            //    Series.AppendChild(Point);
            //}
            //else if (CheckBuildingId == anychartName)// dr["BuildingId"].ToString())
            //{
                XmlNode pointNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data/series[last()]");
                XmlElement Point = XMLDoc.CreateElement("point");
                Point.SetAttribute("name", value);
                Point.SetAttribute("y", y);
                if ("" != pointColor)
                {
                    Point.SetAttribute("color", pointColor);
                }
                pointNode.AppendChild(Point);

                Point.InnerXml = "<attributes><attribute name=\"ShowTitle\"><![CDATA[" + title + "]]></attribute></attributes>";
                
            //}

        }

        #region 报警相关偏离点
        /// <summary>
        /// 参数分析
        /// </summary>
        public EasyUIData monitorDetail(Plant plant, String modleid, String name, String value)  //int page, int rows
        {
            IDao dao = new Dao(plant,true);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            IList xtList = new ArrayList();
            String sql = "select t.*,p.instrumentation_unit from View_ResMSPC t, psog_instrumentation  p "
                                + "where t.VResMSPC_Tagid = p.id and VResMSPC_ModelID = "
                                + modleid + " and (VResMSPC_TagDCSAlarmFlag != 0 or VResMSPC_TagXT2AlarmFlag != 0) "
                                + "and VResMSPC_ModelTime = '" + name
                                + "' and cast(round(VResMSPC_T2RealValue,3) as numeric(5,3)) = cast(round(" + value + ", 3) as numeric(5,3)) order by abs(vresmspc_tagrtdatabias) desc"
                                + ""
                                ;    //, count(1) over() rowno
            DataSet ds = dao.executeQuery(sql); //, page, rows
            if (BeanTools.DataSetIsNotNull(ds))
            {
                //grid.total = ds.Tables[0].Rows[0]["rowno"];
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    MonitorDetail md = new MonitorDetail();
                    md.point = BeanTools.ObjectToString(dr["VResMSPC_TagName"]);
                    md.desc = BeanTools.ObjectToString(dr["VResMSPC_TagDesc"]);
                    md.unit = BeanTools.ObjectToString(dr["instrumentation_unit"]);
                    md.val = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagRTData"]));
                    md.time = BeanTools.DataTimeToString(dr["VResMSPC_ModelTime"]);
                    md.tagId = BeanTools.ObjectToString(dr["VResMSPC_tagid"]);
                    md.tagDCS = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagDCSL"])) + "-" + getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagDCSH"]) );
                    md.tagXT = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagXT2L"])) + "-" + getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagXT2H"])); ;
                    
                    md.transState = "0" != BeanTools.ObjectToString(dr["VResMSPC_TagDCSAlarmFlag"]) ? "超DCS阈值" : "超经验阈值";
                    if ("0" != BeanTools.ObjectToString(dr["VResMSPC_TagDCSAlarmFlag"]))
                    {
                        list.Add(md);
                    }
                    else
                    {
                        xtList.Add(md);
                    }
                    
                }
            }
            foreach (MonitorDetail monitor in xtList)
            {
                list.Add(monitor);
            }
            grid.rows = list;
            return grid;
        }

        public string getRoundString(string sourceStr){
            try
            {
                return Math.Round(Convert.ToDouble(sourceStr), 4).ToString();
            }
            catch (Exception exp)
            {
                return "0";
            }
        }

        #endregion

        #region 报警相关偏离历史曲线
        public String alarmMonitorchartLine(Plant plant, String startTime, String endTime, String tableName, String tagId)
        {
            IDao dao = new Dao(plant,true);

            LoadXML1();
            anychartName = tableName;
            //tableName = tableName.Replace(".", "_");
            //测试标题
            XmlNode titleNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/chart_settings/title");
            if (titleNode == null)
            {
                titleNode = XMLDoc.CreateElement("title");
                XmlNode chartSetNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/chart_settings");
                chartSetNode.AppendChild(titleNode);
            }
            XmlNode titleTextNode = titleNode.SelectSingleNode("text");
            if (titleTextNode == null)
            {
                titleTextNode = XMLDoc.CreateElement("text");
                titleNode.AppendChild(titleTextNode);
            }
            //XmlNode titleFontNode = XMLDoc.CreateElement("font");
            //titleNode.AppendChild(titleFontNode);
            //XmlElement font = (XmlElement)titleFontNode;
            //font.SetAttribute("render_as_html", "true");
            XmlElement el = (XmlElement)titleNode;
            el.SetAttribute("enabled", "true");
            el.SetAttribute("padding", "15");
            titleTextNode.InnerText = anychartName;

            String sql = "";
            seriesNode.RemoveAll(); //清空历史节点
            seriesNode.InnerText = "";
            //XmlElement Series1 = XMLDoc.CreateElement("series");
            //Series1.SetAttribute("name", anychartName);
            //seriesNode.AppendChild(Series1);
            XmlElement Series = XMLDoc.CreateElement("series");
            Series.SetAttribute("name", "实时值");
            Series.SetAttribute("color", "green");
            seriesNode.AppendChild(Series);
            XmlElement Series4 = XMLDoc.CreateElement("series");
            Series4.SetAttribute("name", "正常值上限");
            Series4.SetAttribute("color", "RGB(255,0,0)");
            seriesNode.AppendChild(Series4);
            XmlElement Series2 = XMLDoc.CreateElement("series");
            Series2.SetAttribute("name", "经验值上限");
            Series2.SetAttribute("color", "RGB(255,0,255)");
            seriesNode.AppendChild(Series2);
            XmlElement Series3 = XMLDoc.CreateElement("series");
            Series3.SetAttribute("name", "经验值下限");
            Series3.SetAttribute("color", "RGB(0,255,255)");
            seriesNode.AppendChild(Series3);
            XmlElement Series5 = XMLDoc.CreateElement("series");
            Series5.SetAttribute("name", "正常值下限");
            Series5.SetAttribute("color", "RGB(0,0,255)");
            seriesNode.AppendChild(Series5);


            SqlParameter[] sqlParas = new SqlParameter[3];
            sqlParas[0] = new SqlParameter("@startTime", startTime);
            sqlParas[1] = new SqlParameter("@endTime", endTime);
            sqlParas[2] = new SqlParameter("@InstrumentId", tagId);
            sqlParas[0].Direction = ParameterDirection.Input;
            sqlParas[1].Direction = ParameterDirection.Input;
            sqlParas[2].Direction = ParameterDirection.Input;

            SqlDataReader dr = dao.executeProc("procInstrumentLimitNumData", sqlParas);
            if (null != dr)
            {
                while (dr.Read())
                {
                    CreateInstruXml(BeanTools.DataTimeToString(dr["vresmspc_modelTime"]).Trim(), BeanTools.ObjectToString(dr["VResMSPC_TagRTData"]).Trim(), "Green", "1");
                    CreateInstruXml(BeanTools.DataTimeToString(dr["vresmspc_modelTime"]).Trim(), BeanTools.ObjectToString(dr["VResMSPC_TagDCSH"]).Trim(), "RGB(255,0,0)", "2");
                    CreateInstruXml(BeanTools.DataTimeToString(dr["vresmspc_modelTime"]).Trim(), BeanTools.ObjectToString(dr["VResMSPC_TagXT2H"]).Trim(), "RGB(255,0,255)", "3");
                    CreateInstruXml(BeanTools.DataTimeToString(dr["vresmspc_modelTime"]).Trim(), BeanTools.ObjectToString(dr["VResMSPC_TagXT2L"]).Trim(), "RGB(0,255,255)", "4");
                    CreateInstruXml(BeanTools.DataTimeToString(dr["vresmspc_modelTime"]).Trim(), BeanTools.ObjectToString(dr["VResMSPC_TagDCSL"]).Trim(), "RGB(0,0,255)", "5");
                }
            }
            else//创建空节点
            {
                XmlElement Point = XMLDoc.CreateElement("point");
                Point.SetAttribute("name", "无记录");
                Point.SetAttribute("y", "0");
                Series.AppendChild(Point);
            }

            dao.closeConn();

            return XMLDoc.InnerXml;

        }

        private string getSqlStr1(String startTime, String endTime)
        {
            StringBuilder sql = new StringBuilder();
            if (!string.IsNullOrEmpty(startTime))
            {
                sql.AppendFormat(" and RealTime_Time >= '{0}'", startTime);
            }
            if (!string.IsNullOrEmpty(endTime))
            {
                sql.AppendFormat("and RealTime_Time <= '{0}'", endTime);
            }
            return sql.ToString();
        }

        public void LoadXML1()
        {
            XMLDoc = new XmlDocument();
            XMLDoc.Load(CommonStr.physicalPath + @"resource\chartXml\alarmInstruChartLine.xml");
            seriesNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data");
            //seriesNode.RemoveAll();
            //seriesNode.InnerText = "";
        }

        #endregion

        /// <summary>
        /// 实时报警--下hazop
        /// </summary>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public EasyUIData qryAlarmHazop(Plant plant, string instrumentId, string state)
        {
            EasyUIData grid = new EasyUIData();

            IDao dao = new Dao(plant,true);
            IList list = new ArrayList();
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	p.id,");
            sql.Append("	p.hazop_reason,");
            sql.Append("	p.hazop_measure,");
            sql.Append("	p.hazop_conseq,");
            sql.Append("	COUNT (1) OVER () rowNum,");
            sql.Append("	p.hazop_prevent");
            sql.Append(" FROM psog_hazop p ");
            sql.Append(" INNER JOIN PSOG_Instrumentation t ON p.HAZOP_InstrumentationID = t.ID");
            sql.AppendFormat(" AND t.Instrumentation_Code = '{0}'", instrumentId);
            sql.AppendFormat(" WHERE hazop_bias = '{0}'", state);
            sql.Append(" ORDER BY p.id");

            //String sql = string.Format("select id,hazop_reason, hazop_measure,hazop_conseq,count(1) over() rowNum,hazop_prevent from psog_hazop p where hazop_instrumentationid='{0}' and hazop_bias='{1}' order by id", instrumentId, state);    //, count(1) over() rowno
            DataSet ds = dao.executeQuery(sql.ToString()); //, page, rows
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmRealTime alarm = new AlarmRealTime();
                    alarm.tableId = BeanTools.ObjectToString(dr["id"]);
                    alarm.cause = BeanTools.ObjectToString(dr["hazop_reason"]);
                    alarm.measure = BeanTools.ObjectToString(dr["hazop_measure"]);
                    alarm.rowcount = BeanTools.ObjectToString(dr["rowNum"]);
                    alarm.effect = System.Text.RegularExpressions.Regex.Replace(BeanTools.ObjectToString(dr["hazop_conseq"]), "\\n", "<br />");
                    alarm.prevent = BeanTools.ObjectToString(dr["hazop_prevent"]);
                    
                    list.Add(alarm);
                }
            }
            grid.rows = list;
            return grid;
        }

        public string FaultTreeResult(Plant plant)  //查询所有故障树的状态
        {
            IList list = new ArrayList();
            IDao dao = new Dao(plant, false);

            try
            {
                String sql = "select * from dbo.PSOG_AS_Equipment";
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        FaultTreeResult bv = new FaultTreeResult();
                        bv.id = ds.Tables[0].Rows[i]["AS_Equipment_ID"].ToString();
                        bv.status = ds.Tables[0].Rows[i]["AS_Equipment_State"].ToString();
                        bv.ASName = ds.Tables[0].Rows[i]["AS_Equipment_Name"].ToString();
                        bv.unit = ds.Tables[0].Rows[i]["AS_Equipment_Process"].ToString();
                        list.Add(bv);
                    }
                }
            }
            catch (Exception e)
            {
                string str = e.Message;
            }

            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            string jsonData = jsonSerializer.Serialize(list);
            return jsonData;
        }

        public string FaultTreeJsonById(Plant plant, string Id)  //written by ZhuJF @150714
        {
            string list = "{\"rows\":[";
            IDao dao = new Dao(plant, false);

            try
            {
                List<int> AS_id = new List<int>();
                List<string> AS_name = new List<string>();
                List<int> AS_type = new List<int>();
                List<int> AS_fatherId = new List<int>();
                String sql = "select * from dbo.PSOG_AS_EquipmentCause where AS_EquipmentCause_NodeID = " + Id + " order by id";
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        AS_id.Add(int.Parse(ds.Tables[0].Rows[i]["AS_EquipmentCause_ID"].ToString()));
                        AS_name.Add(ds.Tables[0].Rows[i]["AS_EquipmentCause_DESC"].ToString());
                        AS_type.Add(int.Parse(ds.Tables[0].Rows[i]["AS_EquipmentCause_Type"].ToString()));
                        AS_fatherId.Add(int.Parse(ds.Tables[0].Rows[i]["AS_EquipmentCause_FatherID"].ToString()));
                    }
                }

                int topId = 0;
                int flagTop = 0;
                for ( int i = 0; i < AS_id.Count; i++ )
                {
                    string reasonStr = "";
                    if(AS_type[i] == 1)
                    {
                        topId = AS_id[i];
                        continue;
                    }
                    if (AS_type[i] == 2)
                    {
                        string actionStr = "";
                        int flag = 0;
                        for (int ii = 0; ii < AS_id.Count; ii++)
                        {
                            if (AS_fatherId[ii] == AS_id[i] && AS_type[ii] == 3)
                            {
                                if (flag != 0)
                                {
                                    actionStr += "。 "+AS_name[ii];
                                }
                                else
                                {
                                    actionStr += AS_name[ii];
                                }
                                flag++;
                            }
                        }

                        reasonStr = "{\"id\":" + AS_id[i] + ", \"reason\":\"" + AS_name[i] + "\", \"action\":\"" + actionStr + "\"}";
                        if(AS_fatherId[i] == topId)
                        {
                            if (flagTop != 0)
                            {
                                list += ", " + reasonStr;
                            }
                            else
                            {
                                list += reasonStr;
                            }
                            flagTop++;
                        }
                        
                    }

                }
                list += "]}";

            }
            catch (Exception e)
            {
                string str = e.Message;
            }

            return list;
        }


        /************以下为异常运行状态增加（图3-2）************/
        public IList pcaModelTags(Plant plant, String modelID)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(plant, true);

            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("select * from PSOG_Instrumentation where ID in");
            sql.AppendFormat("(select PCATag_TagID from PSOG_PCATag where PCATag_ModelID={0})", modelID);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    PCAModelTags pca = new PCAModelTags();
                    pca.id = i + 1;
                    pca.tagName = ds.Tables[0].Rows[i]["Instrumentation_Code"].ToString();
                    pca.tagDescription = ds.Tables[0].Rows[i]["Instrumentation_Name"].ToString();
                    pca.tagUnit = ds.Tables[0].Rows[i]["Instrumentation_Unit"].ToString();
                    pca.HHLimit = double.Parse(ds.Tables[0].Rows[i]["Instrumentation_HHigh"].ToString());
                    pca.HLimit = double.Parse(ds.Tables[0].Rows[i]["Instrumentation_High"].ToString());
                    pca.LLLimit = double.Parse(ds.Tables[0].Rows[i]["Instrumentation_LLow"].ToString());
                    pca.LLimit = double.Parse(ds.Tables[0].Rows[i]["Instrumentation_Low"].ToString());
                    list.Add(pca);
                }
            }
            return list;
        }

        public string DeviceMonitoringResultById(Plant plant, string Id)  //written by ZhuJF @150401
        {
            string list = "";
            IDao dao = new Dao(plant, false);

            try
            {
                String sql = "select * from PSOG_ProcessMonitorObject where PSOG_MonitorObject_MSPCModelID = " + Id;
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        if (int.Parse(ds.Tables[0].Rows[i]["MonitorObject_MSPCCurrStatus"].ToString()) == 1)
                        {
                            list = list + "正常";
                        }
                        else if (int.Parse(ds.Tables[0].Rows[i]["MonitorObject_MSPCCurrStatus"].ToString()) == 0)
                        {
                            list = list + "预警";
                        }
                        else
                        {
                            list = list + "异常";
                        }
                        list = list + "," + ds.Tables[0].Rows[i]["MonitorObject_MSPCStartTime"].ToString();
                    }
                }
            }
            catch (Exception e)
            {
                string str = e.Message;
            }

            return list;
        }


        public EasyUIData pcaAbnormalHistory(Plant plant, String modelID) //查询设备监测历史故障，历史表
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            IDao dao = new Dao(plant, true);

            String sql = "select * from dbo.RTResEx_FDPCA_T2_History where ModelID=" + modelID + " and ModelState = -1";
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    FTAHistoryModel fta = new FTAHistoryModel();
                    fta.id = i + 1;
                    fta.ftaStartTime = ds.Tables[0].Rows[i]["StartTime"].ToString();
                    fta.ftaEndTime = ds.Tables[0].Rows[i]["EndTime"].ToString();

                    DateTimeFormatInfo dtFormat = new System.Globalization.DateTimeFormatInfo();
                    dtFormat.ShortDatePattern = "yyyy/MM/dd HH:mm:ss";
                    DateTime dtStart = Convert.ToDateTime(fta.ftaStartTime, dtFormat);
                    DateTime dtEnd = Convert.ToDateTime(fta.ftaEndTime, dtFormat);
                    TimeSpan TS = dtEnd.Subtract(dtStart);
                    double hours = (Math.Round(TS.TotalHours * 100) + 1) / 100;
                    fta.ftaDuration = hours.ToString();
                    list.Add(fta);
                }
            }
            grid.rows = list;
            return grid;
        }

        #region 设备监测报警相关偏离点 - by ZhuJF @150319
        /// <summary>
        /// 参数分析
        /// </summary>
        public EasyUIData monitorDeviceDetail(Plant plant, String modleid, String startT, String endT, String id)  //int page, int rows
        {
            DateTime dt = DateTime.Now;
            IDao dao = new Dao(plant, true);
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            IList xtList = new ArrayList();
            String sql = "";
            if (id == "1")
            {
                sql = "exec procSearchPCAASTags '" + startT + "','" + endT + "'," + modleid;
            }
            else
            {
                sql = "exec procSearchPCAAllTags '" + startT + "','" + endT + "'," + modleid;
            }

            DataSet ds = dao.executeProcDS(sql, "procAlarmZHHisSearch_ChatterAlarm");

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    MonitorDetail md = new MonitorDetail();
                    md.point = BeanTools.ObjectToString(dr["VResMSPC_TagName"]);
                    md.desc = BeanTools.ObjectToString(dr["VResMSPC_TagDesc"]);
                    md.unit = BeanTools.ObjectToString(dr["instrumentation_unit"]);
                    md.val = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagRTData"]));
                    md.time = BeanTools.DataTimeToString(dr["VResMSPC_ModelTime"]);
                    md.tagId = BeanTools.ObjectToString(dr["VResMSPC_tagid"]);
                    md.tagDCS = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagDCSL"])) + "-" + getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagDCSH"]));
                    md.tagXT = getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagXT2L"])) + "-" + getRoundString(BeanTools.ObjectToString(dr["VResMSPC_TagXT2H"])); ;

                    md.transState = "0" != BeanTools.ObjectToString(dr["VResMSPC_TagDCSAlarmFlag"]) ? "超DCS阈值" : "超经验阈值";
                    if ("0" != BeanTools.ObjectToString(dr["VResMSPC_TagDCSAlarmFlag"]))
                    {
                        md.transState = "超DCS阈值";
                        list.Add(md);
                    }
                    else if ("0" != BeanTools.ObjectToString(dr["VResMSPC_TagXT2AlarmFlag"]))
                    {
                        md.transState = "超经验阈值";
                        xtList.Add(md);
                    }
                    else
                    {
                        md.transState = "正常";
                        list.Add(md);
                    }

                }
            }
            foreach (MonitorDetail monitor in xtList)
            {
                list.Add(monitor);
            }
            grid.rows = list;
            return grid;
        }

      

        #endregion

        public IList alarmAnychartLineNew(Plant plant, String startTime, String endTime, String tableName)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(plant, true);

            LoadXMLs();
            anychartName = tableName;
            tableName = tableName.Replace(".", "_");

            StringBuilder sql = new StringBuilder();
            sql.Append("select count(1) from sys.objects where name = 'PSOG_HisData_").Append(tableName).Append("'");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                seriesNode.RemoveAll(); //清空历史节点
                seriesNode.InnerText = "";
                XmlElement Series = XMLDoc.CreateElement("series");
                Series.SetAttribute("name", anychartName);
                seriesNode.AppendChild(Series);

                if (1 <= BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]))    //存在表记录
                {
                    sql.Length = 0;
                    SqlParameter[] sqlParas = new SqlParameter[3];
                    sqlParas[0] = new SqlParameter("@startTime", startTime);
                    sqlParas[1] = new SqlParameter("@endTime", endTime);
                    sqlParas[2] = new SqlParameter("@tableName", tableName);
                    sqlParas[0].Direction = ParameterDirection.Input;
                    sqlParas[1].Direction = ParameterDirection.Input;
                    sqlParas[2].Direction = ParameterDirection.Input;

                    SqlDataReader dr = dao.executeProc("procHisAlarmChart", sqlParas);
                    if (null != dr)
                    {
                        while (dr.Read())
                        {
                            PCAByTime pca = new PCAByTime();
                            pca.startTime = dr["RealTime_Time"].ToString();
                            pca.value = double.Parse(dr["RealTime_Value"].ToString());
                            list.Add(pca);
                        }
                    }
                    dao.closeConn();
                }
                else//创建空节点
                {
                   
                }
            }
            return list;

        }

        public void LoadXMLs()
        {
            XMLDoc = new XmlDocument();
            XMLDoc.Load(CommonStr.physicalPath + @"resource\chartXml\alarmChartLine.xml");
            seriesNode = XMLDoc.SelectSingleNode("/anychart/charts/chart/data");
            //seriesNode.RemoveAll();
            //seriesNode.InnerText = "";
        }

        /*************以下为运行监测状态(图2-2)*******************/
        public IList ftaModelTags(Plant plant, String modelID)  //查询某FTA的变量
        {
            IList list = new ArrayList();
            IDao dao = new Dao(plant, false);

            String sql = "select * from dbo.PSOG_FTATag where FTATag_ModelID=" + modelID;
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    FTAModelTags fta = new FTAModelTags();
                    fta.id = i + 1;
                    fta.tagName = ds.Tables[0].Rows[i]["FTATag_Name"].ToString();
                    fta.tagDescription = ds.Tables[0].Rows[i]["FTATag_Describre"].ToString();
                    string toolTipStr = ds.Tables[0].Rows[i]["FTATag_Property"].ToString();
                    string resultStr = GetFromToolTip(toolTipStr, "VaryValue");
                    string symbolStr = GetFromToolTip(toolTipStr, "Arithmetic");
                    if (resultStr == "")
                    {
                        fta.Limit = -0.1010;
                    }
                    else
                    {
                        fta.Limit = double.Parse(resultStr);
                    }

                    if (symbolStr == ">" || symbolStr == ">=")
                    {
                        fta.limitFlag = "-1";
                    }
                    else
                    {
                        fta.limitFlag = "1";
                    }

                    if (int.Parse(ds.Tables[0].Rows[i]["FTATag_State"].ToString()) == 1)
                    {
                        fta.tagState = "异常";
                    }
                    else
                    {
                        fta.tagState = "正常";
                    }
                    fta.tagStartTime = ds.Tables[0].Rows[i]["FTATag_Time"].ToString();
                    list.Add(fta);
                }
            }
            return list;
        }

        public string FaultTreeResultById(Plant plant, string Id)  //written by ZhuJF @150327
        {
            string list = "";
            IDao dao = new Dao(plant, false);

            try
            {
                String sql = "select * from PSOG_AS_Equipment where AS_Equipment_ID = " + Id;
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        if (int.Parse(ds.Tables[0].Rows[i]["AS_Equipment_State"].ToString()) == 1)
                        {
                            list = list + "正常";
                        }
                        else
                        {
                            list = list + "异常";
                        }
                        list = list + "," + ds.Tables[0].Rows[i]["AS_Equipment_StartTime"].ToString();
                        list = list + "," + ds.Tables[0].Rows[i]["AS_Equipment_Name"].ToString();
                    }
                }
            }
            catch (Exception e)
            {
                string str = e.Message;
            }

            return list;
        }


        public EasyUIData ftaAbnormalHistory(Plant plant, String modelID) //查询FTA历史故障，历史表
        {
            EasyUIData grid = new EasyUIData();
            IList list = new ArrayList();
            IDao dao = new Dao(plant, true);

            String sql = "select * from dbo.PSOG_ASGraph_History where ASGraph_History_NodeID=" + modelID;
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    FTAHistoryModel fta = new FTAHistoryModel();
                    fta.id = i + 1;
                    fta.ftaStartTime = ds.Tables[0].Rows[i]["ASGraph_History_NodeStartTime"].ToString();
                    fta.ftaEndTime = ds.Tables[0].Rows[i]["ASGraph_History_NodeEndTime"].ToString();

                    DateTimeFormatInfo dtFormat = new System.Globalization.DateTimeFormatInfo();
                    dtFormat.ShortDatePattern = "yyyy/MM/dd HH:mm:ss";
                    DateTime dtStart = Convert.ToDateTime(fta.ftaStartTime, dtFormat);
                    DateTime dtEnd = Convert.ToDateTime(fta.ftaEndTime, dtFormat);
                    TimeSpan TS = dtEnd.Subtract(dtStart);
                    double hours = (Math.Round(TS.TotalHours * 100) + 1) / 100;
                    fta.ftaDuration = hours.ToString();
                    list.Add(fta);
                }
            }
            grid.rows = list;
            return grid;
        }

        //Node属性操作
        public string GetFromToolTip(string strToolTip, string name)
        {
            //ID,Father_ID,MainWindow,Type,Add_Index,IsContainer,ConditionType,VaryName,Arithmetic,VaryValue,Unit,VaryError,TimeUnit,VaryNameLogic,IsError,Condition_ID,KgetN
            string str = strToolTip;
            string[] names ={ "ID", "Father_ID", "MainWindow", "Type", "Add_Index", "IsContainer", "ConditionType", "VaryName", "Arithmetic", "VaryValue", "Unit", "VaryError", "TimeUnit", 
                "VaryNameLogic", "IsError", "Condition_ID", "KgetN","ItemList" };
            if (str == "")
                return "";
            if ((str == null))
                str = "0$$0$$0$0$0$$$$$0$$$0$0$$";
            string[] values = str.Split(new Char[] { '$' });
            if (values.Length != names.Length)
                return "";
            int i = 0;
            for (i = 0; i < names.Length; i++)
            {
                if (name == names[i])
                    break;
            }
            if (i >= names.Length)
                return "";
            return values[i];
        }


    }
}
