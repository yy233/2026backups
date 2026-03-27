//
//  PopViewRelationship.h
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "BasePopView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol PopViewRelationshipDelegate <NSObject>
- (void)relationshipPopViewChooseModel:(RelationshipModel *)model;
@end
@interface PopViewRelationship : BasePopView
@property (nonatomic,weak)id<PopViewRelationshipDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
