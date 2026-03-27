//
//  PesionVC.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//  养老

#import "PesionVC.h"
//#define  URL_PesionVC               @"http://old.zhsj.co/#/"
#define   URL_PesionVC              @"http://222.178.212.29/pension"      //养老
//————————————————
/** 弃用
 #define   URL_MedicalVC                                                    @"http://222.178.212.29/medicalCare"  //医疗
 #define   URL_PesionVC                                                     @"http://222.178.212.29/pension"      //养老
 */



@interface PesionVC ()
@property (nonatomic,strong) WKWebView  *webView;
@end

@implementation PesionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"养老";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [self setupNavigationBarWithBackItemNoTitle];
}
- (void)setUI{
    [_webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_webView.superview);
    }];
}

- (void)initData{
 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_PesionVC] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];
}
 
@end
