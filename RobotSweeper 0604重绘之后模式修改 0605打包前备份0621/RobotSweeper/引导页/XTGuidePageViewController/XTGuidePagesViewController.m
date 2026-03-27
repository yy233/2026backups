//
//  XTGuidePagesViewController.m
//  XTGuidePagesView
//
//  Created by zjwang on 16/5/30.
//  Copyright © 2016年 夏天. All rights reserved.
//

#import "XTGuidePagesViewController.h"

#define s_w [UIScreen mainScreen].bounds.size.width
#define s_h [UIScreen mainScreen].bounds.size.height
#define VERSION_INFO_CURRENT @"currentversion"
@interface XTGuidePagesViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation XTGuidePagesViewController

- (void)guidePageControllerWithImages:(NSArray *)images
{
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, s_w, s_h)];
    gui.delegate = self;
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < images.count; i ++) {
        [gui addSubview:({
            self.btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnEnter.frame = CGRectMake(s_w * i, 0, s_w, s_h);
            [self.btnEnter setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];;
            self.btnEnter.imageView.contentMode = UIViewContentModeScaleAspectFill;//图片
            self.btnEnter;
        })];
        
        [self.btnEnter addSubview:({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
           
            
            btn.frame = CGRectMake(s_w * i, s_h - 50, s_w*0.5, s_h*0.25);//0.5w的btn距离底部h0.25为按钮区
            btn.center = CGPointMake(s_w / 2, s_h*0.875);//1-0.25/2
            btn.layer.cornerRadius = 4;
            btn.clipsToBounds = YES;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
            if (i == images.count - 1) {
//                [btn setTitle:@"点击进入" forState:UIControlStateNormal];
                btn.hidden = NO;
            }else{
//                [btn setTitle:@"跳过" forState:UIControlStateNormal];
                btn.hidden = YES;
            }
            btn;
            
        })];
    }
    gui.contentSize = CGSizeMake(s_w * images.count, 0);
    [self.view addSubview:gui];
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, s_w / 2, 30)];
    self.pageControl.center = CGPointMake(s_w / 2, s_h *0.75);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = images.count;
}
- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickEnter)]) {
        [self.delegate clickEnter];
    }
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [XTGuidePagesViewController saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}
#pragma mark - ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / s_w;
}

@end


