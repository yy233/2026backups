//
//  CityChooseHeadView.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "CityChooseHeadView.h"
@interface CityChooseHeadView ()
@property (nonatomic,strong) UIButton *imgBtn;

@end
@implementation CityChooseHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgBtn];
        [self addSubview:self.cityLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgBtn.superview.mas_centerY);
        make.left.equalTo(_imgBtn.superview.mas_left).offset(20);
        make.width.offset(120);
        make.height.offset(80);
    }];
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cityLabel.superview.mas_centerY);
        make.left.equalTo(_imgBtn.mas_right).offset(20);
        make.right.equalTo(_cityLabel.superview.mas_right).offset(-20);
    }];
}
- (UIButton *)imgBtn{
    if (!_imgBtn) {
        _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgBtn setTitle:@"当前定位:" forState:UIControlStateNormal];
        _imgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_imgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _imgBtn.backgroundColor = [UIColor blueColor];
    }
    return _imgBtn;
}

- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.text = @"";
        _cityLabel.textColor = [UIColor blackColor];
        _cityLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _cityLabel;
}
@end
