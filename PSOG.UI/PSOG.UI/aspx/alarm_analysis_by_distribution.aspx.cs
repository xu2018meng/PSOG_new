﻿using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class alarm_analysis_by_distribution : System.Web.UI.Page
{
    public string startTime = "";
    public String endTime = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime time = DateTime.Now;
        endTime = time.ToString("yyyy-MM-dd HH:mm:ss");
        startTime = time.AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss");
    }
}
