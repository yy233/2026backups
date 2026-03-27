//
//  ZYPropertyPayCostPayCell.h
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "ZYPropertyPayCostPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPropertyPayCostPayCellDelegate <NSObject>

- (void)doubtButtonEvent;

@end

@interface ZYPropertyPayCostPayCell : UITableViewCell

@property (nonatomic, strong) ZYPropertyPayCostPayModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *doubtButton;

@property (nonatomic, weak) id<ZYPropertyPayCostPayCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
