//
//  UserInfoRegistVC.m
//  Community
//
//  Created by 余莹 on /Users/yuying/Desktop/Community/Community/Master_All/CommunityManagement/UserInfoRegistration2020/11/20.
//

#import "UserInfoRegistVC.h"
#import "UserCertificationHouserModel.h"
#define  UserInfoRegistVCTableViewCell_Identifier @"UserInfoRegistVCTableViewCell"
#define  UserInfoRegistVCNotUserInfoTableViewCell_Identifier @"UserInfoRegistVCNotUserInfoTableViewCell"
#define  UserInfoRegistVCOtherUserInfoTableViewCell_Identifier @"UserInfoRegistVCOtherUserInfoTableViewCell"
//
#import "UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar.h"   //业主
#import "UserCertificationDetailOfFamileViewController.h"           //家属
//
#import "UserCertificationDetailViewModel.h"


@interface UserInfoRegistVC () <UserInfoRegistVCOtherUserInfoTableViewCellDelegate,eidtorBtnRegistVcMainUserInfoTabeViewCellDelegate,BasePopTableViewChooseDelegate>
@property (nonatomic,strong) UIView *footerBackview;
@property (nonatomic,strong) UIButton *footerBtn;
//家属//业主 相关数据和popview
@property (nonatomic,strong) UserInfoRegistModel *mainUserModel;
@property (nonatomic,strong) PopViewChangeHouse *popViewChangeHouse;
@property (nonatomic,strong) NSMutableArray *chooseHouserDataSource;
@property (nonatomic,assign) NSInteger nowCommunityId;
@property (nonatomic,assign) NSInteger nowHouseId;

@end

