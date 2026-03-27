//
//  PrivacyAgreementVCLate.m
//  Community
//
//  Created by 余莹 on 2022/4/13.
//

#import "PrivacyAgreementVCLate.h"

static NSString *kPrivacyInfo_AllLongUrl =  @"https://sqwy.zhsj.co/yinsi.html";  //  https://sqwy.zhsj.co/yinsi.html  https://sqwy.zhsj.co/yonghuxieyi.html" //0427隐私协议换成接口数据

@interface PrivacyAgreementVCLate () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PrivacyAgreementVCLate

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"APP协议";
    [self initView];
    [self initData];
}

- (void)setupNavigationBarWithBackItemNoTitle:(BOOL)animated{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setThisColorOfNav:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setThisColorOfNav:(BOOL)animated{
    UIColor *drakColor = Y_RGBA(0, 21, 52, 1);// 重蓝色 主蓝
    UIColor *wColor = Y_RGBA(255, 255, 255, 1);//白色
    [self setupNavigationBarWithBackItemNoTitle:animated];
 
    if(self.isLoginVcPushInToBool ){//深色
      [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor:drakColor];
      self.view.backgroundColor =  drakColor;
        
     }else{//提示页跳转情况的
         if ([ThemeManager shareManager].type == ThemeType_White) {
             [self setupNavigationBarTextColor:[UIColor blackColor] andBarItemsColor:[UIColor blackColor] andBackViewCustomColor:wColor];
             self.view.backgroundColor =  wColor;
         }else{
             [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor:drakColor];
             self.view.backgroundColor =  drakColor;
         }
         
    }
}
- (void)initView{
 
    
    [self.view addSubview:self.webview];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview).insets(UIEdgeInsetsMake(20, 16, KIndicatorHeight+20, 16));
    }];
}
 
- (void)initData{
 
    //网页数据的加载方式
    /**
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPrivacyInfo_AllLongUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
     [self.webView loadRequest:request];
     */
    
    //接口数据 
    WEAKSELF
    [PrivacyAgreementUserAgreementTool getAgreementDetailWithType:self.selfAgreementsType withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            AllAgreementUseModel *model = [AllAgreementUseModel mj_objectWithKeyValues:dic];
            [weakSelf webViewDataWithStr:[TextShowWithModelStr textShowWithModelStr:model.content]]; 
         }
    }];

}

#pragma mark ------------------------------------------------------------------------调整UI
/**
 
 - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
     [self.webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
            self.title = title;
         DLog(@"titletitle== %@",title);
     }];
   
      //背景色
      [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#001534\"" completionHandler:nil];// 重蓝色 主蓝 (0, 21, 52, 1) #001534  themeColorVCBackViewColor
      //修改字体大小 300%
      [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
      // 修改字体颜色 //245rgb
      [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#F5F5F5'"completionHandler:nil];
  
     
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//暗模式情景时防止颜色闪白色
         self.webView.hidden = NO;
     });
  
 }
 */
#pragma mark == 调整UI （匹配 url 加载数据时的颜色   [self.webView loadRequest:request]; ）


 
#pragma mark == 调整UI （匹配 htmlStr 加载数据时的颜色  [self.webView loadHTMLString:htmls baseURL:nil];）
- (void)webViewDataWithStr:(NSString *)str{
    NSString *content = [str stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSString *textColor16Str = @"";
    NSString *bgColor16Str = @"";
    
    if (self.isLoginVcPushInToBool) {//登录页过来的
        textColor16Str =  @"#F5F5F5";//白色
        //        textColor16Str = @"rgba(245,245,245,1)";
        bgColor16Str = @"rgba(0, 21, 52, 1)";//重蓝色
    }else{
        if ([ThemeManager shareManager].type == ThemeType_White) {
            textColor16Str =  @"#6E727D";//灰色
            //            textColor16Str = @"rgba( 110,114,125,1)";
            bgColor16Str = @"rgba(255, 255, 255, 1)"; //
        }else{
            textColor16Str =  @"#F5F5F5";//白色
            //            textColor16Str = @"rgba(245,245,245,1)";
            bgColor16Str = @"rgba(0, 21, 52, 1)";//重蓝色
        }
        
    }
    
    //content = @"<h3><strong style=\"color: rgb(255, 182, 193);\">未来物服尊重用户隐私。本隐私权政策适用于 重庆纵横世纪科技有限公司及其子公司或联属公司提供的所有产品、品牌、站点和服务（以下统称为\"未来物服”）。</strong></h3>";
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px !important;color:%@ !important ;background-color:%@ !important;}\n"
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
                       "</html>",textColor16Str,bgColor16Str,content];
    NSLog(@"htmls= %@",htmls);
    
    if (content.length>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmls baseURL:nil];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//暗模式情景时防止颜色闪白色
            self.webView.hidden = NO;
        });
    }
    
    
}

#pragma mark === views

- (WKWebView *)webview{
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.hidden = YES;//暗模式情景时防止颜色闪白色
        _webView.navigationDelegate = self;
    }
    return _webView;
}



@end
