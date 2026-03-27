//
//  IssueBuniessShopManagerVC.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueBuniessShopManagerVC.h"
#import "ShopBuniessIssueVc.h"
 
#import "IssueHouseManagerVcTopAddTableViewCell.h"
#define  IssueHouseManagerVcTopAddTableViewCell_Identifier          @"IssueHouseManagerVcTopAddTableViewCell"
#import "IssueHouseManagerVcTopTwoBtnsTableViewCell.h"
#define  IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier      @"IssueHouseManagerVcTopTwoBtnsTableViewCell"
#import "IssueHouseManagerVcHouseTableViewCell.h"
#define  IssueHouseManagerVcHouseTableViewCell_Identifier      @"IssueHouseManagerVcHouseTableViewCell"
//
#import "IssueBuniessShopManagerListUseModel.h"
//
#import "IssBuniessShopManagerDetailVC.h"
//
#define Tag_Btn   200
 
@interface IssueBuniessShopManagerVC () <IssueHouseManagerVcTopAddTableViewCellDelegate>

@end

@implementation IssueBuniessShopManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺管理";
    self.myType = IssueHouseManagerVC_MyType_BuniessShopManager;
    [self initBussshopData];
    [self initNotice];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initBussshopData];//取消某发布成功时需要
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(ShopBuniessAddSuccess_Notice_Name, shopBuniessAddSuccessNotice);
}
- (void)shopBuniessAddSuccessNotice{
    [self initBussshopData];//已发商铺的list更新
}
- (void)initBussshopData{
    WEAKSELF
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_Get_BuniessShop_UserSendList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[IssueBuniessShopManagerListUseModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                NSLog(@"%@",responsObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}

- (void)rightBtnAction{
    DLog(@"");
    Y_SVP_SHOW_INFO_MES(@"商铺rightBtnAction"); 
}

#pragma mark == add
- (void)cellTouchBtnWithAddAction{
    ShopBuniessIssueVc *vc = [[ShopBuniessIssueVc alloc]init];
    [self pushVc:vc];
 
}

#pragma mark == edit
#pragma mark ==
- (void)editBtnAction:(UIButton *)sender{
  
    
    NSInteger indx = sender.tag-Tag_Btn;
    IssueBuniessShopManagerListUseModel *model = self.dataSourceArr[indx];
    IssBuniessShopManagerDetailVC *vc = [[IssBuniessShopManagerDetailVC alloc]init];
    vc.IDNum = model.ID;
    vc.isManagerTypeLastCellIsChange = YES;
    [self pushVc:vc];
 
    
//    model.id
//    ShopBuniessIssueVc *vc = [[ShopBuniessIssueVc alloc]init];
//    vc.isEditType = YES;
//    vc.editUseId = model.id;
//    [self pushVc:vc];
    
}
 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.myType==IssueHouseManagerVC_MyType_BuniessShopManager) {
        return 2;
    }else{//其他类型暂0
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   if (self.myType==IssueHouseManagerVC_MyType_BuniessShopManager){
        if (section==[tableView numberOfSections]-1) {
            return self.dataSourceArr.count;
        }else{
            return 1;
        }
    }else{//其他类型暂0
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.myType==IssueHouseManagerVC_MyType_BuniessShopManager){
        if (indexPath.section==0) {
            return 100;
        }else{
            return 120;
        }
        return 0;
    }else{
        return 0;
    }
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myType==IssueHouseManagerVC_MyType_BuniessShopManager) {
        return [self fangDongTypeTableView:tableView buniessShopCellForRowAtIndexPath:indexPath];
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        }
        return cell;
    }
}
- (UITableViewCell *)fangDongTypeTableView:(UITableView *)tableView buniessShopCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        IssueHouseManagerVcTopAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcTopAddTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHouseManagerVcTopAddTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcTopAddTableViewCell_Identifier];
        }
        cell.delegate = self;
//        cell.centerBtn.selected = (self.dataSourceArr.count>0)?YES:NO;
        cell.centerBottomL.text = (self.dataSourceArr.count>0)?@"发布新的房源":@"你还没有发布过房源";
        return cell;
    }else{
        IssueHouseManagerVcHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcHouseTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHouseManagerVcHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcHouseTableViewCell_Identifier];
        }
        IssueBuniessShopManagerListUseModel *model = self.dataSourceArr[indexPath.row];
        cell.model = model;
        cell.editBtn.tag = indexPath.row + Tag_Btn;
        [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

@end
