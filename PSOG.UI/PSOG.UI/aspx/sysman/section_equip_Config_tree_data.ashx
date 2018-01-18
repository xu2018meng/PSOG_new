<%@ WebHandler Language="C#" Class="section_equip_Config_tree_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;

public class section_equip_Config_tree_data : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) {
        
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        string nodeType = context.Request.Form["nodeType"];
        
        List<TreeNode> treeList = new List<TreeNode>();

        if ("plant".Equals(nodeType))
        { //打开装置下的单元

            treeList = new SysManage().queryDeviceConfigTreeNode(nodeId);
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