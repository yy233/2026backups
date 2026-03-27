//
//  SafetyCenterVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "SafetyCenterVC.h"

#import "LoginPasswordSetVC.h"
#import "PayPasswordSetVC.h"
#import "PhoneChangeFirstStepVC.h"
#import "PhoneChangeSecondStepVC.h"
#import "AccountCancelVC.h"


#import "PersonInfoNormalCell.h"

//#import "ZYElectronicSignPasswordSettingVc.h"
//#import "ZYElectronicSignPasswordChangedVc.h"

@interface SafetyCenterVC ()

@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSMutableArray *subArray;

@property(nonatomic, strong) NSString *selectedDate;

@end

static NSString *const normalCellID = @"PersonInfoNormalCell";

@implementation SafetyCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
    
    [self initData];
}

- (void)initView{
    self.title = @"安全中心";
    [self.tableView registerClass:[PersonInfoNormalCell class] forCellReuseIdentifier:normalCellID];
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
}
- (void)initData{
    self.titleArray = [NSMutableArray arrayWithObjects:@"登录密码",@"支付密码",@"修改手机号",nil];//@"注销账号"
    NSString *loginPassword;
    NSString *payPassword;
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPassword) {
        loginPassword = @"修改";
    }else {
        loginPassword = @"未设置";
    }
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
        payPassword = @"修改";
    }else {
        payPassword = @"未设置";
    }
    NSString *tel = [ZYHidePartTool hidePartWithStr:[ShareUserInfo sharedUserInfo].userInfo.mobile holderSingleStr:@"*" location:3 length:4];
    self.subArray = [NSMutableArray arrayWithObjects:loginPassword, payPassword, tel,nil];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArray.count;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
    if (!cell) {
        cell = [[PersonInfoNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellID];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titleArray[indexPath.row];
    cell.sub = self.subArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        LoginPasswordSetVC *vc = [[LoginPasswordSetVC alloc] init];
//        [self pushVc:vc];
        
        PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
        vc.type = Set_Password_Type_Login;
        [self pushVc:vc];
    }else if (indexPath.row == 1){
//        if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
//            ZYElectronicSignPasswordChangedVc *vc = [[ZYElectronicSignPasswordChangedVc alloc] init];
//            vc.typeStr = @"支付密码";
//            [self pushVc:vc];
//        }else {
//            ZYElectronicSignPasswordSettingVc *vc = [[ZYElectronicSignPasswordSettingVc alloc] init];
//            vc.typeStr = @"支付密码";
//            [self pushVc:vc];
//        }
       DLog(@"didSelectRowAtIndexPath ");
        PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
        vc.type = Set_Password_Type_Pay;
        [self pushVc:vc];
    }else if (indexPath.row == 2){
//        PhoneChangeFirstStepVC *vc = [[PhoneChangeFirstStepVC alloc] init];
//        [self pushVc:vc];
        
        PhoneChangeSecondStepVC *vc = [[PhoneChangeSecondStepVC alloc] init];
        [self pushVc:vc];
    }else if (indexPath.row == 3){//@"账户注销"
        //暂不显示
        AccountCancelVC *vc = [[AccountCancelVC alloc] init];
        [self pushVc:vc];
    }
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