@implementation UserInfoRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息登记";
    self.tableView.separatorColor = [UIColor clearColor];
    [self addRefresh];
    [self addNoticeWithUserOrFamileAddOrEdit];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    userInfoListIsRegistered 刷新
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark == addNotice
- (void)addNoticeWithUserOrFamileAddOrEdit{
//    Y_NSNotificationCenter_Creat_NameAction(Notice_Certifiction_MainUser_Add_Or_Edit_OK, noticeOfMainUserAddOrEdit);
    Y_NSNotificationCenter_Creat_NameAction(Notice_Certifiction_MainUser_Add_Ok, noticeOfMainUserAdd);
    Y_NSNotificationCenter_Creat_NameAction(Notice_Certifiction_MainUser_Add_Ok, noticeOfMainUserEdit);
    Y_NSNotificationCenter_Creat_NameAction(Notice_Certifiction_Famile_Add_Or_Edit_OK, noticeOfFamileAddOrEdit)
}
//- (void)noticeOfMainUserAddOrEdit{
//    [self.tableView.mj_header beginRefreshing];
//}
- (void)noticeOfMainUserAdd{
    self.userInfoListIsRegistered = YES;//20210225 更改当前列表状态
    [self.tableView.mj_header beginRefreshing];
}
- (void)noticeOfMainUserEdit{
    self.userInfoListIsRegistered = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)noticeOfFamileAddOrEdit{
    [self.tableView.mj_header beginRefreshing];
}
- (void)dealloc{
//      Y_NSNotificationCenter_RemoveNotice_Name(Notice_Certifiction_MainUser_Add_Or_Edit_OK);
        Y_NSNotificationCenter_RemoveNotice_Name(Notice_Certifiction_MainUser_Add_Ok);
        Y_NSNotificationCenter_RemoveNotice_Name(Notice_Certifiction_MainUser_Edit_OK);
        Y_NSNotificationCenter_RemoveNotice_Name(Notice_Certifiction_Famile_Add_Or_Edit_OK);
}
#pragma mark ==  addRefresh

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
#pragma mark == init Data
- (void)initData{
    if (self.userInfoListIsRegistered) {//已经认证过房屋 yes
        [self getNowIds];
        [self houseData];
        [self listData];
    }else{
        self.dataSourceArr = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
    }
   
}
- (void)getNowIds{
    self.nowCommunityId = [ShareUserInfo sharedUserInfo].commuityInfo.ID;
    self.nowHouseId = [ShareUserInfo sharedUserInfo].commuityInfo.houseId;
}
#pragma mark == initListData
- (void)listData{
//    if (self.nowCommunityId==0 || self.nowHouseId==0 || [ShareUserInfo sharedUserInfo].userInfo.idCard.length==0)//新用户 不加载数据 idCard做判断； nowId 即使是新用户也会 在经纬度获取小区时 初始化最近的小区的某个house
    if (self.nowCommunityId==0 || self.nowHouseId==0 || self.userInfoListIsRegistered==NO)
    {
        return;
    }
    Y_SVP_SHOW_MES_IsLoading_15Delay
    NSMutableDictionary  *parms = @{@"houseId":@(self.nowHouseId)}.mutableCopy ;
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_GuestInfoReistion_List withParams:parms finished:^(id responsObject, NSError *error) {
//20210202更换
//    [[ToolOfNetWork sharedTools]YrequestPostURLStrWithAllURLNoParmsNotMainQueue:URL_GuestInfoReistion_List withParams:parms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableDictionary *sourceDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSMutableArray *arrOfrelation = [[NSMutableArray alloc]init];
                NSMutableArray *arrOfHouser = [[NSMutableArray alloc]init];
                if (isNotNil(sourceDic) && [sourceDic.allKeys containsObject:@"proprietorMembers"]) {
                    self.mainUserModel = [UserInfoRegistModel mj_objectWithKeyValues:sourceDic];
                    self.dataSourceArr = [NSMutableArray arrayWithObject:self.mainUserModel];//业主
                    arrOfrelation = [NSMutableArray arrayWithArray:self.mainUserModel.proprietorMembers];//家属
                    arrOfHouser = [NSMutableArray arrayWithArray:self.mainUserModel.proprietorHouses]; //处理详细地址所需的house
                }
                if (arrOfrelation.count>0) {//家属
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[UserFamilyModel mj_objectArrayWithKeyValuesArray:arrOfrelation]];
                    [self.dataSourceArr addObjectsFromArray:arr];//家属arr
                }
                if (arrOfHouser.count>0) {//详细地址
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[UserCertificationHouserModel mj_objectArrayWithKeyValuesArray:arrOfHouser]];
                    UserCertificationHouserModel *model = arr.firstObject;
                    self.mainUserModel.detailAddress =  [NSString stringWithFormat:@"%@ %@ %@ %@ %@",model.communityName,model.building,model.unit,model.floor,model.door];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setReloadUI];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ====  删除家属  
