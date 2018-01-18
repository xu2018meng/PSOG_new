using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace PSOG.DAO
{
    public interface IDao
    {
        /**
         * 执行sql查询，通过对args解析绑定参数，返回DataSet数据类型
         * 
         */
        DataSet executeQuery(String sql, Dictionary<String, Object> args);

        /**
         * String sql, SqlParameter sqlPara
         * 执行sql查询，通过对sqlPara解析绑定参数，返回DataSet数据类型
         * 
         */
        DataSet executeQuery(String sql, SqlParameter[] sqlPara);

        /**
         * 执行sql查询，通过对args解析绑定参数，pageNo 请求第几页，pageSize 每页多少条记录 
         * sql 语句含order by 请在select 后加 top 100 percent
         * 返回DataSet数据类型
         */
        DataSet executeQuery(String sql, Dictionary<String, Object> args, int pageNo, int pageSize);

        /**
         * 执行sql查询，SqlParameter[] args，pageNo 请求第几页，pageSize 每页多少条记录 
         * sql 语句含order by 请在select 后加 top 100 percent
         * 返回DataSet数据类型
         */
        DataSet executeQuery(String sql, SqlParameter[] args, int pageNo, int pageSize);

        /**
         * 执行sql查询，返回DataSet数据类型
         * 
         */
        DataSet executeQuery(String sql);

        /**
         * 执行sql查询，pageNo 请求第几页，pageSize 每页多少条记录 ，返回DataSet数据类型
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        DataSet executeQuery(String sql, int pageNo, int pageSize);

         /**
         * 执行sql查询，pageNo 请求第几页，pageSize 每页多少条记录 ，返回DataSet数据类型
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        DataSet executeQuery(String sqlHead, String sql, int pageNo, int pageSize);
        
        /**
         * 执行sql，返回受影响的行数
         * 
         */
        int executeNoQuery(String sql);

        /**
         * 执行sql，pageNo 请求第几页，pageSize 每页多少条记录，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100 percent
         */
        int executeNoQuery(String sql, int pageNo, int pageSize);

        /**
         * 执行sql，通过args替换sql中待替换的字符，返回受影响的行数
         * 
         */
        int executeNoQuery(String sql, Dictionary<String, String> args);

        /**
         * 执行sql，通过args替换sql中待替换的字符，pageNo 请求第几页，pageSize 每页多少条记录 ，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100%
         */
        int executeNoQuery(String sql, Dictionary<String, String> args, int pageNo, int pageSize);


        /**
         * 执行sql，通过args替换sql中待替换的字符，pageNo 请求第几页，pageSize 每页多少条记录 ，返回受影响的行数
         * sql 语句含order by 请在select 后加 top 100%
         */
        bool executeNoQuery(System.Collections.IList sqls);

        /* New  */
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="sqlPara"></param>
        /// <returns></returns>
        int executeNonQuery(String sql, SqlParameter[] sqlPara);

        /// <summary>
        /// 执行存储过程
        /// </summary>
        /// <param name="procName"></param>
        /// <param name="parames"></param>
        /// <returns></returns>
        SqlDataReader executeProc(String procName, SqlParameter[] parames);
        DataSet executeProcDS(String procName, String subtableName);
        /// <summary>
        /// 关闭连接
        /// </summary>
        void closeConn();

    }
}
