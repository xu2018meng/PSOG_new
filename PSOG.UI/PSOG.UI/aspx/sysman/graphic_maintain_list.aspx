<%@ Page Language="C#" AutoEventWireup="true" CodeFile="graphic_maintain_list.aspx.cs" Inherits="graphic_maintain_list" %>

<html>

<head id="Head1">
    <%  %>
    <title>图片列表</title>
    <link href="../../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../../resource/jquery/easyui/themes/default/demo.css" />
    <script type="text/javascript" src="../../resource/jquery/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../resource/jquery/easyui/jquery.easyui.min.js"></script>
     <link type="text/css" rel="stylesheet" href="../../resource/css/calendar.css" />
      <link href="../../resource/uploadify-v3.1/uploadify.css" rel="stylesheet" />
    <script src="../../resource/uploadify-v3.1/jquery.uploadify-3.1.min.js"></script>
    <style type="text/css">
        html, body{
            width:100%;
            height:100%;
            padding:0;
            margin:0;
        }
        .param {
           text-align:right;
        }
        .input{
          width:200px;
          height:20px;
        }
        .lable{
          width:60px;
          text-align:right;
        }
        .tr{
          height:35px;
        }
    </style>
    <script type="text/javascript">
      function initGrid(){
           $("#dg").datagrid({
            url:'graphic_maintain_list_data.ashx',
            queryParams: {
                plantId: ''
            }
           });
     }
    </script>
