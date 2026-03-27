//
//  MapVcGetUpXml.m
//  RobotSweeper
//
//  Created by Joey on 2018/9/12.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MapVcGetUpXml.h"
#import "XMLDictionary.h"

@implementation MapVcGetUpXml
//旧版
/**
+(void)getNewXml{

    NSString *strOfRobotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;

    NSString *typeS  = @"";
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if([[dicOfRobot allKeys] containsObject:@"eqOpfJid"] && [[dicOfRobot allKeys] containsObject:@"eqType"] ){//存在该字段再取
            if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
                typeS = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqType"]];
            }
        }
    }
    if (typeS.length==1) {
        typeS = [NSString stringWithFormat:@"0%@",typeS];
    }

    if([typeS isEqualToString:@"01"]){
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_monitor"];
         //请求监控 数据存到 ShareUser.sharedUserInfo().userMode.nowRobotJidMonitor

    }
    //属于同一type则可以不更新xml
    if ([[DataManager shareDataManager].appNowProductTypeNumStr isEqualToString:typeS]) {
//        return;//如果去掉这一句则无论什么品牌都每次都更新url
        //1213正式服都得在地图页获取xml
    }

    //清空当前s c版本
    [DataManager shareDataManager].lastNavigationVersion = @"--";
    [DataManager shareDataManager].lastFriewareVersion = @"--";

    //三位的型号ID
    NSString *eqSerialStr = @"";
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if([[dicOfRobot allKeys] containsObject:@"eqOpfJid"] && [[dicOfRobot allKeys] containsObject:@"eqSerial"] ){//存在该字段再取
            if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
                eqSerialStr = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqSerial"]];
            }
        }
    }

    //导航版
    NSString *slamStr = [DataManager shareDataManager].xmlOfMainSlam;
    //控制板
    NSString *ctrlStr = [DataManager shareDataManager].xmlOfMainCtrl;
    switch ([typeS intValue]) {
        case 1:
            if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfQg(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfQg(eqSerialStr);

            }else{//没有此格式的用测试服的xml地址
//                slamStr = S_cs_sweeperUpdateSlamXmlOfQg;
//                ctrlStr = S_cs_sweeperUpdateCtrlXmlOfQg;
                slamStr = @"";
                ctrlStr = @"";
            }

            break;
        case 2:
            if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfKw(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfKw(eqSerialStr);
            }else{//没有此格式的用测试服的xml地址
//                slamStr = S_cs_sweeperUpdateSlamXmlOfKw;
//                ctrlStr = S_cs_sweeperUpdateSlamXmlOfKw;
                slamStr = @"";
                ctrlStr = @"";
            }
            break;
        case 3:
             if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfBleam(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfBleam(eqSerialStr);
             }else{//没有此格式的用测试服的xml地址
//                 slamStr = S_cs_sweeperUpdateSlamXmlOfBleam;
//                 ctrlStr = S_cs_sweeperUpdateCtrlXmlOfBleam;
                 slamStr = @"";
                 ctrlStr = @"";
             }
            break;
        default:
            break;
    }

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    NSLog(@"--upVersionInfo---%f",sizeInMB);
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];

    if (slamStr.length<=0|| [slamStr isEqualToString:@""]|| ctrlStr.length<=0 ||[ctrlStr isEqualToString:@""]) {

        return;//没有地址不做请求
    }

    [[ToolOfNetWork sharedTools]needxml];
    [[ToolOfNetWork sharedTools]YrequestXmlURL:slamStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
        NSXMLParser *parserOfversions = responsObject;
        NSError *err = nil;
        NSDictionary *dicOfSlam = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversions];
        //           NSLog(@"uppppss-----%@ err=%@",dicOfSlam,err.debugDescription);
        if (err==nil) {
            NSLog(@" dicOfSlam %@",dicOfSlam);
            [DataManager shareDataManager].lastNavigationVersion = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"version"]];
            [DataManager shareDataManager].fileMD5OfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"md5"]];
            [DataManager shareDataManager].fileMuvOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"muv"]];
            [DataManager shareDataManager].fileMsgOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"msg"]];

        }

    }];
    [[ToolOfNetWork sharedTools]YrequestXmlURL:ctrlStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
        NSXMLParser *parserOfversionc = responsObject;
        NSError *err = nil;
        NSDictionary *dicOfCtrl = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversionc];
        //            NSLog(@"uppppsc-----%@ err=%@",dicOfCtrl,err.debugDescription);
        if (err==nil) {
             NSLog(@"dicOfCtrl %@",dicOfCtrl);
            DataManager.shareDataManager.lastFriewareVersion = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"version"]];
            [DataManager shareDataManager].fileMD5OfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"md5"]];
            [DataManager shareDataManager].fileMuvOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"muv"]];
            [DataManager shareDataManager].fileMsgOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"msg"]];

        }
    }];



}
*/

