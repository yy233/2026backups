//
//  UserCertificationChooseHouseDetailAddressVC.m
//  Community
//  选择房屋详细地址
//  Created by 余莹 on 2020/12/1.
//

#import "UserCertificationChooseHouseDetailAddressVC.h"
#import "UserCertificationChooseHouseDetailAddressTableViewCell.h"
#import "AddressSubChoosePopView.h"
#import "SubPoPViewWithFloor.h"
#import "SubPoPViewWithAddressDetail.h"


#define UserCertificationChooseHouseDetailAddressTableViewCell_Identifier @"UserCertificationChooseHouseDetailAddressTableViewCell"
#define Tag_textField 350

#define Notice_name_AddressAllInfoPost @"noticeActionWithDetailedAddressInfo"
#define Notice_Name_ChooseCity  @"ChooseCityNotice"
#define Notice_Name_ChooseCommunity @"ChooseCommunityNotice"
#define Notice_Name_ChooseBuild @"ChooseBuildNotice"
#define Notice_Name_ChooseUnit @"ChooseUnitNotice"

#define Tag_SubPopView_Floor  360 //单元
#define Tag_SubPopView_AddressDetail  361 //门牌 

#pragma mark ===========

//#define Type_GetStr_building     @"building"
//#define Type_GetStr_unit         @"unit"
//#define Type_GetStr_floor        @"floor"
//#define Type_GetStr_door         @"door"

#pragma mark ===========

#define Type_GetListKey_building     @"buildingList"
#define Type_GetListKey_unit         @"unitList"
#define Type_GetListKey_floor        @"floorList"
#define Type_GetListKeyr_door        @"doorList"

#pragma mark ===========
#define Type_GetStr_building_Chinese        @"楼栋"
#define Type_GetStr_unit_Chinese            @"单元"
#define Type_GetStr_floor_Chinese           @"楼层"
#define Type_GetStr_door_Chinese            @"门牌"
#define TIP_STR_Again_Choose      @"若需要重新选择\n请从小区开始重新选择"

#pragma mark ===========

@interface UserCertificationChooseHouseDetailAddressVC () <UITableViewDelegate,UITableViewDataSource,AddressChooseVcSubPopViewDelegate>
//
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) UIButton *footerBtn;
//cell文本部分 4种
@property (nonatomic,strong) NSMutableArray *cellTitleOneArr;
@property (nonatomic,strong) NSMutableArray *cellTitleTwoArr;
@property (nonatomic,strong) NSMutableArray *cellTitleThrArr;
@property (nonatomic,strong) NSMutableArray *cellTitleFourArr;

@property (nonatomic,strong) NSMutableArray *dataSourceArr;//主cell 各个model的文本name部分显示
@property (nonatomic,strong) NSMutableArray *floorPopViewDataSourceArr;//弹出视图的modelarr源 unit_model_arr
@property (nonatomic,strong) NSMutableArray *addressPopViewDataSourceArr;//弹出视图的modelarr源

//用于小区后续层级打包请求数据的参数
@property (nonatomic,assign) NSInteger nowCommunityHouseLeave;//默认0 弃用原数据属性 留 用于UI刷新
//小区后续层级 小区回调时设置 点击cell和赋值时使用
@property (nonatomic,assign) NSInteger buildCellRow;
@property (nonatomic,assign) NSInteger unitCellRow;
@property (nonatomic,assign) NSInteger floorCellRow;
@property (nonatomic,assign) NSInteger addressCellRow;

 //各个通知拿到的 model
@property (nonatomic,strong) CityChooseModel *cityModel;
@property (nonatomic,strong) CommunityModel *communityModel;
@property (nonatomic,strong) BuildingModel *buildModel;
@property (nonatomic,strong) UnitModel *unitModel;
@property (nonatomic,strong) FloorModel*floorModel;
@property (nonatomic,strong) AddressModel *addressModel;
 
@property (nonatomic,strong) SubPoPViewWithFloor *floorPopView;//单元用vc popview弃用
@property (nonatomic,strong) SubPoPViewWithAddressDetail *addressPopView;
//
//@property (nonatomic,strong) PublicChooseHouseMultipleLevelsModel *publicHouseModel;
@property (nonatomic,assign) NSInteger nowHangNum;
@property (nonatomic,strong) NSMutableArray *nowTitleArr;

@end

@implementation UserCertificationChooseHouseDetailAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择房屋详细地址";
    self.nowHangNum = self.nowTitleArr.count;
    [self initView];
    [self initNotice];
}
#pragma mark == view 界面转换

- (void)changeViewWithThisGetStr:(NSString *)getStr{
    NSLog(@"getStr --- %@",getStr);
    if ([getStr containsString:Type_GetListKey_building]) {
        [self.nowTitleArr addObject:@"楼栋"];
        self.nowHangNum = self.nowTitleArr.count;
        self.buildCellRow = self.nowHangNum-1;
    }
    if ([getStr containsString:Type_GetListKey_unit]) {
        [self.nowTitleArr addObject:@"单元"];
        self.nowHangNum = self.nowTitleArr.count;
        self.unitCellRow = self.nowHangNum-1;
    }
    if ([getStr containsString:Type_GetListKey_floor]) {
        [self.nowTitleArr addObject:@"楼层"];
        self.nowHangNum = self.nowTitleArr.count;
        self.floorCellRow = self.nowHangNum-1;
    }
    if ([getStr containsString:Type_GetListKeyr_door]) {
        [self.nowTitleArr addObject:@"门牌"];
        self.nowHangNum = self.nowTitleArr.count;
        self.addressCellRow = self.nowHangNum-1;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)changeViewType:(NSString *)typeStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reSetUI];
        [self.tableView reloadData];
    });
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChooseCity, chooseCityNotice:) //城市
    Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChooseCommunity, chooseCommunityNotice:)//社区
    Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChooseBuild, ChooseBuildNotice:)//楼栋
    Y_NSNotificationCenter_Creat_NameAction(Notice_Name_ChooseUnit, ChooseUnitNotice:)//单元

}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChooseCity);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChooseCommunity);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChooseBuild);
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_Name_ChooseUnit);

}
#pragma mark == notice 回调 —————————— @"城市",@"小区",@"楼栋"
#pragma mark == 得到某城市
- (void)chooseCityNotice:(NSNotification *)notice{
    [self cleanCityLast];
    NSDictionary *userInfo  = notice.userInfo;
    self.cityModel = [userInfo objectForKey:@"userInfo"];
    self.dataSourceArr[0] = self.cityModel.name; //@"城市";
    self.nowTitleArr = [NSMutableArray arrayWithObjects:@"城市",@"小区",nil];
    self.nowHangNum = self.nowTitleArr.count;
    [self.tableView reloadData];
}
#pragma mark == 得到某小区
- (void)chooseCommunityNotice:(NSNotification *)notice{
    [self cleanCommountLast];
    NSDictionary *userInfo  = notice.userInfo;
    self.communityModel = [userInfo objectForKey:@"userInfo"];
    self.dataSourceArr[1] = self.communityModel.name; //@"社区";
    self.nowTitleArr = [NSMutableArray arrayWithObjects:@"城市",@"小区",nil];
     self.nowHangNum = self.nowTitleArr.count;
    
    //小区的下一级数据
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.communityModel.ID) forKey:@"id"];
    [parms setValue:@(2) forKey:@"queryType"];//小区下级别只用2
    [self initCommunityNextListData:parms];
    [self.tableView reloadData];
}
#pragma mark == 得到某楼栋
- (void)ChooseBuildNotice:(NSNotification *)notice{
    NSDictionary *userInfo  = notice.userInfo;
    self.buildModel = [userInfo objectForKey:@"userInfo"];
    self.dataSourceArr[self.buildCellRow] = self.buildModel.building; //楼栋
    
    //得到build数据 下一级数据parm
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.buildModel.id) forKey:@"id"];
    [parms setValue:@(queryType_Num_willGetUnityNextList) forKey:@"queryType"];//小区-楼栋-单元 求单元list用3
