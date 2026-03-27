//
//  IssueHouseManagerVcLate.m
//  Community
//
//  Created by 余莹 on 2021/8/23.
//

#import "IssueHouseManagerVcLate.h"
#import "IssueHouseManagerHeaderView.h"
#import "IssueHouseManagerVcTopAddTableViewCell.h"
//#define  IssueHouseManagerVcTopAddTableViewCell_Identifier          @"IssueHouseManagerVcTopAddTableViewCell"
#import "IssueHouseManagerVcTopTwoBtnsTableViewCell.h"
#define  IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier      @"IssueHouseManagerVcTopTwoBtnsTableViewCell"
#import "IssueHouseManagerVcHouseTableViewCell.h"
#define  IssueHouseManagerVcHouseTableViewCell_Identifier      @"IssueHouseManagerVcHouseTableViewCell"

#import "IssueHouseManagerVcHouseTableViewCellLate.h"
#define  IssueHouseManagerVcHouseTableViewCellLate_Identifier      @"IssueHouseManagerVcHouseTableViewCellLate"

//
#import "IssueHouseAppointmentManagerVc.h"
//
#import "IssueManagerViewModel.h"// 房东身份时 发布的列表数据 (商铺 房屋)
//
#import "IssHouseManagerDetailVC.h"

//0710增 自己发布的商铺
#import "IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView.h" //
#import "IssBuniessShopManagerDetailVC.h"
#import "IssueHouseMainVc.h"


#define   Color_2Green    Y_RGBA(2, 195, 168, 1)
#define   Tag_Buniess_Btn 200
#define   Tag_Btn         300

//#define  Section_Num_AddNew                         0
#define  Section_Num_YuyueQianyue                   0
#define  Section_Num_BuniessCellOrHouseCell         1

@interface IssueHouseManagerVcLate ()<IssueHouseManagerHeaderViewDelegate,IssueHouseManagerVcTopAddTableViewCellDelegate,IssueHouseManagerVcTopTwoBtnsTableViewCellDelegate,IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) IssueHouseManagerHeaderView *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView *houseOrBuniessSectionHeaderView;
@property (nonatomic,strong) NSMutableArray *buniessShopArr;
@property (nonatomic,assign) BOOL isShowHouseList;//房屋 商铺切换
@end

@implementation IssueHouseManagerVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buniessShopArr = [[NSMutableArray alloc]init];
    self.isShowHouseList = YES;
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
//    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor: [ThemeManager shareManager].themeContentBackGroundColor];
    [self upBottomListData];//取消某发布成功时需要 新增后返回到本页 需要
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheNavIsWwBackIsCountViewBackBulue];//setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)chooseHouseOrBuniessSectionHeaderViewWithIsShowBuniessListBool:(BOOL)isShowBuniessListBool{
    self.isShowHouseList = !isShowBuniessListBool;
    [self upBottomListData];//商铺 房屋 切换时 需要
}
- (void)initView{
    self.title = @"租房管理";
//    [self initNavRightItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
 
//    self.tableView.tableHeaderView = self.headerView;//只有房东身份 不做身份切换（房东才有 房屋管理 ）
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview).offset(-KIndicatorHeight);
        make.height.offset(50);
    }];
