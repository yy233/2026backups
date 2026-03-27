//
//  HouseRentNavSearchView.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "HouseRentNavSearchView.h"
#define H_TextField 44
#define CornerRadius_TextField 16.5
@interface HouseRentNavSearchView ()
@property (nonatomic,strong) UIColor *searchTextFieldBackColor;
@property (nonatomic,strong) UIColor *searchBarTextColor;
@end
@implementation HouseRentNavSearchView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchBar];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self setSearchFieldColorAndCornerRadius];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchBar.superview.mas_left);
        make.width.equalTo(_searchBar.superview.mas_width).offset(-5);//间距
        make.top.equalTo(_searchBar.superview.mas_top);
        make.height.offset(H_TextField);
    }];
}
- (void)setSearchFieldColorAndCornerRadius {
        NSString *version = [UIDevice currentDevice].systemVersion;
        UITextField *searchField;
        UIView  *textFieldBackView;
        UIImageView *searchBarBackgroundImg;

//        if (version.doubleValue >= 13.0) {
        if (@available(iOS 13.0, *)) {
            _searchBar.tintColor = self.searchBarTextColor;;//光标
            [self setSearchFieldHeight:H_TextField WithTextField:_searchBar.searchTextField];
            _searchBar.searchTextField.backgroundColor =  self.searchTextFieldBackColor;
            _searchBar.searchTextField.textColor = self.searchBarTextColor;
            _searchBar.searchTextField.font = [UIFont systemFontOfSize:12];
            _searchBar.searchTextField.layer.cornerRadius = CornerRadius_TextField;//有效
            _searchBar.searchTextField.layer.masksToBounds = YES;
            _searchBar.searchTextField.clipsToBounds = YES;
            _searchBar.backgroundImage = [UIImage new];

        } else {
            _searchBar.tintColor = [ThemeManager shareManager].mainSearchBarTextColor;;//光标
            searchField = [_searchBar valueForKey:@"searchField"];
            textFieldBackView = [_searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
            searchBarBackgroundImg = (UIImageView *)[_searchBar.subviews.firstObject subViewOfClassName:@"UISearchBarBackground"];
            if (searchField) {
                searchField.backgroundColor = self.searchTextFieldBackColor;//框内色
                [searchField setTextColor:self.searchBarTextColor];
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
    UIColor *strokeColor = self.searchTextFieldBackColor;
    [strokeColor set];
    [bez fill];
    [bez stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark --
 
- (UISearchBar *)searchBar{//搜索
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, H_TextField)];
        _searchBar.placeholder = @"搜索";
        _searchBar.layer.cornerRadius = CornerRadius_TextField;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}
- (UIColor *)searchTextFieldBackColor{
    if (!_searchTextFieldBackColor) {
        _searchTextFieldBackColor = Y_RGBA(240, 241, 246, 1);
    }
    if ([ThemeManager shareManager].type == ThemeType_White) {
        _searchTextFieldBackColor = Y_RGBA(240, 241, 246, 1);
    }else{
        _searchTextFieldBackColor = Y_RGBA(240, 241, 246, 1);
    }
    return _searchTextFieldBackColor;
}
 
- (UIColor *)searchBarTextColor{
    if (!_searchBarTextColor) {
        _searchBarTextColor = [UIColor blackColor];
    }
    if ([ThemeManager shareManager].type == ThemeType_White) {
        _searchBarTextColor = [UIColor blackColor];
    }else{
        _searchBarTextColor = [UIColor blackColor];
    }
    return _searchBarTextColor;
}
 
@end
