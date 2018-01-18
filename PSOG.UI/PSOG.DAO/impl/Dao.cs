using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.Data.SqlClient;
using log4net;
using PSOG.Common;
using PSOG.Entity;
namespace PSOG.DAO.impl
{
    public class Dao : IDao
    {
        public static string StartupPath = "";
        public OleDbConnection Conn;
        public static string Dbpath = StartupPath + "\\RSESDataBase.mdb";//连接字符串
        public static string IsSqlServer = "1";//地址
        public static string strServer = "127.0.0.1";//地址
        public static string strPort = "1433";//端口
        public static string strDatabase = "Soft_Qdrise_PSOG_BLHJT";//数据库名称
        public static string struid = "sa";//用户名
        public static string strpwd = "123";//密码
        public static string IsRSqlServer = "1";//地址
        public static string strRServer = "127.0.0.1";//地址
        public static string strRPort = "1433";//端口
        public static string strRDatabase = "Soft_Qdrise_PSOG_BLHJT";//数据库名称
        public static string strRuid = "sa";//用户名
        public static string strRpwd = "123";//密码
        public static string PesFileName;//所对应的异常工况库的文件名
        public static string SYS_DATABASETable;
        public static string SYSConnString = "";
        public string ConnString;

        static ILog log4 = LogManager.GetLogger(typeof(IDao));
        static String strConnection = System.Configuration.ConfigurationManager.AppSettings["DBConnection"];//读取web.config中配置的连接串 主配置数据库
        String noDBConnection = System.Configuration.ConfigurationManager.AppSettings["noDBConnection"];//读取web.config中配置的连接串  子数据库
        Boolean mainDB = false;
        SqlConnection connection = null;
        //static String hisConnection = "Data Source=10.206.1.81;Initial Catalog=Soft_Qdrise_PSOG_YSSH_FCC2;Integrated Security=false;User ID=sa;Password=!QAZ2wsx; max pool size=50; Connection Lifetime=600;";
        public SqlConnection conn
        {
            get 
            {
                if (true == mainDB)//
                {
                    return new SqlConnection(strConnection);
                }
                else
                {
                    return new SqlConnection(noDBConnection);
                }
            }
        }


        public Dao(String initialCatalog)
        {

            noDBConnection = "Initial Catalog=" + initialCatalog + ";" + noDBConnection;
        }
        public Dao()
        {
            mainDB = true;
        }
        public Dao(Plant plant)
        {
            noDBConnection = "Data Source=" + plant.realTimeDBIP + "," + plant.realTimeDBPort + ";Initial Catalog=" + plant.realTimeDB
                + ";Integrated Security=false;User ID=" + plant.realTimeDBUser + ";Password=" + plant.realTimeDBPass + "; max pool size=50; Connection Lifetime=600;Connect Timeout=600";
        }

        public Dao(Plant plant, bool ishistory)
        {
            if (ishistory)
            {
                noDBConnection = "Data Source=" + plant.historyDBIP + "," + plant.historyDBPort + ";Initial Catalog=" + plant.historyDB
                    + ";Integrated Security=false;User ID=" + plant.historyDBUser + ";Password=" + plant.historyDBPass + "; max pool size=50; Connection Lifetime=600;Connect Timeout=600";
            }
            else
            {
                noDBConnection = "Data Source=" + plant.realTimeDBIP + "," + plant.realTimeDBPort + ";Initial Catalog=" + plant.realTimeDB
                    + ";Integrated Security=false;User ID=" + plant.realTimeDBUser + ";Password=" + plant.realTimeDBPass + "; max pool size=50; Connection Lifetime=600;Connect Timeout=600";
            }
        }
   
