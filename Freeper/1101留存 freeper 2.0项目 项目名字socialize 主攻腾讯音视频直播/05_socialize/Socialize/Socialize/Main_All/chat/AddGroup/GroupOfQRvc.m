//
//  GroupOfQRvc.m
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import "GroupOfQRvc.h"
#import "GroupQrWillShareDoChooseGroupOrFriendListVc.h"

@implementation GroupOfQRvc

- (UIImageView *)bkImg{
    if(!_bkImg){
        _bkImg = [[UIImageView alloc]init];
        _bkImg.contentMode = UIViewContentModeScaleAspectFit;
        _bkImg.image = [UIImage imageNamed:@"qr_Bk"];
    }
    return _bkImg;
}

- (UIView *)centBkView{
    if(!_centBkView){
        _centBkView = [[UIView alloc]init];
        _centBkView.layer.cornerRadius = 6;
        _centBkView.clipsToBounds = NO;//越界也显示
    }
    return _centBkView;
}

- (UIImageView *)centQrImgV{
    if(!_centQrImgV){
        _centQrImgV = [[UIImageView alloc]init];
    }
    return _centQrImgV;
}
- (UIImageView *)groupFaceImgV{
    if(!_groupFaceImgV){
        _groupFaceImgV = [[UIImageView alloc]init];
        _groupFaceImgV.layer.cornerRadius = 6;
        _groupFaceImgV.layer.masksToBounds = YES;//本v越界不显示
//        _groupFaceImgV.clipsToBounds = NO;//子v越界也显示
    }
    return _groupFaceImgV;
}
- (UILabel *)gorupLabel{
    if(!_gorupLabel){
        _gorupLabel = [[UILabel alloc]init];
        _gorupLabel.font = [UIFont boldSystemFontOfSize:24.0];
        _gorupLabel.textAlignment = NSTextAlignmentCenter;
        _gorupLabel.numberOfLines = 2;
    }
    return _gorupLabel;
}
- (UIView *)btnBkV{
    if(!_btnBkV){
        _btnBkV = [[UIView alloc]init];
    }
    return _btnBkV;
}
- (UIButton *)saveBtn{
    if(!_saveBtn){
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_saveBtn newAnBtnWithImg:[UIImage imageNamed:@"qr_Down"]];
        [_saveBtn addTarget:self action:@selector(saveDownAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _saveBtn;
}

- (UIButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn newAnBtnWithImg:[UIImage imageNamed:@"qr_Share"]];
//        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn addTarget:self action:@selector(shareLinkDataToGroupOrFriendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initDatas];
    
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
}
- (void)initViews{
 
    [self.view addSubview:self.bkImg];
    [self.view addSubview:self.centBkView];
    [self.centBkView addSubview:self.centQrImgV];
    [self.centBkView addSubview:self.groupFaceImgV];
    [self.centBkView addSubview:self.gorupLabel];
    [self.view addSubview:self.btnBkV];
    [self.btnBkV addSubview:self.saveBtn];
    [self.btnBkV addSubview:self.shareBtn];
    [self setUIs];
}
- (void)setUIs{
    [_bkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bkImg.superview);
    }];
    [_centBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_centBkView.superview);
        make.width.equalTo(_centBkView.superview).offset(-100);
        make.height.equalTo(_centBkView.superview).multipliedBy(0.55);
    }];
    [_centQrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centQrImgV.superview);
        make.width.equalTo(_centQrImgV.superview).offset(-60);
        make.bottom.equalTo(_centQrImgV.superview).offset(-50);
        make.height.equalTo(_centQrImgV.mas_width);
    }];
    [_gorupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_gorupLabel.superview);
        make.bottom.equalTo(_centQrImgV.mas_top).offset(-15);
    }];
    [_groupFaceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80.0);
        make.centerX.equalTo(_groupFaceImgV.superview);
        make.bottom.equalTo(_gorupLabel.mas_top).offset(-15);
    }];
    //
    [_btnBkV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centBkView);
        make.top.equalTo(_centBkView.mas_bottom).offset(50);
        make.height.offset(30);
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.top.equalTo(_saveBtn.superview);
        make.width.equalTo(_saveBtn.superview).multipliedBy(0.5);
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.top.equalTo(_shareBtn.superview);
        make.width.equalTo(_saveBtn.superview).multipliedBy(0.5);
    }];
    //只显示分享
    _saveBtn.hidden = YES;
    [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_saveBtn.superview);
        make.top.bottom.equalTo(_shareBtn.superview);
        make.width.equalTo(_shareBtn.mas_height);
    }];
    
    
    [self subsColr];
}
#define  kTheme_Type_Key   @"Theme_Type"

