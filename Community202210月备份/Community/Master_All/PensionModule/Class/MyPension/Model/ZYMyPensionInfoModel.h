//
//  ZYMyPensionInfoModel.h
//  Community
//
//  Created by ZY on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMyPensionInfoModel : NSObject

// 电话
@property (nonatomic, copy) NSString *phone;

// 昵称
@property (nonatomic, copy) NSString *nickName;

// 性别
@property (nonatomic, assign) NSInteger sex;

// 头像
@property (nonatomic, copy) NSString *avatarThumbnail;

@end

NS_ASSUME_NONNULL_END
