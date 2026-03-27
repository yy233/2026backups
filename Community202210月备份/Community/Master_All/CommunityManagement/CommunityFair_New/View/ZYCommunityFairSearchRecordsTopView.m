//
//  ZYCommunityFairSearchRecordsTopView.m
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import "ZYCommunityFairSearchRecordsTopView.h"

@interface ZYCommunityFairSearchRecordsTopView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation ZYCommunityFairSearchRecordsTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton *clearButton = [self.searchTF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    self.searchTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.searchView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.backButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"sj_back_icon"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)searchButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonEvent)]) {
        [self.delegate searchButtonEvent];
    }
}

@end
