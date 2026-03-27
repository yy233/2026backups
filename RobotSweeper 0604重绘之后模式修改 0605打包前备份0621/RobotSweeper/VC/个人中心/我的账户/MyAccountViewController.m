//
//  MyAccountViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/19.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "MyAccountViewController.h"

#import "PassWordChangeViewController.h"

@interface MyAccountViewController ()
@property (nonatomic,strong)UIView *backVone;
@property (nonatomic,strong)UIView *backVtwo;
@property (nonatomic,strong)UILabel *phoneL;
@property (nonatomic,strong)UILabel *conternL;
@property (nonatomic,strong)UIButton *phoneB;
@property (nonatomic,strong)UIButton *passwordB;
@property (nonatomic,strong)UIImageView *passwordPushImgV;//跳转img

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
}

- (void)initView{
    [self.view addSubview:self.phoneL];
    [self.view addSubview:self.conternL];
    [self.view addSubview:self.backVone];
    [self.view addSubview:self.backVtwo];
    [self.view addSubview:self.phoneB];
    [self.view addSubview:self.passwordB];
    [self.view addSubview:self.passwordPushImgV];
    [self getYS];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- getYS
- (void)getYS{
    [_phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.offset(30);
    }];
    [_conternL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.phoneL.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    [_backVone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.conternL.mas_bottom).offset(10);
        make.height.offset(80);
    }];
    [_backVtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.backVone.mas_bottom).offset(10);
        make.height.offset(80);
    }];
    [_phoneB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backVone.mas_left).offset(20);
        make.right.equalTo(self.backVone.mas_right).offset(-20);
        make.centerY.equalTo(self.backVone);
        make.height.offset(40);
    }];
    [_passwordPushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backVtwo.mas_right).offset(-40);
        make.centerY.equalTo(self.backVtwo);
        make.height.offset(20);
        make.width.offset(20);
    }];
    [_passwordB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backVtwo.mas_left).offset(20);
        make.right.equalTo(self.backVtwo.mas_right).offset(-20);
        make.centerY.equalTo(self.backVtwo);
        make.height.offset(40);
    }];
    
    
    
}



#pragma mark -- passwordBAction
- (void)passwordBAction:(UIButton *)sender{
    
    PassWordChangeViewController *passWordChangeVC = [[PassWordChangeViewController alloc]init];
//    self.title = @"";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:passWordChangeVC animated:YES];
}
#pragma mark -- getter
- (UILabel *)phoneL{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc]init];
        _phoneL.text = [NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].accountNum];
    }
    return _phoneL;
}

- (UILabel *)conternL{
    if (!_conternL) {
        _conternL = [[UILabel alloc]init];
        NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
        int i = 0;
        if (arrOflist.count>0) {
            i = arrOflist.count;
        }
        _conternL.text = [NSString stringWithFormat:@"已经绑定了%d台设备",i];
         
    }
    return _conternL;
}

- (UIView *)backVone{
    if (!_backVone) {
        _backVone = [[UIView alloc]init];
        _backVone.backgroundColor = Y_RGB(240, 240, 240);
    }
    return _backVone;
}

- (UIView *)backVtwo{
    if (!_backVtwo) {
        _backVtwo = [[UIView alloc]init];
        _backVtwo.backgroundColor =  Y_RGB(240, 240, 240);
        
    }
    return _backVtwo;
}

- (UIButton *)phoneB{
    if (!_phoneB) {
        _phoneB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneB setTitle:[NSString stringWithFormat:@"手机号：%@",[ShareUser sharedUserInfo].accountNum] forState:UIControlStateNormal];
         _phoneB.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;//
        [_phoneB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _phoneB;
}

- (UIButton *)passwordB{
    if (!_passwordB) {

        _passwordB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordB setTitle:[NSString stringWithFormat:@"账号密码"] forState:UIControlStateNormal];
        _passwordB.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;//
      
        [_passwordB addTarget:self action:@selector(passwordBAction:) forControlEvents:UIControlEventTouchUpInside];
        [_passwordB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _passwordB;
}
- (UIImageView *)passwordPushImgV{
    if (!_passwordPushImgV) {
        _passwordPushImgV = [[UIImageView alloc]initWithImage:Y_IMAGE(@"跳转")];
        _passwordPushImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _passwordPushImgV;
}

@end
