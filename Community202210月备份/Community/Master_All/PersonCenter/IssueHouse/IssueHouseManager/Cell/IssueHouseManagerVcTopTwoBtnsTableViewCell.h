//
//  IssueHouseManagerVcTopTwoBtnsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  IssueHouseManagerVcTopTwoBtnsTableViewCellDelegate <NSObject>
- (void)cellTouchYuyueAction;
- (void)cellTouchQianyueAction;
@end
@interface IssueHouseManagerVcTopTwoBtnsTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIButton *yuyueBtn;
@property (nonatomic,strong) UIButton *qianyueBtn;
@property (nonatomic,weak) id <IssueHouseManagerVcTopTwoBtnsTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
