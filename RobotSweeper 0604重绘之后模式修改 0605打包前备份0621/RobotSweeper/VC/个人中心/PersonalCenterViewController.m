//
//  PersonalCenterViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonCenterCollectionViewCell.h"
#import "PersonFooterCollectionReusableView.h"


#import "MyAccountViewController.h"//我的账户
#import "MyAccountXTableViewController.h"
#import "SetManageOfRobotTableViewController.h"//设备管理
#import "MessageCenterViewController.h"//消息中心
#import "ShowVersionViewController.h"
#import "FeedbackProblemsViewController.h"

@interface PersonalCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *personCenterCv;
@property (nonatomic,strong) NSMutableArray *arrOfS;
@property (nonatomic,strong) NSMutableArray *arrOfImgName;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.personCenterCv];
 
    _arrOfS = [NSMutableArray arrayWithObjects:@"我的账户",@"设备管理",@"消息中心",@"反馈问题",@"产品指南",[NSString stringWithFormat:@"%@APP",[ToolOfBasic appNameStr]], nil];
    
    _arrOfImgName = [NSMutableArray arrayWithObjects:@"mycenter_usercenter",@"mycenter_guanli",@"mycenter_message",@"mycenter_fankui",@"mycenter_zhinanzhen",@"关于", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PersonCenterCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PersonCenterCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, Y_mainW/2-20, 100)];
    }
    
    cell.signal.backgroundColor = [UIColor blueColor];
     cell.signal.hidden = YES;
//    if (indexPath.row==2&&) {
//        cell.signal.hidden = NO;
//    }else{
//        cell.signal.hidden = YES;
//    }
    cell.titleL.text = _arrOfS[indexPath.row];
    cell.imgv.image = [UIImage imageNamed:_arrOfImgName[indexPath.row]];
//    cell.imgv.image = [[UIImage imageNamed:_arrOfImgName[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    cell.imgv.tintColor = [UIColor brownColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        return CGSizeMake(Y_mainW/2-20, 160);
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Y_mainW, 80);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        
       PersonFooterCollectionReusableView  *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PersonFooterCollectionReusableView" forIndexPath:indexPath];//重用
        if (footerview==nil) {
            footerview = [[PersonFooterCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 80)];
        }
     
        [footerview.logOutBtn addTarget:self action:@selector(logOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        reusableView = footerview;
         
        
    }else{
        reusableView  = [UICollectionReusableView new];
    }
    
    return reusableView;
}

- (void)logOutBtnAction:(UIButton *)sender{
    NSLog(@"logOutBtnAction");
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:@"是否退出当前账户" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logoutAction];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    
    alert.view.layer.cornerRadius = 8;
    alert.view.backgroundColor = [UIColor whiteColor];
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
            [self.view makeToast:@"登出失败" duration:2 position:@"center"];
            
        }
    }];
    
    
}

#pragma mark -- didSelect
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect=%ld",(long)indexPath.row);
    if (indexPath.row==5) {
        ShowVersionViewController *showVersionViewController = [[ShowVersionViewController alloc]init];
        [self.navigationController pushViewController:showVersionViewController animated:YES];
    }
    
    if (indexPath.row == 4) {
        [MBProgressHUD showError:@"暂无产品指南"];
//        YPageViewController *productGuideVc = [[YPageViewController alloc]init];
//        [self.navigationController pushViewController:productGuideVc animated:YES];
}
    if (indexPath.row == 3) {
        FeedbackProblemsViewController*feedbackProblemsViewController = [[FeedbackProblemsViewController alloc]init];
        [self.navigationController pushViewController:feedbackProblemsViewController animated:YES];

    }
    if (indexPath.row == 2) {//消息中心
        [MBProgressHUD showError:@"消息中心暂未开通"];
//        MessageCenterViewController *messageCenterVc = [[MessageCenterViewController alloc]init];
//        [self.navigationController pushViewController:messageCenterVc animated:YES];
        
    }
    if (indexPath.row == 1) {
        SetManageOfRobotTableViewController *setManageOfRobot = [[SetManageOfRobotTableViewController alloc]init];
        [self.navigationController pushViewController:setManageOfRobot animated:YES];
    }
    if (indexPath.row == 0) {
        MyAccountXTableViewController *myAccountVc = [[MyAccountXTableViewController alloc]init];
        [self.navigationController pushViewController:myAccountVc animated:YES];
//    MyAccountXTableViewController MyAccountViewController
    }
    
}

- (UICollectionView*)personCenterCv{
    if (!_personCenterCv) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
        _personCenterCv = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _personCenterCv.dataSource = self;
        _personCenterCv.delegate = self;
        //注册
        [_personCenterCv registerClass:[PersonCenterCollectionViewCell class] forCellWithReuseIdentifier:@"PersonCenterCollectionViewCell"];

        [_personCenterCv registerClass:[PersonFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PersonFooterCollectionReusableView"];
        _personCenterCv.backgroundColor = [UIColor whiteColor];
    }
    return _personCenterCv;
}
@end
