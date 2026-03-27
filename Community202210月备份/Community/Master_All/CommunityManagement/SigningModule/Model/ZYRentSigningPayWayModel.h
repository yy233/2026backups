//
//  ZYRentSigningPayWayModel.h
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYRentSigningPayWayModel : NSObject

@property (nonatomic, copy) NSString *iconImageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isSelected;

// 支付类型 1:微信 2:支付宝
@property (nonatomic, assign) NSInteger payType;

@end

NS_ASSUME_NONNULL_END
