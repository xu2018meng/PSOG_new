using System;
using System.Collections.Generic;
using System.Text;
using PSOG.Entity;

namespace PSOG.Common
{
    public class CommonStr
    {
        public static string applicationPath = "";  //项目路径，项目启动填充值
        public static String physicalPath = ""; //物理路径，项目启动填充值
        public static string monitorObject_Source = "PCA数据库"; //psog_processmonitorObject表中字段
        public static string unusualImgPath = @"C:\PESGraph\";   //异常工矿库图片地址
        public static string[] plantItem = new string[] { "", "主页", "工艺监测", "设备监测", "报警分析", "开停车导航", "装置知识" };
        public static string[] plantItemUri = new string[] { "", "aspx/main_page.aspx", 
            "aspx/art_check_main.aspx", "aspx/device_check_main.aspx", "aspx/alarm_analysis.aspx", "开停车导航", "" };
        public static string realDB = "realId"; //实时库检索名称
        public static string hisDB = "hisId";   //历史库检索名称
        public static string add_succ = "保存成功！";   
        public static string add_fail = "保存失败！";   
        public static string del_succ = "删除成功！";   
        public static string del_fail = "删除失败！";   
        public static string session_user = "PSOG_USER";
        public static string default_user_password = "21218CCA77804D2BA1922C33E0151105";
        public static string knowledge_manage_code = "006001"; //装置知识管理页面

    }
}
