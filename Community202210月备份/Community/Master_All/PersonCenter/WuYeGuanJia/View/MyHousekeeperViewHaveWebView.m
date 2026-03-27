//
//  MyHousekeeperViewHaveWebView.m
//  Community
//
//  Created by 余莹 on 2022/4/9.
//

#import "MyHousekeeperViewHaveWebView.h"

static CGFloat kThisCycleScrollView_Height = 200;

@interface MyHousekeeperViewHaveWebView () <SDCycleScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *showBackView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) WKWebView *webview;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;


@end


@implementation MyHousekeeperViewHaveWebView
#pragma mark === data

- (void)fillBannerData:(NSMutableArray *)bannerArr{
     self.cycleScrollView.imageURLStringsGroup = bannerArr;
}

- (void)fillOnlyPhoneStr:(NSString *)onlyPhoneStr{
    if (onlyPhoneStr.length <= 0) {
        return;
    }
    self.footerView.hidden = NO;
    [self.footerView.footerBtn newAnBtnWithTextStr:onlyPhoneStr];
    [self.footerView.footerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
}

- (void)fillShowWebViewStr:(NSString *)showtext{
    [self webViewDataWithStr:[TextShowWithModelStr textShowWithNotNullStr:showtext]];

}

#pragma mark ===
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addviews];
        [self setUI];
        
    }
    return self;
}
- (void)addviews{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.showBackView];
    [self.showBackView addSubview:self.cycleScrollView];
    [self.showBackView addSubview:self.webview];
    [self addSubview:self.footerView];
}
- (void)setUI{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_scrollView.superview);
        make.bottom.equalTo(_scrollView.superview).offset(-20);//底部空余
    }];
    [_showBackView mas_makeConstraints:^(MASConstraintMaker *make) {//过渡视图contentSize，并设置其约束初始状态
        make.top.left.bottom.and.right.equalTo(_scrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(_scrollView);
    }];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_cycleScrollView.superview);
        make.height.offset(kThisCycleScrollView_Height);
    }];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_webview.superview).offset(-16);
        make.centerX.equalTo(_webview.superview);
        make.top.equalTo(_cycleScrollView.mas_bottom);
        make.height.equalTo(_scrollView.superview);//父级的父级可显示的总高-bottom20为初值 ｜   【  后有数据 变总数据高度---（只留外部SV可用滚动）】
    }];
    [_showBackView mas_makeConstraints:^(MASConstraintMaker *make) {//过渡视图 定下纵向限制 扩大其高度
        make.bottom.equalTo(_webview.mas_bottom).offset(+20*2);
    }];
    
    //
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerView.superview);
        make.width.equalTo(_footerView.superview);
        make.height.offset(90);
        make.bottom.equalTo(_footerView.superview.mas_bottom).offset(-100-KIndicatorHeight);//自身高度+间隔bottom
    }];
    _footerView.hidden = YES;//有电话数据再显示

}
 
- (void)webViewDataWithStr:(NSString *)str{
    NSString *content = [str stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSString *textColor16Str = @"";
    NSString *bgColor16Str = @"";
    
    if ([ThemeManager shareManager].type == ThemeType_White) {
        textColor16Str =  @"#6E727D";//灰色
        bgColor16Str = @"rgba(255, 255, 255, 1)"; //
    }else{
        textColor16Str =  @"#F5F5F5";//白色
        bgColor16Str = @"rgba(0, 21, 52, 1)";//重蓝色
    }
    
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
        [self.webview loadHTMLString:htmls baseURL:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//暗模式情景时防止颜色闪白色
            [self getHtWithChangeHeight];//已经有数据后 再拿高度 防止h=0
            self.webview.hidden = NO;
        });

    }
}
//有数据后 留总SV可滑动 webSV 不可滑动
- (void)getHtWithChangeHeight{
    _webview.scrollView.scrollEnabled = NO;
    
    
   CGFloat getH = self.webview.scrollView.contentSize.height;
    NSLog(@"getH= %lf",getH);
    if (getH < self.frame.size.height - kThisCycleScrollView_Height) {//高度较小不做高度更新
        return;
    }
    [_webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_webview.superview).offset(-16);
        make.centerX.equalTo(_webview.superview);
        make.top.equalTo(_cycleScrollView.mas_bottom);
        make.height.offset(getH);  // 【  后有数据 变总数据高度---（只留外部SV可用滚动）】
    }];

}


#pragma mark === views

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}
- (UIView *)showBackView{
    if (!_showBackView) {
        _showBackView = [[UIView alloc]init];
    }
    return _showBackView;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView  = [[SDCycleScrollView alloc]init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = Color_Blue;
        _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"cc_placeholder_big_banner"];//不需要本Community_Homepage_bannerone占位
    }
    return _cycleScrollView;
}
- (WKWebView *)webview{
    if (!_webview) {
        _webview = [[WKWebView alloc]init];
        _webview.hidden = YES;//暗模式情景时防止颜色闪白色
    }
    return _webview;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]init];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithImg: [UIImage imageNamed:@"theiPhone_icon"]];
        [_footerView setBtnFram:CGRectMake(0, 0, 200, 40)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark === footerView call phone
- (void)footerBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchFooterBtnActionWithCallPhone)]) {
        [_delegate touchFooterBtnActionWithCallPhone];
    }
}

#pragma mark === SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"didSelectItemAt top img Item");
    if (_delegate && [_delegate respondsToSelector:@selector(myHousekeeperViewTouchTopSdcyclviewWithIndex:)]) {
        [_delegate myHousekeeperViewTouchTopSdcyclviewWithIndex:index];
    }
}
@end
