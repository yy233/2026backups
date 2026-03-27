//
//  ZYSigningDetailHouseInfoCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailHouseInfoCell.h"

@interface ZYSigningDetailHouseInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

// 倒计时终点
@property (nonatomic, assign) NSInteger countdownFinishTime;

@end

@implementation ZYSigningDetailHouseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.timeImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_time"];
    self.timeLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.remarkLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.bottomLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    
    CGRect bounds = CGRectMake(0, 0, kScreenW - 32, self.contentV.bounds.size.height);
    [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self.houseImageView zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];
}

// 设置数据model
- (void)setModel:(ZYSigningDetailDataModel *)model {
    _model = model;
    
    // 签约操作状态 0:发起签约 1:已发起签约 2:已接受申请 4:等待支付房租 5:已支付完成 6:已完成签约 7:已取消签约 8:已拒绝申请 9:重新发起 31:房东已重新发起 32:房东已取消发起
    if (_model.operation == 0 || _model.operation == 6 || _model.operation == 7 || _model.operation == 8 || _model.operation == 10) {
        self.topView.hidden = YES;
    }else if (_model.operation == 1 || _model.operation == 2 || _model.operation == 4 || _model.operation == 5 || _model.operation ==  9 || _model.operation == 31 || _model.operation ==  32) {
        self.topView.hidden = NO;
        NSInteger startTime = [[NSDate date] timeIntervalSinceNow];
        self.countdownFinishTime = [[NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:_model.countdownFinish] timeIntervalSinceNow];
        NSInteger totalSecond = self.countdownFinishTime - startTime;
        if (totalSecond > 0) {
            NSInteger second = totalSecond % 60;
            NSInteger minute = (totalSecond / 60) % 60;
            NSInteger hours = (totalSecond / 3600) % 24;
            NSInteger days = totalSecond / (24 * 3600);
            self.timeLabel.text = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒", days, hours, minute, second];
        }else {
            self.timeLabel.text = @"申请已过期";
        }
        
        if (_model.identityType == 1) {
            self.remarkLabel.text = @"请在7个工作日完成合同签署，超时系统将自动关闭";
        }else {
            self.remarkLabel.text = @"请您联系房东在规定时间确认，超时系统将自动关闭";
        }
    }
    
    // 房屋信息
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"Products_default"]];
    self.titleLabel.text = _model.title;
    if (_model.assetType == 1) {
        self.subTitleLabel.hidden = YES;
    }else {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@，朝%@", _model.houseType, _model.directionId];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@元/月", [NSNumber numberWithDouble:_model.price]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
