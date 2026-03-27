//
//  ZYAccessRecordTopHeaderView.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordTopHeaderView.h"

@interface ZYAccessRecordTopHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *relationView;

@property (weak, nonatomic) IBOutlet UILabel *relationLabel;

@property (weak, nonatomic) IBOutlet UILabel *decLabel;

@property (nonatomic, assign) NSInteger type;

@end

@implementation ZYAccessRecordTopHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ar_crdu_picture"];
    [self.switchButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.switchButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ar_cyqihuan_icon"] forState:UIControlStateNormal];
    [self.switchButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.addressLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.iconImageView zy_cornerRadiusAdvance:30 rectCornerType:UIRectCornerAllCorners];
    self.decLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    [self.switchButton addTarget:self action:@selector(switchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.relationView.layer.borderWidth = 0.5;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.relationView.layer.borderColor = [UIColor clearColor].CGColor;
        self.relationView.backgroundColor = [UIColor zy_colorWithHexString:@"#FFE9C5"];
        self.relationLabel.textColor = [UIColor zy_colorWithHexString:@"#FF3607"];
    }else {
        self.relationView.layer.borderColor = [UIColor zy_colorWithHexString:@"#F7DCB1"].CGColor;
        self.relationView.backgroundColor = [UIColor clearColor];
        self.relationLabel.textColor = [UIColor zy_colorWithHexString:@"#F7DCB1"];
    }
}

// 设置数据model
- (void)setModel:(ZYAccessRecordVisitPermitModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl] placeholderImage:[UIImage imageNamed:@"yl_mortx"]];
    self.nameLabel.text = _model.name;
    self.relationLabel.text = _model.relationName;
    self.addressLabel.text = _model.communityName;
    // 业主和家属
    if (_model.relation == 1 || _model.relation == 2) {
        self.switchButton.hidden = NO;
    }else {
        self.switchButton.hidden = YES;
    }
}

#pragma mark - 处理点击事件
- (void)switchButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchButtonEvent)]) {
        [self.delegate switchButtonEvent];
    }
}

@end
