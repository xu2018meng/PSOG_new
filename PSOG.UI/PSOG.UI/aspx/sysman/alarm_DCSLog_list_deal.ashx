<%@ WebHandler Language="C#" Class="alarm_DCSLog_list_deal" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.IO;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public class alarm_DCSLog_list_deal : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
       
        context.Response.ContentType = "text/plain";
        string flag = context.Request.QueryString["flag"];

        if ("upload".Equals(flag))
        {
            // 文件上传后的保存路径
            string filePath = context.Request.MapPath("~/uploads/");
            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }
            string saveName = Guid.NewGuid().ToString() + ".txt"; // 保存文件名称
            HttpFileCollection files = context.Request.Files;
            files[0].SaveAs(filePath + saveName);

            String message = filePath + saveName;
            context.Response.Write(message);
        }
        else if ("grid".Equals(flag)) {
            EasyUIData grid = new EasyUIData();

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else if ("dataGrid".Equals(flag)) {
            string plantId = context.Request.Form["plantId"];
            string flagId = context.Request.Form["flagId"];
            string pageSizeStr = context.Request.Form["rows"];
            string pageNoStr = context.Request.Form["page"];
            int pageSize = 20, pageNo = 1;
            if (!string.IsNullOrEmpty(pageSizeStr) && !string.IsNullOrEmpty(pageNoStr))
            {
                try
                {
                    pageSize = Convert.ToInt32(pageSizeStr);
                    pageNo = Convert.ToInt32(pageNoStr);
                }
                catch (Exception exp)
                {
                    pageSize = 20;
                    pageNo = 1;
                }
            }

            EasyUIData grid = new SysManage().queryAlarmDCSLogFromTemp(plantId,flagId,pageNo,pageSize);
            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else if ("uploadDCSLog".Equals(flag)) {
            string plantId = context.Request.Form["plantId"];
            string filePath = context.Request.Form["filePath"];
            string paramFlagId = context.Request.Form["paramFlagId"];
            String message = new SysManage().uploadDCSLog(plantId, filePath, paramFlagId);
            context.Response.Write(message);
        }
        else if ("delTempFileData".Equals(flag)) {
            string plantId = context.Request.Form["plantId"];
            string flagId = context.Request.Form["flagId"];
            string filePath = context.Request.Form["filePath"];
            //删除临时文件
            System.IO.FileInfo nfile = new System.IO.FileInfo(filePath);
            if (nfile.Exists)
            {
                nfile.Delete();
            }
            //删除临时数据
            String message = new SysManage().delDCSLogTempData(plantId,flagId);
            context.Response.Write(message);
        }
        else if ("saveDCS".Equals(flag)) {
            String plantId = context.Request.Form["plantId"];
            string flagId = context.Request.Form["flagId"];
            string initStartTime = context.Request.Form["initStartTime"];
            string initEndTime = context.Request.Form["initEndTime"];
            String message = new SysManage().saveDCSLog(plantId,flagId,initStartTime,initEndTime);
            context.Response.Write(message);
        }
        else if ("delDCS".Equals(flag)) {
            String plantId = context.Request.Form["plantId"];
            string logInfo = context.Request.Form["logInfo"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<string> logIds = js.Deserialize<List<string>>(logInfo);
            string delMes = new SysManage().deleteDCSLogInfo(plantId, logIds);
            context.Response.Write(delMes);
        }
        else if ("isExistDCS".Equals(flag))
        {
            String plantId = context.Request.Form["plantId"];
            string initStartTime = context.Request.Form["initStartTime"];
            string initEndTime = context.Request.Form["initEndTime"];
            String message = new SysManage().isExistDCSLog(plantId,initStartTime,initEndTime);
            context.Response.Write(message);
        }
        
    }


 
    public bool IsReusable {
        get {
            return false;
        }
    }

}