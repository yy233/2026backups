//
//  PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView.m
//  Community
//
//  Created by 余莹 on 2022/4/27.
//

#import "PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView.h"
/**
 
 "免责条款", 1)
 ("用户协议", 2)
 ("隐私政策", 3)
 ("入驻协议", 4)
 ("二手协议", 5)
 ("租赁协议", 6)
 ("关于我们", 8)
 ("缴费协议", 7)
 
 Agreements_Type_Disclaimer = 1,
 Agreements_Type_User,
 Agreements_Type_Privacy,
 Agreements_Type_Settlement,
 Agreements_Type_Secondhand,
 Agreements_Type_Lease,
 Agreements_Type_Payment,
 */

//
static NSString *DisclaimerPolicyTitleText = @"《免责条款》";
static NSString *UserPolicyTitleText = @"《用户协议》";
static NSString *PrivacyPolicyTitleText = @"《隐私协议》";
static NSString *InTheAgreementTitleText = @"《入驻协议》";
static NSString *SecondHandTitleText = @"《二手协议》";
static NSString *LeaseTitleText = @"《租赁协议》";
static NSString *AboutUsTitleText = @"《关于我们》";
static NSString *PaymentTitleText = @"《缴费协议》";


//
static NSString *DisclaimerPolicyKey= @"App_DisclaimerPolicy://";
static NSString *UserPolicyKey = @"App_UserPolicy://";
static NSString *PrivacyPolicyKey = @"App_PrivacyPolicy://";
static NSString *InTheAgreementKey = @"App_InTheAgreemen://";
static NSString *SecondHandKey = @"App_SecondHand://";
static NSString *LeaseKey = @"App_Lease://";
static NSString *AboutUsKey = @"App_AboutUs://";
static NSString *PaymentKey = @"App_Payment://";



@interface PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView () <UITextViewDelegate>
 
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) WKWebView *webview;//0428更换
@property (nonatomic,strong) UITextView *privacypolicyTextView;

@property (nonatomic,strong) UIButton *noAgreeBtn;
@property (nonatomic,strong) BaseTableViewFooterView *agreeBtnV;


@property (nonatomic,strong) AllAgreementUseModel* saveModel;

@property (nonatomic,strong) NSMutableArray *showTypeListTextArr;
@property (nonatomic,strong) NSMutableArray *showTypeListKeyArr;

@end

@implementation PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView

