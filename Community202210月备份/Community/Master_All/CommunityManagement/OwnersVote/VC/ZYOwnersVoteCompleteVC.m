//
//  ZYOwnersVoteCompleteVC.m
//  Community
//
//  Created by ZY on 2021/8/4.
//

#import "ZYOwnersVoteCompleteVC.h"
#import "ZYOwnersVoteVC.h"
#import "ZYOwnersVoteCompleteView.h"

@interface ZYOwnersVoteCompleteVC ()

@property (nonatomic, strong) ZYOwnersVoteCompleteView *ownersVoteCompleteView;

@end

@implementation ZYOwnersVoteCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票成功";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.ownersVoteCompleteView];
    [_ownersVoteCompleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_ownersVoteCompleteView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYOwnersVoteCompleteView *)ownersVoteCompleteView {
    if (!_ownersVoteCompleteView) {
        _ownersVoteCompleteView = [[NSBundle mainBundle] loadNibNamed:@"ZYOwnersVoteCompleteView" owner:nil options:nil].lastObject;
        [_ownersVoteCompleteView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ownersVoteCompleteView;
}

#pragma mark - 点击事件
// 确认
- (void)okButtonClicked {
    
    NSLog(@"确认");
    [self popVC];
}

@end
