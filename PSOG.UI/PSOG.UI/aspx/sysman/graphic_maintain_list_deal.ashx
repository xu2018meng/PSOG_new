<%@ WebHandler Language="C#" Class="graphic_maintain_list_deal" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.IO;
using System.Collections;
using System.Web.Script.Serialization;
using System.Collections.Generic;

public class graphic_maintain_list_deal : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
       
        context.Response.ContentType = "text/plain";
        string flag = context.Request.QueryString["flag"];
        string plantId = context.Request.QueryString["plantId"];
        if ("upload".Equals(flag))
        {
            // 文件上传后的保存路径
            string filePath = context.Request.MapPath("~/uploads/Graphic/");
            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }
            HttpFileCollection files = context.Request.Files;//上下文文件数组

            string fileName = Path.GetFileName(files[0].FileName);// 原始文件名称
            string fileExtension = Path.GetExtension(fileName); // 文件扩展名

            string pkId = context.Request.QueryString["pkId"];
            string saveName = Guid.NewGuid().ToString() + fileExtension; // 保存文件名称
           
            files[0].SaveAs(filePath + saveName);
            
            //保存记录
            new SysManage().SaveFiles(plantId, pkId, fileName, "/uploads/Graphic/" + saveName);

            String message = filePath + saveName;
            context.Response.Write(message);
        }
        else if ("saveRecord".Equals(flag)) {
            String PicId = context.Request.Form["PicId"];
            String PicName = context.Request.Form["PicName"];
            String PicNum = context.Request.Form["PicNum"];
            String saveOrUpdate = context.Request.Form["saveOrUpdate"];

            string message = new SysManage().SaveGraphicRecord(plantId, PicId, PicName, Convert.ToInt32(PicNum), saveOrUpdate);
            context.Response.Write(message);
        }
        else if ("getFile".Equals(flag)) {
            string sheetId = context.Request.Form["sheetId"];
            ArrayList list = new SysManage().queryFileList(plantId, sheetId);
            BeanTools.ToJson(context.Response.OutputStream, (object)list);
        }
        else if ("delFile".Equals(flag)) {
            string AnnexId = context.Request.Form["AnnexId"];
            string filePath = new SysManage().queryFilePath(plantId,AnnexId);
            //删除记录
            String message = new SysManage().delFile(plantId,AnnexId);
            
            //删除文件
            filePath = context.Request.MapPath("~" + filePath);
            System.IO.FileInfo nfile = new System.IO.FileInfo(filePath);
            if (nfile.Exists)
            {
                nfile.Delete();
            }
            context.Response.Write(message);
        }
        else if ("delRecord".Equals(flag)) {
            string recordStr = context.Request.Form["recordArr"];
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<string> recordList = js.Deserialize<List<string>>(recordStr);
            //查询文件路径
            List<string> pathList = new SysManage().queryFilesPath(plantId, recordList);
            //删除记录
            string message = new SysManage().delGraphicRecord(plantId, recordList);
            
            //删除服务器上的文件
            if (message == "1") {
                foreach (string path in pathList) {
                    //删除文件
                    string filePath = context.Request.MapPath("~" + path);
                    System.IO.FileInfo nfile = new System.IO.FileInfo(filePath);
                    if (nfile.Exists)
                    {
                        nfile.Delete();
                    }
                }
            }
            
            context.Response.Write(message);
        }
        else if ("getGraphic".Equals(flag)) {
            string SheetId = context.Request.Form["SheetId"];
            string filePath = new SysManage().queryFilePathBySheetId(plantId,SheetId);
            filePath = "../.." + filePath;
            context.Response.Write(filePath);
        }
        else if ("savePoint".Equals(flag)) {
            string pointId = context.Request.Form["pointId"];
            string pointX = context.Request.Form["pointX"];
            string pointY = context.Request.Form["pointY"];
            string bitNo = context.Request.Form["bitNo"];
            string picId = context.Request.Form["picId"];
            string saveOrUpdate = context.Request.Form["saveOrUpdate"];
            
            string  message = new SysManage().SaveGraphicPoint(plantId,pointId,pointX,pointY,bitNo,picId,saveOrUpdate);
            context.Response.Write(message);
        }
        else if ("getPoints".Equals(flag)) {
            string picId = context.Request.Form["picId"];
            List<GraphicPoint> list = new SysManage().queryGraphicPoints(plantId,picId);
            BeanTools.ToJson(context.Response.OutputStream, (object)list);
        }
        else if ("getSelectPoints".Equals(flag)) {
            string startX = context.Request.Form["startX"];
            string endX = context.Request.Form["endX"];
            string startY = context.Request.Form["startY"];
            string endY = context.Request.Form["endY"];
            List<GraphicPoint> list = new SysManage().querySelectPoints(plantId,startX,endX,startY,endY);
            BeanTools.ToJson(context.Response.OutputStream, (object)list);
        }
        else if ("delPoints".Equals(flag)) {
            string startX = context.Request.Form["startX"];
            string endX = context.Request.Form["endX"];
            string startY = context.Request.Form["startY"];
            string endY = context.Request.Form["endY"];
            string message = new SysManage().delPoints(plantId, startX, endX, startY, endY);
            context.Response.Write(message);    
        }
       
        
    }


 
    public bool IsReusable {
        get {
            return false;
        }
    }

}