</head>
<body class="easyui-layout" onload="initGrid();">

    <div id="gridDiv"  region="center" style="padding: 5px; height: 100%; width:100%" border="false">   
       
       <table id="dg" style="width:auto;height:auto" fit="true" url=""
            toolbar="#toolbar" idField="PicId" pagination="false" pagesize="20" 
            rownumbers="true" fitColumns="false" singleSelect="false">
    
         <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                   <th data-options="field:'PicName',width:160,align:'left',halign: 'center'">名称</th>
                  <th data-options="field:'PicNum',width:200,align:'left',halign: 'center'">顺序号</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:2px;">
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新增</a>   
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="edit()">编辑</a>   
          <a id="a_config" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="config()">配置</a>        
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delData()">删除</a>   
       </div>  
   </div>  
   
    <!--记录信息 -->
    <div id="dlg" class="easyui-dialog" title="新增" style="width:600px;height:280px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true,
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveGraphicRecord();
                    }
                }] ">
        <form id="fm"  method="post" action="" style="padding-top:10px;">
           <input id="PicId" name="PicId"  style="display:none"/>
            <table cellpadding="2">
                <tr class="tr">
                    <td class="lable">名称:</td>
                    <td><input id="PicName" name="PicName" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">顺序号:</td>
                    <td><input id="PicNum" name="PicNum" class="input" maxlength="50" class="easyui-textbox"  type="text" data-options="required:true"/></td>
                </tr>
                <tr>
                <td colspan="2" style="text-align:center">
                    <div id="td_file">
                         <input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>
                    </div>
                    <div id="div_file"></div>
                </td>
                </tr>
            </table>
        </form>
    </div>
    
     <!--监控点 -->
    <div id="pointDiv" class="easyui-dialog" title="配置" style="width:900px;height:500px;overflow:hidden;"  closed="true" modal="true" 
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true">
        <svg version="1.1" id="svg1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  x="0px" y="0px"
                width="100%" height="100%"  enable-background="new 0 0 100% 100%" xml:space="preserve"
                style="background-size: 100% 100%;" ondblclick="recordClick(evt)"
                onmousedown="recorddown(evt);" onmouseup="recordup(evt)" ondrag="return false;">
                
                  <defs>
                    <pattern id="elecgreen" width="100%" height="100%" patternContentUnits="objectBoundingBox">
                        <image width="1" height="1" xlink:href="../../resource/img/绿位号.png" />
                    </pattern>
                </defs>
            </svg>
    </div>
    
      <!-- 关联位号保存-->
    <div id="bitDiv" class="easyui-dialog" title="配置" style="width:450px;height:280px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true,
                toolbar: [{
                    text:'保存',
                    iconCls:'icon-save',
                    handler:function(){
                        saveGraphicPoints();
                    }
                }] ">
        <form id="Form1"  method="post" action="" style="padding-top:30px;">
           <input id="Text1" name="PicId"  style="display:none"/>
            <table cellpadding="2" style="margin-left:16%">
                <tr class="tr">
                    <td class="lable">X轴:</td>
                    <td><input id="pointX" name="PicName" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true" /></td>
                </tr>
               <tr class="tr">
                    <td class="lable">Y轴:</td>
                    <td>
                    <input id="pointY" name="pointY" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true" />
                    <input type="button" style="width:45px;height:22px;" value="调 整" onclick="EditValueChanged();"/>
                    </td>
                </tr>
                 <tr class="tr">
                    <td class="lable">关联位号:</td>
                    <td>
                    <input id="bitNo" name="bitNo" class="easyui-searchbox" style="width:201px;height: 23px;" data-options="searcher:openBitDiv, editable:false"></input>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    
    
     <div id="bitSelectDiv" class="easyui-dialog" closed="true" title="位号选择" style="width: 700px; height: 450px; overflow: hidden" buttons="#bitDiv-buttons" modal="true">
        <iframe id='BitGrid' name="BitGrid" src="graphic_bit_select_list.aspx" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="bitDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelectBit();" style="width: 70px">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#bitSelectDiv').dialog('close')" style="width: 70px">取消</a>
        </div>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 

    var nodeId = "";
    var nodeType = "";
    var initFilePath = "";//文件路径
    var saveOrUpdate = "0";//保存或更新都标记
     
    //加载列表数据
    function reloadGrid(id,type){
       nodeId = id;
       nodeType = type;
       
       if("plant" == nodeType)
       { 
           $('#dg').datagrid('load', {
             plantId:nodeId
           });
           
       }else{
           $('#dg').datagrid('load', {
              plantId:""
           });
       }
       
    }
    
     //增加
    function append(){
      if(nodeType != "plant"){
         $.messager.alert('提示', '请先选择装置','info');
         return false;
      }
      initFilePath = "";
      saveOrUpdate = "0";
      $("#PicId").val(guid());
      initFileUpload();
       $('#dlg').dialog({
               onClose:function(){
                      $("#PicId").val('');
                      $("#PicName").val('');
                       $("#PicNum").val('');
                      initFilePath = "";
                      document.getElementById("div_file").innerHTML = "";
                      document.getElementById("td_file").innerHTML = "";
                      $("#td_file").append('<input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>');
               }
          }).dialog('open').dialog('setTitle', '新增');
      
    }
    
    //附件上传
     function initFileUpload() {
         $('#file_upload').uploadify(
            {
                'buttonText': '选择文件',
                'swf': '../../resource/uploadify-v3.1/uploadify.swf',
                'uploader': 'graphic_maintain_list_deal.ashx',
                'method': 'get',
                auto: false,
                multi: false,
                fileTypeExts: '*.png;*.jpg;*.gif;*.bmp',
                removeCompleted: false,
                'onCancel': function (file) {
                    queueSize = queueSize - 1;
                },
                'onDialogClose': function (swfuploadifyQueue) {
                      queueSize = swfuploadifyQueue.queueLength;
                      //保存附件
                      $("#file_upload").uploadify("settings", "formData", {'flag':'upload','pkId':$("#PicId").val(),'plantId':nodeId });
                      $('#file_upload').uploadify('upload', '*');
                },
                onUploadSuccess: function (file, data, response) {
                   initFilePath = data;
              
                }
            });
  }
  
  //保存记录
  function saveGraphicRecord(){
        var picName = $("#PicName").val();
        var picNum =  $("#PicNum").val();
        if(picName == null || picName.length<=0){
           $.messager.alert('提示', '名称不能为空','info');
           return false;
        }
        if(picNum == null || picNum.length<=0 || isNaN(picNum)){
           $.messager.alert('提示', '顺序号只能为数字且不能为空','info');
           return false;
        }
        
        $.ajax({
            url : './graphic_maintain_list_deal.ashx?flag=saveRecord&plantId='+nodeId,
            data : {
                      PicId:$("#PicId").val(),
                      PicName:picName,
                      PicNum:picNum,
                      saveOrUpdate:saveOrUpdate
                    },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                 
                  $('#dg').datagrid('load', {
                     plantId:nodeId
                   });
                    $('#dg').datagrid('clearSelections');
                   $('#dlg').dialog('close'); 
                   $.messager.show({
                        title : '提示',
                        msg : "保存成功"
                   });  
                 
                }else{
                    $.messager.show({
                        title : '提示',
                        msg : "保存失败"
                    });   
                }             
            }
      });
  }
  
  
   //编辑
    function edit(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('提示', '请选择一条待修改的数据');
              return false;
          }
          $("#PicId").val(rows[0].PicId);
          $("#PicName").val(rows[0].PicName);
          $("#PicNum").val(rows[0].PicNum);
          
          initFileUpload();
          saveOrUpdate = "1";
          
            //加载附件列表
        $("#AnnexId-queue").empty();
        $("#div_file").empty();
        $.ajax({
            url : './graphic_maintain_list_deal.ashx?flag=getFile&plantId='+nodeId,
            data : {
                      sheetId:rows[0].PicId
                    },
            async:false,
            type:"post",
            success: function (result) {   
                result = eval('('+result+')');        
                for (var i = 0; i < result.length; i++) {
                    document.getElementById("td_file").innerHTML = "";
                    var file = result[i];
                    $("#div_file").append("<div id='" + file.ANNEXID + "' style='font-size: 15px;height:30px;'>" 
                        + file.ANNEXNAME + "<img src='../../resource/img/delete.png' style='cursor:pointer' onclick='deleteAnnex(\"" + file.ANNEXID + "\")' /></div>");
                }
            },
            error: function () {
                $.messager.show({
                    title: 'Info',
                    msg: "获取失败"
                });
            }
        });
          
         
        
          $('#dlg').dialog({
               onClose:function(){
                      $("#PicId").val('');
                      $("#PicName").val('');
                       $("#PicNum").val('');
                      initFilePath = "";
                        document.getElementById("div_file").innerHTML = "";
                      document.getElementById("td_file").innerHTML = "";
                      $("#td_file").append('<input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>');
               }
          }).dialog('open').dialog('setTitle', '编辑');
    }
    
    //删除图片
    function deleteAnnex(AnnexId){
       var param = {
        AnnexId: AnnexId
      };
        $.ajax({
            type: "POST",
            async: false,
            url : './graphic_maintain_list_deal.ashx?flag=delFile&plantId='+nodeId,
            data: param,
            dataType: "json",
            success: function (result) {
                if (result == "1") {
                   document.getElementById("div_file").innerHTML = "";
                   $("#td_file").append('<input id="file_upload" name="file_upload" type="file" style="width:100px;margin-left: 20px;"/>');
                    initFileUpload();
                } else {
                    $.messager.show({
                        title: 'Info',
                        msg: "删除失败"
                    });
                }
            },
            error: function () {
                $.messager.show({
                    title: 'Info',
                    msg: "删除失败"
                });
            }
        });
    }
    
    //删除记录
   function delData(){
      var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('提示', '请至少选择一条待删除的数据','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].PicId);
         }
         
         $.messager.confirm('Confirm', '您确定要删除吗?', function (r) {
           if(r){
               $.ajax({
                    url : './graphic_maintain_list_deal.ashx?flag=delRecord&plantId='+nodeId,
                    data : {
                      recordArr:JSON.stringify(arr)
                    },
                    async:false,
                    type:"post",
                    success : function(result) {
                         if(result=="1"){
                              $('#dg').datagrid('load', {
                                 plantId:nodeId
                              });
                              $('#dg').datagrid('clearSelections');
                              $.messager.show({
                                 title : '提示',
                                 msg : "删除成功"
                               });   
                         }  else{
                            $.messager.alert('提示', '删除失败');
                         }    
                    }
                });
           }
            
          });
  }
  
  //生成guid
