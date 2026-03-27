//
//  SettingDefine.h
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/12.
//  Copyright © 2017年 美超刘. All rights reserved.
//

#ifndef SettingDefine_h
#define SettingDefine_h


#define ColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define KKKK @"2222"

#define Resource @"black"
#define IsBlack 1

#define TYRESULTSELETOR @"ResultSeletor"
#define TYREQUESTINDEX @"TYrequestIndex"
#define RequestSuccess @"RequestSuccess"
#define RequestFail @"RequestFail"

#define HOSTLOCATION @"http://192.168.199.131:8080/sweep/"

/**
 获取版本信息及版本号
 */
#define SweeperUpdate @"file/NavigationUpdate.xml"


/**
 下载固件
 */
#define NavigationDownload @"file/navigation.tar"



#define GetXmppAccount @"account"

#define UploadLog @"line/lineLog"


#endif /* SettingDefine_h */