        /// <summary>
        /// 执行存储过程
        /// </summary>
        /// <param name="procName"></param>
        /// <param name="parames"></param>
        /// <returns></returns>
        public SqlDataReader executeProc(String procName, SqlParameter[] parames)
        {
            connection = conn;
            SqlDataReader dr = null;
            if (!string.IsNullOrEmpty(procName))
            {
                SqlCommand com = connection.CreateCommand();
                com.CommandText = procName;
                com.CommandType = CommandType.StoredProcedure;
                com.CommandTimeout = 600;
                connection.Open();
                foreach (SqlParameter parame in parames)
                {
                    com.Parameters.Add(parame);
                }
                try
                {
                    dr = com.ExecuteReader();
                }
                catch (Exception exp)
                { }
                //connection.Close();
            }
            return dr;
        }
        /// <summary>
        /// 执行存储过程 DATASET
        /// </summary>
        /// <param name="procName"></param>
        /// <param name="parames"></param>
        /// <returns></returns>
        public DataSet executeProcDS(String procName, String subtableName)
        {
            connection = conn;
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlCommand command = new SqlCommand(procName, connection);
            adapter.SelectCommand = command;
            DataSet Ds = new DataSet();
            Ds.Tables.Add(subtableName);
            try
            {
                adapter.Fill(Ds, subtableName);
                return Ds;
            }
            catch (Exception e)
            {
                string str=e.Message;
                return null;
            }
        }
        /// <summary>
        /// 关闭连接
        /// </summary>
        public void closeConn()
        {
            if (null != connection)
            {
                connection.Close();
                connection = null;
            }
        }

        /**
         * 执行sql查询，通过对args解析绑定参数，返回DataSet数据类型
         * 
         */
        public DataSet executeQuery(String sql, Dictionary<String, Object> args)
        {
            DataSet ds = new DataSet();
            try
            {
                SqlDataAdapter adp = new SqlDataAdapter(sql, this.conn);
                if (null != args)
                {
                    Dictionary<String, Object>.KeyCollection keys = args.Keys;
                    Object argsValue;
                    foreach (Object obj in keys)
                    {
                        argsValue = null;
                        if (args.TryGetValue(obj.ToString(), out argsValue))
                        {
                            adp.SelectCommand.Parameters.Add(obj.ToString(), SqlDbType.VarChar).Value = argsValue;//绑定参数

                        }
                    }
                }
                log4.Info(sql); //当前执行的sql输出到日志中
                adp.Fill(ds, "default");
            }
            catch (Exception exp)
            {
                conn.Close();
                throw exp;
            }
            return ds;
        }

        /**
         * String sql, SqlParameter sqlPara
         * 执行sql查询，通过对sqlPara解析绑定参数，返回DataSet数据类型
         * 
         */
        public DataSet executeQuery(String sql, SqlParameter[] sqlPara)
        {
            DataSet ds = new DataSet();
            try
            {
                SqlDataAdapter adp = new SqlDataAdapter(sql, conn);
                if (null != sqlPara)
                {
                    adp.SelectCommand.Parameters.AddRange(sqlPara);
                }
                log4.Info(sql); //当前执行的sql输出到日志中
                adp.Fill(ds, "default");
            }
            catch (Exception exp)
            {
                conn.Close();
                throw exp;
            }
            return ds;
        }

        /**
         * 执行sql查询，通过对args解析绑定参数，pageNo 请求第几页，pageSize 每页多少条记录 
         * sql 语句含order by 请在select 后加 top 100 percent
         * 返回DataSet数据类型
         */
        public DataSet executeQuery(String sql, Dictionary<String, Object> args, int pageNo, int pageSize)
        {
            sql = getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql
            DataSet ds = executeQuery(sql, args);
            return ds;
        }

        /**
         * 执行sql查询，SqlParameter[] args，pageNo 请求第几页，pageSize 每页多少条记录 
         * sql 语句含order by 请在select 后加 top 100 percent
         * 返回DataSet数据类型
         */
        public DataSet executeQuery(String sql, SqlParameter[] args, int pageNo, int pageSize)
        {
            sql = getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql
            DataSet ds = executeQuery(sql, args);
            return ds;
        }

        /**
         * 执行sql查询，返回DataSet数据类型
         * 
         */
        public DataSet executeQuery(String sql)
        {
            DataSet ds = new DataSet();
            try
            {
                SqlDataAdapter adp = new SqlDataAdapter(sql, conn);
                log4.Info(sql); //当前执行的sql输出到日志中
                adp.Fill(ds, "default");
            }
            catch (Exception exp)
            {
                conn.Close();
                
            }
            return ds;
        }

