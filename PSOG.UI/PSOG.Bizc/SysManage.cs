using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PSOG.DAO;
using PSOG.DAO.impl;
using PSOG.Entity;
using System.Data;
using PSOG.Common;
using System.Web.Script.Serialization;
using System.IO;
using System.Configuration;
using System.Net;

namespace PSOG.Bizc
{
    public class SysManage
    {
        public static IList plantList = new ArrayList();    //װ���б�
        public static Object lockObj = new object();
        public string DomainHack = ConfigurationManager.AppSettings["ReportDomainHack"];
        public string projectPath = ConfigurationManager.AppSettings["ReportApplicationPath"];
        public string WXAlarmInfoId = ConfigurationManager.AppSettings["WXAlaramInfo"];
        public string WXAlarmReportId = ConfigurationManager.AppSettings["WXAlaramReport"];

        // ��������������ѯ
        public List<FunctionNode> qryOQIFunctionNode(string userId)
        {
            List<FunctionNode> functionList = new List<FunctionNode>();
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct m.sys_menu_name, m.sys_menu_url, m.sys_menu_index ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_p_code ='008' order by m.sys_menu_index", userId);    //008�����������

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        FunctionNode node = new FunctionNode();

                        node.functionName = BeanTools.ObjectToString(dr["sys_menu_name"]);
                        node.functionUrl = BeanTools.ObjectToString(dr["sys_menu_url"]);

                        functionList.Add(node);
                    }
                }
            }
            return functionList;
        }
        public List<TreeNode> qrtRoleTree(string userId)
        {
            IDao dao = new Dao();
            List<TreeNode>  treeList = new List<TreeNode>();
            TreeNode headNode = qryHeadNode();
            StringBuilder sql = new StringBuilder();

            if (!string.IsNullOrEmpty(userId))
            {                
                sql.Append("select r.sys_role_code,r.sys_role_name,ur.sys_user_id ");
                sql.Append("from psogsys_permissionrole r left join psogsys_permission_user_role ur  ");
                sql.AppendFormat("on r.sys_role_code = ur.sys_role_code and sys_user_id = '{0}' ", userId);
                sql.Append("where r.sys_role_code <> 'ROOT' order by r.SYS_ROLE_ORDER asc ");

            }
            else
            {
                sql.Append("select sys_role_code,sys_role_name,'' sys_user_id from psogsys_permissionrole where sys_role_code <> 'ROOT' order by SYS_ROLE_ORDER asc");
            }

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_role_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_role_name"]);
                    node.state = "open";
                    string sys_user_id = BeanTools.ObjectToString(dr["sys_user_id"]);
                    if (!string.IsNullOrEmpty(sys_user_id))
                    {
                        node.isChecked = true;
                    }
                    else
                    {
                        node.isChecked = false;
                    }
                    node.children = null;
                    node.iconCls = "sysMan_role";
                    headNode.children.Add(node);
                }
            }
            treeList.Add(headNode);

            return treeList;
        }

        public TreeNode qryHeadNode()
        {
            TreeNode node = new TreeNode();
            node.id = "-1";
            node.text = "��ɫ";
            node.state = "open";
            node.iconCls = "sysMan_root";
            return node;
        }

        /// <summary>
        /// ��ȡװ���б�
        /// </summary>
        /// <returns></returns>
        public IList qryPlantList()
        {
            IDao dao = new Dao();
            plantList = new ArrayList();
            StringBuilder sql = new StringBuilder();

            return plantList;
        }

        public string qryPlantIds(string plantCode)
        {
            string plantIds = "";
            if (!string.IsNullOrEmpty(plantCode))
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("select stuff( ");
                sql.Append("(select ','+convert(varchar(50),PlantInfo_PlantCode) ");
                sql.Append("from psogsys_plantinfo ");
                sql.AppendFormat("where plantinfo_mesplantcode in ('{0}') ", plantCode.Replace(",", "','"));
                sql.Append("order by plantinfo_id ");
                sql.Append("for xml path('') ");
                sql.Append("),1,1,'') ");

                IDao dao = new Dao();
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    plantIds = BeanTools.ObjectToString(ds.Tables[0].Rows[0][0]);
                }

            }
            return plantIds;
        }

        //����ID�õ���֯����CODE
        public string getOrgniseCode(string orgID)
        {
            string orgCode = "";
            if (!string.IsNullOrEmpty(orgID))
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("select * from PSOGSYS_PermissionOrgan where  ID = '");
                sql.Append(orgID);
                sql.Append("' and SYS_ORGAN_is_use=1");
                IDao dao = new Dao();
                 DataSet ds = dao.executeQuery(sql.ToString());
                 if (BeanTools.DataSetIsNotNull(ds))
                 {
                     orgCode = BeanTools.ObjectToString(ds.Tables[0].Rows[0]["SYS_ORGAN_CODE"]);
                 }
            }
            return orgCode;
        }
        //����ID�õ���֯������Ϣ
        public OrganiseUnit getOrganiseInfo(string orgID)
        {
            OrganiseUnit org = new OrganiseUnit();
            if (!string.IsNullOrEmpty(orgID))
            {
                StringBuilder sql = new StringBuilder();
                sql.AppendFormat("select * from PSOGSYS_PermissionOrgan where  SYS_ORGAN_CODE ='{0}' and SYS_ORGAN_is_use=1", orgID);
                IDao dao = new Dao();
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    org.ID = BeanTools.ObjectToString(dr["ID"]);
                    org.SYS_ORGAN_CODE = BeanTools.ObjectToString(dr["SYS_ORGAN_CODE"]);
                    org.SYS_ORGAN_NAME = BeanTools.ObjectToString(dr["SYS_ORGAN_NAME"]);
                    org.SYS_ORGAN_P_CODE = BeanTools.ObjectToString(dr["SYS_ORGAN_P_CODE"]);
                    org.SYS_ORGAN_TYPE = BeanTools.ObjectToString(dr["SYS_ORGAN_TYPE"]);
                    org.SYS_ORGAN_CRT_TIME = BeanTools.ObjectToString(dr["SYS_ORGAN_CRT_TIME"]);
                    org.SYS_ORGAN_ORDER = BeanTools.ObjectToString(dr["SYS_ORGAN_ORDER"]);
                }
            }
            return org;
        }
        //�õ�ĳ��λ���������
        public string getMaxOrder(string prentID)
        {
            string order = null;
            if (!string.IsNullOrEmpty(prentID))
            {
                StringBuilder sql = new StringBuilder();
                sql.AppendFormat("select max(SYS_ORGAN_ORDER)+1 MAXORDER from PSOGSYS_PermissionOrgan where  SYS_ORGAN_P_CODE ='{0}'", prentID);
                IDao dao = new Dao();
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    order = BeanTools.ObjectToString(dr["MAXORDER"]);
                }
            }
            return order;
        }
        //�õ���֯�������ڵ�
        public List<TreeNode> getOrgniseTree()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name, ");
            sql.Append("sys_organ_type, ");
            sql.Append("(select count(1) from psogsys_permissionorgan o  ");
            sql.Append("where o.sys_organ_p_code = t.sys_organ_code and SYS_ORGAN_is_use=1 ");
            sql.Append(")+(select count(1) from psogsys_permissionuser u where (u.SYS_USER_ORGAN_ID=sys_organ_code or SYS_USER_DEPT_ID=sys_organ_code) and sys_user_is_use ='1') childCount ");
            sql.Append("from psogsys_permissionorgan t  ");
            sql.Append("where (sys_organ_p_code = '9999' or sys_organ_p_code = '9B758C25-11AE-492A-8229-3EDCECB47A9C') and SYS_ORGAN_is_use=1 ");
            sql.Append("order by SYS_ORGAN_ORDER ");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                //���ڵ�
                DataRow dr = ds.Tables[0].Rows[0];
                TreeNode headNode = new TreeNode();
                headNode.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                headNode.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                if (1 <= childCount)    //���ӽڵ�
                {
                    headNode.state = "closed";
                }
                else
                {
                    headNode.state = "open";
                }
                headNode.iconCls = "sysMan_root";
                headNode.attributes = childCount + ":ORGAN";
                

                //�ӽڵ�
                for (int i=1, size=ds.Tables[0].Rows.Count;i<size;i++)
                {
                    dr = ds.Tables[0].Rows[i];
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }
                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                    }
                    node.attributes = childCount + ":ORGAN";
                    
                    headNode.children.Add(node);
                }

                treeList.Add(headNode);
            }

            return treeList;
        }
        

        public List<TreeNode> getOrgTreeNde(string parentOrganCode)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();
            sql.Append("select * ,0 childCount, 0 organType from PSOGSYS_PermissionOrgan where  SYS_ORGAN_P_CODE = '");
            sql.Append(parentOrganCode);
            sql.Append("' and SYS_ORGAN_is_use=1");
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    string organType = BeanTools.ObjectToString(dr["organType"]);
                    
                    node.state = "open";
                    node.attributes = childCount + ":BUMEN";
                    node.iconCls = "sysMan_department";
                   
                    treeList.Add(node);
                }
            }

            return treeList;
        
        }

        //�õ���֯�����б�
        public List<OrganiseUnit> getOrganiseList(string parentID)
        {
            List<OrganiseUnit> orgList = new List<OrganiseUnit>();
            if (!string.IsNullOrEmpty(parentID))
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("select *,count(1) over() rowno from PSOGSYS_PermissionOrgan where  SYS_ORGAN_P_CODE = '");
                sql.Append(parentID);
                sql.Append("'and SYS_ORGAN_is_use=1");
                IDao dao = new Dao();
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        OrganiseUnit org = new OrganiseUnit();
                        org.ID = BeanTools.ObjectToString(dr["ID"]);
                        org.SYS_ORGAN_CODE = BeanTools.ObjectToString(dr["SYS_ORGAN_CODE"]);
                        org.SYS_ORGAN_NAME = BeanTools.ObjectToString(dr["SYS_ORGAN_NAME"]);
                        org.SYS_ORGAN_P_CODE = BeanTools.ObjectToString(dr["SYS_ORGAN_P_CODE"]);
                        //��֯��������Ŀǰд��  01--��λ  02--����
                        org.SYS_ORGAN_TYPE = BeanTools.ObjectToString(dr["SYS_ORGAN_TYPE"]).Equals("01")?"��λ":"����";
                        org.SYS_ORGAN_CRT_TIME = BeanTools.ObjectToString(dr["SYS_ORGAN_CRT_TIME"]);
                        org.SYS_ORGAN_ORDER = BeanTools.ObjectToString(dr["SYS_ORGAN_ORDER"]);

                        orgList.Add(org);
                    }
                }
            }
            return orgList;
        }

        
        /// <summary>
        /// ������֯������Ϣ
        /// </summary>
        /// <param name="org">��֯������Ϣ</param>
        /// <returns>0--�ɹ�  1--��λ��Ŵ���  2--ʧ��</returns>
        public int saveOrganData(OrganiseUnit org)
        {
            StringBuilder sql = new StringBuilder();
            IDao dao = new Dao();
            if (org != null)
            {
                //�жϱ���Ƿ���� �����ڣ�����false
                sql.Append("select * from PSOGSYS_PermissionOrgan where  SYS_ORGAN_CODE = '");
                sql.Append(org.SYS_ORGAN_CODE);
                sql.Append("'");
                DataSet ds = dao.executeQuery(sql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    return 1;
                }
                else
                {
                    try
                    {
                        //��������
                        sql = new StringBuilder();
                        sql.Append("insert into PSOGSYS_PermissionOrgan(ID,SYS_ORGAN_CODE,SYS_ORGAN_NAME,SYS_ORGAN_P_CODE,SYS_ORGAN_TYPE,SYS_ORGAN_CRT_TIME,SYS_ORGAN_is_use,SYS_ORGAN_ORDER) ");
                        sql.Append("values('");
                        sql.Append(org.ID);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_CODE);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_NAME);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_P_CODE);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_TYPE);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_CRT_TIME);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_is_use);
                        sql.Append("','");
                        sql.Append(org.SYS_ORGAN_ORDER);
                        sql.Append("')");
                        dao.executeQuery(sql.ToString());
                    }
                    catch (Exception e)
                    {
                        return 2;
                    }
                }
            }
            return 0;
        }

        /// <summary>
        /// ɾ����֯������Ϣ
        /// </summary>
        /// <param name="ids">��λID����</param>
        /// <returns>0--�ɹ�  1--ʧ��</returns>
        public int deleteOrg(String[] ids)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();
            try
            {
                if (ids.Length != 0)
                {
                    sql.Append("update PSOGSYS_PermissionOrgan set SYS_ORGAN_is_use  = 0 where (");
                    for (int i = 0; i < ids.Length; i++)
                    {
                        if (i < ids.Length - 1)
                            sql.AppendFormat("ID = '{0}' OR ", ids[i]);
                        else
                            sql.AppendFormat("ID = '{0}' ) ", ids[i]);
                    }
                    dao.executeQuery(sql.ToString());
                }
            }
            catch (Exception e)
            {
                return 1;
            }
            return 0;
        }
        /// <summary>
        /// �޸Ĳ�������
        /// </summary>
        /// <param name="orgCode">���ű��</param>
        /// <param name="orgName">��������</param>
        /// <returns>0--�ɹ� 1--ʧ��</returns>
        public int updateOrg(String orgCode, String orgName, String orgOrder)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();
            try
            {
                sql.AppendFormat("update PSOGSYS_PermissionOrgan set SYS_ORGAN_NAME  = '{1}',SYS_ORGAN_ORDER  = '{2}' where SYS_ORGAN_CODE = '{0}'", orgCode, orgName, orgOrder);
                dao.executeQuery(sql.ToString());
            }
            catch (Exception e)
            {
                return 1;
            }
            return 0;
        }
        public List<TreeNode> qrtHeadMenuTree(string roleId)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            TreeNode headNode = qryMenuHeadNode();
            StringBuilder sql = new StringBuilder();

            
            if (!string.IsNullOrEmpty(roleId))  //������ɫ���ѯ��͹���Ƿ�ѡ��
            {
                sql.Append("select m.id,m.sys_menu_code, m.sys_menu_p_code, m.sys_menu_url,");
                sql.Append("m.sys_menu_name,m.sys_menu_index ,");
                sql.Append("(select count(1) from psogsys_permissionmenu g where g.sys_menu_p_code = m.sys_menu_code) childCount, ");
                sql.Append("rm.sys_role_code ");
                sql.AppendFormat("from psogsys_permissionmenu m left join  psogsys_permission_role_menu rm on m.sys_menu_code = rm.sys_menu_code and rm.sys_role_code='{0}' ", roleId);
                sql.Append("where m.sys_menu_p_code = 'ROOT' ");
                sql.Append("order by sys_menu_index asc ");
            }
            else
            {
                sql.Append("select id,sys_menu_code, sys_menu_p_code, sys_menu_url, ");
                sql.Append("sys_menu_name,sys_menu_index , ");
                sql.Append("(select count(1) from psogsys_permissionmenu g where g.sys_menu_p_code = m.sys_menu_code) childCount,'' sys_role_code ");
                sql.Append("from psogsys_permissionmenu m ");
                sql.Append("where m.sys_menu_p_code = 'ROOT' ");
                sql.Append("order by sys_menu_index asc ");
            }
            

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_menu_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else 
                    {
                        node.state = "open";
                    }
                    string sys_role_code = BeanTools.ObjectToString(dr["sys_role_code"]);
                    if (!string.IsNullOrEmpty(sys_role_code))
                    {
                        node.isChecked = true;
                    }
                    else
                    {
                        node.isChecked = false;
                    }

                    node.iconCls = "sysMan_menu";
                    node.attributes = childCount + "";
                    headNode.children.Add(node);
                }
            }
            treeList.Add(headNode);

            return treeList;
        }

        /// <summary>
        /// ���ݽ�ɫ�����ѯװ��
        /// </summary>
        /// <param name="roleCode"></param>
        /// <returns></returns>
        public List<Plant> qryPlantByRole(string roleCode)
        {
            List<Plant> plantIds = new List<Plant>();

            StringBuilder sql = new StringBuilder();

            if (!string.IsNullOrEmpty(roleCode))
            {
                sql.Append("select m.sys_menu_code, p.plantinfo_plantname,rm.sys_role_code ");
                sql.Append("from psogSys_plantInfo p right join  psogsys_permissionmenu m on p.plantinfo_plantcode= m.sys_menu_url ");
                sql.AppendFormat("left join  psogsys_permission_role_menu rm on m.sys_menu_code = rm.sys_menu_code and rm.sys_role_code='{0}' ", roleCode);
                sql.Append("where m.sys_menu_p_code = 'Plant'  and p.isuse ='1' ");
                sql.Append("order by sys_menu_index asc ");
            }
            else
            {
                sql.Append("select m.sys_menu_code, p.plantinfo_plantname,'' sys_role_code ");
                sql.Append("from psogSys_plantInfo p right join  psogsys_permissionmenu m on p.plantinfo_plantcode= m.sys_menu_url ");
                sql.Append("where m.sys_menu_p_code = 'Plant'  and p.isuse ='1' ");
                sql.Append("order by sys_menu_index asc ");
            }

            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Plant plant = new Plant();

                    plant.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    plant.organtreeName = BeanTools.ObjectToString(dr["plantinfo_plantname"]);
                    string sys_role_code = BeanTools.ObjectToString(dr["sys_role_code"]);
                    if (!string.IsNullOrEmpty(sys_role_code))
                    {
                        plant.isChecked = true;
                    }
                    else
                    {
                        plant.isChecked = false;
                    }
                    plantIds.Add(plant);
                }
            }

            return plantIds;
        }

        public TreeNode qryMenuHeadNode()
        {
            TreeNode node = new TreeNode();
            node.id = "-1";
            node.text = "�˵�";
            node.state = "open";
            node.iconCls = "sysMan_root";
            return node;
        }

        public List<TreeNode> qrtMenuTreeNode(string nodeId, String roleCode)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();


            if (!string.IsNullOrEmpty(roleCode))  //������ɫ���ѯ��͹���Ƿ�ѡ��
            {
                sql.Append("select m.id,m.sys_menu_code, m.sys_menu_p_code, m.sys_menu_url,");
                sql.Append("m.sys_menu_name,m.sys_menu_index ,");
                sql.Append("(select count(1) from psogsys_permissionmenu g where g.sys_menu_p_code = m.sys_menu_code) childCount, ");
                sql.Append("rm.sys_role_code ");
                sql.AppendFormat("from psogsys_permissionmenu m left join  psogsys_permission_role_menu rm on m.sys_menu_code = rm.sys_menu_code and rm.sys_role_code='{0}' ", roleCode);
                sql.AppendFormat("where m.sys_menu_p_code = '{0}' ", nodeId);
                sql.Append("order by sys_menu_index asc ");
            }
            else
            {

                sql.Append("select id,sys_menu_code, sys_menu_p_code, sys_menu_url, ");
                sql.Append("sys_menu_name,sys_menu_index , ");
                sql.Append("(select count(1) from psogsys_permissionmenu g where g.sys_menu_p_code = m.sys_menu_code) childCount, '' sys_role_code ");
                sql.Append("from psogsys_permissionmenu m ");
                sql.AppendFormat("where m.sys_menu_p_code = '{0}' ", nodeId);
                sql.Append("order by sys_menu_index asc ");
            }

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_menu_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }

                    string sys_role_code = BeanTools.ObjectToString(dr["sys_role_code"]);
                    string sys_menu_p_code = BeanTools.ObjectToString(dr["sys_menu_p_code"]);
                    if (!string.IsNullOrEmpty(sys_role_code))   //��Ϊ��ѡ�и�ѡ��
                    {
                        node.isChecked = true;
                    }
                    else
                    {
                        node.isChecked = false;
                    }

                    if ("plant" == sys_menu_p_code.ToLower())
                    {
                        node.iconCls = "sysMan_plant";
                    }
                    else
                    {
                        node.iconCls = "sysMan_menu";
                    }                    
                    node.attributes = childCount + "";
                    treeList.Add(node);
                }
            }

            return treeList;
        }

        public string addRoleMenuRelation(string menuCodes, string roleCode)
        {
            string message = CommonStr.add_fail;

            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(roleCode))
            {
                lock (lockObj)
                {
                    IList sqlList = new ArrayList();

                    //ɾ��ԭ��ɫ��Ӧ�Ĳ˵�
                    String delSql = string.Format("delete from psogsys_permission_role_menu where sys_role_code ='{0}'", roleCode);
                    sqlList.Add(delSql);
                    //���

                    string[] menuCode = menuCodes.Split(',');
                    foreach (string code in menuCode)
                    {
                        string addSql = string.Format("insert into psogsys_permission_role_menu (id, sys_role_code, sys_menu_code) values(newid(),'{0}','{1}')", roleCode, code);
                        sqlList.Add(addSql);
                    }

                    dao.executeNoQuery(sqlList);

                    message = CommonStr.add_succ;
                }
            }

            return message;
        }

        public List<TreeNode> qryHeadOrganTree()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name, ");
            sql.Append("sys_organ_type, ");
            sql.Append("(select count(1) from psogsys_permissionorgan o  ");
            sql.Append("where o.sys_organ_p_code = t.sys_organ_code and o.sys_organ_is_use ='1' ");
            sql.Append(")+(select count(1) from psogsys_permissionuser u where (u.SYS_USER_ORGAN_ID=sys_organ_code or SYS_USER_DEPT_ID=sys_organ_code) and u.sys_user_is_use ='1') childCount ");
            sql.Append("from psogsys_permissionorgan t  ");
            sql.Append("where ( sys_organ_p_code = '9999' or sys_organ_p_code = (select po.sys_organ_code from psogsys_permissionorgan po where po.sys_organ_p_code = '9999' ) ) and t.sys_organ_is_use ='1' ");
            sql.Append("order by sys_organ_order ");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                //���ڵ�
                DataRow dr = ds.Tables[0].Rows[0];
                TreeNode headNode = new TreeNode();
                headNode.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                headNode.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                if (1 <= childCount)    //���ӽڵ�
                {
                    headNode.state = "closed";
                }
                else
                {
                    headNode.state = "open";
                }
                headNode.iconCls = "sysMan_root";
                headNode.attributes = childCount + ":ORGAN";
                

                //�ӽڵ�
                for (int i=1, size=ds.Tables[0].Rows.Count;i<size;i++)
                {
                    dr = ds.Tables[0].Rows[i];
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }
                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                    }
                    node.attributes = childCount + ":ORGAN";
                    
                    headNode.children.Add(node);
                }

                treeList.Add(headNode);
            }

            return treeList;
        }

        public List<TreeNode> qryOrganTreeNode(string parentOrganCode)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name,sys_organ_order, ");
            sql.Append("(select count(1) from psogsys_permissionuser u where (u.SYS_USER_ORGAN_ID=sys_organ_code  ");
            sql.Append("or SYS_USER_DEPT_ID=sys_organ_code) and sys_user_is_use ='1') childCount, 0 organType ");
            sql.Append("from psogsys_permissionorgan t ");
            sql.AppendFormat("where sys_organ_p_code = '{0}'  and t.sys_organ_is_use ='1' ", parentOrganCode);
            sql.Append("union ");
            sql.Append("select id, sys_user_name,sys_user_order, ");
            sql.Append("'0', 1 organType ");
            sql.Append("from psogsys_permissionuser u ");
            sql.AppendFormat("where ((u.SYS_USER_ORGAN_ID='{0}' and SYS_USER_DEPT_ID is null) or  ", parentOrganCode);
            sql.AppendFormat("(SYS_USER_DEPT_ID='{0}' and u.SYS_USER_ORGAN_ID is not null)) and sys_user_is_use ='1' ", parentOrganCode);
            sql.Append("order by organType asc , sys_organ_order asc ");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    string organType = BeanTools.ObjectToString(dr["organType"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }

                    if ("0" == organType)
                    {
                        node.attributes = childCount + ":ORGAN";
                        node.iconCls = "sysMan_department";
                    }
                    else
                    {
                        node.attributes = childCount + ":USER";
                        node.iconCls = "sysMan_user";
                    }
                    treeList.Add(node);
                }
            }

            return treeList;
        }

        public string addUserRoleRelation(string roleCodes, string userId)
        {
            string message = CommonStr.add_fail;

            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                lock (lockObj)
                {
                    IList sqlList = new ArrayList();

                    //ɾ��ԭ��ɫ��Ӧ�Ĳ˵�
                    String delSql = string.Format("delete from psogsys_permission_user_role where sys_user_id ='{0}'", userId);
                    sqlList.Add(delSql);
                    //���

                    string[] roleCode = roleCodes.Split(',');
                    foreach (string code in roleCode)
                    {
                        string addSql = string.Format("insert into psogsys_permission_user_role (id, sys_user_id, sys_role_code) values(newid(),'{0}','{1}')", userId, code);
                        sqlList.Add(addSql);
                    }

                    dao.executeNoQuery(sqlList);

                    message = CommonStr.add_succ;
                }
            }

            return message;
        }

        /// <summary>
        /// ���ݿͻ���ip��ѯ�û�����
        /// </summary>
        /// <param name="remoteAddr"></param>
        /// <returns></returns>
        public SysUser qryUserNameByURL(string remoteAddr)
        {
            SysUser user = new SysUser();

            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(remoteAddr))
            {
                string sql = string.Format("select id,sys_user_login_name,sys_user_name,SYS_USER_IP,SYS_USER_ORGAN_ID,SYS_USER_DEPT_ID from psogsys_permissionuser where SYS_USER_IP ='{0}' and SYS_USER_IS_USE ='1' ", remoteAddr);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    user.userLoginName = BeanTools.ObjectToString(dr["sys_user_login_name"]);
                    user.userName = BeanTools.ObjectToString(dr["sys_user_name"]);
                    user.userIp = BeanTools.ObjectToString(dr["SYS_USER_IP"]);
                    user.userOrganId = BeanTools.ObjectToString(dr["SYS_USER_ORGAN_ID"]);
                    user.userDeptId = BeanTools.ObjectToString(dr["SYS_USER_DEPT_ID"]);
                    user.userId = BeanTools.ObjectToString(dr["ID"]);
                }
            }

            return user;
        }

        /// <summary>
        /// �����û�id��ȡ�ܲ鿴��װ��
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string qryPlantsByUserId(string userId)
        {
            string plants = "";
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select m.sys_menu_url, m.sys_menu_index ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and sys_menu_p_code = 'PLANT'  order by m.sys_menu_index asc ", userId);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        plants = "" == plants ? BeanTools.ObjectToString(dr["sys_menu_url"]) : plants + "," + BeanTools.ObjectToString(dr["sys_menu_url"]);
                    }
                }
            }
            return plants;
        }

        public List<TreeNode> loadManageTree(string userId, String parentMenuCode)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();

            string sql = "select distinct m.sys_menu_code, m.sys_menu_url, m.sys_menu_name, m.sys_menu_index ";
            sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur, ";
            sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
            sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
            sql += string.Format("and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code and m.sys_menu_p_code = '{0}' ", parentMenuCode);
            sql += string.Format("and u.id = '{0}' order by m.sys_menu_index asc ", userId);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_menu_name"]);
                    node.attributes = BeanTools.ObjectToString(dr["sys_menu_url"]);
                    if ("#".Equals(node.attributes))
                    {
                        node.state = "closed";
                        node.iconCls = "sysMan_gztype";
                    }
                    else {
                        node.state = "open";
                        node.iconCls = "sysMan_menu";
                    }
                    treeList.Add(node);
                }
            }

            return treeList;
        }

        /// <summary>
        /// �����û�Ȩ�޻�ȡ��Ӧ����ʾ��ҳ������
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string qryFunctionNos(string userId)
        {
            string functionNos = "";
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct substring(m.sys_menu_code,1,3)  sys_menu_code ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_code in ('002001','003','004001','004002','004003','004004') ", userId);    //002001,003,004 �����޶��Ĺ��ܱȽ���

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        functionNos = "" == functionNos ? BeanTools.ObjectToString(dr["sys_menu_code"]) : functionNos + "," + BeanTools.ObjectToString(dr["sys_menu_code"]);
                    }
                }
            }
            return functionNos;
        }

        public string qryArtFunctionNos(string userId)
        {
            string functionNos = "";
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct m.sys_menu_code ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_p_code ='002' ", userId);    //002�����ռ��

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        functionNos = "" == functionNos ? BeanTools.ObjectToString(dr["sys_menu_code"]) : functionNos + "," + BeanTools.ObjectToString(dr["sys_menu_code"]);
                    }
                }
            }
            return functionNos;
        }

        /// <summary>
        /// �û�������ڵ�
        /// </summary>
        /// <returns></returns>
        public List<TreeNode> qryHeadOrganNode()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name, ");
            sql.Append("sys_organ_type, ");
            sql.Append("(select count(1) from psogsys_permissionorgan o  ");
            sql.Append("where o.sys_organ_p_code = t.sys_organ_code  and o.sys_organ_is_use ='1' ");
            sql.Append(") childCount ");
            sql.Append("from psogsys_permissionorgan t  ");
            sql.Append("where (sys_organ_p_code = '9999' or sys_organ_p_code = (select po.sys_organ_code from psogsys_permissionorgan po where po.sys_organ_p_code = '9999' ) ) and t.sys_organ_is_use ='1' ");
            sql.Append("order by sys_organ_order ");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                //���ڵ�
                DataRow dr = ds.Tables[0].Rows[0];
                TreeNode headNode = new TreeNode();
                headNode.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                headNode.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                if (1 <= childCount)    //���ӽڵ�
                {
                    headNode.state = "closed";
                }
                else
                {
                    headNode.state = "open";
                }
                headNode.iconCls = "sysMan_root";
                headNode.attributes = childCount + ":ROOT";


                //�ӽڵ�
                for (int i = 1, size = ds.Tables[0].Rows.Count; i < size; i++)
                {
                    dr = ds.Tables[0].Rows[i];
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }
                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                        node.attributes = childCount + ":ORGAN";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                        node.attributes = childCount + ":DEPT";
                    }
                    

                    headNode.children.Add(node);
                }

                treeList.Add(headNode);
            }

            return treeList;
        }

        /// <summary>
        /// �û����������ѯ�ӽڵ�
        /// </summary>
        /// <param name="parentOrganCode"></param>
        /// <returns></returns>
        public List<TreeNode> qryUserTreeNode(string parentOrganCode)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name,sys_organ_order, ");
            sql.Append("(select count(1) from psogsys_permissionorgan u where u.sys_organ_p_code= t.sys_organ_code and sys_organ_is_use ='1' ) childCount, sys_organ_type ");
            sql.Append("from psogsys_permissionorgan t ");
            sql.AppendFormat("where sys_organ_p_code = '{0}' and t.sys_organ_is_use ='1' ", parentOrganCode);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }

                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                        node.attributes = childCount + ":ORGAN";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                        node.attributes = childCount + ":DEPT";
                    }

                    node.iconCls = "sysMan_department";
                    treeList.Add(node);
                }
            }

            return treeList;
        }

        /// <summary>
        /// ��λ���߲����µ��û�
        /// </summary>
        /// <param name="organCode"></param>
        /// <param name="deptCode"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>

        public EasyUIData qryUserList(string organCode, string deptCode, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            if (!string.IsNullOrEmpty(organCode) || !string.IsNullOrEmpty(deptCode))
            {
                string sql = "select ID, SYS_USER_NAME, SYS_USER_IP, SYS_USER_LOGIN_NAME,  SYS_USER_ORGAN_ID,SYS_USER_TELPHONE,SYS_Message_Method,";
                sql += " SYS_USER_DEPT_ID, SYS_USER_ORDER,count(1) over() usercount ";
                sql += " from psogsys_permissionuser u where SYS_USER_IS_USE = '1' ";
                if (!string.IsNullOrEmpty(deptCode))
                {
                    sql += string.Format("and u.sys_user_dept_id = '{0}' ", deptCode);
                }
                else if (!string.IsNullOrEmpty(organCode))
                {
                    sql += string.Format("and u.sys_user_organ_id = '{0}' ", organCode);
                }
                sql += "order by SYS_USER_ORDER asc  ";

                Dao dao = new Dao();

                DataSet ds = dao.executeQuery(sql, pageNo, pageSize);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["usercount"]);
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        SysUser user = new SysUser();
                        user.userId = BeanTools.ObjectToString(dr["ID"]);
                        user.userName = BeanTools.ObjectToString(dr["SYS_USER_NAME"]);
                        user.userIp = BeanTools.ObjectToString(dr["SYS_USER_IP"]);
                        user.userLoginName = BeanTools.ObjectToString(dr["SYS_USER_LOGIN_NAME"]);
                        user.userOrganId = BeanTools.ObjectToString(dr["SYS_USER_ORGAN_ID"]);
                        user.userDeptId = BeanTools.ObjectToString(dr["SYS_USER_DEPT_ID"]);
                        user.userTel = BeanTools.ObjectToString(dr["SYS_USER_TELPHONE"]);
                        user.userSendMessage = BeanTools.ObjectToString(dr["SYS_Message_Method"]);
                        grid.rows.Add(user);
                    }
                }

            }
            return grid;
        }

        /// <summary>
        /// userId Ϊ�������������޸�
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="userIp"></param>
        /// <param name="userName"></param>
        /// <param name="userLoginName"></param>
        /// <param name="userOrganId"></param>
        /// <param name="userDeptId"></param>
        /// <returns></returns>
        public string addOrUpdateUser(string userId, string userIp, string userName, string userLoginName,
                   string userOrganId, string userDeptId, string userTel,string sendMessage)
        {
            string message = CommonStr.add_fail;

            IDao  dao = new Dao();
            string sql = "";

            //�жϵ�¼���Ƿ�����ظ�
            sql += "select count(1) from psogsys_permissionUser ";
            sql += string.Format("where sys_user_login_name='{0}' and SYS_USER_IS_USE='1' ", userLoginName);
            if (!string.IsNullOrEmpty(userId))
            {
                sql += string.Format(" and ID <> '{0}'  ", userId);
            }

            try
            {
                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    int rowCount = BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]);
                    if (1 <= rowCount)
                    {
                        message = "�û���¼�������ظ���:false";
                        return message;
                    }
                }
                
            }
            catch (Exception exp)
            {
            }


            if (!string.IsNullOrEmpty(userId))//�޸�
            {
                sql = string.Format("update psogsys_permissionUser set SYS_USER_NAME = '{0}', SYS_USER_LOGIN_NAME = '{1}', SYS_USER_IP = '{2}',SYS_USER_TELPHONE='{3}',SYS_Message_Method='{4}' where ID = '{5}' ", userName, userLoginName, userIp, userTel,sendMessage, userId);

            }
            else//����
            {
                userId = Guid.NewGuid().ToString();

                sql = string.Format("insert into psogsys_permissionUser(ID,SYS_USER_NAME,SYS_USER_IP,");
                sql += "SYS_USER_LOGIN_NAME,SYS_USER_PASSWORD,SYS_USER_CREATE_TIME,SYS_USER_IS_USE,SYS_USER_ORGAN_ID,SYS_USER_DEPT_ID,SYS_USER_TELPHONE,SYS_Message_Method,SYS_USER_ORDER ) ";
                sql += string.Format(" (select '{0}','{1}','{2}','{3}','{4}',convert(varchar(19), getdate(), 120),'{5}','{6}','{7}','{8}','{9}', isnull(max(SYS_USER_ORDER),0)+1 from psogsys_permissionuser)",
                    userId, userName, userIp, userLoginName, CommonStr.default_user_password, "1", userOrganId, userDeptId, userTel, sendMessage);
            }

            try
            {
                dao.executeNoQuery(sql);
                message = CommonStr.add_succ + ":" + userId;
            }
            catch (Exception exp)
            {
            }

            return message;
        }

        public string delUser(string userId)
        {
            string message = CommonStr.del_fail;

            IDao dao = new Dao();
            string sql = string.Format("update psogsys_permissionUser set SYS_USER_IS_USE='0',SYS_USER_DROP_TIME=(convert(varchar(19),getdate(),120))  where ID = '{0}' ", userId);
            

            try
            {
                dao.executeNoQuery(sql);
                message = CommonStr.del_succ; 
            }
            catch (Exception exp)
            {
            }

            return message;
        }

        /// <summary>
        /// ��ѯ��ɫ�б�
        /// </summary>
        /// <returns></returns>
        public EasyUIData qryRoleList()
        {
            EasyUIData grid = new EasyUIData();

            string sql = "select ID, SYS_ROLE_CODE,SYS_ROLE_NAME,SYS_ROLE_ORDER ";
            sql += "from psogsys_permissionrole where  SYS_ROLE_CODE <> 'ROOT' ";
            sql += "order by SYS_ROLE_ORDER asc  ";

            Dao dao = new Dao();

            DataSet ds = dao.executeQuery(sql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    SysRole role = new SysRole();
                    role.roleId = BeanTools.ObjectToString(dr["ID"]);
                    role.roleCode = BeanTools.ObjectToString(dr["SYS_ROLE_CODE"]);
                    role.roleIndex = BeanTools.ObjectToString(dr["SYS_ROLE_ORDER"]);
                    role.roleName = BeanTools.ObjectToString(dr["SYS_ROLE_NAME"]);

                    grid.rows.Add(role);
                }
            }
            return grid;
        }

        public string delRole(string roleId)
        {
            string message = CommonStr.del_fail;

            IDao dao = new Dao();
            string sql = string.Format("delete psogsys_permissionRole   where ID = '{0}' ", roleId);


            try
            {
                dao.executeNoQuery(sql);
                message = CommonStr.del_succ;
            }
            catch (Exception exp)
            {
            }

            return message;
        }

        /// <summary>
        /// roleIdΪ��������ɫ�������޸Ľ�ɫ
        /// </summary>
        /// <param name="roleId"></param>
        /// <param name="roleName"></param>
        /// <returns></returns>
        public string addOrUpdateRole(string roleId, string roleName)
        {
            string message = CommonStr.add_fail;

            IDao dao = new Dao();
            string sql = "";

            //�жϵ�¼���Ƿ�����ظ�
            sql += "select count(1) from psogsys_permissionRole ";
            sql += string.Format("where SYS_ROLE_NAME='{0}' ", roleName);
            if (!string.IsNullOrEmpty(roleId))
            {
                sql += string.Format("and ID <> '{0}'  ", roleId);
            }

            try
            {
                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    int rowCount = BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]);
                    if (1 <= rowCount)
                    {
                        message = "��ɫ�������ظ���:false";
                        return message;
                    }
                }

            }
            catch (Exception exp)
            {
            }


            if (!string.IsNullOrEmpty(roleId))//�޸�
            {
                sql = string.Format("update psogsys_permissionRole set SYS_ROLE_NAME = '{0}' where ID = '{1}' ", roleName, roleId);

            }
            else//����
            {
                roleId = Guid.NewGuid().ToString();

                sql = string.Format("insert into psogsys_permissionRole(ID,SYS_ROLE_CODE,SYS_ROLE_NAME,SYS_ROLE_ORDER) ");
                sql += string.Format(" (select '{0}','{1}','{2}', isnull(max(SYS_ROLE_ORDER),0)+1 from psogsys_permissionRole)", roleId, roleId, roleName);
            }

            try
            {
                dao.executeNoQuery(sql);
                message = CommonStr.add_succ + ":" + roleId;
            }
            catch (Exception exp)
            {
            }

            return message;
        }

        public List<FunctionNode> qryFunctionNode(string userId)
        {
            List<FunctionNode> functionList = new List<FunctionNode>();
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct m.sys_menu_name, m.sys_menu_url, m.sys_menu_index,m.sys_menu_code ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_p_code ='004' order by m.sys_menu_index", userId);    //002�����ռ��

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        FunctionNode node = new FunctionNode();

                        node.functionName = BeanTools.ObjectToString(dr["sys_menu_name"]);
                        node.functionUrl = BeanTools.ObjectToString(dr["sys_menu_url"]);
                        node.functionCode = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        functionList.Add(node);
                    }
                }
            }
            return functionList;
        }
        public string[] qryListLimit(string userId,string pageid)
        {
            string[] list=new string[25];
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "SELECT sys_menu_code from PSOGSYS_PermissionMenu m where m.SYS_MENU_P_CODE='" + pageid + "' and m.SYS_MENU_CODE in ";
                sql += "(SELECT rm.SYS_MENU_CODE FROM	PSOGSYS_Permission_Role_Menu rm WHERE	rm.SYS_ROLE_CODE IN (";
                sql += string.Format("SELECT ur.SYS_ROLE_CODE FROM	PSOGSYS_Permission_User_Role ur	WHERE	ur.SYS_USER_ID = '{0}'));",userId);    //002�����ռ��

                DataSet ds = dao.executeQuery(sql);
               
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    int i = 0;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        FunctionNode node = new FunctionNode();

                        list[i] = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        i++;
                    }
                }
            }
            return list;
        }

        public string updateUserInfo(string userId, string userName, string userLoginName, string oldPassword, string newPassword)
        {
            string message = CommonStr.add_fail;

            IDao dao = new Dao();
            string sql = "";

            //�жϵ�¼���Ƿ�����ظ�
            sql += "select count(1) from psogsys_permissionUser ";
            sql += string.Format("where sys_user_login_name='{0}' ", userLoginName);
            sql += string.Format("and ID <> '{0}'  ", userId);

            try
            {
                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    int rowCount = BeanTools.ObjectToInt(ds.Tables[0].Rows[0][0]);
                    if (1 <= rowCount)
                    {
                        message = "�û���¼�������ظ���:false";
                        return message;
                    }
                }

            }
            catch (Exception exp)
            {
            }

            //��֤��ǰ�����Ƿ���ȷ
            sql = "select SYS_USER_PASSWORD from psogsys_permissionUser ";
            sql+= string.Format("where ID = '{0}' ",userId);
            try
            {
                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    string password = BeanTools.ObjectToString(ds.Tables[0].Rows[0]["SYS_USER_PASSWORD"]);
                    if (!password.Equals(oldPassword))
                    {
                        message = "������������������룡:false";
                        return message;
                    }
                }

            }
            catch (Exception exp)
            {
            }
            //�����û���Ϣ
            sql = string.Format("update psogsys_permissionUser set SYS_USER_NAME='{0}',SYS_USER_LOGIN_NAME='{1}'", userName,userLoginName);
            if (!newPassword.Equals("C4CA4238A0B923820DCC509A6F75849B"))
            {
                sql += string.Format(",SYS_USER_PASSWORD='{0}' ", newPassword);
            }
            sql += string.Format("where ID='{0}'", userId);
            try
            {
                dao.executeQuery(sql.ToString());
            }
            catch (Exception e)
            {
                message = "�������ݳ������⣡:false";
                return message;
            }
            message = "���³ɹ���:false";
            return message;

        }
        //Ϊ�칤��ӵ�2015-1-20
        public string deleteAlarmParamenter(string paramentID, string DBName)
        {
            IDao dao = new Dao(DBName);
            if (!string.IsNullOrEmpty(paramentID))
            {
                try
                {
                    string sql = String.Format("update RTResEx_AlarmRealTime set RTResEx_AlarmRealTime_IsClear = '1' where ID = '{0}'", paramentID);
                    dao.executeNoQuery(sql.ToString());
                }
                catch (Exception e)
                {
                    return "ɾ��ʧ�ܣ�";
                }

            }
            return "ɾ���ɹ���";
        }

        public string deleteAlarmParamenter(string paramentID, Plant plant)
        {
            IDao dao = new Dao(plant,false);
            if (!string.IsNullOrEmpty(paramentID))
            {
                try
                {
                    string sql = String.Format("update RTResEx_AlarmRealTime set RTResEx_AlarmRealTime_IsClear = '1' where ID = '{0}'", paramentID);
                    dao.executeNoQuery(sql.ToString());
                }
                catch (Exception e)
                {
                    return "ɾ��ʧ�ܣ�";
                }
                
            }
            return "ɾ���ɹ���";
        }

        public string updMenuItem(string menuId, string menuName, string menuUrl, string menuIndex)
        {
            string message = "�޸�ʧ�ܣ�:" + menuId;
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(menuId))
            {
                try
                {
                    string sql = String.Format("update PSOGSYS_PermissionMenu set SYS_MENU_URL = '{0}', SYS_MENU_NAME='{1}',SYS_MENU_INDEX='{2}' where sys_menu_code = '{3}'", menuUrl.Replace("'", "''"), menuName.Replace("'", "''"), menuIndex.Replace("'", "''"), menuId);
                    dao.executeNoQuery(sql.ToString());
                    message = "�޸ĳɹ���:" + menuId;
                }
                catch (Exception e)
                {
                }

            }
            else
            {
                try
                {
                    menuId = Guid.NewGuid().ToString();
                    IList sqlList = new ArrayList();

                    string sql = String.Format("insert into PSOGSYS_PermissionMenu(id,SYS_MENU_NAME,SYS_MENU_url,sys_menu_code,sys_menu_p_code,sys_menu_index) ");
                    sql += string.Format("select '{0}','{1}','{2}','P'+convert(varchar(31),isnull(max(sys_menu_index),0)+1),'PLANT',isnull(max(sys_menu_index),0)+1 from PSOGSYS_PermissionMenu g where sys_menu_p_code = 'plant'",menuId, menuName,menuUrl);
                    sqlList.Add(sql);

                    string sql1 = String.Format("insert into PSOGSYS_Permission_role_Menu(id, sys_role_code, sys_menu_code) ");   //����������Ա��Ȩ��
                    sql1 += string.Format("select newid(),'Root',sys_menu_code from PSOGSYS_PermissionMenu g where id = '{0}'", menuId);
                    sqlList.Add(sql1);

                    dao.executeNoQuery(sqlList);

                    //��ȡװ�ñ���
                    String menuCode = "";
                    sql = "select sys_menu_code ";
                    sql += string.Format("from PSOGSYS_PermissionMenu m where id = '{0}'", menuId);

                    DataSet ds = dao.executeQuery(sql);
                    if (BeanTools.DataSetIsNotNull(ds))
                    {
                        menuCode = BeanTools.ObjectToString(ds.Tables[0].Rows[0]["sys_menu_code"]);
                    }

                    message = "����ɹ���:" + menuCode;
                }
                catch (Exception e)
                {
                }
            }
            return message;
        }

        /// <summary>
        /// �˵�������ݸ��ڵ��ѯ�˵�
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData qryMenuItemList(string parentMenuCode)
        {
            EasyUIData grid = new EasyUIData();
            if (!string.IsNullOrEmpty(parentMenuCode))
            {
                string sql = "select sys_menu_code, m.SYS_MENU_URL, m.SYS_MENU_NAME, m.SYS_MENU_INDEX ";
                sql += string.Format("from PSOGSYS_PermissionMenu m where sys_menu_p_code = '{0}' or sys_menu_code = '{1}' ", parentMenuCode, parentMenuCode);                
                sql += "order by SYS_menu_index asc  ";

                Dao dao = new Dao();

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        SysMenu menuItem = new SysMenu();
                        menuItem.menuId = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        menuItem.menuName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);
                        menuItem.menuUrl = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                        menuItem.menuIndex = BeanTools.ObjectToString(dr["SYS_MENU_INDEX"]);
                        grid.rows.Add(menuItem);
                    }
                }

            }
            return grid;
        }

        /// <summary>
        /// �˵�װ�ù���-�˵�����װ����
        /// </summary>
        /// <returns></returns>
        public List<TreeNode> qrtMenuAndPlantTree()
        {
            List<TreeNode> treeList = new List<TreeNode>();

            TreeNode headNode = new TreeNode();
            headNode.id = "menu";
            headNode.text = "װ����˵�";
            headNode.state = "open";
            headNode.attributes = "0:root";
            headNode.iconCls = "sysMan_root";

            List<TreeNode> menuItems = qrtHeadMenuItemTree();
            List<TreeNode> plantItems = qrtPlantItemTree();

            headNode.children.AddRange(plantItems); //װָ��
            headNode.children.AddRange(menuItems);  //�˵���
            
            treeList.Add(headNode);
            return treeList;
        }

        /// <summary>
        /// �˵�װ�ù���-�˵���
        /// </summary>
        /// <returns></returns>
        private List<TreeNode> qrtHeadMenuItemTree()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            TreeNode headNode = new TreeNode();
            headNode.id = "root";
            headNode.text = "�˵�";
            headNode.state = "open";
            headNode.iconCls = "sysMan_root";
            headNode.attributes = "0:menu";
            StringBuilder sql = new StringBuilder();

            sql.Append("select id,sys_menu_code, sys_menu_p_code, sys_menu_url, ");
            sql.Append("sys_menu_name,sys_menu_index , ");
            sql.Append("(select count(1) from psogsys_permissionmenu g where g.sys_menu_p_code = m.sys_menu_code) childCount,'' sys_role_code ");
            sql.Append("from psogsys_permissionmenu m ");
            sql.Append("where m.sys_menu_p_code = 'ROOT' ");
            sql.Append("order by sys_menu_index asc ");


            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_menu_name"]);
                    int childCount = BeanTools.ObjectToInt(dr["childCount"]);
                    if (1 <= childCount)    //���ӽڵ�
                    {
                        node.state = "closed";
                    }
                    else
                    {
                        node.state = "open";
                    }
                    node.iconCls = "sysMan_menu";
                    node.attributes = childCount + ":menu";
                    headNode.children.Add(node);
                }
            }
            treeList.Add(headNode);

            return treeList;
        }

        /// <summary>
        /// �˵�װ�ù���-װ�����ڵ�
        /// </summary>
        /// <returns></returns>
        private List<TreeNode> qrtPlantItemTree()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            TreeNode headNode = new TreeNode();
            headNode.id = "plant";
            headNode.text = "װ��";
            headNode.state = "open";
            headNode.iconCls = "sysMan_root";
            headNode.attributes = "0:plant";
            StringBuilder sql = new StringBuilder();

            sql.Append("select id,sys_menu_code, sys_menu_p_code, sys_menu_url, ");
            sql.Append("sys_menu_name,sys_menu_index ");
            sql.Append("from psogsys_permissionmenu m ");
            sql.Append("where m.sys_menu_p_code = 'Plant' ");
            sql.Append("order by sys_menu_index asc ");


            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_menu_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_menu_name"]);
                    node.state = "open";
                    node.iconCls = "sysMan_plant";
                    node.attributes = "0:plant";
                    headNode.children.Add(node);
                }
            }
            treeList.Add(headNode);

            return treeList;
        }

        /// <summary>
        /// �˵�װ�ù���-ɾ��װ��
        /// </summary>
        /// <param name="menuId"></param>
        /// <returns></returns>
        public string delMenuItem(String menuId)
        {
            string message = CommonStr.del_fail;

            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(menuId))
            {
                lock (lockObj)
                {
                    IList sqlList = new ArrayList();

                    //ɾ��װ���Ѿ������ɫ��Ȩ��
                    String delSql = string.Format("delete from psogsys_permission_role_menu where sys_menu_code ='{0}'", menuId);
                    sqlList.Add(delSql);
                    
                    //ɾ��װ��
                    string addSql = string.Format("delete from psogsys_permissionmenu where sys_menu_code ='{0}'", menuId);
                    sqlList.Add(addSql);

                    dao.executeNoQuery(sqlList);

                    message = CommonStr.del_succ;
                }
            }

            return message;
        }

        public List<FunctionNode> qryFunctionNodeWithArt(string userId)
        {
            List<FunctionNode> functionList = new List<FunctionNode>();
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct m.sys_menu_name, m.sys_menu_url, m.sys_menu_index,m.sys_menu_code ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_p_code ='002' order by m.sys_menu_index", userId);    //002�����ռ��

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        FunctionNode node = new FunctionNode();

                        node.functionName = BeanTools.ObjectToString(dr["sys_menu_name"]);
                        node.functionUrl = BeanTools.ObjectToString(dr["sys_menu_url"]);
                        node.functionCode = BeanTools.ObjectToString(dr["sys_menu_code"]);

                        functionList.Add(node);
                    }
                }
            }
            return functionList;
        }

        /// <summary>
        /// �����
        /// </summary>
        /// <param name="DBName"></param>
        /// <param name="pageNo"></param>
        /// <param name="PageSize"></param>
        /// <returns></returns>
        public EasyUIData qryArtSoftMeasureList(Plant plant, int pageNo, int PageSize)
        {
            EasyUIData grid = new EasyUIData();
            if (!string.IsNullOrEmpty(""))
            {
                string sql = " ";

                Dao dao = new Dao(plant,true);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ArtSoftMeasure softMeasureItem = new ArtSoftMeasure();
                        softMeasureItem.describe = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        softMeasureItem.time = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);
                        softMeasureItem.valuation = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                        softMeasureItem.id = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                        softMeasureItem.trend = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);

                        grid.rows.Add(softMeasureItem);
                    }
                }

            }
            ArtSoftMeasure softMeasureItem1 = new ArtSoftMeasure();
            softMeasureItem1.describe = "����";
            softMeasureItem1.time = "2014-09-22";
            softMeasureItem1.valuation = "0.46";
            softMeasureItem1.id = "1";
            softMeasureItem1.trend = "2";
            grid.rows.Add(softMeasureItem1);
            ArtSoftMeasure softMeasureItem2 = new ArtSoftMeasure();
            softMeasureItem2.describe = "����1";
            softMeasureItem2.time = "2014-09-221";
            softMeasureItem2.valuation = "0.461";
            softMeasureItem2.id = "21";
            softMeasureItem2.trend = "21";
            grid.rows.Add(softMeasureItem2);
            return grid;
        }

        /// <summary>
        /// �������
        /// </summary>
        /// <param name="DBName"></param>
        /// <param name="pageNo"></param>
        /// <param name="PageSize"></param>
        /// <returns></returns>
        public EasyUIData qryArtMechanismBalanceList(Plant plant, int pageNo, int PageSize)
        {
            EasyUIData grid = new EasyUIData();
            if (!string.IsNullOrEmpty(""))
            {
                string sql = " ";

                Dao dao = new Dao(plant,true);

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ArtSoftMeasure softMeasureItem = new ArtSoftMeasure();
                        softMeasureItem.describe = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        softMeasureItem.time = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);
                        softMeasureItem.valuation = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                        softMeasureItem.id = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                        softMeasureItem.trend = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);

                        grid.rows.Add(softMeasureItem);
                    }
                }

            }
            ArtSoftMeasure softMeasureItem1 = new ArtSoftMeasure();
            softMeasureItem1.describe = "����";
            softMeasureItem1.time = "2014-09-22";
            softMeasureItem1.valuation = "0.46";
            softMeasureItem1.id = "1";
            softMeasureItem1.state = "����";

            grid.rows.Add(softMeasureItem1);
            return grid;
        }

        /// <summary>
        /// װ��֪ʶҪ�л���ҳ�棨������ѯ��
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string qryKnowledgeFunctionUrl(string userId)
        {
            string functionNo = "", functionUrl = "";
            IDao dao = new Dao();
            if (!string.IsNullOrEmpty(userId))
            {
                string sql = "select distinct m.sys_menu_code,m.sys_menu_url, m.sys_menu_index ";
                sql += "from psogsys_permissionuser u, psogsys_permission_user_role ur,  ";
                sql += "psogsys_permissionrole r,psogsys_permissionmenu m, psogsys_permission_role_menu mr ";
                sql += "where u.id= ur.sys_user_id and ur.sys_role_code = r.sys_role_code ";
                sql += "and r.sys_role_code = mr.sys_role_code and mr.sys_menu_code = m.sys_menu_code ";
                sql += string.Format("and u.id = '{0}' and m.sys_menu_p_code ='006' order by m.sys_menu_index ", userId);    //006����װ��֪ʶ

                DataSet ds = dao.executeQuery(sql);
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        functionNo = BeanTools.ObjectToString(dr["sys_menu_code"]);
                        functionUrl = BeanTools.ObjectToString(dr["sys_menu_url"]);
                        if (CommonStr.knowledge_manage_code == functionNo)
                        {
                            break;
                        }
                    }
                }
            }
            return functionUrl;
        }


        /// <summary>
        /// ��ѯ��ѡ���λ��
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData querySelectedBit(string parentId, String tagName, String deviceName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode))
            {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }

            StringBuilder sql = new StringBuilder();
            //��ѯ�ĸ���
            if ("bjgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalAlarmConfig_TagName as tagName,t.AbnormalAlarmConfig_DeviceName as deviceName, ");
                sql.Append("t.AbnormalAlarmConfig_Type as typeName,count(1) over() bitCount");
                sql.Append(string.Format(" from PSOG_AbnormalAlarmConfig t where t.AbnormalAlarmConfig_Type='{0}'", typeName));

                //λ��
                if (!string.IsNullOrEmpty(tagName))
                {
                    sql.Append(string.Format(" and t.AbnormalAlarmConfig_TagName like '{0}'", "%" + tagName + "%"));
                }
                //װ��
                if (!string.IsNullOrEmpty(deviceName))
                {
                    sql.Append(string.Format(" and t.AbnormalAlarmConfig_DeviceName like '{0}'", "%" + deviceName + "%"));
                }
                sql.Append(" order by t.AbnormalAlarmConfig_TagName");
            }
            else if ("yjgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalEarlyWarnConfig_TagName as tagName,t.AbnormalEarlyWarnConfig_DeviceName as deviceName, ");
                sql.Append("t.AbnormalEarlyWarnConfig_Type as typeName,count(1) over() bitCount");
                sql.Append(string.Format("  from PSOG_AbnormalEarlyWarnConfig t where t.AbnormalEarlyWarnConfig_Type='{0}'", typeName));
                //λ��
                if (!string.IsNullOrEmpty(tagName))
                {
                    sql.Append(string.Format(" and t.AbnormalEarlyWarnConfig_TagName like '{0}'", "%" + tagName + "%"));
                }
                //װ��
                if (!string.IsNullOrEmpty(deviceName))
                {
                    sql.Append(string.Format(" and t.AbnormalEarlyWarnConfig_DeviceName like '{0}'", "%" + deviceName + "%"));
                }
                sql.Append(" order by t.AbnormalEarlyWarnConfig_TagName");
            }
            else if ("ycgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalStateConfig_TagName as tagName,t.AbnormalStateConfig_DeviceName as deviceName,");
                sql.Append("t.AbnormalStateConfig_Type as typeName,count(1) over() bitCount ");
                sql.Append(string.Format(" from PSOG_AbnormalStateConfig t where t.AbnormalStateConfig_Type='{0}'", typeName));
                //λ��
                if (!string.IsNullOrEmpty(tagName))
                {
                    sql.Append(string.Format(" and t.AbnormalStateConfig_TagName like '{0}'", "%" + tagName + "%"));
                }
                //װ��
                if (!string.IsNullOrEmpty(deviceName))
                {
                    sql.Append(string.Format(" and t.AbnormalStateConfig_DeviceName like '{0}'", "%" + deviceName + "%"));
                }
                sql.Append(" order by t.AbnormalStateConfig_TagName");
            }

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["tagName"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["deviceName"]);
                    bit.typeName = BeanTools.ObjectToString(dr["typeName"]);
                    grid.rows.Add(bit);
                }
            }
            
            return grid;
        }


        /// <summary>
        /// ��ѯ��ѡ���λ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData querySelectingBit(string parentId, String tagName, String deviceName,int pageNo,int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode)) {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode)) {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode)) {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }


            StringBuilder sql = new StringBuilder();
            //��ѯ�ĸ���
            sql.Append("select ins.ID,ins.Instrumentation_Code,ins.Instrumentation_Name,");
            sql.Append("Instrumentation_LineID,Instrumentation_DeviceID,count(1) over() bitCount");
            sql.Append(" from PSOG_Instrumentation ins where ins.IsDelete='0' and ins.Instrumentation_Type=1");
            sql.Append(" and ins.Instrumentation_Code not in");
            if ("bjgz".Equals(gzCode))
            {
                sql.Append("(select t.AbnormalAlarmConfig_TagName from PSOG_AbnormalAlarmConfig t ");
                sql.Append(string.Format(" where t.AbnormalAlarmConfig_Type='{0}')", typeName));
            }
            else if ("yjgz".Equals(gzCode))
            {
                sql.Append("(select t.AbnormalEarlyWarnConfig_TagName from PSOG_AbnormalEarlyWarnConfig t ");
                sql.Append(string.Format(" where t.AbnormalEarlyWarnConfig_Type='{0}')", typeName));
            }
            else if ("ycgz".Equals(gzCode))
            {
                sql.Append("(select t.AbnormalStateConfig_TagName from PSOG_AbnormalStateConfig t ");
                sql.Append(string.Format(" where t.AbnormalStateConfig_Type='{0}')", typeName));
            }

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and ins.Instrumentation_Code like '{0}'", "%" + tagName + "%"));
            }
            //װ��
            if (!string.IsNullOrEmpty(deviceName))
            {
                sql.Append(string.Format(" and ins.Instrumentation_Name like '{0}'", "%" + deviceName + "%"));
            }
            sql.Append(" order by ins.Instrumentation_Code");


            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    bit.belongLineId = BeanTools.ObjectToString(dr["Instrumentation_LineID"]);
                    bit.belongDeviceId = BeanTools.ObjectToString(dr["Instrumentation_DeviceID"]);
                    grid.rows.Add(bit);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ѡ���λ�Ų��뵽λ�����͹�ϵ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String InsertTypeBit(String parentId, List<BitDevice> list) {
            String[] parentInfos = parentId.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode))
            {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }


            //�����ĸ���
            StringBuilder sql = new StringBuilder();
            if ("bjgz".Equals(gzCode))
            {
                sql.Append("insert into PSOG_AbnormalAlarmConfig(ID,AbnormalAlarmConfig_TagName,AbnormalAlarmConfig_DeviceName,AbnormalAlarmConfig_Type)");
            }
            else if ("yjgz".Equals(gzCode))
            {
                sql.Append("insert into PSOG_AbnormalEarlyWarnConfig(ID,AbnormalEarlyWarnConfig_TagName,AbnormalEarlyWarnConfig_DeviceName,AbnormalEarlyWarnConfig_Type)");
            }
            else if ("ycgz".Equals(gzCode))
            {
                sql.Append("insert into PSOG_AbnormalStateConfig(ID,AbnormalStateConfig_TagName,AbnormalStateConfig_DeviceName,AbnormalStateConfig_Type)");
            }
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                foreach (BitDevice bit in list)
                {
                    StringBuilder insertSb = new StringBuilder();
                    insertSb.Append(sql.ToString());
                    insertSb.Append(string.Format(" values('{0}','{1}','{2}','{3}')", Guid.NewGuid().ToString(), bit.bitNo, bit.deviceName, typeName));
                    dao.executeNoQuery(insertSb.ToString());

                    if ("yjgz".Equals(gzCode)) {

                        addVirtualBitCode(dao, bit.bitId, bit.bitNo,bit.belongLineId,bit.belongDeviceId);
                    }
                }
                return "1";
            }
            catch (Exception exe) {
                return "0";
            }
        }

        /// <summary>
        /// �������λ��
        /// </summary>
        /// <param name="plant"></param>
        /// <param name="baseBitCode"></param>
        public void addVirtualBitCode(Dao dao, string baseBitId, string baseBitCode, string lineId, string deviceId)
        {
            //10-Tag_ZouPing  �����ж�
            //2-Tag_BianHuaFuDu �仯����
            //7-Tag_BianHuaLv  ��������
            //1-Tag_GuiLing  ����
            try
            {
                string pdCode = baseBitCode + "_ZouPing";//�����ж�
                string fdCode = baseBitCode + "_BianHuaFuDu";//�仯����
                string lvCode = baseBitCode + "_BianHuaLv";//��������
                string glCode = baseBitCode + "_GuiLing";//����
                //�Ȳ�ѯ�Ƿ��Ѿ�����
                int pdNum = 0;
                int fdNum = 0;
                int lvNum = 0;
                int glNum = 0;
                StringBuilder selSql = new StringBuilder();
                selSql.Append("select");
                selSql.AppendFormat(" (select count(*) from PSOG_Instrumentation t1 where t1.Instrumentation_Code='{0}') as pdNum,", pdCode);
                selSql.AppendFormat(" (select count(*) from PSOG_Instrumentation t1 where t1.Instrumentation_Code='{0}') as fdNum,", fdCode);
                selSql.AppendFormat(" (select count(*) from PSOG_Instrumentation t1 where t1.Instrumentation_Code='{0}') as lvNum,", lvCode);
                selSql.AppendFormat(" (select count(*) from PSOG_Instrumentation t1 where t1.Instrumentation_Code='{0}') as glNum", glCode);

                DataSet ds = dao.executeQuery(selSql.ToString());
                if (BeanTools.DataSetIsNotNull(ds))
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        pdNum = BeanTools.ObjectToInt(dr["pdNum"]);
                        fdNum = BeanTools.ObjectToInt(dr["fdNum"]);
                        lvNum = BeanTools.ObjectToInt(dr["lvNum"]);
                        glNum = BeanTools.ObjectToInt(dr["glNum"]);
                    }
                }
                //������ڣ���ִ�У������ڣ����������
                if (pdNum < 1) {
                    String pdSql = getAddVirtualBitCodeSql(baseBitId, pdCode, "�����ж�", lineId, deviceId, 10,30);
                    dao.executeNoQuery(pdSql);
                }
                if (fdNum < 1)
                {
                    String fdSql = getAddVirtualBitCodeSql(baseBitId, fdCode, "�仯����", lineId, deviceId, 2,10);
                    dao.executeNoQuery(fdSql);
                }
                if (lvNum < 1)
                {
                    String lvSql = getAddVirtualBitCodeSql(baseBitId, lvCode, "��������", lineId, deviceId, 7,30);
                    dao.executeNoQuery(lvSql);
                }
                if (glNum < 1)
                {
                    String glSql = getAddVirtualBitCodeSql(baseBitId, glCode, "����", lineId, deviceId, 1,30);
                    dao.executeNoQuery(glSql);
                }
            }
            catch (Exception e) {
                throw e;
            }

        }

        /// <summary>
        /// �����������λ�ŵ�sql���
        /// </summary>
        /// <param name="?"></param>
        /// <param name="?"></param>
        /// <returns></returns>
        private string getAddVirtualBitCodeSql(string bitId,string bitCode,string bitName,string lineId,string deviceId,int callType,int startTime) { 
               StringBuilder pdSql = new StringBuilder();
               pdSql.Append("insert into PSOG_Instrumentation(Instrumentation_Code,Instrumentation_Name,Instrumentation_Type,");
               pdSql.Append("Instrumentation_LineID,Instrumentation_DeviceID,Instrumentation_CalSequence,Instrumentation_CalType,");
               pdSql.Append("Instrumentation_StartTime,Instrumentation_EndTime,IsMonitor,IsMathCal,Instrumentation_Correlations,IsDelete,IsES)");
               pdSql.AppendFormat(" values('{0}','{1}',5,", bitCode, bitName);
               if (string.IsNullOrEmpty(lineId))
               {
                   pdSql.Append("null,");
               }
               else { 
                   pdSql.AppendFormat("{0},",lineId);
               }
               if (string.IsNullOrEmpty(deviceId))
               {
                  pdSql.Append("null,");
               }
               else { 
                  pdSql.AppendFormat("{0},",deviceId);
               }
               pdSql.AppendFormat("1,{0},{1},0,1,1,'{2}',0,1)", callType,startTime, bitId);
               return pdSql.ToString();
        }

        /// <summary>
        /// ���������쳣��ϵ
        /// </summary>
        /// <param name="id"></param>
        /// <param name="tagName"></param>
        /// <param name="tagDesc"></param>
        public String saveTypeAbnormalInfo(String id,String tagId,String tagName,String tagDesc){
            String[] parentInfos = id.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode))
            {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }
            StringBuilder sql = new StringBuilder();
            if (String.IsNullOrEmpty(tagId))
            { //����
                sql.Append("insert into PSOG_AbnormalStateConfig(ID,AbnormalStateConfig_TagName,AbnormalStateConfig_DeviceName,AbnormalStateConfig_Type)");
                sql.Append(string.Format(" values('{0}','{1}','{2}','{3}')", Guid.NewGuid().ToString(), tagName, tagDesc, typeName));
            }
            else { //�޸�
                sql.Append("update PSOG_AbnormalStateConfig set ");
                sql.AppendFormat(" AbnormalStateConfig_TagName='{0}',AbnormalStateConfig_DeviceName='{1}'", tagName, tagDesc);
                sql.AppendFormat(" where ID='{0}'", tagId);
            }

            
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe) {
                return "0";
            }

        }

       /// <summary>
       /// ɾ������λ�Ź�ϵ
       /// </summary>
       /// <param name="parentId"></param>
       /// <param name="list"></param>
       /// <returns></returns>
        public String deleteTypeBit(String parentId, List<Object> list)
        {
            String[] parentInfos = parentId.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode))
            {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }


            //ɾ��
            String tableName = "PSOG_AbnormalAlarmConfig";
            if ("bjgz".Equals(gzCode))
            {
                tableName = "PSOG_AbnormalAlarmConfig";
            }
            else if ("yjgz".Equals(gzCode))
            {
                tableName = "PSOG_AbnormalEarlyWarnConfig";
            }
            else if ("ycgz".Equals(gzCode))
            {
                tableName = "PSOG_AbnormalStateConfig";
            }
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                foreach (Object obj in list)
                {
                    StringBuilder sql = new StringBuilder();
                    sql.Append(string.Format("delete from {0} where ID='{1}'",tableName,obj.ToString()));
                    dao.executeNoQuery(sql.ToString());
                }
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯ�����µ�λ�����ڵ�
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<TreeNode> queryBitTreeNode(string parentId)
        {
            String[] parentInfos = parentId.Split('#');
            String typeCode = parentInfos[0];
            String gzCode = parentInfos[1];
            String plantId = parentInfos[2];

            //����
            String typeName = "";
            if ("gy".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("zl".Equals(typeCode))
            {
                typeName = "����";
            }
            else if ("sb".Equals(typeCode))
            {
                typeName = "�豸";
            }
            else if ("gygc".Equals(typeCode))
            {
                typeName = "���ù���";
            }

            StringBuilder sql = new StringBuilder();
            //��ѯ�ĸ���
            if ("bjgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalAlarmConfig_TagName as tagName,t.AbnormalAlarmConfig_DeviceName as deviceName ");
                sql.Append(string.Format(" from PSOG_AbnormalAlarmConfig t where t.AbnormalAlarmConfig_Type='{0}'", typeName));
                sql.Append(" order by t.AbnormalAlarmConfig_TagName");
            }
            else if ("yjgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalEarlyWarnConfig_TagName as tagName,t.AbnormalEarlyWarnConfig_DeviceName as deviceName ");
                sql.Append(string.Format("  from PSOG_AbnormalEarlyWarnConfig t where t.AbnormalEarlyWarnConfig_Type='{0}'", typeName));
                sql.Append(" order by t.AbnormalEarlyWarnConfig_TagName");
            }
            else if ("ycgz".Equals(gzCode))
            {
                sql.Append("select t.ID,t.AbnormalStateConfig_TagName as tagName,t.AbnormalStateConfig_DeviceName as deviceName ");
                sql.Append(string.Format(" from PSOG_AbnormalStateConfig t where t.AbnormalStateConfig_Type='{0}'", typeName));
                sql.Append(" order by t.AbnormalStateConfig_TagName");
            }

            List<TreeNode> treeList = new List<TreeNode>();
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["ID"]) + "#" + parentId;
                    node.text = BeanTools.ObjectToString(dr["tagName"]);
                    node.state = "open";
                    string deviceName = BeanTools.ObjectToString(dr["deviceName"]);
                    node.attributes = deviceName+":bit";
                    node.iconCls = "sysMan_leafnode";
                    treeList.Add(node);
                }
            }
            return treeList;
        }


        /// <summary>
        /// �û�ѡ����--���ڵ�
        /// </summary>
        /// <returns></returns>
        public List<TreeNode> UserSelectOrgTree()
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            StringBuilder sql = new StringBuilder();

            sql.Append("select sys_organ_code,sys_organ_name,sys_organ_type ");
            sql.Append(" from psogsys_permissionorgan t  ");
            sql.Append("where (sys_organ_p_code = '9999' or sys_organ_p_code = (select po.sys_organ_code from psogsys_permissionorgan po where po.sys_organ_p_code = '9999' ) ) and t.sys_organ_is_use ='1' ");
            sql.Append("order by sys_organ_order ");

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                //���ڵ�
                DataRow dr = ds.Tables[0].Rows[0];
                TreeNode headNode = new TreeNode();
                headNode.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                headNode.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                headNode.state = "open";
                headNode.iconCls = "sysMan_root";
                headNode.attributes =  "1:ROOT";


                //�ӽڵ�
                for (int i = 1, size = ds.Tables[0].Rows.Count; i < size; i++)
                {
                    dr = ds.Tables[0].Rows[i];
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    node.state = "closed";
                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                        node.attributes = "1:ORGAN";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                        node.attributes =  "1:DEPT";
                    }


                    headNode.children.Add(node);
                }

                treeList.Add(headNode);
            }

            return treeList;
        }


        /// <summary>
        /// �û�ѡ����--��ѯ���ź���Ա
        /// </summary>
        /// <param name="parentOrganCode"></param>
        /// <returns></returns>
        public List<TreeNode> queryUserSelectDeptUserNode(string parentId,string type)
        {
            IDao dao = new Dao();
            List<TreeNode> treeList = new List<TreeNode>();
            //��ѯ����
            StringBuilder sql = new StringBuilder();
            sql.Append("select sys_organ_code,sys_organ_name,sys_organ_order,sys_organ_type ");
            sql.Append("from psogsys_permissionorgan t ");
            sql.AppendFormat("where sys_organ_p_code = '{0}' and t.sys_organ_is_use ='1' ", parentId);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["sys_organ_code"]);
                    node.text = BeanTools.ObjectToString(dr["sys_organ_name"]);
                    node.state = "closed";

                    string sys_organ_type = BeanTools.ObjectToString(dr["sys_organ_type"]);
                    if ("01" == sys_organ_type) //��λ
                    {
                        node.iconCls = "sysMan_organ";
                        node.attributes =  "1:ORGAN";
                    }
                    else    //����
                    {
                        node.iconCls = "sysMan_department";
                        node.attributes = "1:DEPT";
                    }
                    treeList.Add(node);
                }
            }


            //��ѯ��Ա
            StringBuilder userSql = new StringBuilder();
            userSql.Append("select ID, SYS_USER_NAME ");
            userSql.Append(" from psogsys_permissionuser u where SYS_USER_IS_USE = '1'");
            if ("DEPT".Equals(type)) {
                userSql.Append(string.Format(" and u.sys_user_dept_id = '{0}' ", parentId));
            }
            else if ("ORGAN".Equals(type)) {
                userSql.Append(string.Format(" and (u.sys_user_dept_id is null or u.sys_user_dept_id='') and u.sys_user_organ_id = '{0}' ", parentId));
            }

            DataSet userDs = dao.executeQuery(userSql.ToString());
            if (BeanTools.DataSetIsNotNull(userDs))
            {
                foreach (DataRow dr in userDs.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["ID"]);
                    node.text = BeanTools.ObjectToString(dr["SYS_USER_NAME"]);
                    node.state = "open";
                    node.attributes = "0:USER";
                    node.iconCls = "sysMan_user";
                    treeList.Add(node);
                }
            }

            return treeList;
        }

        /// <summary>
        /// ���汨������
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="topLevel"></param>
        /// <param name="lowLevel"></param>
        /// <param name="time1"></param>
        /// <param name="man1"></param>
        /// <param name="time2"></param>
        /// <param name="man2"></param>
        /// <param name="time3"></param>
        /// <param name="man3"></param>
        /// <returns></returns>
        public String saveAlarmRule(String id, String plantId, String topLevel, String lowLevel, String time1,
                                     String man1,String manName1, String time2, String man2,String manName2,
                                     String time3, String man3,String manName3) {
             StringBuilder sql = new StringBuilder();
             sql.Append("update PSOG_AbnormalAlarmConfig ");
             sql.AppendFormat(" set AbnormalAlarmConfig_TopLevel='{0}',AbnormalAlarmConfig_LowLevel = '{1}',",topLevel,lowLevel);
             if (!string.IsNullOrEmpty(time1))
             {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime1={0},AbnormalAlarmConfig_StartMen1='{1}',AbnormalAlarmConfig_StartMenName1='{2}',", Convert.ToInt32(time1), man1,manName1);
             }
             else {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime1=null,AbnormalAlarmConfig_StartMen1='{0}',AbnormalAlarmConfig_StartMenName1='{1}',", man1,manName1);
             }
             if (!string.IsNullOrEmpty(time2))
             {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime2={0},AbnormalAlarmConfig_StartMen2='{1}',AbnormalAlarmConfig_StartMenName2='{2}',", Convert.ToInt32(time2), man2,manName2);
             }
             else {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime2=null,AbnormalAlarmConfig_StartMen2='{0}',AbnormalAlarmConfig_StartMenName2='{1}',", man2,manName2);
             }
             if (!string.IsNullOrEmpty(time3))
             {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime3={0},AbnormalAlarmConfig_StartMen3='{1}',AbnormalAlarmConfig_StartMenName3='{2}'", Convert.ToInt32(time3), man3,manName3);
             }
             else {
                 sql.AppendFormat("AbnormalAlarmConfig_StartTime3=null,AbnormalAlarmConfig_StartMen3='{0}',AbnormalAlarmConfig_StartMenName3='{1}'", man3,manName3);
             }
             sql.AppendFormat(" where ID='{0}'", id);
             try
             {
                 Plant plant = BeanTools.getPlantDB(plantId);
                 Dao dao = new Dao(plant, true);
                 dao.executeNoQuery(sql.ToString());
                 return "1";
             }
             catch (Exception exe)
             {
                 return "0";
             }

        }

        /// <summary>
        /// ��ȡ�������õ�λ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getAlarmBitInfo(String plantId,String bitId) {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.AbnormalRealTime_TagName,t.AbnormalRealTime_Desc,");
            sql.Append("t.AbnormalRealTime_Type,t.AbnormalRealTime_Value,t.AbnormalRealTime_State,t.AbnormalRealTime_IsConfirm");
            sql.AppendFormat("  from RTResEx_AbnormalRealTime t where t.AbnormalRealTime_TagID='{0}'",bitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());

            BitDevice device = new BitDevice();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    device.bitId = BeanTools.ObjectToString(dr["ID"]);
                    device.bitNo = BeanTools.ObjectToString(dr["AbnormalRealTime_TagName"]);
                    device.deviceName = BeanTools.ObjectToString(dr["AbnormalRealTime_Desc"]);
                    device.typeName = BeanTools.ObjectToString(dr["AbnormalRealTime_Type"]);
                    device.realValue = BeanTools.ObjectToString(dr["AbnormalRealTime_Value"]);
                    device.status = BeanTools.ObjectToString(dr["AbnormalRealTime_State"]);
                    device.isConfirm = BeanTools.ObjectToString(dr["AbnormalRealTime_IsConfirm"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(device);
            return jsonData;
        }

        /// <summary>
        /// ��ѯλ�ŵ�DCS������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitCode"></param>
        /// <returns></returns>
        public string  getAlarmLimitValue(string plantId, string bitCode) {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.Instrumentation_High,t.Instrumentation_Low from PSOG_Instrumentation t ");
            sql.AppendFormat(" where t.Instrumentation_Code='{0}'  and t.IsDelete=0", bitCode);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            Dictionary<string, string> dict = new Dictionary<string, string>();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string highValue = BeanTools.ObjectToString(dr["Instrumentation_High"]);
                    string lowValue = BeanTools.ObjectToString(dr["Instrumentation_Low"]);
                    dict.Add("highValue", highValue);
                    dict.Add("lowValue", lowValue);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(dict);
            return jsonData;
        }

        /// <summary>
        /// ȷ�ϱ�����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public string confirmAlarm(String plantId,String id,string userId,string userName) {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("update RTResEx_AbnormalRealTime set AbnormalRealTime_IsConfirm='��ȷ��'");
                sql.AppendFormat(" where AbnormalRealTime_TagID='{0}'", id);
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, false);
                dao.executeNoQuery(sql.ToString());
                //��¼ȷ����Ϣ
                insertConfirmRecord(plant,id,userId,userName);
                return "1";
            }
            catch (Exception e) {
                return "0";
            }
        }

        /// <summary>
        /// ����Ԥ����Ϣȷ�ϼ�¼
        /// </summary>
        /// <param name="plant"></param>
        /// <param name="id"></param>
        private void insertConfirmRecord(Plant plant, String id,string userId,string userName) {
            try
            {
                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO PSOG_AbnormalConfirm_Record (");
                sql.Append("	ID,");
                sql.Append("	Confirm_TagId,");
                sql.Append("	Confirm_TagName,");
                sql.Append("	Confirm_TagDesc,");
                sql.Append("	Confirm_RealValue,");
                sql.Append("	Confirm_StartDate,");
                sql.Append("	Confirm_SustainTime,");
                sql.Append("	Confirm_UserId,");
                sql.Append("	Confirm_UserName,");
                sql.Append("	Confirm_Date,");
                sql.Append("	Confirm_Type)  ");
                sql.AppendFormat("SELECT '{0}',r.AbnormalRealTime_TagID,", Guid.NewGuid().ToString());
                sql.Append("	r.AbnormalRealTime_TagName,");
                sql.Append("	r.AbnormalRealTime_Desc,");
                sql.Append("	r.AbnormalRealTime_Value,");
                sql.Append("	r.AbnormalRealTime_StartTime,");
                sql.Append("	r.AbnormalRealTime_SustainTime,");
                sql.AppendFormat("'{0}','{1}','{2}','����'", userId, userName, nowDate);
                sql.AppendFormat(" FROM {0}.dbo.RTResEx_AbnormalRealTime r",plant.realTimeDB);
                sql.AppendFormat(" WHERE r.AbnormalRealTime_TagID = '{0}'", id);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
            }
            catch (Exception e) { 
            
            }
           
        }


        /// <summary>
        /// ��ѯ����������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getAlarmRuleInfo(String plantId, String bitId) {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.AbnormalAlarmConfig_TopLevel,t.AbnormalAlarmConfig_LowLevel,");
            sql.Append("t.AbnormalAlarmConfig_StartTime1,t.AbnormalAlarmConfig_StartMen1,t.AbnormalAlarmConfig_StartMenName1,");
            sql.Append("t.AbnormalAlarmConfig_StartTime2,t.AbnormalAlarmConfig_StartMen2,t.AbnormalAlarmConfig_StartMenName2,");
            sql.Append("t.AbnormalAlarmConfig_StartTime3,t.AbnormalAlarmConfig_StartMen3,t.AbnormalAlarmConfig_StartMenName3");
            sql.AppendFormat("  from PSOG_AbnormalAlarmConfig t where t.ID='{0}'",bitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            AlarmRule rule = new AlarmRule();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    rule.topLevel = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_TopLevel"]);
                    rule.lowLevel = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_LowLevel"]);
                    rule.alarmTime1 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartTime1"]);
                    rule.alarmMan1 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMen1"]);
                    rule.alarmManName1 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMenName1"]);
                    rule.alarmTime2 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartTime2"]);
                    rule.alarmMan2 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMen2"]);
                    rule.alarmManName2 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMenName2"]);
                    rule.alarmTime3 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartTime3"]);
                    rule.alarmMan3 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMen3"]);
                    rule.alarmManName3 = BeanTools.ObjectToString(dr["AbnormalAlarmConfig_StartMenName3"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(rule);
            return jsonData;
        }

        /// <summary>
        /// ��ѯλ�������ֵ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<Dictionary<String, String>> queryBitDict(String plantId) {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.Instrumentation_Code from PSOG_Instrumentation t where t.IsDelete=0 and t.Instrumentation_Type=1");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            List<Dictionary<String, String>> list = new List<Dictionary<string, string>>();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<String, String> dict = new Dictionary<string, string>();
                    String bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    dict.Add("label", bitNo);
                    dict.Add("value", bitNo);
                    list.Add(dict);
                }
            }
            return list;
        }

        /// <summary>
        /// ���ݱ����ȡλ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitCode"></param>
        /// <returns></returns>
        public string queryBitInfoByCode(String plantId,string bitCode,string paramKPI)
        {
            string result = "";
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.Instrumentation_Name,");
            sql.Append("	t.Instrumentation_Unit,");
            sql.Append("	t.Instrumentation_UpLine,");
            sql.Append("	t.Instrumentation_DownLine,");
            if (string.IsNullOrEmpty(paramKPI))
            {
                sql.Append(" '' as kpiValue");
            }
            else {
                if ("�߱�".Equals(paramKPI))
                {
                    sql.Append(" t.Instrumentation_High as kpiValue");
                }
                else if ("�߸߱�".Equals(paramKPI))
                {
                    sql.Append(" t.Instrumentation_HHigh as kpiValue");
                }
                else if ("�ͱ�".Equals(paramKPI))
                {
                    sql.Append(" t.Instrumentation_Low as kpiValue");
                }
                else if ("�͵ͱ�".Equals(paramKPI))
                {
                    sql.Append(" t.Instrumentation_LLow as kpiValue");
                }
            }

            sql.Append(" FROM");
            sql.Append("	PSOG_Instrumentation t");
            sql.Append(" WHERE");
            sql.Append("	t.IsDelete = 0");
            sql.AppendFormat(" AND t.Instrumentation_Code = '{0}'", bitCode);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            Dictionary<String, String> dict = new Dictionary<string, string>();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String bitName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    String bitUnit = BeanTools.ObjectToString(dr["Instrumentation_Unit"]);
                    String bitUpLine = BeanTools.ObjectToString(dr["Instrumentation_UpLine"]);
                    String bitDownLine = BeanTools.ObjectToString(dr["Instrumentation_DownLine"]);
                    String kpiValue = BeanTools.ObjectToString(dr["kpiValue"]);
                    dict.Add("bitName",bitName);
                    dict.Add("bitUnit",bitUnit);
                    dict.Add("bitRange", bitDownLine + "��" + bitUpLine);
                    dict.Add("kpiValue", kpiValue);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            result = jsonSerializer.Serialize(dict);
            return result;
        }

        /// <summary>
        /// ��ѯԤ�������µ�λ�������ֵ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<Dictionary<String, String>> queryEarlyAlarmBitDict(String plantId,string baseBitCode)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.Instrumentation_Code from PSOG_Instrumentation t");
            sql.AppendFormat(" where t.IsDelete=0 and t.Instrumentation_Code like '{0}/_%' escape '/'", baseBitCode);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            List<Dictionary<String, String>> list = new List<Dictionary<string, string>>();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<String, String> dict = new Dictionary<string, string>();
                    String bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    dict.Add("label", bitNo);
                    dict.Add("value", bitNo);
                    list.Add(dict);
                }
            }
            return list;
        }


        /// <summary>
        /// ����Ԥ������
        /// </summary>
        /// <param name="id"></param>
        /// <param name="plantId"></param>
        /// <param name="rule"></param>
        /// <param name="time1"></param>
        /// <param name="man1"></param>
        /// <param name="manName1"></param>
        /// <param name="time2"></param>
        /// <param name="man2"></param>
        /// <param name="manName2"></param>
        /// <param name="time3"></param>
        /// <param name="man3"></param>
        /// <param name="manName3"></param>
        /// <returns></returns>
        public String saveEarlyAlarmRule(String id, String plantId, String rule, String time1,
                                     String man1, String manName1, String time2, String man2, String manName2,
                                     String time3, String man3, String manName3)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("update PSOG_AbnormalEarlyWarnConfig ");
            sql.AppendFormat(" set AbnormalEarlyWarnConfig_Rule='{0}',", rule);
            if (!string.IsNullOrEmpty(time1))
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime1={0},AbnormalEarlyWarnConfig_StartMen1='{1}',AbnormalEarlyWarnConfig_StartMenName1='{2}',", Convert.ToInt32(time1), man1, manName1);
            }
            else
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime1=null,AbnormalEarlyWarnConfig_StartMen1='{0}',AbnormalEarlyWarnConfig_StartMenName1='{1}',", man1, manName1);
            }
            if (!string.IsNullOrEmpty(time2))
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime2={0},AbnormalEarlyWarnConfig_StartMen2='{1}',AbnormalEarlyWarnConfig_StartMenName2='{2}',", Convert.ToInt32(time2), man2, manName2);
            }
            else
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime2=null,AbnormalEarlyWarnConfig_StartMen2='{0}',AbnormalEarlyWarnConfig_StartMenName2='{1}',", man2, manName2);
            }
            if (!string.IsNullOrEmpty(time3))
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime3={0},AbnormalEarlyWarnConfig_StartMen3='{1}',AbnormalEarlyWarnConfig_StartMenName3='{2}'", Convert.ToInt32(time3), man3, manName3);
            }
            else
            {
                sql.AppendFormat("AbnormalEarlyWarnConfig_StartTime3=null,AbnormalEarlyWarnConfig_StartMen3='{0}',AbnormalEarlyWarnConfig_StartMenName3='{1}'", man3, manName3);
            }
            sql.AppendFormat(" where ID='{0}'", id);
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }

        }

        /// <summary>
        /// ��ȡԤ�����õ�λ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getEarlyAlarmBitInfo(String plantId, String bitId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT");
            sql.Append("	t.AbnormalEarlyRealTime_TagName,");
            sql.Append("	t.AbnormalEarlyRealTime_Desc,");
            sql.Append("	t.AbnormalEarlyRealTime_Type,");
            sql.Append("	t.AbnormalEarlyRealTime_IsConfirm,");
            sql.Append("	st.RTData_fRTVal,");
            sql.Append("	stuff(");
            sql.Append("		(");
            sql.Append("			SELECT");
            sql.Append("				',' + r.AbnormalEarlyRealTime_State");
            sql.Append("			FROM");
            sql.Append("				RTResEx_AbnormalEarlyRealTime r");
            sql.Append("			WHERE");
            sql.Append("				r.AbnormalEarlyRealTime_TagID = t.AbnormalEarlyRealTime_TagID");
            sql.Append("			AND r.AbnormalEarlyRealTime_State <> '����'");
            sql.Append("			AND r.AbnormalEarlyRealTime_State <> '�����쳣' FOR xml path ('')");
            sql.Append("		),");
            sql.Append("		1,");
            sql.Append("		1,");
            sql.Append("		''");
            sql.Append("	) AS status");
            sql.Append(" FROM");
            sql.Append("	RTResEx_AbnormalEarlyRealTime t");
            sql.Append(" LEFT JOIN RTResEx_RTData st ON t.AbnormalEarlyRealTime_TagName = st.TagName");
            sql.Append(" WHERE");
            sql.AppendFormat("	t.AbnormalEarlyRealTime_TagID = '{0}'", bitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());

            BitDevice device = new BitDevice();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    device.bitNo = BeanTools.ObjectToString(dr["AbnormalEarlyRealTime_TagName"]);
                    device.deviceName = BeanTools.ObjectToString(dr["AbnormalEarlyRealTime_Desc"]);
                    device.typeName = BeanTools.ObjectToString(dr["AbnormalEarlyRealTime_Type"]);
                    device.realValue = BeanTools.ObjectToString(dr["RTData_fRTVal"]);
                    device.status = BeanTools.ObjectToString(dr["status"]);
                    device.isConfirm = BeanTools.ObjectToString(dr["AbnormalEarlyRealTime_IsConfirm"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(device);
            return jsonData;
        }

        /// <summary>
        /// ȷ��Ԥ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public string confirmEarlyAlarm(String plantId, String id,string userId,string userName)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("update RTResEx_AbnormalEarlyRealTime set AbnormalEarlyRealTime_IsConfirm='��ȷ��'");
                sql.AppendFormat(" where AbnormalEarlyRealTime_TagID='{0}'", id);
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, false);
                dao.executeNoQuery(sql.ToString());

                //����Ԥ��ȷ�ϼ�¼
                insertEarlyAlarmConfirmRecord(plant,id,userId,userName);
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }

        }

        /// <summary>
        /// ����Ԥ����Ϣȷ�ϼ�¼
        /// </summary>
        /// <param name="plant"></param>
        /// <param name="id"></param>
        private void insertEarlyAlarmConfirmRecord(Plant plant, String id, string userId, string userName)
        {
            try
            {
                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO PSOG_AbnormalConfirm_Record (");
                sql.Append("	ID,");
                sql.Append("	Confirm_TagId,");
                sql.Append("	Confirm_TagName,");
                sql.Append("	Confirm_TagDesc,");
                sql.Append("	Confirm_RealValue,");
                sql.Append("	Confirm_StartDate,");
                sql.Append("	Confirm_SustainTime,");
                sql.Append("	Confirm_UserId,");
                sql.Append("	Confirm_UserName,");
                sql.Append("	Confirm_Date,");
                sql.Append("	Confirm_Type)  ");
                sql.AppendFormat("SELECT TOP 1 '{0}',r.AbnormalEarlyRealTime_TagID,", Guid.NewGuid().ToString());
                sql.Append("	r.AbnormalEarlyRealTime_TagName,");
                sql.Append("	r.AbnormalEarlyRealTime_Desc,");
                sql.Append("	r.AbnormalEarlyRealTime_Value,");
                sql.Append("	r.AbnormalEarlyRealTime_StartTime,");
                sql.Append("	r.AbnormalEarlyRealTime_SustainTime,");
                sql.AppendFormat("'{0}','{1}','{2}','Ԥ��'", userId, userName, nowDate);
                sql.AppendFormat(" FROM {0}.dbo.RTResEx_AbnormalEarlyRealTime r", plant.realTimeDB);
                sql.AppendFormat(" WHERE r.AbnormalEarlyRealTime_TagID = '{0}'", id);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
            }
            catch (Exception e)
            {

            }

        }

        /// <summary>
        /// ��ѯԤ��������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getEarlyAlarmRuleInfo(String plantId, String bitId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.AbnormalEarlyWarnConfig_Rule,");
            sql.Append("t.AbnormalEarlyWarnConfig_StartTime1,t.AbnormalEarlyWarnConfig_StartMen1,t.AbnormalEarlyWarnConfig_StartMenName1,");
            sql.Append("t.AbnormalEarlyWarnConfig_StartTime2,t.AbnormalEarlyWarnConfig_StartMen2,t.AbnormalEarlyWarnConfig_StartMenName2,");
            sql.Append("t.AbnormalEarlyWarnConfig_StartTime3,t.AbnormalEarlyWarnConfig_StartMen3,t.AbnormalEarlyWarnConfig_StartMenName3");
            sql.AppendFormat("  from PSOG_AbnormalEarlyWarnConfig t where t.ID='{0}'", bitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            EarlyAlarmRule rule = new EarlyAlarmRule();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    rule.earlyAlarmRule = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_Rule"]);
                    rule.earlyAlarmTime1 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartTime1"]);
                    rule.earlyAlarmMan1 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMen1"]);
                    rule.earlyAlarmManName1 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMenName1"]);
                    rule.earlyAlarmTime2 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartTime2"]);
                    rule.earlyAlarmMan2 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMen2"]);
                    rule.earlyAlarmManName2 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMenName2"]);
                    rule.earlyAlarmTime3 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartTime3"]);
                    rule.earlyAlarmMan3 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMen3"]);
                    rule.earlyAlarmManName3 = BeanTools.ObjectToString(dr["AbnormalEarlyWarnConfig_StartMenName3"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(rule);
            return jsonData;
        }

        /// <summary>
        /// �����쳣����
        /// </summary>
        /// <param name="id"></param>
        /// <param name="plantId"></param>
        /// <param name="rule"></param>
        /// <param name="time1"></param>
        /// <param name="man1"></param>
        /// <param name="manName1"></param>
        /// <param name="time2"></param>
        /// <param name="man2"></param>
        /// <param name="manName2"></param>
        /// <param name="time3"></param>
        /// <param name="man3"></param>
        /// <param name="manName3"></param>
        /// <returns></returns>
        public String saveAbnormalStateRule(String id, String plantId, String rule, String time1,
                                     String man1, String manName1, String time2, String man2, String manName2,
                                     String time3, String man3, String manName3)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("update PSOG_AbnormalStateConfig ");
            sql.AppendFormat(" set AbnormalStateConfig_Rule='{0}',", rule);
            if (!string.IsNullOrEmpty(time1))
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime1={0},AbnormalStateConfig_StartMen1='{1}',AbnormalStateConfig_StartMenName1='{2}',", Convert.ToInt32(time1), man1, manName1);
            }
            else
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime1=null,AbnormalStateConfig_StartMen1='{0}',AbnormalStateConfig_StartMenName1='{1}',", man1, manName1);
            }
            if (!string.IsNullOrEmpty(time2))
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime2={0},AbnormalStateConfig_StartMen2='{1}',AbnormalStateConfig_StartMenName2='{2}',", Convert.ToInt32(time2), man2, manName2);
            }
            else
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime2=null,AbnormalStateConfig_StartMen2='{0}',AbnormalStateConfig_StartMenName2='{1}',", man2, manName2);
            }
            if (!string.IsNullOrEmpty(time3))
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime3={0},AbnormalStateConfig_StartMen3='{1}',AbnormalStateConfig_StartMenName3='{2}'", Convert.ToInt32(time3), man3, manName3);
            }
            else
            {
                sql.AppendFormat("AbnormalStateConfig_StartTime3=null,AbnormalStateConfig_StartMen3='{0}',AbnormalStateConfig_StartMenName3='{1}'", man3, manName3);
            }
            sql.AppendFormat(" where ID='{0}'", id);
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ȡ�쳣���õĻ�����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getAbnomalStateInfo(String plantId, String id)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.AbnormalStateRealTime_TagName,t.AbnormalStateRealTime_Desc,t.AbnormalStateRealTime_State,t.AbnormalStateRealTime_IsConfirm");
            sql.AppendFormat("  from RTResEx_AbnormalStateRealTime t where t.AbnormalStateRealTime_TagID='{0}'", id);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());

            BitDevice device = new BitDevice();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    device.bitNo = BeanTools.ObjectToString(dr["AbnormalStateRealTime_TagName"]);
                    device.deviceName = BeanTools.ObjectToString(dr["AbnormalStateRealTime_Desc"]);
                    device.status = BeanTools.ObjectToString(dr["AbnormalStateRealTime_State"]);
                    device.isConfirm = BeanTools.ObjectToString(dr["AbnormalStateRealTime_IsConfirm"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(device);
            return jsonData;
        }


        /// <summary>
        /// ȷ���쳣��Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public string confirmAbnormalState(String plantId, String id,String userId,String userName)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("update RTResEx_AbnormalStateRealTime set AbnormalStateRealTime_IsConfirm='��ȷ��'");
                sql.AppendFormat(" where AbnormalStateRealTime_TagID='{0}'", id);
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, false);
                dao.executeNoQuery(sql.ToString());
                
                //�����쳣ȷ�ϼ�¼
                insertAbnormalConfirmRecord(plant,id,userId,userName);
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }

        }

        /// <summary>
        /// �����쳣��Ϣȷ�ϼ�¼
        /// </summary>
        /// <param name="plant"></param>
        /// <param name="id"></param>
        private void insertAbnormalConfirmRecord(Plant plant, String id, string userId, string userName)
        {
            try
            {
                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO PSOG_AbnormalConfirm_Record (");
                sql.Append("	ID,");
                sql.Append("	Confirm_TagId,");
                sql.Append("	Confirm_TagName,");
                sql.Append("	Confirm_TagDesc,");
                sql.Append("	Confirm_RealValue,");
                sql.Append("	Confirm_StartDate,");
                sql.Append("	Confirm_SustainTime,");
                sql.Append("	Confirm_UserId,");
                sql.Append("	Confirm_UserName,");
                sql.Append("	Confirm_Date,");
                sql.Append("	Confirm_Type)  ");
                sql.AppendFormat("SELECT '{0}',r.AbnormalStateRealTime_TagID,", Guid.NewGuid().ToString());
                sql.Append("	r.AbnormalStateRealTime_TagName,");
                sql.Append("	r.AbnormalStateRealTime_Desc,");
                sql.Append("	0,");
                sql.Append("	r.AbnormalStateRealTime_StartTime,");
                sql.Append("	r.AbnormalStateRealTime_SustainTime,");
                sql.AppendFormat("'{0}','{1}','{2}','�쳣'", userId, userName, nowDate);
                sql.AppendFormat(" FROM {0}.dbo.RTResEx_AbnormalStateRealTime r", plant.realTimeDB);
                sql.AppendFormat(" WHERE r.AbnormalStateRealTime_TagID = '{0}'", id);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
            }
            catch (Exception e)
            {

            }
        }



        /// <summary>
        /// ��ѯ�쳣������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getAbnormalStateRuleInfo(String plantId, String bitId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.AbnormalStateConfig_Rule,");
            sql.Append("t.AbnormalStateConfig_StartTime1,t.AbnormalStateConfig_StartMen1,t.AbnormalStateConfig_StartMenName1,");
            sql.Append("t.AbnormalStateConfig_StartTime2,t.AbnormalStateConfig_StartMen2,t.AbnormalStateConfig_StartMenName2,");
            sql.Append("t.AbnormalStateConfig_StartTime3,t.AbnormalStateConfig_StartMen3,t.AbnormalStateConfig_StartMenName3");
            sql.AppendFormat("  from PSOG_AbnormalStateConfig t where t.ID='{0}'", bitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            AbnormalStateRule rule = new AbnormalStateRule();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    rule.abStateRule = BeanTools.ObjectToString(dr["AbnormalStateConfig_Rule"]);
                    rule.abStateTime1 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartTime1"]);
                    rule.abStateMan1 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMen1"]);
                    rule.abStateManName1 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMenName1"]);
                    rule.abStateTime2 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartTime2"]);
                    rule.abStateMan2 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMen2"]);
                    rule.abStateManName2 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMenName2"]);
                    rule.abStateTime3 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartTime3"]);
                    rule.abStateMan3 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMen3"]);
                    rule.abStateManName3 = BeanTools.ObjectToString(dr["AbnormalStateConfig_StartMenName3"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String jsonData = jsonSerializer.Serialize(rule);
            return jsonData;
        }


        /// <summary>
        /// ��ѯװ���µĵ�Ԫ�ڵ�
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<TreeNode> queryUnitTreeNode(string plantId)
        {
            List<TreeNode> treeList = new List<TreeNode>();
            //�����ҳ
            TreeNode mainNode = new TreeNode();
            mainNode.id = "main#" + plantId;
            mainNode.text = "��ҳ";
            mainNode.state = "open";
            mainNode.attributes = "0:main";
            mainNode.iconCls = "sysMan_homepage";
            treeList.Add(mainNode);

            //���״̬���
            TreeNode statusNode = new TreeNode();
            statusNode.id = "status#" + plantId;
            statusNode.text = "״̬���";
            statusNode.state = "closed";
            statusNode.attributes = "1:status";
            statusNode.iconCls = "sysMan_gztype";

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT t.ID,t.ProductLine_Code,t.ProductLine_Name,");
            sql.Append("(select count(*) from PSOG_Device p where p.Device_ProductLineID=t.ID) as num" );
            sql.Append(" from PSOG_ProductLine t where (t.IsDelete is null or t.IsDelete<>'1') order by t.ID");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["ID"]) + "#" + plantId;
                    node.text = BeanTools.ObjectToString(dr["ProductLine_Name"]);
                    int num = Convert.ToInt32(BeanTools.ObjectToString(dr["num"]));
                    if (num > 0)
                    {
                        node.state = "closed";
                        node.attributes = "1:unit";
                    }
                    else {
                        node.state = "open";
                        node.attributes = "0:unit";
                    }

                    node.iconCls = "sysMan_sort";
                    statusNode.children.Add(node);
                }
            }
            treeList.Add(statusNode);

            TreeNode alarmNode = new TreeNode();
            alarmNode.id = "alarm#" + plantId;
            alarmNode.text = "��������";
            alarmNode.state = "closed";
            alarmNode.attributes = "3:alarm";
            alarmNode.iconCls = "sysMan_gztype";

            TreeNode alarmSurveyNode = new TreeNode();
            alarmSurveyNode.id = "alarmSurvey#" + plantId;
            alarmSurveyNode.text = "�������";
            alarmSurveyNode.state = "open";
            alarmSurveyNode.attributes = "0:alarmSurvey";
            alarmSurveyNode.iconCls = "sysMan_leafnode";
            alarmNode.children.Add(alarmSurveyNode);

            //TreeNode alarmParamNode = new TreeNode();
            //alarmParamNode.id = "alarmParam#" + plantId;
            //alarmParamNode.text = "���ղ���̨��";
            //alarmParamNode.state = "open";
            //alarmParamNode.attributes = "0:alarmParam";
            //alarmParamNode.iconCls = "sysMan_leafnode";
            //alarmNode.children.Add(alarmParamNode);

            //TreeNode alarmParamChangeNode = new TreeNode();
            //alarmParamChangeNode.id = "alarmParamChange#" + plantId;
            //alarmParamChangeNode.text = "���ղ������̨��";
            //alarmParamChangeNode.state = "open";
            //alarmParamChangeNode.attributes = "0:alarmParamChange";
            //alarmParamChangeNode.iconCls = "sysMan_leafnode";
            //alarmNode.children.Add(alarmParamChangeNode);

            //TreeNode alarmParamApplyNode = new TreeNode();
            //alarmParamApplyNode.id = "alarmParamApply#" + plantId;
            //alarmParamApplyNode.text = "���ղ����������";
            //alarmParamApplyNode.state = "open";
            //alarmParamApplyNode.attributes = "0:alarmParamApply";
            //alarmParamApplyNode.iconCls = "sysMan_leafnode";
            //alarmNode.children.Add(alarmParamApplyNode);

            //TreeNode alarmParamExamNode = new TreeNode();
            //alarmParamExamNode.id = "alarmParamExam#" + plantId;
            //alarmParamExamNode.text = "���ղ���������";
            //alarmParamExamNode.state = "open";
            //alarmParamExamNode.attributes = "0:alarmParamExam";
            //alarmParamExamNode.iconCls = "sysMan_leafnode";
            //alarmNode.children.Add(alarmParamExamNode);

            treeList.Add(alarmNode);

            TreeNode operatorNode = new TreeNode();
            operatorNode.id = "operator#" + plantId;
            operatorNode.text = "��������";
            operatorNode.state = "open";
            operatorNode.attributes = "0:operator";
            operatorNode.iconCls = "sysMan_leafnode";
            treeList.Add(operatorNode);

            TreeNode modalNode = new TreeNode();
            modalNode.id = "modal#" + plantId;
            modalNode.text = "ģ�Ͳ鿴";
            modalNode.state = "closed";
            modalNode.attributes = "2:modal";
            modalNode.iconCls = "sysMan_gztype";

            TreeNode stModalNode = new TreeNode();
            stModalNode.id = "stmodal#" + plantId;
            stModalNode.text = "״̬���ģ�Ϳ�";
            stModalNode.state = "open";
            stModalNode.attributes = "0:stmodal";
            stModalNode.iconCls = "sysMan_leafnode";
            modalNode.children.Add(stModalNode);

            TreeNode baseModalNode = new TreeNode();
            baseModalNode.id = "basemodal#" + plantId;
            baseModalNode.text = "��ԭ�����ģ�Ϳ�";
            baseModalNode.state = "open";
            baseModalNode.attributes = "0:basemodal";
            baseModalNode.iconCls = "sysMan_leafnode";
            modalNode.children.Add(baseModalNode);

            treeList.Add(modalNode);
           
            return treeList;
        }


        /// <summary>
        /// ��ѯװ���µ�ԭ���ܲ˵�
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<TreeNode> queryHistoryMenuTreeNode(string plantId)
        {
            List<TreeNode> treeList = new List<TreeNode>();
            //�����ҳ
            TreeNode mainNode = new TreeNode();
            mainNode.id = "main#" + plantId;
            mainNode.text = "��ҳ";
            mainNode.state = "open";
            mainNode.attributes = "0:main";
            mainNode.iconCls = "sysMan_homepage";
            treeList.Add(mainNode);

            TreeNode alarmNode = new TreeNode();
            alarmNode.id = "alarm#" + plantId;
            alarmNode.text = "��������";
            alarmNode.state = "closed";
            alarmNode.attributes = "3:alarm";
            alarmNode.iconCls = "sysMan_gztype";

            TreeNode realAlarmNode = new TreeNode();
            realAlarmNode.id = "realAlarm#" + plantId;
            realAlarmNode.text = "ʵʱ����";
            realAlarmNode.state = "open";
            realAlarmNode.attributes = "0:realAlarm";
            realAlarmNode.iconCls = "sysMan_leafnode";
            alarmNode.children.Add(realAlarmNode);

            TreeNode alarmSurveyNode = new TreeNode();
            alarmSurveyNode.id = "alarmSurvey#" + plantId;
            alarmSurveyNode.text = "��������";
            alarmSurveyNode.state = "open";
            alarmSurveyNode.attributes = "0:alarmSurvey";
            alarmSurveyNode.iconCls = "sysMan_leafnode";
            alarmNode.children.Add(alarmSurveyNode);

            TreeNode paramChangeNode = new TreeNode();
            paramChangeNode.id = "paramChange#" + plantId;
            paramChangeNode.text = "�����������";
            paramChangeNode.state = "closed";
            paramChangeNode.attributes = "0:paramChange";
            paramChangeNode.iconCls = "sysMan_sort";

            TreeNode changeApplyNode = new TreeNode();
            changeApplyNode.id = "changeApply#" + plantId;
            changeApplyNode.text = "�������";
            changeApplyNode.state = "open";
            changeApplyNode.attributes = "0:changeApply";
            changeApplyNode.iconCls = "sysMan_leafnode";
            paramChangeNode.children.Add(changeApplyNode);

            TreeNode changeExamNode = new TreeNode();
            changeExamNode.id = "changeExam#" + plantId;
            changeExamNode.text = "������";
            changeExamNode.state = "open";
            changeExamNode.attributes = "0:changeExam";
            changeExamNode.iconCls = "sysMan_leafnode";
            paramChangeNode.children.Add(changeExamNode);

            TreeNode changeRecordNode = new TreeNode();
            changeRecordNode.id = "changeRecord#" + plantId;
            changeRecordNode.text = "�����¼";
            changeRecordNode.state = "open";
            changeRecordNode.attributes = "0:changeRecord";
            changeRecordNode.iconCls = "sysMan_leafnode";
            paramChangeNode.children.Add(changeRecordNode);

            alarmNode.children.Add(paramChangeNode);

            treeList.Add(alarmNode);

            TreeNode operatorNode = new TreeNode();
            operatorNode.id = "operator#" + plantId;
            operatorNode.text = "��������";
            operatorNode.state = "open";
            operatorNode.attributes = "0:operator";
            operatorNode.iconCls = "sysMan_leafnode";
            treeList.Add(operatorNode);

            //����ר�õ�ͼ�μ��
            TreeNode graphicNode = new TreeNode();
            graphicNode.id = "graphic#" + plantId;
            graphicNode.text = "ͼ�μ��";
            graphicNode.state = "open";
            graphicNode.attributes = "0:graphic";
            graphicNode.iconCls = "sysMan_leafnode";
            treeList.Add(graphicNode);

            TreeNode modalNode = new TreeNode();
            modalNode.id = "modal#" + plantId;
            modalNode.text = "�쳣����";
            modalNode.state = "closed";
            modalNode.attributes = "2:modal";
            modalNode.iconCls = "sysMan_gztype";

            TreeNode baseModalNode = new TreeNode();
            baseModalNode.id = "basemodal#" + plantId;
            baseModalNode.text = "��ԭ�����ģ�Ϳ�";
            baseModalNode.state = "open";
            baseModalNode.attributes = "0:basemodal";
            baseModalNode.iconCls = "sysMan_leafnode";
            modalNode.children.Add(baseModalNode);

            treeList.Add(modalNode);

            return treeList;
        }

        /// <summary>
        /// ��ѯ��Ԫ�µ��豸�ڵ�
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<TreeNode> queryDeviceTreeNode(string parentId)
        {
            String[] parentIns = parentId.Split('#');
            String unitId = parentIns[0];
            String plantId = parentIns[1];

            List<TreeNode> treeList = new List<TreeNode>();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Device_Code,t.Device_Name from PSOG_Device t ");
            sql.AppendFormat(" where t.Device_ProductLineID='{0}' and (t.IsDelete is null or t.IsDelete <> '1') order by t.ID", unitId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["ID"]) + "#" + plantId;
                    node.text = BeanTools.ObjectToString(dr["Device_Code"]);
                    node.state = "open";
                    node.attributes = "0:device";
                    node.iconCls = "sysMan_leafnode";
                    treeList.Add(node);
                }
            }
            return treeList;
        }


        /// <summary>
        /// �ж�΢���˻��Ƿ��Ѵ���
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string getWXUserFlag(String userId) {
            IDao dao = new Dao();
            StringBuilder sql = new StringBuilder();
            sql.Append("select u.SYS_WXUSER_ISCREATED from PSOGSYS_PermissionUser u");
            sql.AppendFormat(" where u.ID='{0}'",userId);

            String isCreated = "";

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    isCreated = BeanTools.ObjectToString(dr["SYS_WXUSER_ISCREATED"]);
                }
            }

            return isCreated;
        }

        /// <summary>
        /// �����û����
        /// </summary>
        /// <param name="userId"></param>
        public void updateWXUserFlag(String userId) {
            IDao dao = new Dao();
            StringBuilder sql = new StringBuilder();
            sql.Append("update PSOGSYS_PermissionUser set SYS_WXUSER_ISCREATED='1'");
            sql.AppendFormat(" where ID='{0}'",userId);
            dao.executeNoQuery(sql.ToString());
        }


        /// <summary>
        /// ��ѯ������δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAlarmInfo_new()
        {

            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalRealTime_TagID,t.AbnormalRealTime_TagName,t.AbnormalRealTime_Desc,t.AbnormalRealTime_State,");
                    alarmSql.Append("t.AbnormalRealTime_StartTime,t.AbnormalRealTime_SustainTime,t.AbnormalRealTime_Value, ");
                    alarmSql.Append(" AbnormalRealTime_MsgMark,t.AbnormalRealTime_SendMessage from RTResEx_AbnormalRealTime t");
                    alarmSql.Append(" where (t.AbnormalRealTime_IsConfirm is null or t.AbnormalRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalRealTime_State<>'����' and t.AbnormalRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalRealTime_Value"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalRealTime_SendMessage"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }

                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=Alarm";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOG������Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalAlarmConfig_StartTime1,t.AbnormalAlarmConfig_StartMen1,t.AbnormalAlarmConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime2,t.AbnormalAlarmConfig_StartMen2,t.AbnormalAlarmConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime3,t.AbnormalAlarmConfig_StartMen3,t.AbnormalAlarmConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalAlarmConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen1"]);
                                    string manName1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName1"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen2"]);
                                    string manName2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName2"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen3"]);
                                    string manName3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName3"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++) {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i])) {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SmsSendFunc(message, mobile1List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message,"����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i])) {
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID,tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile1List);
                                                            // web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else {
                                                            num1++;
                                                        }
                                                    }

                                                    
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "1", "AbnormalRealTime_NormalMsgMark");
                                                   
                                                    
                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SmsSendFunc(message, mobile2List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile2List);
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                           
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else {
                                                            num2++;
                                                        }
                                                    }

                                                   
                                                     updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "2", "AbnormalRealTime_NormalMsgMark");
                                                    
                                                   
                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SmsSendFunc(message, mobile3List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                            num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile3List);
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else {
                                                            num3++;
                                                        }
                                                    }
                                                 
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "3", "AbnormalRealTime_NormalMsgMark");
                                                   
                                                   

                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯԤ����δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendEarlyAlarmInfo_new()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalEarlyRealTime_TagID,t.AbnormalEarlyRealTime_TagName,t.AbnormalEarlyRealTime_Desc,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_State,t.AbnormalEarlyRealTime_StartTime,AbnormalEarlyRealTime_Value,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_SustainTime,t.AbnormalEarlyRealTime_MsgMark,t.AbnormalEarlyRealTime_SendMessage from RTResEx_AbnormalEarlyRealTime t ");
                    alarmSql.Append("where (t.AbnormalEarlyRealTime_IsConfirm is null or t.AbnormalEarlyRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_State<>'����' and t.AbnormalEarlyRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalEarlyRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Desc"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SendMessage"]);

                            String tagState = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_StartTime"]);

                            String continueTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }

                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=EarlyAlarm";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOGԤ����Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalEarlyWarnConfig_StartTime1,t.AbnormalEarlyWarnConfig_StartMen1,AbnormalEarlyWarnConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime2,t.AbnormalEarlyWarnConfig_StartMen2,AbnormalEarlyWarnConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime3,t.AbnormalEarlyWarnConfig_StartMen3,AbnormalEarlyWarnConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalEarlyWarnConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i]))
                                                        {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SmsSendFunc(message, mobile1List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile1List);
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else {
                                                            num1++;
                                                        }
                                                    }
                                                  
                                                   updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "1", "AbnormalEarlyRealTime_NormalMsgMark");
                                                  
                                                   
                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SmsSendFunc(message, mobile2List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile2List);
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                           
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else {
                                                            num2++;
                                                        }
                                                    }
                                                    
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "2", "AbnormalEarlyRealTime_NormalMsgMark");
                                                    
                                                   
                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SmsSendFunc(message, mobile3List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                             num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile3List);
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                         
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else {
                                                            num3++;
                                                        }
                                                    }
                                                   
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "3", "AbnormalEarlyRealTime_NormalMsgMark");
                                                   
                                                   


                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯ�쳣��δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAbnormalStateInfo_new()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalStateRealTime_TagID,t.AbnormalStateRealTime_TagName,t.AbnormalStateRealTime_Desc,");
                    alarmSql.Append("t.AbnormalStateRealTime_State,AbnormalStateRealTime_StartTime,");
                    alarmSql.Append("t.AbnormalStateRealTime_SustainTime,AbnormalStateRealTime_MsgMark,t.AbnormalStateRealTime_SendMessage from RTResEx_AbnormalStateRealTime t ");
                    alarmSql.Append("where (t.AbnormalStateRealTime_IsConfirm is null or t.AbnormalStateRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalStateRealTime_State<>'����' and t.AbnormalStateRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalStateRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalStateRealTime_Desc"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalStateRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SendMessage"]);

                            String tagState = BeanTools.ObjectToString(drr["AbnormalStateRealTime_State"]);
                            String realValue = "0";
                            String startTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_StartTime"]);

                            String continueTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }
                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=Abnormal";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOG�쳣��Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalStateConfig_StartTime1,t.AbnormalStateConfig_StartMen1,t.AbnormalStateConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime2,t.AbnormalStateConfig_StartMen2,t.AbnormalStateConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime3,t.AbnormalStateConfig_StartMen3,t.AbnormalStateConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalStateConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i]))
                                                        {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SmsSendFunc(message, mobile1List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i]))
                                                        {
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            string[] mobile1List = new string[1];
                                                            mobile1List[0] = mobile1s[i];
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile1List);
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else {
                                                            num1++;
                                                        }
                                                    }
                                                    
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "1", "AbnormalStateRealTime_NormalMsgMark");
                                                    
                                                    

                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SmsSendFunc(message, mobile2List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            string[] mobile2List = new string[1];
                                                            mobile2List[0] = mobile2s[i];
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile2List);
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                         
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else {
                                                            num2++;
                                                        }
                                                    }
                                                  
                                                   updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "2", "AbnormalStateRealTime_NormalMsgMark");
                                                   
                                                   
                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SmsSendFunc(message, mobile3List);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                            num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            string[] mobile3List = new string[1];
                                                            mobile3List[0] = mobile3s[i];
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            web.SmsSendFunc(message, mobile3List);
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else {
                                                            num3++;
                                                        }
                                                    }
                                              
                                                    updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "3", "AbnormalStateRealTime_NormalMsgMark");
                                                   
                                                   


                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ������Ϣ���͵ı��
        /// </summary>
        /// <param name="dao"></param>
        /// <param name="table"></param>
        /// <param name="colName"></param>
        /// <param name="id"></param>
        /// <param name="mark"></param>
        public void updateRealMesMark(IDao dao,String table,string colName,String id,String mark,string normalColName) {
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("update {0} set {1}='{2}',{3}='0'", table, colName, mark, normalColName);
            sql.AppendFormat(" where ID='{0}'",id);
            dao.executeNoQuery(sql.ToString());
        }

        /// <summary>
        /// ������Ϣ��¼
        /// </summary>
        /// <param name="plant"></param>
        /// <param name="tagId"></param>
        /// <param name="tagName"></param>
        /// <param name="tagDesc"></param>
        /// <param name="type"></param>
        /// <param name="state"></param>
        /// <param name="startDate"></param>
        /// <param name="sustainTime"></param>
        /// <param name="value"></param>
        /// <param name="toUserId"></param>
        /// <param name="toUserName"></param>
        /// <param name="sendDate"></param>
        /// <param name="sendMessage"></param>
        public void insertMessageRecord(Plant plant,string tagId, string tagName, string tagDesc, string type, string state, string startDate, string sustainTime,
            string value, string toUserId, string toUserName, string sendDate, string sendMessage,string sendMethod) {
                try
                {
                    int continueTime = sustainTime == null ? 0 : Convert.ToInt32(sustainTime);
                    float realValue = float.Parse(value);
                    StringBuilder sql = new StringBuilder();
                    sql.Append("insert into PSOG_AbnormalSendMessage_Record(ID,MessageRecord_TagId,MessageRecord_TagName,MessageRecord_TagDesc,");
                    sql.Append("MessageRecord_Type,MessageRecord_State,MessageRecord_StartDate,MessageReocrd_SustainTime,MessageRecord_Value,");
                    sql.Append("MessageRecord_ToUserId,MessageRecord_ToUserName,MessageRecord_SendDate,MessageRecord_SendMessage,MessageRecord_SendMethod)");
                    sql.AppendFormat(" values('{0}','{1}','{2}','{3}','{4}',", Guid.NewGuid().ToString(), tagId, tagName, tagDesc, type);
                    sql.AppendFormat("'{0}','{1}',{2},{3},'{4}','{5}',", state, startDate, continueTime, realValue, toUserId, toUserName);
                    sql.AppendFormat("'{0}','{1}','{2}')", sendDate, sendMessage, sendMethod);

                    Dao dao = new Dao(plant, true);
                    dao.executeNoQuery(sql.ToString());
                }
                catch (Exception e) { 
                   
                }
        }


        /// <summary>
        /// ��ѯ����������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAlarmNormalInfo_new()
        {

            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalRealTime_TagID,t.AbnormalRealTime_SendMessage,t.AbnormalRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalRealTime_TagName,t.AbnormalRealTime_Desc,t.AbnormalRealTime_State,t.AbnormalRealTime_StartTime,");
                    alarmSql.Append("t.AbnormalRealTime_SustainTime,t.AbnormalRealTime_Value");
                    alarmSql.Append(" from RTResEx_AbnormalRealTime t where t.AbnormalRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalRealTime_SustainTime"]);

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalAlarmConfig_StartTime1,t.AbnormalAlarmConfig_StartMen1,t.AbnormalAlarmConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime2,t.AbnormalAlarmConfig_StartMen2,t.AbnormalAlarmConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime3,t.AbnormalAlarmConfig_StartMen3,t.AbnormalAlarmConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalAlarmConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            
                                           updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                            
                                           
                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length) {
                                                sendMark2 = "1";
                                            }
                                            
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark2 = "1";
                                            }
                                          
                                        }
                                        
                                        updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                        

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length) {
                                                sendMark3 = "1";
                                            }
                                            
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark3 = "1";
                                            }
                                           
                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SmsSendFunc(message, mobile3List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile3List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length) {
                                                sendMark3 = "1";
                                            }
                                           
                                        }
                                      
                                        updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                        
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯԤ��������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendEarlyAlarmNormalInfo_new()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalEarlyRealTime_TagID,t.AbnormalEarlyRealTime_SendMessage,t.AbnormalEarlyRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalEarlyRealTime_TagName,t.AbnormalEarlyRealTime_Desc,t.AbnormalEarlyRealTime_State,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_StartTime,t.AbnormalEarlyRealTime_SustainTime,t.AbnormalEarlyRealTime_Value");
                    alarmSql.Append(" from RTResEx_AbnormalEarlyRealTime t where t.AbnormalEarlyRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SustainTime"]);

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalEarlyWarnConfig_StartTime1,t.AbnormalEarlyWarnConfig_StartMen1,t.AbnormalEarlyWarnConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime2,t.AbnormalEarlyWarnConfig_StartMen2,t.AbnormalEarlyWarnConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime3,t.AbnormalEarlyWarnConfig_StartMen3,t.AbnormalEarlyWarnConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalEarlyWarnConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                          
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                            
                                           
                                            
                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                               
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length) {
                                                sendMark2 = "1";
                                            }
                                           
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark2 = "1";
                                            }
                                          
                                        }
                                       
                                        updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                       

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark3 = "1";
                                            }
                                            
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark3 = "1";
                                            }
                                            
                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SmsSendFunc(message, mobile3List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile3List);
                                                
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length) {
                                                sendMark3 = "1";
                                            }
                                            
                                        }
                                       
                                        updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                        
                                    }


                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯ�쳣������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAbnormalStateNormalInfo_new()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalStateRealTime_TagID,AbnormalStateRealTime_SendMessage,AbnormalStateRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalStateRealTime_TagName,t.AbnormalStateRealTime_Desc,t.AbnormalStateRealTime_State,");
                    alarmSql.Append("t.AbnormalStateRealTime_StartTime,t.AbnormalStateRealTime_SustainTime");
                    alarmSql.Append(" from RTResEx_AbnormalStateRealTime t where t.AbnormalStateRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalStateRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalStateRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalStateRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalStateRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalStateRealTime_State"]);
                            String realValue = "0";
                            String startTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SustainTime"]);
                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalStateConfig_StartTime1,t.AbnormalStateConfig_StartMen1,t.AbnormalStateConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime2,t.AbnormalStateConfig_StartMen2,t.AbnormalStateConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime3,t.AbnormalStateConfig_StartMen3,t.AbnormalStateConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalStateConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                           
                                             updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                          
                                          
                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length) {
                                                sendMark2 = "1";
                                            }
                                          
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark2 = "1";
                                            }
                                            
                                        }
                                        
                                        updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                        

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SmsSendFunc(message, mobile1List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    string[] mobile1List = new string[1];
                                                    mobile1List[0] = mobile1s[i];
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile1List);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length) {
                                                sendMark3 = "1";
                                            }
                                           
                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SmsSendFunc(message, mobile2List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    string[] mobile2List = new string[1];
                                                    mobile2List[0] = mobile2s[i];
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile2List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length) {
                                                sendMark3 = "1";
                                            }
                                           
                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SmsSendFunc(message, mobile3List);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    string[] mobile3List = new string[1];
                                                    mobile3List[0] = mobile3s[i];
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    web.SmsSendFunc(message, mobile3List);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length) {
                                                sendMark3 = "1";
                                            }
                                            
                                        }
                                       
                                         updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                        
                                    }


                                }
                            }

                        }
                    }

                }
            }
        }




        /// <summary>
        /// ���·���������Ϣ�ı��
        /// </summary>
        /// <param name="dao"></param>
        /// <param name="table"></param>
        /// <param name="colName"></param>
        /// <param name="id"></param>
        /// <param name="mark"></param>
        public void updateRealNormalMesMark(IDao dao, String table, string normalColName, String id, String abnormalColName, string confirmColName)
        {
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("update {0} set {1}='1',{2}=null,{3}='δȷ��'", table, normalColName, abnormalColName, confirmColName);
            sql.AppendFormat(" where ID='{0}'", id);
            dao.executeNoQuery(sql.ToString());
        }


        /// <summary>
        /// ��ȡ�豸ָ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="deviceId"></param>
        /// <returns></returns>
        public DeviceIndex getDeviceIndexInfo(String plantId, String deviceId)
        {
            //����ֵ
            DeviceIndex device = new DeviceIndex();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.DeviceRealTime_TagName,t.DeviceRealTime_TagDesc,");
            sql.Append("t.DeviceRealTime_RunIndex,t.DeviceRealTime_AlarmIndex,t.DeviceRealTime_EarlyAlarmIndex");
            sql.AppendFormat(" from RTResEx_DeviceRealTime t where t.DeviceRealTime_TagId='{0}'", deviceId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    device.pkId = BeanTools.ObjectToString(dr["ID"]);
                    device.deviceName = BeanTools.ObjectToString(dr["DeviceRealTime_TagName"]);
                    device.deviceDesc = BeanTools.ObjectToString(dr["DeviceRealTime_TagDesc"]);
                    device.runIndex = BeanTools.ObjectToString(dr["DeviceRealTime_RunIndex"]);
                    device.alarmIndex = BeanTools.ObjectToString(dr["DeviceRealTime_AlarmIndex"]);
                    device.earlyAlarmIndex = BeanTools.ObjectToString(dr["DeviceRealTime_EarlyAlarmIndex"]);
                }
            }
            return device;
        }


        /// <summary>
        /// ��ѯ�豸Ԥ������������
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<TreeNode> queryDeviceConfigTreeNode(string plantId)
        {
            List<TreeNode> treeList = new List<TreeNode>();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT t.ID,t.ProductLine_Code,t.ProductLine_Name,");
            sql.Append("(select count(*) from PSOG_Device p where p.Device_ProductLineID=t.ID) as num");
            sql.Append(" from PSOG_ProductLine t where (t.IsDelete is null or t.IsDelete <> '1') order by t.ID");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TreeNode node = new TreeNode();
                    node.id = BeanTools.ObjectToString(dr["ID"]) + "#" + plantId;
                    node.text = BeanTools.ObjectToString(dr["ProductLine_Name"]);
                    int num = Convert.ToInt32(BeanTools.ObjectToString(dr["num"]));
                    if (num > 0)
                    {
                        node.state = "closed";
                        node.attributes = "1:unit";
                    }
                    else
                    {
                        node.state = "open";
                        node.attributes = "0:unit";
                    }

                    node.iconCls = "sysMan_gztype";
                    treeList.Add(node);
                }
            }
            return treeList;
        }


        /// <summary>
        /// ��ѯ�����õı�����
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData queryHasDeviceAlarmList(string parentId, String tagName, String tagDesc, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.AlarmDeviceConfig_TagName,t.AlarmDeviceConfig_TagDesc,count(1) over() bitCount");
            sql.AppendFormat(" from PSOG_AbnormalAlarmDeviceConfig t where t.AlarmDeviceConfig_DeviceId='{0}'",deviceId);
            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.AlarmDeviceConfig_TagName like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(tagDesc))
            {
                sql.Append(string.Format(" and t.AlarmDeviceConfig_TagDesc like '{0}'", "%" + tagDesc + "%"));
            }
            sql.Append(" order by t.AlarmDeviceConfig_TagName");
           
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["AlarmDeviceConfig_TagName"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["AlarmDeviceConfig_TagDesc"]);
                    grid.rows.Add(bit);
                }
            }

            return grid;
        }


        /// <summary>
        /// ��ѯ�豸��ѡ��ı�����
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryHavingDeviceAlarmList(string parentId, String tagName, String deviceName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Instrumentation_Code,t.Instrumentation_Name,count(1) over() bitCount");
            sql.Append(" from PSOG_Instrumentation t ");
            sql.Append(" where t.Instrumentation_Type=1 and t.IsDelete=0 and  t.ID not in(");
            sql.Append("  select p.AlarmDeviceConfig_TagId from PSOG_AbnormalAlarmDeviceConfig p ");
            sql.AppendFormat(" where p.AlarmDeviceConfig_DeviceId='{0}')", deviceId);

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.Instrumentation_Code like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(deviceName))
            {
                sql.Append(string.Format(" and t.Instrumentation_Name like '{0}'", "%" + deviceName + "%"));
            }
            sql.Append(" order by t.Instrumentation_Code");


            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    grid.rows.Add(bit);
                }
            }
            return grid;
        }



        /// <summary>
        /// ���뵽�豸��������Ϣ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String InsertDeviceAlarm(String parentId, List<BitDevice> list)
        {
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                foreach (BitDevice bit in list)
                {
                    StringBuilder insertSb = new StringBuilder();
                    insertSb.Append("insert into PSOG_AbnormalAlarmDeviceConfig(ID,AlarmDeviceConfig_TagId,AlarmDeviceConfig_TagName,");
                    insertSb.Append("AlarmDeviceConfig_TagDesc,AlarmDeviceConfig_DeviceId) ");
                    insertSb.Append(string.Format(" values('{0}','{1}','{2}','{3}','{4}')", Guid.NewGuid().ToString(),bit.bitId, bit.bitNo, bit.deviceName, deviceId));
                    dao.executeNoQuery(insertSb.ToString());
                }
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ɾ���豸������
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String deleteDeviceAlarm(String parentId, List<Object> list)
        {
            String[] parentInfos = parentId.Split('#');
            String plantId = parentInfos[1];

            //ɾ��
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("delete from PSOG_AbnormalAlarmDeviceConfig where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0,delSql.Length-1)+")";
                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ��ѯ�����õ�Ԥ����
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData queryHasDeviceEarlyAlarmList(string parentId, String tagName, String tagDesc, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.EarlyWarnDeviceConfig_TagName,t.EarlyWarnDeviceConfig_TagDesc,count(1) over() bitCount");
            sql.AppendFormat(" from PSOG_AbnormalEarlyWarnDeviceConfig t where t.EarlyWarnDeviceConfig_DeviceId='{0}'", deviceId);
            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.EarlyWarnDeviceConfig_TagName like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(tagDesc))
            {
                sql.Append(string.Format(" and t.EarlyWarnDeviceConfig_TagDesc like '{0}'", "%" + tagDesc + "%"));
            }
            sql.Append(" order by t.EarlyWarnDeviceConfig_TagName");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["EarlyWarnDeviceConfig_TagName"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["EarlyWarnDeviceConfig_TagDesc"]);
                    grid.rows.Add(bit);
                }
            }

            return grid;
        }



        /// <summary>
        /// ��ѯ�豸��ѡ���Ԥ����
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryHavingDeviceEarlyAlarmList(string parentId, String tagName, String deviceName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Instrumentation_Code,t.Instrumentation_Name,count(1) over() bitCount");
            sql.Append(" from PSOG_Instrumentation t ");
            sql.Append(" where t.Instrumentation_Type=1 and t.IsDelete=0 and t.ID not in(");
            sql.Append("  select p.EarlyWarnDeviceConfig_TagId from PSOG_AbnormalEarlyWarnDeviceConfig p ");
            sql.AppendFormat(" where p.EarlyWarnDeviceConfig_DeviceId='{0}')", deviceId);

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.Instrumentation_Code like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(deviceName))
            {
                sql.Append(string.Format(" and t.Instrumentation_Name like '{0}'", "%" + deviceName + "%"));
            }
            sql.Append(" order by t.Instrumentation_Code");


            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    grid.rows.Add(bit);
                }
            }
            return grid;
        }


        /// <summary>
        /// ���뵽�豸Ԥ������Ϣ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String InsertDeviceEarlyAlarm(String parentId, List<BitDevice> list)
        {
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                foreach (BitDevice bit in list)
                {
                    StringBuilder insertSb = new StringBuilder();
                    insertSb.Append("insert into PSOG_AbnormalEarlyWarnDeviceConfig(ID,EarlyWarnDeviceConfig_TagId,EarlyWarnDeviceConfig_TagName,");
                    insertSb.Append("EarlyWarnDeviceConfig_TagDesc,EarlyWarnDeviceConfig_DeviceId) ");
                    insertSb.Append(string.Format(" values('{0}','{1}','{2}','{3}','{4}')", Guid.NewGuid().ToString(), bit.bitId, bit.bitNo, bit.deviceName, deviceId));
                    dao.executeNoQuery(insertSb.ToString());
                }
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }



        /// <summary>
        /// ɾ���豸Ԥ����
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String deleteDeviceEarlyAlarm(String parentId, List<Object> list)
        {
            String[] parentInfos = parentId.Split('#');
            String plantId = parentInfos[1];

            //ɾ��
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("delete from PSOG_AbnormalEarlyWarnDeviceConfig where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0, delSql.Length - 1) + ")";
                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ��ѯ�����õ��쳣��
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData queryHasDeviceAbnormalList(string parentId, String tagName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.StateDeviceConfig_TagName,count(1) over() bitCount");
            sql.AppendFormat(" from PSOG_AbnormalStateDeviceConfig t where t.StateDeviceConfig_DeviceId='{0}'", deviceId);
            //����
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.StateDeviceConfig_TagName like '{0}'", "%" + tagName + "%"));
            }
            sql.Append(" order by t.StateDeviceConfig_TagId");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["StateDeviceConfig_TagName"]);
                    grid.rows.Add(bit);
                }
            }

            return grid;
        }


        /// <summary>
        /// ��ѯ�豸��ѡ����쳣��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryHavingDeviceAbnormalList(string parentId, String tagName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];
            Plant plant = BeanTools.getPlantDB(plantId);

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.AS_Equipment_ID,t.AS_Equipment_Name,count(1) over() bitCount");
            sql.Append(" from PSOG_AS_Equipment t ");
            sql.Append(" where t.AS_Equipment_ID not in(");
            sql.AppendFormat("  select p.StateDeviceConfig_TagId from {0}.dbo.PSOG_AbnormalStateDeviceConfig p ",plant.historyDB);
            sql.AppendFormat(" where p.StateDeviceConfig_DeviceId='{0}')", deviceId);

            //����
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.AS_Equipment_Name like '{0}'", "%" + tagName + "%"));
            }
            sql.Append(" order by t.AS_Equipment_ID");

            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitId = BeanTools.ObjectToString(dr["AS_Equipment_ID"]);
                    bit.bitNo = BeanTools.ObjectToString(dr["AS_Equipment_Name"]);
                    grid.rows.Add(bit);
                }
            }
            return grid;
        }

        /// <summary>
        /// ���뵽�豸�쳣����Ϣ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String InsertDeviceAbnormal(String parentId, List<BitDevice> list)
        {
            String[] parentInfos = parentId.Split('#');
            String deviceId = parentInfos[0];
            String plantId = parentInfos[1];

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                foreach (BitDevice bit in list)
                {
                    StringBuilder insertSb = new StringBuilder();
                    insertSb.Append("insert into PSOG_AbnormalStateDeviceConfig(ID,StateDeviceConfig_TagId,StateDeviceConfig_TagName,");
                    insertSb.Append("StateDeviceConfig_DeviceId) ");
                    insertSb.Append(string.Format(" values('{0}','{1}','{2}','{3}')", Guid.NewGuid().ToString(), bit.bitId, bit.bitNo, deviceId));
                    dao.executeNoQuery(insertSb.ToString());
                }
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ɾ���豸�쳣��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String deleteDeviceAbnormal(String parentId, List<Object> list)
        {
            String[] parentInfos = parentId.Split('#');
            String plantId = parentInfos[1];

            //ɾ��
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("delete from PSOG_AbnormalStateDeviceConfig where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0, delSql.Length - 1) + ")";
                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ��ѯ����״ָ̬���Ĳ��������ֵ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public String queryPCAModelDict(String plantId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.PCAModel_ID from PSOG_PCAModel t");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());

            List<Dictionary<String, String>> list = new List<Dictionary<string, string>>();
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<String, String> dict = new Dictionary<string, string>();
                    String id = BeanTools.ObjectToString(dr["ID"]);
                    String name = BeanTools.ObjectToString(dr["PCAModel_ID"]);
                    dict.Add("value", id);
                    dict.Add("text", name);
                    list.Add(dict);
                }
            }
            String dictJson = "";
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            dictJson = jsonSerializer.Serialize(list);
            return dictJson;
        }

        /// <summary>
        /// �����豸����ָ������
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="pcaId"></param>
        /// <param name="pcaName"></param>
        /// <returns></returns>
        public string saveRunIndexParamInfo(string parentId,string runId, string pcaId, string pcaName) {
            string[] parentIns = parentId.Split('#');
            string deviceId = parentIns[0];
            string plantId = parentIns[1];

            StringBuilder sql = new StringBuilder();
            if(string.IsNullOrEmpty(runId)){//����
                sql.Append("insert into PSOG_DeviceRunIndexConfig(ID,DeviceRunIndexConfig_DeviceId,");
                sql.Append("DeviceRunIndexConfig_PCAId,DeviceRunIndexConfig_PCAName)");
                sql.AppendFormat(" values('{0}','{1}','{2}','{3}')", Guid.NewGuid().ToString(), deviceId, pcaId, pcaName);
            }else{//�༭
                sql.AppendFormat("update PSOG_DeviceRunIndexConfig set DeviceRunIndexConfig_PCAId='{0}',", pcaId);
                sql.AppendFormat("DeviceRunIndexConfig_PCAName='{0}'", pcaName);
                sql.AppendFormat(" where ID='{0}'", runId);
            }

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e) {
                return "0";
            }
           
        }

        /// <summary>
        /// ��ȡ�豸����״ָ̬���Ĳ�����Ϣ
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public string getRunIndexParamInfo(String parentId) {
            string[] parentIns = parentId.Split('#');
            string deviceId = parentIns[0];
            string plantId = parentIns[1];
            StringBuilder sql = new StringBuilder();
            sql.Append("select ID,t.DeviceRunIndexConfig_PCAId from PSOG_DeviceRunIndexConfig t");
            sql.AppendFormat(" where t.DeviceRunIndexConfig_DeviceId='{0}'",deviceId);

            string paramJson = "";
            Dictionary<string, string> paramDict = new Dictionary<string, string>();
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string id = BeanTools.ObjectToString(dr["ID"]);
                    string pcaId = BeanTools.ObjectToString(dr["DeviceRunIndexConfig_PCAId"]);
                    paramDict.Add("id",id);
                    paramDict.Add("pcaId", pcaId);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            paramJson = jsonSerializer.Serialize(paramDict);
            return paramJson;
        }


        /// <summary>
        /// ��ѯ�豸��ص�Ԥ������
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData queryDeviceAlarmList(string plantId, string deviceId)
        {
            EasyUIData grid = new EasyUIData();

            Plant plant = BeanTools.getPlantDB(plantId);
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT t.ID,");
            sql.Append("       t.AlarmDeviceConfig_TagName AS tagName,");
            sql.Append("       r.RTResEx_AlarmRealTime_Value AS realValue,");
            sql.Append("       '����' AS status");
            sql.Append("  FROM PSOG_AbnormalAlarmDeviceConfig t");
            sql.AppendFormat("  LEFT JOIN {0}.dbo.RTResEx_AlarmRealTime r",plant.realTimeDB);
            sql.Append("    ON t.AlarmDeviceConfig_TagName = r.RTResEx_AlarmRealTime_Items");
            sql.AppendFormat(" WHERE t.AlarmDeviceConfig_DeviceId = '{0}'",deviceId);
            sql.Append(" UNION ALL ");
            sql.Append("SELECT et.ID,");
            sql.Append("       et.EarlyWarnDeviceConfig_TagName,");
            sql.Append("       ert.RTResEx_AlarmRealTime_Value AS realValue,");
            sql.Append("       'Ԥ��' AS status");
            sql.Append("  FROM PSOG_AbnormalEarlyWarnDeviceConfig et");
            sql.AppendFormat("  LEFT JOIN {0}.dbo.RTResEx_AlarmRealTime ert",plant.realTimeDB);
            sql.Append("    ON et.EarlyWarnDeviceConfig_TagName = ert.RTResEx_AlarmRealTime_Items");
            sql.AppendFormat(" WHERE et.EarlyWarnDeviceConfig_DeviceId = '{0}'",deviceId);

            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAlarmInfo alarm = new HomeAlarmInfo();
                    alarm.alarmId = BeanTools.ObjectToString(dr["ID"]);
                    alarm.alarmBitNo = BeanTools.ObjectToString(dr["tagName"]);
                    alarm.alarmRealValue = BeanTools.ObjectToString(dr["realValue"]);
                    alarm.alarmStatus = BeanTools.ObjectToString(dr["status"]);
                    grid.rows.Add(alarm);
                }
            }

            return grid;
        }

        /// <summary>
        /// ����豸��ص��쳣��Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="deviceId"></param>
        /// <returns></returns>
        public String getDeviceAbnormalJson(String plantId, String deviceId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.StateDeviceConfig_TagId,t.StateDeviceConfig_TagName ");
            sql.AppendFormat("  from PSOG_AbnormalStateDeviceConfig t where t.StateDeviceConfig_DeviceId='{0}'", deviceId);

            List<HomeAbStateInfo> list = new List<HomeAbStateInfo>();
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAbStateInfo abnormal = new HomeAbStateInfo();
                    abnormal.abStateId = BeanTools.ObjectToString(dr["StateDeviceConfig_TagId"]);
                    abnormal.abStateName = BeanTools.ObjectToString(dr["StateDeviceConfig_TagName"]);
                    list.Add(abnormal);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            return jsonSerializer.Serialize(list);
        }

        /// <summary>
        /// ��ȡ�豸����״ָ̬���Ĳ���ID
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="deviceId"></param>
        /// <returns></returns>
        public string getDeviceRunIndexId(string plantId,string deviceId) {
            String runIndexId = "";
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.DeviceRunIndexConfig_PCAId from PSOG_DeviceRunIndexConfig t ");
            sql.AppendFormat(" where t.DeviceRunIndexConfig_DeviceId = '{0}'",deviceId);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    runIndexId = BeanTools.ObjectToString(dr["DeviceRunIndexConfig_PCAId"]);
                }
            }
            return runIndexId;
        }


        /// <summary>
        /// ��ѯ�������ʵʱ�б�
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmRealTimeList(string plantId, String tagName, String typeName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
       
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT tt.*, r.RTData_fRTVal,count(1) over() recordCount");
            sql.Append(" FROM ");
            sql.Append("	(");
            sql.Append("		SELECT");
            sql.Append("			t.ID,");
            sql.Append("			t.AbnormalRealTime_TagID,");
            sql.Append("			t.AbnormalRealTime_TagName,");
            sql.Append("			t.AbnormalRealTime_Desc,");
            sql.Append("			t.AbnormalRealTime_State,");
            sql.Append("			t.AbnormalRealTime_Type,");
            sql.Append("			t.AbnormalRealTime_StartTime,");
            sql.Append("			t.AbnormalRealTime_SustainTime,");
            sql.Append("			'1' AS num");
            sql.Append("		FROM");
            sql.Append("			RTResEx_AbnormalRealTime t");
            sql.Append("		WHERE");
            sql.Append("			t.AbnormalRealTime_State <> '����'");
            sql.Append("		AND t.AbnormalRealTime_State <> '�����쳣'");
            sql.Append("		UNION ALL");
            sql.Append("			SELECT");
            sql.Append("				t.ID,");
            sql.Append("				t.AbnormalRealTime_TagID,");
            sql.Append("				t.AbnormalRealTime_TagName,");
            sql.Append("				t.AbnormalRealTime_Desc,");
            sql.Append("				t.AbnormalRealTime_State,");
            sql.Append("				t.AbnormalRealTime_Type,");
            sql.Append("				t.AbnormalRealTime_StartTime,");
            sql.Append("				t.AbnormalRealTime_SustainTime,");
            sql.Append("				'2' AS num");
            sql.Append("			FROM");
            sql.Append("				RTResEx_AbnormalRealTime t");
            sql.Append("			WHERE");
            sql.Append("				t.AbnormalRealTime_State = '����'");
            sql.Append("			OR t.AbnormalRealTime_State = '�����쳣'");
            sql.Append("	) tt");
            sql.Append(" INNER JOIN RTResEx_RTData r ON tt.AbnormalRealTime_TagName = r.TagName");
            sql.Append(" where tt.ID is not null");

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.AppendFormat(" and tt.AbnormalRealTime_TagName like '{0}'", "%" + tagName+"%");
            }
            //����
            if (!string.IsNullOrEmpty(typeName)) {
                sql.AppendFormat(" and tt.AbnormalRealTime_Type = '{0}'", typeName);
            }
            sql.Append(" ORDER BY tt.num,tt.AbnormalRealTime_TagName");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAlarmInfo hn = new HomeAlarmInfo();
                    hn.alarmId = dr["ID"].ToString();
                    hn.alarmRuleId = dr["AbnormalRealTime_TagID"].ToString();
                    hn.alarmBitNo = dr["AbnormalRealTime_TagName"].ToString();
                    hn.alarmTagDesc = dr["AbnormalRealTime_Desc"].ToString();
                    hn.alarmRealValue = dr["RTData_fRTVal"].ToString();
                    hn.alarmStatus = dr["AbnormalRealTime_State"].ToString();
                    hn.alarmType = dr["AbnormalRealTime_Type"].ToString();
                    hn.alarmSustainTime = dr["AbnormalRealTime_SustainTime"].ToString();
                    hn.alarmStartTime = dr["AbnormalRealTime_StartTime"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ѯԤ�����ʵʱ�б�
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryEarlyAlarmRealTimeList(string plantId, String tagName, String typeName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("WITH tab AS (");
            sql.Append("	SELECT");
            sql.Append("		t.AbnormalEarlyRealTime_TagID,");
            sql.Append("		MIN (");
            sql.Append("			t.AbnormalEarlyRealTime_StartTime");
            sql.Append("		) AS stTime,");
            sql.Append("		'1' AS num,");
            sql.Append("		'Ԥ��' AS status");
            sql.Append("	FROM");
            sql.Append("		RTResEx_AbnormalEarlyRealTime t");
            sql.Append("	WHERE");
            sql.Append("		t.AbnormalEarlyRealTime_State <> '����'");
            sql.Append("	AND t.AbnormalEarlyRealTime_State <> '�����쳣'");
            sql.Append("	GROUP BY");
            sql.Append("		t.AbnormalEarlyRealTime_TagID");
            sql.Append("),");
            sql.Append(" tab2 AS (");
            sql.Append("	SELECT");
            sql.Append("		t.AbnormalEarlyRealTime_TagID,");
            sql.Append("		MIN (");
            sql.Append("			t.AbnormalEarlyRealTime_StartTime");
            sql.Append("		) AS stTime,");
            sql.Append("		'2' AS num,");
            sql.Append("		'�����쳣' AS status");
            sql.Append("	FROM");
            sql.Append("		RTResEx_AbnormalEarlyRealTime t");
            sql.Append("	LEFT JOIN tab ON t.AbnormalEarlyRealTime_TagID = tab.AbnormalEarlyRealTime_TagID");
            sql.Append("	WHERE t.AbnormalEarlyRealTime_State = '�����쳣'");
            sql.Append("	  AND tab.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("	GROUP BY t.AbnormalEarlyRealTime_TagID");
            sql.Append(") SELECT");
            sql.AppendFormat("	TOP {0} tt.*",pageSize);
            sql.Append(" FROM ");
            sql.Append("	(");
            sql.Append("		SELECT");
            sql.Append("			r.ID,");
            sql.Append("			r.AbnormalEarlyRealTime_TagID,");
            sql.Append("			r.AbnormalEarlyRealTime_TagName,");
            sql.Append("			r.AbnormalEarlyRealTime_Desc,");
            sql.Append("			st.RTData_fRTVal,");
            sql.Append("			tt.status,");
            sql.Append("			r.AbnormalEarlyRealTime_Type,");
            sql.Append("			r.AbnormalEarlyRealTime_SustainTime,");
            sql.Append("			r.AbnormalEarlyRealTime_StartTime,");
            sql.Append("			COUNT (1) OVER () recordCount,");
            sql.Append("			row_number () OVER (");
            sql.Append("				ORDER BY");
            sql.Append("					tt.num,");
            sql.Append("					r.AbnormalEarlyRealTime_TagName");
            sql.Append("			) rownum");
            sql.Append("		FROM");
            sql.Append("			RTResEx_AbnormalEarlyRealTime r");
            sql.Append("		INNER JOIN (");
            sql.Append("			SELECT");
            sql.Append("				*");
            sql.Append("			FROM");
            sql.Append("				tab");
            sql.Append("			UNION ALL");
            sql.Append("				SELECT");
            sql.Append("					*");
            sql.Append("				FROM");
            sql.Append("					tab2");
            sql.Append("				UNION ALL");
            sql.Append("					SELECT");
            sql.Append("						t.AbnormalEarlyRealTime_TagID,");
            sql.Append("						MIN (");
            sql.Append("							t.AbnormalEarlyRealTime_StartTime");
            sql.Append("						) AS stTime,");
            sql.Append("						'3' AS num,");
            sql.Append("						'����' AS status");
            sql.Append("					FROM");
            sql.Append("						RTResEx_AbnormalEarlyRealTime t");
            sql.Append("					LEFT JOIN tab ON t.AbnormalEarlyRealTime_TagID = tab.AbnormalEarlyRealTime_TagID");
            sql.Append("					LEFT JOIN tab2 ON t.AbnormalEarlyRealTime_TagID = tab2.AbnormalEarlyRealTime_TagID");
            sql.Append("					WHERE");
            sql.Append("						t.AbnormalEarlyRealTime_State = '����'");
            sql.Append("					AND tab.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("					AND tab2.AbnormalEarlyRealTime_TagID IS NULL");
            sql.Append("					GROUP BY");
            sql.Append("						t.AbnormalEarlyRealTime_TagID");
            sql.Append("		) tt ON r.AbnormalEarlyRealTime_TagID = tt.AbnormalEarlyRealTime_TagID");
            sql.Append("		AND r.AbnormalEarlyRealTime_StartTime = tt.stTime");
            sql.Append("		INNER JOIN RTResEx_RTData st ON r.AbnormalEarlyRealTime_TagName = st.TagName");
            sql.Append("		WHERE r.ID IS NOT NULL");

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.AppendFormat(" and r.AbnormalEarlyRealTime_TagName like '{0}'", "%" + tagName + "%");
            }
            //����
            if (!string.IsNullOrEmpty(typeName))
            {
                sql.AppendFormat(" and r.AbnormalEarlyRealTime_Type = '{0}'", typeName);
            }
            sql.Append("	) tt");
            sql.AppendFormat(" WHERE tt.rownum > {0}",(pageNo-1)*pageSize);


            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeEarlyAlarmInfo hn = new HomeEarlyAlarmInfo();
                    hn.earlyAlarmId = dr["ID"].ToString();
                    hn.earlyAlarmRuleId = dr["AbnormalEarlyRealTime_TagID"].ToString();
                    hn.earlyAlarmBitNo = dr["AbnormalEarlyRealTime_TagName"].ToString();
                    hn.earlyAlarmTagDesc = dr["AbnormalEarlyRealTime_Desc"].ToString();
                    hn.earlyAlarmRealValue = dr["RTData_fRTVal"].ToString();
                    hn.earlyAlarmStatus = dr["status"].ToString();
                    hn.earlyAlarmType = dr["AbnormalEarlyRealTime_Type"].ToString();
                    hn.earlyAlarmSustainTime = dr["AbnormalEarlyRealTime_SustainTime"].ToString();
                    hn.earlyAlarmStartTime = dr["AbnormalEarlyRealTime_StartTime"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ѯ�쳣���ʵʱ�б�
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryAbnormalRealTimeList(string plantId, String tagName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select tt.*,count(1) over() recordCount from ");
            sql.Append(" (SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AbnormalStateRealTime_TagID,");
            sql.Append("	t.AbnormalStateRealTime_TagName,");
            sql.Append("	t.AbnormalStateRealTime_Desc,");
            sql.Append("	t.AbnormalStateRealTime_State,");
            sql.Append("	t.AbnormalStateRealTime_Unit,");
            sql.Append("	t.AbnormalStateRealTime_Meter,");
            sql.Append("	t.AbnormalStateRealTime_StartTime,");
            sql.Append("	t.AbnormalStateRealTime_SustainTime,");
            sql.Append("    '1' as num");
            sql.Append(" FROM RTResEx_AbnormalStateRealTime t ");
            sql.Append(" WHERE t.AbnormalStateRealTime_State <> '����'");
            sql.Append("   AND t.AbnormalStateRealTime_State <> '�����쳣'");
            sql.Append(" union ALL ");
            sql.Append("SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AbnormalStateRealTime_TagID,");
            sql.Append("	t.AbnormalStateRealTime_TagName,");
            sql.Append("	t.AbnormalStateRealTime_Desc,");
            sql.Append("	t.AbnormalStateRealTime_State,");
            sql.Append("	t.AbnormalStateRealTime_Unit,");
            sql.Append("	t.AbnormalStateRealTime_Meter,");
            sql.Append("	t.AbnormalStateRealTime_StartTime,");
            sql.Append("	t.AbnormalStateRealTime_SustainTime,");
            sql.Append("    '2' as num");
            sql.Append(" FROM RTResEx_AbnormalStateRealTime t");
            sql.Append(" WHERE t.AbnormalStateRealTime_State = '����'");
            sql.Append("  or t.AbnormalStateRealTime_State = '�����쳣') tt");
            
            sql.Append(" where tt.ID is not null");

            //����
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.AppendFormat(" and tt.AbnormalStateRealTime_TagName like '{0}'", "%" + tagName + "%");
            }
            sql.Append(" ORDER BY tt.num,tt.AbnormalStateRealTime_TagName");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HomeAbStateInfo hn = new HomeAbStateInfo();
                    hn.abStateId = dr["ID"].ToString();
                    hn.abStateRuleId = dr["AbnormalStateRealTime_TagID"].ToString();
                    hn.abStateName = dr["AbnormalStateRealTime_TagName"].ToString();
                    hn.abStateDesc = dr["AbnormalStateRealTime_Desc"].ToString();
                    hn.abStateStatus = dr["AbnormalStateRealTime_State"].ToString();
                    hn.abStateUnit = dr["AbnormalStateRealTime_Unit"].ToString();
                    hn.abStateMeter = dr["AbnormalStateRealTime_Meter"].ToString();
                    hn.abStateSustainTime = dr["AbnormalStateRealTime_SustainTime"].ToString();
                    hn.abStateStartTime = dr["AbnormalStateRealTime_StartTime"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }


       /// <summary>
        /// ��ѯװ���µĹ���
       /// </summary>
       /// <param name="plantId"></param>
       /// <param name="tagName"></param>
       /// <param name="tagDesc"></param>
       /// <param name="pageNo"></param>
       /// <param name="pageSize"></param>
       /// <returns></returns>
        public EasyUIData querySectionList(string plantId, String tagName, String tagDesc, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.ProductLine_Code,t.ProductLine_Name,count(1) over() recordCount");
            sql.Append("  from PSOG_ProductLine t where (t.IsDelete<>'1' or t.IsDelete is null)");
            //����
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.ProductLine_Code like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(tagDesc))
            {
                sql.Append(string.Format(" and t.ProductLine_Name like '{0}'", "%" + tagDesc + "%"));
            }
            sql.Append(" order by t.ID");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    SectionDevice section = new SectionDevice();
                    section.sectionId = BeanTools.ObjectToString(dr["ID"]);
                    section.sectionName = BeanTools.ObjectToString(dr["ProductLine_Code"]);
                    section.sectionDesc = BeanTools.ObjectToString(dr["ProductLine_Name"]);
                    grid.rows.Add(section);
                }
            }

            return grid;
        }

        /// <summary>
        /// ��ѯ�����µ��豸
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="tagName"></param>
        /// <param name="tagDesc"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData querySectionDeviceList(string parentId, String tagName, String tagDesc, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            string[] parentIns = parentId.Split('#');
            string sectionId = parentIns[0];
            string plantId = parentIns[1];

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Device_Code,t.Device_Name,count(1) over() recordCount");
            sql.AppendFormat("  from PSOG_Device t where t.Device_ProductLineID='{0}'", sectionId);
            sql.Append(" and (t.IsDelete<>'1' or t.IsDelete is null)");
            //����
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.Device_Code like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(tagDesc))
            {
                sql.Append(string.Format(" and t.Device_Name like '{0}'", "%" + tagDesc + "%"));
            }
            sql.Append(" order by t.ID");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    SectionDevice section = new SectionDevice();
                    section.sectionId = BeanTools.ObjectToString(dr["ID"]);
                    section.sectionName = BeanTools.ObjectToString(dr["Device_Code"]);
                    section.sectionDesc = BeanTools.ObjectToString(dr["Device_Name"]);
                    grid.rows.Add(section);
                }
            }
            return grid;
        }

        /// <summary>
        /// ���湤����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="sectionId"></param>
        /// <param name="sectionName"></param>
        /// <param name="sectionDesc"></param>
        /// <param name="sectionMark"></param>
        /// <returns></returns>
        public String saveSectionInfo(string plantId,string sectionId,string sectionName,string sectionDesc,string sectionMark)
        {
            StringBuilder sql = new StringBuilder();
            string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
            if (String.IsNullOrEmpty(sectionId))
            { //����
                sql.Append("INSERT INTO PSOG_ProductLine(ProductLine_Code,ProductLine_Name,ProductLine_Remark,");
                sql.Append("ProductLine_EditDate,IsDelete)");
                sql.Append(string.Format(" values('{0}','{1}','{2}','{3}',{4})", sectionName, sectionDesc, sectionMark, nowDate,0));
            }
            else
            { //�޸�
                sql.Append("update PSOG_ProductLine set ");
                sql.AppendFormat(" ProductLine_Code='{0}',ProductLine_Name='{1}',ProductLine_Remark='{2}',ProductLine_EditDate='{3}'", sectionName, sectionDesc, sectionMark, nowDate);
                sql.AppendFormat(" where ID='{0}'", sectionId);
            }


            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


        /// <summary>
        /// ���湤���豸��Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="sectionId"></param>
        /// <param name="sectionName"></param>
        /// <param name="sectionDesc"></param>
        /// <param name="sectionMark"></param>
        /// <returns></returns>
        public String saveSectionEquipInfo(string parentId, string deviceId, string deviceName, string deviceDesc, string deviceMark)
        {
            string[] parentIns = parentId.Split('#');
            string sectionId = parentIns[0];
            string plantId = parentIns[1];

            StringBuilder sql = new StringBuilder();
            string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
            if (String.IsNullOrEmpty(deviceId))
            { //����
                sql.Append("INSERT INTO PSOG_Device(Device_Code,Device_Name,Device_Remark,");
                sql.Append("Device_EditDate,IsDelete,Device_ProductLineID)");
                sql.Append(string.Format(" values('{0}','{1}','{2}','{3}',{4},{5})", deviceName, deviceDesc, deviceMark, nowDate, 0, Convert.ToInt32(sectionId)));
            }
            else
            { //�޸�
                sql.Append("update PSOG_Device set ");
                sql.AppendFormat(" Device_Code='{0}',Device_Name='{1}',Device_Remark='{2}',Device_EditDate='{3}'", deviceName, deviceDesc, deviceMark, nowDate);
                sql.AppendFormat(" where ID='{0}'", deviceId);
            }


            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ɾ�����μ�¼
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="sectionIds"></param>
        /// <returns></returns>
        public string delSection(string plantId, List<Object> list)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                //��ɾ������
                StringBuilder sql = new StringBuilder();
                sql.Append("update PSOG_ProductLine set IsDelete='1' where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0, delSql.Length - 1) + ")";
                dao.executeNoQuery(delSql);

                //�ټ���ɾ�������µ��豸
                StringBuilder equipSql = new StringBuilder();
                equipSql.Append("update PSOG_Device set IsDelete='1' where Device_ProductLineID in(");
                foreach (Object obj in list)
                {
                    equipSql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delEquipSql = equipSql.ToString();
                delEquipSql = delEquipSql.Substring(0, delEquipSql.Length - 1) + ")";
                dao.executeNoQuery(delEquipSql);

                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ɾ�������µ��豸
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="sectionIds"></param>
        /// <returns></returns>
        public string delSectionEquip(string parentId, List<Object> list) {
            string[] parentIns = parentId.Split('#');
            string deviceId = parentIns[0];
            string plantId = parentIns[1];

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("update PSOG_Device set IsDelete='1' where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append("'").Append(obj.ToString()).Append("',");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0, delSql.Length - 1) + ")";
                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ���ӽ�ɫ��������Ȩ��
        /// </summary>
        /// <param name="rule"></param>
        /// <param name="roleCode"></param>
        /// <returns></returns>
        public string addRoleRule(string rule, string roleCode)
        {
            string message = CommonStr.add_fail;
            try
            {
                IDao dao = new Dao();

                lock (lockObj)
                {
                    IList sqlList = new ArrayList();

                    //ɾ��ԭ��ɫ��Ӧ�Ĺ���
                    String delSql = string.Format("delete from PSOGSYS_Permission_Role_Rule where Role_Code ='{0}'", roleCode);
                    sqlList.Add(delSql);
                    //���
                    if (rule.Length > 0)
                    {
                        StringBuilder addSql = new StringBuilder();
                        addSql.AppendFormat("insert into PSOGSYS_Permission_Role_Rule(ID,Role_Code,Alarm_Rule) values(newid(),'{0}','{1}')", roleCode, rule);
                        sqlList.Add(addSql.ToString());
                    }

                    dao.executeNoQuery(sqlList);

                    return "1";
                }
            } catch (Exception e) {
                return "0";
            } 
        }

        /// <summary>
        /// ��ȡ��ɫ��Ӧ�ı�������Ȩ��
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public string getRoleRuleInfo(string roleId) {
            String alarmRule = "";
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("select Alarm_Rule from PSOGSYS_Permission_Role_Rule where Role_Code='{0}'", roleId);
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    alarmRule = BeanTools.ObjectToString(dr["Alarm_Rule"]);
                }
            }
            return alarmRule;
        }

        /// <summary>
        /// �жϵ�ǰ�û��Ƿ���б༭���������Ȩ��
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="ruleCode"></param>
        /// <returns></returns>
        public string isHasEditRule(string userId,string ruleCode) {
            string isHasEdit = "0";
            StringBuilder sql = new StringBuilder();
            sql.Append("select u.SYS_ROLE_CODE,r.Alarm_Rule from PSOGSYS_Permission_User_Role u ");
            sql.Append(" left join PSOGSYS_Permission_Role_Rule r ");
            sql.Append("  on u.SYS_ROLE_CODE=r.Role_Code");
            sql.AppendFormat(" where u.SYS_USER_ID='{0}'", userId);
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string roleCode = BeanTools.ObjectToString(dr["SYS_ROLE_CODE"]);
                    string rule = BeanTools.ObjectToString(dr["Alarm_Rule"]);
                    if ("ROOT".ToUpper().Equals(roleCode.ToUpper())) {
                        isHasEdit = "1";
                    }
                    else if (rule.IndexOf(ruleCode) > -1)
                    {
                        isHasEdit = "1";
                    }
                }
            }
            return isHasEdit;
        }


        /// <summary>
        /// ��ѯװ���µı������б�
        /// </summary>
        /// <param name="parentMenuCode"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmLimitList(string plantId, String tagName, String deviceName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
            
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,");
            sql.Append("       t.Instrumentation_Code,");
            sql.Append("       t.Instrumentation_DCSCode,");
            sql.Append("       t.Instrumentation_Name,");
            sql.Append("       t.Instrumentation_Unit,");
            sql.Append("       t.Instrumentation_Type,");
            sql.Append("       t.Instrumentation_LineID,");
            sql.Append(" (select p.ProductLine_Name from PSOG_ProductLine p where p.ID=t.Instrumentation_LineID) as lineName,");
            sql.Append("       t.Instrumentation_DeviceID,");
            sql.Append(" (select d.Device_Code from PSOG_Device d where d.ID=t.Instrumentation_DeviceID) as deviceName,");
            sql.Append("       t.Instrumentation_UpLine,");
            sql.Append("       t.Instrumentation_DownLine,");
            sql.Append("       t.Instrumentation_HHigh,");
            sql.Append("       t.Instrumentation_High,");
            sql.Append("       t.Instrumentation_Low,");
            sql.Append("       t.Instrumentation_LLow,");
            sql.Append("       t.Instrumentation_EditDate,");
            sql.Append("       t.Instrumentation_Remark,");
            sql.Append("       count(1) over() bitCount");
            sql.Append("  from PSOG_Instrumentation t");
            sql.Append(" where (t.IsDelete = '0' or t.IsDelete is null)");
            //λ��
            if (!string.IsNullOrEmpty(tagName)) {
                sql.AppendFormat(" and t.Instrumentation_Code like '{0}'","%"+tagName+"%");
            }
            //����
            if (!string.IsNullOrEmpty(deviceName))
            {
                sql.AppendFormat(" and t.Instrumentation_Name like '{0}'", "%" + deviceName + "%");
            }

            sql.Append(" order by t.Instrumentation_Code");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmLimit limit = new AlarmLimit();
                    limit.limitId = BeanTools.ObjectToString(dr["ID"]);
                    limit.limitBitCode = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    limit.limitDCSCode = BeanTools.ObjectToString(dr["Instrumentation_DCSCode"]);
                    limit.limitBitName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    limit.limitUnit = BeanTools.ObjectToString(dr["Instrumentation_Unit"]);
                    limit.limitType = BeanTools.ObjectToString(dr["Instrumentation_Type"]);
                    limit.limitLineId = BeanTools.ObjectToString(dr["Instrumentation_LineID"]);
                    limit.limitLineName = BeanTools.ObjectToString(dr["lineName"]);
                    limit.limitDeviceId = BeanTools.ObjectToString(dr["Instrumentation_DeviceID"]);
                    limit.limitDeviceName = BeanTools.ObjectToString(dr["deviceName"]);
                    limit.limitUpLine = BeanTools.ObjectToString(dr["Instrumentation_UpLine"]);
                    limit.limitDownLine = BeanTools.ObjectToString(dr["Instrumentation_DownLine"]);
                    limit.limitHHigh = BeanTools.ObjectToString(dr["Instrumentation_HHigh"]);
                    limit.limitHigh = BeanTools.ObjectToString(dr["Instrumentation_High"]);
                    limit.limitLow = BeanTools.ObjectToString(dr["Instrumentation_Low"]);
                    limit.limitLLow = BeanTools.ObjectToString(dr["Instrumentation_LLow"]);
                    limit.limitEditDate = BeanTools.ObjectToString(dr["Instrumentation_EditDate"]);
                    limit.limitRemark = BeanTools.ObjectToString(dr["Instrumentation_Remark"]);
                    grid.rows.Add(limit);
                }
            }

            return grid;
        }

        /// <summary>
        /// ��ȡ���������ֵ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<Dictionary<string, string>> getGridLineDict(string plantId) {
            List<Dictionary<string, string>> list = new List<Dictionary<string, string>>();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.ProductLine_Name from PSOG_ProductLine t ");
            sql.Append(" where (t.IsDelete = '0' or t.IsDelete is null)");
            sql.Append(" order by t.ID");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>();
                    string id = BeanTools.ObjectToString(dr["ID"]);
                    string name = BeanTools.ObjectToString(dr["ProductLine_Name"]);
                    dict.Add("value",id);
                    dict.Add("text", name);
                    list.Add(dict);
                }
            }
            return list;
        }

        /// <summary>
        /// ��ѯ�豸�����ֵ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<Dictionary<string, string>> getGridDeviceDict(string plantId,string lineId) {
            List<Dictionary<string, string>> list = new List<Dictionary<string, string>>();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Device_Code from PSOG_Device t");
            sql.AppendFormat(" where t.Device_ProductLineID='{0}'",lineId);
            sql.Append(" and (t.IsDelete = '0' or t.IsDelete is null)");
            sql.Append(" order by t.Device_Code");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>();
                    string id = BeanTools.ObjectToString(dr["ID"]);
                    string name = BeanTools.ObjectToString(dr["Device_Code"]);
                    dict.Add("value", id);
                    dict.Add("text", name);
                    list.Add(dict);
                }
            }
            return list;
        }

        /// <summary>
        /// У��λ���Ƿ��Ѿ�����
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitCode"></param>
        /// <returns></returns>
        public string checkBitCodeIsExist(string plantId, string bitCode) {
            string isExist = "0";//1�����ڣ�0��������
            StringBuilder sql = new StringBuilder();
            sql.Append("select count(*) as num from PSOG_Instrumentation t");
            sql.AppendFormat(" where t.Instrumentation_Code='{0}'", bitCode);
            sql.Append(" and (t.IsDelete = '0' or t.IsDelete is null)");
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    int num = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["num"]);
                    if (num > 0) {
                        isExist = "1";
                    }
                }
            }
            return isExist;
        }

        /// <summary>
        /// ���汨������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="limitId"></param>
        /// <param name="limitBitCode"></param>
        /// <param name="limitDCSCode"></param>
        /// <param name="limitBitName"></param>
        /// <param name="limitUnit"></param>
        /// <param name="limitType"></param>
        /// <param name="limitLineId"></param>
        /// <param name="limitDeviceId"></param>
        /// <param name="limitUpLine"></param>
        /// <param name="limitDownLine"></param>
        /// <param name="limitHHigh"></param>
        /// <param name="limitHigh"></param>
        /// <param name="limitLLow"></param>
        /// <param name="limitLow"></param>
        /// <param name="limitRemark"></param>
        /// <returns></returns>
        public String saveAlarmLimitInfo(string plantId, String limitId, String limitBitCode, String limitDCSCode, String limitBitName,
                                    String limitUnit, String limitType, String limitLineId, String limitDeviceId, String limitUpLine,
                                    String limitDownLine, String limitHHigh, String limitHigh, string limitLLow, string limitLow, string limitRemark)
        {
            StringBuilder sql = new StringBuilder();
            string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
            if (string.IsNullOrEmpty(limitId))
            {
                sql.Append("insert into PSOG_Instrumentation(Instrumentation_Code,Instrumentation_DCSCode,Instrumentation_Name,");
                sql.Append("Instrumentation_Unit,Instrumentation_Type,Instrumentation_LineID,Instrumentation_DeviceID,");
                sql.Append("Instrumentation_UpLine,Instrumentation_DownLine,Instrumentation_HHigh,Instrumentation_High,");
                sql.Append("Instrumentation_Low,Instrumentation_LLow,Instrumentation_EditDate,Instrumentation_Remark,IsDelete)");
                sql.AppendFormat(" values('{0}','{1}','{2}','{3}',", limitBitCode, limitDCSCode, limitBitName, limitUnit);
                //�Ǳ�����
                if (string.IsNullOrEmpty(limitType))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitType);
                }
                //��������
                if (string.IsNullOrEmpty(limitLineId))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitLineId);
                }
                //�����豸
                if (string.IsNullOrEmpty(limitDeviceId))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitDeviceId);
                }
                //��������
                if (string.IsNullOrEmpty(limitUpLine))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitUpLine);
                }
                //��������
                if (string.IsNullOrEmpty(limitDownLine))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitDownLine);
                }
                //DCS�߸߱�
                if (string.IsNullOrEmpty(limitHHigh))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitHHigh);
                }
                //DCS�߱�
                if (string.IsNullOrEmpty(limitHigh))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitHigh);
                }
                //DCS�ͱ�
                if (string.IsNullOrEmpty(limitLow))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitLow);
                }
                //DCS�͵ͱ�
                if (string.IsNullOrEmpty(limitLLow))
                {
                    sql.Append("null,");
                }
                else
                {
                    sql.AppendFormat("{0},", limitLLow);
                }
                sql.AppendFormat("'{0}','{1}',0)", nowDate, limitRemark);
            }
            else {
                sql.AppendFormat("update PSOG_Instrumentation set Instrumentation_Code='{0}',Instrumentation_DCSCode='{1}',", limitBitCode, limitDCSCode);
                sql.AppendFormat("Instrumentation_Name='{0}',Instrumentation_Unit='{1}',", limitBitName, limitUnit);
                //�Ǳ�����
                if (string.IsNullOrEmpty(limitType))
                {
                    sql.Append("Instrumentation_Type=null,");
                }
                else {
                    sql.AppendFormat("Instrumentation_Type={0},", limitType);
                }
                //��������
                if (string.IsNullOrEmpty(limitLineId))
                {
                    sql.Append("Instrumentation_LineID=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_LineID={0},", limitLineId);
                }
                //�����豸
                if (string.IsNullOrEmpty(limitDeviceId))
                {
                    sql.Append("Instrumentation_DeviceID=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_DeviceID={0},", limitDeviceId);
                }
                //��������
                if (string.IsNullOrEmpty(limitUpLine))
                {
                    sql.Append("Instrumentation_UpLine=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_UpLine={0},", limitUpLine);
                }
                //��������
                if (string.IsNullOrEmpty(limitDownLine))
                {
                    sql.Append("Instrumentation_DownLine=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_DownLine={0},", limitDownLine);
                }
                //DCS�߸߱�
                if (string.IsNullOrEmpty(limitHHigh))
                {
                    sql.Append("Instrumentation_HHigh=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_HHigh={0},", limitHHigh);
                }
                //DCS�߱�
                if (string.IsNullOrEmpty(limitHigh))
                {
                    sql.Append("Instrumentation_High=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_High={0},", limitHigh);
                }
                //DCS�͵ͱ�
                if (string.IsNullOrEmpty(limitLLow))
                {
                    sql.Append("Instrumentation_LLow=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_LLow={0},", limitLLow);
                }
                //DCS�ͱ�
                if (string.IsNullOrEmpty(limitLow))
                {
                    sql.Append("Instrumentation_Low=null,");
                }
                else
                {
                    sql.AppendFormat("Instrumentation_Low={0},", limitLow);
                }
                sql.AppendFormat("Instrumentation_EditDate='{0}',Instrumentation_Remark='{1}'", nowDate, limitRemark);
                sql.AppendFormat(" where ID={0}", limitId);
            }
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }

        }

        /// <summary>
        /// ɾ��������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String deleteAlarmLimitInfo(String plantId, List<Object> list)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("update PSOG_Instrumentation set IsDelete='1' where ID in(");
                foreach (Object obj in list)
                {
                    sql.Append(obj.ToString()).Append(",");
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0,delSql.Length-1)+")";

                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }


       /// <summary>
       /// ��ѯ���ղ���̨��
       /// </summary>
       /// <param name="plantId"></param>
       /// <param name="paramName"></param>
       /// <param name="paramBitCode"></param>
       /// <param name="pageNo"></param>
       /// <param name="pageSize"></param>
       /// <returns></returns>
        public EasyUIData queryCraftParamList(string plantId, String paramName, String paramBitCode, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Instrumentation_ParamRank,t.Instrumentation_Name,");
            sql.Append("t.Instrumentation_Code,t.Instrumentation_UpLine,t.Instrumentation_DownLine,t.Instrumentation_Unit,");
            sql.Append("t.Instrumentation_HHigh,t.Instrumentation_High,t.Instrumentation_LLow,");
            sql.Append("t.Instrumentation_Low,t.Instrumentation_Remark,count(1) over() recordCount");
            sql.Append(" from PSOG_Instrumentation t where (t.IsDelete='0' or t.IsDelete is null)");

            //λ��
            if (!string.IsNullOrEmpty(paramBitCode))
            {
                sql.AppendFormat(" and t.Instrumentation_Code like '{0}'", "%" + paramBitCode + "%");
            }
            //��������
            if (!string.IsNullOrEmpty(paramName))
            {
                sql.AppendFormat(" and t.Instrumentation_Name like '{0}'", "%" + paramName + "%");
            }

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmLimit hn = new AlarmLimit();
                    hn.limitId = dr["ID"].ToString();
                    hn.limitParamRank = dr["Instrumentation_ParamRank"].ToString();
                    hn.limitBitName = dr["Instrumentation_Name"].ToString();
                    hn.limitBitCode = dr["Instrumentation_Code"].ToString();
                    string upLine = dr["Instrumentation_UpLine"].ToString();
                    string downLine = dr["Instrumentation_DownLine"].ToString();
                    hn.limitUpLine = downLine + "��" + upLine;

                    hn.limitUnit = dr["Instrumentation_Unit"].ToString();
                    hn.limitHHigh = dr["Instrumentation_HHigh"].ToString();
                    hn.limitHigh = dr["Instrumentation_High"].ToString();
                    hn.limitLLow = dr["Instrumentation_LLow"].ToString();
                    hn.limitLow = dr["Instrumentation_Low"].ToString();
                    hn.limitRemark = dr["Instrumentation_Remark"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }


        /// <summary>
        /// ��ѯ���ղ������̨��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="paramName"></param>
        /// <param name="paramBitCode"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryCraftParamChangeRecord(string plantId, String paramName, String paramBitCode, String queryStartDate,
                         String queryEndDate, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.Craft_ParamRank,t.Craft_ParamName,t.Craft_ParamBitCode,");
            sql.Append("t.Craft_Unit,t.Craft_AlarmType,t.Craft_KPI,t.Craft_ChangeBeforeValue,t.Craft_ChangeAfterValue,");
            sql.Append("t.Craft_ChangeReason,t.Craft_ChangeDate,t.Craft_Remark,count(1) over() recordCount");
            sql.Append(" from PSOG_CraftParam_ChangeRecord t where t.ID is not null ");

            //λ��
            if (!string.IsNullOrEmpty(paramBitCode))
            {
                sql.AppendFormat(" and t.Craft_ParamBitCode like '{0}'", "%" + paramBitCode + "%");
            }
            //��������
            if (!string.IsNullOrEmpty(paramName))
            {
                sql.AppendFormat(" and t.Craft_ParamName like '{0}'", "%" + paramName + "%");
            }
            //���ʱ��
            if (!string.IsNullOrEmpty(queryStartDate)) {
                sql.AppendFormat(" and t.Craft_ChangeDate >= '{0}'", queryStartDate);
            }
            if (!string.IsNullOrEmpty(queryEndDate)) {
                sql.AppendFormat(" and t.Craft_ChangeDate <= '{0}'", queryEndDate);
            }

            sql.Append(" order by t.Craft_ChangeDate desc");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CraftParamRecord hn = new CraftParamRecord();
                    hn.craftId = dr["ID"].ToString();
                    hn.craftParamRank = dr["Craft_ParamRank"].ToString();
                    hn.craftParamName = dr["Craft_ParamName"].ToString();
                    hn.craftParamBitCode = dr["Craft_ParamBitCode"].ToString();
                    hn.craftUnit = dr["Craft_Unit"].ToString();
                    hn.craftAlarmType = dr["Craft_AlarmType"].ToString();
                    hn.craftKPI = dr["Craft_KPI"].ToString();
                    hn.craftBeforeValue = dr["Craft_ChangeBeforeValue"].ToString();
                    hn.craftAfterValue = dr["Craft_ChangeAfterValue"].ToString();
                    hn.craftReason = dr["Craft_ChangeReason"].ToString();
                    hn.craftDate = dr["Craft_ChangeDate"].ToString();
                    hn.craftRemark = dr["Craft_Remark"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ѯ���ղ�����������б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="paramName"></param>
        /// <param name="paramBitCode"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryCraftParamApplyList(string plantId, String queryReason, String queryStartDate,String queryEndDate, int pageNo, int pageSize,string applyUserId)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.*,count(1) over() recordCount");
            sql.AppendFormat("  from PSOG_CraftParam_ChangeProcess t where t.Process_ApplyUserId ='{0}' ",applyUserId);
            if (!string.IsNullOrEmpty(queryReason)) {
                sql.AppendFormat(" and t.Process_Reason like '{0}'", "%" + queryReason+"%");
            }
            if (!string.IsNullOrEmpty(queryStartDate)) {
                sql.AppendFormat(" and t.Process_ApplyDate>='{0}'", queryStartDate);
            }
            if (!string.IsNullOrEmpty(queryEndDate)) {
                sql.AppendFormat(" and t.Process_ApplyDate<='{0}'", queryEndDate);
            }
            sql.Append(" order by t.Process_ApplyDate desc");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CraftProcess hn = new CraftProcess();
                    hn.processId = dr["ID"].ToString();
                    hn.processPlantName = dr["Process_PlantName"].ToString();
                    hn.processApplyDate = dr["Process_ApplyDate"].ToString();
                    hn.processExecuteDate = dr["Process_ExecuteDate"].ToString();
                    hn.processRecoverDate = dr["Process_RecoverDate"].ToString();
                    hn.processReason = dr["Process_Reason"].ToString();
                    hn.processProtectMeasure = dr["Process_ProtectMeasure"].ToString();
                    hn.processToProductExamId = dr["Process_ToProductExam"].ToString();
                    hn.processToProductExamName = dr["Process_ToProductExamName"].ToString();
                    hn.processToMeterExamId = dr["Process_ToMeterExam"].ToString();
                    hn.processToMeterExamName = dr["Process_ToMeterExamName"].ToString();
                    hn.processToSatrapExamId = dr["Process_ToSatrapExam"].ToString();
                    hn.processToSatrapExamName = dr["Process_ToSatrapExamName"].ToString();
                    hn.processProductExamIdea = dr["Process_ProductExam"].ToString();
                    hn.processMeterExamIdea = dr["Process_MeterExam"].ToString();
                    hn.processSatrapExamIdea = dr["Process_SatrapExam"].ToString();
                    hn.processStatus = dr["Proecss_Status"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ȡװ������
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public String getPlantName(String plantId) {
            String plantName = "";
            StringBuilder sql = new StringBuilder();
            sql.Append("select t.PlantInfo_PlantName from PSOGSYS_PlantInfo t ");
            sql.AppendFormat(" where t.PlantInfo_PlantCode='{0}' and t.IsUse='1'", plantId);
            Dao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    plantName = dr["PlantInfo_PlantName"].ToString();
                }
            }
            return plantName;
        }

        /// <summary>
        /// ��ѯ���������������еĲ����б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="processId"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryProcessChildList(string plantId, String processId)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.ProcessChild_ParamBitCode,t.ProcessChild_ParamName,");
            sql.Append("t.ProcessChild_Unit,t.ProcessChild_ControlRange,t.ProcessChild_KPI,");
            sql.Append("t.ProcessChild_AlarmType,t.ProcessChild_BeforeValue,t.ProcessChild_AfterValue");
            sql.AppendFormat(" from PSOG_CraftParam_ChangeProcessChild t where t.ProcessID='{0}'", processId);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CraftProcessChild hn = new CraftProcessChild();
                    hn.processChildId = dr["ID"].ToString();
                    hn.processChildBitCode = dr["ProcessChild_ParamBitCode"].ToString();
                    hn.processChildParamName = dr["ProcessChild_ParamName"].ToString();
                    hn.processChildUnit = dr["ProcessChild_Unit"].ToString();
                    hn.processChildControlRange = dr["ProcessChild_ControlRange"].ToString();
                    hn.processChildKPI = dr["ProcessChild_KPI"].ToString();
                    hn.processChildAlarmType = dr["ProcessChild_AlarmType"].ToString();
                    hn.processChildBeforeValue = dr["ProcessChild_BeforeValue"].ToString();
                    hn.processChildAfterValue = dr["ProcessChild_AfterValue"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ���湤�ղ��������������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="processId"></param>
        /// <param name="executeDate"></param>
        /// <param name="replyDate"></param>
        /// <param name="applyData"></param>
        /// <param name="changeReason"></param>
        /// <param name="protectMeasure"></param>
        /// <param name="productExamId"></param>
        /// <param name="productExamName"></param>
        /// <param name="meterExamId"></param>
        /// <param name="meterExamName"></param>
        /// <param name="satrapExamId"></param>
        /// <param name="satrapExamName"></param>
        /// <param name="paramJson"></param>
        /// <returns></returns>
        public String saveOrSubmitCraftChangeApply(string plantId, string processId, string executeDate, string replyDate, string applyData, string changeReason,
                                string protectMeasure, string productExamId, string productExamName, string meterExamId, string meterExamName,
                                string satrapExamId, string satrapExamName, string plantName, string runIndex, string paramJson, string applyUserId)
        {
            try{
                string status = "��ʼ";
                if ("1".Equals(runIndex)) {
                    status = "�����";
                }
                //�ȱ�����������
                StringBuilder sql = new StringBuilder();
                int index = Convert.ToInt32(runIndex);
                if (string.IsNullOrEmpty(processId))
                { //����IDΪ�գ�����������
                    processId = Guid.NewGuid().ToString();
                    sql.Append("INSERT INTO PSOG_CraftParam_ChangeProcess (");
                    sql.Append("	ID,");
                    sql.Append("	Process_ApplyDate,");
                    sql.Append("	Process_ExecuteDate,");
                    sql.Append("	Process_RecoverDate,");
                    sql.Append("	Process_Reason,");
                    sql.Append("	Process_ProtectMeasure,");
                    sql.Append("	Process_ToProductExam,");
                    sql.Append("	Process_ToProductExamName,");
                    sql.Append("	Process_ToMeterExam,");
                    sql.Append("	Process_ToMeterExamName,");
                    sql.Append("	Process_ToSatrapExam,");
                    sql.Append("	Process_ToSatrapExamName,");
                    sql.Append("    Process_PlantName,");
                    sql.Append("    Proecss_Status,");
                    sql.Append("    Process_ApplyUserId,");
                    sql.Append("    Process_RunIndex)");
                    sql.AppendFormat(" values('{0}','{1}',", processId, applyData);
                    if (string.IsNullOrEmpty(executeDate))
                    {
                        sql.Append("null,");
                    }
                    else {
                        sql.AppendFormat("'{0}',", executeDate);
                    }
                    if (string.IsNullOrEmpty(replyDate))
                    {
                        sql.Append("null,");
                    }
                    else {
                        sql.AppendFormat("'{0}',", replyDate);
                    }
                    sql.AppendFormat("'{0}','{1}','{2}','{3}',", changeReason, protectMeasure, productExamId, productExamName);
                    sql.AppendFormat("'{0}','{1}','{2}','{3}','{4}','{5}','{6}',{7})", meterExamId, meterExamName, satrapExamId, satrapExamName, plantName,status,applyUserId, index);
                }
                else {
                    sql.Append("update PSOG_CraftParam_ChangeProcess set ");
                    sql.AppendFormat("Process_ApplyDate='{0}',Process_ExecuteDate='{1}',Process_RecoverDate='{2}',", applyData, executeDate, replyDate);
                    sql.AppendFormat("Process_Reason='{0}',Process_ProtectMeasure='{1}',", changeReason, protectMeasure);
                    sql.AppendFormat("Process_ToProductExam='{0}',Process_ToProductExamName='{1}',", productExamId, productExamName);
                    sql.AppendFormat("Process_ToMeterExam='{0}',Process_ToMeterExamName='{1}',", meterExamId, meterExamName);
                    sql.AppendFormat("Process_ToSatrapExam='{0}',Process_ToSatrapExamName='{1}',Process_RunIndex={2},", satrapExamId, satrapExamName, index);
                    sql.AppendFormat("Process_ProductExam=null,Process_MeterExam=null,Process_SatrapExam=null,Proecss_Status='{0}'",status);
                    sql.AppendFormat(" where ID='{0}'", processId);
                }
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());

                //�ٱ����ӱ���Ϣ
                if (!string.IsNullOrEmpty(paramJson)) {
                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                    List<CraftProcessChild> childList = jsonSerializer.Deserialize<List<CraftProcessChild>>(paramJson);
                    //��ɾ��
                    StringBuilder delChildSql = new StringBuilder();
                    delChildSql.Append("delete from PSOG_CraftParam_ChangeProcessChild");
                    delChildSql.AppendFormat(" where ProcessID='{0}'", processId);
                    dao.executeNoQuery(delChildSql.ToString());
                    //������
                    for(int i=0;i<childList.Count;i++){
                        CraftProcessChild child = childList[i];
                        StringBuilder insChildSql = new StringBuilder();
                        insChildSql.Append("INSERT INTO PSOG_CraftParam_ChangeProcessChild (");
                        insChildSql.Append("	ID,");
                        insChildSql.Append("	ProcessID,");
                        insChildSql.Append("	ProcessChild_ParamBitCode,");
                        insChildSql.Append("	ProcessChild_ParamName,");
                        insChildSql.Append("	ProcessChild_Unit,");
                        insChildSql.Append("	ProcessChild_ControlRange,");
                        insChildSql.Append("	ProcessChild_KPI,");
                        insChildSql.Append("	ProcessChild_AlarmType,");
                        insChildSql.Append("	ProcessChild_BeforeValue,");
                        insChildSql.Append("	ProcessChild_AfterValue)");
                        insChildSql.AppendFormat(" values('{0}','{1}',", Guid.NewGuid().ToString(), processId);
                        insChildSql.AppendFormat("'{0}','{1}',",child.processChildBitCode,child.processChildParamName);
                        insChildSql.AppendFormat("'{0}','{1}',",child.processChildUnit,child.processChildControlRange);
                        insChildSql.AppendFormat("'{0}','{1}',",child.processChildKPI,child.processChildAlarmType);
                        insChildSql.AppendFormat("{0},{1})",float.Parse(child.processChildBeforeValue),float.Parse(child.processChildAfterValue));
                        dao.executeNoQuery(insChildSql.ToString());
                    }
                   
                }
                return processId;
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ɾ�����������������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="list"></param>
        /// <returns></returns>
        public String delCraftParamApplyData(String plantId, List<String> list)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);

                //����
                StringBuilder mainSb = new StringBuilder();
                mainSb.Append("delete from PSOG_CraftParam_ChangeProcess where ID in(");
                //�ӱ�
                StringBuilder delChildSb = new StringBuilder();
                delChildSb.Append("delete from PSOG_CraftParam_ChangeProcessChild where ProcessID in(");
                foreach (String id in list)
                {
                    mainSb.AppendFormat("'{0}',",id);
                    delChildSb.AppendFormat("'{0}',", id);
                }
                String mainSql = mainSb.ToString();
                mainSql = mainSql.Substring(0,mainSql.Length-1)+")";

                String delChildSql = delChildSb.ToString();
                delChildSql = delChildSql.Substring(0, delChildSql.Length - 1) + ")";

                //��ִ��ɾ����������
                dao.executeNoQuery(mainSql);

                //��ִ��ɾ���ӱ�����
                dao.executeNoQuery(delChildSql);

                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// �����������б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="queryReason"></param>
        /// <param name="queryStartDate"></param>
        /// <param name="queryEndDate"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryCraftParamExamList(string plantId, String queryReason, String queryStartDate, String queryEndDate,String userId, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.*,count(1) over() recordCount");
            sql.Append("  from PSOG_CraftParam_ChangeProcess t ");
            sql.AppendFormat(" where ((t.Process_RunIndex>0 and t.Process_RunIndex<3 and ((t.Process_ToProductExam = '{0}' and len(ISNULL(t.Process_ProductExam, ''))=0) or (t.Process_ToMeterExam='{1}' and len(ISNULL(t.Process_MeterExam, ''))=0 )))", userId, userId);
            sql.AppendFormat(" or (t.Process_RunIndex=3 and t.Process_ToSatrapExam='{0}')) ",userId);
            if (!string.IsNullOrEmpty(queryReason))
            {
                sql.AppendFormat(" and t.Process_Reason like '{0}'", "%" + queryReason + "%");
            }
            if (!string.IsNullOrEmpty(queryStartDate))
            {
                sql.AppendFormat(" and t.Process_ApplyDate>='{0}'", queryStartDate);
            }
            if (!string.IsNullOrEmpty(queryEndDate))
            {
                sql.AppendFormat(" and t.Process_ApplyDate<='{0}'", queryEndDate);
            }
            sql.Append(" order by t.Process_ApplyDate desc");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CraftProcess hn = new CraftProcess();
                    hn.processId = dr["ID"].ToString();
                    hn.processPlantName = dr["Process_PlantName"].ToString();
                    hn.processApplyDate = dr["Process_ApplyDate"].ToString();
                    hn.processExecuteDate = dr["Process_ExecuteDate"].ToString();
                    hn.processRecoverDate = dr["Process_RecoverDate"].ToString();
                    hn.processReason = dr["Process_Reason"].ToString();
                    hn.processProtectMeasure = dr["Process_ProtectMeasure"].ToString();
                    hn.processToProductExamId = dr["Process_ToProductExam"].ToString();
                    hn.processToProductExamName = dr["Process_ToProductExamName"].ToString();
                    hn.processToMeterExamId = dr["Process_ToMeterExam"].ToString();
                    hn.processToMeterExamName = dr["Process_ToMeterExamName"].ToString();
                    hn.processToSatrapExamId = dr["Process_ToSatrapExam"].ToString();
                    hn.processToSatrapExamName = dr["Process_ToSatrapExamName"].ToString();
                    hn.processProductExamIdea = dr["Process_ProductExam"].ToString();
                    hn.processMeterExamIdea = dr["Process_MeterExam"].ToString();
                    hn.processSatrapExamIdea = dr["Process_SatrapExam"].ToString();
                    grid.rows.Add(hn);
                }
            }
            return grid;
        }

        /// <summary>
        /// ���ղ���������--�ύ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="processId"></param>
        /// <param name="productExam"></param>
        /// <param name="meterExam"></param>
        /// <param name="satrapExam"></param>
        /// <returns></returns>
        public string craftParamExamSubmit(string plantId, string processId, string productExam, string meterExam, string satrapExam, string isFinal)
        {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("update PSOG_CraftParam_ChangeProcess set ");
                sql.Append("  Process_RunIndex=Process_RunIndex+1,");
                if ("1".Equals(isFinal)) {
                    sql.Append(" Proecss_Status='���',");
                }
                sql.AppendFormat(" Process_ProductExam='{0}',", productExam);
                sql.AppendFormat(" Process_MeterExam='{0}',", meterExam);
                sql.AppendFormat(" Process_SatrapExam='{0}'", satrapExam);
                sql.AppendFormat(" where ID='{0}'", processId);

                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());

                if ("1".Equals(isFinal)) {
                    //���ɱ����¼
                    StringBuilder recordSql = new StringBuilder();
                    recordSql.Append("INSERT INTO PSOG_CraftParam_ChangeRecord (");
                    recordSql.Append("	Id,");
                    recordSql.Append("	Craft_ProcessId,");
                    recordSql.Append("	Craft_ParamBitCode,");
                    recordSql.Append("	Craft_ParamName,");
                    recordSql.Append("	Craft_Unit,");
                    recordSql.Append("	Craft_AlarmType,");
                    recordSql.Append("	Craft_KPI,");
                    recordSql.Append("	Craft_ChangeBeforeValue,");
                    recordSql.Append("	Craft_ChangeAfterValue,");
                    recordSql.Append("	Craft_ChangeReason,");
                    recordSql.Append("	Craft_ChangeDate)  ");
                    recordSql.Append(" SELECT ");
                    recordSql.Append("  NEWID(),");
                    recordSql.Append("	p.ID,");
                    recordSql.Append("	ch.ProcessChild_ParamBitCode,");
                    recordSql.Append("	ch.ProcessChild_ParamName,");
                    recordSql.Append("	ch.ProcessChild_Unit,");
                    recordSql.Append("	ch.ProcessChild_AlarmType,");
                    recordSql.Append("	ch.ProcessChild_KPI,");
                    recordSql.Append("	ch.ProcessChild_BeforeValue,");
                    recordSql.Append("	ch.ProcessChild_AfterValue,");
                    recordSql.Append("	p.Process_Reason,");
                    recordSql.Append("	p.Process_ApplyDate");
                    recordSql.Append(" FROM	PSOG_CraftParam_ChangeProcess p ");
                    recordSql.Append(" INNER JOIN PSOG_CraftParam_ChangeProcessChild ch ON p.ID = ch.ProcessID");
                    recordSql.AppendFormat(" WHERE p.ID = '{0}'", processId);
                    dao.executeNoQuery(recordSql.ToString());

                    //���ݱ������Ա����޽�����Ӧ�ı��
                    StringBuilder queryChangeSql = new StringBuilder();
                    queryChangeSql.Append("select t.ProcessChild_ParamBitCode,t.ProcessChild_KPI,t.ProcessChild_AfterValue");
                    queryChangeSql.Append("  from PSOG_CraftParam_ChangeProcessChild t ");
                    queryChangeSql.AppendFormat(" where t.ProcessID='{0}'", processId);
                    DataSet ds = dao.executeQuery(queryChangeSql.ToString());
                    if (BeanTools.DataSetIsNotNull(ds))
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            string paramBitCode = dr["ProcessChild_ParamBitCode"].ToString();
                            float afterValue = float.Parse(dr["ProcessChild_AfterValue"].ToString());
                            string paramKPI = dr["ProcessChild_KPI"].ToString();
                            string changeField = "";
                            if ("�߱�".Equals(paramKPI)) {
                                changeField = "Instrumentation_High";
                            }
                            else if ("�߸߱�".Equals(paramKPI)) {
                                changeField = "Instrumentation_HHigh";
                            }
                            else if ("�ͱ�".Equals(paramKPI))
                            {
                                changeField = "Instrumentation_Low";
                            }
                            else if ("�͵ͱ�".Equals(paramKPI))
                            {
                                changeField = "Instrumentation_LLow";
                            }
                            if (string.IsNullOrEmpty(changeField)) {
                                continue;
                            }
                            StringBuilder updateParam = new StringBuilder();
                            updateParam.AppendFormat("update PSOG_Instrumentation set {0}={1},", changeField, afterValue);
                            updateParam.AppendFormat("Instrumentation_EditDate='{0}'", DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"));
                            updateParam.AppendFormat(" where Instrumentation_Code='{0}'", paramBitCode);
                            dao.executeNoQuery(updateParam.ToString());
                        }
                    }
                }

                return "1";
            }
            catch (Exception e) {
                return "0";
            }
        }

        /// <summary>
        /// ���ղ���������--�˻�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="processId"></param>
        /// <param name="productExam"></param>
        /// <param name="meterExam"></param>
        /// <param name="satrapExam"></param>
        /// <returns></returns>
        public string craftParamExamBack(string plantId, string processId, string productExam, string meterExam, string satrapExam) {

            StringBuilder sql = new StringBuilder();
            sql.Append("update PSOG_CraftParam_ChangeProcess set ");
            sql.Append("  Process_RunIndex = 0,Proecss_Status='�˻�',");
            sql.AppendFormat(" Process_ProductExam='{0}',", productExam);
            sql.AppendFormat(" Process_MeterExam='{0}',", meterExam);
            sql.AppendFormat(" Process_SatrapExam='{0}'", satrapExam);
            sql.AppendFormat(" where ID='{0}'", processId);

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯDCS������־�б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="tagName"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmDCSLogList(string plantId, String tagName,string startDate,string endDate, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AlarmManager_History_Items,");
            sql.Append("	t.AlarmManager_History_Describe,");
            sql.Append("	t.AlarmManager_History_State,");
            sql.Append("	t.AlarmManager_History_StartTime,");
            sql.Append("	t.AlarmManager_History_EndTime,");
            sql.Append("	t.AlarmManager_History_AlarmClass,");
            sql.Append("    count(1) over() recordCount");
            sql.Append("   FROM ");
            sql.Append("	PSOG_AlarmManager_History_FromDCSLog t");
            sql.Append(" where t.ID is not null ");

            
            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.AppendFormat(" and t.AlarmManager_History_Items like '{0}'", "%" + tagName + "%");
            }
           
            //��ʼʱ��
            if (!string.IsNullOrEmpty(startDate)) {
                sql.AppendFormat(" and t.AlarmManager_History_StartTime>='{0}'",startDate);
            }
            if (!string.IsNullOrEmpty(endDate)) {
                sql.AppendFormat(" and t.AlarmManager_History_StartTime<='{0}'", endDate);
            }

            sql.Append(" order by t.AlarmManager_History_StartTime desc");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DCSAlarmLog alarmLog = new DCSAlarmLog();
                    alarmLog.alarmLogId = BeanTools.ObjectToString(dr["ID"]);
                    alarmLog.alarmLogBitCode = BeanTools.ObjectToString(dr["AlarmManager_History_Items"]);
                    alarmLog.alarmLogDescribe = BeanTools.ObjectToString(dr["AlarmManager_History_Describe"]);
                    alarmLog.alarmLogState = BeanTools.ObjectToString(dr["AlarmManager_History_State"]);
                    alarmLog.alarmLogStartTime = BeanTools.ObjectToString(dr["AlarmManager_History_StartTime"]);
                    alarmLog.alarmLogEndTime = BeanTools.ObjectToString(dr["AlarmManager_History_EndTime"]);
                    alarmLog.alarmLogRank = BeanTools.ObjectToString(dr["AlarmManager_History_AlarmClass"]);
                    grid.rows.Add(alarmLog);
                }
            }

            return grid;
        }

        /// <summary>
        /// �ϴ�DCS������־����ʱ��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="filepath"></param>
        /// <returns></returns>
        public String uploadDCSLog(string plantId,string filepath,string paramFlagId)
        {

            FileStream fs = new FileStream(filepath, FileMode.OpenOrCreate, FileAccess.ReadWrite);
            StreamReader m_StreamReader = new StreamReader(fs);
            m_StreamReader.BaseStream.Seek(0, SeekOrigin.Begin);
            ArrayList strLines = new ArrayList();

            string strLine = m_StreamReader.ReadLine();
            while (strLine != null)
            {
                strLines.Add(strLine);
                strLine = m_StreamReader.ReadLine();
            }
            m_StreamReader.Close();
            fs.Close();
            List<string[]> m_strs = new List<string[]>();
            for (int i = 0; i < strLines.Count; i++)
            {
                string[] strs = strLines[i].ToString().Replace(',', ' ').Split(new char[] { ' ' });
                try
                {
                    int count = 0;
                    string[] strstemp = new string[11];
                    for (int j = 0; j < strs.Length; j++)
                    {
                        if ((strs[j] != "") && (strs[j] != "-"))
                        {
                            if (count == 7)
                            {
                                try
                                {
                                    float.Parse(strs[j]);
                                }
                                catch
                                {
                                    strstemp[count] = "0";
                                    count++;
                                }
                            }
                            if (count < strstemp.Length - 1)
                                strstemp[count] = strs[j];
                            else
                                strstemp[strstemp.Length - 2] += " " + strs[j];
                            count++;
                        }
                    }
                    if ((strstemp[0] != null) && (strstemp[0] != ""))
                        m_strs.Add(strstemp);
                }
                catch
                { }
            }

            String flagId = "";
            if (m_strs.Count>0){
                if (string.IsNullOrEmpty(paramFlagId))
                {
                    flagId = Guid.NewGuid().ToString();
                }
                else {
                    flagId = paramFlagId;
                }
               
            }

            DataTable dt = GetTableSchema();

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DateTime initStartTime = DateTime.Now.ToLocalTime();
            DateTime initEndTime = new DateTime();

            for (int i = 0; i < m_strs.Count; i++)
            {
                if (m_strs[i][4] == "ALM")
                {
                    int j = i + 1;
                    bool Flag = false;
                    for (; j < m_strs.Count; j++)
                    {
                        try
                        {
                            if ((m_strs[j][4] == "RTN") && (m_strs[j][5] == m_strs[i][5]))
                            {
                                Flag = true;
                                string starttime = m_strs[i][0].Substring(0, 6) + "20" + m_strs[i][0].Substring(6, 2) + " " + m_strs[i][1];
                                string endtime = m_strs[j][0].Substring(0, 6) + "20" + m_strs[j][0].Substring(6, 2) + " " + m_strs[j][1];
                                DateTime dstarttime = DateTime.Parse(starttime);
                                DateTime dendtime = DateTime.Parse(endtime);

                                if (initStartTime > dstarttime)
                                {
                                    initStartTime = dstarttime;
                                }

                                if (initEndTime < dstarttime)
                                {
                                    initEndTime = dstarttime;
                                }
                                    


                                DataRow dr = dt.NewRow();
                                dr[0] = Guid.NewGuid().ToString();
                                dr[1] = m_strs[i][5];
                                dr[2] = m_strs[i][9];
                                dr[3] = m_strs[i][6];
                                dr[4] = flagId;
                                dr[5] = m_strs[i][8];
                                dr[6] = dstarttime;
                                dr[7] = dendtime;
                                dt.Rows.Add(dr);
                                break;
                            }
                        }
                        catch(Exception e)
                        {
                           
                        }
                    }
                    if (!Flag)
                    {
                        string starttime = m_strs[i][0].Substring(0, 6) + "20" + m_strs[i][0].Substring(6, 2) + " " + m_strs[i][1];
                        string endtime = m_strs[m_strs.Count - 1][0].Substring(0, 6) + "20" + m_strs[m_strs.Count - 1][0].Substring(6, 2) + " " + m_strs[m_strs.Count - 1][1];
                        DateTime dstarttime = DateTime.Parse(starttime);
                        DateTime dendtime = DateTime.Parse(endtime);

                        if (initStartTime > dstarttime)
                        {
                            initStartTime = dstarttime;
                        }

                        if (initEndTime < dstarttime)
                        {
                            initEndTime = dstarttime;
                        }

                        DataRow dr = dt.NewRow();
                        dr[0] = Guid.NewGuid().ToString();
                        dr[1] = m_strs[i][5];
                        dr[2] = m_strs[i][9];
                        dr[3] = m_strs[i][6];
                        dr[4] = flagId;
                        dr[5] = m_strs[i][8];
                        dr[6] = dstarttime;
                        dr[7] = dendtime;
                        dt.Rows.Add(dr);
                    }
                }
            }

            dao.batchInsert(dt, "PSOG_AlarmManager_History_DCSLog_Temp");

            String result = flagId + "#" + initStartTime.ToString("yyyy-MM-dd HH:mm:ss") + "#" + initEndTime.ToString("yyyy-MM-dd HH:mm:ss");

            return result;
        }

        /// <summary>
        /// ��ȡ��ṹ
        /// </summary>
        /// <returns></returns>
        public DataTable GetTableSchema()
        {
            DataTable dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[]{ 
                new DataColumn("ID",typeof(string)), 
                new DataColumn("AlarmManager_History_Items",typeof(string)), 
                new DataColumn("AlarmManager_History_Describe",typeof(string)),
                new DataColumn("AlarmManager_History_State",typeof(string)),
                new DataColumn("AlarmManager_History_FlagID",typeof(string)),
                new DataColumn("AlarmManager_History_AlarmClass",typeof(string)),
                new DataColumn("AlarmManager_History_StartTime",typeof(DateTime)),
                new DataColumn("AlarmManager_History_EndTime",typeof(DateTime))
             });//���ݿ��ṹ
            return dt;
        }


        /// <summary>
        /// ��ѯDCS��־��ʱ������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="flagId"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmDCSLogFromTemp(string plantId,string flagId,int pageNo,int pageSize)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.AlarmManager_History_Items,");
            sql.Append("	t.AlarmManager_History_Describe,");
            sql.Append("	t.AlarmManager_History_State,");
            sql.Append("	t.AlarmManager_History_StartTime,");
            sql.Append("	t.AlarmManager_History_EndTime,");
            sql.Append("	t.AlarmManager_History_AlarmClass,");
            sql.Append("    COUNT (1) OVER () recordCount");
            sql.Append(" FROM ");
            sql.Append("	PSOG_AlarmManager_History_DCSLog_Temp t");
            sql.AppendFormat(" WHERE t.AlarmManager_History_FlagID = '{0}'",flagId);
            sql.Append(" order by t.AlarmManager_History_StartTime desc");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(),pageNo,pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DCSAlarmLog alarmLog = new DCSAlarmLog();
                    alarmLog.alarmLogId = BeanTools.ObjectToString(dr["ID"]);
                    alarmLog.alarmLogBitCode = BeanTools.ObjectToString(dr["AlarmManager_History_Items"]);
                    alarmLog.alarmLogDescribe = BeanTools.ObjectToString(dr["AlarmManager_History_Describe"]);
                    alarmLog.alarmLogState = BeanTools.ObjectToString(dr["AlarmManager_History_State"]);
                    alarmLog.alarmLogStartTime = BeanTools.ObjectToString(dr["AlarmManager_History_StartTime"]);
                    alarmLog.alarmLogEndTime = BeanTools.ObjectToString(dr["AlarmManager_History_EndTime"]);
                    alarmLog.alarmLogRank = BeanTools.ObjectToString(dr["AlarmManager_History_AlarmClass"]);
                    grid.rows.Add(alarmLog);
                }
            }

            return grid;
        }

        /// <summary>
        /// ɾ��DCS��־��ʱ����
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="flagId"></param>
        /// <returns></returns>
        public string delDCSLogTempData(string plantId, string flagId) {
            try
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("delete from PSOG_AlarmManager_History_DCSLog_Temp");
                sql.AppendFormat(" where AlarmManager_History_FlagID='{0}'", flagId);

                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e) {
                return "0";
            }
            
        }

        /// <summary>
        /// �жϸ�ʱ�����DCS��־�Ƿ��Ѿ�����
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="initStartTime"></param>
        /// <param name="initEndTime"></param>
        /// <returns></returns>
        public string isExistDCSLog(string plantId, string initStartTime, string initEndTime) {
            string isExist = "0";
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT COUNT(*) as num FROM PSOG_AlarmManager_History_FromDCSLog t");
            sql.AppendFormat(" WHERE t.AlarmManager_History_StartTime >= '{0}'", initStartTime);
            sql.AppendFormat(" AND t.AlarmManager_History_StartTime <= '{0}'", initEndTime);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
               int num = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["num"]);
               if (num > 0) {
                   isExist = "1";
               }
            }
            return isExist;
        }

        /// <summary>
        /// ����DCS������־
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="flagId"></param>
        /// <returns></returns>
        public string saveDCSLog(string plantId, string flagId,string initStartTime,string initEndTime) {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                //��ɾ������ʱ����ڵ���־
                StringBuilder delSql = new StringBuilder();
                delSql.Append("delete from PSOG_AlarmManager_History_FromDCSLog ");
                delSql.AppendFormat(" where AlarmManager_History_StartTime>='{0}'", initStartTime);
                delSql.AppendFormat(" and AlarmManager_History_StartTime<='{0}'",initEndTime);
                dao.executeNoQuery(delSql.ToString());

                StringBuilder saveSql = new StringBuilder();
                saveSql.Append("INSERT INTO PSOG_AlarmManager_History_FromDCSLog (");
                saveSql.Append("	AlarmManager_History_Items,");
                saveSql.Append("	AlarmManager_History_Describe,");
                saveSql.Append("	AlarmManager_History_State,");
                saveSql.Append("	AlarmManager_History_StartTime,");
                saveSql.Append("	AlarmManager_History_EndTime,");
                saveSql.Append("	AlarmManager_History_AlarmClass)  ");
                saveSql.Append("SELECT");
                saveSql.Append("	t.AlarmManager_History_Items,");
                saveSql.Append("	t.AlarmManager_History_Describe,");
                saveSql.Append("	t.AlarmManager_History_State,");
                saveSql.Append("	t.AlarmManager_History_StartTime,");
                saveSql.Append("	t.AlarmManager_History_EndTime,");
                saveSql.Append("	t.AlarmManager_History_AlarmClass");
                saveSql.Append(" FROM PSOG_AlarmManager_History_DCSLog_Temp t ");
                saveSql.AppendFormat(" WHERE t.AlarmManager_History_FlagID = '{0}'", flagId);

                dao.executeNoQuery(saveSql.ToString());
                return "1";
            }
            catch (Exception e) {
                return "0";
            }
        }

        /// <summary>
        /// ɾ��DCS��־
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="logIds"></param>
        /// <returns></returns>
        public String deleteDCSLogInfo(String plantId, List<string> logIds)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                StringBuilder sql = new StringBuilder();
                sql.Append("delete from PSOG_AlarmManager_History_FromDCSLog where ID in(");
                foreach (String id in logIds)
                {
                    sql.AppendFormat("'{0}',",id);
                }
                String delSql = sql.ToString();
                delSql = delSql.Substring(0, delSql.Length - 1) + ")";

                dao.executeNoQuery(delSql);
                return "1";
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯHAZOP������ԭ���б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public EasyUIData queryBitHazopParamList(string plantId, string bitId, string bias)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("select t.ID,t.HAZOP_Reason,t.HAZOP_I,t.HAZOP_Measure");
            sql.AppendFormat("  from PSOG_HAZOP t where t.HAZOP_InstrumentationID = '{0}' and t.HAZOP_Bias='{1}'", bitId, bias);
            sql.Append(" and (len(ISNULL(t.HAZOP_Reason, ''))>0 or len(ISNULL(t.HAZOP_I, ''))>0 or len(ISNULL(t.HAZOP_Measure, ''))>0)");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    HazopParam hazop = new HazopParam();
                    hazop.hazopId = BeanTools.ObjectToString(dr["ID"]);
                    hazop.hazopReason = BeanTools.ObjectToString(dr["HAZOP_Reason"]);
                    hazop.hazopI = BeanTools.ObjectToString(dr["HAZOP_I"]);
                    hazop.hazopMeasure = BeanTools.ObjectToString(dr["HAZOP_Measure"]);
                    grid.rows.Add(hazop);
                }
            }

            return grid;
        }

        /// <summary>
        /// ����Hazop����
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <param name="hazopBiasValueH"></param>
        /// <param name="hazopRRH"></param>
        /// <param name="hazopFH"></param>
        /// <param name="hazopSH"></param>
        /// <param name="hazopConseqH"></param>
        /// <param name="hazopPreventH"></param>
        /// <param name="hazopBiasValueL"></param>
        /// <param name="hazopRRL"></param>
        /// <param name="hazopFL"></param>
        /// <param name="hazopSL"></param>
        /// <param name="hazopConseqL"></param>
        /// <param name="hazopPreventL"></param>
        /// <param name="paramJson"></param>
        /// <param name="paramJsonLow"></param>
        /// <returns></returns>
        public String saveHazopParamData(string plantId, string bitId, string hazopBiasValueH, string hazopRRH, string hazopFH, string hazopSH,
                               string hazopConseqH, string hazopPreventH, string hazopBiasValueL, string hazopRRL, string hazopFL,
                               string hazopSL, string hazopConseqL, string hazopPreventL, string paramJson, string paramJsonLow)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                //��ɾ��
                StringBuilder delSql = new StringBuilder();
                delSql.AppendFormat("delete from PSOG_HAZOP  where HAZOP_InstrumentationID={0}", bitId);
                dao.executeNoQuery(delSql.ToString());

                //�ȱ���߱�����
                if (!string.IsNullOrEmpty(paramJson))
                {
                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                    List<HazopParam> highReasonList = jsonSerializer.Deserialize<List<HazopParam>>(paramJson);
                    foreach (HazopParam hazopParam in highReasonList)
                    {
                        StringBuilder saveHighSql = new StringBuilder();
                        saveHighSql.Append("insert into PSOG_HAZOP(HAZOP_InstrumentationID,HAZOP_Reason,HAZOP_I,HAZOP_Measure,");
                        saveHighSql.Append("HAZOP_Bias,HAZOP_BiasValue,HAZOP_RR,HAZOP_F,HAZOP_S,HAZOP_Conseq,HAZOP_Prevent)");
                        saveHighSql.AppendFormat(" values({0},'{1}','{2}','{3}','��',", bitId, hazopParam.hazopReason, hazopParam.hazopI, hazopParam.hazopMeasure);
                        if (string.IsNullOrEmpty(hazopBiasValueH))
                        {
                            saveHighSql.Append("null,");
                        }
                        else
                        {
                            saveHighSql.AppendFormat("{0},", float.Parse(hazopBiasValueH));
                        }
                        saveHighSql.AppendFormat("'{0}',", hazopRRH);

                        if (string.IsNullOrEmpty(hazopFH))
                        {
                            saveHighSql.Append("null,");
                        }
                        else
                        {
                            saveHighSql.AppendFormat("{0},", Convert.ToInt32(hazopFH));
                        }

                        if (string.IsNullOrEmpty(hazopSH))
                        {
                            saveHighSql.Append("null,");
                        }
                        else
                        {
                            saveHighSql.AppendFormat("{0},", Convert.ToInt32(hazopSH));
                        }
                        saveHighSql.AppendFormat("'{0}','{1}')", hazopConseqH, hazopPreventH);
                        dao.executeNoQuery(saveHighSql.ToString());
                    }
                }
                else {
                    StringBuilder saveHighSql = new StringBuilder();
                    saveHighSql.Append("insert into PSOG_HAZOP(HAZOP_InstrumentationID,");
                    saveHighSql.Append("HAZOP_Bias,HAZOP_BiasValue,HAZOP_RR,HAZOP_F,HAZOP_S,HAZOP_Conseq,HAZOP_Prevent)");
                    saveHighSql.AppendFormat(" values({0},'��',", bitId);
                    if (string.IsNullOrEmpty(hazopBiasValueH))
                    {
                        saveHighSql.Append("null,");
                    }
                    else
                    {
                        saveHighSql.AppendFormat("{0},", float.Parse(hazopBiasValueH));
                    }
                    saveHighSql.AppendFormat("'{0}',", hazopRRH);

                    if (string.IsNullOrEmpty(hazopFH))
                    {
                        saveHighSql.Append("null,");
                    }
                    else
                    {
                        saveHighSql.AppendFormat("{0},", Convert.ToInt32(hazopFH));
                    }

                    if (string.IsNullOrEmpty(hazopSH))
                    {
                        saveHighSql.Append("null,");
                    }
                    else
                    {
                        saveHighSql.AppendFormat("{0},", Convert.ToInt32(hazopSH));
                    }
                    saveHighSql.AppendFormat("'{0}','{1}')", hazopConseqH, hazopPreventH);
                    dao.executeNoQuery(saveHighSql.ToString());
                }

                //�ٱ���ͱ�����
                if (!string.IsNullOrEmpty(paramJsonLow))
                {
                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                    List<HazopParam> lowReasonList = jsonSerializer.Deserialize<List<HazopParam>>(paramJsonLow);
                    foreach (HazopParam hazopParam in lowReasonList)
                    {
                        StringBuilder saveLowSql = new StringBuilder();
                        saveLowSql.Append("insert into PSOG_HAZOP(HAZOP_InstrumentationID,HAZOP_Reason,HAZOP_I,HAZOP_Measure,");
                        saveLowSql.Append("HAZOP_Bias,HAZOP_BiasValue,HAZOP_RR,HAZOP_F,HAZOP_S,HAZOP_Conseq,HAZOP_Prevent)");
                        saveLowSql.AppendFormat(" values({0},'{1}','{2}','{3}','��',", bitId, hazopParam.hazopReason, hazopParam.hazopI, hazopParam.hazopMeasure);
                        if (string.IsNullOrEmpty(hazopBiasValueL))
                        {
                            saveLowSql.Append("null,");
                        }
                        else
                        {
                            saveLowSql.AppendFormat("{0},", float.Parse(hazopBiasValueL));
                        }
                        saveLowSql.AppendFormat("'{0}',", hazopRRL);

                        if (string.IsNullOrEmpty(hazopFL))
                        {
                            saveLowSql.Append("null,");
                        }
                        else
                        {
                            saveLowSql.AppendFormat("{0},", Convert.ToInt32(hazopFL));
                        }

                        if (string.IsNullOrEmpty(hazopSL))
                        {
                            saveLowSql.Append("null,");
                        }
                        else
                        {
                            saveLowSql.AppendFormat("{0},", Convert.ToInt32(hazopSL));
                        }
                        saveLowSql.AppendFormat("'{0}','{1}')", hazopConseqL, hazopPreventL);
                        dao.executeNoQuery(saveLowSql.ToString());
                    }
                }else {
                    StringBuilder saveLowSql = new StringBuilder();
                    saveLowSql.Append("insert into PSOG_HAZOP(HAZOP_InstrumentationID,");
                    saveLowSql.Append("HAZOP_Bias,HAZOP_BiasValue,HAZOP_RR,HAZOP_F,HAZOP_S,HAZOP_Conseq,HAZOP_Prevent)");
                    saveLowSql.AppendFormat(" values({0},'��',", bitId);
                    if (string.IsNullOrEmpty(hazopBiasValueL))
                    {
                        saveLowSql.Append("null,");
                    }
                    else
                    {
                        saveLowSql.AppendFormat("{0},", float.Parse(hazopBiasValueL));
                    }
                    saveLowSql.AppendFormat("'{0}',", hazopRRL);

                    if (string.IsNullOrEmpty(hazopFL))
                    {
                        saveLowSql.Append("null,");
                    }
                    else
                    {
                        saveLowSql.AppendFormat("{0},", Convert.ToInt32(hazopFL));
                    }

                    if (string.IsNullOrEmpty(hazopSL))
                    {
                        saveLowSql.Append("null,");
                    }
                    else
                    {
                        saveLowSql.AppendFormat("{0},", Convert.ToInt32(hazopSL));
                    }
                    saveLowSql.AppendFormat("'{0}','{1}')", hazopConseqL, hazopPreventL);
                    dao.executeNoQuery(saveLowSql.ToString());
                }
                return "1";
                
            }
            catch (Exception exe)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ȡhazop������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="bitId"></param>
        /// <returns></returns>
        public String getHazopParamInfo(string plantId, string bitId) {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	TOP 1 h.HAZOP_BiasValue,");
            sql.Append("	h.HAZOP_F,");
            sql.Append("	h.HAZOP_S,");
            sql.Append("	h.HAZOP_RR,");
            sql.Append("    h.HAZOP_Conseq,");
            sql.Append("    h.HAZOP_Prevent,");
            sql.Append("	'��' AS type");
            sql.Append(" FROM PSOG_HAZOP h ");
            sql.AppendFormat(" WHERE h.HAZOP_InstrumentationID = {0}",bitId);
            sql.Append(" AND h.HAZOP_Bias = '��' ");
            sql.Append(" UNION ALL ");
            sql.Append("	SELECT");
            sql.Append("		TOP 1 h.HAZOP_BiasValue,");
            sql.Append("		h.HAZOP_F,");
            sql.Append("		h.HAZOP_S,");
            sql.Append("		h.HAZOP_RR,");
            sql.Append("        h.HAZOP_Conseq,");
            sql.Append("        h.HAZOP_Prevent,");
            sql.Append("		'��' AS type");
            sql.Append("	FROM  PSOG_HAZOP h");
            sql.AppendFormat("	WHERE h.HAZOP_InstrumentationID = {0}",bitId);
            sql.Append("	AND h.HAZOP_Bias = '��'");

            Dictionary<string, string> hazopDict = new Dictionary<string, string>();
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string hazopBiasValue = BeanTools.ObjectToString(dr["HAZOP_BiasValue"]);
                    string hazopF = BeanTools.ObjectToString(dr["HAZOP_F"]);
                    string hazopS = BeanTools.ObjectToString(dr["HAZOP_S"]);
                    string hazopRR = BeanTools.ObjectToString(dr["HAZOP_RR"]);
                    string hazopConseq = BeanTools.ObjectToString(dr["HAZOP_Conseq"]);
                    string hazopPrevent = BeanTools.ObjectToString(dr["HAZOP_Prevent"]);
                    string hazopType = BeanTools.ObjectToString(dr["type"]);
                    if ("��".Equals(hazopType)) {
                        hazopDict.Add("biasValueH", hazopBiasValue);
                        hazopDict.Add("hazopFH", hazopF);
                        hazopDict.Add("hazopSH", hazopS);
                        hazopDict.Add("hazopRRH", hazopRR);
                        hazopDict.Add("conseqH", hazopConseq);
                        hazopDict.Add("preventH", hazopPrevent);
                    }
                    else if ("��".Equals(hazopType))
                    {
                        hazopDict.Add("biasValueL", hazopBiasValue);
                        hazopDict.Add("hazopFL", hazopF);
                        hazopDict.Add("hazopSL", hazopS);
                        hazopDict.Add("hazopRRL", hazopRR);
                        hazopDict.Add("conseqL", hazopConseq);
                        hazopDict.Add("preventL", hazopPrevent);
                    }
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String hazopJSON = jsonSerializer.Serialize(hazopDict);
            return hazopJSON;
        }

        /// <summary>
        /// ��ѯ΢�ű�������������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public String queryWXReportConfigInfo(string plantId)
        {
            WXReportConfig reportConfig = new WXReportConfig();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT t.WXReportSetting_Id,t.WXReportSetting_ToUserId,t.WXReportSetting_ToUserName");
            sql.Append(" from PSOG_AbnormalReport_WXConfig t");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    reportConfig.WXReportConfigId = BeanTools.ObjectToString(dr["WXReportSetting_Id"]);
                    reportConfig.WXReportConfigToUserId = BeanTools.ObjectToString(dr["WXReportSetting_ToUserId"]);
                    reportConfig.WXReportConfigToUserName = BeanTools.ObjectToString(dr["WXReportSetting_ToUserName"]);
                }
            }
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            String configJson = jsonSerializer.Serialize(reportConfig);
            return configJson;
        }

        /// <summary>
        /// ����΢�ű�������������Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="toUserId"></param>
        /// <param name="toUserName"></param>
        /// <returns></returns>
        public string saveWXReportConfigInfo(string plantId,string toUserId,string toUserName)
        {
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);

                lock (lockObj)
                {
                    IList sqlList = new ArrayList();

                    //ɾ��������Ϣ
                    StringBuilder delSql = new StringBuilder();
                    delSql.Append("delete from PSOG_AbnormalReport_WXConfig");
                    sqlList.Add(delSql.ToString());
                    //���
                    if (!string.IsNullOrEmpty(toUserId))
                    {
                        StringBuilder insertSql = new StringBuilder();
                        insertSql.Append("insert into PSOG_AbnormalReport_WXConfig(WXReportSetting_Id,WXReportSetting_ToUserId,WXReportSetting_ToUserName)");
                        insertSql.AppendFormat(" values('{0}','{1}','{2}')",Guid.NewGuid().ToString(),toUserId,toUserName);
                        sqlList.Add(insertSql.ToString());
                    }
                    dao.executeNoQuery(sqlList);

                    return "1";
                }
            }
            catch (Exception e)
            {
                return "0";
            }
        }

        /// <summary>
        /// ���ر�����Ϣ��־�б�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="tagName"></param>
        /// <param name="tagDesc"></param>
        /// <param name="alarmType"></param>
        /// <param name="sendStartTime"></param>
        /// <param name="sendEndTime"></param>
        /// <param name="toUserName"></param>
        /// <param name="pageNo"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmMessageRecordList(string plantId, String tagName, String tagDesc,string alarmType,string sendStartTime,
                                                     string sendEndTime,string toUserName,int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();
           
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ID,");
            sql.Append("	t.MessageRecord_TagName,");
            sql.Append("	t.MessageRecord_TagDesc,");
            sql.Append("	t.MessageRecord_Type,");
            sql.Append("	t.MessageRecord_State,");
            sql.Append("	t.MessageRecord_StartDate,");
            sql.Append("	t.MessageReocrd_SustainTime,");
            sql.Append("	t.MessageRecord_Value,");
            sql.Append("	t.MessageRecord_SendDate,");
            sql.Append("	t.MessageRecord_ToUserName,");
            sql.Append("	t.MessageRecord_SendMethod,");
            sql.Append("	COUNT (1) OVER () recordCount");
            sql.Append(" FROM PSOG_AbnormalSendMessage_Record t");
            sql.Append(" where t.ID is not null ");
            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and t.MessageRecord_TagName like '{0}'", "%" + tagName + "%"));
            }
            //����
            if (!string.IsNullOrEmpty(tagDesc))
            {
                sql.Append(string.Format(" and t.MessageRecord_TagDesc like '{0}'", "%" + tagDesc + "%"));
            }
            //��������
            if (!string.IsNullOrEmpty(alarmType))
            {
                sql.Append(string.Format(" and t.MessageRecord_Type = '{0}'", alarmType));
            }
            //��ʼʱ��
            if (!string.IsNullOrEmpty(sendStartTime))
            {
                sql.Append(string.Format(" and t.MessageRecord_SendDate >= '{0}'", sendStartTime));
            }
            //����ʱ��
            if (!string.IsNullOrEmpty(sendEndTime))
            {
                sql.Append(string.Format(" and t.MessageRecord_SendDate <= '{0}'", sendEndTime));
            }
            //������
            if (!string.IsNullOrEmpty(toUserName))
            {
                sql.Append(string.Format(" and t.MessageRecord_ToUserName like '{0}'", "%" + toUserName + "%"));
            }
            sql.Append(" order by t.MessageRecord_SendDate");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["recordCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmMessageRecord record = new AlarmMessageRecord();
                    record.MessageRecordId = BeanTools.ObjectToString(dr["ID"]);
                    record.MessageRecordTagName = BeanTools.ObjectToString(dr["MessageRecord_TagName"]);
                    record.MessageRecordTagDesc = BeanTools.ObjectToString(dr["MessageRecord_TagDesc"]);
                    record.MessageRecordType = BeanTools.ObjectToString(dr["MessageRecord_Type"]);
                    record.MessageRecordState = BeanTools.ObjectToString(dr["MessageRecord_State"]);
                    record.MessageRecordStartDate = BeanTools.ObjectToString(dr["MessageRecord_StartDate"]);
                    record.MessageRecordSustainTime = BeanTools.ObjectToString(dr["MessageReocrd_SustainTime"]);
                    record.MessageRecordValue = BeanTools.ObjectToString(dr["MessageRecord_Value"]);
                    record.MessageRecordSendDate = BeanTools.ObjectToString(dr["MessageRecord_SendDate"]);
                    record.MessageRecordToUserName = BeanTools.ObjectToString(dr["MessageRecord_ToUserName"]);
                    record.MessageRecordSendMethod = BeanTools.ObjectToString(dr["MessageRecord_SendMethod"]);
                    grid.rows.Add(record);
                }
            }
            return grid;
        }

        /// <summary>
        /// �����û�ID��ȡ�û���
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string GetUserNameById(string userId) {
            string userName = "";
            StringBuilder sql = new StringBuilder();
            sql.AppendFormat("select u.SYS_USER_NAME from PSOGSYS_PermissionUser u where u.ID='{0}'",userId);
            Dao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    userName = BeanTools.ObjectToString(dr["SYS_USER_NAME"]);
                }
            }
            return userName;
        }

        /// <summary>
        /// ������¼�Ƿ��Ѿ�ȷ��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="tagId"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public string AlarmRecordIsConfirmed(string plantId, string tagId,string type) {
            string isConfirm = "0";
            StringBuilder sql = new StringBuilder();
            if ("Alarm".Equals(type))
            {
                sql.AppendFormat("select t.AbnormalRealTime_IsConfirm from RTResEx_AbnormalRealTime t where t.AbnormalRealTime_TagID='{0}'", tagId);
            }
            else if ("EarlyAlarm".Equals(type))
            {
                sql.AppendFormat("select t.AbnormalEarlyRealTime_IsConfirm from RTResEx_AbnormalEarlyRealTime t where t.AbnormalEarlyRealTime_TagID='{0}'", tagId);
            }
            else if ("Abnormal".Equals(type))
            {
                sql.AppendFormat("select t.AbnormalStateRealTime_IsConfirm from RTResEx_AbnormalStateRealTime t where t.AbnormalStateRealTime_TagID='{0}'",tagId);
            }
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, false);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string innerConfirm = BeanTools.ObjectToString(dr[0]);
                    if ("��ȷ��".Equals(innerConfirm))
                    {
                        isConfirm = "1";
                    }
                   
                }
            }
            return isConfirm;
        }

        /// <summary>
        /// �������ͱ�����������
        /// </summary>
        public void sendAlarmReportTask() {

            string nowDate = DateTime.Now.ToString("yyyy-MM-dd") + " 07:00:00";
            string startDate = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd") + " 07:00:00";
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);
                    //��ѯ������
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao userDao = new Dao(plant, true);
                    StringBuilder sb = new StringBuilder();
                    sb.Append("select t.WXReportSetting_ToUserId,t.WXReportSetting_ToUserName from PSOG_AbnormalReport_WXConfig t");
                    DataSet userDS = userDao.executeQuery(sb.ToString());
                    string toUserId = "";
                    string toUserName = "";
                    if (BeanTools.DataSetIsNotNull(userDS))
                    {
                        foreach (DataRow drs in userDS.Tables[0].Rows)
                        {
                            toUserId = BeanTools.ObjectToString(drs["WXReportSetting_ToUserId"]);
                            toUserName = BeanTools.ObjectToString(drs["WXReportSetting_ToUserName"]);
                        }
                    }

                    //���ͱ���
                    if (!string.IsNullOrEmpty(toUserId)) {
                        //΢��ͼ����Ϣ
                        WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                        newsArticle.description = "װ�ñ�����������";
                        string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/alarm_analysis_report_wx.aspx?plantId=" + plantId + "&startTime=" + startDate + "&endTime="+nowDate;
                        newsArticle.url = confirmUrl;
                        newsArticle.title = plantName + "װ�ñ�����������  " + startDate + "---" + nowDate;
                        web.SendAlarmNews(newsArticle, toUserId, WXAlarmReportId);
                        //������־
                        InsertWXAlarmReportRecord(plantId, toUserId, toUserName, startDate + "---" + nowDate,nowDate);
                    }

                }
            } 
        }

        /// <summary>
        /// ���汨�����͵���־
        /// </summary>
        /// <param name="toUserId"></param>
        /// <param name="toUserName"></param>
        /// <param name="reportInterval"></param>
        /// <param name="nowDate"></param>
        public void InsertWXAlarmReportRecord(string plantId,string toUserId,string toUserName,string reportInterval,string nowDate) {
            StringBuilder sql = new StringBuilder();
            sql.Append("insert into PSOG_AbnormalReportSend_Record(ID,ReportInterval,SendDate,SendToUserId,SendToUserName)");
            sql.AppendFormat(" values('{0}','{1}','{2}',",Guid.NewGuid().ToString(),reportInterval,nowDate);
            sql.AppendFormat("'{0}','{1}')",toUserId,toUserName);
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            dao.executeNoQuery(sql.ToString());
        }


        /// <summary>
        /// ��ɽʯ��--���Ͷ���
        /// </summary>
        /// <param name="Mobile"></param>
        /// <param name="ShortMessage"></param>
        public static void SendMessageByHttpPost(string Mobile, string ShortMessage)
        {
            //MessageBox.Show("start");
            HttpWebRequest hwr = (HttpWebRequest)HttpWebRequest.Create("http://10.101.240.3/CoreSMS/submitMessage");
            hwr.Proxy = WebRequest.DefaultWebProxy;
            hwr.Method = "POST";
            hwr.ContentType = "application/x-www-form-urlencoded";
            hwr.CookieContainer = new CookieContainer();
            hwr.UserAgent = "Mozilla/4.0(compatible;MSIE 6.0;WindowsNT 5.2;SV1;.NET CLR 2.0.50727;)";//��������� 
            hwr.Accept = "*/*";//�������� 
            hwr.KeepAlive = true;
            //��֯��������
            string SendStr = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
            SendStr += "<CoreSMS>";
            SendStr += "<OperID>psog</OperID>";
            SendStr += "<OperPass>psog</OperPass>";
            SendStr += "<Action>Submit</Action>";
            SendStr += "<Category>0</Category>";
            SendStr += "<Body>";
            SendStr += "<SendTime>" + System.DateTime.Now.ToString("yyyyMMddhhmmss") + "</SendTime>";
            SendStr += "<AppendID></AppendID>";
            SendStr += "<Message>";

            SendStr += "<DesMobile>" + Mobile + "</DesMobile>";
            SendStr += "<Content>" + ShortMessage + "</Content>";
            SendStr += "</Message>";

            SendStr += "</Body>";
            SendStr += "</CoreSMS>";
            //MessageBox.Show(SendStr);
            if (SendStr != null)
            {
                byte[] bs = Encoding.Default.GetBytes(SendStr);
                hwr.ContentLength = bs.Length;
                System.IO.Stream newStream = hwr.GetRequestStream();
                newStream.Write(bs, 0, bs.Length);
                newStream.Close();
                //MessageBox.Show("1");
            }
            else
            {
                hwr.ContentLength = 0;
            }

            // ��ȡ���ؽ��
            HttpWebResponse wr = null;
            Encoding encode = Encoding.Default;


            Char[] read = new Char[1024];
            wr = (HttpWebResponse)hwr.GetResponse();
            Stream ReceiveStream = wr.GetResponseStream();
            StreamReader sr = new StreamReader(ReceiveStream, encode);
            int count = sr.Read(read, 0, 1024);
            StringBuilder sb = new StringBuilder();
            while (count > 0)
            {
                string str = new string(read, 0, count);
                sb.Append(str);
                count = sr.Read(read, 0, 1024);
            }
            string strPageContent = sb.ToString();
            //MessageBox.Show(strPageContent);
            sr.Dispose();
            hwr.Abort();
            //MessageBox.Show("end");
        }



        /// <summary>
        /// ��ѯ������δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAlarmInfo_new_ys()
        {

            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalRealTime_TagID,t.AbnormalRealTime_TagName,t.AbnormalRealTime_Desc,t.AbnormalRealTime_State,");
                    alarmSql.Append("t.AbnormalRealTime_StartTime,t.AbnormalRealTime_SustainTime,t.AbnormalRealTime_Value, ");
                    alarmSql.Append(" AbnormalRealTime_MsgMark,t.AbnormalRealTime_SendMessage from RTResEx_AbnormalRealTime t");
                    alarmSql.Append(" where (t.AbnormalRealTime_IsConfirm is null or t.AbnormalRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalRealTime_State<>'����' and t.AbnormalRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalRealTime_Value"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalRealTime_SendMessage"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }

                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=Alarm";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOG������Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalAlarmConfig_StartTime1,t.AbnormalAlarmConfig_StartMen1,t.AbnormalAlarmConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime2,t.AbnormalAlarmConfig_StartMen2,t.AbnormalAlarmConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime3,t.AbnormalAlarmConfig_StartMen3,t.AbnormalAlarmConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalAlarmConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen1"]);
                                    string manName1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName1"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen2"]);
                                    string manName2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName2"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen3"]);
                                    string manName3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName3"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else
                                                        {
                                                            num1++;
                                                        }
                                                    }

                                                  
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "1", "AbnormalRealTime_NormalMsgMark");
                                                   

                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else
                                                        {
                                                            num2++;
                                                        }
                                                    }

                                                   
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "2", "AbnormalRealTime_NormalMsgMark");
                                                    

                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                            num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else
                                                        {
                                                            num3++;
                                                        }
                                                    }
                                                   
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_MsgMark", ID, "3", "AbnormalRealTime_NormalMsgMark");
                                                    


                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯԤ����δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendEarlyAlarmInfo_new_ys()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalEarlyRealTime_TagID,t.AbnormalEarlyRealTime_TagName,t.AbnormalEarlyRealTime_Desc,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_State,t.AbnormalEarlyRealTime_StartTime,AbnormalEarlyRealTime_Value,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_SustainTime,t.AbnormalEarlyRealTime_MsgMark,t.AbnormalEarlyRealTime_SendMessage from RTResEx_AbnormalEarlyRealTime t ");
                    alarmSql.Append("where (t.AbnormalEarlyRealTime_IsConfirm is null or t.AbnormalEarlyRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_State<>'����' and t.AbnormalEarlyRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalEarlyRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Desc"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SendMessage"]);

                            String tagState = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_StartTime"]);

                            String continueTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }

                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=EarlyAlarm";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOGԤ����Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalEarlyWarnConfig_StartTime1,t.AbnormalEarlyWarnConfig_StartMen1,AbnormalEarlyWarnConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime2,t.AbnormalEarlyWarnConfig_StartMen2,AbnormalEarlyWarnConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime3,t.AbnormalEarlyWarnConfig_StartMen3,AbnormalEarlyWarnConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalEarlyWarnConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                           
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else
                                                        {
                                                            num1++;
                                                        }
                                                    }
                                                    
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "1", "AbnormalEarlyRealTime_NormalMsgMark");
                                                    

                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                         
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else
                                                        {
                                                            num2++;
                                                        }
                                                    }
                                                   
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "2", "AbnormalEarlyRealTime_NormalMsgMark");
                                                    

                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                            num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else
                                                        {
                                                            num3++;
                                                        }
                                                    }
                                                    
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_MsgMark", ID, "3", "AbnormalEarlyRealTime_NormalMsgMark");
                                                   



                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯ�쳣��δȷ�ϵ�ʵʱ��Ϣ--����΢����Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAbnormalStateInfo_new_ys()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalStateRealTime_TagID,t.AbnormalStateRealTime_TagName,t.AbnormalStateRealTime_Desc,");
                    alarmSql.Append("t.AbnormalStateRealTime_State,AbnormalStateRealTime_StartTime,");
                    alarmSql.Append("t.AbnormalStateRealTime_SustainTime,AbnormalStateRealTime_MsgMark,t.AbnormalStateRealTime_SendMessage from RTResEx_AbnormalStateRealTime t ");
                    alarmSql.Append("where (t.AbnormalStateRealTime_IsConfirm is null or t.AbnormalStateRealTime_IsConfirm<>'��ȷ��')");
                    alarmSql.Append(" and t.AbnormalStateRealTime_State<>'����' and t.AbnormalStateRealTime_State<>'�����쳣'");
                    alarmSql.Append(" and ISNULL(t.AbnormalStateRealTime_MsgMark, 0)<=2");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagID"]);
                            String tagName = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalStateRealTime_Desc"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalStateRealTime_MsgMark"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SendMessage"]);

                            String tagState = BeanTools.ObjectToString(drr["AbnormalStateRealTime_State"]);
                            String realValue = "0";
                            String startTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_StartTime"]);

                            String continueTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SustainTime"]);
                            long intervalMin = 0;
                            if (!string.IsNullOrEmpty(continueTime))
                            {
                                intervalMin = long.Parse(continueTime);
                            }
                            //΢��ͼ����Ϣ
                            //WXWeb.NewsArticle newsArticle = new WXWeb.NewsArticle();
                            //newsArticle.description = message;

                            //string confirmUrl = "http://" + DomainHack + projectPath + "/aspx/WXAlarmConfirmCode.aspx?message=" + message + "&plantId=" + plantId + "&recordId=" + tagId + "&messageType=Abnormal";
                            //newsArticle.url = confirmUrl;
                            //newsArticle.title = "PSOG�쳣��Ϣ  " + DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss"); 

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalStateConfig_StartTime1,t.AbnormalStateConfig_StartMen1,t.AbnormalStateConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime2,t.AbnormalStateConfig_StartMen2,t.AbnormalStateConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime3,t.AbnormalStateConfig_StartMen3,t.AbnormalStateConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalStateConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if (string.IsNullOrEmpty(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time1) && !string.IsNullOrEmpty(man1))
                                        {
                                            int itTime1 = Convert.ToInt32(time1);
                                            if (intervalMin > itTime1)
                                            {
                                                if (!string.IsNullOrEmpty(mobile1))
                                                {
                                                    string[] method1s = method1.Split(',');
                                                    string[] man1s = man1.Split(',');
                                                    string[] manName1s = manName1.Split(',');
                                                    string[] mobile1s = mobile1.Split(',');
                                                    int num1 = 0;
                                                    for (int i = 0; i < method1s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method1s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                            num1++;
                                                        }
                                                        else if ("΢��".Equals(method1s[i]))
                                                        {
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            //web.SendAlarmNews(newsArticle, man1s[i],WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                            num1++;
                                                        }
                                                        else if ("ȫ��".Equals(method1s[i]))
                                                        {
                                                            web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile1s[i], message);
                                                           
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                                continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                            num1++;
                                                        }
                                                        else
                                                        {
                                                            num1++;
                                                        }
                                                    }
                                                   
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "1", "AbnormalStateRealTime_NormalMsgMark");
                                                  


                                                }

                                            }
                                        }
                                    }
                                    else if ("1".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time2) && !string.IsNullOrEmpty(man2))
                                        {
                                            int itTime2 = Convert.ToInt32(time2);
                                            if (intervalMin > itTime2)
                                            {
                                                if (!string.IsNullOrEmpty(mobile2))
                                                {
                                                    string[] method2s = method2.Split(',');
                                                    string[] man2s = man2.Split(',');
                                                    string[] manName2s = manName2.Split(',');
                                                    string[] mobile2s = mobile2.Split(',');
                                                    int num2 = 0;
                                                    for (int i = 0; i < method2s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method2s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                            num2++;
                                                        }
                                                        else if ("΢��".Equals(method2s[i]))
                                                        {
                                                            //web.SendAlarmNews(newsArticle, man2s[i],WXAlarmInfoId);
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                               continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                            num2++;
                                                        }
                                                        else if ("ȫ��".Equals(method2s[i]))
                                                        {
                                                            web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile2s[i], message);
                                                           
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                              continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                            num2++;
                                                        }
                                                        else
                                                        {
                                                            num2++;
                                                        }
                                                    }
                                                    
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "2", "AbnormalStateRealTime_NormalMsgMark");
                                                   

                                                }

                                            }
                                        }
                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        if (!string.IsNullOrEmpty(time3) && !string.IsNullOrEmpty(man3))
                                        {
                                            int itTime3 = Convert.ToInt32(time3);
                                            if (intervalMin > itTime3)
                                            {
                                                if (!string.IsNullOrEmpty(mobile3))
                                                {
                                                    string[] method3s = method3.Split(',');
                                                    string[] man3s = man3.Split(',');
                                                    string[] manName3s = manName3.Split(',');
                                                    string[] mobile3s = mobile3.Split(',');
                                                    int num3 = 0;
                                                    for (int i = 0; i < method3s.Length; i++)
                                                    {
                                                        string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                        if ("����".Equals(method3s[i]))
                                                        {
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                              continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                            num3++;
                                                        }
                                                        else if ("΢��".Equals(method3s[i]))
                                                        {
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            //web.SendAlarmNews(newsArticle, man3s[i],WXAlarmInfoId);
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                            num3++;
                                                        }
                                                        else if ("ȫ��".Equals(method3s[i]))
                                                        {
                                                            web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                            SendMessageByHttpPost(mobile3s[i], message);
                                                          
                                                            insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                             continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                            num3++;
                                                        }
                                                        else
                                                        {
                                                            num3++;
                                                        }
                                                    }
                                                  
                                                        updateRealMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_MsgMark", ID, "3", "AbnormalStateRealTime_NormalMsgMark");
                                                 



                                                }

                                            }
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }



        /// <summary>
        /// ��ѯ����������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAlarmNormalInfo_new_ys()
        {

            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalRealTime_TagID,t.AbnormalRealTime_SendMessage,t.AbnormalRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalRealTime_TagName,t.AbnormalRealTime_Desc,t.AbnormalRealTime_State,t.AbnormalRealTime_StartTime,");
                    alarmSql.Append("t.AbnormalRealTime_SustainTime,t.AbnormalRealTime_Value");
                    alarmSql.Append(" from RTResEx_AbnormalRealTime t where t.AbnormalRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalRealTime_SustainTime"]);

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalAlarmConfig_StartTime1,t.AbnormalAlarmConfig_StartMen1,t.AbnormalAlarmConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime2,t.AbnormalAlarmConfig_StartMen2,t.AbnormalAlarmConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalAlarmConfig_StartTime3,t.AbnormalAlarmConfig_StartMen3,t.AbnormalAlarmConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalAlarmConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalAlarmConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalAlarmConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                           
                                                updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                          

                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                      
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                       

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "����", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else
                                                {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalRealTime", "AbnormalRealTime_NormalMsgMark", ID, "AbnormalRealTime_MsgMark", "AbnormalRealTime_IsConfirm");
                                        
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯԤ��������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendEarlyAlarmNormalInfo_new_ys()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalEarlyRealTime_TagID,t.AbnormalEarlyRealTime_SendMessage,t.AbnormalEarlyRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalEarlyRealTime_TagName,t.AbnormalEarlyRealTime_Desc,t.AbnormalEarlyRealTime_State,");
                    alarmSql.Append("t.AbnormalEarlyRealTime_StartTime,t.AbnormalEarlyRealTime_SustainTime,t.AbnormalEarlyRealTime_Value");
                    alarmSql.Append(" from RTResEx_AbnormalEarlyRealTime t where t.AbnormalEarlyRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalEarlyRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_State"]);
                            String realValue = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_Value"]);
                            String startTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalEarlyRealTime_SustainTime"]);

                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalEarlyWarnConfig_StartTime1,t.AbnormalEarlyWarnConfig_StartMen1,t.AbnormalEarlyWarnConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime2,t.AbnormalEarlyWarnConfig_StartMen2,t.AbnormalEarlyWarnConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalEarlyWarnConfig_StartTime3,t.AbnormalEarlyWarnConfig_StartMen3,t.AbnormalEarlyWarnConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalEarlyWarnConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalEarlyWarnConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalEarlyWarnConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                          
                                                updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                            


                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                       
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                       

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "Ԥ��", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else
                                                {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                       
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalEarlyRealTime", "AbnormalEarlyRealTime_NormalMsgMark", ID, "AbnormalEarlyRealTime_MsgMark", "AbnormalEarlyRealTime_IsConfirm");
                                       
                                    }


                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ��ѯ�쳣������ʵʱ��Ϣ--����΢�źͶ���Ϣ
        /// </summary>
        /// <returns></returns>
        public void sendAbnormalStateNormalInfo_new_ys()
        {
            //���ʱ��ִ��ĳ����  
            WXWeb.WXService web = new WXWeb.WXService();

            //��ѯװ����Ϣ
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	m.SYS_MENU_NAME,");
            sql.Append("	m.SYS_MENU_URL");
            sql.Append(" FROM  PSOGSYS_PlantInfo p");
            sql.Append(" INNER JOIN PSOGSYS_PermissionMenu m ON p.PlantInfo_PlantCode = m.SYS_MENU_URL");
            sql.Append(" AND p.IsUse = '1'");
            sql.Append(" AND m.SYS_MENU_P_CODE = 'plant'");
            IDao dao = new Dao();
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    String plantId = BeanTools.ObjectToString(dr["SYS_MENU_URL"]);
                    String plantName = BeanTools.ObjectToString(dr["SYS_MENU_NAME"]);

                    StringBuilder alarmSql = new StringBuilder();
                    alarmSql.Append("select t.ID,t.AbnormalStateRealTime_TagID,AbnormalStateRealTime_SendMessage,AbnormalStateRealTime_MsgMark, ");
                    alarmSql.Append("t.AbnormalStateRealTime_TagName,t.AbnormalStateRealTime_Desc,t.AbnormalStateRealTime_State,");
                    alarmSql.Append("t.AbnormalStateRealTime_StartTime,t.AbnormalStateRealTime_SustainTime");
                    alarmSql.Append(" from RTResEx_AbnormalStateRealTime t where t.AbnormalStateRealTime_NormalMsgMark='0'");
                    alarmSql.Append(" and t.AbnormalStateRealTime_State='����'");
                    alarmSql.Append(" and t.AbnormalStateRealTime_SustainTime>=10");
                    Plant plant = BeanTools.getPlantDB(plantId);
                    Dao innerDao = new Dao(plant, false);
                    DataSet innerDs = innerDao.executeQuery(alarmSql.ToString());
                    if (BeanTools.DataSetIsNotNull(innerDs))
                    {
                        foreach (DataRow drr in innerDs.Tables[0].Rows)
                        {
                            String ID = BeanTools.ObjectToString(drr["ID"]);
                            String tagId = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagID"]);
                            String message = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SendMessage"]);
                            String msgMark = BeanTools.ObjectToString(drr["AbnormalStateRealTime_MsgMark"]);

                            String tagName = BeanTools.ObjectToString(drr["AbnormalStateRealTime_TagName"]);
                            String tagDesc = BeanTools.ObjectToString(drr["AbnormalStateRealTime_Desc"]);
                            String tagState = BeanTools.ObjectToString(drr["AbnormalStateRealTime_State"]);
                            String realValue = "0";
                            String startTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_StartTime"]);
                            String continueTime = BeanTools.ObjectToString(drr["AbnormalStateRealTime_SustainTime"]);
                            //��ѯ������Ϣ
                            StringBuilder ruleSql = new StringBuilder();
                            ruleSql.Append("select t.AbnormalStateConfig_StartTime1,t.AbnormalStateConfig_StartMen1,t.AbnormalStateConfig_StartMenName1,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime2,t.AbnormalStateConfig_StartMen2,t.AbnormalStateConfig_StartMenName2,");
                            ruleSql.Append("t.AbnormalStateConfig_StartTime3,t.AbnormalStateConfig_StartMen3,t.AbnormalStateConfig_StartMenName3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0 for xml path('')), 1, 1, '') as mobile1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen1)>0  for xml path('')), 1, 1, '') as sendMethod1,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0 for xml path('')), 1, 1, '') as mobile2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen2)>0  for xml path('')), 1, 1, '') as sendMethod2,");
                            ruleSql.Append("stuff((select ',' +u.SYS_USER_TELPHONE from PSOGSYS_PermissionUser u ");
                            ruleSql.Append(" where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0 for xml path('')), 1, 1, '') as mobile3,");
                            ruleSql.Append("stuff((select ',' +u.SYS_Message_Method from PSOGSYS_PermissionUser u ");
                            ruleSql.Append("where  CHARINDEX(u.ID,t.AbnormalStateConfig_StartMen3)>0  for xml path('')), 1, 1, '') as sendMethod3");
                            ruleSql.AppendFormat(" from {0}.dbo.PSOG_AbnormalStateConfig t where t.ID='{1}'", plant.historyDB, tagId);
                            Dao ruleDao = new Dao();
                            DataSet ruleDs = ruleDao.executeQuery(ruleSql.ToString());
                            if (BeanTools.DataSetIsNotNull(ruleDs))
                            {
                                foreach (DataRow ruleDr in ruleDs.Tables[0].Rows)
                                {
                                    String time1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime1"]);
                                    String man1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen1"]);
                                    String manName1 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName1"]);
                                    String time2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime2"]);
                                    String man2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen2"]);
                                    String manName2 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName2"]);
                                    String time3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartTime3"]);
                                    String man3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMen3"]);
                                    String manName3 = BeanTools.ObjectToString(ruleDr["AbnormalStateConfig_StartMenName3"]);
                                    String mobile1 = BeanTools.ObjectToString(ruleDr["mobile1"]);
                                    String mobile2 = BeanTools.ObjectToString(ruleDr["mobile2"]);
                                    String mobile3 = BeanTools.ObjectToString(ruleDr["mobile3"]);
                                    string method1 = BeanTools.ObjectToString(ruleDr["sendMethod1"]);
                                    string method2 = BeanTools.ObjectToString(ruleDr["sendMethod2"]);
                                    string method3 = BeanTools.ObjectToString(ruleDr["sendMethod3"]);
                                    //����Ϣ
                                    if ("1".Equals(msgMark))
                                    {

                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                          
                                                updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                          

                                        }

                                    }
                                    else if ("2".Equals(msgMark))
                                    {
                                        string sendMark2 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                 
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark2 = "1";
                                            }

                                        }
                                      
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                       

                                    }
                                    else if ("3".Equals(msgMark))
                                    {
                                        string sendMark3 = "0";
                                        if (!string.IsNullOrEmpty(mobile1) && !string.IsNullOrEmpty(man1))
                                        {
                                            string[] method1s = method1.Split(',');
                                            string[] man1s = man1.Split(',');
                                            string[] manName1s = manName1.Split(',');
                                            string[] mobile1s = mobile1.Split(',');
                                            int num1 = 0;
                                            for (int i = 0; i < method1s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method1s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "����");
                                                    num1++;
                                                }
                                                else if ("΢��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "΢��");
                                                    num1++;
                                                }
                                                else if ("ȫ��".Equals(method1s[i]))
                                                {
                                                    web.SendInfoToUser(man1s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile1s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                        continueTime, realValue, man1s[i], manName1s[i], nowDate, message, "ȫ��");
                                                    num1++;
                                                }
                                                else
                                                {
                                                    num1++;
                                                }
                                            }
                                            if (num1 == method1s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile2) && !string.IsNullOrEmpty(man2))
                                        {
                                            string[] method2s = method2.Split(',');
                                            string[] man2s = man2.Split(',');
                                            string[] manName2s = manName2.Split(',');
                                            string[] mobile2s = mobile2.Split(',');
                                            int num2 = 0;
                                            for (int i = 0; i < method2s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method2s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "����");
                                                    num2++;
                                                }
                                                else if ("΢��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                       continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "΢��");
                                                    num2++;
                                                }
                                                else if ("ȫ��".Equals(method2s[i]))
                                                {
                                                    web.SendInfoToUser(man2s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile2s[i], message);
                                                   
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man2s[i], manName2s[i], nowDate, message, "ȫ��");
                                                    num2++;
                                                }
                                                else
                                                {
                                                    num2++;
                                                }
                                            }
                                            if (num2 == method2s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        if (!string.IsNullOrEmpty(mobile3) && !string.IsNullOrEmpty(man3))
                                        {
                                            string[] method3s = method3.Split(',');
                                            string[] man3s = man3.Split(',');
                                            string[] manName3s = manName3.Split(',');
                                            string[] mobile3s = mobile3.Split(',');
                                            int num3 = 0;
                                            for (int i = 0; i < method3s.Length; i++)
                                            {
                                                string nowDate = DateTime.Now.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss");
                                                if ("����".Equals(method3s[i]))
                                                {
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                      continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "����");
                                                    num3++;
                                                }
                                                else if ("΢��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "΢��");
                                                    num3++;
                                                }
                                                else if ("ȫ��".Equals(method3s[i]))
                                                {
                                                    web.SendInfoToUser(man3s[i], message, WXAlarmInfoId);
                                                    SendMessageByHttpPost(mobile3s[i], message);
                                                  
                                                    insertMessageRecord(plant, ID, tagName, tagDesc, "�쳣", tagState, startTime,
                                                     continueTime, realValue, man3s[i], manName3s[i], nowDate, message, "ȫ��");
                                                    num3++;
                                                }
                                                else
                                                {
                                                    num3++;
                                                }
                                            }
                                            if (num3 == method3s.Length)
                                            {
                                                sendMark3 = "1";
                                            }

                                        }
                                        
                                            updateRealNormalMesMark(innerDao, "RTResEx_AbnormalStateRealTime", "AbnormalStateRealTime_NormalMsgMark", ID, "AbnormalStateRealTime_MsgMark", "AbnormalStateRealTime_IsConfirm");
                                       
                                    }


                                }
                            }

                        }
                    }

                }
            }
        }


        /// <summary>
        /// ���ر������ͼ�μ�¼
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public EasyUIData queryAlarmGraphicRecordList(string plantId)
        {
            EasyUIData grid = new EasyUIData();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.PicId,");
            sql.Append("	t.PicName,");
            sql.Append("	t.PicNum");
            sql.Append(" FROM PSOG_Abnormal_Graphic_Manage t");
            sql.Append(" order by t.PicNum");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    AlarmGraphicRecord record = new AlarmGraphicRecord();
                    record.PicId = BeanTools.ObjectToString(dr["PicId"]);
                    record.PicName = BeanTools.ObjectToString(dr["PicName"]);
                    record.PicNum = BeanTools.ObjectToInt(dr["PicNum"]);
                    grid.rows.Add(record);
                }
            }
            return grid;
        }

        /// <summary>
        /// �����ļ�
        /// </summary>
        /// <param name="sheetId"></param>
        /// <param name="fileName"></param>
        /// <param name="filePath"></param>
        public void SaveFiles(string plantId,string sheetId,string fileName,string filePath) {
            StringBuilder sql = new StringBuilder();
            sql.Append("insert PSOG_SYS_FILES(ANNEXID,ANNEXNAME,ANNEXPATH,SHEETID) ");
            sql.AppendFormat(" values('{0}','{1}','{2}','{3}')", Guid.NewGuid().ToString(), fileName, filePath, sheetId);
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
            }
            catch (Exception e)
            {

            }
        }

       /// <summary>
       /// �����¼
       /// </summary>
       /// <param name="plantId"></param>
       /// <param name="PicId"></param>
       /// <param name="PicName"></param>
       /// <param name="PicNum"></param>
       /// <returns></returns>
        public string SaveGraphicRecord(string plantId, string PicId, string PicName, int PicNum, string saveOrUpdate)
        {
            StringBuilder sql = new StringBuilder();
            if ("0".Equals(saveOrUpdate))
            {//����
                sql.Append("insert PSOG_Abnormal_Graphic_Manage(PicId,PicName,PicNum) ");
                sql.AppendFormat(" values('{0}','{1}',{2})", PicId, PicName, PicNum);
            }
            else { //����
                sql.Append("update PSOG_Abnormal_Graphic_Manage set ");
                sql.AppendFormat(" PicName='{0}',PicNum={1}", PicName,PicNum);
                sql.AppendFormat(" where PicId='{0}'", PicId);
            }
            
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯ�ļ�
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="sheetId"></param>
        /// <returns></returns>
        public ArrayList queryFileList(string plantId, string sheetId)
        {
            ArrayList grid = new ArrayList();

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ANNEXID,");
            sql.Append("	t.ANNEXNAME,");
            sql.Append("	t.ANNEXPATH");
            sql.Append(" FROM PSOG_SYS_FILES t");
            sql.AppendFormat(" where SHEETID='{0}'",sheetId);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    FileInfoRecord record = new FileInfoRecord();
                    record.ANNEXID = BeanTools.ObjectToString(dr["ANNEXID"]);
                    record.ANNEXNAME = BeanTools.ObjectToString(dr["ANNEXNAME"]);
                    record.ANNEXPATH = BeanTools.ObjectToString(dr["ANNEXPATH"]);
                    grid.Add(record);
                }
            }
            return grid;
        }

        /// <summary>
        /// ��ѯ�ļ�·��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="AnnexId"></param>
        /// <returns></returns>
        public string queryFilePath(string plantId, string AnnexId)
        {
            string filePath = "";
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ANNEXPATH");
            sql.Append(" FROM PSOG_SYS_FILES t");
            sql.AppendFormat(" where ANNEXID='{0}'", AnnexId);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    filePath = BeanTools.ObjectToString(dr["ANNEXPATH"]);
                }
            }
            return filePath;
        }

        /// <summary>
        /// ɾ���ļ���¼
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="AnnexId"></param>
        /// <returns></returns>
        public string delFile(string plantId, string AnnexId)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("delete from PSOG_SYS_FILES ");
            sql.AppendFormat(" where ANNEXID='{0}'", AnnexId);
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }


        /// <summary>
        /// ��ѯ���ļ���·��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="AnnexId"></param>
        /// <returns></returns>
        public List<string> queryFilesPath(string plantId, List<string> AnnexIdList)
        {
            List<string> pathList = new List<string>();
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append(" t.ANNEXPATH");
            sql.Append(" FROM PSOG_SYS_FILES t");
            sql.Append(" where SHEETID in(");
            foreach (string AnnexId in AnnexIdList)
            {
                sql.Append("'").Append(AnnexId).Append("',");
            }
            string selSql = sql.ToString();
            selSql = selSql.Substring(0,selSql.Length-1)+")";

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(selSql);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string filePath = BeanTools.ObjectToString(dr["ANNEXPATH"]);
                    pathList.Add(filePath);
                }
            }
            return pathList;
        }

        /// <summary>
        /// ɾ��ͼ�μ�¼
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="recordList"></param>
        /// <returns></returns>
        public string delGraphicRecord(string plantId, List<string> recordList)
        {
            StringBuilder idSb = new StringBuilder();
            idSb.Append("'");
            foreach (string recordId in recordList) {
                idSb.Append(recordId).Append("',");
            }
            string idStr = idSb.ToString();
            idStr = idStr.Substring(0,idStr.Length-1);

            //ɾ����¼
            StringBuilder delRecordSql = new StringBuilder();
            delRecordSql.Append("delete from PSOG_Abnormal_Graphic_Manage where PicId in(");
            delRecordSql.Append(idStr).Append(")");
            //ɾ������
            StringBuilder sql = new StringBuilder();
            sql.Append("delete from PSOG_Abnormal_Graphic_Point where PicId in(");
            sql.Append(idStr).Append(")");

            //ɾ���ļ�
            StringBuilder delFileSql = new StringBuilder();
            delFileSql.Append("delete from PSOG_SYS_FILES where SHEETID in(");
            delFileSql.Append(idStr).Append(")");

            List<string> sqlList = new List<string>();
            sqlList.Add(delRecordSql.ToString());
            sqlList.Add(sql.ToString());
            sqlList.Add(delFileSql.ToString());
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQueryList(sqlList);

                //ɾ���ļ�
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }


        /// <summary>
        /// ��ѯ�ļ�·��
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="AnnexId"></param>
        /// <returns></returns>
        public string queryFilePathBySheetId(string plantId, string SheetId)
        {
            string filePath = "";
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append("	t.ANNEXPATH");
            sql.Append(" FROM PSOG_SYS_FILES t");
            sql.AppendFormat(" where SHEETID='{0}'", SheetId);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    filePath = BeanTools.ObjectToString(dr["ANNEXPATH"]);
                }
            }
            return filePath;
        }


        /// <summary>
        /// ͼ��ά��--��ѯ��ѡ���λ��
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="tagName"></param>
        /// <param name="deviceName"></param>
        /// <returns></returns>
        public EasyUIData queryGraphicSelectingBit(string plantId, String tagName, String deviceName, int pageNo, int pageSize)
        {
            EasyUIData grid = new EasyUIData();

           
            StringBuilder sql = new StringBuilder();
            //��ѯ�ĸ���
            sql.Append("select ins.Instrumentation_Code,ins.Instrumentation_Name,");
            sql.Append("count(1) over() bitCount");
            sql.Append(" from PSOG_Instrumentation ins where ins.IsDelete='0' and ins.Instrumentation_Type=1");
            sql.Append(" and not EXISTS ");
            sql.Append(" (select p.BitNo from PSOG_Abnormal_Graphic_Point p where p.BitNo=ins.Instrumentation_Code) ");
           

            //λ��
            if (!string.IsNullOrEmpty(tagName))
            {
                sql.Append(string.Format(" and ins.Instrumentation_Code like '{0}'", "%" + tagName + "%"));
            }
            //װ��
            if (!string.IsNullOrEmpty(deviceName))
            {
                sql.Append(string.Format(" and ins.Instrumentation_Name like '{0}'", "%" + deviceName + "%"));
            }
            sql.Append(" order by ins.Instrumentation_Code");


            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);

            DataSet ds = dao.executeQuery(sql.ToString(), pageNo, pageSize);
            if (BeanTools.DataSetIsNotNull(ds))
            {
                grid.total = BeanTools.ObjectToInt(ds.Tables[0].Rows[0]["bitCount"]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    BitDevice bit = new BitDevice();
                    bit.bitNo = BeanTools.ObjectToString(dr["Instrumentation_Code"]);
                    bit.deviceName = BeanTools.ObjectToString(dr["Instrumentation_Name"]);
                    grid.rows.Add(bit);
                }
            }
            return grid;
        }

        //����ͼ�μ���
        public string SaveGraphicPoint(string plantId, string pointId, string pointX, string pointY, string bitNo, string picId,string saveOrUpdate)
        {
            StringBuilder sql = new StringBuilder();
            if ("0".Equals(saveOrUpdate))
            {//����
                sql.Append("insert PSOG_Abnormal_Graphic_Point(PointId,PointX,PointY,BitNo,PicId) ");
                sql.AppendFormat(" values('{0}','{1}','{2}','{3}','{4}')", pointId, pointX, pointY, bitNo, picId);
            }
            else
            { //����
                sql.Append("update PSOG_Abnormal_Graphic_Point set ");
                sql.AppendFormat(" PointX='{0}',PointY='{1}',BitNo='{2}'", pointX, pointY, bitNo);
                sql.AppendFormat(" where PicId='{0}'", picId);
            }

            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯͼ��ά�������
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="picId"></param>
        /// <returns></returns>
        public List<GraphicPoint> queryGraphicPoints(string plantId, string picId)
        {
            List<GraphicPoint> list = new List<GraphicPoint>();
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append(" t.PointId,");
            sql.Append(" t.PointX,");
            sql.Append(" t.PointY,");
            sql.Append(" t.BitNo");
            sql.Append(" FROM PSOG_Abnormal_Graphic_Point t");
            sql.AppendFormat(" where t.PicId ='{0}'",picId);
           
            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    GraphicPoint point = new GraphicPoint();
                    point.PointId = BeanTools.ObjectToString(dr["PointId"]);
                    point.PointX = BeanTools.ObjectToString(dr["PointX"]);
                    point.PointY = BeanTools.ObjectToString(dr["PointY"]);
                    point.BitNo = BeanTools.ObjectToString(dr["BitNo"]);
                    list.Add(point);
                }
            }
            return list;
        }

        /// <summary>
        /// ��ѯѡ��Χ�ڵļ���
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="startX"></param>
        /// <param name="endX"></param>
        /// <param name="startY"></param>
        /// <param name="endY"></param>
        /// <returns></returns>
        public List<GraphicPoint> querySelectPoints(string plantId, string startX,string endX,string startY,string endY)
        {
            List<GraphicPoint> list = new List<GraphicPoint>();
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT");
            sql.Append(" t.PointId,");
            sql.Append(" t.PointX,");
            sql.Append(" t.PointY,");
            sql.Append(" t.BitNo");
            sql.Append(" FROM PSOG_Abnormal_Graphic_Point t");
            sql.AppendFormat(" where cast(t.PointX as FLOAT) >={0} and cast(t.PointX as FLOAT)<={1}", startX, endX);
            sql.AppendFormat(" and cast(t.PointY as FLOAT)>={0} and cast(t.PointY as FLOAT)<={1}", startY, endY);

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    GraphicPoint point = new GraphicPoint();
                    point.PointId = BeanTools.ObjectToString(dr["PointId"]);
                    point.PointX = BeanTools.ObjectToString(dr["PointX"]);
                    point.PointY = BeanTools.ObjectToString(dr["PointY"]);
                    point.BitNo = BeanTools.ObjectToString(dr["BitNo"]);
                    list.Add(point);
                }
            }
            return list;
        }

        /// <summary>
        /// ɾ��Ȧѡ��Χ�ڵļ���
        /// </summary>
        /// <param name="plantId"></param>
        /// <param name="startX"></param>
        /// <param name="endX"></param>
        /// <param name="startY"></param>
        /// <param name="endY"></param>
        /// <returns></returns>
        public string delPoints(string plantId, string startX, string endX, string startY, string endY)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("delete from PSOG_Abnormal_Graphic_Point ");
            sql.AppendFormat(" where cast(PointX as float) >={0} and cast(PointX as float)<={1}", startX, endX);
            sql.AppendFormat(" and cast(PointY as float)>={0} and cast(PointY as float)<={1}", startY, endY);
            try
            {
                Plant plant = BeanTools.getPlantDB(plantId);
                Dao dao = new Dao(plant, true);
                dao.executeNoQuery(sql.ToString());
                return "1";
            }
            catch (Exception e)
            {
                return "0";
            }
        }

        /// <summary>
        /// ��ѯװ���µ�����ͼƬ·��
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public List<Dictionary<string,string>> queryPlantAllGraphics(string plantId)
        {
            List<Dictionary<string,string>> pathList = new List<Dictionary<string,string>>();
            StringBuilder sql = new StringBuilder();
            sql.Append("select m.PicId,f.ANNEXPATH from PSOG_Abnormal_Graphic_Manage m");
            sql.Append(" inner join PSOG_SYS_FILES f on m.PicId=f.SHEETID order by m.PicNum");

            Plant plant = BeanTools.getPlantDB(plantId);
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>();
                    string picId = BeanTools.ObjectToString(dr["PicId"]);
                    string filePath = BeanTools.ObjectToString(dr["ANNEXPATH"]);
                    dict.Add("picId",picId);
                    dict.Add("picPath",filePath);
                    pathList.Add(dict);
                }
            }
            return pathList;
        }


        /// <summary>
        /// ��ȡͼ�μ����Ϣ
        /// </summary>
        /// <param name="plantId"></param>
        /// <returns></returns>
        public Dictionary<string,Dictionary<string,List<Dictionary<string,string>>>> queryGraphicMonitorInfo(string plantId){
            Dictionary<string, Dictionary<string, List<Dictionary<string, string>>>> dict = new Dictionary<string, Dictionary<string, List<Dictionary<string, string>>>>();

            Plant plant = BeanTools.getPlantDB(plantId);
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT m.PicId,");
            sql.Append("       p.PointId,");
            sql.Append("       p.BitNo,");
            sql.Append("       p.PointX,");
            sql.Append("       p.PointY,");
            sql.Append("       r.RTResEx_AlarmRealTime_Items,");
            sql.Append("       it.Instrumentation_Name as RTResEx_AlarmRealTime_Describe,");
            sql.Append("       r.RTResEx_AlarmRealTime_Value,");
            sql.Append("       r.RTResEx_AlarmRealTime_State,");
            sql.Append("       r.RTResEx_AlarmRealTime_StartTime,");
            sql.Append("       r.RTResEx_AlarmRealTime_DurationMin");
            sql.Append("  FROM PSOG_Abnormal_Graphic_Manage m");
            sql.Append(" INNER JOIN PSOG_Abnormal_Graphic_Point p");
            sql.Append("    ON m.PicId = p.PicId");
            sql.AppendFormat("  LEFT JOIN {0}.dbo.RTResEx_AlarmRealTime r",plant.realTimeDB);
            sql.Append("    ON p.BitNo = r.RTResEx_AlarmRealTime_Items");
            sql.Append(" INNER JOIN PSOG_Instrumentation it on p.BitNo = it.Instrumentation_Code");
            sql.Append(" ORDER BY m.PicId");
            Dao dao = new Dao(plant, true);
            DataSet ds = dao.executeQuery(sql.ToString());
            if (BeanTools.DataSetIsNotNull(ds))
            {
                string picId = "";
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string tempPicId = BeanTools.ObjectToString(dr["PicId"]);
                    string pointId = BeanTools.ObjectToString(dr["PointId"]);
                    string bitNo = BeanTools.ObjectToString(dr["BitNo"]);
                    string pointX = BeanTools.ObjectToString(dr["PointX"]);
                    string pointY = BeanTools.ObjectToString(dr["PointY"]);
                    string bitItem = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Items"]);
                    string bitDes = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Describe"]);
                    string alarmValue = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_Value"]);
                    string alarmState = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_State"]);
                    string alarmStartTime = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_StartTime"]);
                    string alarmInterval = BeanTools.ObjectToString(dr["RTResEx_AlarmRealTime_DurationMin"]);

                    Dictionary<string, string> pointDict = new Dictionary<string, string>();
                    pointDict.Add("pointId", pointId);
                    pointDict.Add("bitNo",bitNo);
                    pointDict.Add("pointX", pointX);
                    pointDict.Add("pointY", pointY);
                    pointDict.Add("bitDes", bitDes);
                    pointDict.Add("alarmValue", alarmValue);
                    pointDict.Add("alarmState", alarmState);
                    pointDict.Add("alarmStartTime", alarmStartTime);
                    pointDict.Add("alarmInterval", alarmInterval);

            
                    if (tempPicId.Equals(picId))
                    {
                        Dictionary<string, List<Dictionary<string, string>>> recordDict = dict[""+picId];
                        if (string.IsNullOrEmpty(bitItem))
                        {//����
                            List<Dictionary<string, string>> pointList = recordDict["normal"];
                            pointList.Add(pointDict);
                        }
                        else
                        {//����
                            List<Dictionary<string, string>> pointList = recordDict["alarm"];
                            pointList.Add(pointDict);
                        }
                    }
                    else {
                        picId = tempPicId;
                        List<Dictionary<string, string>> normalList = new List<Dictionary<string, string>>();//���� 
                        List<Dictionary<string, string>> alarmList = new List<Dictionary<string, string>>();//�쳣
                        Dictionary<string,List<Dictionary<string, string>>> recordDict = new Dictionary<string,List<Dictionary<string, string>>>();
                        if (string.IsNullOrEmpty(bitItem))
                        {//����
                            normalList.Add(pointDict);
                        }
                        else
                        {//����
                            alarmList.Add(pointDict);
                        }
                        recordDict.Add("normal", normalList);
                        recordDict.Add("alarm", alarmList);
                        dict.Add(picId,recordDict);
                    }
                }
            }

            return dict;
        }



    }
}
