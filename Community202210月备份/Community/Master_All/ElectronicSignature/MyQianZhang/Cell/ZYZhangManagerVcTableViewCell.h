//
//  ZYZhangManagerVcTableViewCell.h
//  Community
//
//  Created by ZY on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "ZYZhangManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYZhangManagerVcTableViewCell : UITableViewCell

@property (nonatomic, strong) ZYZhangManagerDataModel *model;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

NS_ASSUME_NONNULL_END