        /**
         * 执行sql查询，pageNo 请求第几页，pageSize 每页多少条记录 ，返回DataSet数据类型
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        public DataSet executeQuery(String sql, int pageNo, int pageSize)
        {
            sql = getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql
            DataSet ds = executeQuery(sql);
            return ds;
        }

        /**
         * 执行sql查询，pageNo 请求第几页，pageSize 每页多少条记录 ，返回DataSet数据类型
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        public DataSet executeQuery(String sqlHead, String sql, int pageNo, int pageSize)
        {
            sql = sqlHead + " " + getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql
            DataSet ds = executeQuery(sql);
            return ds;
        }

        /**
         * 执行sql，返回受影响的行数
         * 
         */
        public int executeNoQuery(String sql)
        {
            int rownum = 0;
            try
            {
                SqlCommand com = new SqlCommand(sql, this.conn);
                log4.Info(sql); //当前执行的sql输出到日志中
                com.Connection.Open();
                rownum = com.ExecuteNonQuery();
                com.Connection.Close();
            }
            catch (Exception exp)
            {
                conn.Close();
                throw exp;
            }
            return rownum;
        }

        /**
         * 执行sql，pageNo 请求第几页，pageSize 每页多少条记录，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        public int executeNoQuery(String sql, int pageNo, int pageSize)
        {
            sql = getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql            
            int rownum = executeNoQuery(sql);
            return rownum;
        }

        /**
         * 执行sql，通过args替换sql中待替换的字符，返回受影响的行数
         * 
         */
        public int executeNoQuery(String sql, Dictionary<String, String> args)
        {
            int rownum = 0;
            try
            {
                sql = getSql(sql, args);
                SqlCommand com = new SqlCommand(sql, this.conn);
                log4.Info(sql); //当前执行的sql输出到日志中
                com.Connection.Open();
                rownum = com.ExecuteNonQuery();
                com.Connection.Close();
            }
            catch (Exception exp)
            {
                conn.Close();
                throw exp;
            }
            return rownum;
        }

        /**
         * 执行sql，通过args替换sql中待替换的字符，pageNo 请求第几页，pageSize 每页多少条记录 ，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100%
         */
        public int executeNoQuery(String sql, Dictionary<String, String> args, int pageNo, int pageSize)
        {
            sql = getPagingSql(sql, pageNo, pageSize);  //获取添加分页语句后的sql
            sql = getSql(sql, args);
            int rownum = executeNoQuery(sql);
            return rownum;
        }

        /**
         * 执行sql，通过args替换sql中待替换的字符，pageNo 请求第几页，pageSize 每页多少条记录 ，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100%
         */
        public bool executeNoQuery(System.Collections.IList sqls)
        {
            bool message = false;
            if (null == sqls) return message;
            using (conn)
            {
                SqlCommand com = new SqlCommand();
                com.Connection = conn;
                com.Connection.Open();
                SqlTransaction tran = com.Connection.BeginTransaction();
                com.Transaction = tran;

                try
                {
                    foreach (String sql in sqls)
                    {
                        com.CommandText = sql;
                        com.ExecuteNonQuery();
                        log4.Info(sql); //当前执行的sql输出到日志中
                    }
                    tran.Commit();
                    com.Connection.Close();
                }
                catch (Exception exp)
                {
                    tran.Rollback();
                    conn.Close();
                    throw exp;
                }
            }
            return true;
        }

        public bool executeNoQueryList(System.Collections.IList sqls)
        {
            bool message = false;
            if (null == sqls) return message;
            using (conn)
            {
                SqlCommand com = new SqlCommand();
                com.Connection = conn;
                com.Connection.Open();
                SqlTransaction tran = com.Connection.BeginTransaction();
                com.Transaction = tran;

                try
                {
                    foreach (String sql in sqls)
                    {
                        com.CommandText = sql;
                        com.ExecuteNonQuery();
                        log4.Info(sql); //当前执行的sql输出到日志中
                    }
                    tran.Commit();
                    com.Connection.Close();
                }
                catch (Exception exp)
                {
                    tran.Rollback();
                    conn.Close();
                    throw exp;
                }
            }
            return true;
        }

        /**
         * 通过args替换sql中待替换的字符，返回替换后sql
         * 
         */
        private String getSql(String sql, Dictionary<String, String> args)
        {
            Dictionary<String, String>.KeyCollection keys = args.Keys;
            String argsValue;
            foreach (String obj in keys)
            {
                argsValue = null;
                if (args.TryGetValue(obj.ToString(), out argsValue))    //存在替换键值对，则替换
                {
                    sql = System.Text.RegularExpressions.Regex.Replace(sql, obj, "'" + argsValue.Replace("'", "''") + "'");
                }
            }
            return sql;
        }

