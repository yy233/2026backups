//
//  ShippingAddressVC.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressVC.h"
#import "ShippingAddressVcTableViewCell.h"
#define  ShippingAddressVcTableViewCell_Identifier @"ShippingAddressVcTableViewCell"
#import "ShippingAddressAddNewVC.h"

//
#import "ShippingAddressData.h"
//
@interface ShippingAddressVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

@implementation ShippingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = self.footerView;
    self.footerView.footerBtn.backgroundColor =  Y_RGBA(246, 77, 69, 1);
}
- (void)initData{
    WEAKSELF
    [ShippingAddressData getUserAddressListWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[ShippingAddressModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    [self initData];
}
#pragma mark - footerAddAction
- (void)footerAddAction{
    DLog(@"");
    ShippingAddressAddNewVC *vc= [[ShippingAddressAddNewVC alloc]init];
    vc.isAddType = YES;
    [self pushVc:vc];
}
#pragma mark - editBtnAction
- (void)editBtnAction:(UIButton *)sender{
    DLog(@"");
    //
    ShippingAddressModel *model = self.dataSourceArr[sender.tag-200];
    ShippingAddressAddNewVC *vc= [[ShippingAddressAddNewVC alloc]init];
    vc.isAddType = NO;
    vc.isEditWithAddressUuidStr = [TextShowWithModelStr textShowWithModelStr:model.uuid];
    [self pushVc:vc];
}
#pragma mark === delet
- (void)deletWithAddressUuid:(NSString *)uuid{
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ShippingAddressData deletUserAddressWithUUID:uuid withDicBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"已成功删除");
            [weakSelf initData];//加载
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShippingAddressVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShippingAddressVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[ShippingAddressVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShippingAddressVcTableViewCell_Identifier];
    }
    ShippingAddressModel *model = self.dataSourceArr[indexPath.row];
    cell.topL.text = [TextShowWithModelStr textShowWithModelStr:model.address];// [[TextShowWithModelStr textShowWithModelStr:model.address] stringByAppendingString:[TextShowWithModelStr textShowWithModelStr:model.addressDescription]];// @"天宫殿小区";
    cell.addressL.text = [TextShowWithModelStr textShowWithModelStr:model.addressDescription];
    
    NSString *sexStr = model.sex==0 ? @"（先生）":@"（女士）";
    cell.infoL.text = [NSString stringWithFormat:@"%@%@%@",[TextShowWithModelStr textShowWithModelStr:model.name],sexStr,[TextShowWithModelStr textShowWithModelStr:model.phone]];//@"刘德华（先生）18369854671";
    [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row+200;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[PersonCenterVC class]]) {//上页为个人中心 则不做动作
        }else if([vc isKindOfClass:[BusinessServicesVC class]]){
            [self noticeToAddressInfoWithdidSelectRowAtIndexPath:indexPath];
        }else{
        }
    }
}
- (void)noticeToAddressInfoWithdidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShippingAddressModel *model = self.dataSourceArr[indexPath.row];
    //用于商城选地址时使用
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model forKey:Notice_UserInfo_Key];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(Buniess_willPay_To_ChooseAddress, userInfo);
    [self popVC];
}

//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShippingAddressModel *model = self.dataSourceArr[indexPath.row];
        [self deletWithAddressUuid:[TextShowWithModelStr textShowWithModelStr:model.uuid]];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"新增地址" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
