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


public partial class alarm_analysis_export_new : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            String wordPath = Request["wordPath"];
            wordPath = null == wordPath ? "" : wordPath;
            String wordName = Request["wordName"];
            wordName = null == wordName ? "" : wordName;
            string filePath = Request.PhysicalApplicationPath + "uploads\\AnalysisReport\\" + wordPath;//路径
            if (File.Exists(filePath))
            {
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/ms-word";
                //通知浏览器下载文件而不是打开
                Response.AppendHeader("Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode(wordName, System.Text.Encoding.UTF8));
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