//    [parms setValue:@(queryType_Num_willGetBuildNextFloorList) forKey:@"queryType"];//小区-楼栋-楼层 求楼层3list 换url
    
    [self initBuildNextListData:parms];
    [self.tableView reloadData];
}
- (void)ChooseUnitNotice:(NSNotification *)notice{
    NSDictionary *userInfo  = notice.userInfo;
    self.unitModel = [userInfo objectForKey:@"userInfo"];
    self.dataSourceArr[self.unitCellRow] = self.unitModel.unit; //单元
    
    
    //得到unit数据 下一级数据parm
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    if (self.nowTitleArr.count==4 && [self.nowTitleArr[3] isEqualToString:@"单元"]) {//最长级别 city-comm- b -u- 下级求f
        [parms setValue:@(self.unitModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextUnityNextFloorList) forKey:@"queryType"];
        [self initUnitLastListData:parms];
        [self.tableView reloadData];
    }else if(self.nowTitleArr.count==3 && [self.nowTitleArr[2] isEqualToString:@"单元"]){//city-com-u 下级求f
        [parms setValue:@(self.unitModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextUnityNextFloorList) forKey:@"queryType"];
        [self initUnitLastListData:parms];
        [self.tableView reloadData];
    }else{
    }
 

}
#pragma mark===== pop view 点击 回调 —————————— @"楼层",@"门牌"
- (void)popViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    if (self.floorPopView.tag == tag) {
        self.floorModel = self.floorPopViewDataSourceArr[indexPath.row];
//        [self changeDataOfRemoveOtherSaveDataWithThisRowNum:self.floorCellRow];
        self.dataSourceArr[self.floorCellRow] = self.floorModel.floor;
        //
        [self changeViewWithThisGetStr:Type_GetListKeyr_door];//增门牌cell
        [self.tableView reloadData];
    }
     
    if (self.addressPopView.tag == tag) {
        self.addressModel = self.addressPopViewDataSourceArr[indexPath.row];
//        [self changeDataOfRemoveOtherSaveDataWithThisRowNum:self.addressCellRow];
        self.dataSourceArr[self.addressCellRow] = [TextShowWithModelStr textShowWithModelStr: self.addressModel.door];
        self.saveChooseEndUserInfoModelUseLateVcAddHouse = [NSDictionary dictionaryWithObjects:@[self.communityModel,self.addressModel] forKeys:@[@"C",@"H"]];//0819新增房子的新选择vc所用
        [self.tableView reloadData];
    }
}
 
#pragma mark ====  清空得到的 index 下级别的数据 === 仅仅是展示所用数据
- (void)cleanCityLast{
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.communityModel = nil;
    self.buildModel = nil;
    self.unitModel = nil;
    self.floorModel = nil;
    self.addressModel = nil;
}
- (void)cleanCommountLast{
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.buildModel = nil;
    self.unitModel = nil;
    self.floorModel = nil;
    self.addressModel = nil;
}

#pragma mark =================================== 提交全部信息
- (void)footerBtnAction:(UIButton *)sender{//提交全部信息
    if (isNil(self.addressModel)) {
        Y_SVP_SHOW_ERR_MES(@"数据不完整!")
        return;
    }
    NSMutableDictionary *userInfodic = [NSMutableDictionary dictionary];
//    NSMutableArray *modeArr = [NSMutableArray arrayWithObjects:self.cityModel,self.communityModel,self.buildModel,self.unitModel,self.floorModel,self.addressModel, nil];
    NSMutableArray *modeArr = [NSMutableArray arrayWithObjects:self.cityModel,self.communityModel,self.addressModel, nil];
    NSLog(@"%@",modeArr);
    [userInfodic setValue:modeArr forKey:@"userInfo"];//当前使用（最后一个门牌号ID 进行数据处理），（其他文本段进行展示）
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(Notice_name_AddressAllInfoPost, userInfodic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark == UI
- (void)initView{
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.backV];
    [self.backV addSubview:self.tableView];
    [self.view addSubview:self.footerBtn];
    [self setUI];
}
- (void)setUI{
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerLabel.superview.mas_top).offset(0);//KNavBarHeight
        make.left.equalTo(_headerLabel.superview.mas_left);
        make.right.equalTo(_headerLabel.superview.mas_right);
        make.height.offset(35);
    }];
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerLabel.mas_bottom).offset(25);
        make.left.equalTo(_headerLabel.superview.mas_left).offset(16);
        make.right.equalTo(_headerLabel.superview.mas_right).offset(-16);
        make.height.offset(299);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    [_footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerBtn.superview.mas_bottom).offset(-40);
        make.left.equalTo(_headerLabel.superview.mas_left).offset(16);
        make.right.equalTo(_headerLabel.superview.mas_right).offset(-16);
        make.height.offset(44);
    }];
}
- (void)reSetUI{
    float tableViewH = (self.nowTitleArr.count) * 50;
    [_backV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerLabel.mas_bottom).offset(25);
        make.left.equalTo(_headerLabel.superview.mas_left).offset(16);
        make.right.equalTo(_headerLabel.superview.mas_right).offset(-16);
        make.height.offset(tableViewH);
    }];
}
#pragma mark ====================== tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 

    return self.nowTitleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCertificationChooseHouseDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationChooseHouseDetailAddressTableViewCell_Identifier];
    if (!cell) {
        cell = [[UserCertificationChooseHouseDetailAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserCertificationChooseHouseDetailAddressTableViewCell_Identifier];
    }
    cell.textField.tag = Tag_textField + indexPath.row;
    cell.titleL.text = [NSString stringWithFormat:@"%@",self.nowTitleArr[indexPath.row]];
    if (indexPath.row>=self.nowTitleArr.count) {
        DLog(@"问题问题问题问题问题问题问题问题问题");
    }
    cell.textField.text = [self strOfTextFieldWithRowNum:indexPath.row];//
   
    return cell;
}
- (NSString *)strOfTextFieldWithRowNum:(NSInteger)rowNum{
    return  self.dataSourceArr[rowNum];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        switch (indexPath.row) {
            case 0://城市
            {
                [self chooseCityCell];
                return;
            }
                break;
            case 1://小区
            {
                [self chooseCommunityCell];
                return;
            }
                break;
    
            default:
            {
                NSString *rowTitleStr = [NSString stringWithFormat:@"%@",self.nowTitleArr[indexPath.row]];
                if ([rowTitleStr isEqualToString:Type_GetStr_building_Chinese]) {
                    [self chooseBuildCell];
                }
                if ([rowTitleStr isEqualToString:Type_GetStr_unit_Chinese]) {
                    [self chooseUnitCell];
                }
                if ([rowTitleStr isEqualToString:Type_GetStr_floor_Chinese]) {
                    [self choosFloorCell];
                }
                if ([rowTitleStr isEqualToString:Type_GetStr_door_Chinese]) {
                    [self choosAddressCell];
                }
            }
                break;
                
        }
}