function guid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16).toUpperCase();
    });
}
  
  
  //配置监控点
   var picRecordId = "";//记录的主键
   function config(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('提示', '请选择一条待配置的数据');
              return false;
          }
          picRecordId = rows[0].PicId;
           $.ajax({
            url : './graphic_maintain_list_deal.ashx?flag=getGraphic&plantId='+nodeId,
            data : {
                      SheetId:rows[0].PicId
                    },
            async:false,
            type:"post",
            success: function (result) {   
                if (result.length > 0) {
                    $("#svg1").show();
                    document.getElementById("svg1").setAttribute("style", 'background-image:url(' + result + ');background-size:100% 100%;width:100%;heigth:100%;');
                    
                       //加载监控点
                       $.ajax({
                        url : './graphic_maintain_list_deal.ashx?flag=getPoints&plantId='+nodeId,
                        data : {
                                  picId:rows[0].PicId
                                },
                        async:false,
                        type:"post",
                        success: function (result) {   
                            result = eval('('+result+')');
                            for(var i=0;i<result.length;i++){
                                var pointX = parseFloat(result[i].PointX);
                                var pointY = parseFloat(result[i].PointY);
                                var d = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                              
                               
                                d.setAttribute("id", result[i].PointId);
                                d.setAttribute("name", result[i].PointId);
                                d.setAttribute("x", pointX + '%');
                                d.setAttribute("y", pointY + '%');
                                d.setAttribute("width", "22");
                                d.setAttribute("height", "20");
                                d.ondblclick = function (evt) { EditLocation(evt); };
                                d.setAttribute("fill", "url(#elecgreen)");
                                $("#svg1").append(d);
                                
                                var bit = document.createElementNS("http://www.w3.org/2000/svg", "text");
                                bit.setAttribute("id", result[i].PointId + "1");
                                bit.setAttribute("name", result[i].PointId + "1");
                                bit.setAttribute("x", (parseFloat(pointX)-2) + '%');
                                bit.setAttribute("y", (parseFloat(pointY)+6) + '%');
                                bit.setAttribute("style","fill:blue");
                                bit.textContent = result[i].BitNo;
                                $("#svg1").append(bit);
                                
                            }
                           
                            
                        },
                        error: function () {
                            $.messager.show({
                                title: 'Info',
                                msg: "获取失败"
                            });
                        }
                    });
                    
                    
                    
                    
                    
                } else {
                    $("#svg1").hide();
                }
            },
            error: function () {
                $.messager.show({
                    title: 'Info',
                    msg: "获取失败"
                });
            }
        });
           
          
          var bodyHeight = $(window).height();
          var bodyWidth = $(window).width();
          
          $('#pointDiv').dialog({
               heigth:bodyHeight,
               width:bodyWidth,
               onClose:function(){
                  var html = '<defs><pattern id="elecgreen" width="100%" height="100%" patternContentUnits="objectBoundingBox">'
                           + '<image width="1" height="1" xlink:href="../../resource/img/绿位号.png" /> </pattern></defs>';    
                  document.getElementById("svg1").innerHTML = "";
                  $("#svg1").append(html);
               }
          }).dialog('open').dialog('setTitle', '配置');
          
    }
   
  
    

