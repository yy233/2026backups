//
//  LoginAndRegiestViewSubTopView.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import "LoginAndRegiestViewSubTopView.h"

@implementation LoginAndRegiestViewSubTopView

- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type{
    
    if (type == LoginAndRegiestVC_Show_Type_PasswordLogin) {
        self.minFontLabel.hidden = YES;
    }else{
        self.minFontLabel.hidden = NO;
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.maxFontLabel];
        [self addSubview:self.minFontLabel];
        [self otherUI];
    }
    return self;
}
- (void)otherUI{
    [_maxFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_maxFontLabel.superview);
        make.left.equalTo(_maxFontLabel.superview).offset(26.0);
        make.height.offset(35.0);
    }];
    [_minFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_maxFontLabel.mas_bottom).offset(10);
        make.left.equalTo(_maxFontLabel);
        make.height.offset(15.0);
    }];
}

- (UILabel *)maxFontLabel{
    if (!_maxFontLabel) {
        _maxFontLabel = [[UILabel alloc]init];
        _maxFontLabel.text = @"欢迎业主回家！";
        _maxFontLabel.font = [UIFont boldSystemFontOfSize:32.0];
        _maxFontLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
    }
    return _maxFontLabel;
}
- (UILabel *)minFontLabel{
    if (!_minFontLabel) {
        _minFontLabel = [[UILabel alloc]init];
        _minFontLabel.text = @"未注册的手机号验证后自动创建未来物服账号";
        _minFontLabel.font = [UIFont systemFontOfSize:13.0];
        _minFontLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _minFontLabel.hidden = YES;
    }
    return _minFontLabel;
}

@end
