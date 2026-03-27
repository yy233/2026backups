//
//  HouseZhengZuIssueOkVc.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
// 整租OKvc

#import "HouseZhengZuIssueOkVc.h"
#import "IssueBaseTextFieldAndCanInputTableViewCell.h"
#import "IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.h"
#import "IssueBaseTextViewTableViewCell.h"
#import "IssueBaseSubBlueBtnsViewTableViewCell.h"

#define  IssueBaseTextFieldAndCanInputTableViewCell_Identifier                      @"IssueBaseTextFieldAndCanInputTableViewCell"
#define  IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier         @"IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell"
#define  IssueBaseTextViewTableViewCell_Identifier                                  @"IssueBaseTextViewTableViewCell"
#define  IssueBaseSubBlueBtnsViewTableViewCell_Identifier                           @"IssueBaseSubBlueBtnsViewTableViewCell"
//________________________________
#import "IssueHouseCellBlueSubBtnCellViewModel.h"
#import "PopViewBuniessShopAndHouseChoosePayWayViewModel.h"
#import "IssHouseOfHouseConstViewModel.h"
//________________________________
#import "PopViewHouseChooseHouseLeaseTypes.h"
//________________________________
#define Height_SectionHeaderView_Text     40
#define Height_SectionHeaderView_NoView   0.01
#define Height_Cell_TextField             50
#define Height_Cell_TextView_One          70
#define Height_Cell_BaseBlueOneCell_One   80

//________________________________
#define SectionAllCount       5
//s_0
#define SectionNum_Money               0
#define RowNum_payWay         0
#define RowNum_payMoney       1
//s_1
#define SectionNum_Type                1
#define RowNum_rentType       0
#define RowNum_rentWay        1
//s_2
#define SectionNum_BlueSubBtnCell      2
//s_3
#define SectionNum_Text                3
#define RowNum_title          0
#define RowNum_detailTitle    1
//s_4
#define SectionNum_PersonInfo          4
#define RowNum_name           0
#define RowNum_phoneNum       1
//s_2_row_num________
#define RowNum_Blue_Cell_One           0
#define RowNum_Blue_Cell_Two           1
#define RowNum_Blue_Cell_Thr           2
#define RowNum_Blue_Cell_Four          3
//________________________________
//textView.tag
#define Tag_Cell_Sub_TextView_One          301
#define Tag_Cell_Sub_TextView_Two          302
//textField.tag __info
#define Tag_Cell_Sub_TextField_MoneyNum    200
#define Tag_Cell_Sub_TextField_Name        201
#define Tag_Cell_Sub_TextField_PhoneNum    202
//________________________________
@interface HouseZhengZuIssueOkVc () <IssueBaseSubBlueBtnsViewTableViewCellDelegate,PopViewBuniessShopAndHouseChoosePayWayDelegate,PopViewHouseChooseHouseLeaseTypesDelegate,PopViewHouseChooseHouseLeaseTypesDelegate,IssueBaseTextViewTableViewCellDelegate,IssueBaseTextFieldAndCanInputTableViewCellDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) PopViewBuniessShopAndHouseChoosePayWay *popViewPayWay;
@property (nonatomic,strong) PopViewHouseChooseHouseLeaseTypes *popViewHouseLeaseType;
@property (nonatomic,strong) NSMutableArray *sectionOneTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionOneContentArr;
@property (nonatomic,strong) NSMutableArray *sectionTwoTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionTwoContentArr;
@property (nonatomic,strong) NSMutableArray *sectionPersonTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionPersonConcentArr;
//houseAllDataModel 总model

@end

