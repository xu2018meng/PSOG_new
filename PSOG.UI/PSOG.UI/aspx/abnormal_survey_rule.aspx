<%@ Page Language="C#" AutoEventWireup="true" CodeFile="abnormal_survey_rule.aspx.cs" Inherits="aspx_abnormal_survey_rule" %>
<%@ Import Namespace="PSOG.Entity" %>
<%@ Import Namespace="PSOG.Common" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>�쳣������</title>
     <% 
        String id = Request.QueryString["id"];
        String plantId = Request.QueryString["plantId"];
         String bitCode = Request.QueryString["bitCode"];
       bitCode = null == bitCode ? "" : bitCode;
       String tagDesc = Request.QueryString["tagDesc"];
       tagDesc = null == tagDesc ? "" : tagDesc;
       SysUser user = ((SysUser)Session[CommonStr.session_user]);
       String userId = user.userId;
       String userName = user.userName;
     %>
    <link href="../resource/jquery/easyui/themes/default/easyui.css" rel="stylesheet" />    
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/icon.css" />
    <link rel="stylesheet" type="text/css" href="../resource/jquery/easyui/themes/default/demo.css" /> 
    <script type="text/javascript" src="../resource/jquery/jquery-1.6.min.js"></script>
  <script type="text/javascript" src="../resource/jquery/easyui/jquery.easyui.min.js"></script>
    <style type="text/css">
        *
        {
            margin: 0;
            padding: 0;
        }
        
        html,body, #form1 {
            font-size:12px;
            width:100%;
            height:100%;
        }
       
         .td_lable
        {
            text-align: center;
            width: 80px;
            height: 30px;
        }
        td{border:solid #268BBA; border-width:0px 1px 1px 0px; padding:6px 6px 6px 6px;height:28px;}
        table{border:solid #268BBA; border-width:1px 0px 0px 1px;}
    </style>
</head>
<body onload="" style="background-color:#eef6fe;">
    <form id="form1" action="">
    <div style="text-align:left;height:25px;font-size:16px;padding-top:2px;background-color:#d2ebfe;font-family:΢���ź�;">
    &nbsp;&nbsp;��ǰλ�ã�<a style="font-size:16px;text-decoration: none;color:Blue;font-family:΢���ź�;" href="main_page_new.aspx?plantId=<%=plantId %>">��ҳ</a>
   &nbsp;>&nbsp;<a style="font-size:16px;text-decoration: none;color:Blue;font-family:΢���ź�;" href="abnormal_realTime_list.aspx?plantId=<%=plantId %>">�쳣ʵʱ����</a>
    &nbsp;>&nbsp;�쳣����
    </div>
    
        <div style="padding-top:7px;width:850px;padding-left:13.5%;">
            <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px; ">������Ϣ</div>
            <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="1" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>��&nbsp;&nbsp;��</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:140px;height:30px;">
                           <label id="tagName"></label>
                        </td>
                        <td class="td_lable">
                           <label>״&nbsp;&nbsp;̬</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:140px;height:30px;">
                           <label id="tagStatus"></label>
                        </td>
                       <td class="td_lable">
                           <label>�Ƿ�ȷ��</label>
                        </td>
                        <td class="td_input" style="text-align:confirm;width:140px;height:30px;">
                           <label id="isConfirm"></label>
                        </td>
                    </tr>
                    <tr>
                        
                        <td class="td_lable">
                           <label>��&nbsp;&nbsp;��</label>
                        </td>
                        <td class="td_input" style="text-align:left;width:240px;height:30px;" colspan="5">
                           <label id="tagDesc"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            
            <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px;">�쳣����</div>
            <div style="font-size:12px; padding-top:1px; ">
                <table id="gz_table" cellpadding="1" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                   <tr id="title">
                       <td class="td_input" style="text-align:center;width:24%;">
                           <label>��&nbsp;&nbsp;��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:20%;">
                           <label>��&nbsp;&nbsp;��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:80px;">
                           <label>��&nbsp;&nbsp;��</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                            <label>ֵ</label>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                           <label><a href="#" onclick="addGZ();">
                               <img src="../resource/img/ruleAdd.jpg" border="0"/></a></label>
                        </td>
                       
                    </tr>
                    <tr id="tr1">
                        <td class="td_input" style="text-align:center;width:24%;">
                           <input class="easyui-textbox" style="width:90%; height: 20px;" id="ruleDesc1" name="ruleDesc1" value="" ></input>
                        </td>
                        <td class="td_input" style="text-align:center;width:20%;">
                           <input id="bitNo1" name="bitNo1" class="easyui-combobox" style="width:154px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value'
		                         "/> 
                        </td>
                        <td class="td_input" style="text-align:left;width:80px;">
                         <input id="condition1" name="condition1" class="easyui-combobox" style="width:80px; height: 23px;" data-options="
		                        valueField: 'label',
		                        textField: 'value',
		                        panelHeight:'auto',
		                        data: [{
			                        label: '��',
			                        value: '��'
		                        },{
			                        label: '��',
			                        value: '��'
		                        },{
			                        label: '��',
			                        value: '��'
		                        }]" /> 
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input class="easyui-textbox" style="width:89%; height: 20px;" id="ruleValue1" name="ruleValue1" value=""></input>
                        </td>
                        <td class="td_lable" style="text-align:center" colspan='2'>
                          <label><a id="tr1#a"  href="#" onclick="deleteRule(this.id)">
                              <img src="../resource/img/ruleDel.jpg" border="0"/></a></label>
                        </td>
                      
                    </tr>
                    
                </table>
            </div>
            
            <br />
              
             <div style="font-size:14px; font-weight:700; color:#ffffff; background-color: #268BBA;height:20px;padding-top:4px;padding-left:15px;">֪ͨ����</div>
             <div style="font-size:12px; padding-top:1px; ">
                <table cellpadding="1" cellspacing="0" style=" text-align:center; vertical-align:middle; width:100%; ">
                    <tr>
                        <td class="td_lable">
                           <label>�쳣��ʼ</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                            <input  class="easyui-numberbox" style="width:85%; height: 20px;"  id="alarmStartTime1" name="alarmStartTime1"  data-options="precision:0"></input>����
                        </td>
                        <td class="td_lable">
                           <label>ͨ&nbsp;&nbsp;֪</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan1" name="alarmStartMan1" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv, editable:false"></input>
                        </td>
                        <td class="td_lable" style="text-align:right" colspan='2'>
                           <input id="alarmStartMan1Id" name="alarmStartMan1Id" style="display:none"/>
                        </td>
                    
                    </tr>
                    <tr>
                        <td class="td_lable">
                           <label>�쳣��ʼ</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                            <input class="easyui-numberbox" style="width:85%; height: 20px;" id="alarmStartTime2" name="alarmStartTime2" value="" data-options="precision:0"></input>����
                        </td>
                        <td class="td_lable" >
                           <label>ͨ&nbsp;&nbsp;֪</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan2" name="alarmStartMan2" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv2, editable:false"></input>
                        </td>
                        <td class="td_lable" style="text-align:right" colspan='2'>
                           <input id="alarmStartMan2Id" name="alarmStartMan2Id" style="display:none"/>
                        </td>
                       
                    </tr>
                     <tr>
                        <td class="td_lable" >
                           <label>�쳣��ʼ</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                            <input class="easyui-numberbox" style="width:85%; height: 20px;" id="alarmStartTime3" name="alarmStartTime3" value="" data-options="precision:0"></input>����
                        </td>
                        <td class="td_lable" >
                           <label>ͨ&nbsp;&nbsp;֪</label>
                        </td>
                        <td class="td_input" style="text-align:center;width:33%;">
                           <input id="alarmStartMan3" name="alarmStartMan3" class="easyui-searchbox" style="width:240px;height: 23px;" data-options="searcher:openUserDiv3, editable:false"></input>
                        </td>
                        <td class="td_lable" style="text-align:right" colspan='2'>
                            <input id="alarmStartMan3Id" name="alarmStartMan3Id" style="display:none"/>
                        </td>
                        
                    </tr>
                </table>
            </div>
         
            <div style="padding-top:4px;padding-left:40%">
                <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-save" onclick="save();" id="a_save" style="width: 70px">����</a>
            </div>
        </div>
    </form>
    
     <div id="userDiv" class="easyui-dialog" closed="true" title="��Աѡ��" style="width: 350px; height: 500px; overflow: hidden" buttons="#userDiv-buttons" modal="true">
        <iframe id='BitTree' name="BitTree" src="" style="width: 100%; height: 100%; border: 0; overflow-x: hidden;"></iframe>
        <div id="userDiv-buttons">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-ok" onclick="confirmSelect();" style="width: 70px">ȷ��</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconcls="icon-cancel" onclick="javascript:$('#userDiv').dialog('close')" style="width: 70px">ȡ��</a>
        </div>
    </div>
</body>
</html>

<script type="text/javascript">

   //��ʼ����Ϣ
   var bitDict = null;
   var num = 1;
   var isHasEdit = "1";
   var curState = "";
   $(function(){
     initInfo();
   });
   
   function initInfo(){
     isHasEdit = '<%=isHasEdit %>';
   
      var dictJson = '<%=dictJson %>';
      bitDict = eval('('+dictJson+')');
      $("#bitNo1").combobox("loadData",bitDict);
      
       //������Ϣ
       var baseInfoJson = '<%=baseInfoJson %>';
       var baseInfo = eval('('+baseInfoJson+')');
       
       curState = baseInfo.status;
       
       $("#tagName").html('<%=bitCode %>');
       $("#tagStatus").html(baseInfo.status);
       $("#tagDesc").html('<%=tagDesc %>');
       
       if(baseInfo.isConfirm == "��ȷ��"){
           $("#isConfirm").html(baseInfo.isConfirm);
       }else{
           var html = "<a href='#' onclick='confirmAlarm()'>δȷ��</a>";
           $("#isConfirm").html(html);
       }
       //������Ϣ
       var ruleInfoJson = '<%=ruleInfoJson %>';
       var ruleInfo = eval('('+ruleInfoJson+')');
     
       var rule = ruleInfo.abStateRule;
       if(rule!=null && rule.length>0){
          var ruleRows = rule.split('#');
          num = ruleRows.length;
          if(ruleRows.length>1){
             var ruleCells = ruleRows[0].split('@');
             $("#ruleDesc1").val(ruleCells[0]);
             $("#bitNo1").combobox("setValue",ruleCells[1]);
             $("#condition1").combobox("setValue",ruleCells[2]);
             $("#ruleValue1").val(ruleCells[3]);
             for(var i=1;i<ruleRows.length;i++){
                   var rowIndex = i+1;
                   var html = '<tr id="tr'+rowIndex+'">'
                            +' <td class="td_input" style="text-align:center;width:24%;">'
                            +'    <input class="easyui-textbox" style="width:90%; height: 20px;" id="ruleDesc'+rowIndex+'" name="ruleDesc'+rowIndex+'" value="" ></input>'
                            +' </td>'
                            +' <td class="td_input" style="text-align:center;width:20%;">'
                            +'    <input id="bitNo'+rowIndex+'" name="bitNo'+rowIndex+'"  style="width:154px; height: 23px;" />'
                            +' </td>'
                            +' <td class="td_input" style="text-align:center;width:80px;">'
                            +'  <input id="condition'+rowIndex+'" name="condition'+rowIndex+'" style="width: 80px; height: 23px;" />'
                            +' </td>'
                            +' <td class="td_input" style="text-align:center;width:33%;">'
                            +'    <input class="easyui-textbox" style="width:89%; height: 20px;" id="ruleValue'+rowIndex+'" name="ruleValue'+rowIndex+'" value=""></input>'
                            +' </td>'
                            +' <td class="td_lable" style="text-align:center" colspan="2">'
                            +'   <label><a id="tr'+rowIndex+'#a" href="#" onclick="deleteRule(this.id)"><img src="../resource/img/ruleDel.jpg" border="0"/></a></label>'
                            +'    </td>'
                            +'</tr>';
                 $("#gz_table").append(html);
                 
                $("#bitNo"+rowIndex).combobox({
                    valueField:'label',
                    textField:'value',
                    panelHeight:'auto',
                    data:bitDict
                 });
     
                 $("#condition"+rowIndex).combobox({
                    valueField:'label',
                    textField:'value',
                    panelHeight:'auto',
                    data:[
                      {
                       label:'��',
                       value:'��'
                      },
                      {
                       label:'��',
                       value:'��'
                      },
                      {
                       label:'��',
                       value:'��'
                      }
                    ]
                 });
                 
                 var ruleCell = ruleRows[i].split('@');
                 $("#ruleDesc"+rowIndex).val(ruleCell[0]);
                 $("#bitNo"+rowIndex).combobox("setValue",ruleCell[1]);
                 $("#condition"+rowIndex).combobox("setValue",ruleCell[2]);
                 $("#ruleValue"+rowIndex).val(ruleCell[3]);   
                 
                 //�ж��Ƿ�ɱ༭
                 if(isHasEdit != "1"){
                     $("#bitNo"+rowIndex).combobox("disable");
                     $("#condition"+rowIndex).combobox("disable");
                 } 
            }
          }else{
             var ruleCells = ruleRows[0].split('@');
             $("#ruleDesc1").val(ruleCells[0]);
             $("#bitNo1").combobox("setValue",ruleCells[1]);
             $("#condition1").combobox("setValue",ruleCells[2]);
             $("#ruleValue1").val(ruleCells[3]);
             
              //�ж��Ƿ�ɱ༭
             if(isHasEdit != "1"){
                 $("#bitNo1").combobox("disable");
                 $("#condition1").combobox("disable");
             } 
          }
       }
       
       $("#alarmStartTime1").numberbox("setValue",ruleInfo.abStateTime1);
       $("#alarmStartMan1").searchbox("setValue",ruleInfo.abStateManName1);
       $("#alarmStartMan1Id").val(ruleInfo.abStateMan1);
       
       $("#alarmStartTime2").numberbox("setValue",ruleInfo.abStateTime2);
       $("#alarmStartMan2").searchbox("setValue",ruleInfo.abStateManName2);
       $("#alarmStartMan2Id").val(ruleInfo.abStateMan2);
       
       $("#alarmStartTime3").numberbox("setValue",ruleInfo.abStateTime3);
       $("#alarmStartMan3").searchbox("setValue",ruleInfo.abStateManName3);
       $("#alarmStartMan3Id").val(ruleInfo.abStateMan3);
       
       isHasEdit = '<%=isHasEdit %>';
       if(isHasEdit!="1"){
          $("form[id='form1'] table input").attr("disabled", "disabled");
          $("#bitNo1").combobox("disable");
          $("#condition1").combobox("disable");
          $("#a_save").hide();
       }
   }
   
   
   //ȷ�ϱ���
   function confirmAlarm(){
       if(curState==null || curState.length<=0 || curState=="����" || curState=="�����쳣"){
           $.messager.alert('��ʾ', '�����쳣״̬��ȷ��');              
           return false;
        }
   
        $.messager.confirm('Confirm', '��Ҫȷ�������쳣��Ϣ��?', function (r) {
           if(r){
                $.ajax({
                   url : './abnormal_survey_rule_confirm.ashx',
                   data : {
                       id:'<%=id %>',
                       plantId:'<%=plantId %>',
                        userId:'<%=userId %>',
                       userName:'<%=userName %>'
                   },
                async:false,
                type:"post",
                success : function(data) {
                    if(data=="1"){
                      $("#isConfirm").html("��ȷ��");
                       $.messager.show({
                            title : '��ʾ',
                            msg : "ȷ�ϳɹ�"
                            
                       });   
                    }else{
                        $.messager.show({
                            title : '��ʾ',
                            msg : "ȷ��ʧ��"
                            
                        });   
                    }            
                }
              });
           }
         });
  
   }
   
   
   var manEditorName = "";
   var manEditorId = "";
   //֪ͨ��1
   function openUserDiv(value,name){
      if(isHasEdit != "1"){
        return false;
      }
   
     manEditorName = "alarmStartMan1";
     manEditorId = "alarmStartMan1Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '��Աѡ��');
   }
   
   //֪ͨ��2
    function openUserDiv2(value,name){
      if(isHasEdit != "1"){
        return false;
      }
    
     manEditorName = "alarmStartMan2";
     manEditorId = "alarmStartMan2Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '��Աѡ��');
   }
   
   //֪ͨ��3
    function openUserDiv3(value,name){
      if(isHasEdit != "1"){
        return false;
      }
    
     manEditorName = "alarmStartMan3";
     manEditorId = "alarmStartMan3Id";
     $("#BitTree").attr("src","user_select_tree.aspx");
      $('#userDiv').dialog({
           onClose:function(){
             $("#BitTree").attr("src","");
           }
         }).dialog('open').dialog('setTitle', '��Աѡ��');
   }
   
   //ȷ��ѡ��
   function confirmSelect(){
      window.BitTree.confirmSelect();
   }
   
    //�ر���Աѡ���
   function closeDialog(userIds,userNames){
     $("#"+manEditorId).val(userIds);
     $("#"+manEditorName).searchbox("setValue",userNames);
     $('#userDiv').dialog('close');
   }

  //����һ�й���
  function addGZ(){
       if(isHasEdit != "1"){
        return false;
       }
      
       num++;
       var html = '<tr id="tr'+num+'">'
                +' <td class="td_input" style="text-align:center;width:24%;">'
                +'    <input class="easyui-textbox" style="width:90%; height: 20px;" id="ruleDesc'+num+'" name="ruleDesc'+num+'" value="" ></input>'
                +' </td>'
                +' <td class="td_input" style="text-align:center;width:20%;">'
                +'    <input id="bitNo'+num+'" name="bitNo'+num+'"  style="width:154px; height: 23px;" />'
                +' </td>'
                +' <td class="td_input" style="text-align:center;width:80px;">'
                +'  <input id="condition'+num+'" name="condition'+num+'" style="width: 80px; height: 23px;" />'
                +' </td>'
                +' <td class="td_input" style="text-align:center;width:33%;">'
                +'    <input class="easyui-textbox" style="width:89%; height: 20px;" id="ruleValue'+num+'" name="ruleValue'+num+'" value=""></input>'
                +' </td>'
                +' <td class="td_lable" style="text-align:center" colspan="2">'
                +'   <label><a id="tr'+num+'#a" href="#" onclick="deleteRule(this.id)"><img src="../resource/img/ruleDel.jpg" border="0"/></a></label>'
                +'    </td>'
                +'</tr>';
     $("#gz_table").append(html);
     
     $("#bitNo"+num).combobox({
        valueField:'label',
        textField:'value',
        panelHeight:'auto',
        data:bitDict
     });
     
     $("#condition"+num).combobox({
        valueField:'label',
        textField:'value',
        panelHeight:'auto',
        data:[
          {
           label:'��',
           value:'��'
          },
          {
           label:'��',
           value:'��'
          },
          {
           label:'��',
           value:'��'
          }
        ]
     });
  }
  
  //ɾ����ǰ������
  function deleteRule(id){
     if(isHasEdit != "1"){
        return false;
     }
  
    var trId = id.split('#')[0];
    $("#"+trId).remove();
  }
  
  
  //����
  function save(){
    var ruleInfo = "";
    $("table[id='gz_table'] tr").each(function(index,id){
        var trId = $(this).attr("id");
        if(trId != "title"){
           var ruleRow = trId.split('r')[1];
           var ruleDes = $("#ruleDesc"+ruleRow).val();
           if(ruleDes!=null && ruleDes.length!=0){
              var bitNo = $("#bitNo"+ruleRow).combobox("getValue");
              var condition = $("#condition"+ruleRow).combobox("getValue");
              var ruleValue = $("#ruleValue"+ruleRow).val();
              ruleInfo += ruleDes+"@"+bitNo+"@"+condition+"@"+ruleValue+"#";
           }
          
        }
    });
    ruleInfo = ruleInfo.substring(0,ruleInfo.length-1);
    
     var time1 = $("#alarmStartTime1").val();
     var manId1 = $("#alarmStartMan1Id").val();
     var man1 = $("#alarmStartMan1").searchbox("getValue");
     if(man1==null || man1.length==0){
        manId1 = "";
     }
     
     var time2 = $("#alarmStartTime2").val();
     var man2 = $("#alarmStartMan2").searchbox("getValue");
     var manId2 = $("#alarmStartMan2Id").val();
     if(man2==null || man2.length==0){
         manId2 = "";
     }
     
     var time3 = $("#alarmStartTime3").val();
     var man3 = $("#alarmStartMan3").searchbox("getValue");
     var manId3 = $("#alarmStartMan3Id").val();
     if(man3==null || man3.length==0){
         manId3 = "";
     }
     
     $.ajax({
            url : './abnormal_survey_rule_data.ashx',
            data : {
                id:'<%=id %>',
                plantId:'<%=plantId %>',
                rule:ruleInfo,
                time1:time1,
                man1:manId1,
                manName1:man1,
                time2:time2,
                man2:manId2,
                manName2:man2,
                time3:time3,
                man3:manId3,
                manName3:man3
            },
            async:false,
            type:"post",
            success : function(data) {
                if(data=="1"){
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
  
   //����
    function back(){
       window.history.back();
    }
    
</script>
