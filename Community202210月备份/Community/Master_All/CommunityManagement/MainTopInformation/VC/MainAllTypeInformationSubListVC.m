//
//  MainAllTypeInformationSubListVC.m
//  Community
//
//  Created by 余莹 on 2021/8/31.
//

#import "MainAllTypeInformationSubListVC.h"
#import "InformationOrScanGoToWebVc.h"

#import "ZYActivityApplyDetailVC.h"
#import "ZYOwnersVoteDetailVC.h"
#import "IssueHouseQianYueManagerVC.h"
#import "ZYBlockchainOrderEvidenceVC.h"
#import "MainAllTypeInformationSubPayMoneyTypeSubDataModel.h"

#import "MainAllTypeInformationSubListVcTableViewCell.h"
#define  MainAllTypeInformationSubListVcTableViewCell_Identifier     @"MainAllTypeInformationSubListVcTableViewCell"

#import "MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell.h"
#define MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier         @"MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell"
 

//车辆相关缴费详情跳转相关
#import "ZYParkingTemporaryDetailVC.h"
#import "ParkingPayInfoDetailVC.h"
//物业缴费详情相关
#import "LifeCostPropertyFeeInfoVcLate.h"

// 出入记录
#import "ZYAccessRecordVc.h"
 
//账单明细
#import "BillingListVC.h"
#import "BillingDetailVC.h"

//活动报名
#import "ActivityDetailVC.h"


/**
 1  车辆临时收费   2车辆月租收费   3物业缴费    4活动报名    5业主投票  6租房   8  房屋不需要跳转的推送消息  9 房屋需要跳转的推送消息，10房租租赁支付成功推送
 */
static NSString *PayOrder_ExData_Type_TempCar = @"1";//临时车
static NSString *PayOrder_ExData_Type_MonthCar = @"2";//月租车
static NSString *PayOrder_ExData_Type_WuYe = @"3"; //物业
static NSString *PayOrder_ExData_Type_Activity = @"4";//活动报名
static NSString *PayOrder_ExData_Type_UserVote = @"5";//业主投票
static NSString *PayOrder_ExData_Type_Contract = @"app_contract_Signing";//合同
static NSString *PayOrder_ExData_Type_House8 = @"8";//房屋
static NSString *PayOrder_ExData_Type_House9 = @"9";//房屋
static NSString *PayOrder_ExData_Type_House10 = @"10";//房屋租赁订单付款了的数据
 
static NSString *PayOrder_ExData_Type_AccessRecord = @"12";//出入记录
 
static NSString *PayOrder_ExData_Type_CommunityNoticeInfo = @"11";//物业通知的推送

static NSString *PayOrder_ExData_Type_FaceNoticeInfo = @"13";//人脸照片审核信息通知

 

