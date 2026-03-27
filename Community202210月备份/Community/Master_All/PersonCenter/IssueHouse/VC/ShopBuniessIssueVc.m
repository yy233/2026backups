//
//  ShopBuniessIssueVc.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "ShopBuniessIssueVc.h"
#import "ShopBuniessIssueOkVc.h"
#import "IssueAddPhotoBaseTableViewController.h"
#import "IssueChooseShopQuYuVc.h"
//
#import "IssueBaseTextFieldAndCanInputTableViewCell.h"
#import "IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.h"
#import "IssueShopBuniessThreeGroupTextInfoShowTableViewCell.h"

#define IssueBaseTextFieldAndCanInputTableViewCell_Identifier                      @"IssueBaseTextFieldAndCanInputTableViewCell"
#define IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier         @"IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell"
#define  IssueShopBuniessThreeGroupTextInfoShowTableViewCell_Identifier            @"IssueShopBuniessThreeGroupTextInfoShowTableViewCell"
//
#import "IssBuniessShopPublishTypeViewModel.h"
#import "IssBuniessShopQuYuAndAddressViewModel.h"
//
#import "IssShopBuniessCommmunityAddressCellSubBasePopView.h"

//
#define Tag_textFieldTopBtn                 400
#define RowNum_Choose_city                  0//城市
#define RowNum_Choose_quyu                  1//区域
#define RowNum_Choose_address               2//地址
#define RowNum_Floor                        3 //楼层
#define RowNum_BuniessShop_type             4 //类型
#define RowNum_BuniessShop_status           5 //状态
#define RowNum_BuniessShop_buniess          6 //行业
#define RowNum_BuniessShop_Acreage          7 //面积
#define RowNum_BuniessShop_WidthDepthHeight 8//宽高深度
/**
 self.shopBuniessModel.shopDepth = 1.0;
 self.shopBuniessModel.shopHeight = 1.0;
 self.shopBuniessModel.shopWidth = 1.0;
 */
 
@interface ShopBuniessIssueVc () <PopViewBuniessShopChooseFloorDelegate,PopViewBuniessShopChooseShopPublishTypesDelegate,BasePopTableViewChooseDelegate,IssueChooseCityBaseVcDelegate,IssuLastAddressCellSubBasePopViewDelegate,IssueBaseTextFieldAndCanInputTableViewCellDelegate,IssueShopBuniessThreeGroupTextInfoShowTableViewCellDelegate>
@property (nonatomic,strong) PopViewBuniessShopChooseFloor *popViewChooseFloor;//楼层
@property (nonatomic,strong) PopViewBuniessShopChooseShopPublishTypes *popViewChooseShopType;//类型 行业
@property (nonatomic,strong) PopViewBuniessShopChooseShopStatus *popViewChooseShopStatus;//状态
@property (nonatomic,strong) IssShopBuniessCommmunityAddressCellSubBasePopView *popViewChooseAddress;//商铺地址
@property (nonatomic,strong) CityChooseModel *cityModel;
@property (nonatomic,strong) CommunityModel *communityAddressModel;//
@property (nonatomic,strong) IssueShopBuniessQuYuModel *quYuModel;
@property (nonatomic,strong) NSMutableDictionary *photosUrlSaveDic;
@property (nonatomic,strong) NSMutableDictionary *photosImgSaveDic;
//photosAllUrlArr/图片url 上传用的
@property (nonatomic,strong) IssueShopBuniessAddNewModel *shopBuniessModel;

@end

@implementation ShopBuniessIssueVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺出租";
    self.type = IssueHouse_Type_ShopBuniess;
    self.dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"所在城市",@"所在区域",@"商铺地址",@"商铺楼层",@"商铺类型",@"商铺状态",@"商铺行业",@"建筑面积", nil];//
    self.dataSourceConnectArr = [[NSMutableArray alloc]init];
    for (int i = 0; i <self.dataSourceTitleArr.count; i ++) {
        [self.dataSourceConnectArr addObject:@""];
    }
    [self addNotice];
    
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(ShopBuniessPhotoAddEnd_Notice_Name)
}
- (void)addNotice{
    Y_NSNotificationCenter_Creat_NameAction(ShopBuniessPhotoAddEnd_Notice_Name, getPhotoDic:);
}

