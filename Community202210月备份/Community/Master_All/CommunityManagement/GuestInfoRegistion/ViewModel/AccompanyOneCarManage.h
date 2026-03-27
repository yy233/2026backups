//
//  AccompanyOneCarManage.h
//  Community
//  随行车辆 增删改
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AccompayCarReturnBlock)(BOOL);
@interface AccompanyOneCarManage : NSObject
+ (void)carAddWithOneModel:(CarInfoModel *)carModel withReturn:(AccompayCarReturnBlock)reutrnBlock;
+ (void)carDeletWithOneModel:(CarInfoModel *)carModel withReturn:(AccompayCarReturnBlock)reutrnBlock;
+ (void)carUpdateWithOneOldModel:(CarInfoModel *)oldModel newModel:(CarInfoModel *)newModel withReturn:(AccompayCarReturnBlock)reutrnBlock;
+ (void)carDeletWithModelArr:(NSMutableArray *)carModelArr withReturn:(AccompayCarReturnBlock)reutrnBlock;
@end

NS_ASSUME_NONNULL_END
