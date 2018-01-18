using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using System.Web;
using System.Data;
using System.IO;
using NPOI.HSSF.Model;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using System.Timers;
using PSOG.Entity;
using System.Collections;

namespace PSOG.Common
{
    public class BeanTools
    {
        private static Dictionary<string, Plant> plantDic = new Dictionary<string, Plant>();

        public static void setPlantDic(Dictionary<string, Plant> plants)
        {
            plantDic = plants;
        }
        /* 将对象转化为json串输出到outStream中 */
        public static void ToJson(System.IO.Stream outStream, object obj)
        {
            if (null == obj || "" == obj) return;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            Console.Write(serializer.Serialize(obj));
            byte[] byteData = System.Text.Encoding.UTF8.GetBytes(serializer.Serialize(obj));
            outStream.Write(byteData, 0, byteData.Length);
        }

        /* 将对象转化为json串输出到outStream中 */
        public static String ToJson(object obj)
        {
            if (null == obj || "" == obj) return null;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Serialize(obj);
        }

        /* 将对象转为String类型 */
        public static String ObjectToString(Object obj)
        {
            return null == obj || System.DBNull.Value == obj ? "" : obj.ToString();
        }

        /* 将对象转为String类型 */
        public static String DataTimeToString(Object obj)
        {
            return null == obj || System.DBNull.Value == obj ? "" : ((DateTime)obj).ToString("yyyy-MM-dd HH:mm:ss");
        }

        /// <summary>
        /// 将对象转为Doubl类型
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static double ObjectToDouble(Object obj)
        {
            return null == obj || System.DBNull.Value == obj ? 0 : (double)obj;
        }

        /// <summary>
        /// 将对象转为Float类型
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static float ObjectToFloat(Object obj)
        {
            return null == obj || System.DBNull.Value == obj ? 0 : float.Parse(obj.ToString());
        }

        /// <summary>
        /// decimal To int
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static int DBToInt(Object obj)
        {
            return null == obj ? 0 : (System.DBNull.Value == obj ? 0 : (int)obj);
        }

        /// <summary>
        /// 判断DataSet是否为空
        /// </summary>
        /// <param name="rs"></param>
        /// <returns></returns>
        public static bool DataSetIsNotNull(DataSet rs)
        {
            return null != rs && null != rs.Tables[0] && 1 <= rs.Tables[0].Rows.Count && 1 <= rs.Tables[0].Rows[0].ItemArray.Length;
        }

        /* 将对象转为int类型 */
        public static int ObjectToInt(Object obj)
        {
            int resultNum;
            try
            {
                resultNum = null == obj || System.DBNull.Value == obj ? 0 : (Int32)obj;
            }
            catch (Exception exp)
            {
                resultNum = null == obj || System.DBNull.Value == obj ? 0 : (int)((decimal)obj);
                return resultNum;
            }
            return resultNum;
        }

        /* 获取当前时间 格式yyyy-MM-dd hh:mm:ss */
        public static String getCureentTime()
        {
            return DateTime.Now.ToUniversalTime().ToString();
        }

        /// <summary>
        /// 将json串转化为T类型的对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="dataStr"></param>
        /// <returns></returns>
        public static List<T> getBoList<T>(String dataStr)
        {
            List<T> list = new List<T>();
            if (!string.IsNullOrEmpty(dataStr))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                list = serializer.Deserialize<List<T>>(dataStr);
            }
            return list;
        }

        public static MemoryStream RenderToExcel(IDataReader reader)
        {
            MemoryStream ms = new MemoryStream();

            using (reader)
            {
                IWorkbook workbook = new HSSFWorkbook();
                ISheet sheet = workbook.CreateSheet();

                IRow headerRow = sheet.CreateRow(0);
                int cellCount = reader.FieldCount;

                // handling header.
                for (int i = 0; i < cellCount; i++)
                {
                    headerRow.CreateCell(i).SetCellValue(reader.GetName(i));
                }

                // handling value.
                int rowIndex = 1;
                while (reader.Read())
                {
                    IRow dataRow = sheet.CreateRow(rowIndex);

                    for (int i = 0; i < cellCount; i++)
                    {
                        dataRow.CreateCell(i).SetCellValue(reader[i].ToString());
                    }

                    rowIndex++;
                }

                workbook.Write(ms);
                ms.Flush();
                ms.Position = 0;

                sheet = null;
                workbook = null;
                    
            }
            return ms;
        }

