using System;
using System.Collections.Generic;
using System.Text;
using PSOG.DAO.impl;
using PSOG.DAO;
using PSOG.Entity;
using PSOG.Common;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Xml;
using System.Collections;

namespace PSOG.Bizc
{
    public class MainPage
    {
        
        public List<string> DynamicProcess = new List<string>();
        private List<NormalNodeList> m_NormalNodeList = new List<NormalNodeList>();
        private List<NormalNodeList> m_NotNormalNodeList = new List<NormalNodeList>();
        List<string> M_NotNormalEquip = new List<string>();
        public List<string> equipinfoList = new List<string>();//仅仅存设备烟机的名字
        public List<string> equipNameUrlList = new List<string>();//存设备的名字和url
        public List<string> EquipmentNotProcess = new List<string>();
        

        public String getPageJson(Plant plant)
        {
            IDao dao = new Dao(plant,false);

            DynamicLoadFuntion(dao); //添加默认装置
            RefrashNodeList(dao);  //获取正常的工艺监测
            initNotNormalNodeList(dao); //初始异常节点

            //HomeFourfunction hFf = new HomeFourfunction();
            //hFf.name = "工艺";
            //List<homeNode> allhomeNode = getPlantItem(dao, "工艺");
            string jsonData = "";
            //for (int pn = DynamicProcess.Count; pn > 0; pn--)
            //{
            //    // int icount = 0;
            //    string processName = DynamicProcess[pn - 1];
            //    homeNode hn = new homeNode();
            //    hn.name = processName;
            //    foreach (NormalNodeList temp in m_NotNormalNodeList)
            //    {

            //        if (temp.Group == processName)
            //        {
            //            hn.state = "异常";
            //            allhomeNode.Add(hn);
            //            break;
            //        }
            //    }
            //    if (hn.state == null || hn.state == "")
            //    {
            //        hn.state = "正常";
            //        allhomeNode.Add(hn);
            //    }

            //}
            //hFf.content = allhomeNode;
            // homeAlldata.artData = hFf;

            //设备
            //HomeFourfunction equip = GetEquipmentinfo(dao);
            //质量分析数据
            qualityList Qll = GetQualityData(dao);
            //报警分析数据
            AlarmList alarmfx = GetAlarmData(dao);
            //异常工况数据
            ASList asfx = GetASData(dao);
            // homeAlldata.watchData=watch;
            //json序列化所有信息
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            //jsonData = jsonSerializer.Serialize(hFf) + "," + jsonSerializer.Serialize(equip) + "," + jsonSerializer.Serialize(alarmfx) + "," + jsonSerializer.Serialize(Qll);
            jsonData = jsonSerializer.Serialize(alarmfx) + "," + jsonSerializer.Serialize(asfx);
            return jsonData;

        }