@interface MainAllTypeInformationSubListVC ()
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation MainAllTypeInformationSubListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([ThemeManager shareManager].type == ThemeType_White) {
        self.tableView.backgroundColor = Y_RGB(240, 240, 245);
    }
    
    self.pageNum = 1;
    [self addRefresh];
    [self initRightNav];
    if (self.model.type == subDataModel_ShowType_Money) {//sectionHeaderv 不能悬停 需要用Grouped
        self.title = @"支付助手";
        self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
        self.tableView.estimatedSectionFooterHeight = 0.01;
        self.tableView.estimatedSectionHeaderHeight = 0.01;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.tableHeaderView = [UIView new];
        self.tableView.tableFooterView  = [UIView new];
        
    }
}
- (void)initRightNav{
    if (self.model.type == subDataModel_ShowType_Money) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [rightBtn setTitle:@"全部账单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItems:@[rightItem]];
    }
}
- (void)rightBtnAction{
    BillingListVC *vc = [[BillingListVC alloc]init];
    [self pushVc:vc];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
#pragma mark -  
//initImMessageListWithToUser
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

- (void)initData{//消息类型列表
    self.pageNum = 1;
    WEAKSELF
    [MainAllTypeImInfoData initImMessageListWithToUser:[TextShowWithModelStr textShowWithModelStr:self.model.to_user] withArrBlcok:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (arr.count >0 ) {
            weakSelf.pageNum += 1;
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[MainImInfoSubMsgModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (arr.count>=Y_PAGE_SIZE) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }else{
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
            });
        }
    }];
}
- (void)footerLoadMoreNewsData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    WEAKSELF
    
    [MainAllTypeImInfoData upDataImMessageListWithToUser:[TextShowWithModelStr textShowWithModelStr:self.model.to_user] withPageNum:self.pageNum withArrBlcok:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (arr.count >0 ) {
            weakSelf.pageNum += 1;
            [weakSelf.dataSourceArr addObjectsFromArray:[MainImInfoSubMsgModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

//20220609更改支付助手listUI
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.model.type == subDataModel_ShowType_Money) {
        return 44;  //公众号类型 + 且为支付类型
    }else{
        return 20;
    }
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.model.type == subDataModel_ShowType_Money) {
        //公众号类型 + 且为支付类型
        MainImInfoSubMsgModel *thisModel = self.dataSourceArr[section];
        NSString *timeIntervalStr = [TextShowWithModelStr textShowWithModelStr:thisModel.create_time];//@"1654755682572";//
        BOOL isThisDay = [ToolOfTimeChangeFormat checkIsThisDayWithTheDateStr:timeIntervalStr];
         NSString *showTimeStr = ( isThisDay ? [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"HH:mm"] : [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"YYYY/MM/dd"]);
    
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
        timeL.text = showTimeStr;
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.textColor = [ThemeManager shareManager].detailTextColor;
        timeL.font = [UIFont systemFontOfSize:12.0];
        return timeL;
    }else{
        return [UIView new];
    }
}

#pragma mark ==
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //--------公众号类型 + 且为支付类型
    if (self.model.type == subDataModel_ShowType_Money) {
       
           // return 3;
            return 2;//20220609更改
        
    }
    //_______ 其他
    MainImInfoSubMsgModel *model = self.dataSourceArr[section];//section
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
        //展示type==3暂时没得这个数据 用url做判断
        NSString *subDataModel_ShowType_TextAndUrlStr = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
        //暂时没有做url展示子类别的数据 用键值判断
        if ([subDataModel_ShowType_TextAndUrlStr containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [subDataModel_ShowType_TextAndUrlStr containsString:@"id"] && [subDataModel_ShowType_TextAndUrlStr containsString:@"mobile"]) {
          //绑定家属租客的确认
            return 2;
        }
        //展示type==3类型end
        if (subDataModel.type == subDataModel_ShowType_Money) {
//            return 3;  //公众号类型 + 且为支付类型
            return 2;//20220609更改
            
        }else if(subDataModel.type == subDataModel_ShowType_OnlyText){
            return 1; //普通文本类型
        }else if(subDataModel.type == subDataModel_ShowType_TextAndUrl){//房屋绑定家属类 row0文本row1跳转
            return 2; //普通文本类型
//        }else if(subDataModel.type == subDataModel_ShowType_OnlyText &&  ){//紧急通知类型
//            return 1; //普通文本类型
        }else{
            return 0;//暂无
        }
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //--------公众号类型 + 且为支付类型 0609改
    if (self.model.type == subDataModel_ShowType_Money) {
        if (indexPath.row==0) {
            return 160;
        } else {
            return 30;
        }
    }
    //_______ 其他
    MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];//section
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
        //展示type==3暂时没得这个数据 用url做判断
        NSString *subDataModel_ShowType_TextAndUrlStr = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
        //暂时没有做url展示子类别的数据 用键值判断
        if ([subDataModel_ShowType_TextAndUrlStr containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [subDataModel_ShowType_TextAndUrlStr containsString:@"id"] && [subDataModel_ShowType_TextAndUrlStr containsString:@"mobile"]) {
          //绑定家属租客的确认
            if (indexPath.row==0) {
                return [self onlyTextCellHeightWithSectionNum:indexPath.section];
            } else {
                return 30;
            }
        }
        //展示type==3类型end
        if (subDataModel.type == subDataModel_ShowType_Money) {  //公众号类型 + 且为支付类型
            if (indexPath.row==0) {
                return 160;
            } else {
                return 30;
            }
        }else if(subDataModel.type == subDataModel_ShowType_OnlyText){//普通文本类型
            return [self onlyTextCellHeightWithSectionNum:indexPath.section];
        }else if(subDataModel.type == subDataModel_ShowType_TextAndUrl){//房屋绑定家属类 row0文本row1跳转
            if (indexPath.row==0) {
                return [self onlyTextCellHeightWithSectionNum:indexPath.section];
            } else {
                return 30;
            }
        }else{
            return 0.1;
        }
    }else{
        return 0.1;
    }
}
//计算高度
- (CGFloat )onlyTextCellHeightWithSectionNum:(NSInteger)sectionNum{
    MainImInfoSubMsgModel *model = self.dataSourceArr[sectionNum];
    NSString *messagelistWillShowDetailText = @"";
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg] || [model.msg_type  isEqualToString: kWebSocketMsgTypeObj_Text])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        messagelistWillShowDetailText = [[dic allKeys]containsObject: kWebSocketMsgTypeObj_Content] ? [dic objectForKey:kWebSocketMsgTypeObj_Content] : [dic objectForKey:@"desc"];
    }
    //有分段
    NSArray *duanHangArr = [[NSArray alloc]initWithArray:[messagelistWillShowDetailText componentsSeparatedByString:@"\n"]];
    CGFloat contentAllH = 0.0;//内容str部分
    for (int i = 0; i < duanHangArr.count;i++ ) {
        NSString *oneHangStr = [NSString stringWithFormat:@"%@",duanHangArr[i]];
        CGFloat oneBaseHangH = 14;
        CGFloat oneBaseHangH_UseStr = [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32-20) withTextStr:oneHangStr withFont:[UIFont systemFontOfSize:14.0]];
        CGFloat oneH = (oneBaseHangH > oneBaseHangH_UseStr) ? oneBaseHangH : oneBaseHangH_UseStr;
        contentAllH += oneH;
       // NSLog(@"___oneHangStr = %@",oneHangStr)
    }
   // NSLog(@"___onlyTextCellHeightWithSectionNum section num=%ld text=%@  allH=%f",sectionNum,messagelistWillShowDetailText,contentAllH);
    //CGFloat cellH = (65 + [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32-20) withTextStr:messagelistWillShowDetailText withFont:[UIFont systemFontOfSize:14.0]]);
    return (65 +contentAllH);    
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //--------公众号类型 + 且为支付类型 0609改
    if (self.model.type == subDataModel_ShowType_Money) {
        return [self tableView:tableView moneyCellForRowAtIndexPath:indexPath];
    }
    //_______ 其他
    
    //支付类型
    /**
     data = "{\"sub_name\":\"\U6708\U79df\U7f34\U8d39\",\"pay_amount\":\"200\",\"title\":\"\U652f\U4ed8\U901a\U77e5\",\"type\":2,\"content\":\"\",\"url\":\"www.baidu.com\",\"sub_head_img_url\":\"www.baidu.com\",\"sub_im_id\":\"monthlyRentPayment\",\"appinfo\":{\"version\":\"1\"},\"currency\":\"RMB\",\"links\":[{\"url\":\"www.baidu.com\",\"desc\":\"\U67e5\U770b\U8d26\U5355\U8be6\U60c5\"}],\"pay_type\":\"\U5fae\U4fe1\U652f\U4ed8\",\"template_id\":\"\",\"desc\":\"\U623f\U5c4b\U7f34\U8d39\"}";
     */
    
    MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];//section
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
        //展示type==3暂时没得这个数据 用url做判断
        NSString *subDataModel_ShowType_TextAndUrlStr = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
        //暂时没有做url展示子类别的数据 用键值判断
        if ([subDataModel_ShowType_TextAndUrlStr containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [subDataModel_ShowType_TextAndUrlStr containsString:@"id"] && [subDataModel_ShowType_TextAndUrlStr containsString:@"mobile"]) {
          //绑定家属租客的确认
            return [self tableView:tableView textAndUrlCellForRowAtIndexPath:indexPath]; //普通文本类型
        }
        //展示type==3类型end
        
        if (subDataModel.type == subDataModel_ShowType_Money) { //公众号类型 + 且为支付类型
            return [self tableView:tableView moneyCellForRowAtIndexPath:indexPath];
            
        }else if(subDataModel.type == subDataModel_ShowType_OnlyText){
            return [self tableView:tableView onlytextCellForRowAtIndexPath:indexPath]; //普通文本类型
            
        }else if(subDataModel.type == subDataModel_ShowType_TextAndUrl){
            return [self tableView:tableView textAndUrlCellForRowAtIndexPath:indexPath]; //普通文本类型
        
        }else{
            return  nil;
        }
    }else{
        return nil;
    }
}

