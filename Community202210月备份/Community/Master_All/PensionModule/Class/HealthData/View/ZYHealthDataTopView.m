//
//  ZYHealthDataTopView.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataTopView.h"

@interface ZYHealthDataTopView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;//状态类颜色view

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//状态类文本

@end

@implementation ZYHealthDataTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setNowShowUserModel:(ZYFamilyArchiveModel *)model{
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.name];
    if ( [TextShowWithModelStr textShowWithNotNullStr:model.avatarUrl].length==0) {
        self.iconImageView.image = [UIImage imageNamed:@"jk1"];
        return;
    }
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl]  placeholderImage:[UIImage imageNamed:@"jk1"]];
}
- (void)setTopViewStatusWithRefreshDataTimeStr:(NSString *)statusRefreshDataTime andHealthShowType:(HealthShow_Type)type{
      self.timeLabel.text = [TextShowWithModelStr textShowWithModelStr: statusRefreshDataTime ];//不是个人信息内的更新时间 而是健康数据内的更新时间(常为网络时间+硬件新数据时间+更换人时等初始话滞空)
    //
    switch (type) {
        case HealthShow_Type_Good:
        {
            self.statusView.backgroundColor = Color_HealthShow_Type_Good;
            self.statusLabel.text = kHealthShow_Type_Good_Str;
        }
            break;
        case HealthShow_Type_Warning:
        {
            self.statusView.backgroundColor = Color_HealthShow_Type_Warning;
            self.statusLabel.text = kHealthShow_Type_Warning_Str;
        }
            break;
        case HealthShow_Type_Bad:
        {
            self.statusView.backgroundColor = Color_HealthShow_Type_Bad;
            self.statusLabel.text = kHealthShow_Type_Bad_Str;
        }
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconImageView zy_cornerRadiusAdvance:43 rectCornerType:UIRectCornerAllCorners];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.switchButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.switchButton addTarget:self action:@selector(switchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)switchButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchButtonEvent)]) {
        [self.delegate switchButtonEvent];
    }
}

@end
