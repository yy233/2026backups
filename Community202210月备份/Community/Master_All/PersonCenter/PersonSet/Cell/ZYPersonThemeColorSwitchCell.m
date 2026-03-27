//
//  ZYPersonThemeColorSwitchCell.m
//  Community
//
//  Created by ZY on 2021/10/19.
//

#import "ZYPersonThemeColorSwitchCell.h"

@interface ZYPersonThemeColorSwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *blackButton;

@property (weak, nonatomic) IBOutlet UIButton *whiteButton;

@property (weak, nonatomic) IBOutlet UILabel *blackLabel;

@property (weak, nonatomic) IBOutlet UILabel *whiteLabel;

@end

@implementation ZYPersonThemeColorSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.whiteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    self.blackButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [self.whiteButton addTarget:self action:@selector(whiteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.blackButton addTarget:self action:@selector(blackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setThemeType:(ZYThemeType)themeType {
    _themeType = themeType;
    
    if (_themeType == ZYThemeType_White) {
        self.whiteButton.selected = YES;
        self.blackButton.selected = NO;
    }else {
        self.whiteButton.selected = NO;
        self.blackButton.selected = YES;
    }
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    self.whiteLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.blackLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)whiteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteButtonEvent)]) {
        [self.delegate whiteButtonEvent];
    }
}

- (void)blackButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(blackButtonEvent)]) {
        [self.delegate blackButtonEvent];
    }
}

@end
