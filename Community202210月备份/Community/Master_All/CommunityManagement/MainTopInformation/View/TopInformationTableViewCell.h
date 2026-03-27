//
//  TopInformationTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "TopInformationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopInformationTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView*headImgv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *detailtitleLabel;
@property (nonatomic,strong) UILabel *redCountLabel;
//
@property (nonatomic,strong) TopInformationModel *model; 
@end

NS_ASSUME_NONNULL_END
