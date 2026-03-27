//
//  ZYPensionMainActivityCell.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>
#import "ZYPensionMainActivityModel.h"

#define kActivityCollectionViewCell_W (kScreenW - 45)/3.0
#define kActivityCollectionViewCell_H (kScreenW - 45)/3.0

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionMainActivityCell : UITableViewCell

@property (nonatomic, strong) ZYPensionMainActivityDataModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
