//
//  MedicalVC.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//  医疗

#import  "MedicalVC.h"
//#define   URL_MedicalVC                @"http://health.zhsj.co/#/"
#define   URL_MedicalVC                @"http://222.178.212.29/medicalCare"  //医疗

@interface MedicalVC ()
@property (nonatomic,strong) WKWebView  *webView;
@end

@implementation MedicalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医疗";
}
- (void)initData{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_MedicalVC] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [_webView loadRequest:request];
}
@end
