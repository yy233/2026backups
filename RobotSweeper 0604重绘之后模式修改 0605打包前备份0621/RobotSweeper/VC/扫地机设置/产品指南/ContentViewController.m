//
//  ContentViewController.m
//  UIPageViewControllerDemo
//
//  Created by Herb on 16/4/12.
//  Copyright © 2016年 Herb. All rights reserved.
//

#import "ContentViewController.h"

#import "ContentV.h"
#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface ContentViewController ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic,strong) ContentV *contV;
@end

@implementation ContentViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = kRandomColor;
//    _contentLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentLabel];
}

- (void) viewWillAppear:(BOOL)paramAnimated{
    [super viewWillAppear:paramAnimated];
    _contentLabel.text = _content;
    _i = [_content intValue];
    CGRect rect = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50);
    UIView *cv = [[ContentV alloc]initWithFrame:rect atPage:_i];
 
    cv.tag = _i+200;
    [self.view addSubview: cv];
    
}

@end
