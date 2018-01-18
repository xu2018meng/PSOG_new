<%@ WebHandler Language="C#" Class="tree_plant_new_data2" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class tree_plant_new_data2 : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        string nodeType = context.Request.Form["nodeType"];
        
        List<TreeNode> treeList = new List<TreeNode>();

        if ("plant".Equals(nodeType))
        { //打开装置下的单元

            treeList = new SysManage().queryHistoryMenuTreeNode(nodeId);
        }
        else if ("unit".Equals(nodeType))
        { //打开单元下的设备
            treeList = new SysManage().queryDeviceTreeNode(nodeId);
        }

        BeanTools.ToJson(context.Response.OutputStream, treeList);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}