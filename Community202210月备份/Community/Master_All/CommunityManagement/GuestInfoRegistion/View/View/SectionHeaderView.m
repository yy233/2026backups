//
//  SectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

 
- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W, 40);//固定40
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
//        make.edges.equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
        make.edges.equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(10, 0, 10, 0));

    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
@end
