//
//  SetManageDetailViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/15.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetManageDetailViewController.h"
#import "ContentTableViewCell.h"
#import "CreateQrCodeViewController.h"
@interface SetManageDetailViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray *arrOfSource;
@property (nonatomic,strong)NSString *nameStrOfThisRobot;
@property (nonatomic,strong)UIAlertController *nameChangeAlert;

@property (nonatomic,strong)UILabel *nickAndTimeL;
@property (nonatomic,strong)NSString *strOfT;

//0128新增设备型号
@property (nonatomic,strong)NSString *snIdStrOfThisRobot;
@end

@implementation SetManageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    self.title = NSLocalizedString(@"设备详情", nil) ;
    [self initData]; //时间center 昵称bottom显示
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    
}
- (void)initData{
    
    [ShareUser sharedUserInfo].userMode.nowRobotJid = [_dicOfS objectForKey:@"eqOpfJid"];//扫地机jid
    _snIdStrOfThisRobot = @"";
    NSMutableArray *arrOfAllRbotlist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    
    for ( NSDictionary *dicOfOneRobot in arrOfAllRbotlist) {
        if ([[dicOfOneRobot objectForKey:@"eqOpfJid"]  isEqualToString:[ShareUser sharedUserInfo].userMode.nowRobotJid] && [[dicOfOneRobot allKeys]containsObject:@"eqSN"]) {
            _snIdStrOfThisRobot =  [dicOfOneRobot objectForKey:@"eqSN"];
        }
    }
    if (_snIdStrOfThisRobot.length==0) {
          _snIdStrOfThisRobot =  [ShareUser sharedUserInfo].userMode.nowRobotJid;
    }else{
//        NSString *allStr = [NSString stringWithFormat:@"%@\n%@",_snIdStrOfThisRobot,[ShareUser sharedUserInfo].userMode.nowRobotJid];
//        _snIdStrOfThisRobot = allStr;//这里是设备型号和唯一编码
        
    }
    
    
    _nameStrOfThisRobot = [NSString stringWithFormat:@"%@",[_dicOfS objectForKey:@"nickName"]];//扫地机昵称
    _arrOfSource = [NSMutableArray arrayWithObjects:NSLocalizedString(@"设备型号", nil), NSLocalizedString(@"设备二维码分享", nil) ,NSLocalizedString(@"设备名称", nil), nil];
    _strOfT = @"0000/00/00";
    [self getListOfgetTimeStr];
    
    //    NSString *nickname = [NSString stringWithFormat:@"设备名称：%@",_nameStrOfThisRobot];
    //    _arrOfSource = [NSMutableArray arrayWithObjects:@"设备二维码分享",nickname, nil];
    
}


