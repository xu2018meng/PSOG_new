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
    public class Common
    {
        public static string getFilePath(string name, Plant plant)
        {
            string filePath = "";
            string DBName = plant.realTimeDB;
            if (!string.IsNullOrEmpty(name) && DBName.Length > 13)
            {
               // DBName = DBName.Substring(13);
                string fileName = plant.id;
                filePath = PSOG.Common.CommonStr.unusualImgPath + fileName + @"\" + name + ".bmp";
            }
            return filePath;
        }


        public static Equipment getClickProcess(string id, Plant plant, string plantId)
        {
            Equipment equip = new Equipment();
            string DBName = plant.historyDB;
            if (!string.IsNullOrEmpty(id) && DBName.Length > 13)
            {
                IDao dao = new Dao(plant,false);
                string sql = string.Format("select * from PSOG_ProcessMonitorObject where PSOG_MonitorObject_MSPCModelID='{0}' ", id);
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    equip.id = BeanTools.ObjectToString(dr["PSOG_MonitorObject_MSPCModelID"]);
                    equip.monitorObject_Name = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Name"]);
                    equip.monitorObject_Type = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Type"]);
                    equip.monitorObject_Source = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Source"]);
                    equip.monitorObject_Status = BeanTools.ObjectToString(dr["MonitorObject_CurrStatus"]);
                    if (CommonStr.monitorObject_Source == equip.monitorObject_Source)  //替换为自己的连接
                    {
                        string[] url = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Url"]).Split('?');
                        String parames = 2 <= url.Length ? url[1] : "";
                        //equip.monitorObject_Url = url[0] + "?" + parames + "&modelName=" + equip.monitorObject_Name;
                        equip.monitorObject_Url = url[0] + "?" + parames;
                    }
                    else
                    {
                        equip.monitorObject_Url = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Url"]);
                    }
                }
            }
            return equip;
        }


        public List<Abnormal> AbnormalNumber(string plantId,string id)
        {

            List<Abnormal> AbnormalList = new List<Abnormal>();
           // string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
            Plant plant = BeanTools.getPlantDB(plantId);
            string DBName = plant.realTimeDB;
            if (!string.IsNullOrEmpty(id) && DBName.Length > 13)
            {
                IDao dao = new Dao(plant,false);
                string sql = string.Format("select m.AS_Equipment_ID,m.AS_Equipment_FileName,m.AS_Equipment_Name,m.AS_Equipment_State from PSOG_AS_Equipment m,PSOG_ProcessMonitorObject n where n.PSOG_MonitorObject_MSPCModelID='{0}'AND n.PSOG_MonitorObject_Name=m.AS_Equipment_Process AND n.PSOG_MonitorObject_Name=m.AS_Equipment_Process AND m.AS_Equipment_State=-1 ", id);
                DataSet ds = dao.executeQuery(sql.ToString());
               
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        Abnormal node = new Abnormal();
                        node.AS_Equipment_ID = BeanTools.ObjectToString(dr["AS_Equipment_ID"]);
                        node.AS_Equipment_Name = BeanTools.ObjectToString(dr["AS_Equipment_Name"]);
                        node.AS_Equipment_State = BeanTools.ObjectToString(dr["AS_Equipment_State"]);
                        //node.AS_Equipment_FileName = BeanTools.ObjectToString(dr["AS_Equipment_FileName"]);
                        AbnormalList.Add(node);
                    }
                }
            }
            return AbnormalList;
           
        }



        public static string getEquipName(Plant plant, string url)
        {
            // Equipment equip = new Equipment();
            string monitorObject_Name = "";
            string DBName = plant.historyDB;
            if (DBName.Length > 13)
            {
                IDao dao = new Dao(plant, false);
                string sql = string.Format("select * from PSOG_ProcessMonitorObject where PSOG_MonitorObject_Url like '{0}' ", url);
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    monitorObject_Name = BeanTools.ObjectToString(dr["PSOG_MonitorObject_Name"]);

                }
            }
            return monitorObject_Name;
        }
    }
}
