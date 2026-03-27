//
//  AccompanySectionHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import "AccompanySectionHeaderView.h"

@implementation AccompanySectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
   frame = CGRectMake(0, 0, Screen_W, 40);//固定40
   self = [super initWithFrame:frame];
   if (self) {
       self.backgroundColor = [UIColor clearColor];
       [self addSubview:self.rightMoreChooseBtn];
       [self setUI];
   }
   return self;
}
- (void)setUI{
    
   [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.titleLabel.superview).insets(UIEdgeInsetsMake(0, 16, 0, 60));
   }];
    [_rightMoreChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(20);
        make.right.equalTo(_rightMoreChooseBtn.superview.mas_right).offset(-16);
        make.centerY.equalTo(_rightMoreChooseBtn.superview.mas_centerY);
    }];
}
- (UIButton *)rightMoreChooseBtn{
    if (!_rightMoreChooseBtn) {
        _rightMoreChooseBtn= [[UIButton alloc]init];
        _rightMoreChooseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_rightMoreChooseBtn setTitle:@"多选" forState:UIControlStateNormal];
        [_rightMoreChooseBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_rightMoreChooseBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightMoreChooseBtn setTitleColor:[ThemeManager shareManager].mainTexDetailLightBluetColor forState:UIControlStateNormal];
        [_rightMoreChooseBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateSelected];
     }
    return _rightMoreChooseBtn;
}

@end
