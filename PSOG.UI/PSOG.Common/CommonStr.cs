using System;
using System.Collections.Generic;
using System.Text;
using PSOG.Entity;

namespace PSOG.Common
{
    public class CommonStr
    {
        public static string applicationPath = "";  //��Ŀ·������Ŀ�������ֵ
        public static String physicalPath = ""; //����·������Ŀ�������ֵ
        public static string monitorObject_Source = "PCA���ݿ�"; //psog_processmonitorObject�����ֶ�
        public static string unusualImgPath = @"C:\PESGraph\";   //�쳣�����ͼƬ��ַ
        public static string[] plantItem = new string[] { "", "��ҳ", "���ռ��", "�豸���", "��������", "��ͣ������", "װ��֪ʶ" };
        public static string[] plantItemUri = new string[] { "", "aspx/main_page.aspx", 
            "aspx/art_check_main.aspx", "aspx/device_check_main.aspx", "aspx/alarm_analysis.aspx", "��ͣ������", "" };
        public static string realDB = "realId"; //ʵʱ���������
        public static string hisDB = "hisId";   //��ʷ���������
        public static string add_succ = "����ɹ���";   
        public static string add_fail = "����ʧ�ܣ�";   
        public static string del_succ = "ɾ���ɹ���";   
        public static string del_fail = "ɾ��ʧ�ܣ�";   
        public static string session_user = "PSOG_USER";
        public static string default_user_password = "21218CCA77804D2BA1922C33E0151105";
        public static string knowledge_manage_code = "006001"; //װ��֪ʶ����ҳ��

    }
}
