//
//  ZYFamilyArchiveCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveCollectionViewCell.h"

@interface ZYFamilyArchiveCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation ZYFamilyArchiveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusRoundingRect];
    self.infoButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, 0, -8, 0);
}

// 设置数据model
- (void)setModel:(ZYFamilyArchiveModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl] placeholderImage:[UIImage imageNamed:@"yl_mortx"]];
    self.nameLabel.text = _model.name;
    self.telLabel.text = _model.mobile;
    if (_model.status == 1) {
        self.infoButton.backgroundColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
        [self.infoButton setTitle:@"查看信息" forState:UIControlStateNormal];
    }else {
        self.infoButton.backgroundColor = [UIColor zy_colorWithHexString:@"#FF7E6E"];
        [self.infoButton setTitle:@"完善信息" forState:UIControlStateNormal];
    }
}

@end
