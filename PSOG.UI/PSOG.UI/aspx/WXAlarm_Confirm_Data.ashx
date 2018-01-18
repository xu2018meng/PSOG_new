<%@ WebHandler Language="C#" Class="abnormal_survey_rule_confirm" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class abnormal_survey_rule_confirm : IHttpHandler
{
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String plantId = request.Form["plantId"];
        String userId = request.Form["userId"];
        string recordId = request.Form["recordId"];
        string messageType = request.Form["messageType"];
        //获取用户名
        string userName = new SysManage().GetUserNameById(userId);

        String message = "";
        if ("Alarm".Equals(messageType)) {//报警
            message = new SysManage().confirmAlarm(plantId, recordId, userId, userName);
        }
        else if ("EarlyAlarm".Equals(messageType)) {//预警
            message = new SysManage().confirmEarlyAlarm(plantId, recordId, userId, userName);
        }
        else if ("Abnormal".Equals(messageType)) {//异常
            message = new SysManage().confirmAbnormalState(plantId, recordId, userId, userName);
        }
        
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}