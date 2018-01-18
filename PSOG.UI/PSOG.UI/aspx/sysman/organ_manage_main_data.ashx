<%@ WebHandler Language="C#" Class="organ_manage_mian_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
public class organ_manage_mian_data : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        String action = context.Request.Params["action"];
        //保存
        if (action.Equals("save"))
        {
            SysManage a = new SysManage();
            OrganiseUnit org = new OrganiseUnit();
            org.ID = Guid.NewGuid().ToString();
            //得到父节点组织的CODE

            org.SYS_ORGAN_P_CODE = context.Request.Params["SYS_ORGAN_P_CODE"];
            org.SYS_ORGAN_NAME = context.Request.Params["SYS_ORGAN_NAME"];
            org.SYS_ORGAN_CODE = Guid.NewGuid().ToString();
            org.SYS_ORGAN_TYPE = context.Request.Params["SYS_ORGAN_TYPE"];
            org.SYS_ORGAN_CRT_TIME = context.Request.Params["SYS_ORGAN_CRT_TIME"];
            org.SYS_ORGAN_ORDER = context.Request.Params["SYS_ORGAN_ORDER"];
            org.SYS_ORGAN_is_use = "1";
            int result = saveOrg(org);
            switch (result)
            {
                case 0: context.Response.Write("[0]"); break;
                case 1: context.Response.Write("[1]"); break;
                case 2: context.Response.Write("[2]"); break;
            }
        }
        //删除
        else if (action.Equals("delete"))
        {
            String[] ids = (context.Request.Params["ID"]).Split(',');
            int result = deleteOrg(ids);
            if (result == 0)
            {
                context.Response.Write("[]");
            }
        }
        //修改
        else if (action.Equals("update"))
        {
            String orgCode1 = (context.Request.Params["SYS_ORGAN_CRT_TIME"]);
            String orgCode = (context.Request.Params["SYS_ORGAN_CODE"]);
            String orgName = (context.Request.Params["SYS_ORGAN_NAME"]);
            String orgOrder = (context.Request.Params["SYS_ORGAN_ORDER"]);
            int result = updateOrg(orgCode, orgName, orgOrder);
            if (result == 0)
            {
                context.Response.Write("[0]");
            }
        }
        
        
    }
    public int saveOrg(OrganiseUnit org)
    {
        SysManage a = new SysManage();
        return a.saveOrganData(org);
        
    }
    public int  deleteOrg(String[] ids)
    {
        SysManage a = new SysManage();
        return a.deleteOrg(ids);
    }
    public int updateOrg(String orgCode, String orgName, String orgOrder)
    {
        SysManage a = new SysManage();
        return a.updateOrg(orgCode, orgName, orgOrder);
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}