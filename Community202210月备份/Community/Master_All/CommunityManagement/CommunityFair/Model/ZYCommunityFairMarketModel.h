//
//  ZYCommunityFairMarketModel.h
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairMarketModel : NSObject

// 商品名字
@property (nonatomic, copy) NSString *goodsName;

// 商品价格
@property (nonatomic, copy) NSString *price;

// 商品说明
@property (nonatomic, copy) NSString *goodsExplain;

// 类别id
@property (nonatomic, copy) NSString *categoryId;

// 类别名
@property (nonatomic, copy) NSString *categoryName;

// 标签id
@property (nonatomic, copy) NSString *labelId;

// 标签名
@property (nonatomic, copy) NSString *labelName;

// 手机号
@property (nonatomic, copy) NSString *phone;

// 图片地址集合
@property (nonatomic, copy) NSString *images;

// 0不面议 1面议
@property (nonatomic, assign) NSInteger negotiable;

@end

NS_ASSUME_NONNULL_END
