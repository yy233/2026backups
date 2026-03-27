//
//  ZhengZuIssueHouseVc.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "HouseAllTypeBaseIssueVc.h"
#import "IssueAddPhotoBaseTableViewController.h"
#import "IssueAddPhotoHouseTypeTableViewController.h"

#import "PopViewHouePickerViewChooseHouseInfo.h"
//cell
#import "IssueBaseTextFieldAndCanInputTableViewCell.h"
#import "IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.h"
#import "issueBaseHouseTypeSubChooseBtnTableViewCell.h"
#import "IssueHouseThreeGroupTextInfoShowTableViewCell.h"
#import "IssueBaseTwoTextLabelShowTableViewCell.h"
//
#define IssueBaseTextFieldAndCanInputTableViewCell_Identifier                      @"IssueBaseTextFieldAndCanInputTableViewCell"
#define IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier         @"IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell"
#define issueBaseHouseTypeSubChooseBtnTableViewCell_Identifier                     @"issueBaseHouseTypeSubChooseBtnTableViewCell"
#define IssueHouseThreeGroupTextInfoShowTableViewCell_Identifier                   @"IssueHouseThreeGroupTextInfoShowTableViewCell"
#define IssueBaseTwoTextLabelShowTableViewCell_Identifier                          @"IssueBaseTwoTextLabelShowTableViewCell"
//pop
#import "IssuLastAddressCellSubBasePopView.h"
#import "IssHouseOfUserCommunityAndAddressViewModel.h"



#define Tag_textField       250
#define Tag_textFieldTopBtn 300
//#define RowNum_Choose_city   0
//#define RowNum_Choose_community 1
//#define RowNum_Choose_address   2
//#define RowNum_Text_Area        3
 
#define RowNum_Choose_community 0
#define RowNum_Choose_address   1
#define RowNum_Text_Area        2
#define RowNum_Text_BedroomType 3 //卧室类型
@interface HouseAllTypeBaseIssueVc () <PopViewHouePickerViewChooseHouseInfoDelegate,IssueChooseCityBaseVcDelegate,IssueChooseCommunityBaseVcDelegate,IssuLastAddressCellSubBasePopViewDelegate,UITextFieldDelegate,PopViewBuniessShopChooseShopPublishTypesDelegate>

@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) IssuLastAddressCellSubBasePopView *popViewChooseHouseAddressDetailList;//选择房屋地址相关数据
@property (nonatomic,strong) PopViewHouePickerViewChooseHouseInfo *popViewChooseHouseInfo;//朝向等pop

@property (nonatomic,strong) PopViewBuniessShopChooseShopPublishTypes *popViewChooseBedRoomType;//卧室类型 (1016)//卧室类型同商铺的行业类型选择器一样的基础popV
@property (nonatomic,strong) NSMutableArray *saveHouseInfoBedRoomTypeStrArr;///卧室类型纯文本数据组
@property (nonatomic,strong) NSString *nowChooseBedroomTypeStr;

@property (nonatomic,strong) NSMutableArray *saveHouseInfoStrArr; // 房屋类型 朝向 楼层 （文本arr）
@property (nonatomic,strong) NSMutableArray *saveHouseInfoCodeArr; //房屋类型  朝向 Code 楼层code暂不使用设置为0;
@property (nonatomic,strong) NSMutableArray *saveHouseInfoRowNumArr;// 房屋类型 朝向 楼层 （滚轮row的存储arr 用于修改）
@property (nonatomic,strong) CityChooseModel *cityModel;
@property (nonatomic,strong) CommunityModel *communityModel;
@property (nonatomic,strong) AddressModel *addressModel;
@end

