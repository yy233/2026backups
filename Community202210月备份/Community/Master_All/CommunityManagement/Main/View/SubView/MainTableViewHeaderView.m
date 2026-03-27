//
//  MainHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import "MainTableViewHeaderView.h"
#define H_TextField 50
#define CornerRadius_TextField 20
@interface MainTableViewHeaderView ()
@property (nonatomic,strong) UISearchBar *searchBar;
@end
@implementation MainTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.searchBar];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_searchBar.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self setSearchFieldColorAndCornerRadius];
}

- (void)setSearchFieldColorAndCornerRadius {
        NSString *version = [UIDevice currentDevice].systemVersion;
        UITextField *searchField;
        UIView  *textFieldBackView;
        UIImageView *searchBarBackgroundImg;
        
//        if (version.doubleValue >= 13.0) {
        if (@available(iOS 13.0, *)) {
            _searchBar.tintColor = [ThemeManager shareManager].mainSearchBarTextColor;;//光标
            [self setSearchFieldHeight:H_TextField WithTextField:_searchBar.searchTextField];
            _searchBar.searchTextField.backgroundColor =  [ThemeManager shareManager].mainSearchBarTextFieldBackGroundColor;
            _searchBar.searchTextField.textColor = [ThemeManager shareManager].mainSearchBarTextColor;
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
                searchField.backgroundColor = [ThemeManager shareManager].mainSearchBarTextFieldBackGroundColor;//框内色
                [searchField setTextColor:[ThemeManager shareManager].mainSearchBarTextColor];
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
    UIColor *strokeColor = [ThemeManager shareManager].mainSearchBarTextFieldBackGroundColor;
    [strokeColor set];
    [bez fill];
    [bez stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark --
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W-30, H_TextField)];
        _searchBar.layer.cornerRadius = CornerRadius_TextField;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
//        [self.searchBar setImage:[UIImage imageNamed:@"mainBackImg_0"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//        [self.searchBar setImage:[UIImage imageWithColor:[UIColor redColor]] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];;
    }
    return _searchBar;
}
@end
