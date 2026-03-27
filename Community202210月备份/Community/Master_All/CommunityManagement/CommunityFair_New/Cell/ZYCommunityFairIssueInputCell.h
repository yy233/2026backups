//
//  ZYCommunityFairIssueInputCell.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairIssueModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairIssueInputCellDelegate <NSObject>

- (void)categoryViewEvent;

- (void)discussButtonEvent;

@end

@interface ZYCommunityFairIssueInputCell : UITableViewCell

@property (nonatomic, strong) ZYCommunityFairIssueModel *model;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@property (nonatomic, weak) id<ZYCommunityFairIssueInputCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
