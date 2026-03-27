//
//  ZYCommunityFairIssueVideoCell.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairIssueVideoCellDelegate <NSObject>

- (void)videoViewEvent;

- (void)playButtonEvent;

- (void)videoDeleteButtonEvent;

@end

@interface ZYCommunityFairIssueVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) id<ZYCommunityFairIssueVideoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
