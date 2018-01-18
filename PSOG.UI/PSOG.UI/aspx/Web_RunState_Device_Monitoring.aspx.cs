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
using PSOG.Common;
using PSOG.Entity;

public partial class aspx_Web_RunState_Device_Monitoring : System.Web.UI.Page
{
    public string pcaModelJson = "";
    public string pcaState = "";
    public string pcaStateStartTime = "";
    public string pcaHistory = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId;
        String plantId = Request.QueryString["plantCode"];
        plantId = null == plantId ? "" : plantId;

        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);

        IList list = new ArrayList();
        list = new AlarmAnalysis().pcaModelTags(plant, modelId);
        pcaModelJson = BeanTools.ToJson(list);


        string pcaStateTemp = "";
        pcaStateTemp = new AlarmAnalysis().DeviceMonitoringResultById(plant, modelId);
        pcaState = pcaStateTemp.Split(',')[0];
        pcaStateStartTime = pcaStateTemp.Split(',')[1];

        EasyUIData grid = new AlarmAnalysis().pcaAbnormalHistory(plant, modelId);
        pcaHistory = BeanTools.ToJson(grid);

    }

}
