//
//  ElectroniNewRealNameAuthSectionOneHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectroniNewRealNameAuthSectionOneHeaderView.h"

@implementation ElectroniNewRealNameAuthSectionOneHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame =  CGRectMake(0, 0, Screen_W, 80);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleL];
        [self addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(15);
        make.height.offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.bottom.equalTo(_detailL.superview.mas_bottom).offset(-5);
        make.right.left.equalTo(_titleL);
    
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = FontSize_ElectronicSignature_Bold(19);
        _titleL.text = @"上传身份证";
         
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentLeft;
        _detailL.textColor =  Y_RGBA(136, 136, 136, 1);
        _detailL.font = FontSize_ElectronicSignature_Nomail(14);
        _detailL.text = @"请注意身份证与拍摄边缘对齐，请保证头像及身份证信息清晰可见（点击图片上传）";
        _detailL.numberOfLines = 2;
    }
 
    return _detailL;
}
@end
