using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using PSOG.Entity;
using PSOG.DAO.impl;
using PSOG.DAO;
using System.Data;
using PSOG.Common;

namespace PSOG.Bizc
{
    /// <summary>
    /// 工艺检测
    /// </summary>
    public class ArtTch
    {
        
        public List<string> DynamicProcess = new List<string>();
        private List<NormalNodeList> m_NormalNodeList = new List<NormalNodeList>();
        private List<NormalNodeList> m_NotNormalNodeList = new List<NormalNodeList>();
        public List<string> equipNameUrlList = new List<string>();//存设备的名字和url
        //private int Project_ID = new INI_IO().ReadID();
        private String Father_id = "-1";

        /// <summary>
        /// 生成json串供前台展示
        /// </summary>
        /// <returns></returns>
        public string produceJson(Plant plant)
        {
            IDao dao = new Dao(plant,false);
            int Project_ID = new INI_IO().ReadID();
            MainPage mainPage = new MainPage();
            DynamicProcess = mainPage.DynamicLoadFuntion( dao); //添加默认装置
            m_NormalNodeList = mainPage.RefrashNodeList(dao);  //获取正常的工艺监测
            m_NotNormalNodeList = mainPage.notNormalNodeList(dao, "工艺");//mainPage.initNotNormalNodeList(dao);

            string jsonData = "";
            List<JasonSeri> js = new List<JasonSeri>();
            for (int pn = DynamicProcess.Count; pn > 0; pn--)
            {
                string processName = DynamicProcess[pn - 1];
                JasonSeri tempjs = new JasonSeri();

                List<excNode> listexc = new List<excNode>();
                string nodestatus = "";
                foreach (NormalNodeList temp in m_NotNormalNodeList)
                {
                    if (temp.Group == processName)
                    {

                        excNode tempNode = new excNode();
                        string FatherID = Father_id;

                        FatherID = FatherID + "_" + temp.ID;
                        int projectid = Project_ID;
                        tempNode.twoID = FatherID + "," + projectid;
                        tempNode.Text = temp.Describe;
                        if ("" == nodestatus || "预警" == nodestatus){
                            nodestatus = temp.nodeState;
                        }
                        listexc.Add(tempNode);

                    }
                }
                tempjs.name = processName;
                if (listexc.Count > 0)
                {
                    tempjs.state = nodestatus;
                    tempjs.exc = listexc;

                    js.Add(tempjs);
                }
                else
                {

                    tempjs.state = "正常";
                    js.Add(tempjs);
                }

            }            

            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            jsonData = jsonSerializer.Serialize(js);
            return jsonData;
        }


        public string unusualNode(String clickProcess, String DBName)
        {
            IDao dao = new Dao(DBName);
            int Project_ID = new INI_IO().ReadID();
            MainPage mainPage = new MainPage();
            m_NotNormalNodeList = mainPage.RefrashNodeList(dao);  //获取正常的工艺监测
            string allNodeString = "";
            if (m_NotNormalNodeList.Count > 0)
            {
                foreach (NormalNodeList temp in m_NotNormalNodeList)
                {
                    if (null != temp.Group && temp.Group.Trim() == clickProcess.Trim())
                    {
                        string FatherID = Father_id;

                        FatherID = FatherID + "_" + temp.ID;
                        int projectid = Project_ID;
                        allNodeString += FatherID + "," + projectid + "," + temp.Describe + ",";
                    }
                }
                if (allNodeString != "")
                {
                    allNodeString = allNodeString.Substring(0, allNodeString.Length - 1);
                }
            }
            return allNodeString;
        }

