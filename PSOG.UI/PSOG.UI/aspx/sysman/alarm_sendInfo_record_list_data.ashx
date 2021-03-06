﻿<%@ WebHandler Language="C#" Class="alarm_sendInfo_record_list_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class alarm_sendInfo_record_list_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
       
        context.Response.ContentType = "text/plain";
        string plantId = context.Request.Form["plantId"];
        if (string.IsNullOrEmpty(plantId))
        {
            EasyUIData grid = new EasyUIData();

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        else {
            string tagName = context.Request.Form["tagName"];
            string tagDesc = context.Request.Form["tagDesc"];
            string type = context.Request.Form["type"];
            string toUserName = context.Request.Form["toUserName"];
            string startTime = context.Request.Form["startTime"];
            string endTime = context.Request.Form["endTime"];
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

            EasyUIData grid = new EasyUIData();
            grid = new SysManage().queryAlarmMessageRecordList(plantId,tagName,tagDesc,type,startTime,endTime,toUserName,pageNo,pageSize);

            BeanTools.ToJson(context.Response.OutputStream, grid);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}