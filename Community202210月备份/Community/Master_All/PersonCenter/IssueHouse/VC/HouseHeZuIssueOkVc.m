//
//  HouseHeZuIssueOkVc.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "HouseHeZuIssueOkVc.h"
#import "IssueBaseSubBlueBtnsViewTableViewCell.h"
#define  IssueBaseSubBlueBtnsViewTableViewCell_Identifier                           @"IssueBaseSubBlueBtnsViewTableViewCell"
@interface HouseHeZuIssueOkVc () <IssueBaseSubBlueBtnsViewTableViewCellDelegate>

@end

@implementation HouseHeZuIssueOkVc
- (void)viewDidLoad {
    self.sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"装修情况",@"公共设施",@"房间设施",@"对室友的期望",@"室友性别",@"",nil];
    [super viewDidLoad];
  
}
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
        [IssueHouseOkSendInfoViewModel issueHouseSendHeZuWithChangeParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                    [self popTwoVC];
                });
            }
        }];
    }else{//新增数据属性
        [IssueHouseOkSendInfoViewModel issueHouseSendHeZuWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
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
    switch (type) {
        case Cell_type_BlueBtn_HouseAllType18:
            DLog(@"装修 arr=%@",indexArr);
            [self saveHouseZhuangXiuChooseDataIndex:indexArr];//bluecell选择的数组 num元素
            break;
        case Cell_type_BlueBtn_HouseAllType23:
            DLog(@"家具设施 arr=%@",indexArr);
            [self saveGoneGongSheShiChooseDataIndex:indexArr];//公共设施
            break;
        case Cell_type_BlueBtn_HouseAllType24:
            DLog(@"房间设施 arr=%@",indexArr);
            [self saveFangWuSheShiChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType20:
            DLog(@"室友性别 arr=%@",indexArr);
            [self saveHouseQiWangChooseDataIndex:indexArr];
            break;
        case Cell_type_BlueBtn_HouseAllType22:
            DLog(@"对室友的期望 arr=%@",indexArr);
            [self saveGenderChooseDataIndex:indexArr];
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
#pragma mark —— 室友期望
- (void)saveHouseQiWangChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfQiWang = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfQiWang = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFourContentArr[chooseBlueItemIndex];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfQiWang addObject:@(chooseBlueCodeId)];
        DLog(@" 期望  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealFourBlueCellSave];
}
- (void)dealFourBlueCellSave{
    if (self.saveChooseCodeArrOfHouseLiangDian.count>0) {
        self.houseAllDataModel.houseAdvantageCode = self.saveChooseCodeArrOfHouseLiangDian;
    }else{
        self.houseAllDataModel.houseAdvantageCode = @[];
    }
}
#pragma mark —— 性别 ___当前用文本
- (void)saveGenderChooseDataIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfGender = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfGender = [[NSMutableArray alloc]init];
//    for (int i = 0; i <indexArr.count; i++) {//code
//        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
//        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFiveContentArr[chooseBlueItemIndex];
//        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
//        [self.saveChooseCodeArrOfGender addObject:@(chooseBlueCodeId)];
//        DLog(@" 出租要求  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
//    }
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        IssueHouseCellBlueSubBtnCellModel *chooseMode = self.sectionBluesSubBtnCellFiveContentArr[chooseBlueItemIndex];
        NSString *genderStr = chooseMode.houseConstName;
        [self.saveChooseCodeArrOfGender addObject:genderStr];//暂时不存codenum
    }
    [self dealFiveBlueCellSave];
    
}
- (void)dealFiveBlueCellSave{
    if (self.saveChooseCodeArrOfGender.count>0) {
        self.houseAllDataModel.roommateSex = self.saveChooseCodeArrOfGender.firstObject;
    }else{
        self.houseAllDataModel.roommateSex = @"不限";
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
    if (self.type == IssueHouse_Type_HeZu) {
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
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFourContentArr andCellType:Cell_type_BlueBtn_HouseAllType22];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfQiWang];
        }else if (indexPath.row == 4){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellFiveContentArr andCellType:Cell_type_BlueBtn_HouseAllType20];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfGender];
        }else {
        }
    }
    return cell;
}
 

@end
