//
//  DevGetModel.h
//  Community
//
//  Created by 余莹 on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevGetNowUsersDevInfoModel : NSObject
/**
 
 data =     {
     bind = 1;
     createTime = "2021-11-13 17:27:18";
     familyMemberId = 118830550621491200;
     mdeviceAddress = "A4:C1:38:6B:78:56";
     mdeviceName = "S50-7856";
     mdeviceVersion = 0;
     userUuid = 55217;
 };
*/
@property (nonatomic,assign) NSInteger bind;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *familyMemberId;
@property (nonatomic,strong) NSString *mdeviceAddress;
@property (nonatomic,strong) NSString *mdeviceName;
@property (nonatomic,strong) NSString *mdeviceVersion;
@property (nonatomic,strong) NSString *userUuid;
@end

NS_ASSUME_NONNULL_END