//
    self.headerView.nameL.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.realName];
    self.headerView.phoneL.text =  [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile];
  
    //
    if (self.myType == IssueHouseManagerVC_MyType_ZuKe || self.myType == IssueHouseManagerVC_MyType_FangDong) {
        self.headerView.changeBtn.hidden = NO;
    }else{
        self.headerView.changeBtn.hidden = YES;
    }
    [self changeManagerVcMyType:self.myType];
}
- (void)initNavRightItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    UIImage *infoImg = [[UIImage imageNamed:@"My_Head_news"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [rightBtn setImage:infoImg forState:UIControlStateNormal];
    [rightBtn.imageView setTintColor:[UIColor whiteColor]];
    //
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction{
    DLog(@"");
//    Y_SVP_SHOW_INFO_MES(@"rightBtnAction");
}
#pragma mark ==
- (void)changeManagerVcMyType:(IssueHouseManagerVC_MyType)type{
    self.myType = type;
    DLog(@"");
    switch (self.myType) {
        case IssueHouseManagerVC_MyType_ZuKe:
            self.headerView.changeBtn.selected = NO;
            [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
            self.footerView.hidden = YES;//租客状态不能发布房源
            break;
        case IssueHouseManagerVC_MyType_FangDong:
            self.headerView.changeBtn.selected = YES;
            [self.tableView setSeparatorColor:[UIColor clearColor]];
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.footerView.hidden = NO;
            break;
        default:
            [self.tableView setSeparatorColor:[UIColor clearColor]];
            break;
    }
    [self.tableView reloadData];
    [self upBottomListData];
}
- (void)upBottomListData{
    WEAKSELF
    if (self.myType == IssueHouseManagerVC_MyType_FangDong){ //房东身份 发布过的house 列表
        
        if (self.isShowHouseList) {
            [IssueManagerViewModel managerVcBottomFangDongTypeWithListBlock:^(NSArray * arr, BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_header endRefreshing];
                });
                if (success) {
                    self.dataSourceArr = [[NSMutableArray alloc]initWithArray:[HouseRentListVcHouseCellModel mj_objectArrayWithKeyValuesArray:arr]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }];
        }else{
            [IssueManagerViewModel managerVcBottomBuniessShopTypeWithListBlock:^(NSArray * arr, BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_header endRefreshing];
                });
                if (success) {
                    self.buniessShopArr = [[NSMutableArray alloc]initWithArray:[IssueBuniessShopManagerListUseModel mj_objectArrayWithKeyValuesArray:arr]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }];
        }
       
    }
//    if (self.myType == IssueHouseManagerVC_MyType_BuniessShopManager) {//房东身份 发布过的buniessShop 列表 子类已有initData (商铺管理类)
//    }
}
#pragma mark == action新增发布

- (void)cellTouchBtnWithAddAction{   //新增发布
    DLog(@"");
    //add 发布房源
    IssueHouseMainVc *issueHouse = [[IssueHouseMainVc alloc]init];
    issueHouse.hidesBottomBarWhenPushed = YES;
    [self pushVc:issueHouse];
}

#pragma mark == action预约
- (void)cellTouchYuyueAction{
    [self goYuyueManagerVc];
}


#pragma mark == action签章
- (void)cellTouchQianyueAction{
    Y_SVP_SHOW_INFO_MES(@"当前功能暂未开放");//test
    DLog(@"");
}
#pragma mark ==
- (void)editBtnAction:(UIButton *)sender{
    if (!self.isShowHouseList) {
        return;
    }
    NSInteger index = sender.tag-Tag_Btn;
    HouseRentListVcHouseCellModel *model =  self.dataSourceArr[index];
    IssHouseManagerDetailVC *vc = [[IssHouseManagerDetailVC alloc]init];
    vc.IDNum = model.ID;
    vc.isManagerTypeLastCellIsChange = YES;
    [self pushVc:vc];
}
- (void)editBuniessBtnAction:(UIButton *)sender{
    if (self.isShowHouseList) {
        return;
    }
    NSInteger indx = sender.tag-Tag_Buniess_Btn;
    IssueBuniessShopManagerListUseModel *model = self.buniessShopArr[indx];
    IssBuniessShopManagerDetailVC *vc = [[IssBuniessShopManagerDetailVC alloc]init];
    vc.IDNum = model.ID;
    vc.isManagerTypeLastCellIsChange = YES;
    [self pushVc:vc];

}

#pragma mark ===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myType == IssueHouseManagerVC_MyType_ZuKe) {//租客身份 简单两行cell
        if (indexPath.row==0) {//预约管理
            [self goYuyueManagerVc];
         
        }
        if (indexPath.row==1) {
            DLog(@"");
        }
        
    }
}
- (void)goYuyueManagerVc{
    IssueHouseAppointmentManagerVc *vc = [[IssueHouseAppointmentManagerVc alloc]init];
    vc.myIdentityType = self.myType;
    [self pushVc:vc];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        return 1;
    }else if (self.myType==IssueHouseManagerVC_MyType_FangDong){
//        return 3;
        return 2;//addcell去除改成footerv
    }else{//其他类型暂0
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        return 2;
    }else if (self.myType==IssueHouseManagerVC_MyType_FangDong){
        if (section==[tableView numberOfSections]-1) {
            if (self.isShowHouseList) {
                return self.dataSourceArr.count;
            }else{
                return self.buniessShopArr.count;
            }
          
        }else{
            return 1;
        }
    }else{//其他类型暂0
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        return 50;
    }else if (self.myType==IssueHouseManagerVC_MyType_FangDong){
//        if (indexPath.section == Section_Num_AddNew) {
//            return 100;//发布新房源按钮
//        }else
        if (indexPath.section== Section_Num_YuyueQianyue){
            //            return 60;//预约签章按钮
            return 0.01;//预约签章按钮 暂时隐藏
        }else{
            return 120;//cell 高度
        }
        return 0;
    }else{
        return 0;
    }
 
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        return 0.01;
    }else if (self.myType==IssueHouseManagerVC_MyType_FangDong && section== Section_Num_BuniessCellOrHouseCell){//列表数据
        return 50;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        return [UIView new];
    }else if (self.myType==IssueHouseManagerVC_MyType_FangDong && section == Section_Num_BuniessCellOrHouseCell){
        if (self.isShowHouseList) {
            self.houseOrBuniessSectionHeaderView.buniessBtn.selected = NO;
            self.houseOrBuniessSectionHeaderView.houseBtn.selected = YES;
        }else{
            self.houseOrBuniessSectionHeaderView.buniessBtn.selected = YES;
            self.houseOrBuniessSectionHeaderView.houseBtn.selected = NO;
        }
        return self.houseOrBuniessSectionHeaderView;
    }else{
        return [UIView new];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myType==IssueHouseManagerVC_MyType_ZuKe) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
            cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        }
        if (indexPath.row==0) {
            cell.textLabel.text = @"预约管理";
        }else{
            cell.textLabel.text = @"签约管理";
        }
        return cell;
    }else{
        return [self fangDongTypeTableView:tableView fangDongCellForRowAtIndexPath:indexPath];
        
    }
}
- (UITableViewCell *)fangDongTypeTableView:(UITableView *)tableView fangDongCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section== Section_Num_YuyueQianyue){
        IssueHouseManagerVcTopTwoBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHouseManagerVcTopTwoBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier];
        }
        //_______预约签章按钮 暂时隐藏
        cell.yuyueBtn.hidden = YES;
        cell.qianyueBtn.hidden = YES;
        //_______
        cell.delegate = self;
        return cell;
    }else{

        //cell_model 仅用于商铺_ 商铺 走子类数据 ｜｜ 0710 合并房屋商铺
        if (self.myType == IssueHouseManagerVC_MyType_FangDong){ //房东身份 发布过的house 列表 房屋列表数据
            
            if (self.isShowHouseList) {
                IssueHouseManagerVcHouseTableViewCellLate *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
                if (!cell) {
                    cell = [[IssueHouseManagerVcHouseTableViewCellLate alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
                }
                HouseRentListVcHouseCellModel *model = self.dataSourceArr[indexPath.row];
                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.houseTitle];//title 新增时的描述
                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.housePrice];
                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseMode];
                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseDeposit];
                NSString *urlStr = [NSString stringWithFormat:@"%@",model.houseImage.firstObject];
                if (urlStr.length>0) {
                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
                }
                cell.editBtn.tag = indexPath.row + Tag_Btn;
                [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{ //商铺列表数据
                IssueHouseManagerVcHouseTableViewCellLate *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
                if (!cell) {
                    cell = [[IssueHouseManagerVcHouseTableViewCellLate alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
                }
                IssueBuniessShopManagerListUseModel *model = self.buniessShopArr[indexPath.row];
//                cell.model = model;//没啥用 此数据少 model键值多
//                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.address];//本接口 文本 只有这个address可用于展示
                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.title];//0923 换成title
                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.monthMoney];
                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.statusString];
                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.defrayType];
                NSString *urlStr = [NSString stringWithFormat:@"%@",model.shopShowImg];
                if (urlStr.length>0) {
                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
                }
                cell.editBtn.tag = indexPath.row + Tag_Buniess_Btn;
                [cell.editBtn addTarget:self action:@selector(editBuniessBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
           
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            return cell;
        }
    }
}
//
#pragma mark ==
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-kNavBarHeight-50-KIndicatorHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (IssueHouseManagerHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[IssueHouseManagerHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView ) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, Screen_H -kNavBarHeight -50 -KIndicatorHeight, Screen_W, 50)];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W, 50)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"发布房源"];
        _footerView.footerBtn.layer.cornerRadius = 0.01;
        [_footerView.footerBtn addTarget:self action:@selector(cellTouchBtnWithAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView *)houseOrBuniessSectionHeaderView{
    if (!_houseOrBuniessSectionHeaderView) {
        _houseOrBuniessSectionHeaderView = [[IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView alloc]initWithFrame:CGRectZero];
        _houseOrBuniessSectionHeaderView.delegate = self;
    }
    return _houseOrBuniessSectionHeaderView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
@end
