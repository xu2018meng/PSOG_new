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
using PSOG.Bizc;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using PSOG.Common;
using PSOG.Entity;

public partial class graphic_monitor : System.Web.UI.Page
{
    //图片
    public string picJson = "";
    public string pointJson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        List<Dictionary<string, string>> picList = new SysManage().queryPlantAllGraphics(plantId);
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        picJson = jsonSerializer.Serialize(picList);

        //监测点
        Dictionary<string, Dictionary<string, List<Dictionary<string, string>>>> dict = new SysManage().queryGraphicMonitorInfo(plantId);
        pointJson = jsonSerializer.Serialize(dict);
    }
}