- (void)initView{
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark -- 绑定时间
- (void)getListOfgetTimeStr{
    [MBProgressHUD showMessage:NSLocalizedString(@"正在请求绑定时间", nil)];
    //服务器
    NSString *eqh = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:eqh,@"eqHardwareSerial",nil];
    
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_equipmentselectSweepUser withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
//        NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
        
        if (_Success) {
            
            NSMutableArray *arrOfUserList = [NSMutableArray arrayWithArray: responsObject[@"list"]];
            
            [self.view makeToast: NSLocalizedString(@"获取绑定时间成功", nil)  duration:3 position:@"center"];
            if (arrOfUserList.count>0) {
                [self getTimeStr:arrOfUserList];
            }
        }else{
            //失败
            NSString *msg = @"";
        
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"获取绑定时间失败，请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"获取绑定时间失败", nil)  ;
                }
            if (msg.length == 0) {
                msg = NSLocalizedString(@"获取绑定时间失败", nil) ;
            }
            
            
            [self.view makeToast:msg duration:2 position:@"center"];
            
        }
        
    }];
    
}
- (void)getTimeStr:(NSMutableArray *)arr{
    
    /*{
     createTime = "2018-02-24 15:27:08.0";
     id = 9;
     updateTime = "2018-03-01 17:29:08.0";
     userGuId = 846a48dd46b24b40bcc7879430ffa178;
     userName = 18183132010;
     userPassWord = 7cb49971f4b0c96f0c10bcc40355a167;
     },
     */
    NSString *selfPhone = [ShareUser sharedUserInfo].userMode.userNameNoSuffix;//无后缀的账号
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:arr[i]];
        if ([[dic objectForKey:@"userName"] isEqualToString:selfPhone]) {
            if (![dic objectForKey:@"ueCreateTime"]) {//字段没加就原有的创建时间字段 和create被删
                //createTime
                _strOfT = [[[NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]] substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                NSString *cj = @"创建时间";
                _nickAndTimeL.text = [NSString stringWithFormat:@"%@\n%@：%@",[_dicOfS objectForKey:@"nickName"],cj,_strOfT];
                [self.tableView reloadData];
            }else{//ueCreateTime绑定时间字段
                _strOfT = [[[NSString stringWithFormat:@"%@",[dic objectForKey:@"ueCreateTime"]] substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                NSString *bd = NSLocalizedString(@"绑定时间", nil) ;
                _nickAndTimeL.text = [NSString stringWithFormat:@"%@\n%@：%@",[_dicOfS objectForKey:@"nickName"],bd,_strOfT];
                [self.tableView reloadData];
            }
            /**
             createTime = "2018-09-10 11:11:50.0";第一次绑定时间
             ueCreateTime = "2018-10-12 11:43:09.0"; 绑定时间 解绑后新增时会变
             updateTime = "2019-01-10 14:05:24.0"; 更新昵称后时间不变
             */
            break;
        }
    }
}

#pragma mark --
- (void)deletRobotAction:(UIButton *)sender{
    NSLog(@"解除绑定");
    NSString *messageStr = NSLocalizedString(@"您将与这台设备解除绑定",nil);
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"解绑提示",nil) message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletOneRobot:sender];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)deletOneRobot:(UIButton *)sender{
    
    if (![ToolOfBasic currentNetworkStatus]) {
        [MBProgressHUD showError:NSLocalizedString(@"网络异常,请检查您的网络设置", nil) ];
    }else{
        [MBProgressHUD showMessage:NSLocalizedString(@"正在解除绑定",nil)];
        NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone", nil];
        
        [parms setObject:[ShareUser sharedUserInfo].userMode.nowRobotJid forKey:@"eqHardwareSerial"];
        
            [[ToolOfNetWork sharedTools]YrequestDeleteURL:S_equipmentRemove withParams:parms    finished:^(id responsObject, NSError *error) {
                [MBProgressHUD hideHUD];
                if (_Success) {
                    //删除xmpp好友关系
        //            [[XmppManager shareXmppManager]deletFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid];
                    [MBProgressHUD showSuccess:NSLocalizedString(@"解绑成功",nil)];
                    [self.navigationController popToRootViewControllerAnimated:YES];
        
                }else{
                    //失败
                    
//                    NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
                     NSString *msg = @"";
                    if(msg.length==0){
                        if (error.code == -1009) {
                            msg = NSLocalizedString(@"解绑失败,请查看网络是否可用", nil);
                        }else{
                            msg = NSLocalizedString(@"解绑失败,请稍后再试", nil);
                        }
                        
                    }
                    if (msg.length==0) {
                        msg = NSLocalizedString(@"解绑失败", nil);
                    }
                    if (_SuccessOrErrCode==400) {
                        msg =  NSLocalizedString(@"用户名不能为空", nil);
                    }else if (_SuccessOrErrCode==401){
                        msg =  NSLocalizedString(@"扫地机编号不能为空", nil);
                    }else if (_SuccessOrErrCode==402){
                        msg =  NSLocalizedString(@"该编号扫地机不存在", nil);
                    }else if (_SuccessOrErrCode==403){
                        msg =  NSLocalizedString(@"用户不存在", nil);
                    }else if (_SuccessOrErrCode==404){
                        msg =  NSLocalizedString(@"解绑失败，请稍后重试", nil);
                    }else{
                        
                    }

                    [self.view makeToast:msg duration:2 position:@"bottom"];
                }
            }];
    }
}


#pragma mark --

