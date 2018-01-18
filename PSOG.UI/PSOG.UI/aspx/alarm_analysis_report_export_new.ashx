<%@ WebHandler Language="C#" Class="alarm_analysis_report_export_new" %>

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
using Word = Microsoft.Office.Interop.Word;
using Microsoft.Office.Interop.Word;
using System.Web.Script.Serialization;
using System.Configuration;

public class alarm_analysis_report_export_new : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
            context.Response.ContentType = "text/plain";

            string PhysicalPath = ConfigurationManager.AppSettings["PhysicalPath"];
          //生成word程序对象
            Word.Application app = new Word.Application();
            ////生成documnet对象
            Word.Document doc = new Word.Document();
            Process p = new Process();
            string reportTempName = "";
            Dictionary<string, string> resultDict = new Dictionary<string, string>();//返回结果
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            try
            {
                String plantId = context.Request["plantId"];
                plantId = null == plantId ? "" : plantId;
                String startTime = context.Request["startTime"];
                String endTime = context.Request["endTime"];
                //获取装置名称
                string plantName = new SysManage().getPlantName(plantId);

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
                
                
                List<AlarmLevelTotal> levelList = jsonSerializer.Deserialize<List<AlarmLevelTotal>>(dataGrid_level);
                List<AlarmTop20> top20List = jsonSerializer.Deserialize<List<AlarmTop20>>(dataGrid_top20);
                List<AlarmStanding> standingList = jsonSerializer.Deserialize<List<AlarmStanding>>(dataGrid_standing);
                List<AlarmChattering> chartteringList = jsonSerializer.Deserialize<List<AlarmChattering>>(dataGrid_chattering);

                reportTempName = Guid.NewGuid().ToString();
                for (int i = 0; i < 8; i++)
                {
                    string file_name = reportTempName + "_" + i;
                    string file = PhysicalPath + "temp\\" + file_name + ".svg";
                    FileStream myFs = new FileStream(file, FileMode.Create);
                    StreamWriter mySw = new StreamWriter(myFs);
                    mySw.Write(svg[i]);
                    mySw.Close();
                    myFs.Close();
                }

                 //将8个SVG图表转换成png图片
                p.StartInfo.FileName = "CMD.EXE"; //创建CMD.EXE 进程
                p.StartInfo.RedirectStandardInput = true; //重定向输入
                p.StartInfo.RedirectStandardOutput = true;//重定向输出
                p.StartInfo.UseShellExecute = false; // 不调用系统的Shell
                p.StartInfo.RedirectStandardError = true; // 重定向Error
                p.StartInfo.CreateNoWindow = false; //不创建窗口
                p.Start(); // 启动进程
                string FilePath = PhysicalPath + "temp\\";
                string png_file = FilePath;
                string file_total = "";
                string cmdStart = FilePath.Substring(0, FilePath.IndexOf(":"));
                p.StandardInput.WriteLine(cmdStart + ":");// Cmd 命令
                p.StandardInput.WriteLine("cd " + FilePath + "applications\\SVG2PNG\\classes"); // Cmd 命令

                for (int i = 0; i < 8; i++)
                {
                    string file_name = reportTempName + "_" + i;
                    if (i == 0)
                    {
                        file_total = file_total + file_name + ".svg";
                    }
                    else
                    {
                        file_total = file_total + " " + file_name + ".svg";
                    }
                }
                string repeat_file_name = reportTempName;
                p.StandardInput.WriteLine("java SVG_packege.MyConverter " + file_total + " " + png_file + " image/png " + repeat_file_name);
                p.StandardInput.WriteLine("exit"); // 退出
                p.WaitForExit();
                p.Close();

                  
                //生成的具有模板样式的新文件
                string reportFilePath = PhysicalPath + "uploads\\AnalysisReport\\";
                if (!Directory.Exists(reportFilePath))
                {
                    Directory.CreateDirectory(reportFilePath);
                }

                string templateFile = PhysicalPath + "\\temp\\report2003.doc";
                System.IO.File.Copy(templateFile, reportFilePath + reportTempName + ".doc", true);

                ////开始往模板里写内容--start
                object Obj_FileName = reportFilePath + reportTempName + ".doc";
                object Visible = false;
                object ReadOnly = false;
                object missing = System.Reflection.Missing.Value;

                ////打开文件
                doc = app.Documents.Open(ref Obj_FileName, ref missing, ref ReadOnly, ref missing,
                    ref missing, ref missing, ref missing, ref missing,
                    ref missing, ref missing, ref missing, ref Visible,
                    ref missing, ref missing, ref missing,
                    ref missing);
                doc.Activate();

                object what = Word.WdGoToItem.wdGoToBookmark;
                object WordMarkName = "";//word模板中的书签名称
                //插入装置
                insertAtBookMark(doc, "plantName", plantName);
                insertAtBookMark(doc, "plantName1", plantName);
                //插入时间
                insertAtBookMark(doc, "period", startTimeCopy + "---" + endTimeCopy);

                //插入图表
                for (int i = 0; i < 8; i++)
                {
                    WordMarkName = "ChartPic" + (i + 1);//word模板中的书签名称
                    doc.ActiveWindow.Selection.GoTo(ref what, ref missing, ref missing, ref WordMarkName);
                    string chartName = PhysicalPath + "temp\\" + reportTempName + "_" + i + ".png"; ;
                    if (System.IO.File.Exists(chartName))
                    {
                        doc.ActiveWindow.Selection.InlineShapes.AddPicture(chartName, ref missing, ref missing, ref missing);
                        doc.ActiveWindow.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                    }
                }

                //插入列表
                if (levelList != null && levelList.Count > 0) {
                    Word.Table levelTable = doc.Tables[1];
                    int levelCurrentRow = 2;
                    Object beforeRow = null;
                    foreach (AlarmLevelTotal levelTotal in levelList) {
                        beforeRow = levelTable.Rows[levelCurrentRow];
                        levelTable.Rows.Add(ref beforeRow);
                        levelTable.Cell(levelCurrentRow, 1).Range.Text = levelTotal.index_name;
                        levelTable.Cell(levelCurrentRow, 2).Range.Text = levelTotal.plant_num;
                        levelTable.Cell(levelCurrentRow, 3).Range.Text = levelTotal.index_goal;
                        levelTable.Cell(levelCurrentRow, 4).Range.Text = levelTotal.remark;
                        levelCurrentRow++;
                    }
                }

                if (top20List != null && top20List.Count > 0)
                {
                    Word.Table top20Table = doc.Tables[2];
                    int top20CurrentRow = 2;
                    Object top20beforeRow = null;
                    int top20RowIndex = 1;
                    foreach (AlarmTop20 top20 in top20List)
                    {
                        top20beforeRow = top20Table.Rows[top20CurrentRow];
                        top20Table.Rows.Add(ref top20beforeRow);
                        top20Table.Cell(top20CurrentRow, 1).Range.Text = ""+top20RowIndex;
                        top20Table.Cell(top20CurrentRow, 2).Range.Text = top20.tagname;
                        top20Table.Cell(top20CurrentRow, 3).Range.Text = top20.description;
                        top20Table.Cell(top20CurrentRow, 4).Range.Text = top20.area;
                        top20Table.Cell(top20CurrentRow, 5).Range.Text = ""+top20.count;
                        top20Table.Cell(top20CurrentRow, 6).Range.Text = ""+top20.percent;
                        top20CurrentRow++;
                        top20RowIndex++;
                    }
                }

                if (standingList != null && standingList.Count > 0)
                {
                    Word.Table standingTable = doc.Tables[3];
                    int standingCurrentRow = 2;
                    Object standingbeforeRow = null;
                    int standingRowIndex = 1;
                    foreach (AlarmStanding standing in standingList)
                    {
                        standingbeforeRow = standingTable.Rows[standingCurrentRow];
                        standingTable.Rows.Add(ref standingbeforeRow);
                        standingTable.Cell(standingCurrentRow, 1).Range.Text = ""+standingRowIndex;
                        standingTable.Cell(standingCurrentRow, 2).Range.Text = standing.tagname;
                        standingTable.Cell(standingCurrentRow, 3).Range.Text = standing.description;
                        standingTable.Cell(standingCurrentRow, 4).Range.Text = standing.area;
                        standingTable.Cell(standingCurrentRow, 5).Range.Text = standing.startTime;
                        standingTable.Cell(standingCurrentRow, 6).Range.Text = standing.endTime;
                        standingTable.Cell(standingCurrentRow, 7).Range.Text = ""+standing.alarmInterval;
                        standingCurrentRow++;
                        standingRowIndex++;
                    }
                }

                if (chartteringList != null && chartteringList.Count > 0)
                {
                    Word.Table chartteringTable = doc.Tables[4];
                    int chartteringCurrentRow = 2;
                    Object chartteringbeforeRow = null;
                    int chartteringRowIndex = 1;
                    foreach (AlarmChattering charttering in chartteringList)
                    {
                        chartteringbeforeRow = chartteringTable.Rows[chartteringCurrentRow];
                        chartteringTable.Rows.Add(ref chartteringbeforeRow);
                        chartteringTable.Cell(chartteringCurrentRow, 1).Range.Text = ""+chartteringRowIndex;
                        chartteringTable.Cell(chartteringCurrentRow, 2).Range.Text = charttering.tagname;
                        chartteringTable.Cell(chartteringCurrentRow, 3).Range.Text = charttering.description;
                        chartteringTable.Cell(chartteringCurrentRow, 4).Range.Text = charttering.area;
                        chartteringTable.Cell(chartteringCurrentRow, 5).Range.Text = ""+charttering.chatteringCount;
                        chartteringTable.Cell(chartteringCurrentRow, 6).Range.Text = ""+charttering.totalCount;
                        chartteringTable.Cell(chartteringCurrentRow, 7).Range.Text = ""+charttering.percent;
                        chartteringCurrentRow++;
                        chartteringRowIndex++;
                    }
                }



                //输出完毕后关闭doc对象
                String wordName = reportFilePath + reportTempName + "-001.doc";
                SaveDocument(app, doc, wordName);

                resultDict.Add("wordPath", reportTempName + "-001.doc");
                resultDict.Add("wordName", plantName + "报警分析报表" + startTime +"-"+ endTime+".doc");


            }
            catch (Exception e)
            {}
            finally {
                p.Close();
                 object miss = System.Reflection.Missing.Value;
                object missingValue = Type.Missing;
                object doNotSaveChanges = Microsoft.Office.Interop.Word.WdSaveOptions.wdDoNotSaveChanges;
                doc.Close(ref doNotSaveChanges, ref missingValue, ref missingValue);
                app.Quit(ref miss, ref miss, ref miss);
                doc = null;
                app = null;

               /******导出报表完成后删除服务器上的文件*******/
                for (int i = 0; i < 8; i++)
                {
                    string file_name = reportTempName + "_" + i;
                    //删除svg文件
                    string file = PhysicalPath + "temp\\" + file_name + ".svg";
                    System.IO.FileInfo nfile = new System.IO.FileInfo(file);
                    if (nfile.Exists)
                    {
                        nfile.Delete();
                    }
                    //删除png图片
                    string pngPath = PhysicalPath + "temp\\" + file_name + ".png";
                    System.IO.FileInfo pngfile = new System.IO.FileInfo(pngPath);
                    if (pngfile.Exists)
                    {
                        pngfile.Delete();
                    }
                }
                //删除生成的临时文档
                string tempDocPath = PhysicalPath + "uploads\\AnalysisReport\\" + reportTempName + ".doc";
                System.IO.FileInfo tempDocFile = new System.IO.FileInfo(tempDocPath);
                if (tempDocFile.Exists)
                {
                    tempDocFile.Delete();
                }

            }

            string result = jsonSerializer.Serialize(resultDict);
            context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    //保存新文件
    public void SaveDocument(Word.Application wordApp, Word.Document wordDoc, string filePath)
    {
        try
        {
            object fileName = filePath;
            object format = WdSaveFormat.wdFormatDocument;//保存格式
            object miss = System.Reflection.Missing.Value;
            wordDoc.SaveAs(ref fileName, ref format, ref miss,
              ref miss, ref miss, ref miss, ref miss,
              ref miss, ref miss, ref miss, ref miss,
              ref miss, ref miss, ref miss, ref miss,
              ref miss);
            //关闭wordDoc，wordApp对象
            object SaveChanges = WdSaveOptions.wdSaveChanges;
            object OriginalFormat = WdOriginalFormat.wdOriginalDocumentFormat;
            object RouteDocument = false;
           // wordDoc.Close(ref SaveChanges, ref OriginalFormat, ref RouteDocument);
          //  wordApp.Quit(ref SaveChanges, ref OriginalFormat, ref RouteDocument);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    //在书签处插入基本内容
    public void insertAtBookMark(Word.Document doc, Object bookMark, String text)
    {
        try
        {
            object what = Word.WdGoToItem.wdGoToBookmark;
            object missing = System.Reflection.Missing.Value;
            doc.ActiveWindow.Selection.GoTo(ref what, ref missing, ref missing, ref bookMark);
            doc.ActiveWindow.Selection.TypeText(text);
            doc.ActiveWindow.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    //杀掉winword.exe进程
    public void killWinWordProcess()
    {
        System.Diagnostics.Process[] processes = System.Diagnostics.Process.GetProcessesByName("WINWORD");
        foreach (System.Diagnostics.Process process in processes)
        {
            bool b = process.MainWindowTitle == "";
            if (process.MainWindowTitle == "")
            {
                process.Kill();
            }
        }
    }
    
    
}