<%@ WebHandler Language="C#" Class="organ_left_tree_data" %>

using System;  
using System.Web;  
using System.Configuration;  
using System.Data;
using System.Text;
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;
using System.Collections.Generic; 
//add  
using System.Web.Script.Serialization;

public class organ_left_tree_data : IHttpHandler  
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string parentOrganCode = context.Request.Form["parentOrganCode"];

        List<TreeNode> treeList = new List<TreeNode>();

        treeList = new SysManage().getOrgTreeNde(parentOrganCode);

        String organJson = BeanTools.ToJson(treeList);

        if (null != BeanTools.ToJson(treeList))
        {
            organJson = System.Text.RegularExpressions.Regex.Replace(organJson, "isChecked", "checked");
        }

        byte[] byteData = System.Text.Encoding.UTF8.GetBytes(organJson);
        context.Response.OutputStream.Write(byteData, 0, byteData.Length);

        context.Response.OutputStream.Flush();
    }
    public bool IsReusable  
    {  
        get  
        {  
            return false;  
        }  
    }  
}  
