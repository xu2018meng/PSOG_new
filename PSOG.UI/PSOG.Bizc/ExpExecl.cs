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
        /// 表头样式
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns></returns>
        public static ICellStyle getHeadStyle(HSSFWorkbook workbook)
        {
            //表头样式
            ICellStyle style = workbook.CreateCellStyle();
            style.Alignment = HorizontalAlignment.CENTER;//居中对齐
            //表头单元格背景色
            style.FillForegroundColor = HSSFColor.WHITE.index;
            //style.FillPattern = FillPatternType.SOLID_FOREGROUND;
            //表头单元格边框
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
        /// 获取数据样式
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns></returns>
        public static ICellStyle getDataStyle(HSSFWorkbook workbook)
        {
            ICellStyle datastyle = workbook.CreateCellStyle();
            datastyle.Alignment = HorizontalAlignment.LEFT;//左对齐
            //数据单元格的边框
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
        /// 历史记录导出
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream ToExcel(DataTable dt1, DataTable dt2)
        {
            MemoryStream ms = new MemoryStream();
            
            int rowIndex = 0;

            //创建workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("报警历史统计");
            IRow row = sheet1.CreateRow(rowIndex);
            
            ISheet sheet2 = workbook.CreateSheet("报警次数统计");
            IRow statisRow = sheet2.CreateRow(rowIndex);


            //表头样式
            ICellStyle style = getHeadStyle(workbook);
            //表头字体设置
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//字号
            font.Boldweight = 600;//加粗
            font.Color = HSSFColor.BLACK.index;//颜色
            style.SetFont(font);

            //数据样式
            ICellStyle datastyle = getDataStyle(workbook);

            //数据的字体
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//字号
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
        /// 报警历史统计
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
            //设置列宽
            sheet.SetColumnWidth(0, 4000);
            sheet.SetColumnWidth(1, 8000);
            sheet.SetColumnWidth(2, 2600);
            sheet.SetColumnWidth(3, 2000);
            sheet.SetColumnWidth(4, 6000);
            sheet.SetColumnWidth(5, 5500);
            sheet.SetColumnWidth(6, 5500);

            //设置行高
            sheet.DefaultRowHeight = 350;

            //表头数据
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("位号");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("描述");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("状态");
            cell2.CellStyle = style;

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("分级");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("持续时间");
            cell4.CellStyle = style;

            ICell cell5 = row.CreateCell(5);
            cell5.SetCellValue("开始时间");
            cell5.CellStyle = style;

            ICell cell6 = row.CreateCell(6);
            cell6.SetCellValue("结束时间");
            cell6.CellStyle = style;

            //填充数据
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
        /// 报警次数统计
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
            //设置列宽
            sheet.SetColumnWidth(0, 4500);

            sheet.SetColumnWidth(1, 4500);

            sheet.SetColumnWidth(2, 10000);

            //设置行高
            sheet.DefaultRowHeight = 350;

            //表头数据
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("位号");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("次数");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("描述");
            cell2.CellStyle = style;

            //填充数据
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
        /// 稳定率分析导出
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream stableRateToExcel(SqlDataReader dr)
        {
            MemoryStream ms = new MemoryStream();

            int rowIndex = 0;

            //创建workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("操作质量分析");
            IRow row = sheet1.CreateRow(rowIndex);


            //表头样式
            ICellStyle style = getHeadStyle(workbook);
            //表头字体设置
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//字号
            font.Boldweight = 600;//加粗
            font.Color = HSSFColor.BLACK.index;//颜色
            style.SetFont(font);

            //数据样式
            ICellStyle datastyle = getDataStyle(workbook);

            //数据的字体
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//字号
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
            //设置列宽
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

            //设置行高
            sheet.DefaultRowHeight = 350;

            //表头数据
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("位号");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("描述");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("类型");
            cell2.CellStyle = style;

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("工艺上限");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("工艺下限");
            cell4.CellStyle = style;

            //ICell cell5 = row.CreateCell(5);
            //cell5.SetCellValue("上限USL");
            //cell5.CellStyle = style;

            //ICell cell6 = row.CreateCell(6);
            //cell6.SetCellValue("下限LSL");
            //cell6.CellStyle = style;

            ICell cell5 = row.CreateCell(5);
            cell5.SetCellValue("数据总数");
            cell5.CellStyle = style;

            ICell cell6 = row.CreateCell(6);
            cell6.SetCellValue("超工艺阈值数");
            cell6.CellStyle = style;

            ICell cell7 = row.CreateCell(7);
            cell7.SetCellValue("合格率");
            cell7.CellStyle = style;

            ICell cell8 = row.CreateCell(8);
            cell8.SetCellValue("准确度Ca");
            cell8.CellStyle = style;

            ICell cell9 = row.CreateCell(9);
            cell9.SetCellValue("精密度Cp");
            cell9.CellStyle = style;

            ICell cell10 = row.CreateCell(10);
            cell10.SetCellValue("操作质量指数");
            cell10.CellStyle = style;
            //填充数据
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
        /// 综合分析导出
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static MemoryStream CompToExcel(SqlDataReader dr)
        {
            MemoryStream ms = new MemoryStream();

            int rowIndex = 0;

            //创建workbook
            HSSFWorkbook workbook = new HSSFWorkbook();

            ISheet sheet1 = workbook.CreateSheet("10Min平均报警率");
            IRow row = sheet1.CreateRow(rowIndex);


            //表头样式
            ICellStyle style = getHeadStyle(workbook);
            //表头字体设置
            IFont font = workbook.CreateFont();
            font.FontHeightInPoints = 12;//字号
            font.Boldweight = 600;//加粗
            font.Color = HSSFColor.BLACK.index;//颜色
            style.SetFont(font);

            //数据样式
            ICellStyle datastyle = getDataStyle(workbook);

            //数据的字体
            IFont datafont = workbook.CreateFont();
            datafont.FontHeightInPoints = 11;//字号
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
            //设置列宽
            sheet.SetColumnWidth(0, 5500);
            sheet.SetColumnWidth(1, 5500);
            sheet.SetColumnWidth(2, 3700);
            sheet.SetColumnWidth(3, 5000);
            sheet.SetColumnWidth(4, 9000);

            //设置行高
            sheet.DefaultRowHeight = 350;

            //表头数据
            ICell cell0 = row.CreateCell(0);
            cell0.SetCellValue("开始时间");
            cell0.CellStyle = style;

            ICell cell1 = row.CreateCell(1);
            cell1.SetCellValue("结束时间");
            cell1.CellStyle = style;

            ICell cell2 = row.CreateCell(2);
            cell2.SetCellValue("报警个数");
            cell2.CellStyle = style;
            

            ICell cell3 = row.CreateCell(3);
            cell3.SetCellValue("10Min平均报警率");
            cell3.CellStyle = style;

            ICell cell4 = row.CreateCell(4);
            cell4.SetCellValue("报警位号");
            cell4.CellStyle = style;

            //填充数据
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
