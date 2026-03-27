//
//  PersonSetVC.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "PersonSetVC.h"
#import "PersonInfoVC.h"
#import "SafetyCenterVC.h"
#import "CommonVC.h"
#import "AboutVC.h"
#import "MoneyOfThridBangDingListVc.h"
//
#import "SocketRocketUtility.h"
//
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
//
#import "PersonSetVCShwoTwoTextTableViewCell.h"
#import "ZYPersonThemeColorSwitchCell.h"

#import "ZBLocalNotification.h"

#import "HealthBaseDataManager.h"
#import "TrusangBlueToothSdkDataManager.h"
#import "DevGetNowUsersDevInfoModel.h"

#import "ExitActionWithCleanOrChangeUserInfoTool.h" //退出登录 的数据清理

static NSString *const personThemeColorSwitchCellID = @"ZYPersonThemeColorSwitchCell";

#define RowNum_UserInfo          (0)
#define RowNum_RealName          (1)
#define RowNum_AccountInfo       (2)
#define RowNum_ThridAccountInfo  (3)

#define RowNum_General           (0)
#define RowNum_Advice            (1)
#define RowNum_About             (2)

@interface PersonSetVC () <ZYPersonThemeColorSwitchCellDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@property (nonatomic,strong) NSMutableArray *userInfoTitleArr;
@property (nonatomic,strong) NSMutableArray *systemInfoTitleArr;

@end

@implementation PersonSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)initView{
    self.title = @"设置"; 
    //self.tableView.backgroundColor = Color_245Gray;
//    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.footerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYPersonThemeColorSwitchCell" bundle:nil] forCellReuseIdentifier:personThemeColorSwitchCellID];
}
- (void)initData{
   // self.dataSourceArr = [NSMutableArray arrayWithObjects:@"个人信息",@"账号与安全",@"通用",@"意见反馈",@"关于未来物服", nil];//  @"欢迎评分"
    self.userInfoTitleArr =  [NSMutableArray arrayWithObjects:@"个人信息",@"实名认证",@"账号与安全",@"第三方账号绑定", nil];
    self.systemInfoTitleArr = [NSMutableArray arrayWithObjects:@"通用",@"意见反馈",@"关于未来物服", nil];
    [self.tableView reloadData];
}

