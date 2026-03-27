//
//  HouseDanJianIssueOkVc.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "HouseDanJianIssueOkVc.h"
#import "IssueBaseSubBlueBtnsViewTableViewCell.h"
#define  IssueBaseSubBlueBtnsViewTableViewCell_Identifier                           @"IssueBaseSubBlueBtnsViewTableViewCell"

@interface HouseDanJianIssueOkVc () <IssueBaseSubBlueBtnsViewTableViewCellDelegate>

@end

@implementation HouseDanJianIssueOkVc

- (void)viewDidLoad {
    self.sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"装修情况",@"公共设施",@"房间设施",@"房屋亮点",@"出租要求",@"",nil];//初始名字 后续大类名字由数据来更改
    [super viewDidLoad];
  
}
#pragma mark ==
#pragma mark ==
- (void)footerOkBtnAction{
    self.houseAllDataModel.houseUnit = @"月";
    DLog(@"");
  
    if( self.houseAllDataModel.houseTitle.length < 10 ||  self.houseAllDataModel.houseTitle.length > 30 ){
        Y_SVP_SHOW_ERR_MES(@"房源概述字数不符合!");
        return;
    }
    if (self.saveChooseIndexArrOfZhuangXiug.count==0) {
        Y_SVP_SHOW_ERR_MES(@"请选择房屋装修情况！");
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:[self.houseAllDataModel mj_keyValues]];
    if (self.houseAllDataModel.ID != 0) {//修改数据属性
        [IssueHouseOkSendInfoViewModel issueHouseSendDanJianChangeWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                    [self popTwoVC];
                });
            }
        }];
    }else{//新增数据属性
        [IssueHouseOkSendInfoViewModel issueHouseSendDanJianWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                    [self popTwoVC];
                });
            }
        }];
    }
}
#pragma mark == cell sub btn selected 圆圈类型 各个type选择的arr
- (void)cellTouchSubBlueBtnWithIndexArr:(NSMutableArray *)indexArr andCellType:(Cell_type_BlueBtn)type{
    //___
    //                        18    装修情况
    //                        23    公共设施
    //                        24    房间设施
    //                        14    租房预约日期--待增
    //                        21    出租要求
    switch (type) {//
        case Cell_type_BlueBtn_HouseAllType18:
            DLog(@"装修 arr=%@",indexArr);
            [self saveHouseZhuangXiuChooseDataIndex:indexArr];//bluecell选择的数组 num元素
            break;
        case Cell_type_BlueBtn_HouseAllType23:
            DLog(@" 公共设施 arr=%@",indexArr);
            [self saveGoneGongSheShiChooseDataIndex:indexArr];//公共设施
            break;
        case Cell_type_BlueBtn_HouseAllType24:
            DLog(@"房间设施 arr=%@",indexArr);
            [self saveFangWuSheShiChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType14:
            DLog(@"租房预约日期 arr=%@",indexArr);
            [self saveHouseRentDayTypeChooseDataIndex:indexArr]; 
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
 13  houseFurnitureCode []  整租才会用到
 23  commonFacilitiesCode [] 公共设施   合租/单间
 24  roomFacilitiesCode [] 房间设施   合租/单间
 4    houseAdvantageCode []  房屋亮点  整租/单间
 */
#pragma mark —— 日期 同装修一样是单选
- (void)saveHouseRentDayTypeChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfRentdayType = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfRentdayType = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFourContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfRentdayType addObject:@(chooseBlueCodeId)];
        DLog(@" 日期类型 --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealDayTypeBlueCellSave];//Four
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
#pragma mark —— 房间设施 公共+家具=== 13总的=23+24
- (void)saveGoneGongSheShiChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfGongGongSheShi = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfGongGongSheShi = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellTwoContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfGongGongSheShi addObject:@(chooseBlueCodeId)];
        DLog(@"23 公共设施  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealTwoBlueCellSave];
}
- (void)dealTwoBlueCellSave{
    if (self.saveChooseCodeArrOfGongGongSheShi.count>0) {
        self.houseAllDataModel.commonFacilitiesCode = self.saveChooseCodeArrOfGongGongSheShi;
    }else{
        self.houseAllDataModel.commonFacilitiesCode = @[];
    }
}
- (void)saveFangWuSheShiChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfFangWuSheShi = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfFangWuSheShi = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellThrContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfFangWuSheShi addObject:@(chooseBlueCodeId)];
        DLog(@"24 房屋设施  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealThrBlueCellSave];
}
- (void)dealThrBlueCellSave{
    if (self.saveChooseCodeArrOfFangWuSheShi.count>0) {
        self.houseAllDataModel.roomFacilitiesCode = self.saveChooseCodeArrOfFangWuSheShi;
    }else{
        self.houseAllDataModel.roomFacilitiesCode = @[];
    }
}
//#pragma mark —— 房间亮点
//- (void)saveHouseLiangDianChooseDataIndex:(NSMutableArray *)indexArr{
//    self.saveChooseIndexArrOfHouseLiangDian = [[NSMutableArray alloc]initWithArray:indexArr];
//    self.saveChooseCodeArrOfHouseLiangDian = [[NSMutableArray alloc]init];
//    for (int i = 0; i <indexArr.count; i++) {
//        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
//        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFourContentArr[chooseBlueItemIndex];
//        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
//        [self.saveChooseCodeArrOfHouseLiangDian addObject:@(chooseBlueCodeId)];
//        DLog(@" 房间亮点  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
//    }
//    [self dealFourBlueCellSave];
//}
//- (void)dealFourBlueCellSave{
//    if (self.saveChooseCodeArrOfHouseLiangDian.count>0) {
//        self.houseAllDataModel.houseAdvantageCode = self.saveChooseCodeArrOfHouseLiangDian;
//    }else{
//        self.houseAllDataModel.houseAdvantageCode = @[];
//    }
//}
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
    if (self.saveChooseCodeArrOfYaoQiu.count>0) {
        self.houseAllDataModel.leaseRequireCode = self.saveChooseCodeArrOfYaoQiu;
    }else{
        self.houseAllDataModel.leaseRequireCode = @[];
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
    
    if (self.type == IssueHouse_Type_DanJian) {
        //                        18    装修情况
        //                        23    公共设施
        //                        24    房间设施
        //                        14    租房预约日期--待增
        //                        21    出租要求
        if (indexPath.row==0) {
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellOneContentArr andCellType:Cell_type_BlueBtn_HouseAllType18];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfZhuangXiug];
        }else if (indexPath.row == 1){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellTwoContentArr andCellType:Cell_type_BlueBtn_HouseAllType23];//Cell_type_BlueBtn_HouseAllType23 Cell_type_BlueBtn_HouseAllType13
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfGongGongSheShi];//
        }else if (indexPath.row == 2){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellThrContentArr andCellType:Cell_type_BlueBtn_HouseAllType24];//Cell_type_BlueBtn_HouseAllType24
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfFangWuSheShi];//
        }else if (indexPath.row == 3){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFourContentArr andCellType:Cell_type_BlueBtn_HouseAllType14];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfRentdayType];
        }else if (indexPath.row == 4){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFiveContentArr andCellType:Cell_type_BlueBtn_HouseAllType21];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfYaoQiu];
        }else {
        }
    }
  /**
   case IssueHouse_Type_ZhengZu:
       arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr13,arr19,arr21, nil];
       break;
   case IssueHouse_Type_DanJian:
       arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr13,arr13,arr19,arr21, nil];
       break;
   case IssueHouse_Type_HeZu:
       arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr13,arr13,arr22,arr20, nil];
       break;
   default:
       arrWillBlock = [[NSMutableArray alloc]initWithObjects:@[],@[],@[],@[],@[], nil];
       break;*/
    //(self.type == Cell_type_BlueBtn_HouseAllType21 || self.type == Cell_type_BlueBtn_HouseAllType20 || self.type == Cell_type_BlueBtn_HouseAllType19 || self.type == Cell_type_BlueBtn_HouseAllType18 || self.type == Cell_type_BlueBtn_HouseAllType13 ||self.type == Cell_type_BlueBtn_HouseAllType12 ||self.type == Cell_type_BlueBtn_HouseAllType11)
    return cell;
}

@end