#pragma mark === @"城市",@"小区",@"楼栋",@"单元",@"门牌" ——————————---------------------选择Action
#pragma mark == 城市
- (void)chooseCityCell{
    CityChooseTableViewController *cityChooseVc = [[CityChooseTableViewController alloc]init];
    cityChooseVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityChooseVc animated:YES];
}
#pragma mark == 小区
- (void)chooseCommunityCell{
    if (isNil(self.dataSourceArr.firstObject) || isNil(self.cityModel)) {
        Y_SVP_SHOW_ERR_MES(@"缺少城市内容");
        return;
    }else{
        CommunityChooseTableViewController *communityChooseVc = [[CommunityChooseTableViewController alloc]init];
        communityChooseVc.cityId = self.cityModel.id;
        communityChooseVc.cityModel = self.cityModel;
//        communityChooseVc.comunityMode = self.communityModel;
        [self.navigationController pushViewController:communityChooseVc animated:YES];
    }
    
}
#pragma mark == 楼栋
- (void)chooseBuildCell{
    DLog(@"chooseBuildCell");

    if (![self.nowTitleArr.lastObject isEqualToString:@"楼栋"]) {
        Y_SVP_SHOW_INFO_MES(TIP_STR_Again_Choose);
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.nowTitleArr.count==3) {//小区下级得到楼栋
        [parms setValue:@(self.communityModel.ID) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetCommunityNextList) forKey:@"queryType"]; //求小区的下一级用2
        BuildingNumChooseTableViewController *buildChooseVc = [[BuildingNumChooseTableViewController alloc]init];
        buildChooseVc.baseParms = parms;
        [self.navigationController pushViewController:buildChooseVc animated:YES];
    }else{
        //重新选择 且中间开始选
        Y_SVP_SHOW_INFO_MES(TIP_STR_Again_Choose);
        return;
    }
 
}
#pragma mark == 单元
- (void)chooseUnitCell{
    DLog(@"chooseUnitCell");
    if (![self.nowTitleArr.lastObject isEqualToString:@"单元"]) {
        Y_SVP_SHOW_INFO_MES(TIP_STR_Again_Choose);
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.nowTitleArr.count==3) {//小区下级得到单元
        [parms setValue:@(self.communityModel.ID) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetCommunityNextList) forKey:@"queryType"];
    }else if(self.nowTitleArr.count==4){//楼栋下级得到单元
        [parms setValue:@(self.buildModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextList) forKey:@"queryType"];
    }else{
        //重新选择 且中间开始选
        Y_SVP_SHOW_INFO_MES(TIP_STR_Again_Choose);
        return;
    }
    UnitChooseTableViewController *unitChooseVc = [[UnitChooseTableViewController alloc]init];
    unitChooseVc.baseParms = parms;
    [self.navigationController pushViewController:unitChooseVc animated:YES];
}
    

 
#pragma mark == 楼层
- (void)choosFloorCell{

    if (![self.nowTitleArr.lastObject isEqualToString:@"楼层"]) {
        Y_SVP_SHOW_INFO_MES(TIP_STR_Again_Choose);
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.nowTitleArr.count==5) {//最长级别city-comm- b-u-f
        [parms setValue:@(self.unitModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextUnityNextFloorList) forKey:@"queryType"];
    }else if(self.nowTitleArr.count==4 && [self.nowTitleArr[2] isEqualToString:@"楼栋"]){//city-com-b-f
        [parms setValue:@(self.buildModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextUnityNextFloorList) forKey:@"queryType"];
    }else if(self.nowTitleArr.count==4 && [self.nowTitleArr[2] isEqualToString:@"单元"]){//city-com-u-f
        [parms setValue:@(self.unitModel.id) forKey:@"id"];
        [parms setValue:@(queryType_Num_willGetBuildNextUnityNextFloorList) forKey:@"queryType"];
    }else{
        Y_SVP_SHOW_INFO_MES(@"请从小区重新选择");
        return;
    }
    self.floorPopView = [[SubPoPViewWithFloor alloc]init];
    self.floorPopView.tag = Tag_SubPopView_Floor;
    self.floorPopView.delegate = self;
    [self initFloorData:parms];
 
}
#pragma mark == 门牌
- (void)choosAddressCell{
 
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.buildModel.building.length>0) {
        [parms setValue:@(self.buildModel.id) forKey:@"id"];
    }
    if (self.unitModel.unit.length>0) {
        [parms setValue:@(self.unitModel.id) forKey:@"id"];
    }
    [parms setValue:self.floorModel.floor forKey:@"floor"];//楼层名
    
    self.addressPopView = [[SubPoPViewWithAddressDetail alloc]init];
    self.addressPopView.tag = Tag_SubPopView_AddressDetail;
    self.addressPopView.delegate = self;
    [self initAddressData:parms];
   
}
#pragma mark == ---------------------------------vc跳转前 数据请求部分 用于判断下一级数据 并处理当前UI----------------------
#pragma mark ==  小区下一级别
- (void)initCommunityNextListData:(NSMutableDictionary *)parms{
    Y_SVP_SHOW_MES_5Delay_Loading
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *resArr = [NSMutableArray arrayWithArray:Y_ResponsObject_dataArr];
                    if (resArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        return;
                    }
                    //单个类型 暂无本NSArray类型
                }
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    if ([resDic allKeys].count == 0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        return;
                    }else{
                          NSArray *communityLastKeyArr =  [resDic allKeys];
                            if (communityLastKeyArr.count==0) {
                                Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                            }else if (communityLastKeyArr.count==1) {
                                //下级数据为
                                [self changeViewWithThisGetStr:communityLastKeyArr.firstObject];
                              
                            }else{
                                NSString *msg = @"";
                                for (int i = 0; i <communityLastKeyArr.count; i ++) {
                                  msg = [msg stringByAppendingString:[NSString stringWithString:communityLastKeyArr[i]]];
                                }
//                                Y_SVP_SHOW_INFO_MES(msg);
                                //pop 多选框 决定当前UI 和未来的跳转
                                [self showAlertWithArr:communityLastKeyArr];
                            }
                        }
                    
                }
                
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ==  楼栋下一级别
- (void)initBuildNextListData:(NSMutableDictionary *)parms{
    Y_SVP_SHOW_MES_5Delay_Loading
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *resArr = [NSMutableArray arrayWithArray:Y_ResponsObject_dataArr];
                    if (resArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        return;
                    }
                    //单个类型
                    //
                }
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    if ([resDic allKeys].count == 0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        return;
                    }else{
//                        [resDic allKeys].firstObject
//                        [resDic allKeys].lastObject
                      NSArray *buildLastKeyArr =  [resDic allKeys];
                        if (buildLastKeyArr.count==0) {
                            Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        }else if (buildLastKeyArr.count==1) {
                            //下级数据为
 
                            [self changeViewWithThisGetStr:buildLastKeyArr.firstObject];
                        }else{
                            NSString *msg = @"";
                            for (int i = 0; i <buildLastKeyArr.count; i ++) {
                                [msg stringByAppendingString:buildLastKeyArr[i]];
                            }
                            [self showAlertWithArr:buildLastKeyArr];
                            //pop 多选框 决定当前UI 和未来的跳转
//                            Y_SVP_SHOW_INFO_MES(msg);
                        }
                    }
                    
                }
                
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)initUnitLastListData:(NSMutableDictionary *)parms{
    Y_SVP_SHOW_MES_5Delay_Loading
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *resArr = [NSMutableArray arrayWithArray:Y_ResponsObject_dataArr];
                    if (resArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                        return;
                    }
                    //单个类型
                    //
                }
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
 
                    NSArray *unitLastKeyArr =  [resDic allKeys];
                    if (unitLastKeyArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无下级数据");
                    }else if (unitLastKeyArr.count==1) {
                        //下级数据为
                        //                            Y_SVP_SHOW_INFO_MES(buildLastKeyArr.firstObject);
                        [self changeViewWithThisGetStr:unitLastKeyArr.firstObject];
                    }else{
                        NSString *msg = @"";
                        for (int i = 0; i <unitLastKeyArr.count; i ++) {
                            [msg stringByAppendingString:unitLastKeyArr[i]];
                        }
                        [self showAlertWithArr:unitLastKeyArr];
                        //pop 多选框 决定当前UI 和未来的跳转
                        //                            Y_SVP_SHOW_INFO_MES(msg);
                    }
                }
                
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark == pop View 数据请求部分
#pragma mark == 楼层 list
- (void)initFloorData:(NSMutableDictionary*)parms{
    Y_SVP_SHOW_MES_5Delay_Loading
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    NSArray *keyArr =  [resDic allKeys];
                    if (keyArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无数据");
                        return;
                    }else{
                        for (int i = 0; i <keyArr.count; i ++) {
                            NSString *keyStr = [NSString stringWithString:keyArr[i]];
                            NSLog(@"------keyArr ------%@",keyArr[i]);
                            if ([keyStr isEqualToString:@"floorList"]) {
                                NSMutableArray *doorArr = [NSMutableArray arrayWithArray:resDic[keyStr]];
                                self.floorPopViewDataSourceArr = [NSMutableArray arrayWithArray:[FloorModel mj_objectArrayWithKeyValuesArray:doorArr]];
                                if (self.floorPopViewDataSourceArr.count==0) {
                                    Y_SVP_SHOW_ERR_MES(@"暂无楼栋");
                                    return;
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.tableView reloadData];
                                    [self.floorPopView showInView:self.view thePopViewWithArray:self.floorPopViewDataSourceArr];
                                });
                                
                            }
                        }
                        
                    }
               
                }else{
                    Y_SVP_SHOW_ERR_MES(@"暂无数据");
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark == 门牌
- (void)initAddressData:(NSMutableDictionary*)parms{
    Y_SVP_SHOW_MES_5Delay_Loading
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_MAIN_CHOOSE_COMMUNITY_DoorList withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
            
                if ([[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *resDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    NSArray *keyArr =  [resDic allKeys];
                    if (keyArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无数据");
                        return;
                    }else{
                        for (int i = 0; i <keyArr.count; i ++) {
                            NSString *keyStr = [NSString stringWithString:keyArr[i]];
                            if ([keyStr isEqualToString:@"doorList"]) {
                                NSMutableArray *doorArr = [NSMutableArray arrayWithArray:resDic[keyStr]];
                                self.addressPopViewDataSourceArr = [NSMutableArray arrayWithArray:[AddressModel mj_objectArrayWithKeyValuesArray:doorArr]];
                                if (self.addressPopViewDataSourceArr.count==0) {
                                    Y_SVP_SHOW_ERR_MES(@"暂无门牌数据");
                                    return;
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.tableView reloadData];
                                    [self.addressPopView showInView:self.view thePopViewWithArray:self.addressPopViewDataSourceArr];
                                });
                                
                            }
                        }
                    }
                }else{
                    self.addressPopViewDataSourceArr  = [NSMutableArray arrayWithArray:[AddressModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                    if (self.addressPopViewDataSourceArr.count==0) {
                        Y_SVP_SHOW_ERR_MES(@"暂无数据");
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [self.addressPopView showInView:self.view thePopViewWithArray:self.addressPopViewDataSourceArr];
                        });
                    }
                  
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ====
#pragma mark ====
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _backV.layer.cornerRadius = 5;
        _backV.layer.masksToBounds = YES;
    }
    return _backV;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _tableView.separatorColor = [ThemeManager shareManager].mainContentLineColor;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.text = @"温馨提示：选择所属单元获取更多权限，平台保证保密您的个人信息";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _headerLabel.font = [UIFont systemFontOfSize:11];
        _headerLabel.backgroundColor = Y_RGBA(15, 100, 253, 0.3);
    }
    return _headerLabel;
}
- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerBtn setTitle:@"确认" forState:UIControlStateNormal];
        _footerBtn.layer.cornerRadius = 22;
        _footerBtn.layer.masksToBounds = YES;
        [_footerBtn setBackgroundColor:LoginViewBtnGradientColor(Screen_W-32, 44)];
        [_footerBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}

