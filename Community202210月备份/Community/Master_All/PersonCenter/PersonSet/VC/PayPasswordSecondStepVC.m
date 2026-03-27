//
//  PayPasswordSecondStepVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PayPasswordSecondStepVC.h"
#import "LJPayPasswordView.h"

#import "PayPasswordThirdStepVC.h"

@interface PayPasswordSecondStepVC ()<LJPayPasswordViewDelegate>

@property(nonatomic, strong) UILabel *remarkL;

@property (nonatomic, strong) LJPayPasswordView *passwordV;

@end

@implementation PayPasswordSecondStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
        self.title = @"修改支付密码";
    }else {
        self.title = @"设置支付密码";
    }
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
    }];
    
    [self.passwordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkL.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.view);
        make.width.offset(300);
        make.height.offset(50);
    }];
    
}

#pragma mark - 懒加载

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        _remarkL.text = @"请设置数字密码";
        _remarkL.font = FontSize_Vip_Nomail(14);
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_remarkL];
    }
    return _remarkL;
}
- (LJPayPasswordView *)passwordV{
    if (!_passwordV) {
        _passwordV = [[LJPayPasswordView alloc] initWithFrame:CGRectMake(0, 50, 300, 50)];
        _passwordV.passwordNumber = 6;
//        _passwordV.passwordNumber = 4;
        _passwordV.squareSize = 50;
        _passwordV.pointRadius = 10;
        _passwordV.pointColor = [UIColor blackColor];
        _passwordV.rectColor = [Tool getColorWithHexString:@"#BBBBBB"];
        _passwordV.delegate = self;
        [self.view addSubview:_passwordV];
        
    }
    return _passwordV;
}

#pragma mark - LJPayPasswordViewDelegate

- (void)passwordCompleteInput:(LJPayPasswordView *)password{
    if (password.saveStore.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入密码!");
        return;
    }
    PayPasswordThirdStepVC *vc = [[PayPasswordThirdStepVC alloc] init];
    vc.payPasswordStr = password.saveStore;
    vc.verifyCode = self.verifyCode;
    [self pushVc:vc];
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
