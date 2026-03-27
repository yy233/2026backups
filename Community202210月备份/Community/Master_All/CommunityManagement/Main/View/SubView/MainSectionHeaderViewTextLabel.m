//
//  MainSectionHeaderViewTextLabel.m
//  Community
//
//  Created by 余莹 on 2020/11/27.
//

#import "MainSectionHeaderViewTextLabel.h"

@implementation MainSectionHeaderViewTextLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:20];
        self.textColor = [ThemeManager shareManager].mainSectionHeaderTextColor;
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.rightBtnFunCellSectionHeaderWillShow];
        self.rightBtnFunCellSectionHeaderWillShow.hidden = YES;
    }
    return self;
}
- (UIButton *)rightBtnFunCellSectionHeaderWillShow{
    if (!_rightBtnFunCellSectionHeaderWillShow) {
        _rightBtnFunCellSectionHeaderWillShow = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtnFunCellSectionHeaderWillShow.frame = CGRectMake(Screen_W-32-40, 0, 40, 30);
        [_rightBtnFunCellSectionHeaderWillShow setTitle:@"更多" forState:UIControlStateNormal];
        _rightBtnFunCellSectionHeaderWillShow.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtnFunCellSectionHeaderWillShow setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            [_rightBtnFunCellSectionHeaderWillShow setImage:[UIImage imageNamed:@"rightSkip"] forState:UIControlStateNormal];
        }else{
            [_rightBtnFunCellSectionHeaderWillShow setImage:[UIImage imageNamed:@"rightSkip_white"] forState:UIControlStateNormal];
        }
        [_rightBtnFunCellSectionHeaderWillShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -_rightBtnFunCellSectionHeaderWillShow.imageView.bounds.size.width-5, 0, _rightBtnFunCellSectionHeaderWillShow.imageView.bounds.size.width)];
        [_rightBtnFunCellSectionHeaderWillShow setImageEdgeInsets:UIEdgeInsetsMake(0, _rightBtnFunCellSectionHeaderWillShow.titleLabel.bounds.size.width+5, 0, -_rightBtnFunCellSectionHeaderWillShow.titleLabel.bounds.size.width)];//5间隔
    }
    return _rightBtnFunCellSectionHeaderWillShow;
}
@end
