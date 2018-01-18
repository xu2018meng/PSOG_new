<%@ WebHandler Language="C#" Class="menu_tree_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class menu_tree_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        
        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().qrtMenuTreeNode(nodeId, "");

        BeanTools.ToJson(context.Response.OutputStream, treeList);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}