- (NSMutableArray *)cellTitleOneArr{
    if (!_cellTitleOneArr) {
        _cellTitleOneArr = [[NSMutableArray alloc]initWithObjects:@"城市",@"小区",@"楼栋",@"单元",@"楼层",@"门牌",nil];
    }
    return _cellTitleOneArr;
}
- (NSMutableArray *)cellTitleTwoArr{
    if (!_cellTitleTwoArr) {
        _cellTitleTwoArr = [[NSMutableArray alloc]initWithObjects:@"城市",@"小区",@"单元",@"楼栋",@"楼层",@"门牌",nil];
    }
    return _cellTitleTwoArr;
}
- (NSMutableArray *)cellTitleThrArr{
    if (!_cellTitleThrArr) {
        _cellTitleThrArr = [[NSMutableArray alloc]initWithObjects:@"城市",@"小区",@"楼栋",@"楼层",@"门牌",nil];
    }
    return _cellTitleThrArr;
}
- (NSMutableArray *)cellTitleFourArr{
    if (!_cellTitleFourArr) {
        _cellTitleFourArr = [[NSMutableArray alloc]initWithObjects:@"城市",@"小区",@"单元",@"楼层",@"门牌",nil];
    }
    return _cellTitleFourArr;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)floorPopViewDataSourceArr{
    if (!_floorPopViewDataSourceArr) {
        _floorPopViewDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _floorPopViewDataSourceArr;
}
- (NSMutableArray *)addressPopViewDataSourceArr{
    if (!_addressPopViewDataSourceArr) {
        _addressPopViewDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _addressPopViewDataSourceArr;
}

#pragma mark ===
- (NSInteger)nowCommunityHouseLeave{ //弃用
    if (!_nowCommunityHouseLeave) {
        _nowCommunityHouseLeave = 0;
    }
    return _nowCommunityHouseLeave;
}
//楼栋
- (NSInteger)buildCellRow{
    if (!_buildCellRow) {
        _buildCellRow = 2;
    }
    return _buildCellRow;
}
//单元
- (NSInteger)unitCellRow{
    if (!_unitCellRow) {
        _unitCellRow = 3;
    }
    return _unitCellRow;
}
//楼层
- (NSInteger)floorCellRow{
    if (!_floorCellRow) {
        _floorCellRow = 4;
    }
    return _floorCellRow;
}
//门牌
- (NSInteger)addressCellRow{
    if (!_addressCellRow) {
        _addressCellRow = 5;
    }
    return _addressCellRow;
}

#pragma mark ==
- (NSMutableArray *)nowTitleArr{
    if (!_nowTitleArr) {
        _nowTitleArr = [NSMutableArray arrayWithObjects:@"城市",@"小区",nil];
    }
    return _nowTitleArr;
}

#pragma mark ==

#pragma mark == show alert
- (void)showAlertWithArr:(NSArray *)titleArr{
    NSMutableArray *arrOfChineseTitleArr = [[NSMutableArray alloc]init];
    for (int  i = 0 ; i < titleArr.count ; i++) {
        if ([[NSString stringWithString:titleArr[i]] isEqualToString:Type_GetListKey_building]) {
            [arrOfChineseTitleArr addObject:Type_GetStr_building_Chinese];
        }
        if ([[NSString stringWithString:titleArr[i]] isEqualToString:Type_GetListKey_unit]) {
            [arrOfChineseTitleArr addObject:Type_GetStr_unit_Chinese];
        }
        if ([[NSString stringWithString:titleArr[i]] isEqualToString:Type_GetListKey_floor]) {
            [arrOfChineseTitleArr addObject:Type_GetStr_floor_Chinese];
        }
    }
    
    UIAlertController *alertCotroller = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionOne = [UIAlertAction actionWithTitle:arrOfChineseTitleArr.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
        [self changeViewWithThisGetStr:titleArr.firstObject];
        [alertCotroller dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *alertActionTwo = [UIAlertAction actionWithTitle:arrOfChineseTitleArr.lastObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
        [self changeViewWithThisGetStr:titleArr.lastObject];
        [alertCotroller dismissViewControllerAnimated:YES completion:nil];
    }];
   
    [alertCotroller addAction:alertActionOne];
    [alertCotroller addAction:alertActionTwo];
    alertCotroller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertCotroller animated:YES completion:^{
    }];
}

//- (void)changeDataOfRemoveOtherSaveDataWithThisRowNum:(NSInteger)index{
//    if (index==0) {//得到城市数据
//        //清空 小区 楼栋 单元 门牌
//        self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
//        self.communityModel = nil;
//        self.buildModel = nil;
//        self.unitModel = nil;
//        self.floorModel = nil;
//        self.addressModel = nil;
//
//    }
//    if (index==1) {//得到小区数据
//        self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,@"",@"",@"",@"",@"",@"",@"",@"", nil];
//        self.buildModel = nil;
//        self.unitModel = nil;
//        self.floorModel = nil;
//        self.addressModel = nil;
//    }
//    //
//    if (index==self.buildCellRow) {//得到楼栋数据
//        if (self.viewType==Type_Community_Structure_houseLevelMode_One ||self.viewType==Type_Community_Structure_houseLevelMode_Thr) {//小区后顺位1
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,@"",@"",@"",@"",@"",@"",@"", nil];
//            self.unitModel = nil;
//            self.floorModel = nil;
//            self.addressModel = nil;
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_Two){//单元楼栋型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.unitModel.unit,@"",@"",@"",@"",@"",@"", nil];
//            self.floorModel = nil;
//            self.addressModel = nil;
//        }else{
//        }
//
//    }
//    if (index==self.unitCellRow) {//得到单元数据
//        if (self.viewType==Type_Community_Structure_houseLevelMode_Two ||self.viewType==Type_Community_Structure_houseLevelMode_Four) {//小区后顺位1
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,@"",@"",@"",@"",@"",@"",@"", nil];
//            self.buildModel = nil;
//            self.floorModel = nil;
//            self.addressModel = nil;
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_One){//楼栋单元型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.buildModel.building,@"",@"",@"",@"",@"",@"", nil];
//            self.floorModel = nil;
//            self.addressModel = nil;
//        }else{
//        }
//
//    }
//
//    //
//    if (index==self.floorCellRow) {//得到楼层数据
//        if (self.viewType==Type_Community_Structure_houseLevelMode_One) {//楼栋单元型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.buildModel.building,self.unitModel.unit,@"",@"",@"",@"",@"", nil];
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_Two){//单元楼栋型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.unitModel.unit,self.buildModel.building,@"",@"",@"",@"",@"", nil];
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_Thr){//楼栋型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.buildModel.building,@"",@"",@"",@"",@"", nil];
//        }else{//单元型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.unitModel.unit,@"",@"",@"",@"",@"", nil];
//        }
//        self.addressModel = nil;
//    }
//    if (index==self.addressCellRow) {//得到门牌数据
//        if (self.viewType==Type_Community_Structure_houseLevelMode_One) {//楼栋单元型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.buildModel.building,self.unitModel.unit,self.floorModel.floor,@"",@"",@"",@"", nil];
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_Two){//单元楼栋型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.unitModel.unit,self.buildModel.building,self.floorModel.floor,@"",@"",@"",@"", nil];
//        }else if(self.viewType==Type_Community_Structure_houseLevelMode_Thr){//楼栋型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.buildModel.building,self.floorModel.floor,@"",@"",@"",@"", nil];
//        }else{//单元型
//            self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:self.cityModel.name,self.communityModel.name,self.unitModel.unit,self.floorModel.floor,@"",@"",@"",@"", nil];
//        }
//    }
//    NSLog(@"dataSourceArrtextField== %@",self.dataSourceArr);
//}

@end
