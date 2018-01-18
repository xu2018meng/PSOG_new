using System;
using System.Collections.Generic;
using System.Text;

namespace PSOG.Entity
{
    class SysManage
    {
    }

    public class Menu
    {
        public string id;
    }


    [Serializable]
    public class SysUser 
    {
        public string userName;
        public string userLoginName;
        public string userPassword;
        public string userIp;
        public string userOrganId;
        public string userDeptId;
        public string userId;
        public string userWeiXin;
        public string userTel;
        public string userSendMessage;
    }

    [Serializable]
    public class SysRole
    {
        public string roleName;
        public string roleCode;
        public string roleIndex;
        public string roleId;
    }

    [Serializable]
    public class SysMenu
    {
        public string menuName;
        public string menuCode;
        public string menuIndex;
        public string menuId;
        public string menuUrl;
    }

    //位号装置
    [Serializable]
    public class BitDevice {
        public string bitId;
        public string bitNo;//位号
        public string deviceName;//描述
        public string typeName;//类型
        public string realValue;//实时值
        public string status;//状态
        public string isConfirm;//是否确认
        public string belongLineId;//位号所属工段ID
        public string belongDeviceId;//位号所属设备ID
    }

    //设备监测指数
    public class DeviceIndex {
        public string pkId;
        public string deviceId;
        public string deviceName;
        public string deviceDesc;
        public string runIndex;
        public string alarmIndex;
        public string earlyAlarmIndex;
    }

    //工段设备
    public class SectionDevice {
        public string sectionId;
        public string sectionName;
        public string sectionDesc;
        public string sectionMark;
        public string sectionEditUserId;
        public string sectionEditDate;
    }

    //设备报警限
    public class AlarmLimit {
        public string limitId;
        public string limitBitCode;
        public string limitDCSCode;
        public string limitBitName;
        public string limitUnit;
        public string limitType;
        public string limitLineId;
        public string limitLineName;
        public string limitDeviceId;
        public string limitDeviceName;
        public string limitUpLine;
        public string limitDownLine;
        public string limitHHigh;
        public string limitHigh;
        public string limitLow;
        public string limitLLow;
        public string limitEditDate;
        public string limitRemark;
        public string limitParamRank;
    }

    //工艺参数记录
    public class CraftParamRecord {
        public string craftId;
        public string craftParamRank;
        public string craftParamName;
        public string craftParamBitCode;
        public string craftUnit;
        public string craftAlarmType;
        public string craftKPI;
        public string craftBeforeValue;
        public string craftAfterValue;
        public string craftReason;
        public string craftDate;
        public string craftRemark;
        public string craftControlRange;
    }

    //参数变更过程表
    public class CraftProcess {
        public string processId;
        public string processApplyDate;
        public string processExecuteDate;
        public string processRecoverDate;
        public string processReason;
        public string processProtectMeasure;
        public string processToProductExamId;
        public string processToProductExamName;
        public string processToMeterExamId;
        public string processToMeterExamName;
        public string processToSatrapExamId;
        public string processToSatrapExamName;
        public string processPlantName;
        public string processProductExamIdea;
        public string processMeterExamIdea;
        public string processSatrapExamIdea;
        public string processStatus;
    }

    //参数变更过程子表
    public class CraftProcessChild {
        public string processChildId;
        public string processChildBitCode;
        public string processChildParamName;
        public string processChildUnit;
        public string processChildControlRange;
        public string processChildKPI;
        public string processChildAlarmType;
        public string processChildBeforeValue;
        public string processChildAfterValue;
    }

    //DSC报警日志
    public class DCSAlarmLog {
        public string alarmLogId;
        public string alarmLogBitCode;
        public string alarmLogDescribe;
        public string alarmLogState;
        public string alarmLogStartTime;
        public string alarmLogEndTime;
        public string alarmLogRank;
    }

    //HAZOP参数
    public class HazopParam {
        public string hazopId;
        public string hazopBitId;
        public string hazopReason;
        public string hazopI;
        public string hazopMeasure;
        public string hazopBiasValue;
        public string hazopRR;
        public string hazopF;
        public string hazopS;
        public string hazopConseq;
        public string hazopPrevent;
    }

    //微信报表推送配置信息
    public class WXReportConfig {
        public string WXReportConfigId;
        public string WXReportConfigToUserId;
        public string WXReportConfigToUserName;
    }

    //报警信息推送的记录
    public class AlarmMessageRecord {
        public string MessageRecordId;
        public string MessageRecordTagName;
        public string MessageRecordTagDesc;
        public string MessageRecordType;
        public string MessageRecordState;
        public string MessageRecordStartDate;
        public string MessageRecordSustainTime;
        public string MessageRecordValue;
        public string MessageRecordSendDate;
        public string MessageRecordToUserName;
        public string MessageRecordSendMethod;
    }

    //报警图形监控维护记录
    public class AlarmGraphicRecord
    {
        public string PicId;
        public string PicName;
        public int PicNum;

    }

    //文件
    public class FileInfoRecord
    {
        public string ANNEXID;
        public string ANNEXNAME;
        public string ANNEXPATH;
        public string SHEETID;

    }

    //图形监控点信息
    public class GraphicPoint
    {
        public string PointId;
        public string PointX;
        public string PointY;
        public string BitNo;
    }


}
