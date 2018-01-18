using System;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using PSOG.Bizc;

/// <summary>
/// SendMessageWebService 的摘要说明
/// </summary>
[WebService(Namespace = "http://PSOG.SendMessage.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class SendMessageWebService : System.Web.Services.WebService
{

    public SendMessageWebService()
    {

        //如果使用设计的组件，请取消注释以下行 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public void SendMessageTask()
    {
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


        ////燕山石化用自己的短信平台，以下为燕山石化报警推送
        //new SysManage().sendAlarmInfo_new_ys();
        ////发送预警信息
        //new SysManage().sendEarlyAlarmInfo_new_ys();
        ////发送异常信息
        //new SysManage().sendAbnormalStateInfo_new_ys();

        ////发送报警正常信息
        //new SysManage().sendAlarmNormalInfo_new_ys();
        ////发送预警正常信息
        //new SysManage().sendEarlyAlarmNormalInfo_new_ys();
        ////发送异常正常信息
        //new SysManage().sendAbnormalStateNormalInfo_new_ys();


    }

    /// <summary>
    /// 推送报表
    /// </summary>
    [WebMethod]
    public void SendAlarmReportTask()
    {
        new SysManage().sendAlarmReportTask();
    }


}

