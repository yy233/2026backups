//
//  ShopBuniessIssueOkVc.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "ShopBuniessIssueOkVc.h"
#import "IssueBaseTextFieldAndCanInputTableViewCell.h"
#import "IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.h"
#import "IssueBaseTextViewTableViewCell.h"
#import "IssueBaseSubBlueBtnsViewTableViewCell.h"
#import "PopViewBuniessShopChooseQiZuMainZu.h" //起租免租
//
#import "IssBuniessShopTagsViewModel.h"
#import "PopViewBuniessShopAndHouseChoosePayWayViewModel.h"
//
#import "IssueShopBuniessOkSendInfoViewModel.h"//提交

#define  IssueBaseTextFieldAndCanInputTableViewCell_Identifier                      @"IssueBaseTextFieldAndCanInputTableViewCell"
#define  IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier         @"IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell"
#define  IssueBaseTextViewTableViewCell_Identifier                                  @"IssueBaseTextViewTableViewCell"
#define  IssueBaseSubBlueBtnsViewTableViewCell_Identifier                           @"IssueBaseSubBlueBtnsViewTableViewCell"

//
#define RowNum_PayWay               0
#define RowNum_monthMoney           1
#define RowNum_transaferMoney       2
#define RowNum_QiZuMainZu           3
//
#define RowNum_title                0
#define RowNum_summarize            1
//
#define RowNum_nickname                 0
#define RowNum_mobile               1

//________________________________
//textView.tag
#define Tag_Cell_Sub_TextView_One          301
#define Tag_Cell_Sub_TextView_Two          302
//textField.tag __info
#define Tag_Cell_Sub_TextField_Money           400
#define Tag_Cell_Sub_TextField_TransferMoney   401
#define Tag_Cell_Sub_TextField_Name            402
#define Tag_Cell_Sub_TextField_PhoneNum        403

@interface ShopBuniessIssueOkVc () <IssueBaseSubBlueBtnsViewTableViewCellDelegate,PopViewBuniessShopAndHouseChoosePayWayDelegate,IssueBaseTextFieldAndCanInputTableViewCellDelegate,IssueBaseTextViewTableViewCellDelegate,PopViewBuniessShopChooseQiZuMainZuDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) PopViewBuniessShopAndHouseChoosePayWay *popViewPayWay;
@property (nonatomic,strong) PopViewBuniessShopChooseQiZuMainZu *popViewQiZuMainZu;
@property (nonatomic,strong) NSMutableArray *sectionOneTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionOneConcentArr;
@property (nonatomic,strong) NSMutableArray *sectionPersonTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionPersonConcentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellOneContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellTwoContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellThrContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellFourContentArr;
////
//@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfShopType;//model code
//@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfShopType;//index
// //商铺行业
//@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfShopIndustry;//model code
//@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfShopIndustry;//index
//配套设施
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfPeiTao;//model code
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfPeiTao;//index
//客流人群
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfKeLiu;//model code arr
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfKeLiu;//index

//起租免租
@property (nonatomic,strong) NSMutableArray *saveQiZuMainConcentNumArr;

@end

