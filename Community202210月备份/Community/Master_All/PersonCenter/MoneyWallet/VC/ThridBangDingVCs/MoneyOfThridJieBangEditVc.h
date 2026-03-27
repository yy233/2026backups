//
//  MoneyOfThridJieBangEditVc.h
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import "BaseTableViewController.h"


NS_ASSUME_NONNULL_BEGIN

static NSString *thirdPlatformType_iOS = @"IOS";
static NSString *thirdPlatformType_ALIPAY = @"ALIPAY";
static NSString *thirdPlatformType_WECHAT = @"WECHAT";

static NSString *thirdPlatformType_iOS_ShowNmae    = @"苹果";
static NSString *thirdPlatformType_ALIPAY_ShowNmae = @"支付宝";
static NSString *thirdPlatformType_WECHAT_ShowNmae = @"微信";

@interface MoneyOfThridJieBangEditVc : BaseTableViewController
@property (nonatomic,strong) NSString *thridPTypeStr;
@end

NS_ASSUME_NONNULL_END
