//
//  ZYHouseRepairIssueTimeCell.m
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import "ZYHouseRepairIssueTimeCell.h"

@interface ZYHouseRepairIssueTimeCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel;

@property (weak, nonatomic) IBOutlet UIView *timeLineView;

@end

@implementation ZYHouseRepairIssueTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 100) radius:10 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    
    [self.timeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewTap)]];
    self.timeImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"hr_yysj_icon"];
    self.timeTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.timeContentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.timeLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYHouseRepairIssueUploadModel *)model {
    _model = model;
    
    if (_model.appointmentTime.length > 0) {
        self.timeContentLabel.text = _model.appointmentTime;
    }
}

#pragma mark - 处理点击事件
// 预约时间
- (void)timeViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeViewEvent)]) {
        [self.delegate timeViewEvent];
    }
}

@end