- (NSMutableArray *)showTypeListTextArr{
    if (!_showTypeListTextArr) {
        _showTypeListTextArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _showTypeListTextArr;
}
- (NSMutableArray *)showTypeListKeyArr{
    if (!_showTypeListKeyArr) {
        _showTypeListKeyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _showTypeListKeyArr;
}
- (void)fillNewPrivacyAgreementUserAgreementVersionInfo:(AllAgreementUseModel *)model{
    self.saveModel = model;
    if (model.typeList.count <= 0) {
        return;
    }
    [self thisTypeListSetTextWithModel:model];
}
#pragma mark == TextView 数据处理

- (void)thisTypeListSetTextWithModel:(AllAgreementUseModel *)model{
    [self.showTypeListTextArr removeAllObjects];
    [self.showTypeListKeyArr removeAllObjects];

    for (int i = 0; i < model.typeList.count; i++) {
        
        Agreements_Type oneType = [model.typeList[i] integerValue];
        switch (oneType) {
            case Agreements_Type_Disclaimer:
            {
                [self.showTypeListTextArr addObject:DisclaimerPolicyTitleText];
                [self.showTypeListKeyArr addObject:DisclaimerPolicyKey];

            }
                break;
            case Agreements_Type_User:
            {
                [self.showTypeListTextArr addObject:UserPolicyTitleText];
                [self.showTypeListKeyArr addObject:UserPolicyKey];

            }
                break;
            case Agreements_Type_Privacy:
            {
                [self.showTypeListTextArr addObject:PrivacyPolicyTitleText];
                [self.showTypeListKeyArr addObject:PrivacyPolicyKey];

            }
                break;
            case Agreements_Type_Settlement:
            {
                [self.showTypeListTextArr addObject:InTheAgreementTitleText];
                [self.showTypeListKeyArr addObject:InTheAgreementKey];

            }
                break;
            case Agreements_Type_Secondhand:
            {
                [self.showTypeListTextArr addObject:SecondHandTitleText];
                [self.showTypeListKeyArr addObject:SecondHandKey];

            }
                break;
            case Agreements_Type_Lease:
            {
                [self.showTypeListTextArr addObject:LeaseTitleText];
                [self.showTypeListKeyArr addObject:LeaseKey];

            }
                break;
            case Agreements_Type_AboutUs:
            {
                [self.showTypeListTextArr addObject:AboutUsTitleText];
                [self.showTypeListKeyArr addObject:AboutUsKey];

            }
                break;
            case Agreements_Type_Payment:
            {
                [self.showTypeListTextArr addObject:PaymentTitleText];
                [self.showTypeListKeyArr addObject:PaymentKey];

            }
                break;
            default:
                break;
        }

    }
    
    self.privacypolicyTextView.attributedText = [self getThisShowText];

}

- (NSMutableAttributedString *)getThisShowText{
    if (self.saveModel.notice.length <= 0) {
        self.saveModel.notice = @"更新协议如下:";
    }
    //str
    NSString *showAllStr = [NSString stringWithFormat:@"%@", [TextShowWithModelStr textShowWithModelStr:self.saveModel.notice] ];
    for (int i = 0; i < self.showTypeListTextArr.count; i++) {
        showAllStr =  [showAllStr stringByAppendingString: [NSString stringWithFormat:@"\n%@",self.showTypeListTextArr[i]]];
    }

    //range
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showAllStr];
    NSInteger allStrIndexNum = showAllStr.length;
    NSRange nomalRange = [showAllStr rangeOfString:  [TextShowWithModelStr textShowWithModelStr:self.saveModel.notice] ];
    NSRange otherColorPolicyRange = NSMakeRange(self.saveModel.notice.length, showAllStr.length-self.saveModel.notice.length);
 
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, allStrIndexNum)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2B2C2F) range:nomalRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:otherColorPolicyRange];
    //link
    
    //
    NSRange subRange_Disclaimer = [showAllStr rangeOfString: DisclaimerPolicyTitleText];
    NSRange subRange_User = [showAllStr rangeOfString: UserPolicyTitleText];
    NSRange subRange_Privacy = [showAllStr rangeOfString: PrivacyPolicyTitleText];
    NSRange subRange_InTheAgreement = [showAllStr rangeOfString: InTheAgreementTitleText];
    NSRange subRange_SecondHand = [showAllStr rangeOfString: SecondHandTitleText];
    NSRange subRange_Lease = [showAllStr rangeOfString: LeaseTitleText];
    NSRange subRange_AboutUs = [showAllStr rangeOfString: AboutUsTitleText];
    NSRange subRange_Payment = [showAllStr rangeOfString: PaymentTitleText];
 
    [attributedStr addAttribute:NSLinkAttributeName value:DisclaimerPolicyKey range:subRange_Disclaimer];
    [attributedStr addAttribute:NSLinkAttributeName value:UserPolicyKey range:subRange_User];
    [attributedStr addAttribute:NSLinkAttributeName value:PrivacyPolicyKey range:subRange_Privacy];
    [attributedStr addAttribute:NSLinkAttributeName value:InTheAgreementKey range:subRange_InTheAgreement];
    [attributedStr addAttribute:NSLinkAttributeName value:SecondHandKey range:subRange_SecondHand];
    [attributedStr addAttribute:NSLinkAttributeName value:LeaseKey range:subRange_Lease];
    [attributedStr addAttribute:NSLinkAttributeName value:AboutUsKey range:subRange_AboutUs];
    [attributedStr addAttribute:NSLinkAttributeName value:PaymentKey range:subRange_Payment];
    return attributedStr;
}
//非登录页跳转去的 保持系统当前主题色
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if (URL.absoluteString == DisclaimerPolicyKey) {
        DLog(@"去免责协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Disclaimer;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
   
    }else if (URL.absoluteString == UserPolicyKey) {
        DLog(@"去用户协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_User;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
   
    }else if (URL.absoluteString == PrivacyPolicyKey){
        DLog(@"去隐私协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else if (URL.absoluteString == InTheAgreementKey){
        DLog(@"去入驻协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Settlement;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else if (URL.absoluteString == SecondHandKey){
        DLog(@"去二手协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Secondhand;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else if (URL.absoluteString == LeaseKey){
        DLog(@"去租赁协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Lease;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else if (URL.absoluteString == AboutUsKey){
        DLog(@"去关于我们");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_AboutUs;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else if (URL.absoluteString == PaymentKey){
        DLog(@"去缴费协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Payment;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}
#pragma mark == webView  舍弃 留档
/**
 
 [self webViewDataWithStr:[TextShowWithModelStr textShowWithModelStr: model.content]];
 
 #pragma mark == 调整UI （匹配 htmlStr 加载数据时的颜色  [self.webView loadHTMLString:htmls baseURL:nil];）
 - (void)webViewDataWithStr:(NSString *)str{
     
     NSString *content = [str stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
     content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
     content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
     content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
     
     NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                        "<head> \n"
                        "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                        "<style type=\"text/css\"> \n"
 //                       "body {font-size:15px;color:%@;background-color:%@;}\n"
                        "body {font-size:13px;}\n"
                        "</style> \n"
                        "</head> \n"
                        "<body>"
                        "<script type='text/javascript';charset='utf-8'>"
                        "window.onload = function(){\n"
                        "var $img = document.getElementsByTagName('img');\n"
                        "for(var p in  $img){\n"
                        " $img[p].style.width = '100%%';\n"
                        "$img[p].style.height ='auto'\n"
                        "}\n"
                        "}"
                        "</script>%@"
                        "</body>"
                        "</html>",content];
     NSLog(@"htmls= %@",htmls);
  
      if (content.length>0) {
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.webview loadHTMLString:htmls baseURL:nil];
          });
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//暗模式情景时防止颜色闪白色
              self.webview.hidden = NO;
          });
      }
  
     
 }

 */


- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleL];
//        [self.backView addSubview:self.webview];
        [self.backView addSubview:self.privacypolicyTextView];
        [self.backView addSubview:self.noAgreeBtn];
        [self.backView addSubview:self.agreeBtnV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_backView.superview).offset(-52);//26*2
        make.centerX.centerY.equalTo(_backView.superview);
        make.height.equalTo(_backView.superview).multipliedBy(0.65);
    }];
    //top
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.equalTo(_titleL.superview).offset(-48);//24*2
        make.centerX.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.superview).offset(20);
    }];
    //bottom
    [_agreeBtnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_agreeBtnV.superview);
        make.height.offset(50);
        make.bottom.equalTo(_agreeBtnV.superview).offset(-25);
    }];
    [_noAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(100);
        make.centerX.equalTo(_noAgreeBtn.superview);
        make.bottom.equalTo(_agreeBtnV.mas_top).offset(-10);
    }];
    //center
    [_privacypolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_titleL);//24*2
        make.centerX.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.bottom.equalTo(_noAgreeBtn.mas_top).offset(-15.0);
    }];
}