        private String getPagingSql(String sql, int pageNo, int pageSize)
        {
            if (pageNo <= 0 || pageSize <= 0 || null == sql) return sql;
            System.Text.StringBuilder sbsql = new System.Text.StringBuilder();
            sbsql.Append("SELECT HU_T2.* FROM ( ");
            sbsql.Append("SELECT HU_T1.*,ROW_NUMBER() OVER(ORDER BY TEMPCOLUMN) TEMP_ROW_NO FROM ");
            sbsql.Append("( SELECT TOP ").Append(pageNo * pageSize).Append("  TEMPCOLUMN=0, ").Append(sql.Trim().ToUpper().Substring(6)).Append(" ) HU_T1 ");
            sbsql.Append(") HU_T2 WHERE HU_T2.TEMP_ROW_NO>=").Append((pageNo - 1) * pageSize + 1);
            return sbsql.ToString();
        }

        /* New  */
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="sqlPara"></param>
        /// <returns></returns>
        public int executeNonQuery(String sql, SqlParameter[] sqlPara)
        {
            int ret = 0;
            SqlCommand cmd;
            try
            {

                cmd = new SqlCommand(sql, this.conn);
                log4.Info(sql); //当前执行的sql输出到日志中
                cmd.Connection.Open();
                cmd.Parameters.AddRange(sqlPara);
                ret = cmd.ExecuteNonQuery();
                cmd.Connection.Close();
            }
            catch (Exception exp)
            {
                conn.Close();
                throw exp;
            }
            return ret;
        }

