//
//  PersoncenterXViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/27.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PersoncenterXViewController.h"
#import "PersonFooterCollectionReusableView.h"
#import "MyAccountXTableViewController.h"
#import "MyAccountViewController.h"//我的账户
#import "SetManageOfRobotTableViewController.h"//设备管理
#import "MessageCenterViewController.h"//消息中心
#import "ShowVersionViewController.h"
#import "FeedbackProblemsViewController.h"
#import "productguideviewcontroller.h"//产品指南

@interface PersoncenterXViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *personCenterTableView;

@property (nonatomic,strong) NSMutableArray *arrOfS;
@property (nonatomic,strong) NSMutableArray *arrOfImgName;
@end

@implementation PersoncenterXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"个人中心", nil);
    
}
- (void)initData{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[ToolOfNetWork sharedTools]endXml];
    
   
    _arrOfS = [NSMutableArray arrayWithObjects:NSLocalizedString(@"设备管理",nil),NSLocalizedString(@"消息中心",nil),NSLocalizedString(@"反馈问题",nil),NSLocalizedString(@"产品指南",nil),[NSString stringWithFormat:@"%@APP",[ToolOfBasic appNameStr]], nil];
    
//    _arrOfImgName = [NSMutableArray arrayWithObjects:@"mycenter_guanli",@"mycenter_message",@"mycenter_fankui",@"mycenter_zhinanzhen",@"关于", nil];
    _arrOfImgName = [NSMutableArray arrayWithObjects:@"shebeiguanli",@"xiaoxizhongxin",@"yijianfankui",@"chanpinzhinan",@"jingguoapp", nil];
}
- (void)initView{
    [self.view addSubview:self.personCenterTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        return _arrOfS.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headView = [[UIView alloc]init];
//    headView.frame = CGRectMake(0, 0, Y_mainW, 20);
//    headView.backgroundColor = [UIColor grayColor];
//    return headView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    
    if (indexPath.section==0) {
        cell.textLabel.text = NSLocalizedString(@"我的账户",nil);
        cell.imageView.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"wodezhanghu"];
    }else if(indexPath.section==1){
        cell.textLabel.text = _arrOfS[indexPath.row];
        cell.imageView.image = [SkinManager skin_imageWithTypeAndNameWithImageName:_arrOfImgName[indexPath.row]];//arr
    }else{
        cell.textLabel.text = NSLocalizedString(@"退出登录",nil);
        cell.imageView.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"tuichu"];
    }
    //调整图片大小  cell的imageView是readonly（只读属性），所以不能修改ImageView的大小。 在iOS8会变花
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        self.title = @"";
        MyAccountXTableViewController *myAccountVc = [[MyAccountXTableViewController alloc]init];
        [self.navigationController pushViewController:myAccountVc animated:YES];
        
    }else if (indexPath.section==1){
        self.title = @"";
        if (indexPath.row==0) {//设备管理
            SetManageOfRobotTableViewController *setManageOfRobot = [[SetManageOfRobotTableViewController alloc]init];
            [self.navigationController pushViewController:setManageOfRobot animated:YES];
        }
        if (indexPath.row==1) {
//            [MBProgressHUD showError:@"消息中心暂未开通"];
                    MessageCenterViewController *messageCenterVc = [[MessageCenterViewController alloc]init];
                    [self.navigationController pushViewController:messageCenterVc animated:YES];
        }
        if (indexPath.row==2) {
            FeedbackProblemsViewController*feedbackProblemsViewController = [[FeedbackProblemsViewController alloc]init];
            [self.navigationController pushViewController:feedbackProblemsViewController animated:YES];
        }
        if (indexPath.row==3) {
     
            ProductGuideViewController *productGuideVc = [[ProductGuideViewController alloc]init];
            [self.navigationController pushViewController:productGuideVc animated:YES];
        }
        if (indexPath.row==4) {
            ShowVersionViewController *showVersionViewController = [[ShowVersionViewController alloc]init];
            
            [self.navigationController pushViewController:showVersionViewController animated:YES];
        }
        
    }else{
        //退出登录
        [self logoutAlertView];
    }
}
#pragma mark --
//退出按钮
- (UIView *)footerV{
    
      UIView *footerview = [[PersonFooterCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 80)];
  
    for (UIButton *btn in   footerview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:self action:@selector(logOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return footerview;
}
- (void)logOutBtnAction:(UIButton *)sender{
    NSLog(@"logOutBtnAction");
    [self logoutAlertView];
    
}
- (void)logoutAlertView{
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"退出",nil) message:NSLocalizedString(@"是否退出当前账户",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"退出",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logoutAction];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    
    alert.view.layer.cornerRadius = 8;
    alert.view.backgroundColor = [UIColor whiteColor];
    alert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)logoutAction{
    [[XmppManager shareXmppManager]logoutWithCompletion:^(BOOL finish) {
        
        if (finish) {
            //账号密码清空 防止推出后再点开的自动登录
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"" forKey:AccountNum];
            [def setObject:@"" forKey:PasswordNum];
            
            //登出
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.view.window.rootViewController = appDelegate.nav;
            
        } else {
            [self.view makeToast:NSLocalizedString(@"退出失败",nil) duration:2 position:@"center"];
            
        }
    }];
    
    
}

#pragma mark --getter
- (UITableView *)personCenterTableView{
    if (!_personCenterTableView) {
        _personCenterTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _personCenterTableView.frame = self.view.frame;
        _personCenterTableView.delegate = self;
        _personCenterTableView.dataSource = self;

        _personCenterTableView.tableFooterView = [UIView new];
//        _personCenterTableView.tableFooterView = [self footerV];
//        _personCenterTableView.estimatedRowHeight = 0;
//        _personCenterTableView.estimatedSectionHeaderHeight = 0;
//        _personCenterTableView.estimatedSectionFooterHeight = 0;
//        _personCenterTableView.sectionHeaderHeight = 0.01;
//        _personCenterTableView.sectionFooterHeight = 0.01;

    }
    return _personCenterTableView;
}

@end