#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.clipsToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:18.0];
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = @"温馨提示";
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (WKWebView *)webview{
    if (!_webview) {
        _webview = [[WKWebView alloc]init];
        _webview.hidden = YES;//暗模式情景时防止颜色闪白色
    }
    return _webview;
}
//---隐私UI
- (UITextView *)privacypolicyTextView{
    if (!_privacypolicyTextView) {
        _privacypolicyTextView = [[UITextView alloc]init];
        _privacypolicyTextView.backgroundColor = [UIColor whiteColor];
        _privacypolicyTextView.editable =  NO;
        _privacypolicyTextView.scrollEnabled = NO;
        _privacypolicyTextView.delegate = self; // 指定代理处理点击方法
    }
    return _privacypolicyTextView;
}
 
- (UIButton *)noAgreeBtn{
    if (!_noAgreeBtn) {
        _noAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noAgreeBtn newAnBtnWithTextStr:@"不同意"];
        [_noAgreeBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_noAgreeBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x2B2C2F)];
        [_noAgreeBtn addTarget:self action:@selector(noAgreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noAgreeBtn;
}
- (BaseTableViewFooterView *)agreeBtnV{// |26|24 ==50
    if (!_agreeBtnV) {
        _agreeBtnV = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        [_agreeBtnV setBtnFram:CGRectMake(50, 0, Screen_W-100, 50) ];
        [_agreeBtnV.footerBtn newAnBtnWithTextStr:@"同意并继续"];
        [_agreeBtnV.footerBtn newAnBtnWithLayerCorNerNum:3.5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_agreeBtnV.footerBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtnV;
}

#pragma mark ==

- (void)agreeBtnAction{
    DLog(@"同意按钮");
    WEAKSELF
    if (self.saveModel.typeList.count <= 0) {
        //删除本视图
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeFromSuperview];
        });
    }else{
        [PrivacyAgreementUserAgreementTool agreeAgreementOfNowGetAllTypeWithTypeList:self.saveModel.typeList.mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                //删除本视图
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"操作成功！");
                    [weakSelf removeFromSuperview];
                });
                
            }
        }];
    }
    
}

- (void)noAgreeBtnAction{
    DLog(@"不同意按钮  退出流程 || 先block 再remove");
    if (isNil(self.notAgreeActionBlock)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];//remove self
        });
        return;
    }else{
        self.notAgreeActionBlock();//退出block
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];//remove self
        });

    }
  
}

@end
