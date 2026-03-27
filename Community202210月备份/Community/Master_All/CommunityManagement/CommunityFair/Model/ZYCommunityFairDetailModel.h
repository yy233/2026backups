//
//  ZYCommunityFairDetailModel.h
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import <Foundation/Foundation.h>

@class ZYCommunityFairDetailDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYCommunityFairDetailDataModel *data;

@end


@interface ZYCommunityFairDetailDataModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, copy) NSString *goodsExplain;

@property (nonatomic, assign) NSInteger negotiable;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *images;

// 用户信息
@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *avatarUrl;

// 0.否 1.二要素实名身份证+姓名 2.三要素实名身份证+姓名+实人认证
@property (nonatomic, assign) NSInteger isRealAuth;

@end

NS_ASSUME_NONNULL_END
