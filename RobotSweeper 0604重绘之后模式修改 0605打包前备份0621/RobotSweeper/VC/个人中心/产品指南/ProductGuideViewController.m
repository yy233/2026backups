//
//  ProductGuideViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/5.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ProductGuideViewController.h"

@interface ProductGuideViewController ()
@property (nonatomic,strong)UITextView *textViewOfProductGuide;
@property (nonatomic,strong)NSString *strOfdataS;
@end

@implementation ProductGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"产品指南",nil);
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
    [self initData];
    [self initView];
    
}
- (void)initData{
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:NSLocalizedString(@"产品指南1.0", nil)  ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"====%@",error.localizedDescription);
        _strOfdataS = error.localizedDescription;
    } else {
        
    }
    _strOfdataS = content;
    
//    product instruction1.0
   
}
- (void)initView{
    [self.view addSubview:self.textViewOfProductGuide];
    _textViewOfProductGuide.text = _strOfdataS;
    _textViewOfProductGuide.contentOffset = CGPointMake(0, 0);//偏移量
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITextView *)textViewOfProductGuide{
    if (!_textViewOfProductGuide) {
        _textViewOfProductGuide = [[UITextView alloc]init];
        _textViewOfProductGuide.frame = self.view.frame;
//        _textViewOfProductGuide.frame = CGRectMake(20, 20, Y_mainW-40, Y_mainH-40);
        _textViewOfProductGuide.textContainerInset = UIEdgeInsetsMake(10, 20, 20, 10);
        _textViewOfProductGuide.editable = NO;
        _textViewOfProductGuide.font = [UIFont systemFontOfSize:14];
        _textViewOfProductGuide.backgroundColor = [UIColor clearColor];
    }
    return _textViewOfProductGuide;
}
@end