//var xtemp = 15,ytemp=40;
var xtemp = 15,ytemp=75;
var pointId = "";//监测点的主键
var isSave = false;//是否已保存
var saveOrUpdate = "0";//保存或更新

//双击添加圆点
function recordClick(evt) {
    var explorer =navigator.userAgent ;
    //ie 
    if (explorer.indexOf("MSIE") >= 0) {
      xtemp = 15;
      ytemp = 33;
    }else if(explorer.indexOf("Chrome") >= 0){
      xtemp = 15;
      ytemp = 37;
    }else if(explorer.indexOf("Safari") >= 0){
      xtemp = 15;
      ytemp = 29;
    } 
    
     var svgWidth = document.getElementById("svg1").width.animVal.value;
     var svgHeight = document.getElementById("svg1").height.animVal.value;
    
    var d = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    
    var pointX = ((evt.pageX-xtemp)/ svgWidth * 100).toFixed(3);
    var pointY = ((evt.pageY-ytemp)/ svgHeight * 100).toFixed(3);
    
    pointId = guid();
    d.setAttribute("id", pointId);
    d.setAttribute("name", pointId);
    d.setAttribute("x", pointX + '%');
    d.setAttribute("y", pointY + '%');
    d.setAttribute("width", "22");
    d.setAttribute("height", "20");
    d.ondblclick = function (evt) { EditLocation(evt); };
    d.setAttribute("fill", "url(#elecgreen)");
    $("#svg1").append(d);
    
    saveOrUpdate = "0";
    $("#pointX").val(pointX);
    $("#pointY").val(pointY);
    $("#bitNo").searchbox("setValue","");
    $('#bitDiv').dialog({
               onClose:function(){
                    $("#pointX").val("");
                    $("#pointY").val(""); 
                    if (isSave ==  false) {
                           var point = $("#" + pointId)[0];
                           document.getElementById("svg1").removeChild(point);
                    }
                    pointId = "";
                    isSave = false;
               }
          }).dialog('open').dialog('setTitle', '配置');
}

