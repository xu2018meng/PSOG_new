using System;
using System.Collections.Generic;
using System.Text;
using NPOI.HSSF.Model;
using NPOI.SS.UserModel;
using NPOI.HSSF.UserModel;
using PSOG.Entity;
using System.Data;
using PSOG.Common;
using System.IO;
using NPOI.HSSF.Util;
using NPOI.Util.Collections;
using System.Data;
using System.Data.SqlClient;

namespace PSOG.Bizc
{
    class ExpExecl
    {
        /// <summary>
        /// ��ͷ��ʽ
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns></returns>
        public static ICellStyle getHeadStyle(HSSFWorkbook workbook)
        {
            //��ͷ��ʽ
            ICellStyle style = workbook.CreateCellStyle();
            style.Alignment = HorizontalAlignment.CENTER;//���ж���
            //��ͷ��Ԫ�񱳾�ɫ
            style.FillForegroundColor = HSSFColor.WHITE.index;
            //style.FillPattern = FillPatternType.SOLID_FOREGROUND;
            //��ͷ��Ԫ��߿�
            style.BorderTop = BorderStyle.THIN;
            style.TopBorderColor = HSSFColor.BLACK.index;
            style.BorderRight = BorderStyle.THIN;
            style.RightBorderColor = HSSFColor.BLACK.index;
            style.BorderBottom = BorderStyle.THIN;
            style.BottomBorderColor = HSSFColor.BLACK.index;
            style.BorderLeft = BorderStyle.THIN;
            style.LeftBorderColor = HSSFColor.BLACK.index;
            return style;
        }

        /// <summary>
        /// ��ȡ������ʽ
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns></returns>
        public static ICellStyle getDataStyle(HSSFWorkbook workbook)
        {
            ICellStyle datastyle = workbook.CreateCellStyle();
            datastyle.Alignment = HorizontalAlignment.LEFT;//�����
            //���ݵ�Ԫ��ı߿�
            datastyle.BorderTop = BorderStyle.THIN;
            datastyle.TopBorderColor = HSSFColor.BLACK.index;
            datastyle.BorderRight = BorderStyle.THIN;
            datastyle.RightBorderColor = HSSFColor.BLACK.index;
            datastyle.BorderBottom = BorderStyle.THIN;
            datastyle.BottomBorderColor = HSSFColor.BLACK.index;
            datastyle.BorderLeft = BorderStyle.THIN;
            datastyle.LeftBorderColor = HSSFColor.BLACK.index;
            return datastyle;
        }

        /// <summary>
        /// ��ʷ��¼����
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream ToExcel(DataTable dt1, DataTable dt2)
        {
            MemoryStream ms = new MemoryStream();
            
            int rowIndex = 0;

            //����workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("������ʷͳ��");
            IRow row = sheet1.CreateRow(rowIndex);
            
            ISheet sheet2 = workbook.CreateSheet("��������ͳ��");
            IRow statisRow = sheet2.CreateRow(rowIndex);


            //��ͷ��ʽ
            ICellStyle style = getHeadStyle(workbook);
            //��ͷ��������
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//�ֺ�
            font.Boldweight = 600;//�Ӵ�
            font.Color = HSSFColor.BLACK.index;//��ɫ
            style.SetFont(font);

            //������ʽ
            ICellStyle datastyle = getDataStyle(workbook);

            //���ݵ�����
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//�ֺ�
            datastyle.SetFont(datafont);

            fillHisData(dt1, sheet1, row, datastyle, datafont, style, font, rowIndex);
            fillStatisData(dt2, sheet2, statisRow, datastyle, datafont, style, font, rowIndex);

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            workbook = null;
            sheet1 = null;
            sheet2 = null;
            row = null;
            statisRow = null;

            return ms;
        }

