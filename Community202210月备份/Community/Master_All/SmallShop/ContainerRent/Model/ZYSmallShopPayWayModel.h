//
//  ZYSmallShopPayWayModel.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZYSmallShop_Pay_Way_Type_WeChat,   // 微信支付
    ZYSmallShop_Pay_Way_Type_Alipay    // 支付宝支付
} ZYSmallShop_Pay_Way_Type;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopPayWayModel : NSObject

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type type;

@end

NS_ASSUME_NONNULL_END
