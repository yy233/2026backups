//
//  AccompanyOnePersonManage.h
//  Community
//  随行人员 增删改
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AccompayPersonReturnBlock)(BOOL);
/**
   "code": 0,
    "message": "操作成功",
    "data": true
                                                  
 */
@interface AccompanyOnePersonManage : NSObject
+ (void)personAddWithOneModel:(GuestInfoModel *)guestInfoModel withReturn:(AccompayPersonReturnBlock)reutrnBlock;
+ (void)personDeletWithOneModel:(GuestInfoModel *)guestInfoModel withReturn:(AccompayPersonReturnBlock)reutrnBlock;
+ (void)personUpdateWithOneOldModel:(GuestInfoModel *)oldModel newModel:(GuestInfoModel *)newModel withReturn:(AccompayPersonReturnBlock)reutrnBlock;
+ (void)personDeletWithModelArr:(NSMutableArray *)guestModelArr withReturn:(AccompayPersonReturnBlock)reutrnBlock;
@end

NS_ASSUME_NONNULL_END
