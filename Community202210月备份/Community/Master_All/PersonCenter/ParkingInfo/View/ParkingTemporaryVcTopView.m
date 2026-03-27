//
//  ParkingTemporaryVcTopView.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingTemporaryVcTopView.h"

@interface ParkingTemporaryVcTopView () <UITextFieldDelegate>
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIView *lineV;
@end


@implementation ParkingTemporaryVcTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textF.delegate = self;
        self.backView.backgroundColor = Y_ColorWith16FromRGB(0x2F63BE);
        self.textFieldBackV.backgroundColor = Y_ColorWith16FromRGB(0x224B94);
        self.titleL.text = @"绑定车牌号";
        [self.textFieldBackV addSubview:self.saveBtn];
        [self.saveBtn addSubview:self.lineV];
        [self setReUI];
         self.saveBtn.hidden = YES;//初始状态
        
    }
    return self;
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField.text.length>0) {
        self.saveBtn.hidden = NO;
    }else{
        self.saveBtn.hidden = YES;
    }
}
#pragma mark ==
- (void)setReUI{
    WEAKSELF
    [self.textF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.textF.superview).insets(UIEdgeInsetsMake(0, 10, 0, 60));
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf.saveBtn.superview);
        make.left.equalTo(weakSelf.textF.mas_right).offset(5);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(_lineV.superview);
        make.height.equalTo(_lineV.superview).multipliedBy(0.3);
        make.width.offset(1);
    }];
}
#pragma mark ==
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_ColorWith16FromRGB(0xABC1E8);
    }
    return _lineV;
}
- (UIButton *)saveBtn{
    if (!_saveBtn ) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn newAnBtnWithTextStr:@"保存"];
        [_saveBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_saveBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_saveBtn addTarget:self action:@selector(seaveActon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (void)seaveActon{
    self.saveBlock();
}

@end
