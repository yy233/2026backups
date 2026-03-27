//
//  ZYHelpAndFeedbackCell.h
//  Community
//
//  Created by ZY on 2021/9/7.
//

#import <UIKit/UIKit.h>
#import "ZYHelpAndFeedbackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYHelpAndFeedbackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, strong) ZYHelpAndFeedbackDataListModel *model;

@end

NS_ASSUME_NONNULL_END
