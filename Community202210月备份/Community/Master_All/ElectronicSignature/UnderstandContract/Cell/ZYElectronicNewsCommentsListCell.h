//
//  ZYElectronicNewsCommentsListCell.h
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "ZYCommentsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicNewsCommentsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZYCommentsListDataListModel *model;

@end

NS_ASSUME_NONNULL_END
