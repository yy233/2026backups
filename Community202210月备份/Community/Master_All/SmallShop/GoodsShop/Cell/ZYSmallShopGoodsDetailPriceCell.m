//
//  ZYSmallShopGoodsDetailPriceCell.m
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import "ZYSmallShopGoodsDetailPriceCell.h"

@interface ZYSmallShopGoodsDetailPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *activityView;

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *timeAllView;

@property (weak, nonatomic) IBOutlet UIView *dayView;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UIView *hourView;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UIView *minuteView;

@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong) NSTimer *timer;

// 倒计时终点
@property (nonatomic, assign) NSInteger countdownFinishTime;

@end

@implementation ZYSmallShopGoodsDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.dayView.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF0033"].CGColor;
    self.dayView.layer.borderWidth = 1;
    self.dayView.layer.cornerRadius = 2;
    self.dayView.layer.masksToBounds = YES;
    
    self.hourView.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF0033"].CGColor;
    self.hourView.layer.borderWidth = 1;
    self.hourView.layer.cornerRadius = 2;
    self.hourView.layer.masksToBounds = YES;
    
    self.minuteView.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF0033"].CGColor;
    self.minuteView.layer.borderWidth = 1;
    self.minuteView.layer.cornerRadius = 2;
    self.minuteView.layer.masksToBounds = YES;
    
    self.secondView.layer.borderColor = [UIColor zy_colorWithHexString:@"#FF0033"].CGColor;
    self.secondView.layer.borderWidth = 1;
    self.secondView.layer.cornerRadius = 2;
    self.secondView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 设置数据model
- (void)setModel:(ZYSmallShopGoodsDetailModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.commodityName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.payDto.commoditySellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.payDto.commodityOriginalPrice]];
    self.remarkLabel.text = _model.commodityDescribe;
    if (_model.payDto.activityName.length > 0) {
        self.activityView.hidden = NO;
        self.activityLabel.text = _model.payDto.activityName;
    }else {
        self.activityView.hidden = YES;
        self.activityLabel.text = _model.payDto.activityName;
    }
    
    if (_model.activityEndTime.length > 0) {
        self.timeTitleLabel.hidden = NO;
        self.timeAllView.hidden = NO;
        [self handleCountdownFinishTime];
    }
}

// 处理倒计时
- (void)handleCountdownFinishTime {
    NSInteger startTime = [[NSDate date] timeIntervalSinceNow];
    self.countdownFinishTime = [[NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:_model.activityEndTime] timeIntervalSinceNow];
    NSInteger totalSecond = self.countdownFinishTime - startTime;
    if (totalSecond > 0) {
        NSInteger second = totalSecond % 60;
        NSInteger minute = (totalSecond / 60) % 60;
        NSInteger hours = (totalSecond / 3600) % 24;
        NSInteger days = totalSecond / (24 * 3600);
        self.dayLabel.text = [NSString stringWithFormat:@"%ld", days];
        self.hourLabel.text = [NSString stringWithFormat:@"%ld", hours];
        self.minuteLabel.text = [NSString stringWithFormat:@"%ld", minute];
        self.secondLabel.text = [NSString stringWithFormat:@"%ld", second];
        // 开启定时器
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(notiTimerBack) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }else {
        self.dayLabel.text = @"0";
        self.hourLabel.text = @"0";
        self.minuteLabel.text = @"0";
        self.secondLabel.text = @"0";
        // 销毁定时器
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

// 定时器回调
- (void)notiTimerBack {
    [self handleCountdownFinishTime];
}

@end
