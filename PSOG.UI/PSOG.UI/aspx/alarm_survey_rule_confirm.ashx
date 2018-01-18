<%@ WebHandler Language="C#" Class="alarm_survey_rule_confirm" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class alarm_survey_rule_confirm : IHttpHandler
{
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String id = request.Form["id"];
        String plantId = request.Form["plantId"];
        String userId = request.Form["userId"];
        String userName = request.Form["userName"];

        String message = new SysManage().confirmAlarm(plantId, id,userId,userName);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}