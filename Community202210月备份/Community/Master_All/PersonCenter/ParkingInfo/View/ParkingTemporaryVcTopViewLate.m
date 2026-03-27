//
//  ParkingTemporaryVcTopViewLate.m
//  Community
//
//  Created by 余莹 on 2021/9/27.
//

#import "ParkingTemporaryVcTopViewLate.h"

@interface ParkingTemporaryVcTopViewLate ()
@property (nonatomic,strong) UIImageView *topBackImgV;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
 
@end

@implementation ParkingTemporaryVcTopViewLate

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 250);
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview: self.topBackImgV];
        [self addSubview: self.backView];
        [self addSubview: self.titleL];
        //
      
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topBackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topBackImgV.superview);
        make.height.offset(138);
    }];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackImgV.mas_bottom).offset(-15);
        make.left.equalTo(_backView.superview).offset(10);
        make.right.equalTo(_backView.superview).offset(-10);
        make.height.offset(110);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.mas_left).offset(10);
        make.right.equalTo(_backView.mas_right).offset(-10);
        make.top.equalTo(_backView.mas_top).offset(5);
        make.height.offset(20);
    }];
    //
//    [_carPalteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(_titleL);
//        make.top.equalTo(_titleL.mas_bottom).offset(5);
//        make.height.offset(60);
//    }];
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    _topBackImgV.image = [UIImage imageNamed:@"carBackV"];
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}
#pragma mark ==
- (UIImageView *)topBackImgV{
    if (!_topBackImgV) {
        _topBackImgV = [[UIImageView alloc]init];
        _topBackImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topBackImgV;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"请输入有效车牌";
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}

 
@end
