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
         * ִ��sql��ѯ��ͨ����args�����󶨲���������DataSet��������
         * 
         */
        DataSet executeQuery(String sql, Dictionary<String, Object> args);

        /**
         * String sql, SqlParameter sqlPara
         * ִ��sql��ѯ��ͨ����sqlPara�����󶨲���������DataSet��������
         * 
         */
        DataSet executeQuery(String sql, SqlParameter[] sqlPara);

        /**
         * ִ��sql��ѯ��ͨ����args�����󶨲�����pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ 
         * sql ��京order by ����select ��� top 100 percent
         * ����DataSet��������
         */
        DataSet executeQuery(String sql, Dictionary<String, Object> args, int pageNo, int pageSize);

        /**
         * ִ��sql��ѯ��SqlParameter[] args��pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ 
         * sql ��京order by ����select ��� top 100 percent
         * ����DataSet��������
         */
        DataSet executeQuery(String sql, SqlParameter[] args, int pageNo, int pageSize);

        /**
         * ִ��sql��ѯ������DataSet��������
         * 
         */
        DataSet executeQuery(String sql);

        /**
         * ִ��sql��ѯ��pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ ������DataSet��������
         * sql ��京order by ����select ��� top 100 percent
         */
        DataSet executeQuery(String sql, int pageNo, int pageSize);

         /**
         * ִ��sql��ѯ��pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ ������DataSet��������
         * sql ��京order by ����select ��� top 100 percent
         */
        DataSet executeQuery(String sqlHead, String sql, int pageNo, int pageSize);
        
        /**
         * ִ��sql��������Ӱ�������
         * 
         */
        int executeNoQuery(String sql);

        /**
         * ִ��sql��pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼��������Ӱ�������
         * sql ��京order by ����select ��� top 100 percent
         */
        int executeNoQuery(String sql, int pageNo, int pageSize);

        /**
         * ִ��sql��ͨ��args�滻sql�д��滻���ַ���������Ӱ�������
         * 
         */
        int executeNoQuery(String sql, Dictionary<String, String> args);

        /**
         * ִ��sql��ͨ��args�滻sql�д��滻���ַ���pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ ��������Ӱ�������
         * sql ��京order by ����select ��� top 100%
         */
        int executeNoQuery(String sql, Dictionary<String, String> args, int pageNo, int pageSize);


        /**
         * ִ��sql��ͨ��args�滻sql�д��滻���ַ���pageNo ����ڼ�ҳ��pageSize ÿҳ��������¼ ��������Ӱ�������
         * sql ��京order by ����select ��� top 100%
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
        /// ִ�д洢����
        /// </summary>
        /// <param name="procName"></param>
        /// <param name="parames"></param>
        /// <returns></returns>
        SqlDataReader executeProc(String procName, SqlParameter[] parames);
        DataSet executeProcDS(String procName, String subtableName);
        /// <summary>
        /// �ر�����
        /// </summary>
        void closeConn();

    }
}
