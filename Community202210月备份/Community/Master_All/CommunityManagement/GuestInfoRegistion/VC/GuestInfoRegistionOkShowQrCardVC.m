//
//  GuestInfoRegistionOkShowQrCardVC.m
//  Community
//
//  Created by 余莹 on 2021/6/30.
//

#import "GuestInfoRegistionOkShowQrCardVC.h"

@interface GuestInfoRegistionOkShowQrCardVC ()

@end

@implementation GuestInfoRegistionOkShowQrCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"访客通行码";
    [self rightBarButtonItemCustom];
    [self initView];
    [self initShowQrData];
}
// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"分享" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}
// 分享
- (void)navRightBtnAction {
    NSLog(@"分享");
    UIImage *saveImg = [self captureImageFromView:self.view];    
    WXMediaMessage *message = [WXMediaMessage message];
    // 多媒体消息中包含的图片数据对象
    WXImageObject *imageObject = [WXImageObject object];
    NSUInteger maxSize  = 32*1024;
    UIImage *image = [self compressImage:saveImg toByte:maxSize];
    // 图片真实数据内容
    NSData *data = UIImagePNGRepresentation(image);
    imageObject.imageData = data;
    // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    // 目标场景
    // 发送到聊天界面  WXSceneSession
    // 发送到朋友圈    WXSceneTimeline
    // 发送到微信收藏  WXSceneFavorite
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            NSLog(@"分享成功");
        }else {
            Y_SVP_SHOW_ERR_MES(@"分享失败");
        }
    }];
}
- (void)initView{
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.qrBackView];
    [self.qrBackView addSubview:self.qrBackImgV];
    [self.qrBackView addSubview:self.subTopBackView_4Proportion];
    [self.qrBackView addSubview:self.subBottomBackView_6Proportion];
    //
    [self.subTopBackView_4Proportion addSubview:self.guestNameShowLabel];
    [self.subTopBackView_4Proportion addSubview:self.addressShowLabel];
    [self.subTopBackView_4Proportion addSubview:self.showPasswordTipBtn];
    [self.subTopBackView_4Proportion addSubview:self.showPasswordStrBtn];
    //
    [self.subBottomBackView_6Proportion addSubview:self.timeDelineShowLabel];
    [self.subBottomBackView_6Proportion addSubview:self.footerView];
    [self.subBottomBackView_6Proportion addSubview:self.qrInfoImgV];

    [self setUI];
}
- (void)initShowQrData{
    //top
    //访客名字
    if (self.personNameShowStr.length==0) {
        self.guestNameShowLabel.text = @"";//名字

    }else if (self.personNameShowStr.length==1){
        self.guestNameShowLabel.text = @"*";//名字
    }else{
        self.guestNameShowLabel.text = [NSString stringWithFormat:@"%@*",[self.personNameShowStr substringToIndex:1]];
    }
    //地址
    self.addressShowLabel.text = self.houseNameShowStr;
    if (self.showPasswordStr.length>0) {
        [self.showPasswordStrBtn newAnBtnWithTextStr:self.showPasswordStr];
        self.showPasswordStrBtn.selected = YES;
    }

    //bottom
    self.timeDelineShowLabel.text = [NSString stringWithFormat:@"——— 该二维码将在%@内有效 ———",self.timeDelineShowStr];
    //改串的格式 {\"visitorId\":123456789} 第一个\是转第二个\的 第三个\是转引号用的
    NSString *qrOkStr = [NSString stringWithFormat:@"{\\\"visitorId\\\":%@}",self.visitorId];
    UIImage *qrImg = [CreatQrCodeImgTool creatQrCodeImgWithOnlyStr:qrOkStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.qrInfoImgV.image = qrImg;
    });
 
    
}
- (void)setUI{
    float tipLabelH = 35;
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tipLabel.superview);
        make.height.offset(tipLabelH);
    }];
    //
    [_qrBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLabel.mas_bottom).offset(20);
        make.left.equalTo(_qrBackView.superview).offset(16);
        make.right.equalTo(_qrBackView.superview).offset(-16);
        make.bottom.equalTo(_qrBackView.superview).offset(-20-kGHSafeAreaBottomHeight);
    }];
    [_qrBackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_qrBackImgV.superview);//图的分割线位置为46开位置
    }];
    //
    [_subTopBackView_4Proportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_subTopBackView_4Proportion.superview);
        make.height.equalTo(_subTopBackView_4Proportion.superview).multipliedBy(0.36);
    }];
    [_subBottomBackView_6Proportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_subBottomBackView_6Proportion.superview);
        make.height.equalTo(_subBottomBackView_6Proportion.superview).multipliedBy(0.64);
    }];
    
    [self changeBackViewsUI];//新版更改UI20220520
    [self subTopUI];
    [self subBottomUI];
     
}
- (void)changeBackViewsUI{
    
}
- (void)subTopUI{
    [_guestNameShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guestNameShowLabel.superview).offset(20);
        make.left.right.equalTo(_guestNameShowLabel.superview);
        make.height.offset(20);
    }];
    [_addressShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guestNameShowLabel.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(_addressShowLabel.superview);
    }];
    [_showPasswordTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(30);
        make.centerX.equalTo(_showPasswordTipBtn.superview);
        make.centerY.equalTo(_showPasswordTipBtn.superview).offset(-15);
    }];
    [_showPasswordStrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_showPasswordStrBtn.superview);
        make.top.equalTo(_showPasswordTipBtn.mas_bottom);
        make.bottom.equalTo(_showPasswordStrBtn.superview).offset(-15);
    }];
}
- (void)subBottomUI{
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview).offset(0);
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
    [_timeDelineShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timeDelineShowLabel.superview.mas_centerX);
        make.width.equalTo(_timeDelineShowLabel.superview);
        make.height.offset(20);
        make.bottom.equalTo(_footerView.mas_top).offset(0);
    }];
    [_qrInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_qrInfoImgV.superview.mas_centerX);
        make.bottom.equalTo(_timeDelineShowLabel.mas_top).offset(-10);
        make.top.equalTo(_qrInfoImgV.superview).offset(15);
        make.width.equalTo(_qrInfoImgV.mas_height);
    }];
    [self changQrInfoImgUI];
}
- (void)changQrInfoImgUI{
    
}
#pragma mark ==
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel  = [[UILabel alloc]init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.backgroundColor = Y_ColorWith16FromRGB(0x2672F9);
        _tipLabel.font = [UIFont systemFontOfSize:11];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"温馨提示：用户请将此二维码给予访客，当访客出入门禁时使用";
    }
    return _tipLabel;
}
- (UIView *)qrBackView{
    if (!_qrBackView) {
        _qrBackView = [[UIView alloc]init];
    }
    return _qrBackView;
}
- (UIImageView *)qrBackImgV{
    if (!_qrBackImgV) {
        _qrBackImgV = [[UIImageView alloc]init];
        _qrBackImgV.contentMode = UIViewContentModeScaleToFill;//
        _qrBackImgV.image = [UIImage imageNamed:@"Pass_Background_night"];
    }
    return _qrBackImgV;
}
- (UIView *)subTopBackView_4Proportion{
    if (!_subTopBackView_4Proportion) {
        _subTopBackView_4Proportion = [[UIView alloc]init];
    }
    return _subTopBackView_4Proportion;
}
- (UIView *)subBottomBackView_6Proportion{
    if (!_subBottomBackView_6Proportion) {
        _subBottomBackView_6Proportion = [[UIView alloc]init];
    }
    return _subBottomBackView_6Proportion;
}
//bottom
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"保存二维码"];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:23 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn addTarget:self action:@selector(footerGoBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (UILabel *)timeDelineShowLabel{
    if (!_timeDelineShowLabel) {
        _timeDelineShowLabel  = [[UILabel alloc]init];
        _timeDelineShowLabel.textColor = Y_ColorWith16FromRGB(0x999999);
        _timeDelineShowLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeDelineShowLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeDelineShowLabel;
}
- (UIImageView *)qrInfoImgV{
    if (!_qrInfoImgV) {
        _qrInfoImgV = [[UIImageView alloc]init];
        _qrInfoImgV.contentMode = UIViewContentModeScaleToFill;//
    }
    return _qrInfoImgV;
}
//top
- (UILabel *)guestNameShowLabel{
    if (!_guestNameShowLabel) {
        _guestNameShowLabel  = [[UILabel alloc]init];
        _guestNameShowLabel.textColor = [UIColor blackColor];
        _guestNameShowLabel.font = [UIFont boldSystemFontOfSize:17];
        _guestNameShowLabel.textAlignment = NSTextAlignmentCenter;
        _guestNameShowLabel.numberOfLines = 1;
    }
    return _guestNameShowLabel;
}
- (UILabel *)addressShowLabel{
    if (!_addressShowLabel) {
        _addressShowLabel  = [[UILabel alloc]init];
        _addressShowLabel.textColor = [UIColor blackColor];
        _addressShowLabel.font = [UIFont boldSystemFontOfSize:17];
        _addressShowLabel.textAlignment = NSTextAlignmentCenter;
        _addressShowLabel.numberOfLines = 0;
    }
    return _addressShowLabel;
}
- (UIButton *)showPasswordTipBtn{
    if (!_showPasswordTipBtn) {
        _showPasswordTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordTipBtn newAnBtnWithLayerCorNerNum:14 withLayerLineWidth:0.1 withLayerLineColor:[UIColor whiteColor]];
        [_showPasswordTipBtn newAnBtnWithBackColor:[Color_38BlueColor colorWithAlphaComponent:0.15]];
        [_showPasswordTipBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_showPasswordTipBtn newAnBtnWithTextStr:@"开门密码"];
        [_showPasswordTipBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
    }
    return _showPasswordTipBtn;
}

- (UIButton *)showPasswordStrBtn{
    if (!_showPasswordStrBtn) {
        _showPasswordStrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordStrBtn newAnBtnWithTextColorNomal:Color_153GrayColor withTextColorSelected:Color_38BlueColor withFont:[UIFont boldSystemFontOfSize:18.0] withLayerCorNerNum:0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        //初始状态
        _showPasswordStrBtn.selected = NO;
        [_showPasswordStrBtn newAnBtnWithTextStr:@"暂无"];
    }
    return _showPasswordStrBtn;
}



- (void)footerGoBackBtnAction{
    //隐藏保存btn后再存图
    self.footerView.footerBtn.hidden = YES;
    UIView *willUseView = self.view;
    [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:willUseView];
    self.footerView.footerBtn.hidden = NO;
    
//    [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:self.view];//self.qrBackView];
}
 
#pragma mark ---- 截图
- (UIImage *)captureImageFromView:(UIView *)view {
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, [UIScreen mainScreen].scale);//清晰度 /【UIScreen mainScreen].scale本参数==指定当前设备的缩放因子，而0.0的意思就是自动调整缩放因子以适配显示屏
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 微信分享图片压缩处理(微信图片要求小于32k)
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
