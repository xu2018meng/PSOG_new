<%@ Page Language="C#" AutoEventWireup="true" CodeFile="graphic_maintain_list.aspx.cs" Inherits="graphic_maintain_list" %>

<html>

<head id="Head1">
    <%  %>
    <title>ͼƬ�б�</title>
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
                   <th data-options="field:'PicName',width:160,align:'left',halign: 'center'">����</th>
                  <th data-options="field:'PicNum',width:200,align:'left',halign: 'center'">˳���</th>
                </tr>
            </thead>
        </table>
        
        <div id="toolbar" style="padding-top:2px;">
           <a id="a_add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">����</a>   
           <a id="a_edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="edit()">�༭</a>   
          <a id="a_config" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="config()">����</a>        
           <a id="a_del" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delData()">ɾ��</a>   
       </div>  
   </div>  
   
    <!--��¼��Ϣ -->
    <div id="dlg" class="easyui-dialog" title="����" style="width:600px;height:280px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true,
                toolbar: [{
                    text:'����',
                    iconCls:'icon-save',
                    handler:function(){
                        saveGraphicRecord();
                    }
                }] ">
        <form id="fm"  method="post" action="" style="padding-top:10px;">
           <input id="PicId" name="PicId"  style="display:none"/>
            <table cellpadding="2">
                <tr class="tr">
                    <td class="lable">����:</td>
                    <td><input id="PicName" name="PicName" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true"/></td>
                    <td class="lable">˳���:</td>
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
    
     <!--��ص� -->
    <div id="pointDiv" class="easyui-dialog" title="����" style="width:900px;height:500px;overflow:hidden;"  closed="true" modal="true" 
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
                        <image width="1" height="1" xlink:href="../../resource/img/��λ��.png" />
                    </pattern>
                </defs>
            </svg>
    </div>
    
      <!-- ����λ�ű���-->
    <div id="bitDiv" class="easyui-dialog" title="����" style="width:450px;height:280px;" closed="true" modal="true"
            data-options="
                iconCls: 'icon-add',
                resizable:true,
                maximizable:true,
                toolbar: [{
                    text:'����',
                    iconCls:'icon-save',
                    handler:function(){
                        saveGraphicPoints();
                    }
                }] ">
        <form id="Form1"  method="post" action="" style="padding-top:30px;">
           <input id="Text1" name="PicId"  style="display:none"/>
            <table cellpadding="2" style="margin-left:16%">
                <tr class="tr">
                    <td class="lable">X��:</td>
                    <td><input id="pointX" name="PicName" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true" /></td>
                </tr>
               <tr class="tr">
                    <td class="lable">Y��:</td>
                    <td>
                    <input id="pointY" name="pointY" class="input" maxlength="50" class="easyui-textbox" type="text" data-options="required:true" />
                    <input type="button" style="width:45px;height:22px;" value="�� ��" onclick="EditValueChanged();"/>
                    </td>
                </tr>
                 <tr class="tr">
                    <td class="lable">����λ��:</td>
                    <td>
                    <input id="bitNo" name="bitNo" class="easyui-searchbox" style="width:201px;height: 23px;" data-options="searcher:openBitDiv, editable:false"></input>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    
    
     <div id="bitSelectDiv" class="easyui-dialog" closed="true" title="λ��ѡ��" style="width: 700px; height: 450px; overflow: hidden" buttons="#bitDiv-buttons" modal="true">
        <iframe id='BitGrid' name="BitGrid" src="graphic_bit_select_list.aspx" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="bitDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelectBit();" style="width: 70px">ȷ��</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#bitSelectDiv').dialog('close')" style="width: 70px">ȡ��</a>
        </div>
    </div>
    
</body>    
</html>