@implementation HouseZhengZuIssueOkVc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionFooterHeight = 0.1;//UITableViewStyleGrouped和组尾冗余空间
    if (self.type == IssueHouse_Type_ZhengZu) {
        self.title = @"整租";
    }else if (self.type == IssueHouse_Type_DanJian){
        self.title = @"单间";
    }else if(self.type == IssueHouse_Type_HeZu){
        self.title = @"合租";
    }
    [self initView];
 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
 
}
- (void)initView{
    self.tableView.tableFooterView = self.footerView;
}
- (void)initData{
    //                        18    装修情况
    //                        13    房屋配置
    //
    //                        14    租房预约日期--待增
    //
    //                        12    房源亮点
    //                        21    出租要求
    //___
    //                        18    装修情况
    //                        23    公共设施
    //                        24    房间设施
    //                        14    租房预约日期--待增
    //                        21    出租要求
    WEAKSELF
    [IssueHouseCellBlueSubBtnCellViewModel  getHouseBlueSubCellViewAllArrWithHouseIssueType:self.type withNewListArr:^(NSArray * arr, BOOL success) {
        if (success) {
            //蓝色标签组文本
            self.sectionBluesSubBtnCellTitleArr = [[NSMutableArray alloc]init];
            for (int i = 0 ; i <arr.count; i ++) {
                NSMutableArray *anModelArr = [NSMutableArray arrayWithArray:[IssueHouseCellBlueSubBtnCellModel mj_objectArrayWithKeyValuesArray:arr[i]]];
                IssueHouseCellBlueSubBtnCellModel *model = anModelArr.firstObject;
                NSString *annotationStr = [TextShowWithModelStr textShowWithModelStr:model.annotation];
                [weakSelf.sectionBluesSubBtnCellTitleArr addObject:annotationStr];//大类别名字 重新赋值
                
                if (self.type == IssueHouse_Type_ZhengZu) {
                     //@"整租";
                    if ([annotationStr containsString:@"装修"]) {
                        weakSelf.sectionBluesSubBtnCellOneContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"配置"]) {
                        weakSelf.sectionBluesSubBtnCellTwoContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"日期"]) {
                        weakSelf.sectionBluesSubBtnCellThrContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"亮点"]) {
                        weakSelf.sectionBluesSubBtnCellFourContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"要求"]) {
                        weakSelf.sectionBluesSubBtnCellFiveContentArr =  anModelArr;
                    }else{
                        DLog(@"IssueHouse_Type_ZhengZu =---  init data  %@",annotationStr);
                    }
                }else if (self.type == IssueHouse_Type_DanJian){
                    //@"单间";
                    if ([annotationStr containsString:@"装修"]) {
                        weakSelf.sectionBluesSubBtnCellOneContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"公共设施"]) {
                        weakSelf.sectionBluesSubBtnCellTwoContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"房间设施"]) {
                        weakSelf.sectionBluesSubBtnCellThrContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"日期"]) {
                        weakSelf.sectionBluesSubBtnCellFourContentArr =  anModelArr;
                    }else if ([annotationStr containsString:@"要求"]) {
                        weakSelf.sectionBluesSubBtnCellFiveContentArr =  anModelArr;
                    }else{
                        DLog(@"IssueHouse_Type_DanJian =---  init data  %@",annotationStr);
                    }
                }else if(self.type == IssueHouse_Type_HeZu){
                    //@"合租";
                }
               
            }
             dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==
