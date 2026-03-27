//
//  ZYCommunityFairIssueTextCell.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairIssueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairIssueTextCell : UITableViewCell

@property (nonatomic, strong) ZYCommunityFairIssueModel *model;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

NS_ASSUME_NONNULL_END
