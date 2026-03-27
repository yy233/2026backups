//
//  MyHouseAddSubPeronOkShowWebVc.m
//  Community
//
//  Created by 余莹 on 2021/10/15.
//

#import "MyHouseAddSubPeronOkShowScanCodeVc.h"
#import "MyHouseAddSubPeronOkShowScanCodeView.h"

@interface MyHouseAddSubPeronOkShowScanCodeVc ()
@property (nonatomic,strong) UIImageView *backImgView;
@property (nonatomic,strong) MyHouseAddSubPeronOkShowScanCodeView *showView;
@end

@implementation MyHouseAddSubPeronOkShowScanCodeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人员邀请";
    [self initView];
    [self initData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTransparentStyle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarStyleWithMainColor];
}
- (void)setupNavigationBarTransparentStyle {//透明
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setTitleTextAttributes:attDic];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;
        _backImgView.image = [UIImage imageNamed:@"houseAddPersonBack"];
    }
    return _backImgView;
}
#pragma mark ==
- (MyHouseAddSubPeronOkShowScanCodeView *)showView{
    if (!_showView) {
        _showView = [[MyHouseAddSubPeronOkShowScanCodeView alloc]init];
        [_showView.savePhoneBtnView.footerBtn addTarget:self action:@selector(saveImgToPhone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showView;
}
#pragma mark ==
- (void)initView{
    [self.view addSubview:self.backImgView];
    [self.view addSubview:self.showView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgView.superview);
    }];
    //底部横条高度KIndicatorHeight 34 0 */
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgView.superview).insets(UIEdgeInsetsMake( kNavBarHeight+10, 20, KIndicatorHeight+20,20 ));
    }];
}

#pragma mark ===
- (void)initData{
    self.showView.headerImg.image = [UIImage imageNamed:@"Informationregistration_Headportrait_Default"];
    self.showView.topLabel.text = [@"我是:" stringByAppendingString:[ShareUserInfo sharedUserInfo].userInfo.realName];
    self.showView.topDetailLabel.text = self.addInfoStr;
    self.showView.scanBottomHouseInfoDetailLabel.text = self.addressStr;
        if (self.showScanCodeWebUrlStr.length==0) {
            return;
        }else{
            [self.showView addPersonOkUrlIs:self.showScanCodeWebUrlStr];
        }
   
}

#pragma mark === //截图保存功能


-(UIImage *)captureImageFromView:(UIView *)view

{
    
    CGRect screenRect = [view bounds];
    
    //UIGraphicsBeginImageContext(screenRect.size);
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, [UIScreen mainScreen].scale);//清晰度 /【UIScreen mainScreen].scale本参数==指定当前设备的缩放因子，而0.0的意思就是自动调整缩放因子以适配显示屏
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

 
- (void)saveImgToPhone{
    DLog(@"保存到手机");

//    UIImage *willSaveImg =  [self captureImageFromView:self.showView.scanCodeImg.image];
    UIImage *willSaveImg =  [self captureImageFromView:self.view]; 
    UIImageWriteToSavedPhotosAlbum(willSaveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = @"" ;
//    if(error){
//        msg = @"保存图片失败" ;
//        Y_SVP_SHOW_ERR_MES(msg);
//    }else{
//        msg = @"保存图片成功" ;
//        Y_SVP_SHOW_SUCCESS_MES(msg);
//    }
    if(isNil(error)){
        msg = @"保存图片成功" ;
        Y_SVP_SHOW_SUCCESS_MES(msg);
    }else if (error.code==-1 || [error.localizedDescription containsString:@"未知错误"]){
        //未知错误 服务连接被中断
        msg = @"保存图片状态未获得，可去相册查看图片是否已经被保存";
        Y_SVP_SHOW_INFO_MES(msg);
      
    }else{
        msg = @"保存图片失败" ;
        Y_SVP_SHOW_ERR_MES(msg);
    }
 
}
@end