//20220609更改支付助手cellUI
- (UITableViewCell *)tableView:(UITableView *)tableView moneyCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //支付类型
        if (indexPath.row == 0) {
            MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate *cell = [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate_I];
            if (!cell) {
                cell = [[MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCellLate_I];
                cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
                [cell.showDetailBtn addTarget:self action:@selector(showDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.showDetailBtn.tag = 500+indexPath.section;
            [cell fillPayMoneyTypeDataWithModel:self.dataSourceArr[indexPath.section]];
            return cell;
    
        }else { //
            MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell_I];
            if (!cell) {
                cell = [[MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcPayTypeTableViewCell_I];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 36, 0, 36);
                cell.textLabel.font = [UIFont systemFontOfSize:12];
            }
           
            NSString *strOne = @"支付方式:";
            MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];
            NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
            MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
            NSString *strType = [TextShowWithModelStr textShowWithModelStr:subDataModel.pay_type];
            
            NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",strOne,strType]];
            NSRange range1 = NSMakeRange(0, strOne.length);
            NSRange range2 = NSMakeRange(strOne.length, strType.length);
            //
            NSDictionary* attributes1 = @{ NSForegroundColorAttributeName : [ThemeManager shareManager].detailTextColor  };
            NSDictionary* attributes2 = @{ NSForegroundColorAttributeName : [ThemeManager shareManager].mainTextColor  };
            [astring addAttributes:attributes1 range:range1];
            [astring addAttributes:attributes2  range:range2];
            cell.textLabel.attributedText = astring;
            return cell;
        }
}
- (void)showDetailBtnAction:(UIButton *)sender{
    NSInteger inx = sender.tag - 500;
    MainImInfoSubMsgModel *model = self.dataSourceArr[inx];
    NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
    MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
    
    //展示type==3暂时没得这个数据 用url做判断
    NSString *idStr = [NSString stringWithFormat:@"%ld",subDataModel.template_id];
    NSLog(@"showDetailBtnAction dataId =%@",idStr);
    //账单详情
    BillingDetailVC *vc = [[BillingDetailVC alloc]init];
    vc.idStr = idStr;
    [self pushVc:vc];
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView moneyCellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //支付类型
//    if (indexPath.row == 0) {
//        MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier];
//        if (!cell) {
//            cell = [[MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier];
//            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
//        }
//        [cell fillPayMoneyTypeDataWithModel:self.dataSourceArr[indexPath.section]];
//        return cell;
//
//    }else if (indexPath.row == 1){ //
//        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"desc"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"desc"];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
//            CGRect frame = accessoryImgView.frame;
//            frame.size.width = frame.size.width + 10;
//            accessoryImgView.frame = frame;
//            [accessoryImgView setContentMode:UIViewContentModeLeft];
//            cell.accessoryView = accessoryImgView;
//            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
//        }
//        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
//        cell.textLabel.font = [UIFont systemFontOfSize:12];
//        cell.textLabel.text = @"查看详情";
//        return cell;
//    }else{//row=2 支付上链
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyUpLink"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"moneyUpLink"];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
//            CGRect frame = accessoryImgView.frame;
//            frame.size.width = frame.size.width + 10;
//            accessoryImgView.frame = frame;
//            [accessoryImgView setContentMode:UIViewContentModeLeft];
//            cell.accessoryView = accessoryImgView;
//            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
//        }
//        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
//        cell.textLabel.font = [UIFont systemFontOfSize:12];
//        cell.textLabel.text = @"订单上链信息";
//        return cell;
//
//    }
//}

//查看详情cell
- (UITableViewCell *)tableView:(UITableView *)tableView lookDetailCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"desc"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"desc"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        CGRect frame = accessoryImgView.frame;
        frame.size.width = frame.size.width + 10;
        accessoryImgView.frame = frame;
        [accessoryImgView setContentMode:UIViewContentModeLeft];
        cell.accessoryView = accessoryImgView;
        cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
    }
    cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = @"查看详情";
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView onlytextCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //非好友类型的
    //文本类型（）
     MainAllTypeInformationSubListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationSubListVcTableViewCell_Identifier];
     if (!cell) {
         cell = [[MainAllTypeInformationSubListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MainAllTypeInformationSubListVcTableViewCell_Identifier];
         cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
     }
     [cell fillDataWithModel:self.dataSourceArr[indexPath.section]];
     return cell;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView textAndUrlCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self tableView:tableView onlytextCellForRowAtIndexPath:indexPath]; //普通文本类型
    }else{
        return [self tableView:tableView lookDetailCellForRowAtIndexPath:indexPath];
    }
}
#pragma mark - UITableViewDelegate

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
    MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];//section
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
        
        //展示type==3暂时没得这个数据 用url做判断
        NSString *subDataModel_ShowType_TextAndUrlStr = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
        //暂时没有做url展示子类别的数据 用键值判断
        if ([subDataModel_ShowType_TextAndUrlStr containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [subDataModel_ShowType_TextAndUrlStr containsString:@"id"] && [subDataModel_ShowType_TextAndUrlStr containsString:@"mobile"]) {
          //绑定家属租客的确认
            [self gotoBindFamileOrRentPersonWithStr:subDataModel_ShowType_TextAndUrlStr]; ////绑定家属租客的确认
            return;
        }
        //展示type==3类型end
        
        if (subDataModel.type == subDataModel_ShowType_Money  || subDataModel.type == subDataModel_ShowType_TextAndUrl) {
            //公众号类型 + 且为支付类型
            if (indexPath.row==1) {
                MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];//section
                //公众号类型 + 且为支付类型
                if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
                    NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
                    MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
                    NSString *url = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
                    
                    //暂时没有做url展示子类别的数据 用键值判断
                    if ([url containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [url containsString:@"id"] && [url containsString:@"mobile"]) {
                        [self gotoBindFamileOrRentPersonWithStr:url]; ////绑定家属租客的确认
                        return;
                    }else{
//
                    }
                    /**
                     static NSString *PayOrder_ExData_Type_TempCar = @"1";//临时车
                     static NSString *PayOrder_ExData_Type_MonthCar = @"2";//月租车
                     static NSString *PayOrder_ExData_Type_WuYe = @"3"; //物业
                     static NSString *PayOrder_ExData_Type_Activity = @"4";//活动报名
                     static NSString *PayOrder_ExData_Type_UserVote = @"5";//业主投票
                     static NSString *PayOrder_ExData_Type_Contract = @"app_contract_Signing";//合同
                     static NSString *PayOrder_ExData_Type_House8 = @"8";//房屋
                     static NSString *PayOrder_ExData_Type_House9 = @"9";//房屋
                     */
                    if (subDataModel.type == 2 ) {// // DLog(@" 公众号类型 + 且为支付类型 的URL == %@",url);
                        
                        //20220609支付助手更改
                        /**
                         MainImInfoSubMsgExtraDataModel *extraDataModel = model.extra_data;
                         NSString *exTypeStr = [TextShowWithModelStr textShowWithModelStr:extraDataModel.type];
                         NSString *pushWillUseId =  [TextShowWithModelStr textShowWithModelStr:extraDataModel.dataId];
                         NSString *pushWillUseOrderNum = [TextShowWithModelStr textShowWithModelStr:extraDataModel.orderNum];
                         
                         if ([exTypeStr isEqualToString:PayOrder_ExData_Type_TempCar]) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 ZYParkingTemporaryDetailVC *vc = [[ZYParkingTemporaryDetailVC alloc] init];
                                 vc.orderId = pushWillUseId;
                                 [self pushVc:vc];
                             });
                             
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_MonthCar] ){
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 ParkingPayInfoDetailVC *vc = [[ParkingPayInfoDetailVC alloc]init];
                                 vc.orderIdStr = pushWillUseId;
                                 [self pushVc:vc];
                             });
                             
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_WuYe] ){
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 LifeCostPropertyFeeInfoVcLate *vc = [[LifeCostPropertyFeeInfoVcLate alloc]init];
                                 vc.isDidPay = YES;
                                 vc.idStr = pushWillUseId;
                                 [self pushVc:vc];
                             });
                             
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_Activity] ){
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_UserVote] ){
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_Contract] ){
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_House8] ){
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_House9] ){
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_House10] ){//一支付过租房金钱了的订单数据
                             NSMutableArray *vcs = [NSMutableArray array];
                             for (UIViewController *vc in self.navigationController.viewControllers) {
                                 if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
                                     CommunityManagementMainVcLate *vcLate = (CommunityManagementMainVcLate *)vc;
                                     vcLate.isJumpMyRent = YES;
                                     [vcs addObject:vc];
                                 }
                             }
                             self.navigationController.viewControllers = [vcs copy];
                             
                         }else if ([exTypeStr isEqualToString:PayOrder_ExData_Type_FaceNoticeInfo] ){//人脸审核信息 仅供文本展示不需点击逻辑
                             
                         }else{
                             
                         }
                         return;
                         */
             
                   
                  
                        
                    }else if (subDataModel.type == 3){
                        DLog(@" 公众号类型 + 且为绑定家属 的URL == %@",url);
                        return;
                    }
                }
            }else if(indexPath.row == 2){//subDataModel_ShowType_Money 上链信息
               
                //20220609支付助手更改
             /**
              DLog(@"订单上链信息");
              ZYBlockchainOrderEvidenceVC *vc= [[ZYBlockchainOrderEvidenceVC alloc] init];
              MainImInfoSubMsgExtraDataModel *extraDataModel = model.extra_data;
              vc.orderId = extraDataModel.orderNum;
              [self pushVc:vc];
              */
            }
          
        }else if(subDataModel.type == subDataModel_ShowType_OnlyText){
             
            MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];
            MainImInfoSubMsgExtraDataModel *extraDataModel = model.extra_data;
            NSLog(@"type=%@",extraDataModel.type);
            if ([extraDataModel.type isEqual:@"4"]) { //活动报名
                //（旧版）ZYActivityApplyDetailVC ｜ 06中旬 ActivityDetailVC 新版
//                ZYActivityApplyDetailVC *vc = [[ZYActivityApplyDetailVC alloc] init]; vc.ID = extraDataModel.dataId;
                ActivityDetailVC *vc = [[ActivityDetailVC alloc] init];
                vc.infoIDStr = extraDataModel.dataId;
                [self pushVc:vc];
            }else if ([extraDataModel.type isEqual:@"5"]) { //业主投票
                ZYOwnersVoteDetailVC *vc = [[ZYOwnersVoteDetailVC alloc] init];
                vc.ID = extraDataModel.dataId;
                [self pushVc:vc];
            }else if ([extraDataModel.type isEqual:@"6"]) { //我的租赁
                NSMutableArray *vcs = [NSMutableArray array];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
                        CommunityManagementMainVcLate *vcLate = (CommunityManagementMainVcLate *)vc;
                        vcLate.isJumpMyRent = YES;
                        [vcs addObject:vc];
                    }
                }
                self.navigationController.viewControllers = [vcs copy];
            }else if ([extraDataModel.type isEqual:@"app_contract_Signing"]) { //签章合同管理
                NSMutableArray *vcs = [NSMutableArray array];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
                        CommunityManagementMainVcLate *vcLate = (CommunityManagementMainVcLate *)vc;
                        vcLate.isJumpContractManage = YES;
                        [vcs addObject:vc];
                    }
                }
                self.navigationController.viewControllers = [vcs copy];
 
            }else if ([extraDataModel.type isEqual:@"12"]) { //出入记录
                ZYAccessRecordVc *vc = [ZYAccessRecordVc alloc];
                [self pushVc:vc];
                
            }else if ( [extraDataModel.type isEqualToString:PayOrder_ExData_Type_CommunityNoticeInfo]){//社区紧急消息的通知类型

                UrgentInfoOrTopInfoDetailVC *vc = [[UrgentInfoOrTopInfoDetailVC alloc]init];
                vc.communityId =  [ShareUserInfo sharedUserInfo].commuityInfo.ID;//当前小区id
                vc.infoId = [extraDataModel.dataId integerValue];
                [self pushVc:vc];
            }else if ([extraDataModel.type isEqualToString:PayOrder_ExData_Type_FaceNoticeInfo] ){//人脸审核信息 仅供展示不需点击逻辑
            }else{
                //
                DLog(@"未跳转");
            }
        }else{
            DLog(@"未跳转");
        }
    }

}

