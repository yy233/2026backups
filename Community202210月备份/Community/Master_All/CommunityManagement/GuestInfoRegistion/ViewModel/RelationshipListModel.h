//
//  RelationshipListModel.h
//  Community
//  家属关系 list arr
//  Created by 余莹 on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *);

@interface RelationshipListModel : NSObject
+ (void)getRelationshipListWithBlock:(ListArrBlock)listArrBlock;
@end

NS_ASSUME_NONNULL_END
