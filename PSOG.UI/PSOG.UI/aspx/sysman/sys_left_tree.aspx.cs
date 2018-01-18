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

public partial class aspx_sysman_sys_left_tree : System.Web.UI.Page
{
    public IList plantList = new ArrayList();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        //plantList = new MainPage().qryPlantList();
    }
}
