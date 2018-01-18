<%@ WebHandler Language="C#" Class="craft_param_change_apply_deal" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class craft_param_change_apply_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String flag = request.Form["flag"];
        if ("saveOrSubmit".Equals(flag))
        {
            String plantId = request.Form["plantId"];
            String plantName = request.Form["plantName"];
            String processId = request.Form["processId"];
            String executeDate = request.Form["executeDate"];
            String replyDate = request.Form["replyDate"];
            String applyData = request.Form["applyData"];
            String changeReason = request.Form["changeReason"];
            String protectMeasure = request.Form["protectMeasure"];
            String productExamId = request.Form["productExamId"];
            String productExamName = request.Form["productExamName"];
            String meterExamId = request.Form["meterExamId"];
            String meterExamName = request.Form["meterExamName"];
            String satrapExamId = request.Form["satrapExamId"];
            String satrapExamName = request.Form["satrapExamName"];
            String paramJson = request.Form["paramJson"];
            String runIndex = request.Form["runIndex"];
            String applyUserId = request.Form["applyUserId"];
            String message = new SysManage().saveOrSubmitCraftChangeApply(plantId, processId, executeDate, replyDate, applyData,
                changeReason, protectMeasure, productExamId, productExamName, meterExamId, meterExamName, satrapExamId, satrapExamName, plantName, runIndex, paramJson, applyUserId);
            context.Response.Write(message);
        }
        else if ("delete".Equals(flag)) {
            String plantId = request.Form["plantId"];
            String paramJson = request.Form["paramJson"];
            
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<String> processIdList = js.Deserialize<List<String>>(paramJson);

            String message = new SysManage().delCraftParamApplyData(plantId,processIdList);

            context.Response.Write(message);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}