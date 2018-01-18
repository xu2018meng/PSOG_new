<%@ WebHandler Language="C#" Class="sys_manage_tree_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class sys_manage_tree_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        String userId = context.Request.Form["userId"];
        
        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().loadManageTree(userId, nodeId);

        BeanTools.ToJson(context.Response.OutputStream, treeList);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}