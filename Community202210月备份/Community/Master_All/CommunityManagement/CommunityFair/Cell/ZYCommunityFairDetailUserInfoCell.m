//
//  ZYCommunityFairDetailUserInfoCell.m
//  Community
//
//  Created by ZY on 2021/10/14.
//

#import "ZYCommunityFairDetailUserInfoCell.h"

@interface ZYCommunityFairDetailUserInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZYCommunityFairDetailUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconImageView zy_cornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.contentView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.contentView.backgroundColor = [UIColor zy_colorWithHexString:@"#000F26"];
    }
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

// 设置数据model
- (void)setModel:(ZYCommunityFairDetailDataModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl]];
    if (_model.nickName.length > 0) {
        self.nameLabel.text = _model.nickName;
    }else {
        self.nameLabel.text = _model.realName;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
