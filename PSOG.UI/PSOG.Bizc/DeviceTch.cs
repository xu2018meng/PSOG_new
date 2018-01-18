using System;
using System.Collections.Generic;
using System.Text;
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;
using System.Data;
using PSOG.DAO;
using PSOG.DAO.impl;
using System.Web.Script.Serialization;

namespace PSOG.Bizc
{
    public class DeviceTch
    {
        /// <summary>
        /// 设备类型查询
        /// </summary>
        /// <param name="PesFileName"></param>
        /// <param name="dao"></param>
        /// <returns></returns>
        public List<Equipment> loadEquipmentFuntion(Plant plant)
        {
            IDao dao = new Dao(plant,false);
            List<Equipment> list = new List<Equipment>();

            String sql = "select * from psog_processmonitorObject t where t.psog_monitorobject_type = '设备' order by id asc";

            DataSet ds = dao.executeQuery(sql);

            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Equipment bo = new Equipment();
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
        /// 生成json串供前台展示
        /// </summary>
        /// <returns></returns>
        public string produceJson(Plant plant)
        {
            IDao dao = new Dao(plant,false);
            int Project_ID = new INI_IO().ReadID();
            MainPage mainPage = new MainPage();
            List<Equipment> DynamicProcess = loadEquipmentFuntion(plant); //节点
            List<NormalNodeList> m_NotNormalNodeList = mainPage.initNotNormalNodeList(dao);

            string jsonData = "";
            List<JasonSeri> js = new List<JasonSeri>();
            for (int pn = DynamicProcess.Count-1; pn >= 0; pn--)
            {
                string processName = DynamicProcess[pn].monitorObject_Name;
                JasonSeri tempjs = new JasonSeri();

                List<excNode> listexc = new List<excNode>();
                foreach (NormalNodeList temp in m_NotNormalNodeList)
                {
                    if (temp.Group == processName)
                    {

                        excNode tempNode = new excNode();
                        string FatherID = "-1";

                        FatherID = FatherID + "_" + temp.ID;
                        int projectid = Project_ID;
                        tempNode.twoID = FatherID + "," + projectid;
                        tempNode.Text = temp.Describe;
                        listexc.Add(tempNode);

                    }
                }
                tempjs.name = processName;
                if (listexc.Count > 0)
                {
                    tempjs.state = "异常";
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
    }
}