        public static MemoryStream RenderToExcel(DataTable table)
        {
            MemoryStream ms = new MemoryStream();

            using (table)
            {
                
                IWorkbook workbook = new HSSFWorkbook();
                ISheet sheet = workbook.CreateSheet();
                IRow headerRow = sheet.CreateRow(0);

                // handling header.
                foreach (DataColumn column in table.Columns)
                    headerRow.CreateCell(column.Ordinal).SetCellValue(column.Caption);//If Caption not set, returns the ColumnName value

                // handling value.
                int rowIndex = 1;

                foreach (DataRow row in table.Rows)
                {
                    IRow dataRow = sheet.CreateRow(rowIndex);

                    foreach (DataColumn column in table.Columns)
                    {
                        dataRow.CreateCell(column.Ordinal).SetCellValue(row[column].ToString());
                    }

                    rowIndex++;
                }

                workbook.Write(ms);
                ms.Flush();
                ms.Position = 0;
                sheet = null;
                workbook = null;
            }
            return ms;
        }

        public static void RenderToBrowser(MemoryStream ms, HttpContext context, string fileName)
        {
            if (context.Request.Browser.Browser == "IE")
                fileName = HttpUtility.UrlEncode(fileName);
            context.Response.AddHeader("Content-Disposition", "attachment;fileName=" + fileName);
            context.Response.BinaryWrite(ms.ToArray());
        }

        /// <summary> 
        /// Base64加密 
        /// </summary> 
        /// <param name="codeName">加密采用的编码方式</param> 
        /// <param name="source">待加密的明文</param> 
        /// <returns></returns> 
        public static string EncodeBase64(Encoding encode, string source)
        {
            String encodeStr = "";
            
            try
            {
                byte[] bytes = encode.GetBytes(source);
                encodeStr = Convert.ToBase64String(bytes);
            }
            catch
            {
                encodeStr = source;
            }
            return encodeStr;
        }

        /// <summary> 
        /// Base64加密，采用utf8编码方式加密 
        /// </summary> 
        /// <param name="source">待加密的明文</param> 
        /// <returns>加密后的字符串</returns> 
        public static string EncodeBase64(string source)
        {
            return EncodeBase64(Encoding.UTF8, source);
        }

        /// <summary> 
        /// Base64解密 
        /// </summary> 
        /// <param name="codeName">解密采用的编码方式，注意和加密时采用的方式一致</param> 
        /// <param name="result">待解密的密文</param> 
        /// <returns>解密后的字符串</returns> 
        public static string DecodeBase64(Encoding encode, string result)
        {
            string decodeStr = "";
            
            try
            {
                byte[] bytes = Convert.FromBase64String(result);
                decodeStr = encode.GetString(bytes);
            }
            catch
            {
                decodeStr = result;
            }
            return decodeStr;
        }

        /// <summary> 
        /// Base64解密，采用utf8编码方式解密 
        /// </summary> 
        /// <param name="result">待解密的密文</param> 
        /// <returns>解密后的字符串</returns> 
        public static string DecodeBase64(string result)
        {
            return DecodeBase64(Encoding.UTF8, result);
        }

        /// <summary>
        /// 获取响应的Plant信息
        /// </summary>
        /// <param name="application"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public static Plant getPlantDB(string name)
        {
            Plant plantInfo = null;
            if (!string.IsNullOrEmpty(name))
            {
                try
                {
                    plantInfo = plantDic[name];
                }
                catch (Exception exp)
                {
                    plantInfo = null;
                }
            }
            return plantInfo;
        }

        /// <summary>
        /// 获取响应的Plant信息
        /// </summary>
        /// <param name="application"></param>
        /// <param name="name"></param>
        /// <returns></returns>
        public static List<Plant> getPlantDBs(string names)
        {
            List<Plant> plantInfos = new List<Plant>();
            if (!string.IsNullOrEmpty(names))
            {
                try
                {
                    Plant plant = new Plant();
                    String[] name = names.Split(',');
                    foreach (string plantName in name)
                    {
                        plant = plantDic[plantName];
                        plantInfos.Add(plant);
                    }
                }
                catch (Exception exp)
                {
                    //plantInfos = null;
                }
            }
            return plantInfos;
        }

        public static List<Plant> getAllPlantDB()
        {
            List<Plant> plantInfos = new List<Plant>();
            Dictionary<string, Plant>.KeyCollection keys =  plantDic.Keys;
            foreach (string key in keys)
            {
                plantInfos.Add(plantDic[key]);
            }
            return plantInfos;
        }

        public static void setURLOfKnowledge(string url)
        {
            CommonStr.plantItemUri[6] = url;

        }
    }
}
