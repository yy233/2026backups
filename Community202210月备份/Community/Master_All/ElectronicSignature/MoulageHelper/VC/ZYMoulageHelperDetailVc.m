//
//  ZYMoulageHelperDetailVc.m
//  Community
//
//  Created by ZY on 2021/4/14.
//

#import "ZYMoulageHelperDetailVc.h"
#import "ZYMoulageHelperDetailEditVc.h"
#import <WebKit/WebKit.h>
#import "ZYMoulageHelperDetailModel.h"

@interface ZYMoulageHelperDetailVc () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

@property (nonatomic, strong) NSMutableArray *contractArray;

@property (nonatomic, strong) NSMutableArray *noHandleContractArray;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) NSString *htmlStr;

@end

@implementation ZYMoulageHelperDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"模板详情";
    self.bottomView.hidden = YES;
    [self setUI];
    [self requestContractTemplateDetailData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(49 + button_bottom_height);
    }];
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_webView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
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

- (NSMutableArray *)contractArray {
    if (!_contractArray) {
        _contractArray = [NSMutableArray array];
    }
    
    return _contractArray;
}

- (NSMutableArray *)noHandleContractArray {
    if (!_noHandleContractArray) {
        _noHandleContractArray = [NSMutableArray array];
    }
    
    return _noHandleContractArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = Y_RGBA(38, 114, 249, 1);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, kScreenW, 49);
        [button setTitle:@"编辑合同" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button addTarget:self action:@selector(buttomBottonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }
    
    return _bottomView;
}

#pragma mark - 获取合同模板详情数据
- (void)requestContractTemplateDetailData {
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    NSDictionary *parms = @{@"tempId" : self.uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractTemplateDetailUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.contractArray.count > 0) {
                    [self.contractArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYMoulageHelperDetailModel *model = [ZYMoulageHelperDetailModel yy_modelWithJSON:jsonStr];
                [self webViewloadHTMLStr:model.content];
                NSArray *array = model.tParams;
                for (ZYMoulageHelperDetailtParamsModel *tempModel in array) {
                    if ([tempModel.tKey isEqualToString:@"signA"] || [tempModel.tKey isEqualToString:@"signB"] || [tempModel.tKey isEqualToString:@"signingDateA"] || [tempModel.tKey isEqualToString:@"signingDateB"] || [tempModel.tKey isEqualToString:@"contractNo"]) {
                        [self.noHandleContractArray addObject:tempModel];
                        continue;
                    }
                    [self.contractArray addObject:tempModel];
                }
            }else {
              
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
           
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 加载webView
- (void)webViewloadHTMLStr:(NSString *)htmlStr {
    
//    NSString *handleHTMLStr = [self handleHTML:htmlStr];
//    self.htmlStr = handleHTMLStr;
//    [self.webView loadHTMLString:handleHTMLStr baseURL:nil];
    
    self.htmlStr = htmlStr;
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - 处理html数据
- (NSString *)handleHTML:(NSString *)htmlStr {
    
    if (isNil(htmlStr)) {
        return @"";
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[self filterHTML:htmlStr]];
    NSMutableArray *mArray = [NSMutableArray array];
    while (1) {
        NSRange startRange = [mStr rangeOfString:@"$"];
        NSRange endRange = [mStr rangeOfString:@"}"];
        if (startRange.location == NSNotFound) {
            break;
        }
        NSRange subRange = NSMakeRange(startRange.location, endRange.location - startRange.location + 1);
        NSString *subStr = [mStr substringWithRange:subRange];
        [mStr deleteCharactersInRange:subRange];
        [mArray addObject:subStr];
    }
    NSMutableString *htmlmStr = [NSMutableString stringWithString:htmlStr];
    for (int i = 0; i < mArray.count; i++) {
        NSRange range = [htmlmStr rangeOfString:mArray[i]];
        [htmlmStr deleteCharactersInRange:range];
    }
    
    return [htmlmStr copy];
}

// 获取HTML标签中的信息
- (NSString *)filterHTML:(NSString *)htmlStr {
    
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    
    return str;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[self.webView.scrollView class]]) {
        //防止左右滚动
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, point.y);
    }
}

#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [SVProgressHUD dismiss];
    self.bottomView.hidden = NO;
    
    NSLog(@"页面加载完成");
    // 通过js注入关闭webView缩放
    NSString *injectionJSString=@"var script = document.createElement('meta');"
                                                "script.name = 'viewport';"
                                                "script.content=\"width=device-width, user-scalable=no\";"
                                                "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    for (ZYMoulageHelperDetailtParamsModel *model in self.contractArray) {
        NSString *docStr = [NSString stringWithFormat:@"document.getElementById('%@').innerText='%@'", model.tKey, model.tValue];
        [self.webView evaluateJavaScript:docStr completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            
            NSLog(@"htmlStr:%@", htmlStr);
        }];
    }
}

#pragma mark - 处理点击事件
// 编辑合同
- (void)buttomBottonClicked {
    
    NSLog(@"编辑合同");
    if (self.htmlStr.length > 0) {
        ZYMoulageHelperDetailEditVc *vc = [[ZYMoulageHelperDetailEditVc alloc] init];
        vc.htmlStr = self.htmlStr;
        vc.contractArray = [self.contractArray copy];
        vc.noHandleContractArray = [self.noHandleContractArray copy];
        vc.isSystemTemplate = self.isSystemTemplate;
        vc.contractTemplatesDataListModel = self.contractTemplatesDataListModel;
        [self pushVc:vc];
    }
}

@end