@implementation ShopBuniessIssueOkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商铺出租";
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
    @weakify(self);
    [IssBuniessShopTagsViewModel getIssueBuniessShopTagsWithBlock:^(NSDictionary * dic, BOOL success) {
        @strongify(self);
        NSArray *keyArr = [dic allKeys];//facility配套设施 people 客流人群
        if (success && keyArr.count>=2 && [keyArr containsObject:@"facility"] && [keyArr containsObject:@"people"]) {
            self.sectionBluesSubBtnCellOneContentArr = [NSMutableArray arrayWithArray:dic[@"facility"]];
            self.sectionBluesSubBtnCellTwoContentArr = [NSMutableArray arrayWithArray:dic[@"people"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==
- (void)footerOkBtnAction:(UIButton *)sender{
    
    if( self.shopBuniessModel.title.length < 10 ||  self.shopBuniessModel.title.length > 30 ){
        Y_SVP_SHOW_ERR_MES(@"房源概述字数不符合!");
        return;
    }
    //    self.shopBuniessModel
    self.shopBuniessModel.defrayType = self.sectionOneConcentArr[RowNum_PayWay];
    self.shopBuniessModel.monthMoney = self.sectionOneConcentArr[RowNum_monthMoney];
    self.shopBuniessModel.transferMoney = self.sectionOneConcentArr[RowNum_transaferMoney];       //转让费
    self.shopBuniessModel.startLease = [self.saveQiZuMainConcentNumArr.firstObject integerValue]; //起租
    self.shopBuniessModel.freeLease = [self.saveQiZuMainConcentNumArr.lastObject integerValue];   //免租
    if (self.shopBuniessModel.defrayType.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请选择押付方式");
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms = [NSMutableDictionary dictionaryWithDictionary:[self.shopBuniessModel mj_keyValues]];
    //    DLog(@"");
    //    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:[self.houseAllDataModel mj_keyValues]];
    if (self.shopBuniessModel.shopId != 0) {//修改数据属性
        [IssueShopBuniessOkSendInfoViewModel issueShopBuniessOkSendInfoChangeWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(ShopBuniessAddSuccess_Notice_Name);
                    [self popTwoVC];
                });
            }
        }];
    }else{
        [IssueShopBuniessOkSendInfoViewModel issueShopBuniessOkSendInfoWithParam:parms withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                Y_SVP_SHOW_SUCCESS_MES(@"成功提交！");
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(ShopBuniessAddSuccess_Notice_Name);
                    [self popTwoVC];
                });
            }
        }];
    }
   
}
//和房屋租赁修改更新的判段ID 不同
- (void)popTwoVC{
    if (self.shopBuniessModel.shopId != 0) {//修改数据属性
        dispatch_async(dispatch_get_main_queue(), ^{
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];//4
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -3)] animated:YES];
        });
   
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
        });
    }
   
}
#pragma mark ==========  协议 ==============
#pragma mark == 押付方式
- (void)popViewChoosePayWayModel:(PopViewBuniessShopAndHouseChoosePayWayModel *)model{
    self.sectionOneConcentArr[RowNum_PayWay] = [TextShowWithModelStr textShowWithModelStr:model.houseConstName];//未选择时是nil
    self.shopBuniessModel.defrayType = [TextShowWithModelStr textShowWithModelStr:model.houseConstName];
    [self.tableView reloadData];
}
#pragma mark == 配套设施 客流人群 数据多选 
- (void)cellTouchSubBlueBtnWithIndexArr:(NSMutableArray *)indexArr andCellType:(Cell_type_BlueBtn)type{
    switch (type) {
//        case Cell_type_BlueBtn_shopType:
//        {
//            [self seveShopBuniessChooseShopTypeIndex:indexArr];
//        }
//        case Cell_type_BlueBtn_shopIndustry:
//        {
//            [self seveShopBuniessChooseShopIndustryIndex:indexArr];
//        }
        case Cell_type_BlueBtn_facility:
        {//配套设施
            [self seveShopBuniessChoosePeiTaoIndex:indexArr];
        }
            break;
        case Cell_type_BlueBtn_people:
        {//客流人群
            [self seveShopBuniessChooseKeLiuIndex:indexArr];
        }
            break;
            
        default:
            break;
    }
}
//#pragma mark ——
//- (void)seveShopBuniessChooseShopTypeIndex:(NSMutableArray *)indexArr{
//    self.saveChooseIndexArrOfShopType= [[NSMutableArray alloc]initWithArray:indexArr];
//    self.saveChooseCodeArrOfShopType = [[NSMutableArray alloc]init];
//    for (int i = 0; i <indexArr.count; i++) {
//        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
//        NSDictionary *dic = self.sectionBluesSubBtnCellOneContentArr[chooseBlueItemIndex];//商铺的blue cell 没有做model
//        IssueBuniessShopTagsModel *chooseMode = [IssueBuniessShopTagsModel mj_objectWithKeyValues:dic];
//        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
//        [self.saveChooseCodeArrOfShopType addObject:@(chooseBlueCodeId)];
//        DLog(@" 配套  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
//    }
//    [self dealOneBlueCellSave];
//}
//- (void)dealOneBlueCellSave{
//    if (self.saveChooseCodeArrOfPeiTao.count>0) {
//        self.shopBuniessModel.shopTypeArr = self.saveChooseCodeArrOfShopType;
//    }else{
//        self.shopBuniessModel.shopTypeArr = [[NSMutableArray alloc]init];
//    }
//}
//
//#pragma mark ——
//- (void)seveShopBuniessChooseShopIndustryIndex:(NSMutableArray *)indexArr{
//    self.saveChooseIndexArrOfShopIndustry= [[NSMutableArray alloc]initWithArray:indexArr];
//    self.saveChooseCodeArrOfShopIndustry = [[NSMutableArray alloc]init];
//    for (int i = 0; i <indexArr.count; i++) {
//        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
//        NSDictionary *dic = self.sectionBluesSubBtnCellTwoContentArr[chooseBlueItemIndex];//商铺的blue cell 没有做model
//        IssueBuniessShopTagsModel *chooseMode = [IssueBuniessShopTagsModel mj_objectWithKeyValues:dic];
//        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
//        [self.saveChooseCodeArrOfShopIndustry addObject:@(chooseBlueCodeId)];
//        DLog(@" 配套  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
//    }
//    [self dealTwoBlueCellSave];
//}
//- (void)dealTwoBlueCellSave{
//    if (self.saveChooseCodeArrOfPeiTao.count>0) {
//        self.shopBuniessModel.shopInArr = self.saveChooseCodeArrOfShopType;
//    }else{
//        self.shopBuniessModel.shopInArr = [[NSMutableArray alloc]init];
//    }
//}


