//
//  VersionToolModel.h
//  Community
//
//  Created by 余莹 on 2021/5/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionToolModel : NSObject
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *sysVersion;
@property (nonatomic,assign) NSInteger sysType;
@property (nonatomic,assign) BOOL paySupport; ///是否支持支付 0.不支持 1.支持
@property (nonatomic,assign) BOOL forcedUpdate; ///是否强制更新 0.不强制 1.强制
@property (nonatomic,copy) NSString *sysVersionNumber;//版本号数字
@property (nonatomic,copy) NSString *message;//更新版本提示话术

/**
 {
createTime = "2021-05-31 14:26:41";
id = 1;
paySupport = 0;
sysType = 2;
sysVersion = "1.0.0";
}
 */


/**
 20220416 新接口
 
 "data": {
         "id": 3,
         "idStr": "null",
         "deleted": 0,
         "createTime": "2021-05-31 14:26:48",
         "sysType": 1,/系统类型 1.安卓 2.IOs
         "sysVersion": "0.0.1",//版本号
         "scope": 2,//产品类型
         "paySupport": 1,//是否支持支付 0.不支持 1.支持
         "message": "修复系统BUG", //更新版本提示话术
         "url": "http://123.123",
         "forcedUpdate": "0", //是否强制更新 0.不强制 1.强制
         "sysVersionNumber": "001"//版本号数字
     }
 */
@end

NS_ASSUME_NONNULL_END
