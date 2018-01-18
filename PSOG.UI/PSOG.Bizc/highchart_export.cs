using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;
//using System.Linq;
using Svg;
using System.Drawing.Imaging;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Text;

namespace PSOG.Bizc
{
    public class highchart_export : System.Web.UI.Page
    {
        public void export_png(String tSvg)
        {
            string tFileName = "chart";
            string tType = "image/png";
            MemoryStream tData = new MemoryStream(Encoding.UTF8.GetBytes(tSvg));
            MemoryStream tStream = new MemoryStream();
            string tExt = "png";
            try {
                Svg.SvgDocument tSvgObj = SvgDocument.Open(tData);
                tSvgObj.Draw().Save("D:\\PSOG.UI\\chart.bmp", ImageFormat.Bmp);
                
            }
            catch(Exception e){
                System.Console.WriteLine(e);
            }
            
            
        }

    }
}
