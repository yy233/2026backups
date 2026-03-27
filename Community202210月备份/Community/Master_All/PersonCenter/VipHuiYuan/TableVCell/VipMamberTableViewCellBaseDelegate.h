//
//  VipMamberTableViewCellBaseDelegate.h
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    VipMamberTableViewCell_Type_NotCell_IsHeaderView,
    VipMamberTableViewCell_Type_One,
    VipMamberTableViewCell_Type_Two,
    VipMamberTableViewCell_Type_Thr,
    VipMamberTableViewCell_Type_Four,
} VipMamberTableViewCell_Type;

@protocol VipMamberTableViewCellBaseDelegate <NSObject>
- (void)baseTouchUpCollectionCellSection:(NSInteger)section andIndex:(NSInteger)item withSelfTableViewCellType:(VipMamberTableViewCell_Type)cellType;
@end

NS_ASSUME_NONNULL_END