- (void)footerOkBtnAction{
    self.houseAllDataModel.houseUnit = @"月";
    DLog(@"");
    /**
     --------------
      POST_
      params={
         appellation = "\U54c8\U54c8\U54c8";
         decorationTypeId = 4;
         houseAddress = "(null) (null)";
         houseAdvantageCode =     (
             1024
         );
         houseAreaId = 0;
         houseCityId = 500100;
         houseCommunityId = 1;
         houseContact = 18187789009;
         houseDirection = 2;
         houseFloor = "5/2";
         houseFurnitureCode =     (
             16,
             32,
             2048,
             32768
         );
         houseId = 110;
         houseImage =     (
             "http://222.178.212.29:9000/house-img/71f91f78-69de-4f07-a080-c0c4197a2b5f"
         );
         houseIntroduce = "88888888888888\U63cf\U8ff0";
         houseLat = 136;
         houseLeasedepositId = 4;
         houseLeasemodeId = 2;
         houseLeasetypeId = 2;
         houseLon = 125;
         housePrice = 2900;
         houseSquareMeter = 457;
         houseTitle = "77777\U63cf\U8ff0";
         houseTypeCode = 030101;
         houseUnit = "\U6708";
         leaseRequireCode =     (
             8,
             16
         );
         roommateSexId = 0;
     }_
      url=http://smart.free.vipnps.vip/api/v1/lease/house/wholeLease
     --------------
     2021-03-02 15:21:47.956376+0800 Community[6305:2811602] ___
      url=http://smart.free.vipnps.vip/api/v1/lease/house/wholeLease____{
         code = 499;
         data = 0;
         messa*/
    if( self.houseAllDataModel.houseTitle.length < 10 ||  self.houseAllDataModel.houseTitle.length > 30 ){
        Y_SVP_SHOW_ERR_MES(@"房源概述字数不符合!");
        return;
    }
    
    if (self.saveChooseIndexArrOfZhuangXiug.count==0) {
        Y_SVP_SHOW_ERR_MES(@"请选择房屋装修情况！");
        return;
    }
    
    
    NSString *defStr = [NSString stringWithFormat:@"%@",self.sectionOneContentArr[RowNum_payWay]];
    if (defStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请选择押付方式");
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:[self.houseAllDataModel mj_keyValues]];
    if (self.houseAllDataModel.ID != 0) {//修改数据属性
        [IssueHouseOkSendInfoViewModel issueHouseSendZhengZuChangeWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                    [self popTwoVC];
                });
            }
        }];
    }else{
        [IssueHouseOkSendInfoViewModel issueHouseSendZhengZuWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                    [self popTwoVC];
                });
            }
        }];
    }
    
}
- (void)popTwoVC{
    if (self.houseTypeModel.id != 0) {//修改数据属性
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];//4
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -3)] animated:YES];
    }else{
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];//
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }

}
#pragma mark -
#pragma mark - Table view ————————————————did cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case SectionNum_Money:
        {
            DLog(@"didSelectRowA 押金方式")
            [self choosePayWayAction];
        }
            break;
        case SectionNum_Type:
        {
            if (indexPath.row == RowNum_rentType) {
                DLog(@"didSelectRowA 出租类型 房屋类型 chooseHouseLeaseType ")//
                [self chooseHouseLeaseType];
            }else{
                DLog(@"didSelectRowA 租赁方式")
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark ----didSelectRowA 押金方式 数据
- (void)choosePayWayAction{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [PopViewBuniessShopAndHouseChoosePayWayViewModel getPayWayViewArr:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewPayWay showInView:self.view thePopViewSubViewHeight:0 WithArray:arr.mutableCopy];
            });
        }
    }];
}
#pragma mark ---- didSelectRowA 出租类型 房屋类型 (房屋出租类型id        houseConstCode 1不限(默认) 2普通住宅 4别墅 8公寓  )
- (void)chooseHouseLeaseType{
    [IssHouseOfHouseConstViewModel getIssueHouseLeaseTypeWithList:^(NSArray * arr, BOOL success) {
        if (success) {
            //房屋类型常量
            DLog(@"_____chooseHouseLeaseType____%@",arr);//popshow houseConstType houseConstName houseConstCode annotation #import "PopViewHouseChooseHouseLeaseTypes.h"
            [self.popViewHouseLeaseType showInView:self.view thePopViewSubViewHeight:0 WithArray:arr.mutableCopy];
        }
    }];
}

#pragma mark ========================  各个事件的协议回调

