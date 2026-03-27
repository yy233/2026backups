//
//  BaoHuoWebViewVc.h
//  Socialize
//
//  Created by 余莹 on 2023/7/12.
//

#import <UIKit/UIKit.h>
#import "BaseWebVc.h"
#import "WalletSqlTools.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaoHuoWebViewVc : BaseWebVc
- (void)initBaoHuoWebData;
- (void)creatredEnvOfWebInfo:(NSDictionary *)redEnvDic;
@property (nonatomic,strong) NSString *creatredEnvOfThisTimeStr;
@end

NS_ASSUME_NONNULL_END
