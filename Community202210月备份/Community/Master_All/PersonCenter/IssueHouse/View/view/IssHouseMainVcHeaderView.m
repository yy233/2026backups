//
//  IssHouseVcHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssHouseMainVcHeaderView.h"

@implementation IssHouseMainVcHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self addSubview:self.titleL];
        [self addSubview:self.leftBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    if ([ThemeManager shareManager].type==ThemeType_White) {
        self.backgroundColor = Y_RGBA(255, 248, 227, 1);
        _titleL.textColor = Y_RGBA(240, 138, 28, 1);
    }else{
        self.backgroundColor = Y_RGBA(255, 248, 227, 1);
        _titleL.textColor = Y_RGBA(240, 138, 28, 1);
    }
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleL.superview).insets(UIEdgeInsetsMake(0, 40, 0, 10));
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_top);
        make.bottom.equalTo(_titleL.mas_bottom);
        make.right.equalTo(_titleL.mas_left);
        make.left.equalTo(_leftBtn.superview.mas_left);
    }];
}
#pragma mark ==
- (UILabel *)titleL{//rgba(240, 138, 28, 1)
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.numberOfLines = 2;
        _titleL.text =  @"温馨提示：请正确选择发布信息的分类，分类错误会 导致信息违规下架。";
    }
    return _titleL;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"Selectcategory_Tips"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}
@end