#pragma mark ==== 押付方式
- (void)popViewChoosePayWayModel:(PopViewBuniessShopAndHouseChoosePayWayModel *)model{
    self.payWayModel = model;//本cell子数据model
    self.sectionOneContentArr[RowNum_payWay] = [TextShowWithModelStr textShowWithModelStr:model.houseConstName];//未选择时是nil
    self.houseAllDataModel.houseLeasedepositId = model.houseConstCode; //总数据model
    [self.tableView reloadData];
}
#pragma mark ====  出租类型 房屋类型 houseLeasetypeId
- (void)popViewChooseHouseLeaseTypeWithModel:(IssueHouseConstModel *)model{  //houseConstName   houseConstCode1不限(默认) 2普通住宅 4别墅 8公寓  )
    //本cell子数据model
    self.houseTypeModel = model;
    //总数据model
    self.houseAllDataModel.houseLeasetypeId  = model.houseConstCode;//房屋出租类型ID：1不限(默认) 2普通住宅 4别墅 8公寓
    //展示数据
    self.sectionTwoContentArr[RowNum_rentType] = [TextShowWithModelStr textShowWithModelStr:model.houseConstName];//文本部分
    [self.tableView reloadData];
    
}
#pragma mark == cell sub btn selected 圆圈类型 各个type选择的arr
- (void)cellTouchSubBlueBtnWithIndexArr:(NSMutableArray *)indexArr andCellType:(Cell_type_BlueBtn)type{
    //1015改动
    //                        18    装修情况
    //                        13    房屋配置
    //
    //                        14    租房预约日期--待增
    //
    //                        12    房源亮点
    //                        21    出租要求
    switch (type) {
        case Cell_type_BlueBtn_HouseAllType18: //装修得是单选数据
            DLog(@"装修 arr=%@",indexArr);
            [self saveHouseZhuangXiuChooseDataIndex:indexArr];//bluecell选择的数组 num元素
            break;
        case Cell_type_BlueBtn_HouseAllType13:
            DLog(@"家具设施 arr=%@",indexArr);
            [self saveHouseSheShiChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType14:
            DLog(@"租房预约日期- arr=%@",indexArr);
            [self saveHouseRentDayTypeChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType12:
            DLog(@"亮点 arr=%@",indexArr);
            [self saveHouseLiangDianChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType21:
            DLog(@"出租要求 arr=%@",indexArr);
            [self saveChuZuYaoQiuChooseDataIndex:indexArr];
            break;
        default:
            break;
    }
    
}
#pragma mark ======  圆圈类型    //用于以后新增时的数据上传
/**
 @property (nonatomic,strong) NSArray *leaseRequireCode;    //出租要求
 @property (nonatomic,strong) NSArray *commonFacilitiesCode;//公共设施 13 23 24
 @property (nonatomic,strong) NSArray *roommateExpectCode;  //室友期望
 @property (nonatomic,assign) NSInteger roommateSexId;      //室友性别
 @property (nonatomic,assign) NSInteger decorationTypeId;   //装修情况
 houseAdvantage  房屋优势标签id
 //___*/

#pragma mark —— 日期 同装修一样是单选
- (void)saveHouseRentDayTypeChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfRentdayType = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfRentdayType = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellThrContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfRentdayType addObject:@(chooseBlueCodeId)];
        DLog(@" 日期类型 --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealDayTypeBlueCellSave];
}
- (void)dealDayTypeBlueCellSave{
    if (self.saveChooseCodeArrOfRentdayType.count>0) {
        self.houseAllDataModel.houseReserveTime = [self.saveChooseCodeArrOfRentdayType.firstObject intValue];
    }else{
        self.houseAllDataModel.houseReserveTime = 0;
    }
}
#pragma mark —— 装修
- (void)saveHouseZhuangXiuChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfZhuangXiug = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfZhuangXiug = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellOneContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfZhuangXiug addObject:@(chooseBlueCodeId)];
        DLog(@" 装修  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealOneBlueCellSave];
}
- (void)dealOneBlueCellSave{
    if (self.saveChooseCodeArrOfZhuangXiug.count>0) {
        self.houseAllDataModel.decorationTypeId = [self.saveChooseCodeArrOfZhuangXiug.firstObject intValue];
    }else{
        self.houseAllDataModel.decorationTypeId = 0;
    }
}
#pragma mark —— 房间设施 公共+家具=== 13总的=23+24 分装
/**
 13  houseFurnitureCode []  整租才会用到
 23  commonFacilitiesCode [] 公共设施   合租/单间
 24  roomFacilitiesCode [] 房间设施   合租/单间
 4    houseAdvantageCode []  房屋亮点  整租/单间
 */
- (void)saveHouseSheShiChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfHouseSheShi = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfHouseSheShi = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellTwoContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfHouseSheShi addObject:@(chooseBlueCodeId)];
        DLog(@" 房间设施  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealTwoBlueCellSave];
}
- (void)dealTwoBlueCellSave{
    if (self.saveChooseCodeArrOfHouseSheShi.count>0) {
        self.houseAllDataModel.houseFurnitureCode = self.saveChooseCodeArrOfHouseSheShi;
    }else{
        self.houseAllDataModel.houseFurnitureCode = @[];
    }
}
#pragma mark —— 房间亮点
- (void)saveHouseLiangDianChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfHouseLiangDian = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfHouseLiangDian = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFourContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfHouseLiangDian addObject:@(chooseBlueCodeId)];
        DLog(@" 房间亮点  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealFourBlueCellSave];
}
- (void)dealFourBlueCellSave{
    if (self.saveChooseCodeArrOfHouseSheShi.count>0) {
        self.houseAllDataModel.houseAdvantageCode = self.saveChooseCodeArrOfHouseLiangDian;
    }else{
        self.houseAllDataModel.houseAdvantageCode = @[];
    }
}
#pragma mark —— 出租要求
- (void)saveChuZuYaoQiuChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfYaoQiu = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfYaoQiu = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFiveContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfYaoQiu addObject:@(chooseBlueCodeId)];
        DLog(@" 出租要求  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealFiveBlueCellSave];
    
}
- (void)dealFiveBlueCellSave{
    if (self.saveChooseCodeArrOfHouseSheShi.count>0) {
        self.houseAllDataModel.leaseRequireCode = self.saveChooseCodeArrOfYaoQiu;
    }else{
        self.houseAllDataModel.leaseRequireCode = @[];
    }
}
#pragma mark ======  TextView 文本数据 delegate
- (void)cellTextViewTag:(NSInteger)tag withTextViewStr:(NSString *)textViewStr{
    if (tag == Tag_Cell_Sub_TextView_One) {//房源概括
        self.houseAllDataModel.houseTitle = textViewStr;
    }
    if (tag == Tag_Cell_Sub_TextView_Two) {//房源描述
        self.houseAllDataModel.houseIntroduce = textViewStr;
    }
    
}
#pragma mark ======  TextField 文本数据 delegate
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)str{
    if (tag == Tag_Cell_Sub_TextField_MoneyNum) {
        self.sectionOneContentArr[1] = str;
        //钱(待)处理
        self.houseAllDataModel.housePrice = [str doubleValue];
    }
    if (tag == Tag_Cell_Sub_TextField_Name) {
        self.sectionPersonConcentArr[0] = str;
        self.houseAllDataModel.appellation = str;
    }
    if (tag == Tag_Cell_Sub_TextField_PhoneNum) {
        self.sectionPersonConcentArr[1] = str;
        self.houseAllDataModel.houseContact = str;
    }
    
}
#pragma mark ======
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionAllCount;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == SectionNum_Money || section == SectionNum_Type || section == SectionNum_PersonInfo) {
        SectionHeaderView *v = [[SectionHeaderView alloc]init];
        switch (section) {
            case SectionNum_Money:
                v.titleLabel.text = @"租金详情";
                break;
            case SectionNum_Type:
                v.titleLabel.text = @"类型选择";
                break;
            case SectionNum_PersonInfo:
                v.titleLabel.text = @"联系人";
                break;
            default:
                break;
        }
     
        [v.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(v).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        return v;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SectionNum_Money || section == SectionNum_Type || section == SectionNum_PersonInfo) {
        return Height_SectionHeaderView_Text;
    }else{
        return Height_SectionHeaderView_NoView;//没sectionHeaderText 0.01h
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFView = [[UIView alloc]init];
    if ([ThemeManager shareManager].type == ThemeType_White) {
        sectionFView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;//空sectionFooter分割 普通vc色 浅主题为非白
    }else{
        sectionFView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];//深色主题 主色为重蓝 分割则需黑色
    }
 
    return sectionFView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section==[tableView numberOfSections]-1) {//最后一行footer=1
        return 1;
    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//更改SectionNum_Type的row 仅有房屋类型选择
    if (section==SectionNum_Type) {
        return 1;
    }else if (section == SectionNum_Money || section == SectionNum_Text || section == SectionNum_PersonInfo) {
        return 2;
    }else{
        if (self.type == IssueHouse_Type_ZhengZu) {//@"整租";
//            return 4;
            return 5;//1015 整租单间都有5大类蓝色标签
        }else{
            return 5;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == SectionNum_Money || indexPath.section == SectionNum_Type|| indexPath.section == SectionNum_PersonInfo) {
        return Height_Cell_TextField;
    }else if(indexPath.section  == SectionNum_Text){
        if (indexPath.row==0) {
            return Height_Cell_TextView_One;
        }else{
            return Height_Cell_TextView_One*2;
        }
    }else if(indexPath.section  == SectionNum_BlueSubBtnCell){//计算得到各个cell的高度
        return [self heightForRowWithBlueSubBtnSectionAtIndexPath:indexPath];
    }else{
        return 1;
    }
}
#pragma mark ==//其他类型 蓝色cell 高度重写预定——————————————
- (CGFloat)heightForRowWithBlueSubBtnSectionAtIndexPath:(NSIndexPath *)indexPath{
 
    //        return 80;//第二组 蓝色 高度待定 第一排80 空5+20+10+5+32
    float heightTitleL = 55;
    float blueBtnOneHang = 35.0;
    if (indexPath.row==0) {
        NSInteger hangNum =  self.sectionBluesSubBtnCellOneContentArr.count/3 + ( self.sectionBluesSubBtnCellOneContentArr.count%3>0 ? 1 :0);
        if (hangNum<=1) {
            return Height_Cell_BaseBlueOneCell_One;
        }else{
            return (hangNum-1)*blueBtnOneHang +heightTitleL;
        }
    }else if(indexPath.row == 1){//家具等 文本较细 用4
        NSInteger hangNum =  self.sectionBluesSubBtnCellTwoContentArr.count/4 + ( self.sectionBluesSubBtnCellTwoContentArr.count%3>0 ? 1 :0);
        if (hangNum<=1) {
            return Height_Cell_BaseBlueOneCell_One;
        }else{
            return (hangNum-1)*blueBtnOneHang +heightTitleL;
        }
    }else if(indexPath.row == 2){
        NSInteger hangNum =  self.sectionBluesSubBtnCellThrContentArr.count/3 + ( self.sectionBluesSubBtnCellThrContentArr.count%3>0 ? 1 :0);
        if (hangNum<=1) {
            return Height_Cell_BaseBlueOneCell_One;
        }else{
            return (hangNum-1)*blueBtnOneHang +heightTitleL;
        }
    }else if(indexPath.row == 3){
        NSInteger hangNum =  self.sectionBluesSubBtnCellFourContentArr.count/3 + ( self.sectionBluesSubBtnCellFourContentArr.count%3>0 ? 1 :0);
        if (hangNum<=1) {
            return Height_Cell_BaseBlueOneCell_One;
        }else{
            return (hangNum-1)*blueBtnOneHang +heightTitleL +20;
        }
    }else{
        NSInteger hangNum =  self.sectionBluesSubBtnCellFiveContentArr.count/3 + ( self.sectionBluesSubBtnCellFiveContentArr.count%3>0 ? 1 :0);
        if (hangNum<=1) {
            return Height_Cell_BaseBlueOneCell_One;
        }else{
            return (hangNum-1)*blueBtnOneHang +heightTitleL +20;
        }
    }
   
}
#pragma mark ==
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionNum_Money) {
        if (indexPath.row == RowNum_payWay) {
            IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
            if (!cell) {
                cell = [[IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if ([ThemeManager shareManager].type == ThemeType_Drak) {
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//skip
                }
            }
            cell.titleL.text = self.sectionOneTitleArr[indexPath.row];
            cell.textField.text = self.sectionOneContentArr[indexPath.row];
            return cell;
        }else{
            IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
            cell.titleL.text = self.sectionOneTitleArr[indexPath.row];
            cell.textField.text = self.sectionOneContentArr[indexPath.row];
            cell.delegale = self;
            cell.textField.tag = Tag_Cell_Sub_TextField_MoneyNum;
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            return cell;
        }
    }else if (indexPath.section == SectionNum_Type){
        IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([ThemeManager shareManager].type == ThemeType_Drak) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//skip
            }
        }
        cell.titleL.text = self.sectionTwoTitleArr[indexPath.row];
        cell.textField.text = self.sectionTwoContentArr[indexPath.row];
        return cell;
    }else if(indexPath.section == SectionNum_Text){    //描述文本组
        
        IssueBaseTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseTextViewTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueBaseTextViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextViewTableViewCell_Identifier];
        }
        if (indexPath.row==0) {
            cell.titelL.text = @"房源概述";
            cell.placeHolderLabel.text = @"简要描述您的房源（10-30字内）";
            cell.textView.tag = Tag_Cell_Sub_TextView_One;
        }else{
            cell.titelL.text = @"房源描述";
            cell.placeHolderLabel.text = @"可描述周边的业态，服务内容";
            cell.textView.tag = Tag_Cell_Sub_TextView_Two;
        }
        cell.delegate = self;//IssueBaseTextViewTableViewCellDelegate 文本输入部分的数据回调
        return cell;
    }else if(indexPath.section == SectionNum_PersonInfo){ //最后一组个人信息
        IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
        cell.titleL.text = self.sectionPersonTitleArr[indexPath.row];
        cell.textField.text = self.sectionPersonConcentArr[indexPath.row];
        cell.delegale = self;
        if (indexPath.row==0) {
            cell.textField.tag = Tag_Cell_Sub_TextField_Name;
        }else{
            cell.textField.tag = Tag_Cell_Sub_TextField_PhoneNum;
        }
        return cell;
    }else{
        return [self tableView:tableView blueSubBtnCellForRowAtIndexPath:indexPath];
        
    }
}
#pragma mark ==//其他类型 蓝色cell  待重写——————————
- (UITableViewCell *)tableView:(UITableView *)tableView blueSubBtnCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //蓝色子subbtnView
    IssueBaseSubBlueBtnsViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseSubBlueBtnsViewTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssueBaseSubBlueBtnsViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseSubBlueBtnsViewTableViewCell_Identifier];
    }
    cell.delegate = self;
    cell.titelL.text = self.sectionBluesSubBtnCellTitleArr[indexPath.row];
    if (self.type == IssueHouse_Type_ZhengZu) {
        //                        18    装修情况
        //                        13    房屋配置
        //
        //                        14    租房预约日期--待增
        //
        //                        12    房源亮点
        //                        21    出租要求
        if (indexPath.row==0) {
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellOneContentArr andCellType:Cell_type_BlueBtn_HouseAllType18];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfZhuangXiug];
        }else if (indexPath.row == 1){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellTwoContentArr andCellType:Cell_type_BlueBtn_HouseAllType13];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfHouseSheShi];
        }else if (indexPath.row == 2){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellThrContentArr andCellType:Cell_type_BlueBtn_HouseAllType14];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfRentdayType];
        }else if (indexPath.row == 3){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFourContentArr andCellType:Cell_type_BlueBtn_HouseAllType12];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfHouseLiangDian];
        }else if (indexPath.row == 4){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFiveContentArr andCellType:Cell_type_BlueBtn_HouseAllType21];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfYaoQiu];
        }else {
        
        }
    }
    return cell;
}
#pragma mark ==
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 44)];
        [_footerView.footerBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerOkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (PopViewBuniessShopAndHouseChoosePayWay *)popViewPayWay{
    _popViewPayWay = [[PopViewBuniessShopAndHouseChoosePayWay alloc]init];
    _popViewPayWay.payWayDelegate = self;
    return _popViewPayWay;;
}
- (PopViewHouseChooseHouseLeaseTypes *)popViewHouseLeaseType{
    _popViewHouseLeaseType = [[PopViewHouseChooseHouseLeaseTypes alloc]init];
    _popViewHouseLeaseType.leaseTypesPopViewDelegate = self;
    return _popViewHouseLeaseType;
}
#pragma mark ===
- (NSMutableArray *)sectionOneTitleArr{
    if (!_sectionOneTitleArr) {
        _sectionOneTitleArr = [NSMutableArray arrayWithObjects:@"押付方式",@"月租金",nil];
    }
    return _sectionOneTitleArr;
}
- (NSMutableArray *)sectionOneContentArr{
    if (!_sectionOneContentArr) {
        _sectionOneContentArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
    }
    return _sectionOneContentArr;
}
- (NSMutableArray *)sectionTwoTitleArr{
    if (!_sectionTwoTitleArr) {
//        _sectionTwoTitleArr = [NSMutableArray arrayWithObjects:@"出租类型",@"租赁方式",nil];//UI换成1row
        _sectionTwoTitleArr = [NSMutableArray arrayWithObjects:@"房屋类型",nil];//
    }
    return _sectionTwoTitleArr;
}
- (NSMutableArray *)sectionTwoContentArr{
    if (!_sectionTwoContentArr) {
        _sectionTwoContentArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
    }
    return _sectionTwoContentArr;
}
//last_section
- (NSMutableArray *)sectionPersonTitleArr{
    if (!_sectionPersonTitleArr) {
        _sectionPersonTitleArr = [NSMutableArray arrayWithObjects:@"如何称呼",@"手机号",nil];
    }
    return _sectionPersonTitleArr;
}
- (NSMutableArray *)sectionPersonConcentArr{
    if (!_sectionPersonConcentArr) {
        _sectionPersonConcentArr = [NSMutableArray arrayWithObjects:@"",@"",nil];
    }
    return _sectionPersonConcentArr;
}
#pragma mark == blue_cell
- (NSMutableArray *)sectionBluesSubBtnCellTitleArr{
    if (!_sectionBluesSubBtnCellTitleArr) {
        _sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"装修情况",@"房间设施",@"房屋亮点",@"出租要求",nil];//初始文本
    }
    return _sectionBluesSubBtnCellTitleArr;
}
//--
- (NSMutableArray *)sectionBluesSubBtnCellOneContentArr{
    if (!_sectionBluesSubBtnCellOneContentArr) {
        _sectionBluesSubBtnCellOneContentArr = [[NSMutableArray alloc]init];
    }
    return _sectionBluesSubBtnCellOneContentArr;
}
- (NSMutableArray *)sectionBluesSubBtnCellTwoContentArr{
    if (!_sectionBluesSubBtnCellTwoContentArr) {
        _sectionBluesSubBtnCellTwoContentArr = [[NSMutableArray alloc]init];
    }
    return _sectionBluesSubBtnCellTwoContentArr;
}
- (NSMutableArray *)sectionBluesSubBtnCellThrContentArr{
    if (!_sectionBluesSubBtnCellThrContentArr) {
        _sectionBluesSubBtnCellThrContentArr = [[NSMutableArray alloc]init];
    }
    return _sectionBluesSubBtnCellThrContentArr;
}
- (NSMutableArray *)sectionBluesSubBtnCellFourContentArr{
    if (!_sectionBluesSubBtnCellFourContentArr) {
        _sectionBluesSubBtnCellFourContentArr = [[NSMutableArray alloc]init];
    }
    return _sectionBluesSubBtnCellFourContentArr;
}
- (NSMutableArray *)sectionBluesSubBtnCellFiveContentArr{
    if (!_sectionBluesSubBtnCellFiveContentArr) {
        _sectionBluesSubBtnCellFiveContentArr = [[NSMutableArray alloc]init];
    }
    return _sectionBluesSubBtnCellFiveContentArr;
}
 