#pragma mark == notice
- (void)getPhotoDic:(NSNotification *)notice{
    NSDictionary *phoneDic = notice.userInfo;;
    DLog(@"getPhotoDic----%@",phoneDic);
    if (isNotNil(phoneDic)) {
        [self savePhonesInfo:phoneDic];
    }
}
//处理商铺图片数据
- (void)savePhonesInfo:(NSDictionary*)phoneDic{
    //url
    self.photosUrlSaveDic =  [NSMutableDictionary dictionaryWithDictionary:[phoneDic objectForKey:@"PhotoUrlKey"]];
    NSMutableArray *allUrlArr = [[NSMutableArray alloc]init];
    if ([self.photosUrlSaveDic allKeys].count>0) {//已有数据
        NSMutableArray *arrH = [NSMutableArray arrayWithArray:self.photosUrlSaveDic[@"H"]];
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.photosUrlSaveDic[@"M"]];
        NSMutableArray *arrO = [NSMutableArray arrayWithArray:self.photosUrlSaveDic[@"O"]];
        [allUrlArr addObjectsFromArray:arrH];
        [allUrlArr addObjectsFromArray:arrM];
        [allUrlArr addObjectsFromArray:arrO];
    }
    self.photosAllUrlArr = [NSMutableArray arrayWithArray:allUrlArr];
    
    //img
    self.photosImgSaveDic =  [NSMutableDictionary dictionaryWithDictionary:[phoneDic objectForKey:@"PhotoImgKey"]];
    NSMutableArray *allImgArr = [[NSMutableArray alloc]init];
    if ([self.photosImgSaveDic allKeys].count>0) {//已有数据
        NSMutableArray *arrH = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"H"]];
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"M"]];
        NSMutableArray *arrO = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"O"]];
        [allImgArr addObjectsFromArray:arrH];
        [allImgArr addObjectsFromArray:arrM];
        [allImgArr addObjectsFromArray:arrO];
    }
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
   
    
    /**
     {
         PhotoImgKey =     {
             H =         (
                 "<UIImage:0x283661ef0 anonymous {1242, 2208}>"
             );
             M =         (
                 "<UIImage:0x2836681b0 anonymous {1242, 2208}>"
             );
             O =         (
                 "<UIImage:0x283668c60 anonymous {750, 1334}>"
             );
         };
         PhotoUrlKey =     {
             H =         (
                 "http://222.178.212.29:9000/shop-head-img/b702b0a4-2351-4676-9423-485285182e47"
             );
             M =         (
                 "http://222.178.212.29:9000/shop-middle-img/b1ff24a7-c91e-4ddc-b412-b14d21120bf2"
             );
             O =         (
                 "http://222.178.212.29:9000/shop-other-img/9df0a22e-01b9-45b0-84f4-e426f7ca17a2"
             );
         };
     }*/
}
#pragma mark == 商铺照片
- (void)addPhotosAction{
    DLog(@"照片页");
    IssueAddPhotoBaseTableViewController *vc = [[IssueAddPhotoBaseTableViewController alloc]init];
    if ([self.photosImgSaveDic allKeys].count>0) {//已有数据
        vc.sectionOneImgArr = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"H"]];
        vc.sectionTwoImgArr = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"M"]];
        vc.sectionThrImgArr = [NSMutableArray arrayWithArray:self.photosImgSaveDic[@"O"]];
    }
    [self pushVc:vc];
}

