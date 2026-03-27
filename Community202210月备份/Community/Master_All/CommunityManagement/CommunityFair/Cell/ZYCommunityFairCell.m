//
//  ZYCommunityFairCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYCommunityFairCell.h"

@interface ZYCommunityFairCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonWidthConstraint;

@end

@implementation ZYCommunityFairCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.editButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor forState:UIControlStateNormal];
    [self.moreButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"community_gengduo"] forState:UIControlStateNormal];
    
    [self.iconImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
    
    self.editButton.layer.borderWidth = 0.5;
    self.editButton.layer.borderColor = [ZYThemeManager shareManager].subTitleThemeColor.CGColor;
    self.editButton.layer.cornerRadius = 9;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, 0);
    self.moreButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
}

- (void)setEditStr:(NSString *)editStr {
    _editStr = editStr;
    
    [self.editButton setTitle:_editStr forState:UIControlStateNormal];
    CGSize editSize = [self.editButton.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.markLabel.font} context:nil].size;
    self.editButtonWidthConstraint.constant = editSize.width + 14;
}

// 设置数据model
- (void)setModel:(ZYCommunityFairListDataListModel *)model {
    _model = model;
    
    NSArray *array = [_model.images componentsSeparatedByString:@","];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:array.firstObject] placeholderImage:[UIImage imageNamed:@"Products_default"]];
    self.markLabel.text = _model.labelName;
    CGSize markSize = [self.markLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.markLabel.font} context:nil].size;
    self.markLabelWidthConstraint.constant = markSize.width + 10;
    
    self.nameLabel.text = _model.goodsName;
    if (_model.negotiable == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@", _model.price];
    }else {
        self.moneyLabel.text = @"面议";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
