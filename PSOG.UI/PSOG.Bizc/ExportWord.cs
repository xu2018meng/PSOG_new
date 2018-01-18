using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
//using System.Linq;
using System.Text;
//using System.Windows.Forms;
using System.Web.Script.Serialization;
//��Ҫ�����DLL
using System.IO;
using Microsoft.Office.Core;//COMѡ��е�"Microsoft Office 11.0 Object Library"
using Word = Microsoft.Office.Interop.Word;//.NETѡ��е�"Microsoft.Office.Interop.Word"
using Microsoft.Office.Interop.Word;
using System.Data.OleDb;
using PSOG.Entity;
using PSOG.Common;

namespace PSOG.Bizc
{
    public class ExportWord
    {
        string[] messages;
        public ExportWord(string[] args)
        {
            messages = args;
        }

        //Ϊ�˷������������ǩ����
        object[] BookMark = {
            //��ֵ��ǩ��
            "plantName",             //0,text
            "period",                //1,text
            "plantName1",         //2,text
            "assessTable",           //3,table
            "assessGraph",           //4,picture
            "areaDistribution",         //5,picture
            "chatteringDistribution",         //6,picture
            "standingDistribution",         //7,picture
            "timeDistributionOfAll",            //8,picture
            "priorityDistributionOfAll",       //9,picture
            "priorityDistributionOfEach",       //10,picture
            "alarmTop10",         //11,picture
            "alarmTop10Table",          //12,table
            "standingTop10Table",          //13,table
            "chatteringTop10Table",          //14,table
        };

