<%@ WebHandler Language="C#" Class="quality_analysis_data" %>

using System;
using System.Web;
using PSOG.Common;
using System.Collections.Generic;
using PSOG.Entity;
using PSOG.Bizc;

public class quality_analysis_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        String page = context.Request.Form["page"];
        String rows = context.Request.Form["rows"];  //每页展示多少行
        String plantId = context.Request.QueryString["plantId"];
        string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        EasyUIData grid = new ArtTch().getQualityList(page, rows, plant);

        BeanTools.ToJson(context.Response.OutputStream, grid);  //转换成json格式并输出grid
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}