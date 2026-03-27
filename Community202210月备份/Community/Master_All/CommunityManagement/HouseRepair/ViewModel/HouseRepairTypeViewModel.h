//
//  HouseRepairTypeViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    Repair_Type_PersonalOrPublic_Person=0,
    Repair_Type_PersonalOrPublic_Public=1,
} Repair_Type_PersonalOrPublic;//传0：个人报修事项  传1：公共报修事项

NS_ASSUME_NONNULL_BEGIN

typedef void(^ListTypeArrBlock)(NSArray *,BOOL);
@interface HouseRepairTypeViewModel : NSObject
+ (void)getTypeListWithRepairType:(Repair_Type_PersonalOrPublic)type
                    withListBlock:(ListTypeArrBlock)listBlock;

@end

NS_ASSUME_NONNULL_END
