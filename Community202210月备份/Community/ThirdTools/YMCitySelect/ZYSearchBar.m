//
//  ZYSearchBar.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYSearchBar.h"

@interface ZYSearchBar ()

@property (nonatomic, strong) UIView *contentV;

@property (nonatomic, strong) UIImageView *searchImageView;

@end

@implementation ZYSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentV];
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    [_contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentV.superview).offset(16);
        make.right.equalTo(_contentV.superview).offset(-16);
        make.height.offset(40);
        make.centerY.equalTo(_contentV.superview);
    }];
    [self.contentV addSubview:self.searchImageView];
    [self.contentV addSubview:self.searchTF];
    [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchImageView.superview).offset(15);
        make.width.height.offset(12);
        make.centerY.equalTo(_searchImageView.superview);
    }];
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchImageView.mas_right).offset(6);
        make.right.equalTo(_searchTF.superview).offset(-10);
        make.height.equalTo(_searchTF.superview);
        make.centerY.equalTo(_searchTF.superview);
    }];
}

- (UIView *)contentV {
    if (!_contentV) {
        _contentV = [[UIView alloc] init];
        _contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        _contentV.layer.cornerRadius = 5;
        _contentV.layer.masksToBounds = YES;
    }
    
    return _contentV;
}

- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.image = [UIImage imageNamed:@"ic_shjf_search"];
    }
    
    return _searchImageView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _searchTF.font = [UIFont systemFontOfSize:15];
        _searchTF.placeholder = @"请输入城市名";
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        Ivar ivarS = class_getInstanceVariable([_searchTF class], "_placeholderLabel");
        id placeholderLabelS = object_getIvar(_searchTF, ivarS);
        [placeholderLabelS performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
        UIButton *clearButton = [_searchTF valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    }
    
    return _searchTF;
}

@end
