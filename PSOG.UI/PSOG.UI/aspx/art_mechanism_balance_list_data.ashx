<%@ WebHandler Language="C#" Class="art_mechanism_balance_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class art_mechanism_balance_list_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.QueryString["plantId"];
        string pageNoStr = context.Request.Form["page"];
        string pageSizeStr = context.Request.Form["rows"];
        int pageNo = Convert.ToInt32(pageNoStr);
        int PageSize = Convert.ToInt32(pageSizeStr);
        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);
        EasyUIData grid = new SysManage().qryArtMechanismBalanceList(plant, pageNo, PageSize);

        BeanTools.ToJson(context.Response.OutputStream, grid);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}