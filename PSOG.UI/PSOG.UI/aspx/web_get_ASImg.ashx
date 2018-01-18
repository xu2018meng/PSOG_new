<%@ WebHandler Language="C#" Class="web_get_img" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using System.IO;
using PSOG.Entity;

public class web_get_img : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        HttpResponse response = context.Response;
        HttpRequest request = context.Request;
        string fileId = request.QueryString["fileId"];
        string plantId = request.QueryString["plantId"];
        string name = request.QueryString["name"];
       // string DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        string DBName = plant.realTimeDB;
        fileId = "a" == fileId && DBName.Length > 13 ? DBName.Substring(13) : fileId;
        
        string filePath = CommonStr.unusualImgPath;//路径

        filePath = Common.getFilePath(name, plant);

        //以字符流的形式下载文件
        if ("" != filePath && File.Exists(filePath))
        {
            FileStream fs = new FileStream(filePath, FileMode.Open);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();
            response.ContentType = "application/octet-stream";
            //通知浏览器打开文件
            response.AddHeader("Content-Disposition", "inline;  filename=" + HttpUtility.UrlEncode(fileId, System.Text.Encoding.UTF8));
            response.BinaryWrite(bytes);
            response.Flush();
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}