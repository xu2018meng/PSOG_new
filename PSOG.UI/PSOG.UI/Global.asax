<%@ Application Language="C#" %>
<%@ Import Namespace="PSOG.Common" %>
<%@ Import Namespace="PSOG.Bizc" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="log4net" %>
<%@ import Namespace="System.IO" %>   

<script runat="server">
    private bool isFirst = true;
    private log4net.ILog log = LogManager.GetLogger("Global");
    void Application_Start(object sender, EventArgs e) 
    {
        // 在应用程序启动时运行的代码
        //装置信息封装到session
        try
        {
            BeanTools.setPlantDic(new MainPage().loadPlantList());

            //定时监测报警、预警、异常--在应用程序启动时运行的代码
            //System.Timers.Timer myTimer = new System.Timers.Timer(10000);
            //myTimer.Elapsed += new System.Timers.ElapsedEventHandler(OnTimedEvent);
            //myTimer.Interval = 60000;
            //myTimer.Enabled = true;
            //myTimer.AutoReset = true;
            
        }
        catch (Exception exp)
        {
            log.Error(exp.Message);            
        }
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  在应用程序关闭时运行的代码

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // 在出现未处理的错误时运行的代码
        Exception ex = HttpContext.Current.Server.GetLastError();
        log.Error("未处理异常", ex);
    }

    void Session_Start(object sender, EventArgs e) 
    {
        // 在新会话启动时运行的代码
        if (true == isFirst)
        {
            
            if ("/".Equals(Request.ApplicationPath))
            {
                CommonStr.applicationPath = ConfigurationManager.AppSettings["ApplicationPath"];
            }
            else {
                CommonStr.applicationPath = Request.ApplicationPath;
            }
           
            CommonStr.physicalPath = Request.PhysicalApplicationPath;
           // BeanTools.setURLOfKnowledge(new MainPage().qryUrlOfKnowledge());    //初始装置知识地址        
            isFirst = false;
        }        
        
    }

    void Session_End(object sender, EventArgs e) 
    {
        // 在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer 
        // 或 SQLServer，则不会引发该事件。
        Session.Clear();
    }

    /// <summary>
    /// 校验是否有用户已登录
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    void Application_AcquireRequestState(object sender, EventArgs e)    
    {
        Boolean flag = true;
        String str_Regex = @"[']";
        Regex regex = new Regex(str_Regex);
        
        HttpApplication application = (HttpApplication)sender;
        HttpRequest request = application.Request;
        string url = request.Url.ToString();
        if (url.Contains(".aspx"))
        {   
            string userName = "";
            try
            {
                SysUser user = (SysUser)Context.Session[CommonStr.session_user];
                if (null != user)
                {
                    userName = user.userLoginName;
                }
            }
            catch (Exception exp)
            {
            }
            
            
            //string remoteAddr = Request.ServerVariables.Get("Remote_Addr").ToString(); //客户端ip
            //if(string.IsNullOrEmpty(userName) ){
            //    SysUser user = new SysManage().qryUserNameByURL(remoteAddr);  //根据ip获取用户
            //    if (null != user && !string.IsNullOrEmpty(user.userName))
            //    {
            //        application.Context.Session[CommonStr.session_user] = user;
            //        userName = user.userLoginName;
            //    }
            //}


            if (string.IsNullOrEmpty(userName) && !url.Contains("Login.aspx") && !url.Contains("login_validate.ashx") && !url.Contains("login_jump.aspx")
                && !url.Contains("CheckPng.aspx") && !url.Contains("WXAlarmConfirmCode.aspx") && !url.Contains("WXAlarmConfirmView.aspx")
                && !url.Contains("alarm_analysis_report_wx.aspx") && !url.Contains("alarm_analysis_report.aspx")
                && !url.Contains("alarm_analysis_export.aspx"))  //没登陆跳转到登陆页面
            {
                application.Response.Redirect("~/Login.aspx");
            }
            else {

                //if (Request.QueryString != null && Request.QueryString.Count > 0)
                //{
                //    NameValueCollection queryParam = Request.QueryString;
                //    for (int i = 0; i < queryParam.Count; i++)
                //    {
                //        string queryKey = queryParam.GetKey(i);
                //        string queryText = queryParam[i];
                //        if (regex.IsMatch(queryText))
                //        {
                //            flag = false;
                //            break;
                //        }
                //    }
                //}

                //if (!flag)
                //{
                //    application.Response.Redirect(application.Request.ApplicationPath + "/Login.aspx");
                //}
            }
        }
        else if (url.Contains(".ashx") || url.Contains(".ashx"))
        {
            //if (Request.Form != null && Request.Form.Count > 0)
            //{
            //    NameValueCollection formParam = Request.Form;
            //    for (int i = 0; i < formParam.Count; i++)
            //    {
            //        string formKey = formParam.GetKey(i);
            //        string formText = formParam[i];
            //        if (regex.IsMatch(formText))
            //        {
            //            flag = false;
            //            break;
            //        }
            //    }
            //}
            //if (!flag)
            //{
            //    application.Response.Redirect(application.Request.ApplicationPath + "/Login.aspx");
            //}
        }
    }

    private static void OnTimedEvent(object source, System.Timers.ElapsedEventArgs e)
    {

        try
        {
            //myTimer.Enabled = false;
            new SysManage().sendAlarmInfo_new();
            //发送预警信息
            new SysManage().sendEarlyAlarmInfo_new();
            //发送异常信息
            new SysManage().sendAbnormalStateInfo_new();

            //发送报警正常信息
            new SysManage().sendAlarmNormalInfo_new();
            //发送预警正常信息
            new SysManage().sendEarlyAlarmNormalInfo_new();
            //发送异常正常信息
            new SysManage().sendAbnormalStateNormalInfo_new();
        }
        catch (Exception ex)
        {

        }
        finally {
           // myTimer.Enabled = true;
        }
        //发送报警消息
      
    }  
       
</script>
