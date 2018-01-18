<%@ WebHandler Language="C#" Class="alarm_analysis_outline_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections;
using System.Text;
using System.Data;
using System.IO;

public class alarm_analysis_outline_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime"];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        String id = context.Request.QueryString["id"];
        String dbSource = null == context.Request.Form["dbSource"] ? context.Request.QueryString["dbSource"] : context.Request.Form["dbSource"];
        
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "30" : context.Request.Params["rows"]);

        EasyUIData grid = new EasyUIData();
        IList list = new ArrayList();
        IList list_final = new ArrayList();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            if(id == "1")
            {
                AlarmLevelTotal ALT_level = new AlarmLevelTotal();
                AlarmLevelTotal ALT_average = new AlarmLevelTotal();
                AlarmLevelTotal ALT_max = new AlarmLevelTotal();
                AlarmLevelTotal ALT_disturb = new AlarmLevelTotal();
                grid = new AlarmAnalysis().alarmAnaysisOutline(startTime, endTime, DBName,dbSource);
                
                //将报警等级写入文件
                string startTimeCopy = startTime;
                string endTimeCopy = endTime;

                startTimeCopy = startTime.Replace(":", "").Replace("-", "").Replace(" ", "");
                endTimeCopy = endTime.Replace(":", "").Replace("-", "").Replace(" ", "");
                
                //File.Delete(".\\PSOG.UI\\aspx\\alarm_level_data\\" + plantId + startTimeCopy + endTimeCopy + ".html");
                FileStream fs = new FileStream(context.Request.PhysicalApplicationPath+"aspx\\alarm_level_data\\" + plantId + startTimeCopy + endTimeCopy + ".html", FileMode.OpenOrCreate, FileAccess.ReadWrite);
                StreamWriter m_StreamWriter = new StreamWriter(fs);
                m_StreamWriter.BaseStream.Seek(0, SeekOrigin.Begin);
                m_StreamWriter.Write(BeanTools.ToJson(grid.rows)); 
                m_StreamWriter.Flush();
                m_StreamWriter.Close();
                fs.Close();
                
                string level_name = "";
                string level_goal = "";
                double average_num = 0.0;
                double average_goal = 0.0;
                double max_num = 0.0;
                double max_goal = 0.0;
                double disturb_num = 0.0;
                double disturb_goal = 0.0;
                foreach (AlarmLevel tc in grid.rows)
                {
                    if(tc.area == "装置")
                    {
                        level_name = tc.level;
                        level_goal = tc.level_goal;
                        average_num = tc.averagerate;
                        average_goal = tc.averagerate_goal;
                        max_num = tc.maxrate;
                        max_goal = tc.maxrate_goal;
                        disturb_num = tc.disturbrate;
                        disturb_goal = tc.disturbrate_goal;    
                    }
                }
                ALT_average.index_name = "平均报警率";
                ALT_average.index_goal = average_goal.ToString();
                ALT_average.plant_num = average_num.ToString();
                ALT_average.remark = "在指定时间范围内，每操作员每10分钟的平均报警次数。";

                ALT_disturb.index_name = "扰动率";
                ALT_disturb.index_goal = "小于"+disturb_goal+"%";
                ALT_disturb.plant_num = disturb_num*100+"%";
                ALT_disturb.remark = "将指定时间范围分成连续的10分钟时间段，报警次数超过5次的10分钟时间段数除以总的10分钟时间段数。";

                ALT_level.index_goal = level_goal;
                ALT_level.index_name = "报警系统等级";
                ALT_level.plant_num = level_name;
                ALT_level.remark = "在指定时间范围内，根据平均报警率和最大报警率将报警系统划分为5个等级，从高到低分别为'可预测的'、'鲁棒的'、'稳定的'、'反应性的'和'超负荷的'。";

                ALT_max.index_name = "最大报警率";
                ALT_max.index_goal = max_goal.ToString();
                ALT_max.plant_num = max_num.ToString();
                ALT_max.remark = "在指定时间范围内，每操作员每10分钟的最大报警次数。";

                AlarmLevelTotal ALT_priority = new AlarmLevelTotal();
                list = new AlarmAnalysis().alarmAnaysisDistributionByPriority(startTime, endTime, DBName,dbSource);
                double highPercent = 0.0;
                double mediumPercent = 0.0;
                double lowPercent = 0.0;
                foreach(AlarmPriority tc in list)
                {
                    highPercent = tc.highPercent;
                    mediumPercent = tc.mediumPercent;
                    lowPercent = tc.lowPercent;
                }
                ALT_priority.index_name = "优先级分布";
                ALT_priority.index_goal = "'高'约5%，'中'约15%，'低'约80%";
                ALT_priority.plant_num = "'高'为" + highPercent + "%，'中'为" + mediumPercent + "%，'低'为" + lowPercent + "%";
                ALT_priority.remark = "在指定时间范围内，统计报警次数的优先级分布情况。";
                
                AlarmLevelTotal ALT_top10 = new AlarmLevelTotal();
                grid = new AlarmAnalysis().alarmAnaysisTop20(startTime, endTime, DBName,dbSource);
                int flag = 0;
                double percent_sum = 0.0;
                foreach (AlarmTop20 tc in grid.rows)
                {
                    if (flag < 10) 
                    {
                        percent_sum = percent_sum + tc.percent;
                        flag = flag + 1;
                    }
                }
                ALT_top10.index_name = "Top 10报警次数百分比";
                ALT_top10.index_goal = "约1%到5%";
                ALT_top10.plant_num = percent_sum+"%";
                ALT_top10.remark = "单一变量排名前10位的报警次数之和占报警总数百分比，反映报警系统整体设计是否合理。";

                AlarmLevelTotal ALT_standing = new AlarmLevelTotal();
                grid = new AlarmAnalysis().alarmAnaysisStanding(startTime, endTime, DBName,dbSource);
                int flag_num = 0;
                foreach (AlarmStanding tc in grid.rows)
                { 
                    if(tc.alarmInterval > 8*60)
                    {
                        flag_num = flag_num + 1;
                    }
                }
                ALT_standing.index_name = "持续时间超过8小时的报警次数";
                ALT_standing.index_goal = "小于5个";
                ALT_standing.plant_num = flag_num+"个";
                ALT_standing.remark = "单个报警持续时间的统计。";

                AlarmLevelTotal ALT_chattering = new AlarmLevelTotal();
                grid = new AlarmAnalysis().alarmAnaysisChattering(startTime, endTime, DBName,dbSource);
                flag_num = 0;
                foreach (AlarmChattering tc in grid.rows)
                {
                    if (tc.chatteringCount > 0)
                    {
                        flag_num = flag_num + 1;
                    }
                }
                ALT_chattering.index_name = "重复报警个数";
                ALT_chattering.index_goal = "0个";
                ALT_chattering.plant_num = flag_num + "个";
                ALT_chattering.remark = "对于单一变量，在短时间内报警触发2次或以上，称为重复报警。本系统指定任意连续5分钟内，报警触发2次或以上，为一次重复报警。";

                list_final.Add(ALT_level);
                list_final.Add(ALT_average);
                list_final.Add(ALT_max);
                list_final.Add(ALT_disturb);
                list_final.Add(ALT_priority);
                list_final.Add(ALT_top10);
                list_final.Add(ALT_standing);
                list_final.Add(ALT_chattering);
            }else
            {
                grid = new AlarmAnalysis().alarmAnaysisOutline(startTime, endTime, DBName,dbSource);
                list_final = grid.rows;
            }
            
        }

        BeanTools.ToJson(context.Response.OutputStream, list_final);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}