        /// <summary>
        /// 质量分析查询
        /// </summary>
        /// <param name="page">页号</param>
        /// <param name="rows">行数</param>
        /// <returns></returns>
        public EasyUIData getQualityList(String page, String rows, Plant plant)
        {
            IDao dao = new Dao(plant,false);
            EasyUIData grid = new EasyUIData();
            List<RTResExLimsPoint> limsPoint = new List<RTResExLimsPoint>();
            String sql = "select count(1) over() allrowCount, LimsPoint_MATCODE,LimsPoint_SAMPLEPOINTDESC,LimsPoint_TESTNO,LimsPoint_ANALYLE,LimsPoint_fValue,LimsPoint_UNITS,Status,LimsPoint_High,LimsPoint_Low,Time from RTResEx_LimsPoint  order by status asc , Time desc ";//LimsPoint_PLANT like '%二催化%'
            DataSet ds = dao.executeQuery(sql, Int32.Parse(page), Int32.Parse(rows));
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.DBToInt(ds.Tables[0].Rows[0]["allrowCount"]); //获取总行数
                
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    RTResExLimsPoint point = new RTResExLimsPoint();
                    String value = dr["LimsPoint_fValue"].ToString();
                    point.limsPointMatCode = (string)dr["LimsPoint_MATCODE"];
                    point.limsPointSamplePointDesc = dr["LimsPoint_SAMPLEPOINTDESC"].ToString();
                    point.limsPointTestNo = (string)dr["LimsPoint_TESTNO"];

                    point.limsPointAnalyle = (string)dr["LimsPoint_ANALYLE"];
                    if (value.Length > 4)
                    {
                        value = value.Substring(0, 4);
                    }
                    point.limsPointFValue = value;
                    point.limsPointUnits = (string)dr["LimsPoint_UNITS"];
                    point.status = (string)dr["Status"];
                    point.limsPointHigh = dr["LimsPoint_High"].ToString();
                    point.limsPointLow = dr["LimsPoint_Low"].ToString();
                    point.time = BeanTools.DataTimeToString(dr["Time"]);

                    limsPoint.Add(point);
                }
            }
            grid.rows = limsPoint;
            return grid;
        }

        /// <summary>
        /// 工艺类型查询
        /// </summary>
        /// <param name="PesFileName"></param>
        /// <param name="dao"></param>
        /// <returns></returns>
        public List<Equipment> loadEquipmentFuntion(Plant plant)
        {
            IDao dao = new Dao(plant,false);
            List<Equipment> list = new List<Equipment>();
                        
            String sql = "select * from psog_processmonitorObject t where t.psog_monitorobject_type = '工艺' order by id asc";

            DataSet ds = dao.executeQuery(sql);

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Equipment bo = new Equipment();
                    //bo.id = BeanTools.ObjectToString(dr["id"]);
                    bo.id = BeanTools.ObjectToString(dr["PSOG_MonitorObject_MSPCModelID"]);
                    bo.monitorObject_Name = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Name"]);
                    bo.monitorObject_Type = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Type"]);
                    bo.monitorObject_Source = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Source"]);
                    bo.monitorObject_Status = BeanTools.ObjectToString(dr["MonitorObject_CurrStatus"]);
                    if (CommonStr.monitorObject_Source == bo.monitorObject_Source)  //替换为自己的连接
                    {
                        string[] url = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Url"]).Split('?');
                        String parames = 2 <= url.Length ? url[1] : "";
                        bo.monitorObject_Url = "web_runstate_notiem.aspx?" + parames;
                    }
                    else
                    {
                        bo.monitorObject_Url = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Url"]);
                    }

                    list.Add(bo);
                }
            }
            return list;
        }

        /// <summary>
        /// 获取非正常的异常
        /// </summary>
        /// <param name="clickProcess"></param>
        /// <param name="DBName"></param>
        /// <returns></returns>
        //public string unusualConNode(String clickProcess, String DBName)
        //{
        //    String allNodeString = "";
        //    IDao dao = new Dao(DBName);
        //    String sql = "select '-1_' + convert(varchar(50),nodeid) +  ',' + convert(varchar(32),projectid)+','+nodetext+':' + convert(varchar(32),nodeid) ";
        //   // sql += string.Format("from dbo.RTResEx_ASGraphRealTime t where t.nodefatherText='{0}'", clickProcess);
        //    sql += string.Format("from dbo.RTResEx_ASGraphRealTime t");
        //    DataSet ds = dao.executeQuery(sql);
        //    if (BeanTools.DataSetIsNotNull(ds))
        //    {
        //        foreach (DataRow dr in ds.Tables[0].Rows)
        //        {
        //            allNodeString += dr[0] + ",";
        //        }

        //        if ("" != allNodeString) allNodeString.Substring(0, allNodeString.Length - 1);
        //    }
        //    return allNodeString;
        //}
        public string unusualConNode(String clickProcess, Plant plant)
        {
            String allNodeString = "";
            IDao dao = new Dao(plant,false);
            String sql = "select '-1_' + convert(varchar(50),AS_Equipment_ID) +  ',' + convert(varchar(32),AS_Equipment_State)+','+AS_Equipment_Name+':' + convert(varchar(32),AS_Equipment_ID) ";
            sql += string.Format("from dbo.PSOG_AS_Equipment t where t.AS_Equipment_State='-1' and t.AS_Equipment_Process='{0}'", clickProcess);
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    allNodeString += dr[0] + ",";
                }

                if ("" != allNodeString) allNodeString.Substring(0, allNodeString.Length - 1);
            }
            return allNodeString;
        }
        
    }
}
