<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree_plant.aspx.cs" Inherits="aspx_tree_plant" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="System.Collections" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;">
<head id="Head1" >
    <title>功能菜单</title>
    <%
       String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;%>
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
    <style type="text/css">
       .treeHead{background:url(../resource/img/mainPage/tree_head_ground.png) no-repeat; width:170px; height:39px; cursor:pointer}
       .treeLeaf{background:url(../resource/img/mainPage/tree_leaf_bg.png) no-repeat ; background-position:bottom left; width:170px; height:32px;  cursor:pointer}
       .treeLeafText{position:relative ;top:2px; font-size:13px; cursor:pointer; }
    </style>
</head>
<body style="margin:0px; padding:0px; overflow:hidden; background:url(../resource/img/mainPage/left_bg.png) no-repeat; background-position:left bottom; width:170px; height:100%;">
    <form id="form1" style=" width:170px; height:100%;">
        <div style="margin:0px; padding:0px; width:170px;  height:100%;">
        <%
          String firstPlantId = "";
          bool isFirst = true;
          if (null != plantList && 1 <= plantList.Count)
          {
              String parentId = "";
              foreach(Plant plant in plantList )
                {   
                    
                    if("1" == plant.level)
                    {   parentId = plant.organtreeParentCode;%>
                    <div id="<%=plant.organtreeCode %>" class="treeHead" onmousedown="headMouseDown(this)">
                        <table style="text-align:center">
                            <tr>
                                <td style="width:30px; text-align:center;"><img src="../resource/img/mainPage/comp_logo.png" style="padding-top:3px;"/></td>
                                <td style="width:125px; height:100%; text-align:left; vertical-align:bottom"><span  style="width: 100%; height:100%; padding-bottom:0px; cursor:pointer; "><%=plant.organtreeName%></span></td>
                                <td style="width:15px;  vertical-align:bottom"><img src="../resource/img/mainPage/organ_open.png"  style="padding-right: 10px; padding-bottom:5px;"/></td>
                            </tr>                
                        </table>
                    </div>
                    <%}else{
                          if (true == isFirst) { firstPlantId = plant.id; }
                          isFirst = false;
                         %>
                    
                    <div id="<%=plant.organtreeCode  %>" plantCode="<%=plant.id %>" plantId="<%=plant.id %>" realTimeDB="<%=plant.realTimeDB %>" historyDB="<%=plant.historyDB %>" pid="<%=parentId %>" class="treeLeaf" isClick="false" onmouseover="leafMouseover(this)" onmousedown="leafMouseDown(this,1)" onmouseout="leafMouseOut(this)">
                        <table>
                            <tr>
                                <td style="width:30px; text-align:center;"><img src="../resource/img/mainPage/plant.png" style="padding-top:4px; padding-left:5px;"/></td>
                                <td style="width:140px; height:100%; text-align:left; vertical-align:bottom"><span  style="width: 100%; height:100%;"  class="treeLeafText"><%=plant.organtreeName%></span></td>
                               
                            </tr>                
                        </table>
                    </div>    
                <%} %>
                
             <%}
         } %> 
        </div>
        
    </form>
</body>
</html>
<script type="text/javascript">
window.onload = function (){

    parent.showPlantsPage('<%=firstPlantId %>'); //显示多装置主页

    var plantId = '<%=plantId %>';
    if("" == plantId) plantId = '<%=firstPlantId %>';

    //parent.changePlantItem(plantId);//gai

    if(null != plantId && "" != plantId){
        leafMouseDown($('[plantId="'+ plantId +'"]').get(0), 0);   //默认选中某项
    }
}
//给别的页面调用
function clickMouse(plantStr){
    leafMouseDown($(plantStr).get(0), 0);
}

/* 叶子节点事件 */
function leafMouseover(e){
   // e.style.background = "url('../resource/img/dj.gif')";//gai
}

//clickFlag=1 切换装置
function leafMouseDown(e, clickFlag){
    var elem = e.children[0].children[0].children[0].children[0].children[0]; //装置图标
    var fontCell = e.children[0].children[0].children[0].children[1].children[0];
    $(".treeLeaf").each(function (headCell){
        var temp = this.children[0].children[0].children[0].children[0].children[0];
        if(null != temp.src && "" != temp.src && -1 != temp.src.indexOf("plant_click.png")){
            temp.src = "../resource/img/mainPage/plant.png";
            this.children[0].children[0].children[0].children[1].children[0].style.fontWeight = "400";    //颜色加重
            this.setAttribute("isClick", "false") ;
        }
    })
    e.setAttribute("isClick","true");
    elem.src = "../resource/img/mainPage/plant_click.png";
    fontCell.style.fontWeight = "700";    //颜色加重
    
    //在父页面记录当前选中装置
    
    var plant = parent.window.document.getElementById("div_plant");
    var oldPlantId = plant.getAttribute("plantId");
    plant.plantId = e.getAttribute("plantId");
    
    if(1 == clickFlag && oldPlantId != e.getAttribute("plantId"))
    {
       // parent.window.location = "../Default.aspx?plantId=" + e.plantId;//gai
        
        parent.changePlant();
        
       // parent.window.changePlantItem(e.plantId);//gai
    }else{        
        //触发主界面切换装置
        
        
       // parent.window.changePlantItem(e.plantId);//gai
    }
    
}
function leafMouseOut(e){
   // if("false" == e.isClick)//gai
       // e.style.background = "";//gai
}

/* 根节点事件 */
function headMouseDown(e){
    var qryNodeStr = "div#" + e.id ;
    var elem = e.children[0].children[0].children[0].children[2].children[0]; //收缩图标
    if(-1 != elem.src.indexOf("organ_closed.png")){
        $(qryNodeStr).nextUntil(".treeHead").show();
        elem.src = "../resource/img/mainPage/organ_open.png";
    }else{
        $(qryNodeStr).nextUntil(".treeHead").hide();
        elem.src = "../resource/img/mainPage/organ_closed.png";
    }
}


function clickPlant(plantId, functionNo) {
    var e = $('[plantId="' + plantId + '"]').get(0)
    var elem = e.children[0].children[0].children[0].children[0].children[0]; //装置图标
    var fontCell = e.children[0].children[0].children[0].children[1].children[0];
    $(".treeLeaf").each(function (headCell){
        var temp = this.children[0].children[0].children[0].children[0].children[0];
        if(null != temp.src && "" != temp.src && -1 != temp.src.indexOf("plant_click.png")){
            temp.src = "../resource/img/mainPage/plant.png";
            this.children[0].children[0].children[0].children[1].children[0].style.fontWeight = "400";    //颜色加重
            this.setAttribute("isClick","false");
        }
    })
    e.setAttribute("isClick", "true");
    elem.src = "../resource/img/mainPage/plant_click.png";
    fontCell.style.fontWeight = "700";    //颜色加重



    //在父页面记录当前选中装置

    var plant = parent.window.document.getElementById("div_plant");
    var oldPlantId = plant.getAttribute("plantId");
    plant.plantId = e.getAttribute("plantId");


}

</script>