#pragma mark == "退出账号"
- (void)footerBtnTouchGoBack{
//退出账号 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出账号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exitAction];
    }];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOk];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
   
}
- (void)exitAction{
    
    [ExitActionWithCleanOrChangeUserInfoTool exitActionWithDealUseInfo];// //退出登录 的数据清理
    
    //页面
//    LoginVC *loginVC = [[LoginVC alloc]init];
    LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc] init];//20220514新版
    self.view.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.view.window makeKeyAndVisible];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if (section==0) {
        return self.userInfoTitleArr.count;
    }else{
        return self.systemInfoTitleArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == RowNum_RealName) {//实名认证
        PersonSetVCShwoTwoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonSetVCShwoTwoTextTableViewCell_I];
        if (!cell) {
            cell = [[PersonSetVCShwoTwoTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonSetVCShwoTwoTextTableViewCell_I];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        cell.accessoryType = UITableViewCellAccessoryNone;//无箭头
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.textLabel.text = self.userInfoTitleArr[indexPath.row];
        
        if (ZY_IsRealName ) {
            cell.rightTextL.text = @"已实名认证";
            cell.rightTextL.textColor = [ThemeManager shareManager].mainTextColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }else{
            cell.rightTextL.text = @"去认证";
            cell.rightTextL.textColor = Color_Blue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        cell.accessoryView = accessoryImgView;
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
     
        if (indexPath.section==0) {
            cell.textLabel.text = self.userInfoTitleArr[indexPath.row];

        }else{
            cell.textLabel.text = self.systemInfoTitleArr[indexPath.row];

        }
        
        return cell;
    }

}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((indexPath.section==1) &&  indexPath.row==RowNum_About) {//关于app  这一条都要能走
         AboutVC *vc = [[AboutVC alloc] init];
         [self pushVc:vc];
        return;
    }
    if ((indexPath.section == 0) && indexPath.row == RowNum_RealName) {
        WEAKSELF
        [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
            if (needGotoRealNameVcBool ) {
                [weakSelf pushVc:realNameVc];
            }else{
                DLog(@"已实名认证");
            }
        }];
        return;
    }
    //_______________________________
    if ([self shouldShowBindVcBool]) {//——————————————————————判定是否跳转绑定手机页
        return;
    }
    //_______________________________
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case RowNum_UserInfo:
            {
                PersonInfoVC *vc = [[PersonInfoVC alloc] init];
                [self pushVc:vc];
                
            }
                break;
                
            case RowNum_AccountInfo:
            {
                SafetyCenterVC *vc = [[SafetyCenterVC alloc] init];//账号与安全
                [self pushVc:vc];

            }
                break;
            case RowNum_ThridAccountInfo:
            {
                //test
                MoneyOfThridBangDingListVc *vc = [[MoneyOfThridBangDingListVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
                return;
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case RowNum_General:
            {
                CommonVC *vc = [[CommonVC alloc] init];//通用
                [self pushVc:vc];

            }
                break;
            case RowNum_Advice:
            {
                ComplaintsSuggestionsVC *vc = [[ComplaintsSuggestionsVC alloc]init];//投诉建议
                [self pushVc:vc];
            }
                break;
            case RowNum_About:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }
}
- (void)changeThemeColorAction{
    DLog(@"主题模式切换 %lu",(unsigned long)[ThemeManager shareManager].type);
    [ThemeManager shareManager].type = ([ThemeManager shareManager].type==ThemeType_White)?(ThemeType_Drak):(ThemeType_White);
    //切换
    if ([ThemeManager shareManager].type==ThemeType_White) {
        [ThemeManager shareManager].type = ThemeType_White;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_White;
        [ZYThemeManager shareManager].themeType = ZYThemeType_White;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else{
        [ThemeManager shareManager].type = ThemeType_Drak;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_Dray;
        [ZYThemeManager shareManager].themeType = ZYThemeType_Dark;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    //存储
    [[NSUserDefaults standardUserDefaults] setValue:[ThemeManager shareManager].saveThemeTypeWithStr forKey:Key_SaveThemeTypeWithStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(NOTICE_NAME_ThemeISChanged);
}

#pragma mark - ZYPersonThemeColorSwitchCellDelegate
- (void)whiteButtonEvent {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        [ThemeManager shareManager].type = ThemeType_White;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_White;
        [ZYThemeManager shareManager].themeType = ZYThemeType_White;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        //存储
        [[NSUserDefaults standardUserDefaults] setValue:[ThemeManager shareManager].saveThemeTypeWithStr forKey:Key_SaveThemeTypeWithStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //通知
        Y_NSNotificationCenter_PostNotice_NilObject_Name(NOTICE_NAME_ThemeISChanged);
    }
}

- (void)blackButtonEvent {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        [ThemeManager shareManager].type = ThemeType_Drak;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_Dray;
        [ZYThemeManager shareManager].themeType = ZYThemeType_Dark;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        //存储
        [[NSUserDefaults standardUserDefaults] setValue:[ThemeManager shareManager].saveThemeTypeWithStr forKey:Key_SaveThemeTypeWithStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //通知
        Y_NSNotificationCenter_PostNotice_NilObject_Name(NOTICE_NAME_ThemeISChanged);
    }
}

#pragma mark == 是否绑定手机的跳转判定
#pragma mark === 判定是否需要弹出绑定vc (需要登录的游客账号不会显示本页)
- (BOOL)shouldShowBindVcBool{
    if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
        //用三方ID绑定电话
        //苹果 绑定手机操作
        AppleLoginModel *model = [[AppleLoginModel alloc]init];
        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
        //
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        bindVc.hidesBottomBarWhenPushed = YES;
        [self pushVc:bindVc];
        return YES;
    }else{
        return NO;
    }
}
//____________________________________________
 
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(16, Screen_H-90-kNavBarHeight-KIndicatorHeight, Screen_W-32, 90)];//xywh
        [_footerView.footerBtn newAnBtnWithTextStr:@"退出账号"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnTouchGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}


@end
