<%@ WebHandler Language="C#" Class="add_user_data" %>

using System;
using System.Web;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using System.Configuration;

public class add_user_data : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        HttpRequest request = context.Request;
        String isDel = request.Form["isDel"];
        String userId = request.Form["userId"];
        String message = "";

        string WXOrgId = ConfigurationManager.AppSettings["WXOrgId"];//微信中人员所属组织机构的ID
        
        if("0" == isDel)    //修改、增加记录
        {
            
            String userIp = request.Form["userIp"];
            String userName = request.Form["userName"];
            String userLoginName = request.Form["userLoginName"];
            String userOrganId = request.Form["userOrganId"];
            String userDeptId = request.Form["userDeptId"];
            String userTel = request.Form["userTel"];
            String sendMessage = request.Form["sendMessage"];
            message = new SysManage().addOrUpdateUser(userId, userIp, userName, userLoginName, userOrganId, userDeptId, userTel, sendMessage);

            if (message.Length > 0)
            {
                String[] messIns = message.Split(':');
                if (!"false".Equals(messIns[1]))
                {
                    try
                    {
                        WXWeb.WXService web = new WXWeb.WXService();
                        WXWeb.WeiXinUserData wxUser = new WXWeb.WeiXinUserData();
                        wxUser.userid = messIns[1];
                        wxUser.name = userName;
                        int[] depts = new int[1];
                        depts[0] = Convert.ToInt32(WXOrgId);
                        wxUser.department = depts;
                        wxUser.mobile = userTel;

                        if (string.IsNullOrEmpty(userId))
                        { //新增
                            web.CreateUser(wxUser);
                            new SysManage().updateWXUserFlag(messIns[1]);
                        }
                        else
                        {
                            String isCreated = new SysManage().getWXUserFlag(userId);
                            if ("1".Equals(isCreated))//已创建用户
                            {
                                web.UpdateUser(wxUser);
                            }
                            else
                            {
                                web.CreateUser(wxUser);
                                new SysManage().updateWXUserFlag(messIns[1]);
                            }
                        }

                    }
                    catch (Exception e)
                    {

                    }

                }
            }
            
            
        }
        else//删除记录
        {
            message = new SysManage().delUser(userId);
            if (CommonStr.del_succ.Equals(message))
            {
                WXWeb.WXService web = new WXWeb.WXService();
                web.DeleteUser(userId);
            }
        }

        context.Response.Write(message);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}