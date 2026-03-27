//
//  MyHouseVc.m
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import "MyHouseVc.h"
#import "MyHouseData.h"
#import "MyHousePersonRelationModel.h" 
#import "MyHouseCerEdHouseModel.h"

#import "MyHouseListVcChangeHouseView.h"
#import "MyEditHouseVc.h"
#import "MyHouseAddSubPersonVC.h"
#import "MyHouseAddSubPersonVCLate.h"
#import "MyHouseSectionHeaderView.h"
#import "MyHouseTableViewCell.h"
#define  MyHouseTableViewCell_Identifier     @"MyHouseTableViewCell"
#define  CellH   85
#define  SectionHeaderH   45
@interface MyHouseVc () <IssuLastAddressCellSubBasePopViewDelegate>
@property (nonatomic,assign) NSInteger nowCommunityId;
@property (nonatomic,assign) NSInteger nowHouseId;
@property (nonatomic,strong) NSString *nowCommunityText;//创造二维码时使用的小区文本
//
@property (nonatomic,assign) NSInteger listAllSectionNum;//目前有两组
@property (nonatomic,strong) MyHouseSectionHeaderView *sectionHeaderV;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) MyHouseListVcChangeHouseView *changeHousePopView;
@property (nonatomic,strong) NSMutableArray *chooseHouserDataSource;

@property (nonatomic,assign) NSInteger isEditDeletManagerType;//删除管理的状态
@property (nonatomic,strong) NSMutableArray *chooseTypeSaveArr;//选择的处理

@property (nonatomic,strong) MyHousePersonRelationModel *selfPersonRelationModel;//当前房屋 用户的身份与权限

@end

