//
//  ChangeLiveInfoWithNoticeNetWorkTool.h
//  TUILiveRoom
//
//  Created by 余莹 on 2023/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//    3开启 4结束
typedef enum : NSUInteger {
    Active_State_KaiQi = 3,
    Active_State_JieSu = 4,
} Active_State;

typedef void(^ChangeInfoNetToolBlock)( BOOL isChangeSuccess,NSDictionary *dataDic);
@interface ChangeLiveInfoWithNoticeNetWorkTool : NSObject

+ (void)changeLiveInfoWithActivityIdStr:(NSString *)activeIdstr withNowState:(Active_State)state withBlock:(ChangeInfoNetToolBlock)block;
@end

NS_ASSUME_NONNULL_END
