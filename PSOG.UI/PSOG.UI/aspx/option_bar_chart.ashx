<%@ WebHandler Language="C#" Class="chart" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Entity;
using PSOG.Bizc;

public class chart : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String startTime = null == context.Request.Form["startTime"] ? context.Request.QueryString["startTime"] : context.Request.Form["startTime "];
        String endTime = null == context.Request.Form["endTime"] ? context.Request.QueryString["endTime"] : context.Request.Form["endTime"];
        String plantId = context.Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        int page = int.Parse(null == context.Request.Params["page"] ? "1" : context.Request.Params["page"]);
        int rows = int.Parse(null == context.Request.Params["rows"] ? "10" : context.Request.Params["rows"]);

        EasyUIData grid = new EasyUIData();

        if (null != startTime && "" != startTime && null != endTime && "" != endTime)
        {
            DateTime startDate = new DateTime(), endDate = new DateTime();
            if (null != startTime && "" != startTime) startDate = DateTime.Parse(startTime);
            if (null != endTime && "" != endTime) endDate = DateTime.Parse(endTime);

            grid = new AlarmAnalysis().StableRateAnaly(startDate, endDate, plant, page, rows);
        }
        string FIC = null;
        string LIC = null;
        string PI = null; ;
        string TI103 = null;
        string TI115 = null;
        //带生成xml文件
        string xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?> \n"
            + "<anychart>\n"
            + "<charts>\n"
            + "<chart plot_type=\"CategorizedVertical\">\n"
            + "<data>\n";
            xml+= "<series name=\"Year 2003\" type=\"Bar\">\n";
            foreach(StableRateAlarm sra in grid.rows){
                xml += "<point name=\"" + sra.insItems + "\" y=\"" + sra.insCpkLSL;
                xml+="\" color=\"";
                if(sra.insCpkLSL<0){
                    xml += "red";
                }
                else if (sra.insCpkLSL < 10 && sra.insCpkLSL > 0)
                {
                    xml += "orange";
                }
                else if (sra.insCpkLSL > 10 && sra.insCpkLSL < 50)
                {
                    xml += "yellow";
                }
                else
                {
                    xml += "green";
                }
              
                xml += "\" />\n";
            }
        
            //xml+= "<point name=\"alarm.id\" y=\"3.5\" color=\"red\" />\n";
            //xml+= "<point name=\"LIC1324.PV\" y=\"1.1\" color=\"orange\" />\n";
            //xml+= "<point name=\"PI1320.PV\" y=\"1.5\" color=\"green\"/>\n";
            //xml+= "<point name=\"TI1103G.PV\" y=\"6.2\"  color=\"red\"/>\n";
            //xml += "<point name=\"TI1115.PV\" y=\"5.8\" color=\"orange\"/>\n";
            xml+= "</series>\n"
            + "</data>\n"
            + "<chart_settings>\n"
            + "<title>\n<text>报警等级分布</text>\n</title>\n<axes>\n<y_axis>\n<title>\n<text>值</text>\n</title>\n</y_axis>"
            + "<x_axis>\n<labels align=\"Outside\" />\n<title>\n<text>位号</text>\n</title>\n</x_axis>\n</axes>\n</chart_settings>\n</chart>\n</charts>\n</anychart>";

        context.Response.Write(xml);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}