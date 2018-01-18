using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Collections.Specialized;
using System.IO;
using PSOG.Common;

namespace PSOG.DAO.impl
{
    public class INI_IO
    {
        public string FileName; //INI�ļ��� 
        //������дINI�ļ���API���� 
        [DllImport("kernel32")]
        private static extern bool WritePrivateProfileString(string section, string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key, string def, byte[] retVal, int size, string filePath);
        //��Ĺ��캯��������INI�ļ��� 
        public bool IniFiles(string AFileName)
        {
            // �ж��ļ��Ƿ���� 
            FileInfo fileInfo = new FileInfo(AFileName);
            //Todo:����ö�ٵ��÷� 
            if ((!fileInfo.Exists))
            { //|| (FileAttributes.Directory in fileInfo.Attributes)) 
                ////�ļ������ڣ������ļ� 
                //System.IO.StreamWriter sw = new System.IO.StreamWriter(AFileName, false, System.Text.Encoding.Default);
                //try
                //{
                //    sw.Write("#���õ���");
                //    sw.Close();

                //    //��������ȫ·�������������·�� 
                //    FileName = fileInfo.FullName;

                //    return true;
                //}
                //catch
                //{
                //    //throw (new ApplicationException("Ini�ļ�������"));
                //    return false;
                //}
                return false;
            }
            else
            {
                //��������ȫ·�������������·�� 
                FileName = fileInfo.FullName;
                return true;
            }

        }
        //дINI�ļ� 
        public void WriteString(string Section, string Ident, string Value)
        {
            //if (!WritePrivateProfileString(Section, Ident, Value, FileName))
            //{

            //    throw (new ApplicationException("дIni�ļ�����"));
            //}
        }
        //��ȡINI�ļ�ָ�� 
        public string ReadString(string Section, string Ident, string Default)
        {
            Byte[] Buffer = new Byte[65535];
            int bufLen = GetPrivateProfileString(Section, Ident, Default, Buffer, Buffer.GetUpperBound(0), FileName);
            //�����趨0��ϵͳĬ�ϵĴ���ҳ���ı��뷽ʽ�������޷�֧������ 
            string s = Encoding.GetEncoding(0).GetString(Buffer);
            s = s.Substring(0, bufLen);
            return s.Trim();
        }

        //������ 
        public int ReadInteger(string Section, string Ident, int Default)
        {
            string intStr = ReadString(Section, Ident, Convert.ToString(Default));
            try
            {
                return Convert.ToInt32(intStr);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Default;
            }
        }

        //д���� 
        public void WriteInteger(string Section, string Ident, int Value)
        {
            WriteString(Section, Ident, Value.ToString());
        }

        //������ 
        public bool ReadBool(string Section, string Ident, bool Default)
        {
            try
            {
                return Convert.ToBoolean(ReadString(Section, Ident, Convert.ToString(Default)));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Default;
            }
        }

        //дBool 
        public void WriteBool(string Section, string Ident, bool Value)
        {
            WriteString(Section, Ident, Convert.ToString(Value));
        }

        //��Ini�ļ��У���ָ����Section�����е�����Ident��ӵ��б��� 
        public void ReadSection(string Section, StringCollection Idents)
        {
            Byte[] Buffer = new Byte[16384];
            //Idents.Clear(); 

            int bufLen = GetPrivateProfileString(Section, null, null, Buffer, Buffer.GetUpperBound(0),
              FileName);
            //��Section���н��� 
            GetStringsFromBuffer(Buffer, bufLen, Idents);
        }

        private void GetStringsFromBuffer(Byte[] Buffer, int bufLen, StringCollection Strings)
        {
            Strings.Clear();
            if (bufLen != 0)
            {
                int start = 0;
                for (int i = 0; i < bufLen; i++)
                {
                    if ((Buffer[i] == 0) && ((i - start) > 0))
                    {
                        String s = Encoding.GetEncoding(0).GetString(Buffer, start, i - start);
                        Strings.Add(s);
                        start = i + 1;
                    }
                }
            }
        }
        //��Ini�ļ��У���ȡ���е�Sections������ 
        public void ReadSections(StringCollection SectionList)
        {
            //Note:�������Bytes��ʵ�֣�StringBuilderֻ��ȡ����һ��Section 
            byte[] Buffer = new byte[65535];
            int bufLen = 0;
            bufLen = GetPrivateProfileString(null, null, null, Buffer,
              Buffer.GetUpperBound(0), FileName);
            GetStringsFromBuffer(Buffer, bufLen, SectionList);
        }
        //��ȡָ����Section������Value���б��� 
        public void ReadSectionValues(string Section, NameValueCollection Values)
        {
            StringCollection KeyList = new StringCollection();
            ReadSection(Section, KeyList);
            Values.Clear();
            foreach (string key in KeyList)
            {
                Values.Add(key, ReadString(Section, key, ""));

            }
        }
        /**/
        ////��ȡָ����Section������Value���б��У� 
        //public void ReadSectionValues(string Section, NameValueCollection Values,char splitString)
        //{   string sectionValue;
        //    string[] sectionValueSplit;
        //    StringCollection KeyList = new StringCollection();
        //    ReadSection(Section, KeyList);
        //    Values.Clear();
        //    foreach (string key in KeyList)
        //    {   
        //        sectionValue=ReadString(Section, key, "");
        //        sectionValueSplit=sectionValue.Split(splitString);
        //        Values.Add(key, sectionValueSplit[0].ToString(),sectionValueSplit[1].ToString());

        //    }
        //}
        //���ĳ��Section 
        public void EraseSection(string Section)
        {
            // 
            if (!WritePrivateProfileString(Section, null, null, FileName))
            {
                throw (new ApplicationException("�޷����Ini�ļ��е�Section"));
            }
        }
        //ɾ��ĳ��Section�µļ� 
        public void DeleteKey(string Section, string Ident)
        {
            WritePrivateProfileString(Section, Ident, null, FileName);
        }
        //Note:����Win9X����˵��Ҫʵ��UpdateFile�����������е�����д���ļ� 
        //��Win NT, 2000��XP�ϣ�����ֱ��д�ļ���û�л��壬���ԣ�����ʵ��UpdateFile 
        //ִ�����Ini�ļ����޸�֮��Ӧ�õ��ñ��������»������� 
        public void UpdateFile()
        {
            WritePrivateProfileString(null, null, null, FileName);
        }

        //���ĳ��Section�µ�ĳ����ֵ�Ƿ���� 
        public bool ValueExists(string Section, string Ident)
        {
            // 
            StringCollection Idents = new StringCollection();
            ReadSection(Section, Idents);
            return Idents.IndexOf(Ident) > -1;
        }
        public int ReadID()
        {
            INI_IO ini_io = new INI_IO();
            if (ini_io.IniFiles(CommonStr.physicalPath + "\\sys_setting.ini"))
            {
                string strID = ini_io.ReadString("Section", "ID", "");
                if (strID == "")
                    return -1;
                else
                {
                    int ID = Int32.Parse(strID);
                    ID += 1;
                    ini_io.WriteString("Section", "ID", "" + ID);
                    return ID;
                }
            }
            else
                return -1;
        }

        //ȷ����Դ���ͷ� 
        ~INI_IO()
        {
            UpdateFile();
        }
    }
}