//改变圆点位置
function EditValueChanged() {
    var pointX = $("#pointX").val();
    var pointY = $("#pointY").val();

    if (pointX == null || pointX.length<=0 || isNaN(pointX)  
        || pointY == null || pointY.length<=0 || isNaN(pointY)){
        return false;
    }
    
    var point = $("#" + pointId);
    point.attr({ x: pointX+ '%', y: pointY + '%' });
    
    var point = $("#" + pointId+"1");
    point.attr({ x: (parseFloat(pointX)-2)+ '%', y: (parseFloat(pointY)+6) + '%' });
}

//鼠标按下事件
var startX = 0;
var startY = 0;
function recorddown(evt){
    startX = evt.x;
    startY = evt.y;
}
//鼠标抬起事件
function recordup(evt){

   var explorer =navigator.userAgent ;
    //ie 
    if (explorer.indexOf("MSIE") >= 0) {
      xtemp = 15;
      ytemp = 35;
    }else if(explorer.indexOf("Chrome") >= 0){
      xtemp = 15;
      ytemp = 37;
    }
    
     var svgWidth = document.getElementById("svg1").width.animVal.value;
     var svgHeight = document.getElementById("svg1").height.animVal.value;

    var endX = evt.x;
    var endY = evt.y;
    var width = Math.abs(endX-startX);
    var height = Math.abs(endY-startY);
    if(width<23 || height<21){
      return true;
    }
    x = endX>startX?startX:endX;
    y = endY>startY?startY:endY;
    
    var pointX = ((evt.pageX-xtemp)/ svgWidth * 100).toFixed(3);
    var pointY = ((evt.pageY-ytemp)/ svgHeight * 100).toFixed(3);

    var c = $(document.createElementNS("http://www.w3.org/2000/svg", "rect"));
    c.attr({ id: "rectx", width: width, height: height, x: x-5, y: y-25 });
    c.css({ fill: "deepskyblue", "stroke-width": "2", stroke: "rgb(0,0,0)", "fill-opacity": "0.5", "stroke-opacity": "0.9", "opacity": "0.5" });
    $("#svg1").append(c);
    
    startX = ((startX-xtemp)/ svgWidth * 100).toFixed(3);
    endX = ((endX-xtemp)/ svgWidth * 100).toFixed(3);
    startY = ((startY-ytemp)/ svgHeight * 100).toFixed(3);
    endY = ((endY-ytemp)/ svgHeight * 100).toFixed(3); 
    
      //加载监控点
       $.ajax({
        url : './graphic_maintain_list_deal.ashx?flag=getSelectPoints&plantId='+nodeId,
        data : {
                  startX:startX,
                  endX:endX,
                  startY:startY,
                  endY:endY
                },
        async:false,
        type:"post",
        success: function (result) {   
            result = eval('('+result+')');
            if(result!=null && result.length>0){
                  $.messager.confirm('Confirm', '您确定要删除吗?', function (r) {
                   if(r){
                       $.ajax({
                            url : './graphic_maintain_list_deal.ashx?flag=delPoints&plantId='+nodeId,
                            data : {
                              startX:startX,
                              endX:endX,
                              startY:startY,
                              endY:endY
                            },
                            async:false,
                            type:"post",
                            success : function(message) {
                                 if(message=="1"){
                                     
                                      document.getElementById("svg1").removeChild(document.getElementById("rectx"));
                                      for(var i=0;i<result.length;i++){
                                           var point = $("#" + result[i].PointId)[0];
                                           var pointText = $("#" + result[i].PointId+"1")[0];
                                           document.getElementById("svg1").removeChild(point);
                                           document.getElementById("svg1").removeChild(pointText);
                                      }
                                      
                                      
                                      $.messager.show({
                                         title : '提示',
                                         msg : "删除成功"
                                       });   
                                 }  else{
                                    $.messager.alert('提示', '删除失败');
                                 }    
                            }
                        });
                   }else{
                      document.getElementById("svg1").removeChild(document.getElementById("rectx"));
                   }
                    
                  });
               
            }else{
                $.messager.alert('提示', '圈选的范围没有监测点，请重新选择','info',function(){
                   document.getElementById("svg1").removeChild(document.getElementById("rectx"));
                });
               
            }
            
            
        },
        error: function () {
            $.messager.show({
                title: 'Info',
                msg: "获取失败"
            });
        }
    });
    
}

