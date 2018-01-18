<%@ WebHandler Language="C#" Class="craft_param_change_exam_deal" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class craft_param_change_exam_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String flag = request.Form["flag"];
        if ("submit".Equals(flag))
        {
            String plantId = request.Form["plantId"];
            String processId = request.Form["processId"];
            String productExam = request.Form["productExam"];
            String meterExam = request.Form["meterExam"];
            String satrapExam = request.Form["satrapExam"];
            String isFinal = request.Form["isFinal"];
            String message = new SysManage().craftParamExamSubmit(plantId, processId, productExam, meterExam, satrapExam, isFinal);
            context.Response.Write(message);
        }
        else if ("back".Equals(flag)) {
            String plantId = request.Form["plantId"];
            String processId = request.Form["processId"];
            String productExam = request.Form["productExam"];
            String meterExam = request.Form["meterExam"];
            String satrapExam = request.Form["satrapExam"];

            String message = new SysManage().craftParamExamBack(plantId, processId, productExam, meterExam, satrapExam);
            context.Response.Write(message);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}