//
//  CarTypeListModel.h
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *);
@interface CarTypeListModel : NSObject
+ (void)getCarTypeListWithBlock:(ListArrBlock)listArrBlock;
+ (void)getCarHistoryListWithHouseInfoCommunityId:(NSInteger)communityId withBlocl:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
