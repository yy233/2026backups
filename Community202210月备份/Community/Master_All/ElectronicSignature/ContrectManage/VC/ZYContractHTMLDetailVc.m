//
//  ZYContractHTMLDetailVc.m
//  Community
//
//  Created by ZY on 2021/5/27.
//

#import "ZYContractHTMLDetailVc.h"
#import <WebKit/WebKit.h>

@interface ZYContractHTMLDetailVc () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

@end

@implementation ZYContractHTMLDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.conName;
    
    [self initContractHTMLDetailData];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.delegate = self;
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (WKWebViewConfiguration *)webConfig {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
    }
    
    return _webConfig;
}

#pragma mark - 获取合同HTML详情数据
- (void)initContractHTMLDetailData {
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    NSDictionary *parms = @{@"conId" : self.conId, @"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractHTMLDetailUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
                [self webViewloadUrlStr:dict[@"url"]];
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 加载webView
- (void)webViewloadUrlStr:(NSString *)urlStr {
    
    NSLog(@"urlstr = %@", urlStr);
    NSURLRequest *pdfRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:pdfRequest];
}

#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD dismiss];
}

@end