- (void)deletRelationWithCellRowNum:(NSInteger)relationRowNum{
    
    if (self.dataSourceArr.count <= 1) {//没有信息 + 只有业主 没有家属
        return;
    }
   //row 0为业主 ++为家属
    if (relationRowNum==0) {
        return;
    }
    UserFamilyModel * model = self.dataSourceArr[relationRowNum];//家属
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [UserCertificationDetailViewModel mainUserDeletRelationWithRelationId:model.id withBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"该信息已成功删除");
            });
            [weakSelf  listData];
        }
    }];
    
}
#pragma mark === houstLiset Change Data
- (void)houseData{
    [UserHouseOrCommunityListModel getUserAllHouseListWithBlock:^(NSArray * arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        self.chooseHouserDataSource =  [NSMutableArray arrayWithArray:[UserHouseModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.chooseHouserDataSource.count>1) {
                [self addNavRightBtn];
            }else{
                //RightBtn空
                [self.navigationItem setRightBarButtonItems:nil];
            }
        });
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
}
#pragma mark == right item action
- (void)rightBtnAction:(UIButton *)sender{
    NSLog(@"切换房屋");
    [self changeHouse];
}
- (void)changeHouse{
    [self.popViewChangeHouse showInView:self.view thePopViewTableViewHeight:200 WithArray:self.chooseHouserDataSource];
}
- (PopViewChangeHouse *)popViewChangeHouse{
    _popViewChangeHouse = [[PopViewChangeHouse alloc]init];
    _popViewChangeHouse.delegate = self;
    return _popViewChangeHouse;
}
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
  
    UserHouseModel *model = self.chooseHouserDataSource[indexPath.row];
    if (model.id == self.nowHouseId) {
        return;//同一个门牌 不做后续处理
    }
    self.nowHouseId = model.id;
    self.nowCommunityId = model.communityId;
    [self listData];//刷新业主家属的总list
    [self changeHouseWithDefineDataSaveWithMode:model];//数据处理
    NSLog(@"popViewChangeHouse %@  %@",model.address,model.communityName);
}
#pragma mark == 切换小区 数据部分处理 notice 处理
- (void)changeHouseWithDefineDataSaveWithMode:(UserHouseModel *)houseModel{
    BOOL isChangeCommunityBool = NO;
    if (houseModel.communityId != [ShareUserInfo sharedUserInfo].commuityInfo.ID) {
        isChangeCommunityBool = YES;
    }else{//不同门牌 同小区 则 不刷新主页数据
    }
    CommunityModel *communityModel = [[CommunityModel alloc]init];
    communityModel.ID = houseModel.communityId;
    communityModel.houseId = houseModel.id;
    communityModel.name = houseModel.communityName;
    [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:communityModel];//存储
    if (isChangeCommunityBool) {
        [self changeHouseWithNoticeMainVcNowCommunityInfoRefresh];
    }
}
#pragma mark == 切换小区 notice 处理
- (void)changeHouseWithNoticeMainVcNowCommunityInfoRefresh{
    NSLog(@"通知主页更新小区数据刷新");
    Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_ChangeHouseWithChangeCommnityId_ToRefreshMainVcInfo_Name)
}
#pragma mark == UI
- (void)setReloadUI{
    if (self.dataSourceArr.count==0) {
        [self.tableView reloadData];
        self.tableView.tableFooterView = [UIView new];
    }else{
        self.tableView.tableFooterView = self.footerBackview;
        [self.tableView reloadData];
    }
}
#pragma mark==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourceArr.count==0) {//业主
        return 1;
    }
    return self.dataSourceArr.count;//家属（业主+家属总数据section格式）
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArr.count == 0) {//没有信息
        UserInfoRegistVCNotUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoRegistVCNotUserInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserInfoRegistVCNotUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserInfoRegistVCNotUserInfoTableViewCell_Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        if (indexPath.row==0) {//业主
            UserInfoRegistVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoRegistVCTableViewCell_Identifier];
            if (!cell) {
                cell = [[UserInfoRegistVCTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserInfoRegistVCTableViewCell_Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.model = self.dataSourceArr[indexPath.row];
            cell.delegate = self;
            return cell;
        }else{//家属
            UserInfoRegistVCOtherUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoRegistVCOtherUserInfoTableViewCell_Identifier];
            if (!cell) {
                cell = [[UserInfoRegistVCOtherUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserInfoRegistVCOtherUserInfoTableViewCell_Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            cell.model = self.dataSourceArr[indexPath.row];
            return cell;
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceArr.count==0) {
        return 120;//无
    }else {
        if (indexPath.row==0){
            return 150;//业主
        }else{
            return 80;//家属
        }
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {//业主首行
        [self pushToMainUserDetailVc];
    }
}
//删除 家属信息的删除UI
//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceArr.count <= 1) {//没有信息 + 只有业主 没有家属
        return NO;
    }else{
        return YES;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceArr.count <= 1) {//没有信息 + 只有业主 没有家属
        return UITableViewCellEditingStyleNone;
    }else{
        if (indexPath.row <= 0) {
            return UITableViewCellEditingStyleNone;
        }else{
            return  UITableViewCellEditingStyleDelete;
        }
    }
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 0) {
    }else{
        [self deletRelationWithCellRowNum:indexPath.row];
    }
        
   
   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceArr.count <= 1) {//没有信息 + 只有业主 没有家属
        return @"";
    }else{
        if (indexPath.row <= 0) {
            return @"";
        }else{
            return @"删除";
        }
    }
}

#pragma mark == 编辑
#pragma mark == editorBtn EditorMianUser
- (void)editorBtnActionWillPushVcToEditorMianUser{
    [self pushToMainUserDetailVc];
}
- (void)pushToMainUserDetailVc{
    if (self.dataSourceArr.count==0) {
        UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar *vc = [[UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar alloc]init];
        vc.communityId = self.nowCommunityId;
        vc.type = CertificationVc_Type_MainUser_ReEdit;//业主add 0==CertificationVc_Type_MainUser_Add
        [self.navigationController pushViewController:vc animated:YES];
        //业主Add 20210224 全没认证 改为-- （已经实名 没有房屋 ）
    }else{
//        //旧的有人脸headerView
//        UserCertificationViewController *cerVc = [[UserCertificationViewController alloc]init];
//        cerVc.type = CertificationVc_Type_MainUser_ReEdit;//业主ReEdit
//        cerVc.communityId = self.nowCommunityId;
//        [self.navigationController pushViewController:cerVc animated:YES];
        UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar *vc = [[UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar alloc]init];
        vc.type = CertificationVc_Type_MainUser_ReEdit;//业主ReEdit
        vc.communityId = self.nowCommunityId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark == UserInfoRegistVCOtherUserInfoTableViewCell_Delegate
- (void)editorBtnActionWillPushVcToEditorFamilyMemberInfoWithModel:(UserFamilyModel*)model{
    NSLog(@"ReEdit;//家属 %@",[model mj_keyValues]);
//    UserCertificationViewController *cerVc = [[UserCertificationViewController alloc]init];
    UserCertificationDetailOfFamileViewController *cerVc = [[UserCertificationDetailOfFamileViewController alloc]init];
    cerVc.type = CertificationVc_Type_OtherUser_ReEdit;//家属_ReEdit
    cerVc.houseId = self.nowHouseId;//当前所在门牌的id //当前所切换的小区的ID
    cerVc.communityId = self.nowCommunityId;
    cerVc.detailId = model.id; //当前家属信息cell id
    [self.navigationController pushViewController:cerVc animated:YES];
}
#pragma mark === footerBtnAction 添加
- (void)footerBtnAction:(UIButton *)sender{
//    UserCertificationViewController *cerVc = [[UserCertificationViewController alloc]init];
    UserCertificationDetailOfFamileViewController *cerVc = [[UserCertificationDetailOfFamileViewController alloc]init];
    cerVc.type = CertificationVc_Type_OtherUser_Add;//家属_Add
    cerVc.houseId = self.nowHouseId;//当前所在门牌的id  //当前所切换的小区的ID
    cerVc.communityId = self.nowCommunityId;
    [self.navigationController pushViewController:cerVc animated:YES];
}
#pragma mark ==
- (UIView *)footerBackview{
    if (!_footerBackview) {
        _footerBackview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
        [_footerBackview addSubview:self.footerBtn];
    }
    return _footerBackview;
}
- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerBtn.frame = CGRectMake(16, 10, Screen_W-32, 44);
        [_footerBtn setTitle:@"+ 添加家属" forState:UIControlStateNormal];
        [_footerBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _footerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_footerBtn setBackgroundColor:Y_RGBA(38, 114, 249, 1)];
            [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [_footerBtn setBackgroundColor:Y_RGBA(17, 41, 87, 1)];
            [_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        _footerBtn.layer.cornerRadius = 5;
        _footerBtn.layer.masksToBounds = YES;
    }
    return _footerBtn;
}
//
- (NSMutableArray *)chooseHouserDataSource{
    if (!_chooseHouserDataSource) {
        _chooseHouserDataSource = [NSMutableArray array];
    }
    return _chooseHouserDataSource;
}

@end