//打开位号选择框
function openBitDiv(value,name){
      $('#bitSelectDiv').dialog({
           onClose:function(){
            
           }
         }).dialog('open').dialog('setTitle', '位号选择');
       window.frames["BitGrid"].reloadGrid(nodeId, "","");   
   }
 //确定选择
 function confirmSelectBit(){
    window.frames["BitGrid"].confirmSelectBit();   
 }
 //关闭位号选择
 function closeBitSelectDiv(bitNo){
     $("#bitNo").searchbox("setValue",bitNo);
    $('#bitSelectDiv').dialog('close');
 }
 
 //保存监测点
 function saveGraphicPoints(){
     var pointX = $("#pointX").val();
     var pointY = $("#pointY").val();

     if (pointX == null || pointX.length<=0 || isNaN(pointX)  
        || pointY == null || pointY.length<=0 || isNaN(pointY)){
        $.messager.alert('提示', 'X轴和Y轴不能为空且只能为数字','info');
        return false;
      }
      
       $.ajax({
            url : './graphic_maintain_list_deal.ashx?flag=savePoint&plantId='+nodeId,
            data : {
                      pointId:pointId,
                      pointX:pointX,
                      pointY:pointY,
                      bitNo: $("#bitNo").searchbox("getValue"),
                      picId:picRecordId,
                      saveOrUpdate:saveOrUpdate
                    },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
                   isSave = true;
                   //添加位号
                   
                    var d = document.createElementNS("http://www.w3.org/2000/svg", "text");
                    d.setAttribute("id", pointId + "1");
                    d.setAttribute("name", pointId + "1");
                    d.setAttribute("x", (parseFloat(pointX)-2) + '%');
                    d.setAttribute("y", (parseFloat(pointY)+6) + '%');
                    d.setAttribute("style","fill:blue");
                    d.textContent = $("#bitNo").searchbox("getValue");
                    
                    $("#svg1").append(d);
                   
                   
                   $('#bitDiv').dialog('close'); 
                   $.messager.show({
                        title : '提示',
                        msg : "保存成功"
                   });  
                 
                }else{
                    $.messager.show({
                        title : '提示',
                        msg : "保存失败"
                    });   
                }             
            }
      });
 }
 
 
 //修改小圆点位置
function EditLocation(e) {
    pointId = e.currentTarget.id;
    var point = document.getElementById(""+pointId);
    var pointX = point.x.animVal.valueAsString;
    var pointY = point.y.animVal.valueAsString;
    pointX = pointX.substring(0,pointX.length-1);
    pointY = pointY.substring(0,pointY.length-1);
    
    var curPointText = document.getElementById(pointId+"1");
    var bitNo = curPointText.textContent;
    
    saveOrUpdate = "1";
    $("#pointX").val(pointX);
    $("#pointY").val(pointY);
    $("#bitNo").searchbox("setValue",bitNo);
    $('#bitDiv').dialog({
               onClose:function(){
                    $("#pointX").val("");
                    $("#pointY").val(""); 
                    if (isSave ==  false) {
                           var point = $("#" + pointId)[0];
                           document.getElementById("svg1").removeChild(point);
                    }
                    pointId = "";
                    isSave = false;
               }
          }).dialog('open').dialog('setTitle', '配置');
    
    
    isSave = true;
    event.cancelBubble = true;

}
</script>

