//
//  ElectronicMyInfoHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicMyInfoHeaderView.h"

@implementation ElectronicMyInfoHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 120 + KStatusBarHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backVImgV];
        [self addSubview:self.headImgV];
        [self addSubview:self.nameL];
        [self addSubview:self.renZhengShowBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backVImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backVImgV.superview);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImgV.superview.mas_bottom).offset(-25);
        make.left.equalTo(_headImgV.superview.mas_left).offset(25);
        make.width.offset(55);
        make.height.offset(55);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top).offset(3);
        make.left.equalTo(_headImgV.mas_right).offset(18);
        make.right.equalTo(_nameL.superview.mas_right).offset(20);
    }];
    [_renZhengShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImgV.mas_bottom).offset(-3);
        make.left.equalTo(_headImgV.mas_right).offset(18);
        make.height.offset(18);
        make.width.offset(70);
    }];
    
}
#pragma mark ==
- (UIImageView *)backVImgV{
    if (!_backVImgV) {
        _backVImgV = [[UIImageView alloc]init];
        _backVImgV.image = [[ZYThemeManager shareManager] themeImageNamed:@"zlbg"];
        _backVImgV.contentMode = UIViewContentModeScaleToFill;
    }
    return _backVImgV;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
        _headImgV.contentMode = UIViewContentModeScaleAspectFill;
        [_headImgV zy_cornerRadiusAdvance:55 * 0.5 rectCornerType:UIRectCornerAllCorners];
    }
    return _headImgV;
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [UIColor whiteColor];
        _nameL.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameL;
}
- (UIButton *)renZhengShowBtn{
    if (!_renZhengShowBtn) {
        _renZhengShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _renZhengShowBtn.userInteractionEnabled = NO;
        _renZhengShowBtn.titleLabel.font = FontSize_ElectronicSignature_Nomail(12);
        _renZhengShowBtn.layer.cornerRadius = 18*0.5;
        _renZhengShowBtn.layer.masksToBounds = YES;
        [_renZhengShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [_renZhengShowBtn setTitle:@"已认证" forState:UIControlStateNormal];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            _renZhengShowBtn.backgroundColor = [UIColor whiteColor];
        }else {
            _renZhengShowBtn.backgroundColor = Y_RGBA(29, 61, 121, 1);
        }
        [_renZhengShowBtn setTitleColor:Y_RGBA(170, 174, 185, 1) forState:UIControlStateNormal];
        [_renZhengShowBtn setTitleColor:Y_RGBA(38, 114, 249, 1) forState:UIControlStateSelected];
        [_renZhengShowBtn setImage:[UIImage imageNamed:@"renzheng"] forState:UIControlStateNormal];
        [_renZhengShowBtn setImage:[UIImage imageNamed:@"renzheng--"] forState:UIControlStateSelected];
        _renZhengShowBtn.selected = NO;
    }
    return _renZhengShowBtn;
}
@end
