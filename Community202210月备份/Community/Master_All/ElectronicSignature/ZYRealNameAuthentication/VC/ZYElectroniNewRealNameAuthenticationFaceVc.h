//
//  ElectroniNewRealNameAuthenticationFaceVc.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "ZYElectroniNewRealNameAuthenticationCardVc.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYElectroniNewRealNameAuthenticationFaceVc : ZYElectroniNewRealNameAuthenticationCardVc
@property (nonatomic,strong) NSString *getCerJsonStr;
@property (nonatomic,strong) NSString *cerAddress;
@property (nonatomic, copy) NSString *realName;
@end

NS_ASSUME_NONNULL_END
