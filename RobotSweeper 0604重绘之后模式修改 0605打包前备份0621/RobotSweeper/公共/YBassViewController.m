//
//  YBassViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/30.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "YBassViewController.h"

@interface YBassViewController ()

@end

@implementation YBassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark --
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyBoardNoticf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



+ (UIView *)failOfMessage:(NSString *)str{
    
    CGFloat w = 160;
    
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor grayColor];
    v.alpha = 0.3;
    v.frame = CGRectMake(0, 0, w,130);
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.image = Y_IMAGE(@"叉号图标");
    imgv.frame = CGRectMake(0, 0, 60,60);
    imgv.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds)-0.5*(130-10-60)+10);
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    [v addSubview:imgv];
    UILabel *la = [[UILabel alloc]init];
    la.frame = CGRectMake(0, 0, w ,60);
    la.center = CGPointMake(CGRectGetMidX(v.bounds), 60+CGRectGetMidY(la.bounds)+10);
    la.textAlignment = NSTextAlignmentCenter;
    la.textColor = [UIColor whiteColor];
    la.numberOfLines = 0;
    la.text = str;
    [v addSubview:la];
    return v;
}


#pragma mark -- NotificationKeyBoard

- (void)addKeyBoardNoticf{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowAction:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAction:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现
- (void)keyboardWillShowAction:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    self.view.center = CGPointMake(Y_mainW*0.5,Y_mainH*0.5-height*0.5);
}

//当键退出
- (void)keyboardWillHideAction:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
//    int height = keyboardRect.size.height;
    self.view.center = CGPointMake(Y_mainW*0.5,Y_mainH*0.5);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
