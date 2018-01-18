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

public partial class aspx_tree_plant : System.Web.UI.Page
{
    public IList plantList = new ArrayList();
    public string plantIds = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        String userId = ((SysUser)Session[CommonStr.session_user]).userId;
        plantIds = new SysManage().qryPlantsByUserId(userId);
        plantList = new MainPage().qryPlantList(plantIds);
    }
}
