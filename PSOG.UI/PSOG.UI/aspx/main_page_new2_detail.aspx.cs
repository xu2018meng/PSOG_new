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
using System.Web.Script;
using PSOG.Common;
using PSOG.Entity;
using System.Web.Script.Serialization;

public partial class main_page_new2_detail : System.Web.UI.Page
{
    public string baseJson = "";//基本信息
    public string abnormalJson = "";//异常信息
    public string runIndexId = "";//运行状态指数的参数ID
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        String deviceId = Request.QueryString["deviceId"];
        //查询基本信息
        DeviceIndex device = new SysManage().getDeviceIndexInfo(plantId, deviceId);
        //查询设备相关的异常信息
        abnormalJson = new SysManage().getDeviceAbnormalJson(plantId, deviceId);
        //获取运行状态指数的参数ID
        runIndexId = new SysManage().getDeviceRunIndexId(plantId, deviceId);

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        baseJson = jsonSerializer.Serialize(device);
    }
}
