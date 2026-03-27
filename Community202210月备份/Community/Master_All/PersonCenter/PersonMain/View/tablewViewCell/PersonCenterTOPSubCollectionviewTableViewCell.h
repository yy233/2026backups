//
//  PersonCenterTOPSubCollectionviewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import <UIKit/UIKit.h>
#import "PersonCenterNomalSubCollectionviewTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PersonCenterTOPSubCollectionviewTableViewCellDelegate <NSObject>
- (void)personVcTopSubCollectionViewTouchUpItemWithIndex:(NSInteger)index;
@end

@interface PersonCenterTOPSubCollectionviewTableViewCell : PersonCenterNomalSubCollectionviewTableViewCell
@property (nonatomic,weak) id <PersonCenterTOPSubCollectionviewTableViewCellDelegate> topCellDelegate;
@end

NS_ASSUME_NONNULL_END