- (void)subsColr{
    self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#F9F9F9"];
    self.centBkView.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
    self.centQrImgV.backgroundColor = [UIColor lightGrayColor];
    self.gorupLabel.textColor = [Y_ToolOfOthers getColorWithHexString:@"#515151"];
    self.groupFaceImgV.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self setup_NavigationBar_TransparentBk_blackText];
    NSString *titS = Y_LocaleTypeFile_NSLocalString(@"群聊二维码");
    self.title = titS;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setup_NavigationBar_TransparentBk_blackText];
//    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type
//    if([nowThemeStr isEqualToString: @"light"]){
//        [self setup_NavigationBar_TransparentBk_blackText];
//    }else{
//        [self setup_NavigationBar_TransparentBk_whiteText];
//    }
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type
    if([nowThemeStr isEqualToString: @"light"]){
        [self setup_NavigationBar_TransparentBk_blackText];
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#F9F9F9"];
        self.gorupLabel.textColor = [Y_ToolOfOthers getColorWithHexString:@"#515151"];
        //图片遵循tintcolor 图片颜色渲染
        [self.shareBtn newAnBtnWithImg:[[UIImage imageNamed:@"qr_Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.shareBtn setTintColor: self.gorupLabel.textColor];
//        [self.shareBtn newAnBtnWithImg:[UIImage imageNamed:@"qr_Share"]];
//        self.shareBtn.imageView.image  =  [[UIImage imageNamed:@"qr_Share"] imageWithTintColor:self.gorupLabel.textColor renderingMode:UIImageRenderingModeAlwaysTemplate];

    }else{
        [self setup_NavigationBar_TransparentBk_whiteText];
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#121212"];
        self.gorupLabel.textColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
      
        //图片遵循tintcolor 图片颜色渲染 
        [self.shareBtn newAnBtnWithImg:[[UIImage imageNamed:@"qr_Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.shareBtn setTintColor: self.gorupLabel.textColor];
        
        [self.shareBtn newAnBtnWithImg:[UIImage imageNamed:@"qr_Share"]];
        self.shareBtn.imageView.image  =  [[UIImage imageNamed:@"qr_Share"] imageWithTintColor:self.gorupLabel.textColor renderingMode:UIImageRenderingModeAlwaysTemplate];
 
        
    }
}
 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];//0824暂时不给nav颜色处理 只处理成非隐藏
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        
        [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex: Theme_Nav_COlOR_Light_Str]];
    }else{
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}



- (void)initDatas{
    self.gorupLabel.text = self.groupShowName;
    if(isNotNil(self.groupimg)){
        self.groupFaceImgV.image = self.groupimg;
    }
    if(self.groupID.length>0){
        CGFloat qr_w = Screen_W-100-60;
        NSDictionary *willUseQrDic = @{@"type":@(2001),
                                       @"groupId":self.groupID};
        NSString *qrJs = [Y_ToolOfOthers jsonStrWithDic:willUseQrDic];
      self.centQrImgV.image =  [UIImage generateQRCodeWithString:qrJs Size:qr_w];
    }
   
}
//保存图片
- (void)saveDownAction{
    self.btnBkV.hidden = YES;
    [Y_ToolOfOthers saveImgToPhone:self.view];
    self.btnBkV.hidden = NO;
    

}

//系统分享图片
- (void)shareAction{
    self.btnBkV.hidden = YES;
    UIImage *shareQrImg = [Y_ToolOfOthers captureImageFromView:self.view];
    self.btnBkV.hidden = NO;
    
    NSString *shS = [NSString stringWithFormat:@"%@ %@",self.groupShowName,self.groupID];
    if(isNotNil(shareQrImg)){
        NSArray *shareA =  @[shS,shareQrImg];
        [Y_ToolOfOthers shareActionWithArr:shareA withNowVc:self];
    }else{
        NSArray *shareA =  @[shS];
        [Y_ToolOfOthers shareActionWithArr:shareA withNowVc:self];
    }
   
}


//分享到群或者好友 做个link类型
- (void)shareLinkDataToGroupOrFriendAction{
    
    GroupQrWillShareDoChooseGroupOrFriendListVc *vc = [[GroupQrWillShareDoChooseGroupOrFriendListVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.willShareGroupID = self.groupID;
    vc.willShareGroupShowName = self.groupShowName;
    vc.willShareGroupimg = self.groupimg;
    [self.navigationController.navigationBar setTranslucent:NO];
    [vc.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//  //展示群列表，点击事件 作link 群分享数据。
//    [self onGroupConversation];

    
    
}

 

@end
