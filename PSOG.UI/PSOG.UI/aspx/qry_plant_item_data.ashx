<%@ WebHandler Language="C#" Class="qry_plant_item_data" %>

using System;
using System.Web;
using PSOG.Entity;
using PSOG.Common;


public class qry_plant_item_data : IHttpHandler, System.Web.SessionState.IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.Cache.SetNoStore();
        context.Response.Clear();
        
        context.Response.ContentType = "text/plain";
        String plantId = context.Request.QueryString["plantId"];

        String userId = ((SysUser)context.Session[CommonStr.session_user]).userId;
        string tableHtml = new PSOG.Bizc.MainPage().showPlantItem(plantId, userId);
        context.Response.Write(tableHtml);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}