- (void)nameBtnAction{
  __block SetManageDetailViewController *  blockSelf = self;
    if (_nameChangeAlert==nil) {
        
        _nameChangeAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改设备名称",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [_nameChangeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textAlignment = NSTextAlignmentCenter;
            textField.placeholder = NSLocalizedString(@"设备昵称",nil);
            [textField addTarget:blockSelf action:@selector(nameTextChangeActionEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
        }];
        
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self changeNameAction];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_nameChangeAlert addAction:cancelAction];
        [_nameChangeAlert addAction:yesAction];
        
    }
    _nameChangeAlert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:_nameChangeAlert animated:YES completion:nil];
    
    
}
//输入框
- (void)nameTextChangeActionEditingChanged:(UITextField *)textField{
    _nameStrOfThisRobot = textField.text;
    NSLog(@"EditingChanged  %@",_nameStrOfThisRobot);
    
}
//yesAction
- (void)changeNameAction{
    if (_nameStrOfThisRobot.length<=0) {
            [MBProgressHUD showMessage:NSLocalizedString(@"请输入昵称", nil)];
        return;
    }
    [MBProgressHUD showMessage:NSLocalizedString(@"正在修改昵称", nil)];
    
    //服务器
    NSString *eqh = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone",eqh,@"eqHardwareSerial",_nameStrOfThisRobot,@"nickName",nil];
    //S_equipmentAddEqu
    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentUpdateNickName withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        
        
        if (_Success) {
            [self.view makeToast:NSLocalizedString(@"修改昵称成功", nil)  duration:3 position:@"bottom"];
            //替换本页的字段
            NSLog(@"_nameStrOfThisRobot=%@",_nameStrOfThisRobot);
            [_dicOfS setObject:[NSString stringWithFormat:@"%@",_nameStrOfThisRobot] forKey:@"nickName"];
            NSLog(@"dic%@",_dicOfS);
            [self initData];
            [self.tableView reloadData];
            
            //替换单例中所存的arr
            NSMutableDictionary *dicWillChangeName = [NSMutableDictionary dictionary];
            NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
            NSMutableArray *arrOflistSave = [NSMutableArray arrayWithArray:arrOflist];
 
            for ( NSDictionary *dicOfRobot in arrOflistSave) {//一边遍历数组，又同时修改这个数组里面的内容，导致崩溃
                if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:eqh]) {
                    dicWillChangeName = [NSMutableDictionary dictionaryWithDictionary:dicOfRobot];
                    [arrOflist removeObject:dicOfRobot];
                }
            }
            
            [dicWillChangeName setObject:_nameStrOfThisRobot forKey:@"nickName"];
            [arrOflist addObject:dicWillChangeName];
            [UserTool sharedUserTool].listOfRobotsArr = [NSMutableArray arrayWithArray:arrOflist];
            
        }else{
            //失败
//            NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
           NSString *msg = NSLocalizedString(@"修改昵称失败", nil);
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"修改昵称失败，请查看网络是否可用", nil) ;
                }else{
                    msg = NSLocalizedString(@"修改昵称失败",nil);
                }
                
            }
            if (_SuccessOrErrCode==400) {
                msg = NSLocalizedString(@"用户名不能为空",nil);
            }else if (_SuccessOrErrCode==401){
                msg = NSLocalizedString(@"修改昵称失败，请稍后重试",nil);
            }else{
                
            }
            [self.view makeToast:msg duration:2 position:@"bottom"];
            
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _arrOfSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
     cell.textLabel.numberOfLines = 0;
     cell.detailTextLabel.numberOfLines = 2;
      cell.textLabel.text = _arrOfSource[indexPath.row];
    if (indexPath.row==0) {
         cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",_snIdStrOfThisRobot];
         cell.accessoryType = UITableViewCellAccessoryNone;//不添加箭头
       
    }else if (indexPath.row==1) {
          cell.detailTextLabel.text = @"";
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//添加箭头
    }else{//2
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_nameStrOfThisRobot];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//添加箭头
    }
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 120)];
    backHeaderV.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    
    UIView *whiteBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Y_mainW, 100)];
    whiteBackV.backgroundColor = [UIColor whiteColor];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
    
    imgv.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    _nickAndTimeL = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, Y_mainW-120, 80)];
    _nickAndTimeL.numberOfLines = 3;
    NSString *strofbd = NSLocalizedString(@"绑定时间", nil) ;
    _nickAndTimeL.text = [NSString stringWithFormat:@"%@\n%@：%@",[_dicOfS objectForKey:@"nickName"],strofbd,_strOfT];
    
    [whiteBackV addSubview:imgv];
    [whiteBackV addSubview:_nickAndTimeL];
    [backHeaderV addSubview:whiteBackV];
    return backHeaderV;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *backFootV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 60)];
    UIButton *btnOfdeletRobot = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOfdeletRobot.layer.cornerRadius = 5;
    btnOfdeletRobot.frame = CGRectMake(50, 20, Y_mainW-100, 40);
    [btnOfdeletRobot setTitle:NSLocalizedString(@"解除绑定", nil)  forState:UIControlStateNormal];
    [btnOfdeletRobot setBackgroundColor:[DataManager shareDataManager].colorOfMainType];
    [btnOfdeletRobot addTarget:self action:@selector(deletRobotAction:) forControlEvents:UIControlEventTouchUpInside];
    [backFootV addSubview:btnOfdeletRobot];
    return backFootV;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
//        return 80;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {//设备型号展示
        
    }
    if (indexPath.row==1) {
        CreateQrCodeViewController  *codeVc = [[CreateQrCodeViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:codeVc animated:YES];
    }
    if (indexPath.row==2) {
        [self nameBtnAction];
    }
}

@end
