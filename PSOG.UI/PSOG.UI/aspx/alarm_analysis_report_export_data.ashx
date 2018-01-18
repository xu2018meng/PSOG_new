<%@ WebHandler Language="C#" Class="alarm_analysis_report_export_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Collections;
//using Svg;
using System.Drawing.Imaging;

public class alarm_analysis_report_export_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["action"] != null)
        {
            if (context.Request.Form["action"].Equals("deleteItem"))
            {
                string id = context.Request.Form["realTimeID"].ToString();
                String plantId = context.Request.Form["plantId"];
                plantId = null == plantId ? "" : plantId;
                string DBName = BeanTools.getPlantDB(plantId).realTimeDB;    //数据库名
                SysManage manage = new SysManage();
                string message = manage.deleteAlarmParamenter(id, DBName);
                context.Response.Write(message);
            }
        }
        else
        {
            String plantId = context.Request["plantId"];
            plantId = null == plantId ? "" : plantId;
            String startTime = context.Request["startTime"];
            String endTime = context.Request["endTime"];
            
            string startTimeCopy = startTime;
            string endTimeCopy = endTime;
            
            startTime = startTime.Replace(":", "").Replace("-", "").Replace(" ", "");
            endTime = endTime.Replace(":", "").Replace("-", "").Replace(" ", "");
            //8张图片
            String svg_level = context.Request["svg_level"];
            svg_level = HttpUtility.UrlDecode(svg_level, Encoding.UTF8);
            String svg_distribution_area = context.Request["svg_distribution_area"];
            svg_distribution_area = HttpUtility.UrlDecode(svg_distribution_area, Encoding.UTF8);
            String svg_chattering = context.Request["svg_chattering"];
            svg_chattering = HttpUtility.UrlDecode(svg_chattering, Encoding.UTF8);
            String svg_standing = context.Request["svg_standing"];
            svg_standing = HttpUtility.UrlDecode(svg_standing, Encoding.UTF8);
            String svg_distribution_time = context.Request["svg_distribution_time"];
            svg_distribution_time = HttpUtility.UrlDecode(svg_distribution_time, Encoding.UTF8);
            String svg_distribution_priority_all = context.Request["svg_distribution_priority_all"];
            svg_distribution_priority_all = HttpUtility.UrlDecode(svg_distribution_priority_all, Encoding.UTF8);
            String svg_distribution_priority_area = context.Request["svg_distribution_priority_area"];
            svg_distribution_priority_area = HttpUtility.UrlDecode(svg_distribution_priority_area, Encoding.UTF8);
            String svg_Top20 = context.Request["svg_Top20"];
            svg_Top20 = HttpUtility.UrlDecode(svg_Top20, Encoding.UTF8);
            String[] svg = new String[8];
            svg[0] = svg_level;
            svg[1] = svg_distribution_area;
            svg[2] = svg_chattering;
            svg[3] = svg_standing;
            svg[4] = svg_distribution_time;
            svg[5] = svg_distribution_priority_all;
            svg[6] = svg_distribution_priority_area;
            svg[7] = svg_Top20;
            //4个表格
            String dataGrid_level = context.Request["dataGrid_level"];
            dataGrid_level = HttpUtility.UrlDecode(dataGrid_level, Encoding.UTF8);
            String dataGrid_top20 = context.Request["dataGrid_top20"];
            dataGrid_top20 = HttpUtility.UrlDecode(dataGrid_top20, Encoding.UTF8);
            String dataGrid_standing = context.Request["dataGrid_standing"];
            dataGrid_standing = HttpUtility.UrlDecode(dataGrid_standing, Encoding.UTF8);
            String dataGrid_chattering = context.Request["dataGrid_chattering"];
            dataGrid_chattering = HttpUtility.UrlDecode(dataGrid_chattering, Encoding.UTF8);

            // List<AlarmLevelTotal> a = BeanTools.getBoList<AlarmLevelTotal>(dataGrid_level);
            //Process p = new Process();
            
            try
            {                
                string png_file = context.Request.PhysicalApplicationPath + "temp\\";
                string file_total = "";
                //p.StandardInput.WriteLine("cd " + context.Request.PhysicalApplicationPath + "applications\\SVG2PNG\\classes"); // Cmd 命令

                for (int i = 0; i < 8 ; i++)
                {
                    string file_name = plantId + startTime + endTime + "_" + i;
                    string file = context.Request.PhysicalApplicationPath + "temp\\" + file_name + ".svg";
                    FileStream myFs = new FileStream(file, FileMode.Create);
                    StreamWriter mySw = new StreamWriter(myFs);
                    mySw.Write(svg[i]);
                    mySw.Close();
                    myFs.Close();

                    if (i == 0)
                    {
                        file_total = file_total + file_name + ".svg";
                    }
                    else
                    {
                        file_total = file_total + " " + file_name + ".svg";
                    }
                }
                
                string[] paras = new string[8];
                paras[0] = plantId;
                paras[1] = startTimeCopy;
                paras[2] = endTimeCopy;
                paras[3] = png_file;
                paras[4] = dataGrid_level;
                paras[5] = dataGrid_top20;
                paras[6] = dataGrid_standing;
                paras[7] = dataGrid_chattering;

                for(int j=0; j<8; j++)
                {
                    File.Delete(png_file + j + ".txt");
                    FileStream fs = new FileStream(png_file + j + ".txt", FileMode.OpenOrCreate, FileAccess.ReadWrite);
                    StreamWriter m_StreamWriter = new StreamWriter(fs);
                    m_StreamWriter.BaseStream.Seek(0, SeekOrigin.Begin);
                    m_StreamWriter.Write(paras[j]);
                    m_StreamWriter.Flush();
                    m_StreamWriter.Close();
                    fs.Close();
                }

            }
            catch
            { }
            //System.Threading.Thread.Sleep(10000);
            string doc_path = context.Request.PhysicalApplicationPath + "temp\\" + plantId + startTime + endTime + ".doc";
            DateTime dateTemp = DateTime.Now;
            while(true)
            {
                if (File.Exists(doc_path))
                {
                    FileInfo file = new FileInfo(doc_path);
                    if (FileIsInUse(file))
                    {
                        System.Threading.Thread.Sleep(500);
                    }
                    else
                    {
                        break;
                    }
                    
                }
                else
                {
                    System.Threading.Thread.Sleep(500);
                }
            }
            BeanTools.ToJson(context.Response.OutputStream, "OK");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    static bool FileIsInUse(FileInfo file)
    {
        FileStream stream = null;

        try
        {
            stream = file.Open(FileMode.Open, FileAccess.ReadWrite, FileShare.None);
        }
        catch (IOException)
        {
            //如果文件被占用，即
            //1.文件正在被另一程序写入
            //2.或者正在被另一线程处理
            //3.或者文件不存在
            //此处会抛出异常，我们就利用这个异常来判断指定文件是否被占用
            return true;
        }
        finally
        {
            if (stream != null)
                stream.Close();
        }

        //file is not locked
        return false;
    } 
    

}