#pragma mark —— 配套设施
- (void)seveShopBuniessChoosePeiTaoIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfPeiTao= [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfPeiTao = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        NSDictionary *dic = self.sectionBluesSubBtnCellOneContentArr[chooseBlueItemIndex];//商铺的blue cell 没有做model
        IssueBuniessShopTagsModel *chooseMode = [IssueBuniessShopTagsModel mj_objectWithKeyValues:dic];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfPeiTao addObject:@(chooseBlueCodeId)];
        DLog(@" 配套  --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealPeiTaoBlueCellSave];
}
- (void)dealPeiTaoBlueCellSave{
    if (self.saveChooseCodeArrOfPeiTao.count>0) {
        self.shopBuniessModel.shopFacilityList = self.saveChooseCodeArrOfPeiTao;
    }else{
        self.shopBuniessModel.shopFacilityList = [[NSMutableArray alloc]init];
    }
}
#pragma mark —— 客流人群
- (void)seveShopBuniessChooseKeLiuIndex:(NSMutableArray *)indexArr{
    self.saveChooseIndexArrOfKeLiu = [[NSMutableArray alloc]initWithArray:indexArr];
    self.saveChooseCodeArrOfKeLiu = [[NSMutableArray alloc]init];
    for (int i = 0; i <indexArr.count; i++) {
        NSInteger chooseBlueItemIndex = [indexArr[i] intValue];
        NSDictionary *dic = self.sectionBluesSubBtnCellTwoContentArr[chooseBlueItemIndex];//商铺的blue cell 没有做model
        IssueBuniessShopTagsModel *chooseMode = [IssueBuniessShopTagsModel mj_objectWithKeyValues:dic];
        NSInteger chooseBlueCodeId = chooseMode.houseConstCode;
        [self.saveChooseCodeArrOfKeLiu addObject:@(chooseBlueCodeId)];
        DLog(@" 客流 --codeArr--- %ld ,%@ ,%ld",chooseBlueItemIndex ,chooseMode.houseConstName,chooseBlueCodeId);
    }
    [self dealKeLiuBlueCellSave];
}
- (void)dealKeLiuBlueCellSave{
    if (self.saveChooseCodeArrOfKeLiu.count>0) {
        self.shopBuniessModel.shopPeoples = self.saveChooseCodeArrOfKeLiu;
    }else{
        self.shopBuniessModel.shopPeoples = [[NSMutableArray alloc]init];
    }
}
#pragma mark ======  TextView 文本数据 delegate
- (void)cellTextViewTag:(NSInteger)tag withTextViewStr:(NSString *)textViewStr{
    if (tag == Tag_Cell_Sub_TextView_One) {//房源概括 10到30字
        self.shopBuniessModel.title = textViewStr;
    }
    if (tag == Tag_Cell_Sub_TextView_Two) {//房源描述
        self.shopBuniessModel.summarize = textViewStr;
    }
}
#pragma mark ======  TextField 文本数据 delegate
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)str{
    if (tag == Tag_Cell_Sub_TextField_Money) {
        self.sectionOneConcentArr[1] = str;
        //月租钱(待)处理
        self.shopBuniessModel.monthMoney = str;//[ doubleValue];
    }
    if (tag == Tag_Cell_Sub_TextField_TransferMoney) {
        self.sectionOneConcentArr[2] = str;
        //转出钱(待)处理
        self.shopBuniessModel.transferMoney = str;//[ doubleValue];
    }
    
    if (tag == Tag_Cell_Sub_TextField_Name) {
        self.sectionPersonConcentArr[0] = str;
        self.shopBuniessModel.nickname = str;
    }
    if (tag == Tag_Cell_Sub_TextField_PhoneNum) {
        self.sectionPersonConcentArr[1] = str;
        self.shopBuniessModel.mobile = str;
    }
    
}
#pragma mark ========================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == RowNum_PayWay) {
            [self choosePayWayAction];
        }
        if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){//一组最后一行 起租/免租
            [self chooseTimeAction];
        }
    }
}
#pragma mark ==== 押赴方式
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
#pragma mark ==== 起租免租
- (void)chooseTimeAction{
    [self.popViewQiZuMainZu showInView:self.view thePopViewSubViewHeight:0 WithArray:self.saveQiZuMainConcentNumArr];
}
// index 0 起租 1 免租
- (void)shopBuniessQiZuMainZuInfo:(NSMutableArray *)qiZuMianZuArr{
    self.saveQiZuMainConcentNumArr = [NSMutableArray arrayWithArray:qiZuMianZuArr];
    NSString *qiZuStr = [NSString stringWithFormat:@"%ld个月起租 ",[qiZuMianZuArr.firstObject integerValue]];
    NSString *mianZuStr = [NSString stringWithFormat:@"免租%ld个月",[qiZuMianZuArr.lastObject integerValue]];
    [self.sectionOneConcentArr replaceObjectAtIndex:RowNum_QiZuMainZu withObject:[qiZuStr stringByAppendingString:mianZuStr]];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }else{//   //第二组 蓝色
        return 2;
//        return self.sectionBluesSubBtnCellTitleArr.count;//1015更改 取消修改
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFView = [[UIView alloc]init];
    if ([ThemeManager shareManager].type == ThemeType_White) {
        sectionFView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;//空sectionFooter分割 普通vc色 浅主题为非白
    }else{
        sectionFView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
 
    return sectionFView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section==[tableView numberOfSections]-1) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderViewWithTextLabel *sectionV = [[SectionHeaderViewWithTextLabel alloc]init];
    sectionV.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    sectionV.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    if (section==0) {
        sectionV.titleLabel.text = @"租金详情";
    }else if (section==[tableView numberOfSections]-1){
        sectionV.titleLabel.text = @"联系人";
    }
    return sectionV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 || section==[tableView numberOfSections]-1) {
        return 40;
    }else{
        return 0.01;//没有heaerSectionText的高度
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 || indexPath.section==[tableView numberOfSections]-1) {
        return 50;
    }else if(indexPath.section==[tableView numberOfSections]-2){
        if (indexPath.row==0) {
            return 80;
        }else{
            return 120;
        }
    }else{
        //        return 80;//第二组 蓝色 高度待定 第一排80 空5+20+10+5+32
        float blueBtnOneHang = 40.0;
        if (indexPath.row==0) {
            NSInteger hangNum =  self.sectionBluesSubBtnCellOneContentArr.count/3 + ( self.sectionBluesSubBtnCellOneContentArr.count%3>0 ? 1 :0);
            if (hangNum<=1) {
                return 90;
            }else{
                return (hangNum-1)*blueBtnOneHang +20;
            }
        }else{
            NSInteger hangNum =  self.sectionBluesSubBtnCellTwoContentArr.count/3 + ( self.sectionBluesSubBtnCellTwoContentArr.count%3>0 ? 1 :0);
            if (hangNum<=1) {
                return 90;
            }else{
                return (hangNum-1)*blueBtnOneHang +40;
            }
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {//第一组
        if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
            if (!cell) {
                cell = [[IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell_Identifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if ([ThemeManager shareManager].type == ThemeType_Drak) {
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//skip
                }
            }
            cell.titleL.text = self.sectionOneTitleArr[indexPath.row];
            cell.textField.text = self.sectionOneConcentArr[indexPath.row];
            return cell;
        }else{
            IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
            cell.titleL.text = self.sectionOneTitleArr[indexPath.row];
            cell.textField.text = self.sectionOneConcentArr[indexPath.row];
            //月租金r1 转让费r2
            if (indexPath.row==1) {
                cell.textField.tag = Tag_Cell_Sub_TextField_Money;
            }else{
                cell.textField.tag = Tag_Cell_Sub_TextField_TransferMoney;
            }
            cell.delegale = self;
            return cell;
        }
    }else if (indexPath.section == [tableView numberOfSections]-1) {//最后一组
        IssueBaseTextFieldAndCanInputTableViewCell *cell = [[IssueBaseTextFieldAndCanInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseTextFieldAndCanInputTableViewCell_Identifier];
        cell.titleL.text = self.sectionPersonTitleArr[indexPath.row];
        cell.textField.text = self.sectionPersonConcentArr[indexPath.row];
        if (indexPath.row==0) {
            cell.textField.tag = Tag_Cell_Sub_TextField_Name;
        }else{
            cell.textField.tag = Tag_Cell_Sub_TextField_PhoneNum;
        }
        cell.delegale = self;
        return cell;
    }else if (indexPath.section == 2) {//描述文本组
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
    }else{//蓝色子subbtnView
        IssueBaseSubBlueBtnsViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueBaseSubBlueBtnsViewTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueBaseSubBlueBtnsViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueBaseSubBlueBtnsViewTableViewCell_Identifier];
        }
        cell.delegate = self;
        cell.titelL.text = self.sectionBluesSubBtnCellTitleArr[indexPath.row];
        /** 1015 修改停止
         Cell_type_BlueBtn_shopType,//商铺类型
         Cell_type_BlueBtn_shopIndustry,//商铺行业
         if (indexPath.row==0) {
             [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellOneContentArr andCellType:Cell_type_BlueBtn_shopType];
             [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfShopType];
         }else if(indexPath.row == 1){
             [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellOneContentArr andCellType:Cell_type_BlueBtn_shopIndustry];
             [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfShopIndustry];
         }else
         */
      if(indexPath.row == 0){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellOneContentArr andCellType:Cell_type_BlueBtn_facility];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfPeiTao];
        }else if(indexPath.row == 1){
            [cell showSubBtnWithDataSourceArr:self.sectionBluesSubBtnCellTwoContentArr andCellType:Cell_type_BlueBtn_people];
            [cell cellShowBtnTypeWithSelectedIndexArr:self.saveChooseIndexArrOfKeLiu];
        }else{
    
        }
        
        
        return cell;
    }
}

