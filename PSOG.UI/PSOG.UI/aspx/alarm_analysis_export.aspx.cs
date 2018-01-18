using System;
using System.Collections;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;
//using Svg;
using System.Drawing.Imaging;
//using iTextSharp.text;
//using iTextSharp.text.pdf;
using System.Text;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Diagnostics;


public partial class aspx_alarm_analysis_export : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            String plantId = Request["plantId"];
            plantId = null == plantId ? "" : plantId;
            String startTime = Request["startTime"];
            String endTime = Request["endTime"];

            string sTime = startTime.Replace(":", "").Replace("-", "").Replace(" ", "");
            string eTime = endTime.Replace(":", "").Replace("-", "").Replace(" ", "");

            string plantName = "";
            if (plantId == "JJSH_CJYYT")
            {
                plantName = "1#常减压";
            }
            if (plantId == "JJSH_CLHCJ")
            {
                plantName = "1#催化裂化";
            }
            if (plantId == "JJSH_YJHYT")
            {
                plantName = "延迟焦化";
            }
            if (plantId == "ZHLH_YCJY")
            {
                plantName = "1#常减压";
            }
            string fileName = plantName + "报警分析报表 " + sTime + "-" + eTime + ".doc";//客户端保存的文件名
            string filePath = Request.PhysicalApplicationPath + "temp\\" + plantId + sTime + eTime + ".doc";//路径

            if (File.Exists(filePath))
            {
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/ms-word";
                //通知浏览器下载文件而不是打开
                Response.AppendHeader("Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
                Response.TransmitFile(filePath);
                Response.Flush();
                Response.End();
            }
            else
            {
                String script = "<script>alert('导出失败，请重新导出！');</script>";
                byte[] byteData = System.Text.Encoding.UTF8.GetBytes(script);
                Response.OutputStream.Write(byteData, 0, byteData.Length);
            }

        }
    }
}
