//
//  ZhiBoPivTypeBaoMingVc.m
//  Socialize
//
//  Created by 余莹 on 2023/7/13.
//

#import "ZhiBoPivTypeBaoMingVc.h"
#import "ZhiBoBaseNetTools.h"
#define  Height50 (50)
#define  thisView_BkColor    rgba(27, 26, 39,1)


@interface ZhiBoPivTypeBaoMingVc ()
@property (nonatomic,strong) ZhiBoPivTypePassWordView *mastView;
@property (nonatomic,strong) UIButton *footerB;

@end

@implementation ZhiBoPivTypeBaoMingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setup_NavigationBar_TransparentBk_CustomColorText:[UIColor whiteColor]];

//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (@available(iOS 15.0, *)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        [appearance configureWithDefaultBackground];
//        appearance.shadowColor = nil;
//        appearance.backgroundEffect = nil;
//        appearance.backgroundColor =  [self navBackColor];
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
//        navigationBar.barTintColor = [self navBackColor];
//        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
//        navigationBar.standardAppearance = appearance;
//        navigationBar.scrollEdgeAppearance= appearance;
//    }
//    else {
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
//        navigationBar.barTintColor = [self navBackColor];
//        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
    
    self.title = @"";
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关

}
//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{//本页面颜色保持黑色bk 黑色nav 白色状态栏
    return UIStatusBarStyleLightContent;//白色内容
}



- (UIColor *)navBackColor {
    return [UIColor clearColor];
}

#pragma mark ===
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
#pragma mark ===
- (void)initViews{
 
    self.view.backgroundColor = thisView_BkColor;
    [self.view addSubview:self.mastView];
    [self.view addSubview:self.footerB];
    [_mastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_mastView.superview);
        make.height.equalTo(_mastView.superview).multipliedBy(0.6);
    }];
    [_footerB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.equalTo(_footerB.superview).offset(-60);
        make.centerX.equalTo(_footerB.superview);
        make.bottom.equalTo(_footerB.superview).offset(-100);
    }];
    [self.footerB addTarget:self action:@selector(baoMingAction) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)baoMingAction{
    
    if(self.mastView.passwordTF.text.length <= 0){
        Y_SVP_SHOW_INFO_MES(Y_LocaleTypeFile_NSLocalString(@"请输入密码"));
        return;
    }
    if(![self.mastView.passwordTF.text isEqualToString:[TextShowWithModelStr textShowWithModelStr:self.zhiBoInfoModel.recode]]){
        Y_SVP_SHOW_INFO_MES( Y_LocaleTypeFile_NSLocalString(@"密码错误"));
        return;
    }
    //私密直播类型 直接报名
    NSDictionary *baoMinDic = @{
        @"activityId" : self.zhiBoInfoModel.activityId,
        @"account" : [ShareUserInfo share].userInfo.address,

    };
    WEAKSELF
    [ZhiBoBaseNetTools oneLookerBaoMinOneActivityWithParms:baoMinDic withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            if(self.zhiBoInfoModel.title.length > 0){
                NSString *rooNme = [NSString stringWithFormat:@"%@",self.zhiBoInfoModel.title];
                NSString *showStr = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"报名%@成功") ,rooNme];
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES( Y_LocaleTypeFile_NSLocalString(showStr));
                    if(isNotNil(self.baoMingSuccessNeedRefActionBool)){
                        self.baoMingSuccessNeedRefActionBool();
                    }
                    [weakSelf popVC];
                });
            }else{
                Y_SVP_SHOW_SUCCESS_MES( Y_LocaleTypeFile_NSLocalString(@"报名成功"));
            }
           
        }
    }];
}


#pragma mark ==
- (ZhiBoPivTypePassWordView *)mastView{
    if(!_mastView){
        _mastView = [[ZhiBoPivTypePassWordView alloc]initWithFrame:CGRectZero];
    }
    return _mastView;
}
- (UIButton *)footerB{
    if(!_footerB){
        _footerB = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *btnTitleStr = Y_LocaleTypeFile_NSLocalString(@"确定报名");
        [_footerB setTitle:btnTitleStr  forState:UIControlStateNormal];
        [_footerB newAnBtnWithBackColor:Color_Socialize_GreenColor];
        [_footerB newAnBtnWithTextColor:[UIColor blackColor]];
        [_footerB newAnBtnWithLayerCorNerNum:24.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerB;
}
@end

#pragma mark ==  ZhiBoPivTypePassWordView

@implementation ZhiBoPivTypePassWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topImgv];
        [self addSubview:self.topLabel];
        [self addSubview:self.passwordTitleL];
        [self addSubview:self.passwordBkView];
        [self.passwordBkView addSubview:self.passwordTF];
        [self setUIs];
    }
    return self;
}
- (void)setUIs{
    
    [_topImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topImgv.superview);
        make.width.height.offset(Height50);
        make.top.equalTo(_topImgv.superview).offset(KNavBarHeight+20);
    }];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_topLabel.superview);
        make.height.offset(Height50);
        make.top.equalTo(_topImgv.mas_bottom).offset(20);
    }];
    
    //
    [_passwordBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_passwordBkView.superview).offset(-60);
        make.centerX.width.equalTo(_passwordBkView.superview);
        make.height.offset(Height50);
        make.bottom.equalTo(_passwordBkView.superview).offset(0);
    }];
    
    [_passwordTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_passwordTitleL.superview);
        make.height.offset(Height50);
        make.bottom.equalTo(_passwordBkView.mas_top).offset(-50);
    }];
    
    //
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(_passwordTF.superview);
        make.width.equalTo(_passwordTF.superview).multipliedBy(0.5);
    }];

}

#pragma mark ===

- (UIView *)topImgv{
    if(!_topImgv){
        _topImgv = [[UIImageView alloc]init];
        _topImgv.contentMode = UIViewContentModeScaleAspectFit;
        _topImgv.layer.cornerRadius = 10;
        _topImgv.layer.masksToBounds = YES;
        _topImgv.backgroundColor = [UIColor whiteColor];
    }
    return _topImgv;
}
- (UILabel *)topLabel{
    if(!_topLabel){
        
        _topLabel = [[UILabel alloc]init];
        _topLabel.text = @"Freeper Chat";
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor  = [UIColor whiteColor];
        _topLabel.font = [UIFont boldSystemFontOfSize:30.0];
    }
    return _topLabel;
}

- (UILabel *)passwordTitleL{
    if(!_passwordTitleL){
        _passwordTitleL = [[UILabel alloc]init];
        _passwordTitleL.text = Y_LocaleTypeFile_NSLocalString(@"请输入房间密码") ;
        _passwordTitleL.textAlignment = NSTextAlignmentCenter;
        _passwordTitleL.textColor  = [UIColor whiteColor];
        _passwordTitleL.font = [UIFont systemFontOfSize:14.0];
    }
    return _passwordTitleL;
}

- (UIView *)passwordBkView{
    if(!_passwordBkView){
        _passwordBkView = [[UIView alloc] init];
//        _passwordBkView.backgroundColor = [UIColor clearColor];
        _passwordBkView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _passwordBkView.layer.cornerRadius = 24;
        _passwordBkView.layer.masksToBounds = YES;
    }
    return _passwordBkView;
}

- (UITextField *)passwordTF{
    if(!_passwordTF){
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.placeholder = @"";
        _passwordTF.textColor = [UIColor whiteColor];
        _passwordTF.font = [UIFont boldSystemFontOfSize:18.0];
        _passwordTF.textAlignment = NSTextAlignmentCenter;
    }
    return _passwordTF;
}


@end
