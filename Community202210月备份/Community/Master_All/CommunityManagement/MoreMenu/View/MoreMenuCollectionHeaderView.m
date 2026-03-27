//
//  UIViewMoreMenuCollectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/24.
//

#import "MoreMenuCollectionHeaderView.h"

@implementation MoreMenuCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W-32, 30);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
- (void)headerTitleTest:(NSString *)string{
    self.titleLabel.text = string;
}

@end
