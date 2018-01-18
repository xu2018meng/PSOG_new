<%@ WebHandler Language="C#" Class="alarm_limit_deal_data" %>
using System.Web.Script.Serialization;
using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public class alarm_limit_deal_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string flag = context.Request.Form["flag"];
        string plantId = context.Request.Form["plantId"];
        if ("lineDict".Equals(flag)) {
            List<Dictionary<string, string>> lineList = new SysManage().getGridLineDict(plantId);
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            string lineJson = jsonSerializer.Serialize(lineList);
            context.Response.Write(lineJson);
        }
        else if ("deviceDict".Equals(flag)) {
            string lineId = context.Request.Form["lineId"];
            List<Dictionary<string, string>> deviceList = new SysManage().getGridDeviceDict(plantId,lineId);
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            string deviceJson = jsonSerializer.Serialize(deviceList);
            context.Response.Write(deviceJson);
        }
        else if ("checkIsExist".Equals(flag)) {
            string bitCode = context.Request.Form["bitCode"];
            string isExist = new SysManage().checkBitCodeIsExist(plantId,bitCode);
            context.Response.Write(isExist);
        }
        else if ("save".Equals(flag)) {
            String limitId = context.Request.Form["limitId"];
            String limitBitCode = context.Request.Form["limitBitCode"];
            String limitDCSCode = context.Request.Form["limitDCSCode"];
            String limitBitName = context.Request.Form["limitBitName"];
            String limitUnit = context.Request.Form["limitUnit"];
            String limitType = context.Request.Form["limitType"];
            String limitLineId = context.Request.Form["limitLineId"];
            String limitDeviceId = context.Request.Form["limitDeviceId"];
            String limitUpLine = context.Request.Form["limitUpLine"];
            String limitDownLine = context.Request.Form["limitDownLine"];
            String limitHHigh = context.Request.Form["limitHHigh"];
            String limitHigh = context.Request.Form["limitHigh"];
            String limitLLow = context.Request.Form["limitLLow"];
            String limitLow = context.Request.Form["limitLow"];
            String limitRemark = context.Request.Form["limitRemark"];
            string result = new SysManage().saveAlarmLimitInfo(plantId, limitId, limitBitCode, limitDCSCode, limitBitName, limitUnit,
                            limitType, limitLineId, limitDeviceId, limitUpLine, limitDownLine, limitHHigh, limitHigh, limitLLow,
                            limitLow,limitRemark);
            context.Response.Write(result);
        }
        else if ("delete".Equals(flag)) {
            string bitInfo = context.Request.Form["bitInfo"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Object> objectList = js.Deserialize<List<Object>>(bitInfo);
            string delMes = new SysManage().deleteAlarmLimitInfo(plantId, objectList);
            context.Response.Write(delMes);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}