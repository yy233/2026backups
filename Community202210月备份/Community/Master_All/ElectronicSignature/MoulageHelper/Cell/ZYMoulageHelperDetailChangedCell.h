//
//  ZYMoulageHelperDetailChangedCell.h
//  Community
//
//  Created by ZY on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "ZYMoulageHelperDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailChangedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@property (nonatomic, strong) ZYMoulageHelperDetailtParamsModel *model;

@end

NS_ASSUME_NONNULL_END
