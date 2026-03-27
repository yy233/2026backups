//
//  ZYFamilyArchiveInfoCell.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "ZYFamilyArchiveInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYFamilyArchiveInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, strong) ZYFamilyArchiveInfoModel *model;

@end

NS_ASSUME_NONNULL_END
