//
//  MySubsWebVc.m
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//
/**
 调用网页方法 window.methodRouter({event, data}),  网页数据上报数据格式 {id, status, message?, data?}
 
 页面加载成功 CallBackType 200， 错误 500

 */

#import "MySubsWebVc.h"
#import "DappUseBaseVc.h"

@interface MySubsWebVc ()

@end

@implementation MySubsWebVc
//打开dapp后 拿到 1005 Dapp深度位置 看看是否可以处理tabbar
- (void)get1005OfDappTabBarNeedShowOrHidenWithDic:(NSDictionary *)bodyDic{
    //重写 防止变更tabbbar显示隐藏
}
#define  kTheme_Type_Key   @"Theme_Type"
- (void)viewDidLoad {
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
        
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#000000"];

    }
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
    }

    
    if(!self.subTypeUrlSuix){
        return;
    }
    
    
//    NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位 subTypeUrlSuix存在，自带/。 和LocaleStr 不是挨着的 可不做处理
    
    NSString *this_WebVcBaseUrl = WebVc_Base_URL;
    NSString *WebVc_Base_URL_Str = [this_WebVcBaseUrl substringFromIndex: this_WebVcBaseUrl.length - 1];//最末位
    //NSString *WebVc_Base_URL_Str = [WebVc_Base_URL substringFromIndex: WebVc_Base_URL.length - 1];//最末位
    if([WebVc_Base_URL_Str containsString:@"#"]){//带了 不拼WebCenterUrlUseStr 且位置不一样所以无需/
        
        if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyWallet]){//钱包
            self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@?%@",WebVc_Base_walletUse_URL,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];
            
            
        }else if ([self.subTypeUrlSuix isEqualToString: MySubVc_Url_Suix_userPersonal ]){//@"/pages/user/personal"某人的粉友freeperID页
            //去freeperid粉丝友圈,
            self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@?%@%@&%@",WebVc_Base_URL,self.subTypeUrlSuix,@"imId=" ,self.userPersonalImIdStr,[WebVcsTool getWebUrlLocaleStr]];
            
        }else{//非钱包
            
            if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyFriends] || [self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyFans]){//带？的 后续不用？用&
                self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@&%@",WebVc_Base_URL,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];

            }else{
                self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@?%@",WebVc_Base_URL,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];

            }
        }
    }else{
        if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyWallet]){//钱包 
            self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@?%@",WebVc_Base_walletUse_URL,WebCenterUrlUseStr,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];
        }else if ([self.subTypeUrlSuix isEqualToString: MySubVc_Url_Suix_userPersonal ]){//@"/pages/user/personal"
            //去freeperid粉丝友圈,
            self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@?%@%@&%@",WebVc_Base_URL,WebCenterUrlUseStr,self.subTypeUrlSuix,@"imId=" ,self.userPersonalImIdStr,[WebVcsTool getWebUrlLocaleStr]];
        
            //去freeperid粉丝友圈
        }else{//非钱包
            
            if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyFriends] || [self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyFans]){//带？的 后续不用？用&
                self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@&%@",WebVc_Base_URL, WebCenterUrlUseStr,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];

            }else{
                self.thisVcUseUrlStr = [NSString stringWithFormat:@"%@%@%@?%@",WebVc_Base_URL, WebCenterUrlUseStr,self.subTypeUrlSuix,[WebVcsTool getWebUrlLocaleStr]];
            }
             
            
        }
                
        
    }
    
    NSLog(@"");
    
    NSLog(@"MySubsWebVc thisVcUseUrlStr = %@",self.thisVcUseUrlStr);
    
    [super viewDidLoad];
    
//    [self test];
}
 

#pragma mark ==== dapp  新0720 0807

- (void)webGetOpenDappAction:(NSDictionary *)bodyDic{ //发现页和钱包页也用到
    
    if(![self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyWallet]){//钱包
        return;
    }
    WebViewUseDataModel *infoModel = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    
    NSDictionary *valueDic = [NSDictionary dictionaryWithDictionary:infoModel.data.param.value];
    NSString *url = @"";
    BOOL collect = NO;
    if([[valueDic allKeys] containsObject:@"url"]){
        url = [NSString stringWithFormat:@"%@", [valueDic objectForKey:@"url"]];
    }
    if([[valueDic allKeys] containsObject:@"collect"]){
        collect = [[valueDic objectForKey:@"collect"] boolValue];
    }
    
    if(url.length>0){//数据有效
        NSString *willUseUrl = url;
        NSLog(@"1004 willUseUrl == %@",willUseUrl);
        if (willUseUrl.length <= 0) {
            return;
        }
        DappUseBaseVc *vc = [[DappUseBaseVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dappShowUseInfoBodyDic = bodyDic;
        vc.thisDappUseUrlStr = url;
        vc.isShouCangeType = collect;
        self.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        vc.isGoSubVcDontDealTabbarsHidenOrShow = YES;
        [self pushVc:vc];
    }else{
        DLog(@"");
        
    }
}




#pragma mark ===
- (void)getShopWebViewSendInfoWithModel:(WebViewUseDataModel *)infoModel{
    NSLog(@"MyWebVc  \n %@  %@  %@ %@",infoModel.ID,infoModel.data,infoModel.data.error,infoModel.data.event);
    NSLog(@"MyWebVc  \n %@  %@  %@ %@",infoModel.ID,infoModel.data,infoModel.data.error,infoModel.data.event);
}


// 网页数据上报数据格式 {id, status, message?, data?}
- (void)test{
    
    NSDictionary *dict = @{@"event":@"testEvent",@"data":@"test111Datas"};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:nil];
//    NSString *willSendDataJsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *willSendDataJsonStr = [Y_ToolOfOthers jsonStrWithDic:dict];
    
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",kOcSendToJsFunction_methodRouter,willSendDataJsonStr];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
          NSLog(@" kOcSendToJsFunction ==  %@----%@",result, error);
      }];
  });
}


//重写
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断如果是需要隐藏导航控制器的类，则隐藏
    BOOL isHideNav = ([viewController isKindOfClass:[self class]] );// 隐藏了nav用的view
    [self.navigationController setNavigationBarHidden:isHideNav animated:YES];
    
}

//钱包vc专用
- (void)walletWebVcGetHideWallet{
//    if([self.subTypeUrlSuix isEqualToString:MySubVc_Url_Suix_MyWallet]){//钱包页返回按钮
    if([self.webView.URL.absoluteString containsString:MySubVc_Url_Suix_MyWallet]){
        NSLog(@"当前钱包主页 返回 walletWebVcGetHideWallet");
        [self popVC];
    }else{
        NSLog(@"当前非钱包主页 不做返回");
    }
}

@end
