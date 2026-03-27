//
//  HouseRentQianYueBeginViewModel.h
//  Community
//
//  Created by 余莹 on 2021/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentQianYueBeginViewModel : NSObject
//发起签约
+ (void)initiateQianYueWithHouseOrBuniessInfoDic:(NSMutableDictionary *)parms Block:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