@implementation MyHouseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的房屋";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = self.footerView;
    [self addNavRightBtn];
    [self addRefresh];
    self.listAllSectionNum = 2;
    [self initNowIds];//初始id 只使用一次
}
- (void)initNowIds{//未切换时的初始id
    NSLog(@"initNowIds  == %@",[[UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel mj_keyValues]);
//    self.nowCommunityId = [ShareUserInfo sharedUserInfo].commuityInfo.id;
    self.nowCommunityId = [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.communityId;
    self.nowHouseId = [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.houseId;
   
    //如果不切换小区 则当前名字初始化时的最高级别小区数据
    self.nowCommunityText = @"";  
//    self.nowCommunityText = [TextShowWithModelStr textShowWithModelStr:[UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.];//缺名字

    // [ShareUserInfo sharedUserInfo].commuityInfo.houseId;
//    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel==5) {//1为业主 234家属租客新用户 5游客
     
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self allData];
}
#pragma mark ==
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(allData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)allData{
    //当前小区
    [self thisHouseSelfPersonRelationListData];//人员关系列表
    [self thisCommunitySelfRelationHouseListData];//切换房屋时的数据 自己有关联的全部房屋
}

#pragma mark ==
- (void)thisCommunitySelfRelationHouseListData{

 
        WEAKSELF
        [MyHouseData getMyHousesHaveRelattionListWithBlock:^(NSArray * arr, BOOL success) { 
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
//                weakSelf.dataSourceArr = [[NSMutableArray alloc]initWithArray:[MyHouseCerEdHouseModel mj_objectArrayWithKeyValuesArray:arr]];
                weakSelf.chooseHouserDataSource = [NSMutableArray arrayWithArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }];
    //1103去掉限制 使之所有房屋均可切换
//    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.permissions.count>1) {//1234都是用户 5为游客
//    }
}
#pragma mark ===
///人员关系列表
- (void)thisHouseSelfPersonRelationListData{
    WEAKSELF
    NSMutableDictionary *parm = @{@"houseId":@(self.nowHouseId),@"communityId":@(self.nowCommunityId)}.mutableCopy;
    NSLog(@"thisHouseSelfPersonRelationListData ==  %@",parm);
    [MyHouseData getMyHousePersonsRelationListDataWithParms:parm withBlock:^(NSDictionary * dic,  BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if (isNil(dic) || [dic allKeys].count==0) {
                weakSelf.selfPersonRelationModel = nil;
                return;
            }
            weakSelf.selfPersonRelationModel = [MyHousePersonRelationModel mj_objectWithKeyValues:dic];
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:weakSelf.selfPersonRelationModel.members];
            for (int i = 0 ; i <weakSelf.dataSourceArr.count; i ++) {
                [weakSelf.chooseTypeSaveArr addObject:@(0)];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //权限类
                if (weakSelf.selfPersonRelationModel.relation == PersonRelatio_Num_Zuke ) {//租客身份没有删除没有新增UI
                    weakSelf.sectionHeaderV.managerDeletBtn.hidden = YES;
                    weakSelf.footerView.hidden = YES;
                }else{//有房子 非租客身份 可做add人员和子功能删除人员
                    weakSelf.sectionHeaderV.managerDeletBtn.hidden = NO;
                    weakSelf.footerView.hidden = NO;
//                    [weakSelf.footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];//@"添加人员"按钮 //addTarget 不能更改action 会被叠加 方法都会执行 暂用nil判断走的方法
                    [weakSelf.footerView.footerBtn newAnBtnWithTextStr:@"添加人员"];
                }
                //数据类
                if(self.dataSourceArr.count==0){//关系列表空
                    weakSelf.sectionHeaderV.managerDeletBtn.hidden = YES;
                }
                [weakSelf.tableView reloadData];
            });
        }else{//"当前房屋未认证或者不是您的哦！";成功回调的非房屋数据 后台给的是err键值
            weakSelf.selfPersonRelationModel = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.footerView.footerBtn newAnBtnWithTextStr:@"查看房屋"];//@"编辑房屋" 1020改为查看
//                [weakSelf.footerView.footerBtn addTarget:self action:@selector(notHaveHouseWithGotoAddHouseAction) forControlEvents:UIControlEventTouchUpInside];//没房子 footer做增加房屋跳转
                //addTarget 不能更改action 会被叠加 方法都会执行 暂用nil判断走的方法
                [weakSelf.tableView reloadData];
            });
        }
    }];
     
    
}
#pragma mark === navBtn
- (void)addNavRightBtn{
   
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [rightBtn setTitle:@"切换房屋" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItems:@[rightItem]];
    //1103去掉限制 使之所有房屋均可切换
//    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.permissions.count>1) {//在本小区的房屋权限列表 不止1个房子时
//    }
}
#pragma mark == right item action
- (void)rightBtnAction:(UIButton *)sender{
    NSLog(@"切换房屋");
    [self changeHouse];
}
- (void)changeHouse{
    [self.changeHousePopView showInViewWithPopType:MyHouseListChangeShowHouseList_Type_House withListArray:self.chooseHouserDataSource];
}
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(nonnull NSDictionary *)dic{
    if (isNil(dic)) {
        return;
    }
    MyHouseRelationMeAllTypeHouseModel *model = [MyHouseRelationMeAllTypeHouseModel mj_objectWithKeyValues:dic];
    DLog(@"okBtnWithChooseListCellWithPopType  == %@",dic);
    if (model.houseId == self.nowHouseId) {
        return;//同一个门牌 不做后续处理
    }
    self.nowCommunityText = [TextShowWithModelStr textShowWithModelStr:model.communityText];//如果不切换 则当前名字初始化时的最高级别小区数据
    self.nowHouseId = model.houseId;
    self.nowCommunityId = model.communityId;
    [self thisHouseSelfPersonRelationListData];//人员关系列表 //刷新
    //
    [self changeHouseWithDefineDataSaveWithMode:model];//数据处理 是否总的切换要做权限更改 相关
}
#pragma mark == 切换小区 数据部分处理 notice 处理
- (void)changeHouseWithDefineDataSaveWithMode:(MyHouseRelationMeAllTypeHouseModel *)houseModel{
//    BOOL isChangeCommunityBool = NO;
//    if (houseModel.communityId != [ShareUserInfo sharedUserInfo].commuityInfo.id) {
//        isChangeCommunityBool = YES;
//    }else{//不同门牌 同小区 则 不刷新主页数据
//    }
//    CommunityModel *communityModel = [[CommunityModel alloc]init];
//    communityModel.id = houseModel.communityId;
//    communityModel.houseId = houseModel.id;
//    communityModel.name = houseModel.communityName;
//    [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:communityModel];//存储
//    if (isChangeCommunityBool) {
////        self.nowHouseId =
////        self.nowCommunityId =
////        [self listData];
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ( isNil(  self.selfPersonRelationModel ) ) {
        return 0;// nil时 footerBtn是编辑按钮的功能做新增房屋
    }
     return self.listAllSectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return self.dataSourceArr.count;
    }
     return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return SectionHeaderH;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else{
        return self.sectionHeaderV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellH;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseTableViewCell_Identifier];
    if (!cell) {
        cell = [[MyHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseTableViewCell_Identifier];
    }
    if (indexPath.section==0) {
        cell.editBtnBlock = ^{
            [self cellEditBtnAction];
        };
    }else{
        cell.chooseBtnSelectedBlock = ^(BOOL selected) {
            [self chooseBtnActionWithIndexRowNum:indexPath.row withSectedBool:selected];
        };
    }
    if (indexPath.section==0) {
//        [cell cellEditBtnShowBool:YES];
        [cell cellEditBtnShowBool:YES];//1019不显示编辑房屋按钮（原本要显示编辑按钮是 因为 业主家属身份 不影响更高级别的总添加，当前变为不显示 是全部为实名后 的物业后台 自动加入房屋和业主的关系）
        //编辑房屋 变成 查看房屋按钮 1020
    }else{
        [cell cellEditBtnShowBool:NO];
        [cell changeCellIsWillDeletEditWithNowUserRelationNum:self.selfPersonRelationModel.relation andNowManagerBool:self.isEditDeletManagerType];
    }
    //数据
    if (indexPath.section==0) {
        [cell fillDataWithTopCellWithModel:self.selfPersonRelationModel];
        [cell chooseTypeSaveInfoWithHidedChooseBtn];//编辑状态下的cell choose UI显示
    }else{
       
        MyHousePersonRelationSubMemberModel *model  = self.dataSourceArr[indexPath.row];
        [cell fillDataWithPersonRelationCellWithModel:model];
        if (self.isEditDeletManagerType) {//编辑状态下的cell choose UI显示
            [cell chooseTypeSaveInfoWithChooseBtnSelected:[self.chooseTypeSaveArr[indexPath.row] boolValue]];;
        }else{
            [cell chooseTypeSaveInfoWithHidedChooseBtn];
        }
       
      
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 1) {
        MyHousePersonRelationSubMemberModel *model  = self.dataSourceArr[indexPath.row];
        if (model.relation == PersonRelatio_Num_JiaShu && model.carePattern == 1) {
            if(self.isEditDeletManagerType){//编辑模式删除状态不可跳转
                Y_SVP_SHOW_INFO_MES(@"管理状态时不能跳转家属信息编辑页。");
            }else{
                [self goWithGuanHuaiMoshiDetailVcIndexPath:indexPath];//家属 关怀模式 -- 编辑页
            }
        }
    }
}
- (void)goWithGuanHuaiMoshiDetailVcIndexPath:(NSIndexPath *)indexPath{
    DLog(@"家属 关怀模式 -- 编辑页");
    MyHouseAddSubPersonVCLate *vc = [[MyHouseAddSubPersonVCLate alloc]init];
    vc.myHouseAddOrEditSubPersonVC_Type = MyHouseAddOrEditSubPersonVC_Type_Edit;
    vc.nowCommunityId = self.nowCommunityId;
    vc.nowHouseId = self.nowHouseId;
    vc.isYeZhuRight = (self.selfPersonRelationModel.relation==PersonRelatio_Num_YeZhu) ? YES : NO;
    //二维码展示用
    vc.addressStr = [NSString stringWithFormat:@"%@%@", self.nowCommunityText,[TextShowWithModelStr textShowWithModelStr:self.selfPersonRelationModel.houseSite]];
    //
    vc.listEditPersonWithModel =  self.dataSourceArr[indexPath.row];
    WEAKSELF
    vc.addOrEditPersonWithRefreshListVcBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self pushVc:vc];
    
}

