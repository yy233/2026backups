//
//  InfoDetailView.m
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import "InfoDetailView.h"
@interface InfoDetailView ()
@property (nonatomic,strong) UILabel *titiLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *redCountLabel;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) WKWebView *webV;

@end
@implementation InfoDetailView

- (instancetype)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titiLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.redCountLabel];
        [self addSubview:self.contentTextView];
        [self addSubview:self.webV];
        [self setUI];
    }
    return self;
}
// 获取HTML标签中的信息
- (NSString *)filterHTML:(NSString *)htmlStr {
    
    NSDictionary *dic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data = [htmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithData:data options:dic documentAttributes:nil error:nil];
    NSString *str = attriStr.string;
    
    return str;
}
// filterHTML 不好用 换成图文的 webViewDataWithStr
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
        [self.webV loadHTMLString:htmls baseURL:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//暗模式情景时防止颜色闪白色
            self.webV.hidden = NO;
        });

    }
}

- (void)setModel:(TopOrUregentInfoDetailModel *)model{
    _model = model;
//    _contentTextView.text =  [self filterHTML: [TextShowWithModelStr textShowWithNotNullStr:_model.pushMsg]];//2022换成webv
    [self webViewDataWithStr:[TextShowWithModelStr textShowWithNotNullStr:_model.pushMsg]];
    [self titleTextShow];
    [self timeTextShow];
    [self redCountShow];
}

- (void)titleTextShow{
    _titiLabel.text = _model.pushTitle;
    NSInteger titleHeight = [_model gettitleLabelShowHeight];
    if (titleHeight>Screen_H*0.3) {//限制高度
        titleHeight=Screen_H*0.3;
    }
    [_titiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.superview.mas_top).offset(15);
        make.width.equalTo(_titiLabel.superview.mas_width).offset(-32);
        make.centerX.equalTo(_titiLabel.superview.mas_centerX);
        make.height.offset(titleHeight);
    }];
}
- (void)timeTextShow{
    NSString *timeStr = [ToolOfTimeChangeFormat urgentListTimeFormatWithStr:_model.createTime];
    _timeLabel.text = timeStr;
}
- (void)redCountShow{
    NSString *redCountStr = [NSString stringWithFormat:@"浏览次数：%ld",(long)_model.browseCount];
    _redCountLabel.text = redCountStr;
}
#pragma mark ==
- (void)setUI{
    [_titiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.superview.mas_top).offset(15);
        make.width.equalTo(_titiLabel.superview.mas_width).offset(-32);
        make.centerX.equalTo(_titiLabel.superview.mas_centerX);
        make.height.offset(20);
    }];
    [_redCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.mas_bottom).offset(5);
        make.right.equalTo(_redCountLabel.superview.mas_right).offset(-16);
        make.height.offset(20);
//        make.width.offset(100);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_redCountLabel.mas_centerY);
        make.right.equalTo(_redCountLabel.mas_left).offset(-10);
        make.height.equalTo(_redCountLabel.mas_height);
        make.width.offset(70);
    }];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redCountLabel.mas_bottom).offset(5);
        make.width.equalTo(_contentTextView.superview.mas_width).offset(-32);
        make.centerX.equalTo(_contentTextView.superview.mas_centerX);
        make.bottom.equalTo(_contentTextView.superview.mas_bottom).offset(-20);
    }];
    [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentTextView);
    }];
}
#pragma mark ==
- (UILabel *)titiLabel{
    if (!_titiLabel) {
        _titiLabel = [[UILabel alloc]init];
        _titiLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titiLabel.font = [UIFont boldSystemFontOfSize:18];
        _titiLabel.textAlignment = NSTextAlignmentLeft;
        _titiLabel.numberOfLines = 0;
    }
    return _titiLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (UILabel *)redCountLabel{
    if (!_redCountLabel) {
        _redCountLabel = [[UILabel alloc]init];
        _redCountLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _redCountLabel.font = [UIFont systemFontOfSize:12];
        _redCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _redCountLabel;
}
- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView  = [[UITextView alloc]init];
        _contentTextView.editable = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [ThemeManager shareManager].mainTextColor;
        _contentTextView.font = [UIFont systemFontOfSize:14];
        
    }
    return _contentTextView;
}
- (WKWebView *)webV{
    if (!_webV) {
        _webV = [[WKWebView alloc]init];
        _webV.hidden = YES;
    }
    return _webV;
}
@end
