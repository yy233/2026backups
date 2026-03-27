//
//  ZYMoulageHelperVcTableViewCell.h
//  Community
//
//  Created by ZY on 2021/4/15.
//

#import <UIKit/UIKit.h>
#import "ZYAllContractTemplatesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperVcTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic, strong) ZYAllContractTemplatesDataListModel *model;

@end

NS_ASSUME_NONNULL_END