        public List<NormalNodeList> initNotNormalNodeList(IDao dao)
        {
            
            String sql = "select * from RTResEx_ASGraphRealTime t ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String group = BeanTools.ObjectToString(dr["NodeFatherText"]);
                    if (null != group && "" != group)
                    {
                        NormalNodeList nodeList = new NormalNodeList();
                        nodeList.Group = group;
                        nodeList.Describe = (BeanTools.ObjectToString(dr["nodeText"]));
                        nodeList.ID = BeanTools.ObjectToInt(dr["id"]);
                        m_NotNormalNodeList.Add(nodeList);
                    }
                }
            }
            return m_NotNormalNodeList;
        }

        public List<String> DynamicLoadFuntion(IDao dao)
        {
            DynamicProcess.Clear(); //清空
            //string condition = String.Format("AS_Equipment_FileName='{0}'", PesFileName);//判断打开的文件所对应的装置是否在数据库中 //
            String sql = "select * from psog_processmonitorObject t where t.psog_monitorobject_type = '工艺' order by id desc ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DynamicProcess.Add((string)dr["psog_monitorobject_name"]);
                }
            }
            return DynamicProcess;
        }

        /// <summary>
        /// 获取正常的工艺监测
        /// </summary>
        public List<NormalNodeList> RefrashNodeList(IDao dao)
        {
            m_NormalNodeList.Clear(); //清空
            String sql = "select * from RTResEx_ASGraphHomeNode  order by NodeIndex ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    NormalNodeList tempNormalNodeList = new NormalNodeList();
                    tempNormalNodeList.ID = (int)dr["NodeID"];
                    tempNormalNodeList.Index = float.Parse(dr["NodeIndex"].ToString());
                    tempNormalNodeList.Describe = dr["NodeText"].ToString();
                    m_NormalNodeList.Add(tempNormalNodeList);
                }
            }
            return m_NormalNodeList;
        }

        private HomeFourfunction GetEquipmentinfo(IDao dao)
        {
            HomeFourfunction hFf = new HomeFourfunction();
            hFf.name = "设备";
            List<homeNode> allhomeNode = new List<homeNode>();

            String sql = "select * from psog_processmonitorObject t where t.psog_monitorobject_type = '设备' order by id desc ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    homeNode hn = new homeNode();
                    hn.name = (string)dr["psog_monitorobject_name"];
                    int state = (int)dr["MonitorObject_CurrStatus"];
                    if (1 == state)
                    {
                        hn.state = "正常";
                    }
                    else
                    {
                        hn.state = "异常";
                    }
                    allhomeNode.Add(hn);
                }
            }

            hFf.content = allhomeNode;
            return hFf;
        }

        public void GetEquipment(IDao dao)
        {
            try
            {
                List<string> equipListSort = new List<string>();//设备逆序排列
                equipinfoList.Clear();
                equipNameUrlList.Clear();
                EquipmentNotProcess.Clear();
                DateTime time = DateTime.Now;
                string time1 = time.ToString("yyyy-MM-dd HH:mm:ss");
                string time2 = time.AddMinutes(-2).ToString("yyyy-MM-dd HH:mm:ss");
                IEMWebReference.IEMWebService webSerive = new IEMWebReference.IEMWebService();
                //string result = webSerive.CreateModelTree("iEMAdmin", "inside", string.Format("设备状态.{0}",zzName));
                string result = webSerive.CreateModelTree("iEMAdmin", "inside", "设备状态.燕化炼油二厂二催化");

                bool IsEquipment = true;
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(result);
               
                XmlNamespaceManager nsMgr = new XmlNamespaceManager(xmlDoc.NameTable);
                nsMgr.AddNamespace("ns", "http://www.crtsoft.com");
                XmlNode nodeList = xmlDoc.SelectSingleNode("/ArrayOfTreeNodes/TreeNodes/childnodes");
                foreach (XmlNode node in nodeList.ChildNodes)
                {
                    string EquipNameUrl = "";
                    int count = 0;
                    foreach (string temp in DynamicProcess)
                    {
                        if (node.SelectSingleNode("Text").InnerText.Contains(temp))
                        {

                            IsEquipment = false;
                        }
                    }
                    if (IsEquipment)
                    {
                        EquipNameUrl = node.SelectSingleNode("Text").InnerText + "$" + node.SelectSingleNode("Url").InnerText;
                        // temp.url = node.SelectSingleNode("Url").InnerText;
                        equipNameUrlList.Add(EquipNameUrl);
                        equipListSort.Add(node.SelectSingleNode("Text").InnerText);
                        EquipmentNotProcess.Add(EquipNameUrl);
                    }
                    if (IsEquipment == false)
                    {
                        EquipNameUrl = node.SelectSingleNode("Text").InnerText + "$" + node.SelectSingleNode("Url").InnerText;
                        equipNameUrlList.Add(EquipNameUrl);
                    }
                    IsEquipment = false;
                    //XmlNode tempnode= node.SelectSingleNode("Text");
                }
                for (int pn = equipListSort.Count; pn > 0; pn--)
                {
                    string sortstring = equipListSort[pn - 1];
                    equipinfoList.Add(sortstring);
                }
            }
            catch
            {
                ; //MessageBox.Show("未连接服务器");
            }
        }

        private qualityList GetQualityData(IDao  dao)
        {
            qualityList hFf = new qualityList();
            hFf.name = "质量分析";
            String sql = "select LimsPoint_MATCODE,LimsPoint_SAMPLEPOINTDESC,LimsPoint_ANALYLE,LimsPoint_fValue,LimsPoint_UNITS,Status,LimsPoint_High,LimsPoint_Low,convert(varchar(19),Time,120) time from RTResEx_LimsPoint  order by Status asc, Time desc ";// where LimsPoint_PLANT like '%二催化%'
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<qualityInfo> allhomeAlarmNode = new List<qualityInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {                    
                    qualityInfo hn = new qualityInfo();
                    if (recordnum == 4) { break; }
                    hn.num = recordnum.ToString();
                    hn.modelName = (string)dr["LimsPoint_MATCODE"];//样品名称
                    hn.Cjname = dr["LimsPoint_SAMPLEPOINTDESC"].ToString();//采样名称
                    hn.projectName = (string)dr["LimsPoint_ANALYLE"];//分析项目
                    hn.value = dr["LimsPoint_fValue"].ToString();//值
                    hn.units = (string)dr["LimsPoint_UNITS"];//单位
                    hn.status = (string)dr["Status"];//状态
                    hn.high = dr["LimsPoint_High"].ToString();//高报
                    hn.low = dr["LimsPoint_Low"].ToString();//低报
                    hn.time = dr["Time"].ToString();//时间
                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                hFf.content = allhomeAlarmNode;
            }           
            return hFf;
        }

        /// <summary>
        /// 报警分析数据
        /// </summary>
        /// <returns></returns>
        private AlarmList GetAlarmData(IDao dao)
        {
            AlarmList hFf = new AlarmList();
            hFf.name = "报警";
            String sql = "select RTResEx_AlarmRealTime_Items,RTResEx_AlarmRealTime_Value,RTResEx_AlarmRealTime_State,convert(varchar(19),RTResEx_AlarmRealTime_StartTime,120) RTResEx_AlarmRealTime_StartTime from RTResEx_AlarmRealTime order by RTResEx_AlarmRealTime_State desc ";
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<AlarmInfo> allhomeAlarmNode = new List<AlarmInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmInfo hn = new AlarmInfo();

                    hn.num = recordnum.ToString();
                    hn.item = (string)dr["RTResEx_AlarmRealTime_Items"];
                    string value = dr["RTResEx_AlarmRealTime_Value"].ToString();
                    if (value.Length > 5)
                    {
                        hn.value = value.Substring(0, 5);
                    }
                    else
                    {
                        hn.value = value;
                    }
                    if (System.DBNull.Value == dr["RTResEx_AlarmRealTime_State"])
                        hn.state = "";
                    else
                        hn.state = (string)dr["RTResEx_AlarmRealTime_State"];
                    hn.startTime = dr["RTResEx_AlarmRealTime_StartTime"].ToString();

                    DateTime sDate = Convert.ToDateTime(hn.startTime);
                    DateTime nowDate = Convert.ToDateTime(DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"));
                    TimeSpan ts = nowDate - sDate;
                    hn.continuTime = "" +  Math.Floor(ts.TotalMinutes);


                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                hFf.content = allhomeAlarmNode;
            }
            return hFf;
        }

        /// <summary>
        /// 异常工况数据
        /// </summary>
        /// <returns></returns>
        private ASList GetASData(IDao dao)
        {
            ASList hFf = new ASList();
            hFf.name = "异常工况";
            String sql = "exec procProcessMonitorState";
            //DataSet ds = dao.executeQuery(sql);
            DataSet ds = dao.executeProcDS(sql, "procAlarmZHHisSearch_Grade");
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<ASInfo> allhomeAlarmNode = new List<ASInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ASInfo hn = new ASInfo();

                    hn.id = recordnum.ToString();
                    hn.ASName = dr["ModelName"].ToString();
                    hn.status = dr["ModelState"].ToString();
                    hn.duration = dr["ModelContinueTime"].ToString();
                    hn.corrInstru = dr["ModelItems"].ToString();
                    hn.startT = dr["ModelStartTime"].ToString();
                    hn.unit = dr["ModelProcess"].ToString();
                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                hFf.content = allhomeAlarmNode;
            }
            return hFf;
        }

        /// <summary>
        /// 获取装置列表
        /// </summary>
        /// <returns></returns>
        public IList qryPlantList()
        {
            IDao dao = new Dao();
            IList list = new ArrayList();
            StringBuilder sql = new StringBuilder();

            sql.Append("with tt as( select 'div_s'+p.organtree_code organtree_code,'div_p'+p.organtree_code OrganTree_ParentCode, ");
            sql.Append("p.organtree_name ,p.showOrder,'' id,1 level,'' PlantInfo_ResExDB_Name,'' ");
            sql.Append("PlantInfo_BaseDB_Name ");
            sql.Append("from PSOGSYS_OrganTree p ");
            sql.Append("where p.OrganTree_ParentCode = '9999' ");
            sql.Append("union select'div_s'+p.organtree_code sheetid, ");
            sql.Append("'div_p'+p.OrganTree_ParentCode, p.organtree_name,p.showOrder ,z.PlantInfo_PlantCode,2 level,z.PlantInfo_ResExDB_Name, ");
            sql.Append("z.PlantInfo_BaseDB_Name  ");
            sql.Append("from PSOGSYS_OrganTree p  ");
            sql.Append("left join PSOGSYS_PlantInfo z on p.organtree_code = convert(varchar(36),z.PlantInfo_PlantCode) ");
            sql.Append("where p.OrganTree_ParentCode <> '9999' ");
            sql.Append(") ");
            sql.Append("select * from tt  order by  tt.OrganTree_ParentCode,tt.level, tt.showorder ");

            DataSet ds = dao.executeQuery(sql.ToString());

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {    
                    Plant plant = new Plant();
                    plant.id = BeanTools.ObjectToString(dr["id"]);
                    plant.organtreeName = BeanTools.ObjectToString(dr["organtree_name"]);
                    plant.level = BeanTools.ObjectToString(dr["level"]);
                    plant.realTimeDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_Name"]));
                    plant.historyDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_Name"]));
                    plant.organtreeParentCode = BeanTools.ObjectToString(dr["OrganTree_ParentCode"]);
                    plant.organtreeCode = BeanTools.ObjectToString(dr["organtree_code"]);

                    list.Add(plant);
                }
            }


            return list;
        }

        /// <summary>
        /// 获取装置列表
        /// </summary>
        /// <returns></returns>
        public IList qryPlantList(string plantIds)
        {
            IDao dao = new Dao();
            IList list = new ArrayList();
            StringBuilder sql = new StringBuilder();
            //sql.Append("with tt as( ");
            //sql.Append("select 'div_s'+p.sheetid sheetid,'div_p'+p.sheetid parentid, p.name,p.showOrder,'' id,1 level,'' DataBaseName_RTResEx,'' DataBaseName_Soft_Qdrise ");
            //sql.Append("from psog_organ_plant p  ");
            //sql.Append("where p.parentid = '9999' ");
            //sql.Append("union ");
            //sql.Append("select'div_s'+p.sheetid sheetid, 'div_p'+p.parentid, p.name,p.showOrder ,z.id,2 level,z.DataBaseName_RTResEx,z.DataBaseName_Soft_Qdrise ");
            //sql.Append("from psog_organ_plant p left join zzinformation z on p.sheetid = convert(varchar(36),z.id) ");
            //sql.Append("where p.parentid <> '9999') ");

            //sql.Append(",t as ( ");
            //sql.Append("select * from tt ");
            //sql.AppendFormat("where convert(varchar(50),tt.id)  in ('{0}') or tt.level=1 ) ", plantIds.Replace(",", "','"));

            //sql.Append("select * from t ");
            //sql.Append("where 2 <= (select count(1) from t g where g.parentid = t.parentid) ");
            sql.Append("with tt as( select 'div_s'+p.organtree_code organtree_code,'div_p'+p.organtree_code OrganTree_ParentCode, ");
            sql.Append("p.organtree_name ,p.showOrder,'' id,1 level,'' PlantInfo_ResExDB_Name,'' ");
            sql.Append("PlantInfo_BaseDB_Name ");
            sql.Append("from PSOGSYS_OrganTree p ");
            sql.Append("where p.OrganTree_ParentCode = '9999' ");
            sql.Append("union select'div_s'+p.organtree_code sheetid, ");
            sql.Append("'div_p'+p.OrganTree_ParentCode, p.organtree_name,p.showOrder ,z.PlantInfo_PlantCode,2 level,z.PlantInfo_ResExDB_Name, ");
            sql.Append("z.PlantInfo_BaseDB_Name  ");
            sql.Append("from PSOGSYS_OrganTree p  ");
            sql.Append("left join PSOGSYS_PlantInfo z on p.organtree_code = convert(varchar(36),z.PlantInfo_PlantCode) ");
            sql.Append("where p.OrganTree_ParentCode <> '9999' ");
            sql.Append(") , ");
            sql.Append("t as ( select * from tt ");
            sql.AppendFormat("where convert(varchar(50),tt.id)  in ('{0}') or tt.level=1 ) ", plantIds.Replace(",", "','"));
            sql.Append("select * from t where 2 <= (select count(1) from t g ");
            sql.Append("where g.OrganTree_ParentCode = t.OrganTree_ParentCode) order by  t.OrganTree_ParentCode,t.level, t.showorder ");


            DataSet ds = dao.executeQuery(sql.ToString());

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Plant plant = new Plant();
                    plant.id = BeanTools.ObjectToString(dr["id"]);
                    plant.organtreeName = BeanTools.ObjectToString(dr["organtree_name"]);
                    plant.level = BeanTools.ObjectToString(dr["level"]);
                    plant.realTimeDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_Name"]));
                    plant.historyDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_Name"]));
                    plant.organtreeParentCode = BeanTools.ObjectToString(dr["OrganTree_ParentCode"]);
                    plant.organtreeCode = BeanTools.ObjectToString(dr["organtree_code"]);

                    list.Add(plant);
                }
            }


            return list;
        }

        /// <summary>
        /// 可见装置首页
        /// </summary>
        /// <param name="PesFileName"></param>
        /// <param name="dao"></param>
        /// <returns></returns>
        public List<Plant> loadPlantsInfo(string plantIds)
        {
            IDao dao = new Dao();
            List<Plant> list = new List<Plant>();

            String sql = string.Format("select * from PSOGSYS_PlantInfo t where PlantInfo_PlantCode in ('{0}') and isuse = '1' order by showorder asc", plantIds.Replace(",", "','"));

            DataSet ds = dao.executeQuery(sql);

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Plant bo = new Plant();
                    bo.id = BeanTools.ObjectToString(dr["PlantInfo_PlantCode"]);
                    bo.organtreeName = BeanTools.ObjectToString(dr["PlantInfo_PlantName"]);
                    bo.realTimeDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_Name"]));
                    bo.historyDB = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_Name"]));
                    bo.realTimeDBIP = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_IP"]));
                    bo.realTimeDBPort = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_PORT"]));
                    bo.realTimeDBUser = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_UID"]));
                    bo.realTimeDBPass = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_ResExDB_PWD"]));

                    bo.historyDBIP = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_IP"]));
                    bo.historyDBPort = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_PORT"]));
                    bo.historyDBUser = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_UID"]));
                    bo.historyDBPass = BeanTools.EncodeBase64(BeanTools.ObjectToString(dr["PlantInfo_BaseDB_PWD"]));
                    list.Add(bo);
                }
            }
            return list;
        }

        /// <summary>
        /// 可见装置首页
        /// </summary>
        /// <param name="PesFileName"></param>
        /// <param name="dao"></param>
        /// <returns></returns>
        public Dictionary<string, Plant> loadPlantList()
        {
            IDao dao = new Dao();
            Dictionary<string, Plant> dic = new Dictionary<string, Plant>();

            String sql = "select * from PSOGSYS_PlantInfo t where isuse = '1' order by id asc";

            DataSet ds = dao.executeQuery(sql);

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Plant bo = new Plant();
                    string plantId = BeanTools.ObjectToString(dr["PlantInfo_PlantCode"]);
                    bo.id = plantId;
                    bo.organtreeName = BeanTools.ObjectToString(dr["PlantInfo_PlantName"]);
                    bo.realTimeDB = BeanTools.ObjectToString(dr["PlantInfo_ResExDB_Name"]);
                    bo.historyDB = BeanTools.ObjectToString(dr["PlantInfo_BaseDB_Name"]);
                    bo.realTimeDBIP = BeanTools.ObjectToString(dr["PlantInfo_ResExDB_IP"]);
                    bo.realTimeDBPort = BeanTools.ObjectToString(dr["PlantInfo_ResExDB_PORT"]);
                    bo.realTimeDBUser = BeanTools.ObjectToString(dr["PlantInfo_ResExDB_UID"]);
                    bo.realTimeDBPass =BeanTools.ObjectToString(dr["PlantInfo_ResExDB_PWD"]);

                    bo.historyDBIP = BeanTools.ObjectToString(dr["PlantInfo_BaseDB_IP"]);
                    bo.historyDBPort = BeanTools.ObjectToString(dr["PlantInfo_BaseDB_PORT"]);
                    bo.historyDBUser = BeanTools.ObjectToString(dr["PlantInfo_BaseDB_UID"]);
                    bo.historyDBPass = BeanTools.ObjectToString(dr["PlantInfo_BaseDB_PWD"]);
                    dic.Add(bo.id, bo);
                }
            }
            return dic;
        }

        /// <summary>
        /// 可见装置首页
        /// </summary>
        /// <param name="PesFileName"></param>
        /// <param name="dao"></param>
        /// <returns></returns>
        public string loginValidate(SysUser user)
        {
            String message = "false";

            string userName = user.userLoginName;
            string password = user.userPassword;
            string remoteAddr = user.userIp;

            if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
            {
                return message;
            }

            IDao dao = new Dao();

            String sql = string.Format("select id,sys_user_password,sys_user_name,SYS_USER_IP,SYS_USER_ORGAN_ID,SYS_USER_DEPT_ID from psogsys_permissionuser where sys_user_login_name = '{0}' and SYS_USER_IS_USE ='1'", userName);

            DataSet ds = dao.executeQuery(sql);

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string DBPassword = BeanTools.ObjectToString(dr["sys_user_password"]);

                    user.userName = BeanTools.ObjectToString(dr["sys_user_name"]);
                    user.userIp = BeanTools.ObjectToString(dr["SYS_USER_IP"]);
                    user.userOrganId = BeanTools.ObjectToString(dr["SYS_USER_ORGAN_ID"]);
                    user.userDeptId = BeanTools.ObjectToString(dr["SYS_USER_DEPT_ID"]);
                    user.userId = BeanTools.ObjectToString(dr["id"]);

                    if (password == DBPassword)
                    {
                        message = "true";
                        saveRemoteAddr(userName, remoteAddr);
                    }
                }
            }
            return message;
        }

        /// <summary>
        /// 将ip附到本用户上
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="remoteAddr"></param>
        /// <returns></returns>
        private bool saveRemoteAddr(string userName, string remoteAddr)
        {
            bool message = false;

            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userName))
            {                
                IList sqlList = new ArrayList();

                //将对应本ip的用户清空
                String sql1 = string.Format("update psogsys_permissionuser set SYS_USER_IP = '' where SYS_USER_IP ='{0}'", remoteAddr);
                sqlList.Add(sql1);

                //将本ip映射到当前用户
                string sql2 = string.Format("update psogsys_permissionuser set SYS_USER_IP = '{0}' where sys_user_login_name ='{1}'", remoteAddr, userName);
                sqlList.Add(sql2);

                dao.executeNoQuery(sqlList);

                message = true;

            }

            return message;
        }

        /// <summary>
        /// 获取装置可以展示的功能项
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public string showPlantItem(string plantId)
        {
            IDao dao = new Dao();
            string tableHtml = "";
            if (null != plantId)
            {
                string sql = "select i.plantInfo_notdisplayitem ";
                sql += "from dbo.PSOGSYS_PlantInfo i ";
                sql += string.Format("where i.plantinfo_plantCode = '{0}' ", plantId);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    string itemNos = BeanTools.ObjectToString(ds.Tables[0].Rows[0][0]);
                    if (!string.IsNullOrEmpty(itemNos))
                    {
                        tableHtml = "<tr>";
                        String tableHtml2 = "<tr>";
                        string[] items = itemNos.Split('$');
                        int i = 1;
                        int j = 1;
                        float width = 100 / items.Length; //列宽
                        foreach (string item in items)
                        {
                            try
                            {
                                int itemNo = Int32.Parse(item); //展示记录号 详见CommonStr.plantItemUri CommonStr.plantItem
                                tableHtml += "<td style='width:" + width + "%; height:100%;'><a id='a" + (i++) + "' class='psog_function' href='javascript:void(0)' url='" + CommonStr.plantItemUri[itemNo] + "' onclick='function_click(this)'>" + CommonStr.plantItem[itemNo] + "</a></td>";
                                tableHtml2 += "<td style='width:" + width + "%; height:100%;'><a id='b" + (j++) + "' class='psog_function' href='javascript:void(0)' url='" + CommonStr.plantItemUri[itemNo] + "' onclick='function_click(this)'>" + CommonStr.plantItem[itemNo] + "</a></td>";
                            }
                            catch (Exception exp)
                            {
                            }
                        }
                        tableHtml += "</tr>";
                        tableHtml2 += "</tr>";
                        tableHtml += "*" + tableHtml2;
                    }
                }
            }
            return tableHtml;
        }

        /// <summary>
        /// 获取装置可以展示的功能项
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public string showPlantItem(string plantId, String userId)
        {
            IDao dao = new Dao();
            string tableHtml = "";
            if (null != userId)
            {                
                string sql = "  ";
                sql += "with tt as( ";
                sql += "select distinct m.sys_menu_code, m.sys_menu_p_code ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur, ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' ", userId);
                sql += ") ";
                sql += "select t.*  ";
                sql += "from psogsys_permissionmenu t,( ";
                sql += "select tt.sys_menu_code ";
                sql += "from tt  ";
                sql += "where sys_menu_p_code = 'root' ";
                sql += "union ";
                sql += "select (select top 1 m1.sys_menu_code  ";
                sql += "from psogsys_permissionmenu m1 where m1.sys_menu_code = tt.sys_menu_p_code) ";
                sql += "from tt  ";
                sql += "where  sys_menu_p_code <> 'root' and sys_menu_p_code <> 'plant') g ";
                sql += "where t.sys_menu_code =g.sys_menu_code and t.SYS_MENU_P_CODE='ROOT' ORDER BY t.SYS_MENU_INDEX ";
                //sql += "where t.sys_menu_code =g.sys_menu_code ";

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    
                    tableHtml = "<tr>";
                    String tableHtml2 = "<tr>";
                    int i = 1;
                    int j = 1;
                    float width = 100 / ds.Tables[0].Rows.Count; //列宽
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        try
                        {
                            string menuUrl = BeanTools.ObjectToString(dr["Sys_menu_url"]);
                            string menuName = BeanTools.ObjectToString(dr["sys_menu_name"]);
                            string menuCode = BeanTools.ObjectToString(dr["sys_menu_code"]);
                            tableHtml += "<td style='width:" + width + "%; height:100%;'><a id='a" + (i++) + "' menuCode='" + menuCode + "' class='psog_function' href='javascript:void(0)' url='" + menuUrl + "' onclick='function_click(this)'>" + menuName + "</a></td>";
                            tableHtml2 += "<td style='width:" + width + "%; height:100%;'><a id='b" + (j++) + "'  menuCode='" + menuCode + "' class='psog_function' href='javascript:void(0)' url='" + menuUrl + "' onclick='function_click(this)'>" + menuName + "</a></td>";
                        }
                        catch (Exception exp)
                        {
                        }
                    }
                    tableHtml += "</tr>";
                    tableHtml2 += "</tr>";
                    tableHtml += "*" + tableHtml2;
                }
            }
            return tableHtml;
        }

        public string getPlantItem(string plantId)
        {
            IDao dao = new Dao();
            string functionNos = "";
            if (null != plantId)
            {
                string sql = "select i.plantInfo_notdisplayitem ";
                sql += "from dbo.PSOGSYS_PlantInfo i ";
                sql += string.Format("where i.plantinfo_plantCode = '{0}' ", plantId);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    functionNos = BeanTools.ObjectToString(ds.Tables[0].Rows[0][0]);
                }
            }
            return functionNos;
        }

        /// <summary>
        /// 获取异常或正常点
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<homeNode> getPlantItem(IDao dao, string monitorType)
        {
            List<homeNode> allhomeNode = new List<homeNode>();
            if (null != dao)
            {
                string sql = "select PSOG_MonitorObject_Name, MonitorObject_CurrStatus ";
                sql += "from PSOG_ProcessMonitorObject ";
                sql += string.Format("where PSOG_MonitorObject_Type = '{0}' order by id asc ", monitorType);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        homeNode node = new homeNode();
                        node.name = BeanTools.ObjectToString(dr[0]);
                        node.state = -1 == BeanTools.ObjectToInt(dr[1]) ? "异常" : (0 == BeanTools.ObjectToInt(dr[1]) ? "预警" : "正常");
                        allhomeNode.Add(node);
                    }
                    
                }
            }
            return allhomeNode;
        }

        public List<NormalNodeList> notNormalNodeList(IDao dao, String monitorType)
        {

            string sql = "select PSOG_MonitorObject_Name, MonitorObject_CurrStatus ";
            sql += "from PSOG_ProcessMonitorObject ";
            sql += string.Format("where PSOG_MonitorObject_Type = '{0}' and MonitorObject_CurrStatus <> '1' order by id asc ", monitorType);
            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String group = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Name"]);
                    String currStatus = BeanTools.ObjectToString(dr["MonitorObject_CurrStatus"]);
                    if (null != group && "" != group)
                    {
                        NormalNodeList nodeList = new NormalNodeList();
                        nodeList.Group = group;
                        nodeList.Describe = "";
                        m_NotNormalNodeList.Add(nodeList);
                        if ("0" == currStatus)
                        {
                            nodeList.nodeState = "预警";
                        }
                        else
                        {
                            nodeList.nodeState = "异常";
                        }
                    }
                }
            }
            return m_NotNormalNodeList;
        }

        public string qryUrlOfKnowledge()
        {
            string url = "";
            INI_IO iniIO = new INI_IO();

            try
            {
                iniIO.IniFiles(CommonStr.physicalPath + "\\sys_setting.ini");
                url = iniIO.ReadString("Section", "URL_knowledge","");
            }
            catch (Exception exp)
            {
            }
            return url;
        }

        /// <summary>
        /// 新主页加载数据
        /// </summary>
        /// <param name="plant"></param>
        /// <returns></returns>
        public String getNewPageJson(Plant plant)
        {
            IDao dao = new Dao(plant, false);
            string jsonData = "";
           
            //报警监测数据
            HomeAlarmList alarmList = getHomeAlarmInfo(dao);
            //预警监测数据
            HomeEarlyAlarmList earlyAlarmList = getHomeEarlyAlarmInfo(dao);
            //异常监测数据
            HomeAbStateList abStateList = getHomeAbStateInfo(dao);
            //json序列化所有信息
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            jsonData = jsonSerializer.Serialize(alarmList) + "," + jsonSerializer.Serialize(earlyAlarmList)
                     + "," + jsonSerializer.Serialize(abStateList);
            return jsonData;

        }

        /// <summary>
        /// 主页获取报警监测信息
        /// </summary>
        /// <returns></returns>
        public HomeAlarmList getHomeAlarmInfo(IDao dao)
        {
            HomeAlarmList alarmList = new HomeAlarmList();
            alarmList.name = "报警监测";

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT tt.*, r.RTData_fRTVal");
            sql.Append(" FROM ");
            sql.Append("	(");
            sql.Append("		SELECT");
            sql.Append("			t.ID,");
            sql.Append("			t.AbnormalRealTime_TagID,");
            sql.Append("			t.AbnormalRealTime_TagName,");
            sql.Append("			t.AbnormalRealTime_Desc,");
            sql.Append("			t.AbnormalRealTime_State,");
            sql.Append("			t.AbnormalRealTime_Type,");
            sql.Append("			t.AbnormalRealTime_StartTime,");
            sql.Append("			t.AbnormalRealTime_SustainTime,");
            sql.Append("			'1' AS num");
            sql.Append("		FROM");
            sql.Append("			RTResEx_AbnormalRealTime t");
            sql.Append("		WHERE");
            sql.Append("			t.AbnormalRealTime_State <> '正常'");
            sql.Append("		AND t.AbnormalRealTime_State <> '规则异常'");
            sql.Append("		UNION ALL");
            sql.Append("			SELECT");
            sql.Append("				t.ID,");
            sql.Append("				t.AbnormalRealTime_TagID,");
            sql.Append("				t.AbnormalRealTime_TagName,");
            sql.Append("				t.AbnormalRealTime_Desc,");
            sql.Append("				t.AbnormalRealTime_State,");
            sql.Append("				t.AbnormalRealTime_Type,");
            sql.Append("				t.AbnormalRealTime_StartTime,");
            sql.Append("				t.AbnormalRealTime_SustainTime,");
            sql.Append("				'2' AS num");
            sql.Append("			FROM");
            sql.Append("				RTResEx_AbnormalRealTime t");
            sql.Append("			WHERE");
            sql.Append("				t.AbnormalRealTime_State = '正常'");
            sql.Append("			OR t.AbnormalRealTime_State = '规则异常'");
            sql.Append("	) tt");
            sql.Append(" INNER JOIN RTResEx_RTData r ON tt.AbnormalRealTime_TagName = r.TagName");
            sql.Append(" ORDER BY tt.num ASC,tt.AbnormalRealTime_StartTime DESC");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<HomeAlarmInfo> allhomeAlarmNode = new List<HomeAlarmInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAlarmInfo hn = new HomeAlarmInfo();

                    hn.alarmId = recordnum.ToString();
                    hn.alarmRuleId = dr["AbnormalRealTime_TagID"].ToString();
                    hn.alarmBitNo = dr["AbnormalRealTime_TagName"].ToString();
                    hn.alarmTagDesc = dr["AbnormalRealTime_Desc"].ToString();
                    hn.alarmRealValue = dr["RTData_fRTVal"].ToString();
                    hn.alarmStatus = dr["AbnormalRealTime_State"].ToString();
                    hn.alarmType = dr["AbnormalRealTime_Type"].ToString();
                    hn.alarmSustainTime = dr["AbnormalRealTime_SustainTime"].ToString();
                    hn.alarmStartTime = dr["AbnormalRealTime_StartTime"].ToString();
                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                alarmList.content = allhomeAlarmNode;
            }
            return alarmList;
        }


        /// <summary>
        /// 主页获取预警监测信息
        /// </summary>
        /// <returns></returns>
        public HomeEarlyAlarmList getHomeEarlyAlarmInfo(IDao dao)
        {
            HomeEarlyAlarmList alarmList = new HomeEarlyAlarmList();
            alarmList.name = "预警监测";

            StringBuilder sql = new StringBuilder();
            sql.Append("WITH tab AS (");
            sql.Append("	SELECT");
            sql.Append("		t.AbnormalEarlyRealTime_TagID,");
            sql.Append("		MIN (");
            sql.Append("			t.AbnormalEarlyRealTime_StartTime");
            sql.Append("		) AS stTime,");
            sql.Append("		'1' AS num,");
            sql.Append("		'预警' AS status");
            sql.Append("	FROM");
            sql.Append("		RTResEx_AbnormalEarlyRealTime t");
            sql.Append("	WHERE");
            sql.Append("		t.AbnormalEarlyRealTime_State <> '正常'");
            sql.Append("	AND t.AbnormalEarlyRealTime_State <> '规则异常'");
            sql.Append("	GROUP BY");
            sql.Append("		t.AbnormalEarlyRealTime_TagID");
            sql.Append("),");
            sql.Append(" tab2 AS (");
            sql.Append("	SELECT");
            sql.Append("		t.AbnormalEarlyRealTime_TagID,");
            sql.Append("		MIN (");
            sql.Append("			t.AbnormalEarlyRealTime_StartTime");
            sql.Append("		) AS stTime,");
            sql.Append("		'2' AS num,");
            sql.Append("		'规则异常' AS status");
            sql.Append("	FROM");
            sql.Append("		RTResEx_AbnormalEarlyRealTime t");
            sql.Append("	LEFT JOIN tab ON t.AbnormalEarlyRealTime_TagID = tab.AbnormalEarlyRealTime_TagID");
            sql.Append("	WHERE");
            sql.Append("		t.AbnormalEarlyRealTime_State = '规则异常'");
            sql.Append("	AND tab.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("	GROUP BY");
            sql.Append("		t.AbnormalEarlyRealTime_TagID");
            sql.Append(") SELECT");
            sql.Append("	r.AbnormalEarlyRealTime_TagID,");
            sql.Append("	r.AbnormalEarlyRealTime_TagName,");
            sql.Append("	r.AbnormalEarlyRealTime_Desc,");
            sql.Append("	st.RTData_fRTVal,");
            sql.Append("	tt.status,");
            sql.Append("	r.AbnormalEarlyRealTime_Type,");
            sql.Append("	r.AbnormalEarlyRealTime_SustainTime,");
            sql.Append("	r.AbnormalEarlyRealTime_StartTime");
            sql.Append(" FROM RTResEx_AbnormalEarlyRealTime r");
            sql.Append(" INNER JOIN (");
            sql.Append("	SELECT * FROM tab");
            sql.Append("  UNION ALL");
            sql.Append("	SELECT * FROM tab2");
            sql.Append("		UNION ALL");
            sql.Append("			SELECT");
            sql.Append("				t.AbnormalEarlyRealTime_TagID,");
            sql.Append("				MIN (");
            sql.Append("					t.AbnormalEarlyRealTime_StartTime");
            sql.Append("				) AS stTime,");
            sql.Append("				'3' AS num,");
            sql.Append("				'正常' AS status");
            sql.Append("			FROM");
            sql.Append("				RTResEx_AbnormalEarlyRealTime t");
            sql.Append("			LEFT JOIN tab ON t.AbnormalEarlyRealTime_TagID = tab.AbnormalEarlyRealTime_TagID");
            sql.Append("			LEFT JOIN tab2 ON t.AbnormalEarlyRealTime_TagID = tab2.AbnormalEarlyRealTime_TagID");
            sql.Append("			WHERE");
            sql.Append("				t.AbnormalEarlyRealTime_State = '正常'");
            sql.Append("			AND tab.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("			AND tab2.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("			GROUP BY");
            sql.Append("				t.AbnormalEarlyRealTime_TagID");
            sql.Append(") tt ON r.AbnormalEarlyRealTime_TagID = tt.AbnormalEarlyRealTime_TagID");
            sql.Append(" AND r.AbnormalEarlyRealTime_StartTime = tt.stTime");
            sql.Append(" INNER JOIN RTResEx_RTData st ON r.AbnormalEarlyRealTime_TagName = st.TagName");
            sql.Append(" ORDER BY tt.num ASC,tt.stTime DESC");
           
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<HomeEarlyAlarmInfo> allhomeAlarmNode = new List<HomeEarlyAlarmInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeEarlyAlarmInfo hn = new HomeEarlyAlarmInfo();

                    hn.earlyAlarmId = recordnum.ToString();
                    hn.earlyAlarmRuleId = dr["AbnormalEarlyRealTime_TagID"].ToString();
                    hn.earlyAlarmBitNo = dr["AbnormalEarlyRealTime_TagName"].ToString();
                    hn.earlyAlarmTagDesc = dr["AbnormalEarlyRealTime_Desc"].ToString();
                    hn.earlyAlarmRealValue = dr["RTData_fRTVal"].ToString();
                    hn.earlyAlarmStatus = dr["status"].ToString();
                    hn.earlyAlarmType = dr["AbnormalEarlyRealTime_Type"].ToString();
                    hn.earlyAlarmSustainTime = dr["AbnormalEarlyRealTime_SustainTime"].ToString();
                    hn.earlyAlarmStartTime = dr["AbnormalEarlyRealTime_StartTime"].ToString();
                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                alarmList.content = allhomeAlarmNode;
            }
            return alarmList;
        }


        /// <summary>
        /// 主页获取异常监测信息
        /// </summary>
        /// <returns></returns>
        public HomeAbStateList getHomeAbStateInfo(IDao dao)
        {
            HomeAbStateList alarmList = new HomeAbStateList();
            alarmList.name = "异常监测";

            StringBuilder sql = new StringBuilder();
            sql.Append("select tt.* from ");
            sql.Append(" (SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AbnormalStateRealTime_TagID,");
            sql.Append("	t.AbnormalStateRealTime_TagName,");
            sql.Append("	t.AbnormalStateRealTime_Desc,");
            sql.Append("	t.AbnormalStateRealTime_State,");
            sql.Append("	t.AbnormalStateRealTime_Unit,");
            sql.Append("	t.AbnormalStateRealTime_Meter,");
            sql.Append("	t.AbnormalStateRealTime_StartTime,");
            sql.Append("	t.AbnormalStateRealTime_SustainTime,");
            sql.Append("    '1' as num");
            sql.Append(" FROM RTResEx_AbnormalStateRealTime t ");
            sql.Append(" WHERE t.AbnormalStateRealTime_State <> '正常'");
            sql.Append("   AND t.AbnormalStateRealTime_State <> '规则异常'");
            sql.Append(" union ALL ");
            sql.Append("SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AbnormalStateRealTime_TagID,");
            sql.Append("	t.AbnormalStateRealTime_TagName,");
            sql.Append("	t.AbnormalStateRealTime_Desc,");
            sql.Append("	t.AbnormalStateRealTime_State,");
            sql.Append("	t.AbnormalStateRealTime_Unit,");
            sql.Append("	t.AbnormalStateRealTime_Meter,");
            sql.Append("	t.AbnormalStateRealTime_StartTime,");
            sql.Append("	t.AbnormalStateRealTime_SustainTime,");
            sql.Append("    '2' as num");
            sql.Append(" FROM RTResEx_AbnormalStateRealTime t");
            sql.Append(" WHERE t.AbnormalStateRealTime_State = '正常'");
            sql.Append("  or t.AbnormalStateRealTime_State = '规则异常') tt");
            sql.Append(" ORDER BY tt.num ASC,tt.AbnormalStateRealTime_StartTime DESC");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                int recordnum = 1;
                List<HomeAbStateInfo> allhomeAlarmNode = new List<HomeAbStateInfo>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAbStateInfo hn = new HomeAbStateInfo();

                    hn.abStateId = recordnum.ToString();
                    hn.abStateRuleId = dr["AbnormalStateRealTime_TagID"].ToString();
                    hn.abStateName = dr["AbnormalStateRealTime_TagName"].ToString();
                    hn.abStateDesc = dr["AbnormalStateRealTime_Desc"].ToString();
                    hn.abStateStatus = dr["AbnormalStateRealTime_State"].ToString();
                    hn.abStateUnit = dr["AbnormalStateRealTime_Unit"].ToString();
                    hn.abStateMeter = dr["AbnormalStateRealTime_Meter"].ToString();
                    hn.abStateSustainTime = dr["AbnormalStateRealTime_SustainTime"].ToString();
                    hn.abStateStartTime = dr["AbnormalStateRealTime_StartTime"].ToString();
                    allhomeAlarmNode.Add(hn);
                    recordnum++;
                }
                alarmList.content = allhomeAlarmNode;
            }
            return alarmList;
        }

        /// <summary>
        /// 获取主页B的页面信息
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public string getHome2DeviceInfo(string plantId) {
            //返回结果
            String deviceJson = "";
            Dictionary<String, List<DeviceIndex>> dictList = new Dictionary<String, List<DeviceIndex>>();
            Plant plant = BeanTools.getPlantDB(plantId);
            string realDB = plant.realTimeDB;
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	p.ID,");
            sql.Append("	p.ProductLine_Name,");
            sql.Append("	d.ID as deviceId,");
            sql.Append("	d.Device_Code,");
            sql.Append("	dev.DeviceRealTime_RunIndex,");
            sql.Append("	dev.DeviceRealTime_AlarmIndex,");
            sql.Append("	dev.DeviceRealTime_EarlyAlarmIndex");
            sql.Append(" FROM PSOG_ProductLine p");
            sql.Append(" INNER JOIN PSOG_Device d ON p.ID = d.Device_ProductLineID and (d.IsDelete is null or d.IsDelete<>'1')");
            sql.AppendFormat(" LEFT JOIN {0}.dbo.RTResEx_DeviceRealTime dev ", realDB);
            sql.Append("  ON d.ID = dev.DeviceRealTime_TagId");
            sql.Append(" where (p.IsDelete is null or p.IsDelete<>'1')");
            sql.Append(" ORDER BY p.ID,d.Device_Code");
            IDao dao = new Dao(plant,true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                String unitId = "";
                String unitName = "";
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DeviceIndex device = new DeviceIndex();
                    device.deviceId = dr["deviceId"].ToString();
                    device.deviceName = dr["Device_Code"].ToString();
                    device.runIndex = dr["DeviceRealTime_RunIndex"].ToString();
                    device.alarmIndex = dr["DeviceRealTime_AlarmIndex"].ToString();
                    device.earlyAlarmIndex = dr["DeviceRealTime_EarlyAlarmIndex"].ToString();
                    if (!unitId.Equals(dr["ID"].ToString()))
                    {
                        unitId = dr["ID"].ToString();
                        unitName = dr["ProductLine_Name"].ToString();
                        List<DeviceIndex> devList = new List<DeviceIndex>();
                        devList.Add(device);
                        dictList.Add(unitId + "@" + unitName, devList);
                    }
                    else {
                        dictList[unitId + "@" + unitName].Add(device);
                    }
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            deviceJson = jsonSerializer.Serialize(dictList);
            return deviceJson;

        }
        
    }
}
