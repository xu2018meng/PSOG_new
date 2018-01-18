<%@ WebHandler Language="C#" Class="img_exist" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using System.IO;
using PSOG.Entity;
public class img_exist : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        HttpResponse response = context.Response;
        HttpRequest request = context.Request;

        string fileId = request.QueryString["fileId"];
        string plantId = (request.QueryString["plantId"]);
        string name = request.QueryString["name"];
        //string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        string DBName = plant.realTimeDB;
        fileId = "a" == fileId && DBName.Length > 13 ? DBName.Substring(13) : fileId;

        string filePath = CommonStr.unusualImgPath;//路径

        filePath = Common.getFilePath(name, plant);

        //以字符流的形式下载文件
        if ("" != filePath && File.Exists(filePath))
        {
            response.Write("yes");
        }
        else
        {
            response.Write("no");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}