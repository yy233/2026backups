//
//  ZYMedicalMainTopView.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainTopView.h"

@interface ZYMedicalMainTopView ()

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation ZYMedicalMainTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.showButton.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(90, 30) direction:IHGradientChangeDirectionVertical startColor:[UIColor zy_colorWithHexString:@"#62F3E7"] endColor:[UIColor zy_colorWithHexString:@"#0DD7C6"]];
    self.showButton.layer.borderWidth = 1;
    self.showButton.layer.borderColor = [UIColor zy_colorWithHexString:@"#FFDAC6"].CGColor;
    self.showButton.layer.cornerRadius = 15;
    self.showButton.layer.masksToBounds = YES;
    [self.showButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)showButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showButtonEvent)]) {
        [self.delegate showButtonEvent];
    }
}

@end
