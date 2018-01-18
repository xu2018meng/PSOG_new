<%@ WebHandler Language="C#" Class="role_tree_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class role_tree_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string userId = context.Request.QueryString["userId"];

        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().qrtRoleTree(userId);

        String roleJson = BeanTools.ToJson(treeList);

        if (null != roleJson)
        {
            roleJson = System.Text.RegularExpressions.Regex.Replace(roleJson, "isChecked", "checked");
        }

        byte[] byteData = System.Text.Encoding.UTF8.GetBytes(roleJson);
        context.Response.OutputStream.Write(byteData, 0, byteData.Length);

        context.Response.OutputStream.Flush();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}