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
using PSOG.DAO.impl;
using PSOG.Entity;
using PSOG.Common;


public partial class aspx_Web_RunState : System.Web.UI.Page
{
    public string[] dataStr = { "", "" };
    protected void Page_Load(object sender, EventArgs e)
    {
        String modelId = Request.QueryString["modelId"];
        string plantId = Request.QueryString["plantId"];
        Plant plant = BeanTools.getPlantDB(plantId);
        String DBName = plant.realTimeDB;
        String hisDBName = plant.historyDB;
        try
        {
            Equipment equip = Common.getClickProcess(modelId, plant, plantId);

            dataStr[0] = new ArtTch().unusualConNode(equip.monitorObject_Name, plant);
            dataStr[1] = equip.monitorObject_Url;
        }
        catch
        { }
    }
}
