//
//  VersionListTool.m
//  Community
//
//  Created by 余莹 on 2021/5/31.
//

#import "VersionShowOrHiddenTool.h"
#import "VersionToolModel.h"


#define versionSearchUrl  @"proprietor/app/list/version?sysType=2&sysVersion="
 
#define versionMastUpdataInfoUrl  @"proprietor/app/v3/queryNewestVersion"

#define Data_versionInfo_Key      @"versionInfo"
#define Data_forcedUpdate_Key     @"forcedUpdate"

@implementation VersionShowOrHiddenTool

/**
 当前版本 是否展示三方登录
 */
+ (void)getVersionInfoBoolWithBool:(ShowSanfangViewBoolBlock)showViewBoolBlock{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //20220416新版只用在是否显示更新提示上面。旧接口处理是否显示三方登录
    
    /**
     *    旧版 用与三方登录和部分微信支付显示元素
     *
     * */
    
    
     NSString *vUrl = [NSString stringWithFormat:@"%@%@",versionSearchUrl,app_Version];

      [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:vUrl withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
          if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSLog(@"responsObject = %@ ",responsObject);
               
                 NSMutableDictionary *theVersionDicInfo = [[NSMutableDictionary alloc]init];
                 if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {//两种格式数据都要能做
                     NSArray *arrOfData = [NSArray arrayWithArray:[responsObject objectForKey:@"data"]];
                     theVersionDicInfo = [NSMutableDictionary dictionaryWithDictionary: arrOfData.firstObject];
                 }else if ([ [responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]] ){
                     if (isNil(Y_ResponsObject_dataDic)) {
                         //隐藏
                         showViewBoolBlock(YES,NO);
                     }else{
                         theVersionDicInfo = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                     }
                 }else{
                 }
                 VersionToolModel *vm = [VersionToolModel mj_objectWithKeyValues:theVersionDicInfo];
             
                     if (vm.paySupport) {
                         //显示
                         showViewBoolBlock(YES,YES);
                     }else{
                         //隐藏
                         showViewBoolBlock(YES,NO);
                     }
                 }else{
                     showViewBoolBlock(NO,NO);
                     
                 }
             }else{
                 showViewBoolBlock(NO,NO);
             }
     }];
     

    

   
}


/**
 当前版本是否需要提醒用户升级
 */
+ (void)getShowUpdataSignInfoWithBlock:( void(^)(BOOL success,BOOL isMastUpdataBool,NSString *showVersionNumStr,NSString *showVersionMsg) )boolBlock{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    /**
     sysType 统类型;1:安卓;2:IOS
     scope 产品类型;e到家:2;商城:4;物业端:8;小区端:16;巡更:32;智能仓储:64;大后台:1073741824
     
     */
    NSDictionary *parms = @{
        @"sysType":@(2),
        @"scope":@(2),
        @"sysVersion":app_Version
    };
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:versionMastUpdataInfoUrl withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSLog(@"responsObject = %@ ",responsObject);
                
                NSDictionary *getDataDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                //当前版的后面所有版本内有无强制更新 forcedUpdate 0 1
                BOOL mastUpDateBool =   ([[getDataDic allKeys] containsObject: Data_forcedUpdate_Key] && isNotNil([getDataDic objectForKey: Data_forcedUpdate_Key])) ?  [[getDataDic objectForKey:Data_forcedUpdate_Key] boolValue] : 0 ;
              //最新版信息
                NSMutableDictionary *theVersionDicInfo = [[NSMutableDictionary alloc]initWithDictionary:   ( [[getDataDic allKeys] containsObject: Data_versionInfo_Key] && isNotNil([getDataDic objectForKey: Data_versionInfo_Key]) ) ? [getDataDic objectForKey:Data_versionInfo_Key] : [NSDictionary dictionary] ];
                VersionToolModel *vm = [VersionToolModel mj_objectWithKeyValues:theVersionDicInfo];
                NSString *showVersionNumStr = [TextShowWithModelStr textShowWithModelStr:vm.sysVersion];//sysVersionNumber
                NSString *showVersionMsgStr = [TextShowWithModelStr textShowWithModelStr:vm.message];
 
                if (mastUpDateBool) {
                    //强升
                    boolBlock(YES,YES,showVersionNumStr,showVersionMsgStr);
                }else{
                    //不强升
                    boolBlock(YES,NO,showVersionNumStr,showVersionMsgStr);
                }
            }else{
                boolBlock(NO,NO,@"",@"");
                
            }
        }else{
            boolBlock(NO,NO,@"",@"");
            
        }
    }];
    
    
}
@end
