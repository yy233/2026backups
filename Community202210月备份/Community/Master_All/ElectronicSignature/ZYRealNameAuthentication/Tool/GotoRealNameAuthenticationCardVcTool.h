//
//  GotoRealNameAuthenticationCardVcTool.h
//  Community
//
//  Created by 余莹 on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import "ZYElectroniNewRealNameAuthenticationCardVcLate.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GotoRealNameAuthenticationCardVc_NowVcType_Nomal,//普通为定义
    GotoRealNameAuthenticationCardVc_NowVcType_OneType,
} GotoRealNameAuthenticationCardVc_NowVcType;


@interface GotoRealNameAuthenticationCardVcTool : NSObject
+ (void)needGotoRealNameAuthenticationCardVcWithNowVcType:(GotoRealNameAuthenticationCardVc_NowVcType)nowVcType
                                                withBlock:(void(^)(BOOL needGotoRealNameVcBool ,ZYElectroniNewRealNameAuthenticationCardVcLate *realNameVc))bolck;
@end

NS_ASSUME_NONNULL_END