@implementation HouseAllTypeBaseIssueVc

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == IssueHouse_Type_ZhengZu) {
        self.title = @"整租";
//        self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在城市",@"所在小区",@"具体地址",@"房屋面积", nil];//
//        self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];//
        self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在小区",@"具体地址",@"房屋面积", nil];//
        self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];//
    }else if (self.type == IssueHouse_Type_DanJian){
        self.title = @"单间";
//        self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在城市",@"所在小区",@"具体地址",@"卧室面积",@"卧室类型", nil];//
//        self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"其他", nil];//
        self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在小区",@"具体地址",@"卧室面积",@"卧室类型", nil];//
        self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"其他", nil];//
    }else if(self.type == IssueHouse_Type_HeZu){
        self.title = @"合租";
//        self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在城市",@"所在小区",@"具体地址",@"房屋面积",@"卧室类型", nil];//
//        self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"其他", nil];//
                self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在小区",@"具体地址",@"房屋面积",@"卧室类型", nil];//
                self.dataSourceConnectArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"其他", nil];//
    }
    [self initView];
    [self addNotice];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
}
- (void)initView{
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
//    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;//深色模式下本分割线色太明显了 不使用
}
- (void)initData{
    [self.tableView reloadData];
    if (self.editUseRentHouseId != 0) {
//        self.editUseModel//add用的model 和 详情页展示用的model不一样；
        self.cityModel =  [[CityChooseModel alloc]init];
//        self.cityModel.id = self.editUseModel.mo
    }
    
}
//_______
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(HousePhotoAddEnd_Notice_Name)
}
- (void)addNotice{
    Y_NSNotificationCenter_Creat_NameAction(HousePhotoAddEnd_Notice_Name, getPhotoNoticeUserInfo:);
}

#pragma mark == notice photo
- (void)getPhotoNoticeUserInfo:(NSNotification *)notice{
    NSDictionary *phoneDic = notice.userInfo;;
    [self savePhonesInfo:phoneDic];
}
//处理商铺图片数据
- (void)savePhonesInfo:(NSDictionary*)phoneDic{
    //    @"IMG"@"URL"
    //url
    self.photosAllUrlArr = [NSMutableArray arrayWithArray:[phoneDic objectForKey:@"URL"]];
    //img
//    self.photosImgSaveDic =
    NSMutableArray *allImgArr = [NSMutableArray arrayWithArray:[phoneDic objectForKey:@"IMG"]];
    self.photosAllImgArr = [NSMutableArray arrayWithArray:allImgArr];
    if (allImgArr.count>0) {
        self.headerView.centerBtn.hidden = YES;//隐藏中心的上传按钮
        self.headerView.cycleScrollView.localizationImageNamesGroup = allImgArr;//img
        self.headerView.cycleScrollView.hidden = NO;
    }else{
        self.headerView.centerBtn.hidden = NO;//中心的上传按钮
        self.headerView.cycleScrollView.imageURLStringsGroup = @[];
        self.headerView.cycleScrollView.hidden = YES;
    }
}
#pragma mark == 房屋照片
- (void)addPhotosAction{
    DLog(@"照片页");
    IssueAddPhotoHouseTypeTableViewController *vc = [[IssueAddPhotoHouseTypeTableViewController alloc]init];//照片
    [self pushVc:vc];
}
 
