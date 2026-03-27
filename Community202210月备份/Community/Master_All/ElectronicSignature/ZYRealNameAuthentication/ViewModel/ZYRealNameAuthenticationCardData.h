//
//  RealNameAuthenticationCardData.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//  上传证件照片获取证件信息

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {//face正面  back反面
    UserCard_Type_face,
    UserCard_Type_back,
} UserCard_Type;
NS_ASSUME_NONNULL_BEGIN

typedef void(^RealNameUserInfoModelBlock)(RealNameAuthenticationCardModel *,BOOL);

@interface ZYRealNameAuthenticationCardData : NSObject
+ (void)getUserInfoWithImg:(UIImage *)cardImg withType:(UserCard_Type)type withModelBlock:(RealNameUserInfoModelBlock)cardUserInfoBlock;
    //proprietor/user/idCard/distinguish?type=
    //type=  face正面  back反面
    //file=身份证图片文件
 
@end

NS_ASSUME_NONNULL_END
