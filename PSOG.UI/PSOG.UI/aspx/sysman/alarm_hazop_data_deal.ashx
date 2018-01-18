<%@ WebHandler Language="C#" Class="alarm_hazop_data_deal" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;

public class alarm_hazop_data_deal : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String flag = request.Form["flag"];
        if ("save".Equals(flag))
        {
            String plantId = request.Form["plantId"];
            String bitId = request.Form["bitId"];

            String hazopBiasValueH = request.Form["hazopBiasValueH"];
            String hazopRRH = request.Form["hazopRRH"];
            String hazopFH = request.Form["hazopFH"];
            String hazopSH = request.Form["hazopSH"];
            String hazopConseqH = request.Form["hazopConseqH"];
            String hazopPreventH = request.Form["hazopPreventH"];

            String hazopBiasValueL = request.Form["hazopBiasValueL"];
            String hazopRRL = request.Form["hazopRRL"];
            String hazopFL = request.Form["hazopFL"];
            String hazopSL = request.Form["hazopSL"];
            String hazopConseqL = request.Form["hazopConseqL"];
            String hazopPreventL = request.Form["hazopPreventL"];
            
            String paramJson = request.Form["paramJson"];
            String paramJsonLow = request.Form["paramJsonLow"];

            String message = new SysManage().saveHazopParamData(plantId,bitId,hazopBiasValueH,hazopRRH,hazopFH,hazopSH,hazopConseqH,hazopPreventH,
                                                                hazopBiasValueL,hazopRRL,hazopFL,hazopSL,hazopConseqL,hazopPreventL,paramJson,paramJsonLow);
            context.Response.Write(message);
        }
        else if ("baseInfo".Equals(flag)) {
            String plantId = request.Form["plantId"];
            String bitId = request.Form["bitId"];
            String hazopJson = new SysManage().getHazopParamInfo(plantId,bitId);
            context.Response.Write(hazopJson);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}