#pragma mark ==   ********* 下一步 *********
- (void)footerNextBtnAction:(UIButton *)sender{
    //test
//    //整租 单间 合租
//    switch (self.type) {
//        case IssueHouse_Type_ZhengZu:
//        {
//            HouseZhengZuIssueOkVc *vc=  [[HouseZhengZuIssueOkVc alloc]init];
//            IssueHouseAddNewModel *model = [[IssueHouseAddNewModel alloc]init];
//            vc.type  = self.type;
//            vc.houseAllDataModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case IssueHouse_Type_DanJian:
//        {
//            HouseDanJianIssueOkVc *vc=  [[HouseDanJianIssueOkVc alloc]init];
//            IssueHouseAddNewModel *model = [[IssueHouseAddNewModel alloc]init];
//            vc.type  = self.type;
//            vc.houseAllDataModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case IssueHouse_Type_HeZu:
//        {
//            HouseHeZuIssueOkVc *vc=  [[HouseHeZuIssueOkVc alloc]init];
//            vc.type  = self.type;
//            [self pushVc:vc];
//        }
//            break;
//        default:
//            break;
//    }
//    return;
//test____end
// 1015去掉城市数据
//    if (isNil(self.cityModel)) {
//        Y_SVP_SHOW_ERR_MES(@"城市数据 未选择");
//        return;
//    }
    if (isNil(self.communityModel)) {
        Y_SVP_SHOW_ERR_MES(@"小区数据 未选择");
        return;
    }
    if (isNil(self.addressModel)) {
        Y_SVP_SHOW_ERR_MES(@"具体地址 未选择");
    }
    DLog(@"--footerNextBtnAction--%lu ",(unsigned long)self.type);
    if (self.photosAllUrlArr.count<=0) {
        Y_SVP_SHOW_ERR_MES(@"图片 未选择");
        return;
    }


    //model
    IssueHouseAddNewModel *model = [[IssueHouseAddNewModel alloc]init];
    if ( self.editUseRentHouseId !=  0) {//修改状态下 id用原本的ID
        model.ID = self.editUseRentHouseId; 
    }
    
    //img
    model.houseImage = self.photosAllUrlArr;
    //id
    model.houseCityId = self.cityModel.id;
    model.houseCommunityId = self.communityModel.ID;
    model.houseId = self.addressModel.ID;
    //经纬度 test/**数据越界纬度的范围 -90 <= latitude <= 90   经度的范围是 -180 <= longitude <= 180
//    model.houseLon = -125.00;
//    model.houseLat = 36.00;
    //重庆 106.54    29.59

    if ([ShareUserInfo sharedUserInfo].positioningModel.longitude == 0 && [ShareUserInfo sharedUserInfo].positioningModel.latitude == 0) {
        model.houseLon = 106.54;
        model.houseLat = 29.60;   //重庆经纬度
    }else{
        model.houseLat = [ShareUserInfo sharedUserInfo].positioningModel.longitude ;
        model.houseLat = [ShareUserInfo sharedUserInfo].positioningModel.latitude ;
    }
    //地址
    model.houseAddress = [NSString stringWithFormat:@"%@ %@",[TextShowWithModelStr textShowWithModelStr:self.communityModel.name],[TextShowWithModelStr textShowWithModelStr:self.addressModel.door]];
    //面积 户型 朝向 楼层
    model.houseSquareMeter = [self.dataSourceConnectArr[RowNum_Text_Area] doubleValue];
    if (self.saveHouseInfoStrArr.count==0 || self.saveHouseInfoCodeArr.count==0 ) {
        Y_SVP_SHOW_ERR_MES(@"房屋数据 未选择");
        return;
    }
    //str
   // model.houseFloor = self.saveHouseInfoStrArr.lastObject;//1102弹出框内楼层显示｜vc列表文本显示都更换显示成“x层共y层”，上传数据还是“x/y”
    NSString *showHousFloorStr = [NSString stringWithFormat:@"%@", self.saveHouseInfoStrArr.lastObject];
    NSString *willUseHousFloorStr =  [showHousFloorStr stringByReplacingOccurrencesOfString:@"层共" withString:@"/"];
    model.houseFloor = [willUseHousFloorStr stringByReplacingOccurrencesOfString:@"层" withString:@""];
    //code
    model.houseTypeCode = [NSString stringWithFormat:@"%0.6ld",[self.saveHouseInfoCodeArr.firstObject integerValue]];//6位数的户型code数据
    model.houseDirectionId = [self.saveHouseInfoCodeArr[1] intValue];//朝向
    switch (self.type) {
        case IssueHouse_Type_ZhengZu:
        {

        }
            break;

        default:
            break;
    }

    DLog(@"%@",[model mj_keyValues]);

    //整租 单间 合租
    switch (self.type) {
        case IssueHouse_Type_ZhengZu:
        {
            HouseZhengZuIssueOkVc *vc=  [[HouseZhengZuIssueOkVc alloc]init];
            vc.type  = self.type;
            model.houseLeasemodeId = 2; //房屋出租方式id  1不限(默认) 2整租，4合租 旧的 *** 新的是 （1不限(默认) 2整租，4合租 8单间）
            vc.houseAllDataModel = model;
            [self pushVc:vc];
        }
            break;
        case IssueHouse_Type_DanJian:
        {
            HouseDanJianIssueOkVc *vc=  [[HouseDanJianIssueOkVc alloc]init];
            vc.type  = self.type;
            model.houseLeasemodeId = 8; //房屋出租方式id  1不限(默认) 2整租，4合租
            model.bedroomType = (self.nowChooseBedroomTypeStr.length > 0) ? self.nowChooseBedroomTypeStr : @"其他";
            vc.houseAllDataModel = model;
            [self pushVc:vc];
        }
            break;
        case IssueHouse_Type_HeZu:
        {
            HouseHeZuIssueOkVc *vc=  [[HouseHeZuIssueOkVc alloc]init];
            model.houseLeasemodeId = 4; //房屋出租方式id  1不限(默认) 2整租，4合租
            //卧室类型
           // model.bedroomType = @"其他";//暂时定的其他
            model.bedroomType = (self.nowChooseBedroomTypeStr.length > 0) ? self.nowChooseBedroomTypeStr : @"其他";
            vc.type  = self.type;
            vc.houseAllDataModel = model;
            [self pushVc:vc];
        }
            break;
        default:
            break;
    }
}
#pragma marrk ===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//倒数第一行-___popview
        [self.popViewChooseHouseInfo showInView:self.view withHouseInfoStrArr:self.saveHouseInfoStrArr andSaveAllRowNumArr:self.saveHouseInfoRowNumArr];
        return;
    }