//绑定家属租客的确认
- (void)gotoBindFamileOrRentPersonWithStr:(NSString *)result{
    NSString *getUrlStr = result;// 1021全部url判断后直接赋予给跳转页 不做拼接了 截取后只用来判断电话是本用户电话
    NSString *phoneS = @"";
    NSString *idStr = @"";
    //
    NSArray *resComOneArr = [result componentsSeparatedByString:@"?"];
    NSString *notBaseIsInfoStr =  [NSString stringWithFormat:@"%@",resComOneArr.lastObject];
    NSArray *resComTwoArr = [notBaseIsInfoStr componentsSeparatedByString:@"&"];
    NSString *idKeyObjStr = [NSString stringWithFormat:@"%@",resComTwoArr.firstObject];
    NSString *phoneKeyObjStr = [NSString stringWithFormat:@"%@",resComTwoArr.lastObject];
    //
    idStr = [NSString stringWithFormat:@"%@",([idKeyObjStr componentsSeparatedByString:@"="].lastObject)];
    phoneS = [NSString stringWithFormat:@"%@",([phoneKeyObjStr componentsSeparatedByString:@"="].lastObject)];
    //
   
    NSString *bindUserPhoneStr = phoneS;//@"18012345678";//
    //@"用户手机号与本数据不匹配，不能做绑定！" ｜｜消息列表 手机一定是匹配的|| 无需判断手机
    //实名
    if (!ZY_IsRealName) {
        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
        [self pushVc:vc];
        return;
    }
    //消息url只有id， 手机数据是id数据 需要重新处理
     bindUserPhoneStr = [TextShowWithModelStr textShowWithModelStr: [ShareUserInfo sharedUserInfo].userInfo.mobile ];
    
    InformationOrScanGoToWebVc *vc = [[InformationOrScanGoToWebVc alloc]init];
    /** 1021 不做每个键值的拼接 只做url的全部赋过去
     vc.infoIdStr = idStr;
     vc.phoneStr = bindUserPhoneStr;
     */
    vc.httpAllUseStr = getUrlStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];

}

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];//分割线颜色
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            separatoColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.01];//分割线颜色
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor=[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
//            lineLayer.backgroundColor = separatoColor.CGColor;
            lineLayer.backgroundColor = [ThemeManager shareManager].themeLineColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
@end
