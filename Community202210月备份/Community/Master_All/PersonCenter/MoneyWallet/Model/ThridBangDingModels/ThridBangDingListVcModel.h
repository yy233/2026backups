//
//  ThridBangDingListVcModel.h
//  Community
//
//  Created by 余莹 on 2021/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThridBangDingListVcModel : NSObject

@property (nonatomic,strong) NSString *utcUpdate;
@property (nonatomic,strong) NSString *utcCreate;
@property (nonatomic,strong) NSString *thirdPlatformType;
@property (nonatomic,strong) NSString *thirdPlatformTypeString;

@property (nonatomic,strong) NSString *thirdPlatformId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *avatarUrl;


@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger ID;
//@property (nonatomic,assign) BOOL isDeleted;
@property (nonatomic,assign) BOOL thirdPlatformBindStatus;




/**
 code = 0;
 data =     (
             {
         id = 1470642173479940098;
         isDeleted = 0;
         thirdPlatformId = 2088902438338132;
         thirdPlatformType = ALIPAY;
         uid = 1465928986293600258;
         utcCreate = "2021-12-14 14:29:49";
         utcUpdate = "2021-12-14 14:29:49";
     },
             {
         id = 14706762
 */
@end

NS_ASSUME_NONNULL_END
