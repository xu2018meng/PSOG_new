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

namespace PSOG.Bizc
{
    public class OQIAnalysis
    {
        /// <summary>
        /// ������������
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnalysis_order(String id, String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(DBName);

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_OQITop10 '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_OQITop10");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        int flag = int.Parse(id);
                        for (int di = 0; di < ds.Tables[2 * flag - 2].Rows.Count; di++)
                        {
                            IndexOrder compAnaly = new IndexOrder();
                            compAnaly.name = ds.Tables[2 * flag - 2].Rows[di]["ItemsName"].ToString();
                            compAnaly.value = float.Parse(ds.Tables[2 * flag - 2].Rows[di]["CPKValue"].ToString());
                            list.Add(compAnaly);
                        }
                        IndexOrder compAnaly2 = new IndexOrder();
                        compAnaly2.name = "flag_HI2LO";
                        compAnaly2.value = 0.0f;
                        list.Add(compAnaly2);
                        for (int di = 0; di < ds.Tables[2 * flag - 1].Rows.Count; di++)
                        {
                            IndexOrder compAnaly3 = new IndexOrder();
                            compAnaly3.name = ds.Tables[2 * flag - 1].Rows[di]["ItemsName"].ToString();
                            compAnaly3.value = float.Parse(ds.Tables[2 * flag - 1].Rows[di]["CPKValue"].ToString());
                            list.Add(compAnaly3);
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
        /// �ۺ�����
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnaysisOutline(String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_PlantState '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_PlantState");
                if (ds != null)
                {
                    //int i = ds.Tables.Count;
                    try
                    {
                        string plant = "";
                        //if (DBName == "Soft_Qdrise_PSOG_JJSH_CJYYT")
                        //{
                        //    plant = "����ѹ";
                        //}
                        //if (DBName == "Soft_Qdrise_PSOG_JJSH_CLHCJ")
                        //{
                        //    plant = "�߻��ѻ�";
                        //}
                        //if (DBName == "Soft_Qdrise_PSOG_JJSH_YJHYT")
                        //{
                        //    plant = "�ӳٽ���";
                        //}
                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            OQIOutline compAnaly = new OQIOutline();
                            compAnaly.procName = ds.Tables[0].Rows[i]["����"].ToString();
                            compAnaly.value = float.Parse(ds.Tables[0].Rows[i]["װ��"].ToString());
                            compAnaly.valueFive = float.Parse(ds.Tables[0].Rows[i]["���"].ToString());
                            compAnaly.valueFour = float.Parse(ds.Tables[0].Rows[i]["�İ�"].ToString());
                            compAnaly.valuethree = float.Parse(ds.Tables[0].Rows[i]["����"].ToString());
                            compAnaly.valueTwo = float.Parse(ds.Tables[0].Rows[i]["����"].ToString());
                            compAnaly.valueOne = float.Parse(ds.Tables[0].Rows[i]["һ��"].ToString());
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
        /// ���������ȼ��ֲ�
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnaysisDistributionByPriority(String id, String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(DBName);

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_OQIDistribute '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_OQIDistribute");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        int flag = int.Parse(id);
                        for (int di = 0; di < ds.Tables[flag - 1].Rows.Count; di++)
                        {
                            OQIPriority compAnaly = new OQIPriority();
                            compAnaly.procName = ds.Tables[flag - 1].Rows[di]["DistributeName"].ToString();
                            compAnaly.AAAvalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeAAA"].ToString());
                            compAnaly.AAvalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeAA"].ToString());
                            compAnaly.Avalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeA"].ToString());
                            compAnaly.Bvalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeB"].ToString());
                            compAnaly.Cvalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeC"].ToString());
                            compAnaly.Dvalue = int.Parse(ds.Tables[flag - 1].Rows[di]["GradeD"].ToString());
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
        /// �����ϸ���
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnalysis_passrate(String id, String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(DBName);

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_CountPercent '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_CountPercent");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        int flag = int.Parse(id);
                        for (int di = 0; di < ds.Tables[flag - 1].Rows.Count; di++)
                        {
                            IndexOrder compAnaly = new IndexOrder();
                            compAnaly.name = ds.Tables[flag - 1].Rows[di]["DistributeName"].ToString();
                            compAnaly.value = float.Parse(ds.Tables[flag - 1].Rows[di]["CountPercent"].ToString());
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
        /// �����÷�
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnalysis_score(String id, String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();
            IDao dao = new Dao(DBName);

            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_Score '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_Score");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        int flag = int.Parse(id);
                        for (int di = 0; di < ds.Tables[flag - 1].Rows.Count; di++)
                        {
                            IndexOrder compAnaly = new IndexOrder();
                            compAnaly.name = ds.Tables[flag - 1].Rows[di]["DistributeName"].ToString();
                            compAnaly.value = float.Parse(ds.Tables[flag - 1].Rows[di]["Score"].ToString());
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
        /// �ϸ��ʲ�ѯ����ʱ��
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIDistributionByPassrateTime(String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_CountPercent '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_CountPercent");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //����һ������ж���
                        for (int di = 0; di < ds.Tables[2].Rows.Count; di++)
                        {
                            PassrateDistributionByTime compAnaly = new PassrateDistributionByTime();
                            compAnaly.startTime = ds.Tables[2].Rows[di]["StartTime"].ToString();
                            compAnaly.endTime = ds.Tables[2].Rows[di]["EndTime"].ToString();
                            compAnaly.OQICount = float.Parse(ds.Tables[2].Rows[di]["CountPercent"].ToString());
                            compAnaly.area = ds.Tables[2].Rows[di]["GroupName"].ToString();
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
        /// �÷ֲ�ѯ����ʱ��
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIDistributionByScoreTime(String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_Score '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_Score");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //����һ������ж���
                        for (int di = 0; di < ds.Tables[2].Rows.Count; di++)
                        {
                            PassrateDistributionByTime compAnaly = new PassrateDistributionByTime();
                            compAnaly.startTime = ds.Tables[2].Rows[di]["StartTime"].ToString();
                            compAnaly.endTime = ds.Tables[2].Rows[di]["EndTime"].ToString();
                            compAnaly.OQICount = float.Parse(ds.Tables[2].Rows[di]["Score"].ToString());
                            compAnaly.area = ds.Tables[2].Rows[di]["GroupName"].ToString();
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
        /// �ȼ���ѯ����ʱ��
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIDistributionByPriorityTime(String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_OQIDistribute '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_OQIDistribute");
                if (ds != null)
                {
                    int i = ds.Tables.Count;
                    try
                    {
                        //����һ������ж���
                        for (int di = 0; di < ds.Tables[3].Rows.Count; di++)
                        {
                            PassrateDistributionByTime compAnaly = new PassrateDistributionByTime();
                            compAnaly.startTime = ds.Tables[3].Rows[di]["StartTime"].ToString();
                            compAnaly.endTime = ds.Tables[3].Rows[di]["EndTime"].ToString();
                            compAnaly.OQICount = float.Parse(ds.Tables[3].Rows[di]["D"].ToString());
                            compAnaly.area = ds.Tables[3].Rows[di]["DistributeName"].ToString();
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
        /// �ۺ�����,��ҳ��ʾ
        /// </summary>
        /// <param name="starttime"></param>
        /// <param name="endtime"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        public IList OQIAnaysisMainPage(String starttime, String endtime, String DBName)
        {
            IList list = new ArrayList();

            IDao dao = new Dao(DBName);


            if (null != starttime && null != endtime)
            {
                string strSQL;
                strSQL = "exec procOperateQualitySearch_PlantStateDetail '" + starttime + "','" + endtime + "',0";
                DataSet ds = dao.executeProcDS(strSQL, "procOperateQualitySearch_PlantState");
                if (ds != null)
                {
                    //int i = ds.Tables.Count;
                    try
                    {
                        string plant = "";
                        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        {
                            OQIMainPage compAnaly = new OQIMainPage();
                            compAnaly.area = ds.Tables[0].Rows[i]["PlantName"].ToString();
                            compAnaly.allPercent = float.Parse(ds.Tables[0].Rows[i]["ALLPercent"].ToString());
                            compAnaly.countPercent = float.Parse(ds.Tables[0].Rows[i]["CountPercent"].ToString());
                            compAnaly.CPKPercent = float.Parse(ds.Tables[0].Rows[i]["CPKPercent"].ToString());
                            compAnaly.score = float.Parse(ds.Tables[0].Rows[i]["Score"].ToString());
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
    }
}
