<%@ WebHandler Language="C#" Class="user_select_tree_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class user_select_tree_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string parentId = context.Request.Form["nodeId"];
        string type = context.Request.Form["type"];

        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().queryUserSelectDeptUserNode(parentId,type);

        String organJson = BeanTools.ToJson(treeList);

        if (null != BeanTools.ToJson(treeList))
        {
            organJson = System.Text.RegularExpressions.Regex.Replace(organJson, "isChecked", "checked");
        }

        byte[] byteData = System.Text.Encoding.UTF8.GetBytes(organJson);
        context.Response.OutputStream.Write(byteData, 0, byteData.Length);

        context.Response.OutputStream.Flush();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}