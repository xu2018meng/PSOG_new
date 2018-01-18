using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Common;
using PSOG.Bizc;
using PSOG.Entity;
using log4net;
using System.Text;
using System.Security.Cryptography;
//统一权限认证跳转页面
public partial class login_jump : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string redirecturl = Request.QueryString.Get("url");
        //创建日志记录组件实例
        ILog log = log4net.LogManager.GetLogger(typeof(login_jump));
        log.Debug("session信息:" + Session[CommonStr.session_user]);
        if (Session[CommonStr.session_user] != null)
        {

            Response.Redirect(HttpUtility.UrlDecode(redirecturl));
        }
        else
        {
            SysUser user = new SysUser();
            user.userLoginName = "admin";
            user.userPassword = StrToMD5("1");
            user.userIp = "";

            string message = new MainPage().loginValidate(user);
            if ("true" == message)
            {
                // Context.
               Session[CommonStr.session_user] = user;    //将用户名存储到session
            }
            Response.Redirect(HttpUtility.UrlDecode(redirecturl));
        }
       
    }
    //String转MD5
    public  string StrToMD5(string str)
    {
        byte[] data = Encoding.GetEncoding("GB2312").GetBytes(str);
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] OutBytes = md5.ComputeHash(data);

        string OutString = "";
        for (int i = 0; i < OutBytes.Length; i++)
        {
            OutString += OutBytes[i].ToString("x2");
        }
        return OutString.ToUpper();
        //return OutString.ToLower();
    }
}
