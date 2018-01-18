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
        //context.Response.ContentType = "text/plain";
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
            //8张图片
            String svg_level = context.Request["svg_level"];
            String svg_distribution_area = context.Request["svg_distribution_area"];
            String svg_chattering = context.Request["svg_chattering"];
            String svg_standing = context.Request["svg_standing"];
            String svg_distribution_time = context.Request["svg_distribution_time"];
            String svg_distribution_priority_all = context.Request["svg_distribution_priority_all"];
            String svg_distribution_priority_area = context.Request["svg_distribution_priority_area"];
            String svg_Top20 = context.Request["svg_Top20"];
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
            String dataGrid_top20 = context.Request["dataGrid_top20"];
            String dataGrid_standing = context.Request["dataGrid_standing"];
            String dataGrid_chattering = context.Request["dataGrid_chattering"];

            // List<AlarmLevelTotal> a = BeanTools.getBoList<AlarmLevelTotal>(dataGrid_level);
            Process p = new Process();
            
            try
            {
                p.StartInfo.FileName = "CMD.EXE"; //创建CMD.EXE 进程
                p.StartInfo.RedirectStandardInput = true; //重定向输入
                p.StartInfo.RedirectStandardOutput = true;//重定向输出
                p.StartInfo.UseShellExecute = false; // 不调用系统的Shell
                p.StartInfo.RedirectStandardError = true; // 重定向Error
                p.StartInfo.CreateNoWindow = true; //不创建窗口
                p.Start(); // 启动进程
                p.StandardInput.WriteLine("cd d:\\workspace\\SVG2PNG\\classes"); // Cmd 命令
                string png_file = context.Request.PhysicalApplicationPath + "temp\\";
                string file_total = "";

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
                string repeat_file_name = plantId + startTime + endTime;
                p.StandardInput.WriteLine("java SVG_packege.MyConverter " + file_total + " " + png_file + " image/png " + repeat_file_name);
                p.StandardInput.WriteLine("exit"); // 退出
                p.WaitForExit();
                p.Close();
                
                //p.StartInfo.WindowStyle = ProcessWindowStyle.Minimized;
                // Start the process
                //Process p_export = new Process();
                //string exeName = "D:\\PSOG版本\\C_ExportWord 2014-12-22\\ExportWord\\bin\\Release\\ExportWord.exe";
                //p_export = System.Diagnostics.Process.Start(exeName, "1" + "xcfzsd");
                // Wait for process to be created and enter idle condition

            }
            catch
            { }

            string fileName = "1.doc";//客户端保存的文件名
            string filePath = context.Request.PhysicalApplicationPath + "temp\\4.doc";//路径

            //以字符流的形式下载文件
            //FileStream fs = new FileStream(filePath, FileMode.Open);
            //byte[] bytes = new byte[(int)fs.Length];
            //fs.Read(bytes, 0, bytes.Length);
            //fs.Close();
            //MemoryStream tData = new MemoryStream(Encoding.UTF8.GetBytes(svg_level));
            //MemoryStream tStream = new MemoryStream();
            //Svg.SvgDocument tSvgObj = SvgDocument.Open(tData);
            //tSvgObj.Draw().Save(tStream, ImageFormat.Png);
            //context.Response.ClearContent();
            //context.Response.ClearHeaders();
            //context.Response.ContentType = "image/png";
            //context.Response.AppendHeader("Content-Disposition", "attachment; filename=chart.png");
            //context.Response.BinaryWrite(tStream.ToArray());
            //context.Response.End();
            
            //context.Response.ClearContent();
            //context.Response.ClearHeaders();
            //context.Response.ContentType = "application/ms-word";
            ////通知浏览器下载文件而不是打开
            //context.Response.AppendHeader("Content-Disposition", "attachment;  filename=" + fileName);
            ////context.Response.BinaryWrite(bytes);
            //context.Response.TransmitFile(filePath);
            //context.Response.Flush();
            //context.Response.End();


        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    
    

}