#pragma mark == footer
- (void)footerNextBtnAction:(UIButton *)sender{
   
//    //test
//    //____
//    ShopBuniessIssueOkVc *okVctest = [[ShopBuniessIssueOkVc alloc]init];
//    okVctest.shopBuniessModel = self.shopBuniessModel;
//    [self pushVc:okVctest];
//    return;
//     //test__end

    if (isNil(self.cityModel)) {
        Y_SVP_SHOW_ERR_MES(@"城市数据为空!");
        return;
    }
    if (self.photosAllUrlArr.count==0) {
        Y_SVP_SHOW_ERR_MES(@"图片不能为空!");
        return;
    }
    
    //____
    if (self.isEditType) {
        self.shopBuniessModel.shopId = self.editUseBuniessShopId;
    }
    self.shopBuniessModel.imgPath = self.photosAllUrlArr;
    self.shopBuniessModel.cityId = self.cityModel.id;
    self.shopBuniessModel.areaId = self.quYuModel.id;
    self.shopBuniessModel.city = self.dataSourceConnectArr[RowNum_Choose_city];
    self.shopBuniessModel.area = self.dataSourceConnectArr[RowNum_Choose_quyu];
    
    self.shopBuniessModel.communityId = self.communityAddressModel.ID;
    self.shopBuniessModel.floor = self.dataSourceConnectArr[RowNum_Floor];
//    self.shopBuniessModel.shopTypeId = ;//营业中 空置中；
 
  //待去除
//    self.shopBuniessModel.defrayType =  self.dataSourceConnectArr[RowNum_BuniessShop_buniess];
//    shopTypeIds RowNum_BuniessShop_type
//    shopBusinessIds RowNum_BuniessShop_buniess
 
    if ([ShareUserInfo sharedUserInfo].positioningModel.longitude == 0 && [ShareUserInfo sharedUserInfo].positioningModel.latitude == 0) {
            self.shopBuniessModel.lon = 106.54;
            self.shopBuniessModel.lat = 29.60;   //重庆经纬度
    }else{
        self.shopBuniessModel.lon = [ShareUserInfo sharedUserInfo].positioningModel.longitude ;
        self.shopBuniessModel.lat = [ShareUserInfo sharedUserInfo].positioningModel.latitude ;
    }
   
    //____
    ShopBuniessIssueOkVc *okVc = [[ShopBuniessIssueOkVc alloc]init];
    okVc.shopBuniessModel = self.shopBuniessModel;
    [self pushVc:okVc];
}
#pragma mark == Table view didselect row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case RowNum_Floor:
        {
            [self.popViewChooseFloor showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
        }
            break;
        case RowNum_BuniessShop_type:
        {
            [self showShopTypePopView];
        }
            break;
        case RowNum_BuniessShop_buniess:
        {
            [self showShopBuniessPopView];
        }
            break;
        case RowNum_BuniessShop_status:
        {
            [self showShopStatusPopView];
        }
            break;
        case RowNum_Choose_city:
        {
            IssueChooseCityBaseVc *vc = [[IssueChooseCityBaseVc alloc]init];
            vc.delegate = self;
            [self pushVc:vc];
        }
            break;
        case RowNum_Choose_quyu:
        {
            [self issChooseQuYu];
        }
            break;
        case RowNum_Choose_address:
        {
            [self showPopViewWithAddress];
        }
            break;
        case RowNum_BuniessShop_WidthDepthHeight:
        {
        }
            break;
        default:
            break;
    }
}
#pragma mark == 城市
- (void)issueChooseCityVcGetModel:(CityChooseModel *)cityModel withStr:(NSString *)cityNameStr{
    self.cityModel = cityModel;
    if (cityNameStr.length>0) {
        [self.dataSourceConnectArr replaceObjectAtIndex:RowNum_Choose_city withObject:cityNameStr];
        [self.tableView reloadData];
    }
}
#pragma mark == 区域
- (void)issChooseQuYu{
    if (isNil(self.cityModel)) {
        Y_SVP_SHOW_INFO_MES(@"请选择城市");
        return;
    }
    IssueChooseShopQuYuVc *vc = [[IssueChooseShopQuYuVc alloc]init];
    vc.getQuYuWithUseCityId = self.cityModel.id;
    WEAKSELF
    vc.listBlock = ^(NSArray * modelArr) {
        weakSelf.quYuModel =  modelArr.firstObject;
        DLog(@"%@",modelArr.firstObject);
//        IssueShopBuniessQuYuModel
        weakSelf.dataSourceConnectArr[RowNum_Choose_quyu] = weakSelf.quYuModel.name;
        [weakSelf.tableView reloadData];
    };
    [self pushVc:vc];
//    [IssBuniessShopQuYuViewModel getIssueBuniessShopQuYuWithCityId:self.cityModel.id getQuYuArr:^(NSArray * arr, BOOL success) {
//        if (success) {//使用listvc IssueChooseShopQuYuVc
//            NSLog(@"%@",arr);
//            IssueChooseShopQuYuVc *vc = [[IssueChooseShopQuYuVc alloc]init];
//
//            WEAKSELF
//            vc.listBlock = ^(NSArray * modelArr) {
//                STRONGSELF
//                self.quYuModel =  modelArr.firstObject;
//            };
//            [self pushVc:vc];
//        }
//    }];
}
#pragma mark == 商铺地址
- (void)showPopViewWithAddress{
//    if (self.quYuModel.name.length<=0) {
//        Y_SVP_SHOW_INFO_MES(@"请选择区域");
//        return;
//    }
    //test
    self.quYuModel = [[IssueShopBuniessQuYuModel alloc]init];
    self.quYuModel.id = 500103;
    //
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [IssBuniessShopQuYuAndAddressViewModel getIssueBuniessShopCommunityAddressWithQuYuId:self.quYuModel.id getCommunityAddressArr:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewChooseAddress showInViewWithPopType:IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress withListArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark === 商铺地址
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic{
    if (type == IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress) {
        self.communityAddressModel  = [CommunityModel mj_objectWithKeyValues:dic];
        self.dataSourceConnectArr[RowNum_Choose_address] = self.communityAddressModel.name;
        
        [self.tableView reloadData];
    }
}
#pragma mark == 商铺类型 商铺行业
- (void)showShopTypePopView{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [IssBuniessShopPublishTypeViewModel getIssueBuniessShopType:BuniessShopOrHousePublish_Type_type withArr:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewChooseShopType showInView:self.view thePopViewBuniessShopPublishType:BuniessShopOrHousePublish_Type_type WithArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark == 商铺类型 商铺行业
- (void)showShopBuniessPopView{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [IssBuniessShopPublishTypeViewModel getIssueBuniessShopType:BuniessShopOrHousePublish_Type_business withArr:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewChooseShopType showInView:self.view thePopViewBuniessShopPublishType:BuniessShopOrHousePublish_Type_business WithArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark ================================
#pragma mark == 商铺类型 商铺行业
- (void)popViewChooseBuniessShopPublishTypeWithType:(BuniessShopOrHousePublish_Type)type andModel:(IssueBuniessShopPublishTypeModel *)model{
    NSString *str = [TextShowWithModelStr textShowWithModelStr:model.constName];
    if (type == BuniessShopOrHousePublish_Type_type) {//商铺类型
        self.dataSourceConnectArr[RowNum_BuniessShop_type] = str;
        self.shopBuniessModel.shopTypeId = model.id;
        [self.tableView reloadData];
    }
    if (type == BuniessShopOrHousePublish_Type_business) {//商铺行业
        self.dataSourceConnectArr[RowNum_BuniessShop_buniess] = str;
        self.shopBuniessModel.shopBusinessId = model.id;
        [self.tableView reloadData];
    }
}
#pragma mark === 商铺楼层
- (void)popViewChooseBuniessShopFloorWithType:(PopView_Floor_Type)type andFloorStr:(NSString *)str{
    DLog(@"%@",str);
    self.dataSourceConnectArr[RowNum_Floor] = str;
    self.shopBuniessModel.floor = str;
    [self.tableView reloadData];
}
#pragma mark == 商铺状态
- (void)showShopStatusPopView{
    DLog(@"")
    NSInteger rowShowNum = 0;
    if ([self.dataSourceConnectArr[RowNum_BuniessShop_status] isEqualToString:@""] || [self.dataSourceConnectArr[RowNum_BuniessShop_status] isEqualToString:@"空置中"]) {
        rowShowNum = 0;
    }else{
        rowShowNum = 1;
    }
    [self.popViewChooseShopStatus showInView:self.view thePopViewTableViewHeight:Screen_H*0.3 WithArray:@[@"空置中",@"营业中"].mutableCopy withHeaderViewTitle:@"请选择商铺状态" withNowShowRowNum:rowShowNum];
}
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    DLog(@"0空置中  1营业中");
    NSString *str = @"";
    if (indexPath.row==0) {
        str = @"空置中";
//        shopTypeId = 0; 行业类型其中一个键值
        self.shopBuniessModel.status = 0;
    }else{
        str = @"营业中";
        self.shopBuniessModel.status = 1;//营业中 空置中；
    }
    self.dataSourceConnectArr[RowNum_BuniessShop_status] = str;
    [self.tableView reloadData];
}

#pragma mark === 宽 高 深度
- (void)shopBuniessTextInfoWithWidth:(NSString *)widthStr withDepth:(NSString *)depthStr withHeight:(NSString *)heightStr{
    self.shopBuniessModel.shopWidth  = [widthStr doubleValue];
    self.shopBuniessModel.shopDepth  = [depthStr doubleValue];
    self.shopBuniessModel.shopHeight = [heightStr doubleValue];
}
 
#pragma mark == textF
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)str{
    self.dataSourceConnectArr[RowNum_BuniessShop_Acreage] = str;
    self.shopBuniessModel.shopAcreage = [str doubleValue];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitleArr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        return 80;
    }else{
        return 50;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//倒数第一行
        IssueShopBuniessThreeGroupTextInfoShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueShopBuniessThreeGroupTextInfoShowTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueShopBuniessThreeGroupTextInfoShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IssueShopBuniessThreeGroupTextInfoShowTableViewCell_Identifier];
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-2){//倒数第二行
        IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
        cell.titleL.text = self.dataSourceTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceConnectArr[indexPath.row];
        cell.delegale = self;
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
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
 
        cell.textFieldTopBtn.tag = Tag_textFieldTopBtn +indexPath.row;
        [cell.textFieldTopBtn addTarget:self action:@selector(textFieldTopBtnAction:) forControlEvents:UIControlEventTouchUpInside];//弃用btn的点击action 用didSelectRowAtIndexPath
        cell.titleL.text = self.dataSourceTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceConnectArr[indexPath.row];
        return cell;
    }
}
 
#pragma mark ==
- (PopViewBuniessShopChooseFloor *)popViewChooseFloor{
    _popViewChooseFloor = [[PopViewBuniessShopChooseFloor alloc]init];
    _popViewChooseFloor.floorDelegate = self;
    return _popViewChooseFloor;
}

- (PopViewBuniessShopChooseShopPublishTypes *)popViewChooseShopType{
    _popViewChooseShopType = [[PopViewBuniessShopChooseShopPublishTypes alloc]init];
    _popViewChooseShopType.publishTypesDelegate = self;
    return _popViewChooseShopType;
}
 
- (PopViewBuniessShopChooseShopStatus *)popViewChooseShopStatus{
    _popViewChooseShopStatus = [[PopViewBuniessShopChooseShopStatus alloc]init];
    _popViewChooseShopStatus.delegate = self;
    return _popViewChooseShopStatus;
}
- (IssShopBuniessCommmunityAddressCellSubBasePopView *)popViewChooseAddress{
    _popViewChooseAddress = [[IssShopBuniessCommmunityAddressCellSubBasePopView alloc]init];
    _popViewChooseAddress.delegate = self;
//    WEAKSELF
//    _popViewChooseAddress.arrBlock = ^(NSArray * arr) {
//        weakSelf.communityAddressModel = [CommunityModel mj_objectWithKeyValues:arr.firstObject];
//    };
    return _popViewChooseAddress;
}
 
#pragma mark ==
- (NSMutableDictionary *)photosUrlSaveDic{
    if (!_photosUrlSaveDic) {
        _photosUrlSaveDic = [[NSMutableDictionary alloc]init];
    }
    return _photosUrlSaveDic;
}
- (NSMutableDictionary *)photosImgSaveDic{
    if (!_photosImgSaveDic) {
        _photosImgSaveDic = [[NSMutableDictionary alloc]init];
    }
    return _photosImgSaveDic;
}

- (IssueShopBuniessAddNewModel *)shopBuniessModel{
    if (!_shopBuniessModel) {
        _shopBuniessModel = [[IssueShopBuniessAddNewModel alloc]init];
    }
    return _shopBuniessModel;
}

@end