#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"添加人员"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];//@"添加人员"
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}
- (MyHouseSectionHeaderView *)sectionHeaderV{
    if (!_sectionHeaderV) {
        _sectionHeaderV = [[MyHouseSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, SectionHeaderH)];
        WEAKSELF
        _sectionHeaderV.managerBtnTouchUpSelectedBool = ^(BOOL selected) {
            [weakSelf chooseManagerBtnSectedBool:selected];
        };
    }
    return _sectionHeaderV;
}
- (MyHouseListVcChangeHouseView *)changeHousePopView{
    _changeHousePopView = [[MyHouseListVcChangeHouseView  alloc]init];
    _changeHousePopView.delegate = self;
    return _changeHousePopView;
}
//
 
#pragma mark ==
- (NSMutableArray *)chooseTypeSaveArr{
    if (!_chooseTypeSaveArr) {
        _chooseTypeSaveArr = [[NSMutableArray alloc]init];
    }
    return _chooseTypeSaveArr;
}

//
- (NSMutableArray *)chooseHouserDataSource{
    if (!_chooseHouserDataSource) {
        _chooseHouserDataSource = [NSMutableArray array];
    }
    return _chooseHouserDataSource;
}
#pragma mark== 主按钮action
- (void)chooseManagerBtnSectedBool:(BOOL)selected{
    if (selected) {
        self.isEditDeletManagerType = YES; //可以编辑删除状态
        [self.footerView.footerBtn newAnBtnWithTextStr:@"删除"];
    }else{
        self.isEditDeletManagerType = NO;
        [self.footerView.footerBtn newAnBtnWithTextStr:@"添加人员"];
    }
    [self.tableView reloadData];
}

