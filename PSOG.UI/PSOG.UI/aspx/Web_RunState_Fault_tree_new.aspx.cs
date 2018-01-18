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

public partial class aspx_Web_RunState_Fault_tree_new : System.Web.UI.Page
{
    public string pcaModelJson = "";
    public string ftaState = "";
    public string ftaStateStartTime = "";
    public string ftaHistory = "";
    public string[] id2ModelId = { "7750", "7879", "7960", "7993", "8038", "7807", "7852", "9501", "9534", "9579", "8188", "8317", "8398", "8431", "8476",
                                    "8245", "8626", "8755", "8836", "8869", "8914", "8683", "9064", "9193", "9274", "9307", "9352", "9121"};
    protected void Page_Load(object sender, EventArgs e)
    {
        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId;
        String plantId = Request.QueryString["plantCode"];
        plantId = null == plantId ? "" : plantId;

        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);

        IList list = new ArrayList();
        list = new AlarmAnalysis().ftaModelTags(plant, id2ModelId[int.Parse(modelId) - 1]);
        pcaModelJson = BeanTools.ToJson(list);

        string ftaStateTemp = "";
        ftaStateTemp = new AlarmAnalysis().FaultTreeResultById(plant, id2ModelId[int.Parse(modelId) - 1]);
        ftaState = ftaStateTemp.Split(',')[0];
        ftaStateStartTime = ftaStateTemp.Split(',')[1];

        EasyUIData grid = new AlarmAnalysis().ftaAbnormalHistory(plant, id2ModelId[int.Parse(modelId) - 1]);
        ftaHistory = BeanTools.ToJson(grid);
    }

}
