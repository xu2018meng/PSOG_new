<%@ WebHandler Language="C#" Class="tree_plant_new_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class tree_plant_new_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        
        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().queryBitTreeNode(nodeId);

        BeanTools.ToJson(context.Response.OutputStream, treeList);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}