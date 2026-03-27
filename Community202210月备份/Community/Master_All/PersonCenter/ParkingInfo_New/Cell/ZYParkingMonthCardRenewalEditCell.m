//
//  ZYParkingMonthCardRenewalEditCell.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardRenewalEditCell.h"

@interface ZYParkingMonthCardRenewalEditCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *subtractButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic, assign) NSInteger monthNum;

@end

@implementation ZYParkingMonthCardRenewalEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.unitLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.numLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.subtractButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"pa_huijianhao"] forState:UIControlStateNormal];
    [self.addButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"pa_jiahao"] forState:UIControlStateNormal];
    self.subtractButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    self.addButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [self.subtractButton addTarget:self action:@selector(subtractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.monthNum = 1;
    self.maxMonthNum = 12;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", self.monthNum];
    self.subtractButton.enabled = NO;
}

// 设置数据model
- (void)setModel:(ZYParkingMonthCardRenewalModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
}

- (void)setMaxMonthNum:(NSInteger)maxMonthNum {
    _maxMonthNum = maxMonthNum;
    
    if (_maxMonthNum <= 1) {
        self.subtractButton.enabled = NO;
        [self.subtractButton setImage:[UIImage imageNamed:@"pa_huijianhao"] forState:UIControlStateNormal];
        self.addButton.enabled = NO;
        [self.addButton setImage:[UIImage imageNamed:@"pa_huijiahao"] forState:UIControlStateNormal];
        self.monthNum = 1;
        self.numLabel.text = [NSString stringWithFormat:@"%ld", self.monthNum];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)subtractButtonClicked {
    if (self.monthNum > 1) {
        self.monthNum -= 1;
    }
    if (self.monthNum == 1) {
        self.subtractButton.enabled = NO;
        [self.subtractButton setImage:[UIImage imageNamed:@"pa_huijianhao"] forState:UIControlStateNormal];
    }
    self.addButton.enabled = YES;
    [self.addButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"pa_jiahao"] forState:UIControlStateNormal];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", self.monthNum];
    if (self.delegate && [self.delegate respondsToSelector:@selector(subtractButtonEventWithMonth:)]) {
        [self.delegate subtractButtonEventWithMonth:self.monthNum];
    }
}

- (void)addButtonClicked {
    if (self.monthNum < self.maxMonthNum) {
        self.monthNum += 1;
    }
    if (self.monthNum == self.maxMonthNum) {
        self.addButton.enabled = NO;
        [self.addButton setImage:[UIImage imageNamed:@"pa_huijiahao"] forState:UIControlStateNormal];
    }
    self.subtractButton.enabled = YES;
    [self.subtractButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"pa_jianhao"] forState:UIControlStateNormal];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", self.monthNum];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonEventWithMonth:)]) {
        [self.delegate addButtonEventWithMonth:self.monthNum];
    }
}

@end
