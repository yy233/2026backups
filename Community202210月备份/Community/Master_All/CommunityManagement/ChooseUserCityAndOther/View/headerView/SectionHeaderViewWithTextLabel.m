//
//  SectionHeaderViewWithTextLabel.m
//  Community
//
//  Created by 余莹 on 2020/12/2.
//

#import "SectionHeaderViewWithTextLabel.h"
@interface SectionHeaderViewWithTextLabel ()

@end
@implementation SectionHeaderViewWithTextLabel

- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W, 30);//固定30
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        _titleLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
@end