/**0110*/
+ (void)getNewXml{
    
    NSString *strOfRobotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    
    NSString *typeS  = @"";
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if([[dicOfRobot allKeys] containsObject:@"eqOpfJid"] && [[dicOfRobot allKeys] containsObject:@"eqType"] ){//存在该字段再取
            if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
                typeS = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqType"]];
            }
        }
    }
    if (typeS.length==1) {
        typeS = [NSString stringWithFormat:@"0%@",typeS];
    }
    
    //    if([typeS isEqualToString:@"01"]){01 310
    //        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_monitor"];
    //        //请求监控 数据存到 ShareUser.sharedUserInfo().userMode.nowRobotJidMonitor
    //
    //    }
    
    //清空当前s c版本
    [DataManager shareDataManager].lastNavigationVersion = @"--";
    [DataManager shareDataManager].lastFriewareVersion = @"--";
    
    //三位的型号ID
    NSString *eqSerialStr = @"";
    NSString *eqSN = @"";
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if([[dicOfRobot allKeys] containsObject:@"eqOpfJid"] && [[dicOfRobot allKeys] containsObject:@"eqSerial"] && [[dicOfRobot allKeys] containsObject:@"eqSN"] ){//存在该字段再取
            if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
                eqSerialStr = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqSerial"]];
                eqSN = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqSN"]];//1228
            }
            
        }
    }
    
    //导航版
    NSString *slamStr = [DataManager shareDataManager].xmlOfMainSlam;
    //控制板
    NSString *ctrlStr = [DataManager shareDataManager].xmlOfMainCtrl;
    NSString *slamStrT = @"";
    NSString *ctrlStrT = @"";
    switch ([typeS intValue]) {
        case 1:
            if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfQg(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfQg(eqSerialStr);
                slamStrT = S_sweeperUpdateSlamXmlOfQgT(eqSerialStr);
                ctrlStrT = S_sweeperUpdateCtrlXmlOfQgT(eqSerialStr);
                
            }else{//没有此格式的用测试服的xml地址
                //                slamStr = S_cs_sweeperUpdateSlamXmlOfQg;
                //                ctrlStr = S_cs_sweeperUpdateCtrlXmlOfQg;
                slamStr = @"";
                ctrlStr = @"";
            }
            
            break;
        case 2:
            if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfKw(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfKw(eqSerialStr);
                slamStrT = S_sweeperUpdateSlamXmlOfKwT(eqSerialStr);
                ctrlStrT = S_sweeperUpdateCtrlXmlOfKwT(eqSerialStr);
            }else{//没有此格式的用测试服的xml地址
                //                slamStr = S_cs_sweeperUpdateSlamXmlOfKw;
                //                ctrlStr = S_cs_sweeperUpdateSlamXmlOfKw;
                slamStr = @"";
                ctrlStr = @"";
            }
            break;
        case 3:
            if(![eqSerialStr isEqualToString:@""]){
                slamStr = S_sweeperUpdateSlamXmlOfBleam(eqSerialStr);
                ctrlStr = S_sweeperUpdateCtrlXmlOfBleam(eqSerialStr);
                slamStrT = S_sweeperUpdateSlamXmlOfBleamT(eqSerialStr);
                ctrlStrT = S_sweeperUpdateCtrlXmlOfBleamT(eqSerialStr);
            }else{//没有此格式的用测试服的xml地址
                //                 slamStr = S_cs_sweeperUpdateSlamXmlOfBleam;
                //                 ctrlStr = S_cs_sweeperUpdateCtrlXmlOfBleam;
                slamStr = @"";
                ctrlStr = @"";
            }
            break;
        default:
            break;
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    NSLog(@"--upVersionInfo---%f",sizeInMB);
    
    
    if (slamStr.length<=0|| [slamStr isEqualToString:@""]|| ctrlStr.length<=0 ||[ctrlStr isEqualToString:@""]) {
        return;//没有地址不做请求
    }
    __block int getCanAndCantNum=0;//初始
    __block BOOL boolSmalIsCan = NO;
    __block BOOL boolCtrlIsCan = NO;
    //是否为非稳定版
    __block BOOL smalIsBaseV = NO;
    __block BOOL ctrlIsBaseV = NO;
    //0103c
    
//    NSString *getVersionStatus =  S_XmlVCOfgetVersionStatus;
    NSString *getVersionStatus = S_XmlVCOfgetUpgradeStatus;
    //
    NSMutableDictionary *parmS = [NSMutableDictionary dictionary];
    [parmS setValue:eqSN forKey:@"SN"];
    [parmS setValue:@"1" forKey:@"versionType"];//合法有效值0(控制板)、1（导航版)
    [[ToolOfNetWork sharedTools]endXml];
    [[ToolOfNetWork sharedTools]YrequestURL:getVersionStatus withParams:parmS finished:^(id responsObject, NSError *error) {
        getCanAndCantNum+=1;
        if (_Success) {
            boolSmalIsCan = YES;
            if ([[responsObject allKeys]containsObject:@"upgradeType"]) {
                if ([[responsObject objectForKey:@"upgradeType"] intValue]==0){//0非正式时base版 1正式版
                    smalIsBaseV = YES;//非稳定版
                }else{
                    smalIsBaseV = NO;//稳定版
                }
                
            }
        }
        if (getCanAndCantNum>=2) {
            [self doXmlSalmXml:slamStr CtrlXml:ctrlStr SalmXmlT:slamStrT CtrlXmlT:ctrlStrT boolS:boolSmalIsCan boolC:boolCtrlIsCan isBaseSmal:smalIsBaseV isBaseCtrl:ctrlIsBaseV];
//            [self doXmlSalmXml:slamStr CtrlXml:ctrlStr boolS:boolSmalIsCan boolC:boolCtrlIsCan];
        }
    }];
    //
    NSMutableDictionary *parmC = [NSMutableDictionary dictionary];
    [parmC setValue:eqSN forKey:@"SN"];
    [parmC setValue:@"0" forKey:@"versionType"];//合法有效值0(控制板)、1（导航版)
    [[ToolOfNetWork sharedTools]endXml];
    [[ToolOfNetWork sharedTools]YrequestURL:getVersionStatus withParams:parmC finished:^(id responsObject, NSError *error) {
        getCanAndCantNum+=1;
        if (_Success) {
            boolCtrlIsCan = YES;
            if ([[responsObject allKeys]containsObject:@"upgradeType"]) {
                if ([[responsObject objectForKey:@"upgradeType"] intValue]==0) {//0非正式时base版 1正式版
                    ctrlIsBaseV = YES;//非稳定版
                }else{
                    ctrlIsBaseV = NO;
                }
            }
        }
       
        if (getCanAndCantNum>=2) {
//            [self doXmlSalmXml:slamStr CtrlXml:ctrlStr boolS:boolSmalIsCan boolC:boolCtrlIsCan];
            [self doXmlSalmXml:slamStr CtrlXml:ctrlStr SalmXmlT:slamStrT CtrlXmlT:ctrlStrT boolS:boolSmalIsCan boolC:boolCtrlIsCan isBaseSmal:smalIsBaseV isBaseCtrl:ctrlIsBaseV];
        }
    }];
    
    
    
}
#pragma mark --
//+(void)doXmlSalmXml:(NSString *)slamStr
//            CtrlXml:(NSString *)ctrlStr
//              boolS:(BOOL)boolSmalIsCan
//              boolC:(BOOL)boolCtrlIsCan{
//    if(boolSmalIsCan){
//
//        [self doGetSalmXml:slamStr];
//    }
//    if (boolCtrlIsCan) {
//        [self doGetCtrlXml:ctrlStr];
//    }
//
//}
//0218修改
+(void)doXmlSalmXml:(NSString *)slamStr
            CtrlXml:(NSString *)ctrlStr
            SalmXmlT:(NSString *)slamStrT
            CtrlXmlT:(NSString *)ctrlStrT
              boolS:(BOOL)boolSmalIsCan
              boolC:(BOOL)boolCtrlIsCan
              isBaseSmal:(BOOL)isBaseSmal
              isBaseCtrl:(BOOL)isBaseCtrl{
    if(boolSmalIsCan){
        if (isBaseSmal) {
            [self doGetSalmXml:slamStrT];//非正式版
        }else{
            [self doGetSalmXml:slamStr];//正式版
        }
        
    }
    if (boolCtrlIsCan) {
        if (isBaseCtrl) {
            [self doGetCtrlXml:ctrlStrT];
        }else{
           [self doGetCtrlXml:ctrlStr];
        }
        
    }
    
}

