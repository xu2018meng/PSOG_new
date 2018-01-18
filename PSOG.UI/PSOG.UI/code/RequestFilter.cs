using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Common;

/// <summary>
/// RequestFilter 的摘要说明

/// </summary>
public class RequestFilter
{
    public RequestFilter()
    {
    }

    public void Init(HttpApplication application)
    {
        application.AcquireRequestState += new EventHandler(application_AcquireRequestState);
        application.ReleaseRequestState += new EventHandler(ReleaseRequestState);
    }

    public void application_AcquireRequestState(object o, EventArgs e)
    {
        HttpApplication application = (HttpApplication)o;
        string url = application.Context.Request.Url.ToString();

    }
    public void Dispose()
    {

    }


    public void ReleaseRequestState(object o, EventArgs e)
    {
        
    }
}
