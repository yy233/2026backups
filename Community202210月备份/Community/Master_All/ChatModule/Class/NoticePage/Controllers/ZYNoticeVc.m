//
//  ZYNoticeVc.m
//  Community
//
//  Created by ZY on 2021/4/19.
//

#import "ZYNoticeVc.h"

@interface ZYNoticeVc ()

@end

@implementation ZYNoticeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"通知";
    [self setUI];
}

- (void)viewDidAppear:(BOOL)animated {

   [super viewDidAppear:animated];
   
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {

   [super viewWillDisappear:animated];

    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

#pragma mark - 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
