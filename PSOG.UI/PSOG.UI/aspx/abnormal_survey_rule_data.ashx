<%@ WebHandler Language="C#" Class="abnormal_survey_rule_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;

public class abnormal_survey_rule_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String id = request.Form["id"];
        String plantId = request.Form["plantId"];
        String rule = request.Form["rule"];
        String time1 = request.Form["time1"];
        String man1 = request.Form["man1"];
        String manName1 = request.Form["manName1"];
        String time2 = request.Form["time2"];
        String man2 = request.Form["man2"];
        String manName2 = request.Form["manName2"];
        String time3 = request.Form["time3"];
        String man3 = request.Form["man3"];
        String manName3 = request.Form["manName3"];
        String message = new SysManage().saveAbnormalStateRule(id, plantId, rule, time1, man1, manName1,
                                                      time2, man2, manName2, time3, man3, manName3);
        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}