//
/**
 @property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfZhuangXiug;//  arr 存储 _装修情况
 @property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfHouseSheShi;//  arr 存储 _房间设施
 @property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfHouseLiangDian;//  arr 存储 _房间亮点
 @property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfYaoQiu;//  arr 存储 _出租要求*/
//_ _ _ _ _ _ _ _ _ _
- (NSMutableArray *)saveChooseIndexArrOfZhuangXiug{
    if (!_saveChooseIndexArrOfZhuangXiug) {
        _saveChooseIndexArrOfZhuangXiug = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfZhuangXiug;
}
- (NSMutableArray *)saveChooseIndexArrOfHouseSheShi{
    if (!_saveChooseIndexArrOfHouseSheShi) {
        _saveChooseIndexArrOfHouseSheShi = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfHouseSheShi;
}
- (NSMutableArray *)saveChooseIndexArrOfHouseLiangDian{
    if (!_saveChooseIndexArrOfHouseLiangDian) {
        _saveChooseIndexArrOfHouseLiangDian = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfHouseLiangDian;
}
- (NSMutableArray *)saveChooseIndexArrOfYaoQiu{
    if (!_saveChooseIndexArrOfYaoQiu) {
        _saveChooseIndexArrOfYaoQiu = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfYaoQiu;
}
//__
- (NSMutableArray *)saveChooseIndexArrOfGongGongSheShi{
    if (!_saveChooseIndexArrOfGongGongSheShi) {
        _saveChooseIndexArrOfGongGongSheShi = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfGongGongSheShi;
}
- (NSMutableArray *)saveChooseIndexArrOfFangWuSheShi{
    if (!_saveChooseIndexArrOfFangWuSheShi) {
        _saveChooseIndexArrOfFangWuSheShi = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfFangWuSheShi;
}
- (NSMutableArray *)saveChooseCodeArrOfRentdayType{
    if (!_saveChooseCodeArrOfRentdayType) {
        _saveChooseCodeArrOfRentdayType = [[NSMutableArray alloc]init];
    }
    return _saveChooseCodeArrOfRentdayType;
}
- (NSMutableArray *)saveChooseIndexArrOfRentdayType{
    if (!_saveChooseIndexArrOfRentdayType) {
        _saveChooseIndexArrOfRentdayType = [[NSMutableArray alloc]init];
    }
    return _saveChooseIndexArrOfRentdayType;
}
 


@end
