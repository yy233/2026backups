//
//  WeatherCityChooseSectionHeaderViewWithTextLabel.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#define H_TextField 30
#define CornerRadius_TextField 3
#import "WeatherCityChooseSectionHeaderViewWithTextLabel.h"


@implementation WeatherCityChooseSectionHeaderViewWithTextLabel

- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W, 30);//固定30
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [Tool getColorWithHexString:@"#2B2C2F"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
