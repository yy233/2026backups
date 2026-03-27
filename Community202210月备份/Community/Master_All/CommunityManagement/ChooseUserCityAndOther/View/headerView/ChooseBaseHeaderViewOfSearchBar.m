//
//  ChooseBaseHeaderViewOfSearchBar.m
//  Community
//
//  Created by 余莹 on 2020/12/2.
//
#define H_TextField 30
#define CornerRadius_TextField 3
#import "ChooseBaseHeaderViewOfSearchBar.h"
@interface ChooseBaseHeaderViewOfSearchBar ()
@end
@implementation ChooseBaseHeaderViewOfSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 40);
    self = [super initWithFrame:frame];//40固定 30 search_h
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.searchBar];
        [self setUI];
        [self setSearchFieldColorAndCornerRadius];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.superview.mas_top).offset(5);
        make.bottom.equalTo(_searchBar.superview.mas_bottom).offset(-5);
        make.left.equalTo(_searchBar.superview.mas_left).offset(16);
        make.right.equalTo(_searchBar.superview.mas_right).offset(-16);
    }];
}

- (void)setSearchFieldColorAndCornerRadius {
    NSString *version = [UIDevice currentDevice].systemVersion;
    UITextField *searchField;
    UIView  *textFieldBackView;
    UIImageView *searchBarBackgroundImg;
    
    //        if (version.doubleValue >= 13.0) {
    if (@available(iOS 13.0, *)) {
        _searchBar.tintColor = [UIColor blackColor];;//光标
        [self setSearchFieldHeight:H_TextField WithTextField:_searchBar.searchTextField];
        _searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
        _searchBar.searchTextField.textColor = [UIColor blackColor];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
        _searchBar.searchTextField.layer.cornerRadius = CornerRadius_TextField;//有效
        _searchBar.searchTextField.layer.masksToBounds = YES;
        _searchBar.searchTextField.clipsToBounds = YES;
        _searchBar.backgroundImage = [UIImage new];
        
    } else {
        _searchBar.tintColor = [UIColor blackColor];
        searchField = [_searchBar valueForKey:@"searchField"];
        textFieldBackView = [_searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
        searchBarBackgroundImg = (UIImageView *)[_searchBar.subviews.firstObject subViewOfClassName:@"UISearchBarBackground"];
        if (searchField) {
            searchField.backgroundColor = [UIColor whiteColor];//框内色
            [searchField setTextColor:[UIColor blackColor]];
            searchField.font = [UIFont systemFontOfSize:12];
        }
        if (textFieldBackView) {
            textFieldBackView.layer.cornerRadius = CornerRadius_TextField;
            textFieldBackView.layer.masksToBounds = YES;
            textFieldBackView.clipsToBounds = YES;
        }
        if (searchBarBackgroundImg) {
            searchBarBackgroundImg.image = [UIImage new];
        }
    }
    
}
- (void)setSearchFieldHeight:(CGFloat)height WithTextField:(UITextField *)textField{
    [_searchBar setSearchFieldBackgroundImage:[self getFieldBg:height WithTextField:textField] forState:UIControlStateNormal];
    // 有部分时候这一句是需要加上去的,大家根据情况添加
    textField.frame = CGRectMake(0, 0, Screen_W-30, height);
}

// 画一个带圆角的,扩大的背景图
- (UIImage *)getFieldBg:(CGFloat)height WithTextField:(UITextField *)textField{
    CGRect rect = CGRectMake(0, 0, Screen_W-30, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    UIBezierPath *bez = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CornerRadius_TextField];
    bez.lineWidth = 0.5;
    UIColor *strokeColor = [UIColor whiteColor];// 框内除了边框一圈后小范围的色
    [strokeColor set];
    [bez fill];
    [bez stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark -- headview
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
    }
    return _backView;
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W-30, H_TextField)];
        _searchBar.layer.cornerRadius = CornerRadius_TextField;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"输入城市名、拼音或者首字母查询";//@"输入城市名、拼音或者首字母查询"
    }
    return _searchBar;
}

@end