        /// <summary>
        /// ������ʷͳ��
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="sheet"></param>
        /// <param name="row"></param>
        /// <param name="datastyle"></param>
        /// <param name="datafont"></param>
        /// <param name="style"></param>
        /// <param name="font"></param>
        /// <param name="rowIndex"></param>
        public static void fillHisData(DataTable dt, ISheet sheet, IRow row, ICellStyle datastyle, IFont datafont, ICellStyle style, IFont font, int rowIndex)
        {
            //�����п�
            sheet.SetColumnWidth(0, 4000);
            sheet.SetColumnWidth(1, 8000);
            sheet.SetColumnWidth(2, 2600);
            sheet.SetColumnWidth(3, 2000);
            sheet.SetColumnWidth(4, 6000);
            sheet.SetColumnWidth(5, 5500);
            sheet.SetColumnWidth(6, 5500);

            //�����и�
            sheet.DefaultRowHeight = 350;

            //��ͷ����
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("λ��");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("����");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("״̬");
            cell2.CellStyle = style;

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("�ּ�");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("����ʱ��");
            cell4.CellStyle = style;

            ICell cell5 = row.CreateCell(5);
            cell5.SetCellValue("��ʼʱ��");
            cell5.CellStyle = style;

            ICell cell6 = row.CreateCell(6);
            cell6.SetCellValue("����ʱ��");
            cell6.CellStyle = style;

            //�������
            if (null != dt)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    rowIndex++;
                    row = sheet.CreateRow(rowIndex);

                    cell0 = row.CreateCell(0);
                    cell0.SetCellValue(BeanTools.ObjectToString(dr["AlarmManager_History_Items"]));
                    cell0.CellStyle = datastyle;

                    cell1 = row.CreateCell(1);
                    cell1.SetCellValue(BeanTools.ObjectToString(dr["AlarmManager_History_Describe"]));
                    cell1.CellStyle = datastyle;
                    cell1.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    cell2 = row.CreateCell(2);
                    cell2.SetCellValue(BeanTools.ObjectToString(dr["AlarmManager_History_State"]));
                    cell2.CellStyle = datastyle;

                    cell3 = row.CreateCell(3);
                    cell3.SetCellValue(BeanTools.ObjectToString(dr["AlarmManager_History_AlarmClass"]));
                    cell3.CellStyle = datastyle;
                    cell3.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    string startTime = BeanTools.ObjectToString(dr["AlarmManager_History_StartTime"]);
                    string endTime = BeanTools.ObjectToString(dr["AlarmManager_History_EndTime"]);
                    long duration = (string.IsNullOrEmpty(endTime) ? DateTime.Now.Ticks : DateTime.Parse(endTime).Ticks - DateTime.Parse(startTime).Ticks) / 555000000;
                    cell4 = row.CreateCell(4);
                    cell4.SetCellValue(duration);
                    cell4.CellStyle = datastyle;

                    cell5 = row.CreateCell(5);
                    cell5.SetCellValue(BeanTools.DataTimeToString(dr["AlarmManager_History_StartTime"]));
                    cell5.CellStyle = datastyle;
                    cell5.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    cell6 = row.CreateCell(6);
                    cell6.SetCellValue(BeanTools.DataTimeToString(dr["AlarmManager_History_EndTime"]));
                    cell6.CellStyle = datastyle;
                }
            }
        }

        /// <summary>
        /// ��������ͳ��
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="sheet"></param>
        /// <param name="row"></param>
        /// <param name="datastyle"></param>
        /// <param name="datafont"></param>
        /// <param name="style"></param>
        /// <param name="font"></param>
        /// <param name="rowIndex"></param>
        public static void fillStatisData(DataTable dt, ISheet sheet, IRow row, ICellStyle datastyle, IFont datafont, ICellStyle style, IFont font, int rowIndex)
        {
            //�����п�
            sheet.SetColumnWidth(0, 4500);

            sheet.SetColumnWidth(1, 4500);

            sheet.SetColumnWidth(2, 10000);

            //�����и�
            sheet.DefaultRowHeight = 350;

            //��ͷ����
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("λ��");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("����");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("����");
            cell2.CellStyle = style;

            //�������
            if (null != dt)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    rowIndex++;
                    row = sheet.CreateRow(rowIndex);

                    cell0 = row.CreateCell(0);
                    cell0.SetCellValue(BeanTools.ObjectToString(dr["alarmmanager_history_items"]));
                    cell0.CellStyle = datastyle;

                    cell1 = row.CreateCell(1);
                    cell1.SetCellValue(BeanTools.ObjectToString(dr["statisNo"]));
                    cell1.CellStyle = datastyle;
                    cell1.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    cell2 = row.CreateCell(2);
                    cell2.SetCellValue(BeanTools.ObjectToString(dr["alarmmanager_describe"]));
                    cell2.CellStyle = datastyle;

                }
            }
        }

        /// <summary>
        /// �ȶ��ʷ�������
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream stableRateToExcel(SqlDataReader dr)
        {
            MemoryStream ms = new MemoryStream();

            int rowIndex = 0;

            //����workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("������������");
            IRow row = sheet1.CreateRow(rowIndex);


            //��ͷ��ʽ
            ICellStyle style = getHeadStyle(workbook);
            //��ͷ��������
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//�ֺ�
            font.Boldweight = 600;//�Ӵ�
            font.Color = HSSFColor.BLACK.index;//��ɫ
            style.SetFont(font);

            //������ʽ
            ICellStyle datastyle = getDataStyle(workbook);

            //���ݵ�����
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//�ֺ�
            datastyle.SetFont(datafont);

            fillStableRateData(dr, sheet1, row, datastyle, datafont, style, font, rowIndex);

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            workbook = null;
            sheet1 = null;
            row = null;

            return ms;
        }

        public static void fillStableRateData(SqlDataReader dr, ISheet sheet, IRow row, ICellStyle datastyle, IFont datafont, ICellStyle style, IFont font, int rowIndex)
        {
            //�����п�
            sheet.SetColumnWidth(0, 4000);
            sheet.SetColumnWidth(1, 8000);
            sheet.SetColumnWidth(2, 2600);
            sheet.SetColumnWidth(3, 3200);
            sheet.SetColumnWidth(4, 3200);
            //sheet.SetColumnWidth(5, 3200);
            //sheet.SetColumnWidth(6, 3200);
            sheet.SetColumnWidth(5, 3200);
            sheet.SetColumnWidth(6, 3200);
            sheet.SetColumnWidth(7, 3200);
            sheet.SetColumnWidth(8, 4200);
            sheet.SetColumnWidth(9, 4200);
            sheet.SetColumnWidth(10, 4200);
            sheet.SetColumnWidth(11, 4200);
            sheet.SetColumnWidth(12, 3800);

            //�����и�
            sheet.DefaultRowHeight = 350;

            //��ͷ����
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("λ��");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("����");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("����");
            cell2.CellStyle = style;

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("��������");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("��������");
            cell4.CellStyle = style;

            //ICell cell5 = row.CreateCell(5);
            //cell5.SetCellValue("����USL");
            //cell5.CellStyle = style;

            //ICell cell6 = row.CreateCell(6);
            //cell6.SetCellValue("����LSL");
            //cell6.CellStyle = style;

            ICell cell5 = row.CreateCell(5);
            cell5.SetCellValue("��������");
            cell5.CellStyle = style;

            ICell cell6 = row.CreateCell(6);
            cell6.SetCellValue("��������ֵ��");
            cell6.CellStyle = style;

            ICell cell7 = row.CreateCell(7);
            cell7.SetCellValue("�ϸ���");
            cell7.CellStyle = style;

            ICell cell8 = row.CreateCell(8);
            cell8.SetCellValue("׼ȷ��Ca");
            cell8.CellStyle = style;

            ICell cell9 = row.CreateCell(9);
            cell9.SetCellValue("���ܶ�Cp");
            cell9.CellStyle = style;

            ICell cell10 = row.CreateCell(10);
            cell10.SetCellValue("��������ָ��");
            cell10.CellStyle = style;
            //�������
            if (null != dr)
            {
                while (dr.Read())
                {
                    rowIndex++;
                    row = sheet.CreateRow(rowIndex);

                    cell0 = row.CreateCell(0);
                    cell0.SetCellValue(BeanTools.ObjectToString(dr["insItems"]));
                    cell0.CellStyle = datastyle;

                    cell1 = row.CreateCell(1);
                    cell1.SetCellValue(BeanTools.ObjectToString(dr["insDescribe"]));
                    cell1.CellStyle = datastyle;
                    cell1.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    cell2 = row.CreateCell(2);
                    cell2.SetCellValue(BeanTools.ObjectToString(dr["insAlarmClass"]));
                    cell2.CellStyle = datastyle;

                    cell3 = row.CreateCell(3);
                    cell3.SetCellValue(BeanTools.ObjectToString(dr["insTechnicsH"]));
                    cell3.CellStyle = datastyle;
                    cell3.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    string insTechnicsH = BeanTools.ObjectToString(dr["insTechnicsL"]);
                    cell4 = row.CreateCell(4);
                    cell4.SetCellValue(insTechnicsH);
                    cell4.CellStyle = datastyle;

                    //cell5 = row.CreateCell(5);
                    //cell5.SetCellValue(BeanTools.ObjectToString(dr["insCpkUSL"]));
                    //cell5.CellStyle = datastyle;
                    //cell5.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    //cell6 = row.CreateCell(6);
                    //cell6.SetCellValue(BeanTools.ObjectToString(dr["insCpkLSL"]));
                    //cell6.CellStyle = datastyle;

                    cell5 = row.CreateCell(5);
                    cell5.SetCellValue(BeanTools.ObjectToString(dr["insDataCount"]));
                    cell5.CellStyle = datastyle;

                    cell6 = row.CreateCell(6);
                    cell6.SetCellValue(BeanTools.ObjectToString(dr["insErrorDataCount"]));
                    cell6.CellStyle = datastyle;
                    cell6.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    cell7 = row.CreateCell(7);
                    cell7.SetCellValue(BeanTools.ObjectToString(dr["insPercent"]));
                    cell7.CellStyle = datastyle;

                    cell8 = row.CreateCell(8);
                    cell8.SetCellValue(BeanTools.ObjectToString(dr["insCpkCa"]));
                    cell8.CellStyle = datastyle;
                    cell8.CellStyle.Alignment = HorizontalAlignment.LEFT;

                    string insCpkCa = BeanTools.ObjectToString(dr["insCpkCp"]);
                    cell9 = row.CreateCell(9);
                    cell9.SetCellValue(insCpkCa);
                    cell9.CellStyle = datastyle;

                    cell10 = row.CreateCell(10);
                    cell10.SetCellValue(BeanTools.ObjectToString(dr["insCpk"]));
                    cell10.CellStyle = datastyle;
                    cell10.CellStyle.Alignment = HorizontalAlignment.LEFT;
                }
            }
        }

        /// <summary>
        /// �ۺϷ�������
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream CompToExcel(SqlDataReader dr)
        {
            MemoryStream ms = new MemoryStream();

            int rowIndex = 0;

            //����workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("10Minƽ��������");
            IRow row = sheet1.CreateRow(rowIndex);


            //��ͷ��ʽ
            ICellStyle style = getHeadStyle(workbook);
            //��ͷ��������
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//�ֺ�
            font.Boldweight = 600;//�Ӵ�
            font.Color = HSSFColor.BLACK.index;//��ɫ
            style.SetFont(font);

            //������ʽ
            ICellStyle datastyle = getDataStyle(workbook);

            //���ݵ�����
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//�ֺ�
            datastyle.SetFont(datafont);

            fillcompToData(dr, sheet1, row, datastyle, datafont, style, font, rowIndex);

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            workbook = null;
            sheet1 = null;
            row = null;

            return ms;
        }

        public static void fillcompToData(SqlDataReader dr, ISheet sheet, IRow row, ICellStyle datastyle, IFont datafont, ICellStyle style, IFont font, int rowIndex)
        {
            //�����п�
            sheet.SetColumnWidth(0, 5500);
            sheet.SetColumnWidth(1, 5500);
            sheet.SetColumnWidth(2, 3700);
            sheet.SetColumnWidth(3, 5000);
            sheet.SetColumnWidth(4, 9000);

            //�����и�
            sheet.DefaultRowHeight = 350;

            //��ͷ����
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("��ʼʱ��");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("����ʱ��");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("��������");
            cell2.CellStyle = style;
            

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("10Minƽ��������");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("����λ��");
            cell4.CellStyle = style;

            //�������
            if (null != dr)
            {
                while (dr.Read())
                {
                    rowIndex++;
                    row = sheet.CreateRow(rowIndex);

                    cell0 = row.CreateCell(0);
                    cell0.SetCellValue(BeanTools.DataTimeToString(dr["ZHStartTime"]));
                    cell0.CellStyle = datastyle;

                    cell1 = row.CreateCell(1);
                    cell1.SetCellValue(BeanTools.DataTimeToString(dr["ZHEndTime"]));
                    cell1.CellStyle = datastyle;
                    

                    cell2 = row.CreateCell(2);
                    cell2.SetCellValue(BeanTools.ObjectToString(dr["ZHErrorCount"]));
                    cell2.CellStyle = datastyle;
                    cell2.CellStyle.Alignment = HorizontalAlignment.RIGHT;

                    cell3 = row.CreateCell(3);
                    cell3.SetCellValue(Math.Round(BeanTools.ObjectToDouble(dr["ZHPercent"]),7));
                    cell3.CellStyle = datastyle;
                    cell3.CellStyle.Alignment = HorizontalAlignment.RIGHT;

                    string startTime = BeanTools.ObjectToString(dr["ZHAlarmItems"]);
                    cell4 = row.CreateCell(4);
                    cell4.SetCellValue(startTime);
                    cell4.CellStyle = datastyle;
                    cell3.CellStyle.Alignment = HorizontalAlignment.LEFT;
                }
            }
        }
    }
}
