//
//  ZYSmallShopGoodsSpellGroupDetailCell.m
//  Community
//
//  Created by ZY on 2022/3/4.
//

#import "ZYSmallShopGoodsSpellGroupDetailCell.h"

@interface ZYSmallShopGoodsSpellGroupDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *dayView;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UIView *hourView;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UIView *minuteView;

@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endTimeLabelTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *endTimeView;

@property (nonatomic, strong) NSTimer *timer;

// 倒计时终点
@property (nonatomic, assign) NSInteger countdownFinishTime;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@end

@implementation ZYSmallShopGoodsSpellGroupDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.subContentV.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kScreenW, 58) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#FF6231"] endColor:[UIColor zy_colorWithHexString:@"#FF5757"]];
    
    self.dayView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dayView.layer.borderWidth = 1;
    self.dayView.layer.cornerRadius = 2;
    self.dayView.layer.masksToBounds = YES;
    
    self.hourView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hourView.layer.borderWidth = 1;
    self.hourView.layer.cornerRadius = 2;
    self.hourView.layer.masksToBounds = YES;
    
    self.minuteView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.minuteView.layer.borderWidth = 1;
    self.minuteView.layer.cornerRadius = 2;
    self.minuteView.layer.masksToBounds = YES;
    
    self.secondView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.secondView.layer.borderWidth = 1;
    self.secondView.layer.cornerRadius = 2;
    self.secondView.layer.masksToBounds = YES;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", [NSDate date].br_day];
    self.hourLabel.text = [NSString stringWithFormat:@"%ld", [NSDate date].br_hour];
    self.minuteLabel.text = [NSString stringWithFormat:@"%ld", [NSDate date].br_minute];
    self.secondLabel.text = [NSString stringWithFormat:@"%ld", [NSDate date].br_second];
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap)]];
    
    // 开启定时器
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(notiTimerBack) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
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
- (void)setModel:(ZYSmallShopGoodsSpellGroupDetailModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.commodityHeadImg] placeholderImage:[UIImage imageNamed:@"cc_placeholder_big_banner"]];
    self.nameLabel.text = _model.commodityName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:_model.groupSpellPrice]];
    self.originPriceLabel.text = [NSString stringWithFormat:@"原价￥%@", [ZYDecimalNumberTool stringWithDecimalString:_model.commodityOriginalPrice]];
    if (_model.groupSpellPersonNumber == _model.personSpell) {
        self.endTimeLabel.text = @"拼团结束";
        self.endTimeLabelTopConstraint.constant = 21;
        self.endTimeView.hidden = YES;
    }else {
        self.endTimeLabel.text = @"即将结束";
        self.endTimeLabelTopConstraint.constant = 8;
        self.endTimeView.hidden = NO;
        [self handleCountdownFinishTime];
    }
}

// 处理倒计时
- (void)handleCountdownFinishTime {
    NSInteger startTime = [[NSDate date] timeIntervalSinceNow];
    self.countdownFinishTime = [[NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:_model.endTime] timeIntervalSinceNow];
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

#pragma mark - 处理点击事件
- (void)iconImageViewTap {
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:self.model.commodityHeadImg];
        photoModel.originUrl = [NSURL URLWithString:self.model.commodityHeadImg];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:[self viewContainingController]];
}

@end
