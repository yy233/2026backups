//
//  ZYActivityApplyDetatilInfoCell.h
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "ZYActivityApplyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYActivityApplyDetatilInfoCell : UITableViewCell

@property (nonatomic, strong) ZYActivityApplyDetailDataModel *model;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@end

NS_ASSUME_NONNULL_END
