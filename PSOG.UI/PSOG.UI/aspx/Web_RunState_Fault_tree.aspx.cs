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
using System.IO;

public partial class aspx_Web_RunState_Fault_tree : System.Web.UI.Page
{
    public string pcaModelJson = "";
    public string ftaState = "";
    public string ftaName = "";
    public string ftaStateStartTime = "";
    public string ftaHistory = "";
    public string ftaJson = "";
    //public string[] id2ModelId = { "7750", "7879", "7960", "7993", "8038", "7807", "7852", "9501", "9534", "9579", "8188", "8317", "8398", "8431", "8476",
    //                                "8245", "8626", "8755", "8836", "8869", "8914", "8683", "9064", "9193", "9274", "9307", "9352", "9121"};
    protected void Page_Load(object sender, EventArgs e)
    {
        String modelId = Request.QueryString["modelId"];
        modelId = null == modelId ? "" : modelId;
        String plantId = Request.QueryString["plantCode"];
        plantId = null == plantId ? "" : plantId;

        string DBName = BeanTools.getPlantDB(plantId).historyDB;    //数据库名
        Plant plant = BeanTools.getPlantDB(plantId);

        //关键变量状态
        IList list = new ArrayList();
        list = new AlarmAnalysis().ftaModelTags(plant, modelId);
        pcaModelJson = BeanTools.ToJson(list);

        string ftaStateTemp = "";
        ftaStateTemp = new AlarmAnalysis().FaultTreeResultById(plant, modelId);
        ftaState = ftaStateTemp.Split(',')[0];
        ftaStateStartTime = ftaStateTemp.Split(',')[1];
        ftaName = ftaStateTemp.Split(',')[2];

        ftaJson = new AlarmAnalysis().FaultTreeJsonById(plant, modelId);

        FileStream fs = new FileStream(Request.PhysicalApplicationPath + "aspx\\FT_Jsons\\" + modelId + ".html", FileMode.OpenOrCreate, FileAccess.ReadWrite);
        StreamWriter m_StreamWriter = new StreamWriter(fs);
        m_StreamWriter.BaseStream.Seek(0, SeekOrigin.Begin);
        m_StreamWriter.Write(ftaJson);
        m_StreamWriter.Flush();
        m_StreamWriter.Close();
        fs.Close();
        //ftaJson = BeanTools.ToJson(ftaJson);

        EasyUIData grid = new AlarmAnalysis().ftaAbnormalHistory(plant, ""+(int.Parse(modelId)+1));
        ftaHistory = BeanTools.ToJson(grid);
    }
}
