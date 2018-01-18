using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PSOG.Entity;
using PSOG.Bizc;
using PSOG.Common;
public partial class aspx_web_unusual_condition : System.Web.UI.Page
{
    protected List<Abnormal> AbnormalList = new List<Abnormal>();
    protected void Page_Load(object sender, EventArgs e)
    {
        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId;
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        AbnormalList = new Common().AbnormalNumber(plantId, modelId);
    }
}
