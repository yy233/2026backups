//
//  CircleShowCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "CircleShowCollectionViewCell.h"


@implementation CircleShowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.showLabel];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_showLabel.superview);
        make.centerX.centerY.equalTo(_showLabel.superview);
        make.height.width.offset(40);
    }];
    
}
#pragma mark ==
 
- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc]init];
        _showLabel.font = [UIFont boldSystemFontOfSize:15];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.layer.cornerRadius = 5;
        _showLabel.layer.masksToBounds = YES;
        _showLabel.textColor = [UIColor darkTextColor];
//        _showLabel.textColor = [ThemeManager shareManager].mainTextColor;
//        _showLabel.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    }
    return _showLabel;
}
#pragma mark ==
- (void)changeTextFont:(UIFont *)newFont{
    self.showLabel.font = newFont;
}
- (void)changeTextColor:(UIColor *)newColor{
    self.showLabel.textColor = newColor;
}
- (void)changeTextBackColor:(UIColor *)newLabelBackColor{
    self.showLabel.backgroundColor  = newLabelBackColor;
}
@end