<script type="text/javascript"> 

    var nodeId = "";
    var nodeType = "";
    var initFilePath = "";//�ļ�·��
    var saveOrUpdate = "0";//�������¶����
     
    //�����б�����
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
    
     //����
    function append(){
      if(nodeType != "plant"){
         $.messager.alert('��ʾ', '����ѡ��װ��','info');
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
          }).dialog('open').dialog('setTitle', '����');
      
    }
    
    //�����ϴ�
     function initFileUpload() {
         $('#file_upload').uploadify(
            {
                'buttonText': 'ѡ���ļ�',
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
                      //���渽��
                      $("#file_upload").uploadify("settings", "formData", {'flag':'upload','pkId':$("#PicId").val(),'plantId':nodeId });
                      $('#file_upload').uploadify('upload', '*');
                },
                onUploadSuccess: function (file, data, response) {
                   initFilePath = data;
              
                }
            });
  }
  
  //�����¼
  function saveGraphicRecord(){
        var picName = $("#PicName").val();
        var picNum =  $("#PicNum").val();
        if(picName == null || picName.length<=0){
           $.messager.alert('��ʾ', '���Ʋ���Ϊ��','info');
           return false;
        }
        if(picNum == null || picNum.length<=0 || isNaN(picNum)){
           $.messager.alert('��ʾ', '˳���ֻ��Ϊ�����Ҳ���Ϊ��','info');
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
                        title : '��ʾ',
                        msg : "����ɹ�"
                   });  
                 
                }else{
                    $.messager.show({
                        title : '��ʾ',
                        msg : "����ʧ��"
                    });   
                }             
            }
      });
  }
  
  
   //�༭
    function edit(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('��ʾ', '��ѡ��һ�����޸ĵ�����');
              return false;
          }
          $("#PicId").val(rows[0].PicId);
          $("#PicName").val(rows[0].PicName);
          $("#PicNum").val(rows[0].PicNum);
          
          initFileUpload();
          saveOrUpdate = "1";
          
            //���ظ����б�
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
                    msg: "��ȡʧ��"
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
          }).dialog('open').dialog('setTitle', '�༭');
    }
    
    //ɾ��ͼƬ
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
                        msg: "ɾ��ʧ��"
                    });
                }
            },
            error: function () {
                $.messager.show({
                    title: 'Info',
                    msg: "ɾ��ʧ��"
                });
            }
        });
    }
    
    //ɾ����¼
   function delData(){
      var rows = $('#dg').datagrid('getSelections');
         if(rows==null || rows.length==0){
           $.messager.alert('��ʾ', '������ѡ��һ����ɾ��������','info');
           return false;
         }
         var arr = new Array();
         for(var i=0;i<rows.length;i++){
           arr.push(rows[i].PicId);
         }
         
         $.messager.confirm('Confirm', '��ȷ��Ҫɾ����?', function (r) {
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
                                 title : '��ʾ',
                                 msg : "ɾ���ɹ�"
                               });   
                         }  else{
                            $.messager.alert('��ʾ', 'ɾ��ʧ��');
                         }    
                    }
                });
           }
            
          });
  }
  
  //����guid
function guid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16).toUpperCase();
    });
}
  
  
  //���ü�ص�
   var picRecordId = "";//��¼������
   function config(){
          var rows = $('#dg').datagrid('getSelections');
          if(rows == null || rows.length!=1){
              $.messager.alert('��ʾ', '��ѡ��һ�������õ�����');
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
                    
                       //���ؼ�ص�
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
                                msg: "��ȡʧ��"
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
                    msg: "��ȡʧ��"
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
                           + '<image width="1" height="1" xlink:href="../../resource/img/��λ��.png" /> </pattern></defs>';    
                  document.getElementById("svg1").innerHTML = "";
                  $("#svg1").append(html);
               }
          }).dialog('open').dialog('setTitle', '����');
          
    }
   
  
    

//var xtemp = 15,ytemp=40;
var xtemp = 15,ytemp=75;
var pointId = "";//���������
var isSave = false;//�Ƿ��ѱ���
var saveOrUpdate = "0";//��������

//˫�����Բ��
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
          }).dialog('open').dialog('setTitle', '����');
}

//�ı�Բ��λ��
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

//��갴���¼�
var startX = 0;
var startY = 0;
function recorddown(evt){
    startX = evt.x;
    startY = evt.y;
}
//���̧���¼�
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
    
      //���ؼ�ص�
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
                  $.messager.confirm('Confirm', '��ȷ��Ҫɾ����?', function (r) {
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
                                         title : '��ʾ',
                                         msg : "ɾ���ɹ�"
                                       });   
                                 }  else{
                                    $.messager.alert('��ʾ', 'ɾ��ʧ��');
                                 }    
                            }
                        });
                   }else{
                      document.getElementById("svg1").removeChild(document.getElementById("rectx"));
                   }
                    
                  });
               
            }else{
                $.messager.alert('��ʾ', 'Ȧѡ�ķ�Χû�м��㣬������ѡ��','info',function(){
                   document.getElementById("svg1").removeChild(document.getElementById("rectx"));
                });
               
            }
            
            
        },
        error: function () {
            $.messager.show({
                title: 'Info',
                msg: "��ȡʧ��"
            });
        }
    });
    
}

//��λ��ѡ���
function openBitDiv(value,name){
      $('#bitSelectDiv').dialog({
           onClose:function(){
            
           }
         }).dialog('open').dialog('setTitle', 'λ��ѡ��');
       window.frames["BitGrid"].reloadGrid(nodeId, "","");   
   }
 //ȷ��ѡ��
 function confirmSelectBit(){
    window.frames["BitGrid"].confirmSelectBit();   
 }
 //�ر�λ��ѡ��
 function closeBitSelectDiv(bitNo){
     $("#bitNo").searchbox("setValue",bitNo);
    $('#bitSelectDiv').dialog('close');
 }
 
 //�������
 function saveGraphicPoints(){
     var pointX = $("#pointX").val();
     var pointY = $("#pointY").val();

     if (pointX == null || pointX.length<=0 || isNaN(pointX)  
        || pointY == null || pointY.length<=0 || isNaN(pointY)){
        $.messager.alert('��ʾ', 'X���Y�᲻��Ϊ����ֻ��Ϊ����','info');
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
                   //���λ��
                   
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
                        title : '��ʾ',
                        msg : "����ɹ�"
                   });  
                 
                }else{
                    $.messager.show({
                        title : '��ʾ',
                        msg : "����ʧ��"
                    });   
                }             
            }
      });
 }
 
 
 //�޸�СԲ��λ��
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
          }).dialog('open').dialog('setTitle', '����');
    
    
    isSave = true;
    event.cancelBubble = true;

}
</script>