#pragma mark --
+ (void)doGetSalmXml:(NSString *)slamStr{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [[ToolOfNetWork sharedTools]YrequestXmlURL:slamStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
        NSXMLParser *parserOfversions = responsObject;
        NSError *err = nil;
        NSDictionary *dicOfSlam = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversions];
        //           NSLog(@"uppppss-----%@ err=%@",dicOfSlam,err.debugDescription);
        if (err==nil&&dicOfSlam.count>0) {
            NSLog(@" dicOfSlam %@",dicOfSlam);
            [DataManager shareDataManager].lastNavigationVersion = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"version"]];
            [DataManager shareDataManager].fileMD5OfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"md5"]];
            [DataManager shareDataManager].fileMuvOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"muv"]];
            [DataManager shareDataManager].fileMsgOfSmal = [NSString stringWithFormat:@"%@",[dicOfSlam objectForKey:@"msg"]];
            
        }
        
    }];
}

+ (void)doGetCtrlXml:(NSString*)ctrlStr{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [[ToolOfNetWork sharedTools]YrequestXmlURL:ctrlStr withParams:parm finished:^(NSXMLParser *responsObject, NSError *error) {
        NSXMLParser *parserOfversionc = responsObject;
        NSError *err = nil;
        NSDictionary *dicOfCtrl = [[XMLDictionaryParser sharedInstance]dictionaryWithParser:parserOfversionc];
        //            NSLog(@"uppppsc-----%@ err=%@",dicOfCtrl,err.debugDescription);
        if (err==nil&&dicOfCtrl.count>0) {
            NSLog(@"dicOfCtrl %@",dicOfCtrl);
            DataManager.shareDataManager.lastFriewareVersion = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"version"]];
            [DataManager shareDataManager].fileMD5OfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"md5"]];
            [DataManager shareDataManager].fileMuvOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"muv"]];
            [DataManager shareDataManager].fileMsgOfCtrl = [NSString stringWithFormat:@"%@",[dicOfCtrl objectForKey:@"msg"]];
            
        }
    }];
}
#pragma mark --
+(NSString *)getDeviceEqSerial{
    //三位的型号ID
    NSString *strOfRobotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    NSString *eqSerialStr = @"";
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if([[dicOfRobot allKeys] containsObject:@"eqOpfJid"] && [[dicOfRobot allKeys] containsObject:@"eqSerial"] ){//存在该字段再取
            if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
                eqSerialStr = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqSerial"]];
            }
        }
    }
    return eqSerialStr;
}
@end
