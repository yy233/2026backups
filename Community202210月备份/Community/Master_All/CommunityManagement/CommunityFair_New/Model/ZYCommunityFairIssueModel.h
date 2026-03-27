//
//  ZYCommunityFairIssueModel.h
//  Community
//
//  Created by ZY on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairIssueModel : NSObject

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 商品名
@property (nonatomic, copy) NSString *goodsName;

// 价格
@property (nonatomic, copy) NSString *price;

// 手机号
@property (nonatomic, copy) NSString *phone;

// 商品说明
@property (nonatomic, copy) NSString *goodsExplain;

// 是否面议（0不面议 1面议  默认1）
@property (nonatomic, assign) NSInteger negotiable;

// 商品类别id
@property (nonatomic, copy) NSString *categoryId;

// 商品类别名
@property (nonatomic, copy) NSString *categoryName;

// 标签id
@property (nonatomic, copy) NSString *labelId;

// 标签名
@property (nonatomic, copy) NSString *labelName;

// 图片
@property (nonatomic, copy) NSString *imagesUrl;

// 视频地址
@property (nonatomic, copy) NSString *mvUrl;

@end

NS_ASSUME_NONNULL_END