//有房子 非租客身份 可做add人员 ｜其中有人员删除功能属性处理判断按钮 子功能｜
- (void)footerBtnAction{
    if ( isNil(  self.selfPersonRelationModel ) ) {
        [self notHaveHouseWithGotoAddHouseAction];//没房子 走跳转编辑房子
        return;
    }
    //有房子
    if (self.isEditDeletManagerType) {//删除
        NSInteger i = [self.chooseTypeSaveArr indexOfObject:@(1)];
        if (i != NSNotFound) {
           //i是第一个为1的下标 还得到所有1的rownum 取到对应id做一起的删除
            NSLog(@"%@",self.chooseTypeSaveArr);
            NSMutableArray *willDeletIdsArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.chooseTypeSaveArr.count; i++) {
                if ([self.chooseTypeSaveArr[i] isEqual:@(1)]) {
                    MyHousePersonRelationSubMemberModel *model  = self.dataSourceArr[i];
                    [willDeletIdsArr addObject:@(model.ID)]; 
                }else{
                    DLog(@"---  chooseTypeSaveArr i = %@  ",self.chooseTypeSaveArr[i]);
                }
            }
            if (isNil(willDeletIdsArr) || willDeletIdsArr.count==0) {
                Y_SVP_SHOW_ERR_MES(@"家属信息有误，无法删除");
                return;
            }
            WEAKSELF

             [MyHouseData deletMyHousePersonsRelationsWithIdsArr:willDeletIdsArr withBlock:^(NSDictionary * dic, BOOL success) {
                 if (success) {
                     //选择arr滞空
                     for (int i = 0; i < self.chooseTypeSaveArr.count; i++) {
                         [self.chooseTypeSaveArr replaceObjectAtIndex:i withObject:@(0)];
                     }
                     //重新拿到数据 chooseTypeSaveArr 也删除
                     [weakSelf thisHouseSelfPersonRelationListData];
                 }
            }];
        }else{
            Y_SVP_SHOW_ERR_MES(@"请选择后再点击删除按钮！");
        }
        
    }else{//添加人员
        if ( self.selfPersonRelationModel.relation == PersonRelatio_Num_YeZhu || self.selfPersonRelationModel.relation == PersonRelatio_Num_JiaShu) {
//            MyHouseAddSubPersonVC *vc = [[MyHouseAddSubPersonVC alloc]init];
            MyHouseAddSubPersonVCLate *vc = [[MyHouseAddSubPersonVCLate alloc]init];
            vc.myHouseAddOrEditSubPersonVC_Type = MyHouseAddOrEditSubPersonVC_Type_Add;
            vc.nowCommunityId = self.nowCommunityId;
            vc.nowHouseId = self.nowHouseId;
            vc.isYeZhuRight = (self.selfPersonRelationModel.relation==PersonRelatio_Num_YeZhu) ? YES : NO;
            //二维码展示用
            vc.addressStr = [NSString stringWithFormat:@"%@%@", self.nowCommunityText,[TextShowWithModelStr textShowWithModelStr:self.selfPersonRelationModel.houseSite]];
            //
            WEAKSELF
            vc.addOrEditPersonWithRefreshListVcBlock = ^{
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            [self pushVc:vc];
        }else{
            Y_SVP_SHOW_ERR_MES(@"业主或家属才可添加人员!");
        }
        
     
    }
}
#pragma mark ==//没房子 footer做增加房屋跳转
- (void)notHaveHouseWithGotoAddHouseAction{
    [self cellEditBtnAction];
}

#pragma mark== cell sub btn action
- (void)cellEditBtnAction{
    //goto业主编辑房屋
    MyEditHouseVc *vc = [[MyEditHouseVc alloc]init];
    vc.communityId = self.nowCommunityId;
    [self pushVc:vc];
}

- (void)chooseBtnActionWithIndexRowNum:(NSInteger)rowNum withSectedBool:(BOOL)selected{
    [self.chooseTypeSaveArr replaceObjectAtIndex:rowNum withObject:[NSNumber numberWithBool:selected]];
    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:1];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
