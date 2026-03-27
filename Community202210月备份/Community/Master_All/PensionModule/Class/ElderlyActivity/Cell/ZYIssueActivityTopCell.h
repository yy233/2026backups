//
//  ZYIssueActivityTopCell.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIssueActivityTopCellDelegate <NSObject>

- (void)activityViewEvent;

@end

@interface ZYIssueActivityTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, weak) id<ZYIssueActivityTopCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