        #region Word ���ݵ���
        /// <summary>
        /// ����ģ������word
        /// </summary>
        /// <param name="templateFile">ģ���ļ�</param>
        /// <param name="fileName">���ɵľ���ģ����ʽ�����ļ�</param>
        public void ExportWordFunction()
        {
            try
            {
                #region ����wordӦ�ó������
                string startTime = messages[1].Replace(":", "").Replace("-", "").Replace(" ", "");
                string endTime = messages[2].Replace(":", "").Replace("-", "").Replace(" ", "");
                //����word�������
                object obj = System.Reflection.Missing.Value;
                Word.Application app = new Word.Application();
                //ģ���ļ�
                string TemplateFile = messages[3] + "report 20150117.dot";

                //���ɵľ���ģ����ʽ�����ļ�
                string FileName = messages[3] + messages[0] + startTime + endTime + ".doc";

                //ģ���ļ����������ļ�
                File.Copy(TemplateFile, FileName);

                //����documnet����
                //Word.Document doc = app.Documents.Add(ref obj,ref obj ,ref obj ,ref obj);
                //Word.Document doc=app.Documents.Add(ref obj,ref obj,ref obj,ref,obj,ref obj);
                Word.Document doc = new Word.Document();
                object Obj_FileName = FileName;
                object Visible = true;
                object ReadOnly = false;
                object missing = System.Reflection.Missing.Value;

                //���ļ�
                doc = app.Documents.Open(ref Obj_FileName, ref missing, ref ReadOnly, ref missing,
                    ref missing, ref missing, ref missing, ref missing,
                    ref missing, ref missing, ref missing, ref Visible,
                    ref missing, ref missing, ref missing,
                    ref missing);
                doc.Activate();
                #endregion

                //��ֵ���ݵ���ǩ��λ��

                System.Data.DataRow[] tempTables;

                string plantName = "";
                if (messages[0] == "JJSH_CJYYT")
                {
                    plantName = "1#����ѹ";
                }
                if (messages[0] == "JJSH_CLHCJ")
                {
                    plantName = "1#�߻��ѻ�";
                }
                if (messages[0] == "JJSH_YJHYT")
                {
                    plantName = "�ӳٽ���";
                }
                if (messages[0] == "ZHLH_YCJY")
                {
                    plantName = "1#����ѹ";
                }
                doc.Bookmarks.get_Item(ref BookMark[0]).Range.Text = plantName;//�����ı�
                doc.Bookmarks.get_Item(ref BookMark[1]).Range.Text = messages[1] + "---" + messages[2];
                doc.Bookmarks.get_Item(ref BookMark[2]).Range.Text = plantName;

                //������
                //�ĵ��д������
                Range range = doc.Bookmarks.get_Item(ref BookMark[3]).Range;//������λ��
                Word.Table newTable = doc.Tables.Add(range, 9, 4, ref missing, ref missing);
                //���ñ����ʽ
                newTable.Borders.OutsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                newTable.Borders.InsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                newTable.Columns[1].Width = 70f;
                newTable.Columns[2].Width = 60f;
                newTable.Columns[3].Width = 60f;
                newTable.Columns[4].Width = 250f;
                newTable.Cell(1, 1).Range.Text = "";
                newTable.Cell(1, 2).Range.Text = "��ǰֵ";
                newTable.Cell(1, 3).Range.Text = "Ŀ��ֵ";
                newTable.Cell(1, 4).Range.Text = "��ע";
                List<AlarmLevelTotal> lists = BeanTools.getBoList<AlarmLevelTotal>(messages[4]);
                for (int i = 0; i < 8; i++)
                {
                    //���������
                    newTable.Cell(i + 2, 1).Range.Text = lists[i].index_name;
                    newTable.Cell(i + 2, 2).Range.Text = lists[i].plant_num;
                    newTable.Cell(i + 2, 3).Range.Text = lists[i].index_goal;
                    newTable.Cell(i + 2, 4).Range.Text = lists[i].remark;
                }

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[4]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_0.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[5]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_1.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[6]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_2.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[7]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_3.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[8]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_4.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[9]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_5.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[10]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_6.png", ref missing, ref missing, ref missing);

                //����ͼƬ
                doc.Bookmarks.get_Item(ref BookMark[11]).Select();
                app.Selection.ParagraphFormat.Alignment = Word.WdParagraphAlignment.wdAlignParagraphCenter;
                app.Selection.InlineShapes.AddPicture(messages[3] + messages[0] + startTime + endTime + "_7.png", ref missing, ref missing, ref missing);

                //������
                List<AlarmTop20> lists_2 = BeanTools.getBoList<AlarmTop20>(messages[5]);
                //�ĵ��д������
                range = doc.Bookmarks.get_Item(ref BookMark[12]).Range;//������λ��
                newTable = doc.Tables.Add(range, 1+lists_2.Count, 4, ref missing, ref missing);
                //���ñ����ʽ
                newTable.Borders.OutsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                newTable.Borders.InsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                //newTable.Columns[1].Width = 100f;
                //newTable.Columns[2].Width = 100f;
                //newTable.Columns[3].Width = 10f;
                //newTable.Columns[4].Width = 105f;
                newTable.Cell(1, 1).Range.Text = "λ��";
                newTable.Cell(1, 2).Range.Text = "����";
                newTable.Cell(1, 3).Range.Text = "��������";
                newTable.Cell(1, 4).Range.Text = "ռ����%";

                for (int i = 0; i < lists_2.Count; i++)
                {
                    //���������
                    newTable.Cell(i + 2, 1).Range.Text = lists_2[i].tagname;
                    newTable.Cell(i + 2, 2).Range.Text = lists_2[i].area;
                    newTable.Cell(i + 2, 3).Range.Text = lists_2[i].count.ToString();
                    newTable.Cell(i + 2, 4).Range.Text = lists_2[i].percent.ToString();
                }

                //������
                List<AlarmStanding> lists_3 = BeanTools.getBoList<AlarmStanding>(messages[6]);
                //�ĵ��д������
                range = doc.Bookmarks.get_Item(ref BookMark[13]).Range;//������λ��
                newTable = doc.Tables.Add(range, 1 + lists_3.Count, 5, ref missing, ref missing);
                //���ñ����ʽ
                newTable.Borders.OutsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                newTable.Borders.InsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                //newTable.Columns[1].Width = 100f;
                //newTable.Columns[2].Width = 100f;
                //newTable.Columns[3].Width = 10f;
                //newTable.Columns[4].Width = 105f;
                newTable.Cell(1, 1).Range.Text = "λ��";
                newTable.Cell(1, 2).Range.Text = "����";
                newTable.Cell(1, 3).Range.Text = "������ʼʱ��";
                newTable.Cell(1, 4).Range.Text = "��������ʱ��";
                newTable.Cell(1, 5).Range.Text = "��������ʱ�䣨���ӣ�";

                for (int i = 0; i < lists_3.Count; i++)
                {
                    //���������
                    newTable.Cell(i + 2, 1).Range.Text = lists_3[i].tagname;
                    newTable.Cell(i + 2, 2).Range.Text = lists_3[i].area;
                    newTable.Cell(i + 2, 3).Range.Text = lists_3[i].startTime;
                    newTable.Cell(i + 2, 4).Range.Text = lists_3[i].endTime;
                    newTable.Cell(i + 2, 5).Range.Text = lists_3[i].alarmInterval.ToString();
                }

                //������
                List<AlarmChattering> lists_4 = BeanTools.getBoList<AlarmChattering>(messages[7]);
                //�ĵ��д������
                range = doc.Bookmarks.get_Item(ref BookMark[14]).Range;//������λ��
                newTable = doc.Tables.Add(range, 1 + lists_4.Count, 5, ref missing, ref missing);
                //���ñ����ʽ
                newTable.Borders.OutsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                newTable.Borders.InsideLineStyle = Word.WdLineStyle.wdLineStyleSingle;
                //newTable.Columns[1].Width = 100f;
                //newTable.Columns[2].Width = 100f;
                //newTable.Columns[3].Width = 10f;
                //newTable.Columns[4].Width = 105f;
                newTable.Cell(1, 1).Range.Text = "λ��";
                newTable.Cell(1, 2).Range.Text = "����";
                newTable.Cell(1, 3).Range.Text = "�ظ���������";
                newTable.Cell(1, 4).Range.Text = "�����ܴ���";
                newTable.Cell(1, 5).Range.Text = "�ظ�������";

                for (int i = 0; i < lists_4.Count; i++)
                {
                    //���������
                    newTable.Cell(i + 2, 1).Range.Text = lists_4[i].tagname;
                    newTable.Cell(i + 2, 2).Range.Text = lists_4[i].area;
                    newTable.Cell(i + 2, 3).Range.Text = lists_4[i].chatteringCount.ToString();
                    newTable.Cell(i + 2, 4).Range.Text = lists_4[i].totalCount.ToString();
                    newTable.Cell(i + 2, 5).Range.Text = lists_4[i].percent.ToString();
                }

                //�����Ϻ�ر�doc����
                object IsSave = true;
                doc.Close(ref IsSave, ref missing, ref missing);
            }


            catch (Exception Ex)
            {

                return;
            }
        }
        #endregion
    }
}
