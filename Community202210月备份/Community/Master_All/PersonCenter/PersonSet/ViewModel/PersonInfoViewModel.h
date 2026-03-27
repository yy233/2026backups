//
//  PersonInfoViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonInfoViewModel : NSObject
/**
 个人信息获取
 */
+ (void)getPersonUserInfoWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
头像上传
 */
+ (void)changePersonHeaderImgWithUpSendImg:(UIImage *)img withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
 更换昵称
 */
+ (void)changePersonNickNameWithStr:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
 更换生日
 */
+ (void)changePersonBirthdayTimeNameWithStr:(NSString *)birthdayTimeStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

/**
 得到头像URL 处理头像URL数据
 */
+ (void)changePersonHeadImgWithUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END
