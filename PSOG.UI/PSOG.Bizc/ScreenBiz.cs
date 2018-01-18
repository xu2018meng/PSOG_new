using System;
using System.Collections.Generic;
using System.Text;
using PSOG.DAO;
using PSOG.DAO.impl;
using System.Data;
using PSOG.Common;
using PSOG.Entity;

namespace PSOG.Bizc
{
    /// <summary>
    /// 大屏投放
    /// </summary>
    public class ScreenBiz
    {
        /// <summary>
        /// 获取工段名跟工段报警数

        /// </summary>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public string qryMonitorJson(List<Plant> plants)
        {
            String monitorJson = "[";
            if (null != plants && 1 <= plants.Count)
            {
                foreach (Plant plant in plants)
                {
                    String monitorStr = "";
                    monitorJson += "{'plantId':'" + plant.id + "','plantName':'" + plant.organtreeName + "','monitorList':[";

                    String sql = "with tt as (select max(g.Time) recordtime from RTResEx_FDPCA g) ";

                    sql += "select m.PSOG_MonitorObject_Name,isnull(alarmNum,0) alarmNum,isnull(FDPCA_T2RealValue,0) FDPCA_T2RealValue from ( ";
                    sql += "select sum(case when FDPCA_TagDCSAlarmFlag <> 0 and FDPCA_TagDCSAlarmFlag is not null then  1 else 0 end) alarmNum, ";
                    sql += "ModelID,ModelName, max(FDPCA_T2RealValue) FDPCA_T2RealValue ";
                    sql += "from RTResEx_FDPCA t,tt ";
                    sql += "where t.Time = tt.recordtime ";
                    sql += "group by ModelID,ModelName ) alarm right join  PSOG_ProcessMonitorObject m ";
                    sql += "on m.PSOG_MonitorObject_Name = ModelName ";

                    IDao dao = new Dao(plant,true);

                    DataSet ds = dao.executeQuery(sql);
                    if (BeanTools.DataSetIsNotNull(ds))
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            String monitorName = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Name"]);
                            String alarmNum = BeanTools.ObjectToString(dr["alarmNum"]);
                            double realValue = Convert.ToDouble(BeanTools.ObjectToString(dr["FDPCA_T2RealValue"]));
                            monitorStr += "{'monitorName':'" + monitorName + "','alarmNum':'" + alarmNum + "','realValue':" + realValue + "},";
                        }
                    }
                    monitorStr = "" == monitorStr ? "" : monitorStr.Substring(0, monitorStr.Length - 1)+"]},";    //去除最后的，

                    monitorJson += monitorStr;
                }
                if (monitorJson.EndsWith(","))
                    monitorJson = monitorJson.Substring(0, monitorJson.Length - 1);
                monitorJson += "]";
            }
            return monitorJson;
        }
    }
}