        /// <summary>
        /// 打开数据源链接
        /// </summary>
        /// <returns></returns>
        public OleDbConnection DbConn(int flag)
        {
            if (flag == 1)//历史数据库
            {
                if (IsSqlServer == "1")
                    ConnString = "Provider=SQLOLEDB;Server=" + strServer + "," + strPort + ";Database=" + strDatabase + ";Persist Security Info=False;uid=" + struid + ";pwd=" + strpwd + ";";
                else
                    ConnString = "Provider=Microsoft.Jet.OleDb.4.0;Data Source=" + StartupPath + "\\" + strDatabase;
                //ConnString = "Provider=SQLOLEDB;Server="+strServer+","+strPort+";Database="+strDatabase+";Persist Security Info=False;uid="+struid+";pwd="+strpwd+";";
                Conn = new OleDbConnection(ConnString);
                try
                {
                    Conn.Open();
                }
                catch (Exception)
                {
                    ;
                }
            }
            else if (flag == 0)//实时数据库
            {
                if (IsRSqlServer == "1")
                    ConnString = "Provider=SQLOLEDB;Server=" + strRServer + "," + strRPort + ";Database=" + strRDatabase + ";Persist Security Info=False;uid=" + strRuid + ";pwd=" + strRpwd + ";";
                else
                    ConnString = "Provider=Microsoft.Jet.OleDb.4.0;Data Source=" + StartupPath + "\\" + strRDatabase;
                //ConnString = "Provider=SQLOLEDB;Server="+strServer+","+strPort+";Database="+strDatabase+";Persist Security Info=False;uid="+struid+";pwd="+strpwd+";";
                Conn = new OleDbConnection(ConnString);
                try
                {
                    Conn.Open();
                }
                catch (Exception)
                {
                    ;
                }
            }
            return Conn;
        }
        /// <summary>
        /// 数据库是否连接成功
        /// </summary>
        /// <returns></returns>
        public bool IsConnect()
        {
            if (Conn.State == ConnectionState.Open)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        /// <summary>
        /// 请在数据传递完毕后调用该函数，关闭数据链接。
        /// </summary>
        public void Close()
        {
            Conn.Close();
        }


        /// <summary>
        /// 根据SQL命令返回数据DataTable数据表,
        /// 可直接作为dataGridView的数据源
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
        public DataTable SelectToDataTable(string SQL)
        {
            OleDbDataAdapter adapter = new OleDbDataAdapter();
            OleDbCommand command = new OleDbCommand(SQL, Conn);
            adapter.SelectCommand = command;
            DataTable Dt = new DataTable();
            try
            {
                adapter.Fill(Dt);
                return Dt;
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 根据SQL命令返回数据DataSet数据集，其中的表可直接作为dataGridView的数据源。
        /// </summary>
        /// <param name="SQL"></param>
        /// <param name="subtableName">在返回的数据集中所添加的表的名称</param>
        /// <returns></returns>
        public DataSet SelectToDataSet(string SQL, string subtableName)
        {
            OleDbDataAdapter adapter = new OleDbDataAdapter();
            OleDbCommand command = new OleDbCommand(SQL, Conn);
            adapter.SelectCommand = command;
            DataSet Ds = new DataSet();
            Ds.Tables.Add(subtableName);
            try
            {
                adapter.Fill(Ds, subtableName);
                return Ds;
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 插入数据
        /// </summary>
        /// <param name="SQL"></param>
        /// <param name="subtableName">在返回的数据集中所添加的表的名称</param>
        /// <returns></returns>
        public void InsertToDataSet(string SQL)
        {
            OleDbDataAdapter adapter = new OleDbDataAdapter();
            OleDbCommand command = new OleDbCommand(SQL, Conn);
            command.ExecuteNonQuery();
        }
        /// <summary>
        /// 在指定的数据集中添加带有指定名称的表，由于存在覆盖已有名称表的危险，返回操作之前的数据集。
        /// </summary>
        /// <param name="SQL"></param>
        /// <param name="subtableName">添加的表名</param>
        /// <param name="DataSetName">被添加的数据集名</param>
        /// <returns></returns>
        public DataSet SelectToDataSet(string SQL, string subtableName, DataSet DataSetName)
        {
            OleDbDataAdapter adapter = new OleDbDataAdapter();
            OleDbCommand command = new OleDbCommand(SQL, Conn);
            adapter.SelectCommand = command;
            DataTable Dt = new DataTable();
            DataSet Ds = new DataSet();
            Ds = DataSetName;
            adapter.Fill(DataSetName, subtableName);
            return Ds;
        }

        /// <summary>
        /// 根据SQL命令返回OleDbDataAdapter，
        /// 使用前请在主程序中添加命名空间System.Data.OleDb
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
        public OleDbDataAdapter SelectToOleDbDataAdapter(string SQL)
        {
            OleDbDataAdapter adapter = new OleDbDataAdapter();
            OleDbCommand command = new OleDbCommand(SQL, Conn);
            adapter.SelectCommand = command;
            return adapter;
        }
        public OleDbCommand ExecSelectSql(String TblName, String Fldlist, String Condlist, String OrderBy)
        {
            String Sqlstr;
            if (Condlist == "")
                Sqlstr = "select " + Fldlist + " from " + TblName + " " + OrderBy;
            else
                Sqlstr = "select " + Fldlist + " from " + TblName + " where " + Condlist + " " + OrderBy;
            OleDbCommand command = new OleDbCommand(Sqlstr, Conn);
            return command;
        }
        public void ExecInsertSql(String TblName, String Fldlist, String ValueList)
        {
            String Sqlstr;
            Sqlstr = "Insert into " + TblName + " (" + Fldlist + ") values(" + ValueList + ")";
            ExecuteSQLNonquery(Sqlstr);
        }
        public void ExecUpdateSql(String TblName, String UpdateStr, String Constr)
        {
            String Sqlstr;
            Sqlstr = "update " + TblName + " set " + UpdateStr + " where " + Constr;
            ExecuteSQLNonquery(Sqlstr);
        }
        public void ExceDeleteSql(String TblName, String Constr)
        {
            String Sqlstr;
            if (Constr == "")
                Sqlstr = "delete from " + TblName + " ";
            else
                Sqlstr = "delete from " + TblName + " where " + Constr;
            ExecuteSQLNonquery(Sqlstr);
        }
        /// <summary>
        /// 执行SQL命令，不需要返回数据的修改，删除可以使用本函数
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns></returns>
        public bool ExecuteSQLNonquery(string SQL)
        {
            OleDbCommand cmd = new OleDbCommand(SQL, Conn);
            try
            {
                cmd.ExecuteNonQuery();
                return true;
            }
            catch
            {
                return false;
            }
        }
        public bool IsExistInDB(String DataSheet, String Conditin)
        {
            bool flag = false;
            if (IsConnect())
            {
                try
                {
                    OleDbCommand Com = ExecSelectSql(DataSheet, "*", Conditin, "");
                    OleDbDataReader reader = Com.ExecuteReader();
                    if (reader.Read())
                    {
                        flag = true;
                    }
                    reader.Close();
                }
                catch
                {
                    ;
                }
            }
            return flag;
        }
        public int GetIDFromDB(String DataSheet, String Conditin)
        {
            int temp = -1;
            if (IsConnect())
            {
                try
                {
                    OleDbCommand Com = ExecSelectSql(DataSheet, "*", Conditin, "");
                    OleDbDataReader reader = Com.ExecuteReader();
                    if (reader.Read())
                        temp = (int)reader["ID"];
                    else
                        temp = 0;
                    reader.Close();

                }
                catch
                {
                    temp = -1;
                }
            }
            return temp;
        }
        public String GetStringItemFromDB(String DataSheet, String Name, String Conditin)
        {
            String temp = "";
            if (IsConnect())
            {
                try
                {
                    OleDbCommand Com = ExecSelectSql(DataSheet, "*", Conditin, "");
                    OleDbDataReader reader = Com.ExecuteReader();
                    if (reader.Read())
                        temp = reader[Name].ToString();
                    reader.Close();
                }
                catch
                {
                    temp = "";
                }
            }
            return temp;
        }
        public float GetFloatItemFromDB(String DataSheet, String Name, String Conditin)
        {
            float temp = 0;
            if (IsConnect())
            {
                try
                {
                    OleDbCommand Com = ExecSelectSql(DataSheet, "*", Conditin, "");
                    OleDbDataReader reader = Com.ExecuteReader();
                    if (reader.Read())
                        temp = (float)reader[Name];
                    reader.Close();
                }
                catch
                {
                    temp = -1;
                }
            }
            return temp;
        }
        public int GetIntItemFromDB(String DataSheet, String Name, String Conditin)
        {
            int temp = -1;
            if (IsConnect())
            {
                try
                {
                    OleDbCommand Com = ExecSelectSql(DataSheet, "*", Conditin, "");
                    OleDbDataReader reader = Com.ExecuteReader();
                    if (reader.Read())
                        temp = (int)reader[Name];
                    reader.Close();
                }
                catch
                {
                    temp = -1;
                }
            }
            return temp;
        }

        /// <summary>
        /// 从数据库里读取装置信息
        /// </summary>
        public void SYSSQL()
        {
            SYSConnString = "";
            SYS_DATABASETable = "";
            INI_IO ini_io = new INI_IO();
            if (ini_io.IniFiles(StartupPath + "\\sys_setting.ini"))
            {
                string sysA = ini_io.ReadString("Section", "SYSSERVER_ADDRESS", "");
                string sysport = ini_io.ReadString("Section", "SYS_PORT", "");
                string sysuser = ini_io.ReadString("Section", "SYS_USERNAME", "");
                string syspwd = ini_io.ReadString("Section", "SYS_PASSWORD", "");
                string IsSYSSqlServer = ini_io.ReadString("Section", "SYS_SQLSERVER", "");
                string strSYSDatabase = "";
                if (IsSYSSqlServer == "1")
                {
                    strSYSDatabase = ini_io.ReadString("Section", "SYS_DATABASENAME", "");
                    SYS_DATABASETable = ini_io.ReadString("Section", "SYS_DATABASETable", "");
                }
                else if (IsSYSSqlServer == "0")
                {
                    strSYSDatabase = ini_io.ReadString("Section", "SYS_DATABASEFILENAME", "");
                }
                SYSConnString = "Provider=SQLOLEDB;Server=" + sysA + "," + sysport + ";Database=" +
                                  strSYSDatabase + ";Persist Security Info=False;uid=" + sysuser + ";pwd=" + syspwd + ";";
            }
            else
            {
                //MessageBox.Show("没有配置文件！");

            }
        }
        public void ReadFromDataBase(string EquipmentName)
        {
            INI_IO ini_io = new INI_IO();
            //if (ini_io.IniFiles(Application.StartupPath + "\\sys_setting.ini"))
            //{
            //string  sysA = ini_io.ReadString("Section", "SYSSERVER_ADDRESS", "");
            //string sysport = ini_io.ReadString("Section", "SYS_PORT", "");
            //string sysuser = ini_io.ReadString("Section", "SYS_USERNAME", "");
            //string syspwd = ini_io.ReadString("Section", "SYS_PASSWORD", "");
            //string  IsSYSSqlServer = ini_io.ReadString("Section", "SYS_SQLSERVER", "");
            //string strSYSDatabase="";
            //if (IsSYSSqlServer == "1")
            //    strSYSDatabase = ini_io.ReadString("Section", "SYS_DATABASENAME", "");
            // else if (IsSYSSqlServer == "0")
            //    strSYSDatabase = ini_io.ReadString("Section", "SYS_DATABASEFILENAME", "");
            //string SYSConnString = "Provider=SQLOLEDB;Server=" + sysA + "," + sysport + ";Database=" +
            //                   strSYSDatabase + ";Persist Security Info=False;uid=" + sysuser + ";pwd=" + syspwd + ";";
            SYSSQL();
            Conn = new OleDbConnection(SYSConnString);
            Conn.Open();
            if (Conn.State == ConnectionState.Open)
            {
                string Sqlstr = string.Format("select * from {0} where EquipName= '{1}'", SYS_DATABASETable, EquipmentName);
                OleDbCommand command = new OleDbCommand(Sqlstr, Conn);
                OleDbDataReader reader = command.ExecuteReader();
                int count = 0;
                while (reader.Read())
                {
                    count++;
                    strRDatabase = (string)reader["DataBaseName_RTResEx"];
                    strDatabase = (string)reader["DataBaseName_Soft_Qdrise"];
                    PesFileName = (string)reader["PesFileName"];
                    break;
                }
                if (count == 0)
                {
                    //MessageBox.Show("数据库没有该装置！");
                    count = 0;
                    return;
                }
                ReadINI();
            }

            else
            {
                //Show("获取装置失败！");
                return;
            }
            Conn.Close();
        }
        public void ReadINI()
        {
            INI_IO ini_io = new INI_IO();
            if (ini_io.IniFiles(StartupPath + "\\sys_setting.ini"))
            {
                strServer = ini_io.ReadString("Section", "SERVER_ADDRESS", "");
                strPort = ini_io.ReadString("Section", "DB_PORT", "");
                struid = ini_io.ReadString("Section", "DB_USERNAME", "");
                strpwd = ini_io.ReadString("Section", "DB_PASSWORD", "");
                IsSqlServer = ini_io.ReadString("Section", "IS_SQLSERVER", "");
                if (IsSqlServer == "1") { }
                //strDatabase = ini_io.ReadString("Section", "DB_DATABASENAME", "");
                else if (IsSqlServer == "0")
                    strDatabase = ini_io.ReadString("Section", "DB_DATABASEFILENAME", "");
                strRServer = ini_io.ReadString("Section", "RSERVER_ADDRESS", "");
                strRPort = ini_io.ReadString("Section", "RDB_PORT", "");
                strRuid = ini_io.ReadString("Section", "RDB_USERNAME", "");
                strRpwd = ini_io.ReadString("Section", "RDB_PASSWORD", "");
                IsRSqlServer = ini_io.ReadString("Section", "RIS_SQLSERVER", "");
                if (IsRSqlServer == "1") { }
                //strRDatabase = ini_io.ReadString("Section", "RDB_DATABASENAME", "");
                else if (IsRSqlServer == "0")
                    strRDatabase = ini_io.ReadString("Section", "RDB_DATABASEFILENAME", "");
            }
            else
            {
                //MessageBox.Show("没有配置文件！");
            }
        }

        /// <summary>
        /// 批量插入数据
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="tableName"></param>
        public void batchInsert(DataTable dt,String tableName) {
            SqlConnection connection = this.conn;
            connection.Open();
            try
            {
                SqlBulkCopy sqlbulkcopy = new SqlBulkCopy(connection);
                sqlbulkcopy.BulkCopyTimeout = 100;  //超时之前操作完成所允许的秒数
                sqlbulkcopy.BatchSize = dt.Rows.Count;  //每一批次中的行数
                sqlbulkcopy.DestinationTableName = tableName;  //服务器上目标表的名称
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    sqlbulkcopy.ColumnMappings.Add(i, i);  //映射定义数据源中的列和目标表中的列之间的关系
                }
                sqlbulkcopy.WriteToServer(dt);  // 将DataTable数据上传到数据表中
                connection.Close();
            }
            catch (Exception e) {
                connection.Close();
            }
        }
    }
}
