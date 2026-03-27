//
//  NftDetailWebVc.m
//  Socialize
//
//  Created by 余莹 on 2023/8/1.
//

#import "NftDetailWebVc.h"

@interface NftDetailWebVc ()

@end

@implementation NftDetailWebVc

- (void)viewDidLoad {
    self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@&%@",self.nftDetailAllUrl , [WebVcsTool getWebUrlLocaleStr]];//前面有？了 后半截用& 连接
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//不需要显示nav8
    
    
}

//- (void)noticeLanguageChange{
//    self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@&%@",self.nftDetailAllUrl , [WebVcsTool getWebUrlLocaleStr]];
//    [self initData];
//    DLog(@"webvc收到语言切换 %s \n %@",__FUNCTION__, self.thisVcUseUrlStr );
//}



- (void)initData{
    if(isNil((self.thisVcUseUrlStr))){
        return;
    }
    NSString *allUrlStr = self.thisVcUseUrlStr;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrlStr] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0];//缓存属性
    [self.webView loadRequest:request];
}


- (void)setUI{
    
    WEAKSELF
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height, 0, 0, 0));
    }];
    [self.popWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.webView.superview).insets(UIEdgeInsetsMake(kStatusBar_Height+100, 0, 0, 0));
    }];
}


- (void)initSetUserInfoWithGetBodyDic:(NSDictionary *)bodyDic{
    DLog(@" nft 详情 无需用户信息")
}
 

@end
