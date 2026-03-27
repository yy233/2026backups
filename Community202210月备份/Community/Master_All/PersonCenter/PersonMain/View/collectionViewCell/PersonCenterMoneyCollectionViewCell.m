//
//  PersonCenterMoneyCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterMoneyCollectionViewCell.h"

@implementation PersonCenterMoneyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topL];
        [self.contentView addSubview:self.centerL];
        [self.contentView addSubview:self.bottomL];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topL.superview.mas_top);
        make.left.equalTo(_topL.superview.mas_left);
        make.right.equalTo(_topL.superview.mas_right);
        make.height.offset(15);
    }];
//    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_bottomL.superview.mas_bottom).offset(20);//越出cell 用以增加centerL高度
//        make.left.equalTo(_bottomL.superview.mas_left);
//        make.right.equalTo(_bottomL.superview.mas_right);
//        make.height.offset(15);
//    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomL.superview.mas_bottom).offset(-20);
        make.left.equalTo(_bottomL.superview.mas_left);
        make.right.equalTo(_bottomL.superview.mas_right);
        make.height.offset(15);
    }];
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topL.mas_bottom);
        make.left.equalTo(_centerL.superview.mas_left);
        make.right.equalTo(_centerL.superview.mas_right);
        make.bottom.equalTo(_bottomL.mas_top);
    }];
}
#pragma mark ==
- (UILabel *)topL{
    if (!_topL) {
        _topL = [[UILabel alloc]init];
        _topL.font = [UIFont boldSystemFontOfSize:12];
        _topL.textAlignment = NSTextAlignmentCenter;
    }
    _topL.textColor = [ThemeManager shareManager].mainTextColor;
    return _topL;
}
- (UILabel *)centerL{
    if (!_centerL) {
        _centerL = [[UILabel alloc]init];
        _centerL.font = [UIFont boldSystemFontOfSize:20];
        _centerL.textAlignment = NSTextAlignmentCenter;
    }
    _centerL.textColor = [ThemeManager shareManager].mainTextColor;
    return _centerL;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.font = [UIFont systemFontOfSize:12];
        _bottomL.textAlignment = NSTextAlignmentCenter;
    }
    _bottomL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _bottomL;
}
@end
