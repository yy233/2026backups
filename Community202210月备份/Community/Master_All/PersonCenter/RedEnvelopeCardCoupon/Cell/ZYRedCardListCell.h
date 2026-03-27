//
//  ZYRedCardListCell.h
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "ZYRedCardListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYRedCardListCell : UITableViewCell

@property (nonatomic, strong) ZYRedCardListDataModel *model;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@end

NS_ASSUME_NONNULL_END
