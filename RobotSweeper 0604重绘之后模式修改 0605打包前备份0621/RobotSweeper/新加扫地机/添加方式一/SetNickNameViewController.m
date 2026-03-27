//
//  SetNickNameViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/24.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetNickNameViewController.h"

@interface SetNickNameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveNameBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@end

@implementation SetNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设置昵称", nil);
    _imgV.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];//扫地机图标更具app不同而定
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    _saveNameBtn.layer.cornerRadius = 5;
    _saveNameBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _nameTextF.tintColor = [DataManager shareDataManager].colorOfMainType;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- _____替换返回按钮
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeReturnBarItem];
}

- (void)changeReturnBarItem{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackRootVcAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;//原back--左边的项目是后退按钮。
}

- (void)goBackRootVcAction:(UIBarButtonItem *)sender{
   
    Y_WEAKSELF
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"您将离开添加界面", nil)   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf popVc];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
    
#pragma mark -- pop
- (void)popVc{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- saveBtnAction
- (IBAction)saveBtnAction:(UIButton *)sender {
    
    NSString* nickStr =  [_nameTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //20190424 处理换行符
    NSString* nickStrOk = [nickStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//替换
    
    if (nickStrOk.length<=0) {
        [self.view makeToast:NSLocalizedString(@"请输入机器人昵称", nil)  duration:2 position:@"center"];
        return;
    }
    
    //昵称大于20 切
    NSString *robotnickName = nickStrOk;
    NSString *nickN = [NSString stringWithFormat:@"%@",robotnickName];
//    if (robotnickName.length>=20) {//不限制昵称
//        nickN = [robotnickName substringToIndex:robotnickName.length-6];
//    }
    //xmpp好友
    [[XmppManager shareXmppManager]addFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid  nickName:nickN];
//    //test
//    [[XmppManager shareXmppManager]addFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid  nickName:@"test"];
    
    //服务器
    NSString *eqh = [DataManager shareDataManager].sweeperIMEI;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].userMode.userNameNoSuffix],@"userPhone",eqh,@"eqHardwareSerial",nickN,@"nickName",nil];
    [[ToolOfNetWork sharedTools]endXml];
//    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentAddEqu withParams:parm finished:^(id responsObject, NSError *error) {
    //20190409解绑所有手机只绑定当前手机
    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentDeletAllAndAddEqu withParams:parm finished:^(id responsObject, NSError *error) {

        [MBProgressHUD hideHUD];
        NSLog(@"------%@",responsObject);
        NSLog(@"----error--%@",error.description);
        
        
        if (_Success) {
            NSString *msg = NSLocalizedString(@"添加成功", nil);
            [self.view makeToast:msg duration:3 position:@"center"];
          [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            //403扫地机已存在
            //402扫地机不存在
            //401用户不存在

            NSString *msg = NSLocalizedString(@"添加失败", nil);
            
            if (_SuccessOrErrCode==201) {//修改密码
                msg = NSLocalizedString(@"修改昵称成功", nil);
            }else if(_SuccessOrErrCode==401){//400昵称空去掉了该情况
                msg = NSLocalizedString(@"扫地机编号不能为空", nil);
            }else if(_SuccessOrErrCode==402){
                msg = NSLocalizedString(@"用户不存在", nil);
            }else if(_SuccessOrErrCode==403){
                msg = NSLocalizedString(@"该扫地机不存在", nil);
            }else if(_SuccessOrErrCode==404){
                //                msg = NSLocalizedString(@"添加失败", nil);
                msg = NSLocalizedString(@"添加失败，请稍后重试", nil);
            }
          UIAlertController*  alertOfF = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self performSelector:@selector(popRootvc) withObject:@"stopRecord" afterDelay:0.7];
                
            }];
            [alertOfF addAction:al];
            [self presentViewController:alertOfF animated:YES completion:nil];
        }
        
    }];
 
}

- (void)popRootvc{
     [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark --

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
@end
