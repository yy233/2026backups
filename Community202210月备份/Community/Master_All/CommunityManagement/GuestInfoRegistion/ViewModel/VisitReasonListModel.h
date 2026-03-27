//
//  VisitReasonListModel.h
//  Community
//
//  Created by 余莹 on 2020/12/11.
//

#import <Foundation/Foundation.h>
#import "VisitReasonModel.h" //

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *); 
@interface VisitReasonListModel : NSObject
+ (void)getVisitReasoneListWithBlock:(ListArrBlock)listArrBlock;
@end

NS_ASSUME_NONNULL_END
