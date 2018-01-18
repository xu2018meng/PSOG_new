<%@ WebHandler Language="C#" Class="menu_tree_for_role_menu_data" %>

using System;
using System.Web;
using PSOG.Bizc;
using PSOG.Entity;
using System.Collections.Generic;
using System.Collections;
using PSOG.Common;


public class menu_tree_for_role_menu_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string nodeId = context.Request.Form["nodeId"];
        string roleCode = context.Request.Form["roleId"];

        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().qrtMenuTreeNode(nodeId, roleCode);

        String headMenuJson = BeanTools.ToJson(treeList);

        if (null != headMenuJson)
        {
            headMenuJson = System.Text.RegularExpressions.Regex.Replace(headMenuJson, "isChecked", "checked");
        }

        byte[] byteData = System.Text.Encoding.UTF8.GetBytes(headMenuJson);
        context.Response.OutputStream.Write(byteData, 0, byteData.Length);

        context.Response.OutputStream.Flush();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}