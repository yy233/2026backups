//
//  HouseRepairAdviceViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DataStrBlock)(NSString *,BOOL);
typedef void(^MessageBlock)(NSString *,BOOL);
@interface HouseRepairAdviceViewModel : NSObject
+ (void)houseAdviceSendImgWithOneFileArr:(NSMutableArray *)file withblock:(DataStrBlock)dataStrBlock;
+ (void)houseAdviceSendParams:(NSMutableDictionary *)parms  withblock:(MessageBlock)messageBlock;
@end

NS_ASSUME_NONNULL_END