//    if (indexPath.row == RowNum_Choose_city) {
//        IssueChooseCityBaseVc *vc = [[IssueChooseCityBaseVc alloc]init];//选择城市
//        vc.delegate = self;
//        [self pushVc:vc];
//        return;
//    }
//    if (indexPath.row == RowNum_Choose_community) {
//
//        if (self.dataSourceConnectArr.firstObject==nil || [self.dataSourceConnectArr.firstObject isEqual:@""]) {
//            Y_SVP_SHOW_ERR_MES(@"请选择!");
//            return;
//        }
//        [self chooseCommunityCell];
///**
// IssueChooseCommunityBaseVc *vc = [[IssueChooseCommunityBaseVc alloc]init];//选择小区
// vc.cityModel = self.cityModel;
// vc.cityId = self.cityModel.id;//
// vc.delegate = self;
// [self pushVc:vc];
// (舍弃)（只用当前用户的房屋小区数据列表）
// */
//    }
    if (indexPath.row == RowNum_Choose_community) {
        [self chooseCommunityCell];
    }
    if(indexPath.row == RowNum_Choose_address){
        if (self.dataSourceConnectArr[RowNum_Choose_community]==nil || [self.dataSourceConnectArr[RowNum_Choose_community] isEqual:@""]) {//社区数据
            Y_SVP_SHOW_ERR_MES(@"请选择社区!");
            return;
        }
        [self chooseAddressCell];
    }
    if (indexPath.row < [tableView numberOfRowsInSection:indexPath.section]-2 && self.type == IssueHouse_Type_ZhengZu) {//倒数第2行 以上的行  + 整租 具体地址
        DLog(@"%@",self.dataSourceTitleArr[indexPath.row]);
        //
    }
    if (indexPath.row <= [tableView numberOfRowsInSection:indexPath.section]-2 && self.type != IssueHouse_Type_ZhengZu) {//倒数第2行 和 以上的行  + 非整租
        DLog(@"%@",self.dataSourceTitleArr[indexPath.row]);
        //
        if (indexPath.row == RowNum_Text_BedroomType ) {//卧室类型
            [self chooseBedroomTypeCell];
        }
    }
}
#pragma mark == 卧室类型
- (void)chooseBedroomTypeCell{
    //一个默认死数据的popView 主卧次卧其他
//    []BuniessShopOrHousePublish_Type_BedroomType
    [self.popViewChooseBedRoomType showInView:self.view thePopViewBuniessShopPublishType:BuniessShopOrHousePublish_Type_BedroomType WithArray:self.saveHouseInfoBedRoomTypeStrArr];
    
}
 
- (void)popViewChooseBuniessShopPublishTypeWithBedRoomTypeWithTouchIndex:(NSInteger)index withShowStr:(NSString *)showStr{
    DLog(@"");
    if (showStr.length>0) {
        self.nowChooseBedroomTypeStr = showStr;
        [self.dataSourceConnectArr replaceObjectAtIndex:RowNum_Text_BedroomType withObject:showStr];
        [self.tableView reloadData];
    }
}

