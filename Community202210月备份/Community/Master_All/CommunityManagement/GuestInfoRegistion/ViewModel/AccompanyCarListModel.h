//
//  AccompanyCarListModel.h
//  Community
//  随行车辆
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *);
@interface AccompanyCarListModel : NSObject
+ (void)getAccompayCarInitListWithBlock:(ListArrBlock)listArrBlock;
+ (void)getAccompayCarUpdatMoreListWithBlock:(ListArrBlock)listArrBlock nowPageNum:(NSInteger)pageNum;
@end

NS_ASSUME_NONNULL_END
