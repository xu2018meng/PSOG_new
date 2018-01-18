<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_RunState_ASDB.aspx.cs" Inherits="aspx_Web_RunState_ASDB" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <% 
        String plantId = Request.QueryString["plantId"];
       plantId = null == plantId ? "" : plantId;
         %>
    <title>异常工况库</title>
    <link href="../resource/jquery/easyui/themes/icon.css" rel="stylesheet" />
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />
    <link href="../resource/css/button_style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="../resource/jquery/jquery-1.9.1.min.js"></script>
    <script  type="text/javascript"src="../resource/jquery/easyui/themes/jquery.easyui.min.js"></script>
    <style type="text/css">
        .tableStyle{
            border:1px solid #fff;
        }
    </style>
</head>        
<body style="background-color:Black">
           <%-- <div title="title1" style="padding:10px;text-align:center;" selected="true" src='web_show_img.aspx?fileId=a&plantId=<%=plantId %>'>
                <iframe id='ifram1' src=''  height="100%" width="100%" frameborder="0"></iframe>
            </div>--%>
            <table style="width:100%">
                <tr>
                    <td style="width:20%"></td>
                    <td style="width:60%">
                        <div id="div_content" title="" style="padding:10px;text-align:center;  height:100%;vertical-align:middle; background-color:Black " selected="true" >
                          <!-- <iframe id='Iframe1'  height="100%"  width="100%";  src='web_show_ASImg.aspx?fileId=a&plantId=<%=plantId %>&name=<%=plantId %>' scrolling="no" frameborder="0" onload="this.height=this.contentWindow.document.documentElement.scrollHeight;"></iframe>-->
                             <div>
                                <div style="font-size:x-large; color:White; padding-top:50px"><%=plantName%>装置智能对象库</div>
                             </div>
                             <div style="display:none">
                             <div id="CYL" style="color:White; text-align:left; padding-top:50px; ">
                                
                             </div>
                             <br />
                             <div id="CYT" style="color:White; text-align:left;">
                                
                             </div>
                             <br />
                             <div id="JYL" style="color:White; text-align:left;">
                                
                             </div>
                             <br />
                             <div id="JYT" style="color:White; text-align:left;">
                                
                             </div>
                             <br />
                             <div id="CLT" style="color:White; text-align:left;">
                                
                             </div>
                             </div>
                             <div id="no_area" style="color:White; text-align:left; padding-top:50px; ">
                                
                             </div>
                        </div>
                    </td>
                    <td style="width:20%; " ></td>
                </tr>
            </table>
             