#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 44)];
        [_footerView.footerBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerOkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (PopViewBuniessShopAndHouseChoosePayWay *)popViewPayWay{
    _popViewPayWay = [[PopViewBuniessShopAndHouseChoosePayWay alloc]init];
    _popViewPayWay.payWayDelegate = self;
    return _popViewPayWay;;
}
- (PopViewBuniessShopChooseQiZuMainZu *)popViewQiZuMainZu{
    _popViewQiZuMainZu = [[PopViewBuniessShopChooseQiZuMainZu alloc]init];
    _popViewQiZuMainZu.delegate = self;
    return _popViewQiZuMainZu;
}
#pragma mark ===
- (NSMutableArray *)sectionOneTitleArr{
    if (!_sectionOneTitleArr) {
        _sectionOneTitleArr = [NSMutableArray arrayWithObjects:@"押付方式",@"月租金",@"转让费",@"起租/免租", nil];
    }
    return _sectionOneTitleArr;
}
- (NSMutableArray *)sectionOneConcentArr{
    if (!_sectionOneConcentArr) {
        _sectionOneConcentArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
    return _sectionOneConcentArr;
}
//
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
/**
 :@(7),@(8),@(16),@(17), nil];
 7    商铺类型
 8    商铺行业
 16    商铺配套设施
 17    商铺客流人群
 */
- (NSMutableArray *)sectionBluesSubBtnCellTitleArr{
    if (!_sectionBluesSubBtnCellTitleArr) {
        //        _sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"装修情况",@"公共设施",@"房间设施",@"对室友的期望",@"室友性别",nil];//合租
        _sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"配套设施",@"客流人群",nil];
//        _sectionBluesSubBtnCellTitleArr = [NSMutableArray arrayWithObjects:@"商铺类型",@"商铺行业",@"配套设施",@"客流人群",nil];
    }
    return _sectionBluesSubBtnCellTitleArr;
}
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

//起租免租数量存储
- (NSMutableArray *)saveQiZuMainConcentNumArr{
    if (!_saveQiZuMainConcentNumArr) {
        _saveQiZuMainConcentNumArr = [[NSMutableArray alloc]init];
    }
    return _saveQiZuMainConcentNumArr;
}
@end