#pragma mark == 城市
- (void)issueChooseCityVcGetModel:(CityChooseModel *)cityModel withStr:(NSString *)cityNameStr{\
    /**
     self.cityModel = cityModel;
     if (cityNameStr.length>0) {
         [self.dataSourceConnectArr replaceObjectAtIndex:RowNum_Choose_city withObject:cityNameStr];
         [self.tableView reloadData];
     }
     */
  //1015城市行去除
}
#pragma mark == 小区
- (void)chooseCommunityCell{
    //[IssHouseOfUserCommunityAndAddressViewModel getIssueUserCommunityWithCityId:self.cityModel.id getCimmunityArr:^(NSArray * arr, BOOL success) {
    [IssHouseOfUserCommunityAndAddressViewModel getIssueUserCommunityArr:^(NSArray * arr, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewChooseHouseAddressDetailList showInViewWithPopType:IssuLastAddressCellSubBasePopView_Type_Community withListArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark == 门牌等数据= 具体地址
- (void)chooseAddressCell{
    [IssHouseOfUserCommunityAndAddressViewModel getIssueUserAddressWithCommunityId:self.communityModel.ID getAddressArr:^(NSArray * arr, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewChooseHouseAddressDetailList showInViewWithPopType:IssuLastAddressCellSubBasePopView_Type_Address withListArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark ==具体地址 门牌等数据 协议回调
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic{
    if (type==IssuLastAddressCellSubBasePopView_Type_Community) {//小区数据dic
        self.communityModel = [[CommunityModel alloc]init];//
        self.communityModel.ID = [dic[@"id"] integerValue];
        self.dataSourceConnectArr[RowNum_Choose_community] = dic[@"name"];
        self.communityModel.name = dic[@"name"];
    }
    if (type==IssuLastAddressCellSubBasePopView_Type_Address) {//具体地址 门牌等数据dic 展示用
        self.addressModel = [[AddressModel alloc]init];//
        self.addressModel.ID = [dic[@"id"] integerValue];
        self.dataSourceConnectArr[RowNum_Choose_address] = dic[@"mergeName"];
        self.addressModel.door = dic[@"mergeName"];
    }
    [self.tableView reloadData];
    DLog(@"");
}
#pragma mark == 小区 (舍弃)（只用当前用户的房屋小区数据列表）
- (void)issueChooseCommunityVcGetModel:(CommunityModel *)communityModel withStr:(NSString *)communityNameStr{
    self.communityModel = communityModel;
    if (communityNameStr.length>0) {
        [self.dataSourceConnectArr replaceObjectAtIndex:RowNum_Choose_community withObject:communityNameStr];
        [self.tableView reloadData];
    }
}


#pragma mark == houseinfo pop view  房屋类型 朝向 楼层 -----
- (void)okActionWithHouseInfoGetStrArr:(NSMutableArray *)showStrArr withInfoGetCodeArr:(NSMutableArray *)notShowCodeArr withGetSaveRowNumArr:(NSMutableArray *)saveRowNunArr{
    //房屋类型 朝向 楼层
    self.saveHouseInfoStrArr = showStrArr;//用于当前文本展示
    self.saveHouseInfoCodeArr = notShowCodeArr;//用于后续数据上传 (firstobjec 将在上传时候处理位数)
    self.saveHouseInfoRowNumArr = saveRowNunArr;//用于修改时 popview 已有值处理
    [self.tableView reloadData];
}

#pragma mark ==
- (void)textFieldTopBtnAction:(UIButton *)sender{//弃用
    NSInteger idex = sender.tag - Tag_textFieldTopBtn;
    DLog(@"%@",self.dataSourceTitleArr[idex]);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderViewWithTextLabel *sectionV = [[SectionHeaderViewWithTextLabel alloc]init];
    sectionV.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    sectionV.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    sectionV.titleLabel.text = @"基本信息";
    return sectionV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//倒数第一行
        return 80;
    }else{
        if (self.type != IssueHouse_Type_ZhengZu && (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-2) ) {
            return 80;
        }else{
            return 50;
        }
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitleArr.count+1;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//倒数第一行
        IssueHouseThreeGroupTextInfoShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseThreeGroupTextInfoShowTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueHouseThreeGroupTextInfoShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IssueHouseThreeGroupTextInfoShowTableViewCell_Identifier];
        }
        if (self.saveHouseInfoStrArr.count == 3) {
            cell.oneBottomLabel.text = self.saveHouseInfoStrArr.firstObject;
            cell.twoBottomLabel.text = self.saveHouseInfoStrArr[1];
            cell.thrBottomLabel.text = self.saveHouseInfoStrArr.lastObject;
        }
        return cell;
    }else if (((indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-2)&&(self.type == IssueHouse_Type_ZhengZu)) || ((indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-3)&&(self.type != IssueHouse_Type_ZhengZu))){//倒数第2行整租 || 倒数第三行 非整租 （填写面积的框）
        IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
        cell.titleL.text = self.dataSourceTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceConnectArr[indexPath.row];
        cell.textField.delegate = self;//
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-2 && self.type != IssueHouse_Type_ZhengZu){//倒数第2行 非整租 （卧室类型 目前仅展示文本）
        IssueBaseTwoTextLabelShowTableViewCell *cell = [[IssueBaseTwoTextLabelShowTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IssueBaseTwoTextLabelShowTableViewCell_Identifier];
//        cell.topL.text = self.dataSourceTitleArr[indexPath.row];
        cell.concentLabel.text = self.dataSourceConnectArr[indexPath.row];
        return cell;
    }else{
        //前几行
        IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([ThemeManager shareManager].type == ThemeType_Drak) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//skip
            }
        }
        cell.textField.tag = Tag_textField + indexPath.row;
        cell.textFieldTopBtn.tag = Tag_textFieldTopBtn +indexPath.row;
        [cell.textFieldTopBtn addTarget:self action:@selector(textFieldTopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleL.text = self.dataSourceTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceConnectArr[indexPath.row];
        return cell;
    }
    
}
#pragma mark == textFieldDidEndEditing
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.dataSourceConnectArr[RowNum_Text_Area] = textField.text;
}
#pragma mark ==
- (HouseAllTypeBaseHeaderView *)headerView{ 
    if (!_headerView) {
        _headerView = [[HouseAllTypeBaseHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
        [_headerView.centerBtn addTarget:self action:@selector(addPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 44)];
        [_footerView.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerNextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (PopViewHouePickerViewChooseHouseInfo *)popViewChooseHouseInfo{
    _popViewChooseHouseInfo  = [[PopViewHouePickerViewChooseHouseInfo alloc]init];
    _popViewChooseHouseInfo.houseInfoDelegate = self;
    return _popViewChooseHouseInfo;
}
//
- (IssuLastAddressCellSubBasePopView *)popViewChooseHouseAddressDetailList{
    _popViewChooseHouseAddressDetailList = [[IssuLastAddressCellSubBasePopView alloc]init];
    _popViewChooseHouseAddressDetailList.delegate = self;
    return _popViewChooseHouseAddressDetailList;
}
//
- (NSMutableArray *)saveHouseInfoRowNumArr{
    if (!_saveHouseInfoRowNumArr) {
        _saveHouseInfoRowNumArr = [[NSMutableArray alloc]init];
    }
    return _saveHouseInfoRowNumArr;
}
- (NSMutableArray *)saveHouseInfoCodeArr{
    if (!_saveHouseInfoCodeArr) {
        _saveHouseInfoCodeArr = [[NSMutableArray alloc]init];
    }
    return _saveHouseInfoCodeArr;
}
- (NSMutableArray *)saveHouseInfoStrArr{
    if (!_saveHouseInfoStrArr) {
        _saveHouseInfoStrArr  = [[NSMutableArray alloc]init];
    }
    return _saveHouseInfoStrArr;
}
//
- (NSMutableArray *)dataSourceTitleArr{
    if (!_dataSourceTitleArr) {
        _dataSourceTitleArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceTitleArr;
}
- (NSMutableArray *)dataSourceConnectArr{
    if (!_dataSourceConnectArr) {
        _dataSourceConnectArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceConnectArr;
}
//
//
- (NSMutableArray *)photosAllUrlArr{
if (!_photosAllUrlArr) {
        _photosAllUrlArr = [[NSMutableArray alloc]init];
    }
    return _photosAllUrlArr;
}
- (NSMutableArray *)photosAllImgArr{
    if (!_photosAllImgArr) {
        _photosAllImgArr = [[NSMutableArray alloc]init];
    }
    return _photosAllImgArr;
}
- (NSMutableArray *)saveHouseInfoBedRoomTypeStrArr{
    if (!_saveHouseInfoBedRoomTypeStrArr ) {
        _saveHouseInfoBedRoomTypeStrArr = [[NSMutableArray alloc]initWithObjects:@"主卧",@"次卧",@"其他", nil];
    }
    return _saveHouseInfoBedRoomTypeStrArr;
}
 
- (NSString *)nowChooseBedroomTypeStr{
    if (!_nowChooseBedroomTypeStr || _nowChooseBedroomTypeStr.length==0) {
        _nowChooseBedroomTypeStr = @"其他";
    }
    return _nowChooseBedroomTypeStr;
}
- (PopViewBuniessShopChooseShopPublishTypes *)popViewChooseBedRoomType{
    _popViewChooseBedRoomType = [[PopViewBuniessShopChooseShopPublishTypes alloc]init];
    _popViewChooseBedRoomType.publishTypesDelegate = self;
    return _popViewChooseBedRoomType;
}
@end
