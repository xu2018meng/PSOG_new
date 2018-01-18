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
using System.Collections.Generic;
using PSOG.Bizc;
using PSOG.Entity;
using PSOG.Common;

public partial class aspx_device_tree_function : System.Web.UI.Page
{
    public List<Equipment> list = new List<Equipment>();
    protected void Page_Load(object sender, EventArgs e)
    {
        String plantId = Request.QueryString["plantId"];
        plantId = null == plantId ? "" : plantId;
        String DBName = BeanTools.getPlantDB(plantId).realTimeDB;
        Plant plant = BeanTools.getPlantDB(plantId);
        list = new DeviceTch().loadEquipmentFuntion(plant);
    }
}
