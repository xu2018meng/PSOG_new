﻿using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class _Default_new2 : System.Web.UI.Page 
{
    public string dateStr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime date = DateTime.Now;
        dateStr = date.ToString("yyyy-MM-dd") + "&nbsp;&nbsp;&nbsp;&nbsp;" + date.ToString("dddd", new System.Globalization.CultureInfo("zh-cn"));
    }
}
