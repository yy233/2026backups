//
//  IssueHouseManagerVcHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  IssueHouseManagerVcTopAddTableViewCellDelegate <NSObject>
- (void)cellTouchBtnWithAddAction;
@end
@interface IssueHouseManagerVcTopAddTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIView *greenbackView;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UILabel *centerBottomL;
@property (nonatomic,weak) id <IssueHouseManagerVcTopAddTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