</body>
</html>
<script type="text/javascript">

    
    var ASDB_address = "";

    function show_no_area(a){
        var jsonStr = "["+a+"]";
       
        jsonObj = eval(jsonStr);
        var cell = null;
        var str = "";
       
        var len = jsonObj[0].length;
        
        NumTemp = 0;
        htmlStr = '<table style="margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse;border-color:White"><tr>';
        for(var i=0; i<len; i++){
            NumTemp += 1;
            if(NumTemp > 6){
                if(jsonObj[0][i].status == '1'){
                    htmlStr += '</tr><tr style="height:5px"></tr><tr><td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="width:150px;height:50px; border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td><td style="width:5px;border-width:0"></td>';
                }else{
                    htmlStr += '</tr><tr style="height:5px"></tr><tr><td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="background-color:#D9231F;width:150px;height:50px; border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td><td style="width:5px;border-width:0"></td>';
                }
                
                NumTemp = 1;
            }else{
                if(jsonObj[0][i].status == '1'){
                    htmlStr += '<td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="width:150px;height:50px;border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td><td style="width:5px;border-width:0"></td>';
                }else{
                    htmlStr += '<td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="background-color:#D9231F;width:150px;height:50px;border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td><td style="width:5px;border-width:0"></td>';
                }
                
            }
        }
        
        var ddv = document.getElementById('no_area');
        ddv.innerHTML = htmlStr;
    }

    function show(a)
    {
        var jsonStr = "["+a+"]";
       
        jsonObj = eval(jsonStr);
        var cell = null;
        var str = "";
       
        var len = jsonObj[0].length;
        var category = ["常压炉","常压塔","减压炉","减压塔","初馏塔"];
        var categoryTable = ["常<br />压<br />炉","常<br />压<br />塔","减<br />压<br />炉","减<br />压<br />塔","初<br />馏<br />塔"];
        var cateNum = [0, 0, 0, 0, 0];
        var cateStr = ['', '', '', '', ''];
        if(len > 0){
            
            for(var i=0; i<len; i++){
                for(var j=0; j<category.length; j++){
                    if(jsonObj[0][i].unit == category[j]){
                        cateNum[j] += 1;
                        break;
                    }
                }
            }
            
            for(var j=0; j<category.length; j++){ //border=1px 
                if(cateNum[j] > 6){
                    cateStr[j] = '<table style="margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse;border-style:none;"><tr><td rowspan='+(Math.floor(cateNum[j]/6)+1)+' class="tableStyle" style="width:50px;text-align:center;font-weight:bold;font-size:larger;">'+categoryTable[j]+'</td>';
                }
                if(cateNum[j] > 0 && cateNum[j] < 6){
                    cateStr[j] = '<table style="margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse;border-color:White"><tr><td rowspan=2 class="tableStyle" style="width:50px;text-align:center;font-weight:bold;font-size:larger">'+categoryTable[j]+'</td>';
                }
                if(cateNum[j] == 0){
                    cateStr[j] = '<table style="margin-top:0px;overflow:scroll; color:#fff;border-collapse:collapse"><tr><td rowspan=2 class="tableStyle" style="width:50px;height:100px;text-align:center;font-weight:bold;font-size:larger">'+categoryTable[j]+'</td></tr></table>';
                }
            }
            
            var cateNumTemp = [0, 0, 0, 0, 0];
            var flagOneLine = [0, 0, 0, 0, 0]; //1说明个数超过6个，0说明小于等于6个
            for(var i=0; i<len; i++){
                for(var j=0; j<category.length; j++){
                    if(jsonObj[0][i].unit == category[j]){
                        cateNumTemp[j] += 1;
                        
                        if(cateNumTemp[j] > 6){
                            if(jsonObj[0][i].status == '1'){
                                cateStr[j] += '</tr><tr><td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="width:150px;height:50px; border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td>';
                            }else{
                                cateStr[j] += '</tr><tr><td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="background-color:#D9231F;width:150px;height:50px; border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td>';
                            }
                            
                            cateNumTemp[j] = 0;
                            flagOneLine[j] = 1;
                        }else{
                            if(jsonObj[0][i].status == '1'){
                                cateStr[j] += '<td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="width:150px;height:50px;border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td>';
                            }else{
                                cateStr[j] += '<td class="tableStyle" id='+jsonObj[0][i].id+' onclick="showImg(this)" style="background-color:#D9231F;width:150px;height:50px;border-color:White;cursor:pointer;font-size:12px">'+jsonObj[0][i].ASName+'</td>';
                            }
                            
                        }
                        break;
                    }
                }
            }
            
            for(var j=0; j<category.length; j++){ //少于6个的再多加一行
                if(flagOneLine[j] == 1){
                    cateStr[j] += '</tr></table>';
                }else{
                    cateStr[j] += '</tr><tr><td style="width:150px;height:50px;border-width:0"></td></tr></table>';
                }
            }
            
            var ddv_cyl = document.getElementById('CYL');
            ddv_cyl.innerHTML = cateStr[0];
            var ddv_cyt = document.getElementById('CYT');
            ddv_cyt.innerHTML = cateStr[1];
            var ddv_jyt = document.getElementById('JYT');
            ddv_jyt.innerHTML = cateStr[2];
            var ddv_jyl = document.getElementById('JYL');
            ddv_jyl.innerHTML = cateStr[3];
            var ddv_clt = document.getElementById('CLT');
            ddv_clt.innerHTML = cateStr[4];
        }
        
        
    }
    
    var jsonStr = '<%=jsonStr %>';

    if("" != jsonStr){
        show_no_area(jsonStr);
    }
    
    function showImg(obj){
	    parent.window.function_click_ZH("Web_RunState_Fault_tree.aspx?plantCode=<%=plantId %>&modelId="+obj.id, "003");
    }
    
    function clickBack(){
        $('#totalGraph').show();
        $('#ImgPanel').hide();
        document.getElementById("Img").src = "";
    }
    
    
    function tagAjax(){
        $.ajax({
            type: "post",
            url: 'Web_RunState_FaultTree_Result.ashx?plantId=<%=plantId %>',
            data: null,
            dataType: "json",
            success: function(data){  //state=1,正常；state=-1,异常
                for(var o in data){
                    var imageId = document.getElementById(data[o].id);
                    if(imageId.value != data[o].state){
                        if(data[o].state == 1){
                            imageId.value = "1";
                            imageId.src = "../resource/img/iconAbnormal/"+imageId.name+".png";
                        }else{
                            imageId.value = "-1";
                            imageId.src = "../resource/img/iconAbnormal/red/"+imageId.name+".png";
                        }
                    }
                }             
            }
         });
    }
    //$(function(){
    //tagAjax();
    //});
    
</script>