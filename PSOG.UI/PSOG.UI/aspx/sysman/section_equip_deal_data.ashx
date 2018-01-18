<%@ WebHandler Language="C#" Class="section_equip_deal_data" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class section_equip_deal_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string flag = context.Request.Form["flag"];
        if ("save".Equals(flag)) { //保存信息
            string parentId = context.Request.Form["parentId"];
            string id = context.Request.Form["sectionId"];
            string name = context.Request.Form["sectionName"];
            string desc = context.Request.Form["sectionDesc"];
            string mark = context.Request.Form["sectionMark"];
            string type = context.Request.Form["type"];
            if ("section".Equals(type))
            {
                String message = new SysManage().saveSectionInfo(parentId,id,name,desc,mark);
                context.Response.Write(message);
            }
            else {
                String message = new SysManage().saveSectionEquipInfo(parentId, id, name, desc, mark);
                context.Response.Write(message);
            }
        }
        else if ("delete".Equals(flag))
        {
            string type = context.Request.Form["type"];
            string parentId = context.Request.Form["parentId"];
            string sectionInfo = context.Request.Form["sectionInfo"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Object> objectList = js.Deserialize<List<Object>>(sectionInfo);
            if ("section".Equals(type))
            {
                String message = new SysManage().delSection(parentId, objectList);
                context.Response.Write(message);
            }
            else
            {
                String message = new SysManage().delSectionEquip(parentId, objectList);
                context.Response.Write(message);
            }
        }
       
       
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}