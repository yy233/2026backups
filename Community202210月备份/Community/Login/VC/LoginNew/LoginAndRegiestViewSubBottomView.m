//
//  LoginAndRegiestViewSubBottomView.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import "LoginAndRegiestViewSubBottomView.h"
#import "LoginAndRegiestViewUseTool.h"


@implementation LoginAndRegiestViewSubBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        [self addSubview:self.privacypolicyTextView];
        [self addSubview:self.minFontLabel];
        [self addSubview:self.agreeBtn];
        [self otherUI];
    }
    return self;
}
- (void)otherUI{
    CGFloat h_privacypolicyTextV = KIndicatorHeight > 0 ? 20 : 20;
    [_privacypolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_privacypolicyTextView.superview);
        make.left.equalTo(_privacypolicyTextView.superview).offset(46.0);
        make.height.offset(h_privacypolicyTextV);
    }];
    [_minFontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_privacypolicyTextView.mas_bottom).offset(3);
        make.left.equalTo(_privacypolicyTextView).offset(3);
        make.height.offset(15.0);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.bottom.equalTo(_minFontLabel.mas_top);
        make.right.equalTo(_privacypolicyTextView.mas_left).offset(3);
    }];
    
    NSString *showStr = [NSString stringWithFormat:@"%@%@%@",NomalText,UserPolicyTitleText,PrivacyPolicyTitleText];
    self.privacypolicyTextView.attributedText = [self getThisPrivacyPolicyTextStr:showStr];}
 
- (UILabel *)minFontLabel{
    if (!_minFontLabel) {
        _minFontLabel = [[UILabel alloc]init];
        _minFontLabel.text = @"未注册的手机号将自动完成账号注册";
        _minFontLabel.font = [UIFont systemFontOfSize:11.0];
        _minFontLabel.textColor = [UIColor whiteColor];
    }
    return _minFontLabel;
}

//---隐私UI
- (UITextView *)privacypolicyTextView{
    if (!_privacypolicyTextView) {
        _privacypolicyTextView = [[UITextView alloc]init];
        _privacypolicyTextView.backgroundColor = [UIColor clearColor];
        _privacypolicyTextView.editable =  NO;
        _privacypolicyTextView.scrollEnabled = NO;
        _privacypolicyTextView.delegate = self; // 指定代理处理点击方法
    }
    return _privacypolicyTextView;
}
- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"weigouxuan_icon"] selectedImg:[UIImage imageNamed:@"wlw_gouxuan"]];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
- (void)agreeBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (NSMutableAttributedString *)getThisPrivacyPolicyTextStr:(NSString *)showAllStr{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showAllStr];
    NSInteger allStrIndexNum = showAllStr.length;
    NSRange nomalRange = [showAllStr rangeOfString:NomalText];
    NSRange userPolicyRange = [showAllStr rangeOfString:UserPolicyTitleText];
    NSRange privacyPolicyRange = [showAllStr rangeOfString:PrivacyPolicyTitleText];
 
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, allStrIndexNum)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0xFFFFFF) range:nomalRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:userPolicyRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:privacyPolicyRange];
    //link
    [attributedStr addAttribute:NSLinkAttributeName value:UserPolicyKey range:userPolicyRange];
    [attributedStr addAttribute:NSLinkAttributeName value:PrivacyPolicyKey range:privacyPolicyRange];
    return attributedStr;
}

//从登录页去协议页面
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if (URL.absoluteString == UserPolicyKey) {
        DLog(@"去用户协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_User;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
   
    }else if (URL.absoluteString == PrivacyPolicyKey){
        DLog(@"去隐私协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}
 

@end
