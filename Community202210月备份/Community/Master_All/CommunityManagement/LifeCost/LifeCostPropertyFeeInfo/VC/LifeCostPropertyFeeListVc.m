//
//  LifeCostPropertyFeeListVc.m
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import "LifeCostPropertyFeeListVc.h"

@interface LifeCostPropertyFeeListVc () <UITableViewDelegate,UITableViewDataSource,LifeCostPropertyFeeListVcTopViewDelegate,LifeCostPropertyFeeListVcBottomPayInfoViewDelegate,BasePopTableViewChooseDelegate,IssuLastAddressCellSubBasePopViewDelegate>


@end

@implementation LifeCostPropertyFeeListVc
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业缴费";//0708暂时合并测试 合并完 yy 拉取maste
    self.payMoeyNumDouble = 0.000;
    self.payOrderIdArrs = [[NSMutableArray alloc]init];
    self.saveThisVcUseCommuityInfo = [[ShareUserInfo sharedUserInfo].commuityInfo mutableCopy];
    //NSLog(@"1主 %@ | %@  \n  从 %@ | %@",[ShareUserInfo sharedUserInfo].commuityInfo.name,[ShareUserInfo sharedUserInfo].commuityInfo, self.saveThisVcUseCommuityInfo.name,self.saveThisVcUseCommuityInfo);
   
    /**
     0406改版 用基础的typestr **/
    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL succes, BOOL isShowBool) {
        if (succes && isShowBool) {
            self.popViewPayTypeChooseListTextArr = [PayBaseInfo share].payTypeStrArr;
        }else{
            self.popViewPayTypeChooseListTextArr = [PayBaseInfo share].payTypeStrArr_HidenWX;
        }
    }];
 
    
    [self addNoticeOfPay];
    [self initView];
    [self initData];
    [self addRefresh];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithMainColor];//防止实名流程后nav变色
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"end 主 %@ | %@  \n  从 %@ | %@",[ShareUserInfo sharedUserInfo].commuityInfo.name,[ShareUserInfo sharedUserInfo].commuityInfo, self.saveThisVcUseCommuityInfo.name,self.saveThisVcUseCommuityInfo);

}
- (void)initView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , Screen_W, 50)];
    [self.view addSubview:self.bottomView];
    //
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(0);
        make.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(0);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.bottom.equalTo(_bottomView.superview).offset(-KIndicatorHeight);
        make.height.offset(50);
    }];
    self.bottomView.hidden = YES;
    self.selfViewStaus = LifeCostPropertyFeeListVcTopView_Staus_NoPay;
}
#pragma mark === top delegate
- (void)chooseStaussIndexWithStaus:(LifeCostPropertyFeeListVcTopView_Staus)staus{
    self.selfViewStaus = staus;
    [self initData];//刷新列表
    if ( self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed) {//已支付的列表 不显示bottomv
        self.bottomView.hidden = YES;//隐藏
    }
}

#pragma mark ===
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
#pragma mark ===
- (void)upTopAddressBtnUI{
    [self.topView.addressBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithModelStr:self.saveThisVcUseCommuityInfo.name]];
    [self.topView.addressBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5.0];
}
- (void)initData{
    WEAKSELF
    [self upTopAddressBtnUI];//切小区时 UI刷新一下
    
    NSInteger statusInt =   self.selfViewStaus;//0 1 //1019 状态字段status 改为 orderStatus
//    NSString *urlStr = [NSString stringWithFormat:@"proprietor/FinanceOrder/list?communityId=%ld&orderStatus=%ld",self.saveThisVcUseCommuityInfo.ID,statusInt];
    NSString *urlStr = [NSString stringWithFormat:@"proprietor/FinanceOrder/list?houseID=%ld&orderStatus=%ld",self.saveThisVcUseCommuityInfo.ID,statusInt];

    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:urlStr withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[LifeCostWuyeJiaofeiListModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                [self initChooseData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}

- (void)initChooseData{
    [self.chooseSectionSaveArr removeAllObjects];
//    [self.chooseRowSaveArr removeAllObjects];
    self.allChooseType = NO;
    for (int i = 0; i < self.dataSourceArr.count; i ++) {
        [self.chooseSectionSaveArr addObject:@(0)];
    }
}
 
- (void)topAddressBtnTouchAction{//切换社区
    [SVProgressHUD showWithStatus:@"正在加载社区信息"];[SVProgressHUD dismissWithDelay:15.0];
    [UserHouseOrCommunityListModel getUerAllCommunityListWithBlock:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            if (arr.count<=0) {//默认数据切换掉 都能切换1102去掉《=1的限制 改为〈=0的判断数据（1个小区也能切，后台数据返回有误时也能使用本处进行切换，在用户有小区时 返回测试小区的数据情况）
                Y_SVP_SHOW_INFO_MES(@"暂无可切换的小区");
                return;//不做切换
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewWithChangeCommunity showInViewWithPopType:IssuLastAddressCellSubBasePopView_Type_Community withListArray:arr.mutableCopy];
            });
        }
    }];
    
}

#pragma mark ===   IssuLastAddressCellSubBasePopViewDelegate 切换社区popv 协议
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic{
    NSInteger communityId = [[dic allKeys]containsObject:@"id"] ? [[dic objectForKey:@"id"] integerValue] :1;
    NSString *communityName = [[dic allKeys]containsObject:@"name"] ? [dic objectForKey:@"name"] : @"暂无认证小区";
    self.saveThisVcUseCommuityInfo.ID = communityId;
    self.saveThisVcUseCommuityInfo.name = communityName;
    [self initData];
}
#pragma mark ==  UI

//社区切换
- (PopViewWithChangeCommunity *)popViewWithChangeCommunity{
    _popViewWithChangeCommunity = [[PopViewWithChangeCommunity alloc]init];
    _popViewWithChangeCommunity.delegate = self;
    return _popViewWithChangeCommunity;
}

- (LifeCostPropertyFeeListVcTopView *)topView{
    if (!_topView) {
        _topView = [[LifeCostPropertyFeeListVcTopView alloc]initWithFrame:CGRectZero];
        _topView.delegate = self;
    }
    return _topView;
}
- (LifeCostPropertyFeeListVcBottomPayInfoView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LifeCostPropertyFeeListVcBottomPayInfoView alloc]initWithFrame:CGRectZero];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

#pragma mark ===
- (UITableView *)tableView{
    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
 
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[section];
    return model.list.count*2;//(日期info+物业money 两个cell为一个数据)
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
    view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
    LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell *cell = [[LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sectionHeader"];
    LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[section];
    cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.roomName];
    cell.topRightChooseBtn.tag = Btn_Tag_Section + section;
    [cell.topRightChooseBtn addTarget:self action:@selector(sectionChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.topRightChooseBtn.selected =  [self.chooseSectionSaveArr[section] boolValue];//是否选择的btn显示状态
    [view addSubview:cell];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
 
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[indexPath.section];
    LifeCostWuyeModel *wuyeModel = model.list[indexPath.row/2];

    if (indexPath.row%2 != 0) {
        LifeCostPropertyFeeListVcNomalWuYeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPropertyFeeListVcNomalWuYeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier];
            //金额 用同色做右边内缩
            UIImage *zeroImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor] width:10 height:10];
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:zeroImg];
            cell.accessoryView = accessoryImgView;
        }
        [cell fillRiseName:[TextShowWithModelStr textShowWithModelStr:wuyeModel.rise]  andMoeny:wuyeModel.totalMoney];
        return cell;
    }else{//时间
        LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell_Identifier];
            //右边内缩 直接用图片会被拉变形 用view
            UIImage *grayImg =[UIImage imageNamed:@"rightSkip"];
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:grayImg];
            accessoryImgView.frame = CGRectMake(0, 0, grayImg.size.width, 10);
            accessoryImgView.contentMode = UIViewContentModeScaleAspectFit;
            //
            UIView *allView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
            [allView addSubview:accessoryImgView];
            cell.accessoryView = allView;
        }
        
        cell.titleL.text = [ToolOfTimeChangeFormat timeGetZNFormatWithLineTimeStr:[TextShowWithModelStr textShowWithModelStr:wuyeModel.beginTime]]; //20220420 改成开始时间做成年月展示数据
        cell.detailTextLabel.text = @"查看详情";
        cell.topRightChooseBtn.tag = Btn_Tag_Row + indexPath.section*100 + (indexPath.row/2);//tag1000千位 section百位数（9位可用） row（99数量内可用）
        [cell.topRightChooseBtn addTarget:self action:@selector(rowChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.topRightChooseBtn.selected = wuyeModel.isChooseSelectedType;//是否选择的btn显示状态
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[indexPath.section];
        LifeCostWuyeModel *wuyeModel = model.list[indexPath.row/2];
        LifeCostPropertyFeeInfoVcLate *vc = [[LifeCostPropertyFeeInfoVcLate alloc]init];
        if (self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed) {//已支付的列表 不显示bottomv 详情数据获取用的键值不一样
            vc.isDidPay = YES;
            vc.idStr = wuyeModel.tripartiteOrder;
        }else{
            vc.isDidPay = NO;
            vc.idStr = wuyeModel.idStr;
        }
  
        [self pushVc:vc];
    }
   
     

}
#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];//分割线颜色
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
        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = separatoColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

#pragma mark ==  选择相关viewdata
- (NSMutableArray *)chooseSectionSaveArr{
    if (!_chooseSectionSaveArr) {
        _chooseSectionSaveArr = [[NSMutableArray alloc]init];
    }
    return _chooseSectionSaveArr;
}

#pragma mark ==
- (void)sectionChooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSNumber *chooseNum = @0;
    if (sender.selected) {
        chooseNum = @1;
    }else{
        chooseNum = @0;
    }
    //section替换
    NSInteger chooseSectionIndex = (sender.tag-Btn_Tag_Section);
    [self.chooseSectionSaveArr replaceObjectAtIndex:chooseSectionIndex withObject:chooseNum];
    //modelist 直接做替换
    LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[chooseSectionIndex];
    for (LifeCostWuyeModel *wuyeModel  in model.list) {
        wuyeModel.isChooseSelectedType = [chooseNum boolValue];
    }
    [self.tableView reloadData];
    [self chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney];
   
}
- (void)rowChooseBtnAction:(UIButton *)sender{//row是两行 用1个数据 ， tag row是除了 再赋值的
    sender.selected = !sender.selected;
    NSNumber *chooseNum = @0;
    if (sender.selected) {
        chooseNum = @1;
    }else{
        chooseNum = @0;
    }
    //  cell.topRightChooseBtn.tag = Btn_Tag_Row + indexPath.section*100 + (indexPath.row/2);//tag1000千位 section百位数（9位可用） row（99数量内可用）
    NSInteger chooseSectionIndex = (sender.tag-Btn_Tag_Row)/100;
    NSInteger chooseRowIndex = (sender.tag-Btn_Tag_Row)%100;
    
    //modelist 做替换
    LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[chooseSectionIndex];
    BOOL thisSectionSubRowAllIsSelected = YES;//本组是否全部都是已选择状态了
    for (int i = 0 ; i < model.list.count; i ++) {
        LifeCostWuyeModel *wuyeModel = model.list[i];
        if (i == chooseRowIndex) {
            wuyeModel.isChooseSelectedType = [chooseNum boolValue];
        }
        if ( wuyeModel.isChooseSelectedType == NO) {//只要有一个row不是选择状态 则section no
            thisSectionSubRowAllIsSelected = NO;
        }
    }
    //判断后 section替换
    [self.chooseSectionSaveArr replaceObjectAtIndex:chooseSectionIndex withObject:[NSNumber numberWithBool:thisSectionSubRowAllIsSelected]];
    [self.tableView reloadData];
    [self chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney];
}
#pragma mark === bottom view
//点击数据更新后 更新bottom的数据
- (void)chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney{
    if ( self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed) {//已支付的列表 不显示bottomv
        self.bottomView.hidden = YES;//隐藏
        return;
    }
    
    BOOL bottomViewIsShow = NO;
    double allMoney = 0.0;
    [self.payOrderIdArrs removeAllObjects];
    
    for (int i = 0; i < self.dataSourceArr.count; i ++) {
        LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[i];
        for (LifeCostWuyeModel *wuyeModel  in model.list) {
            if ( wuyeModel.isChooseSelectedType==YES) {
                allMoney += wuyeModel.totalMoney;//累加钱
                bottomViewIsShow = YES;//只要有选择 就显示bottomv
                [self.payOrderIdArrs addObject:wuyeModel.idStr];//订单的ID处理
            }
        }
    }
    [self.bottomView fillBottomViewAllMoney:allMoney];
    self.bottomView.hidden = !bottomViewIsShow;
}

#pragma mark == LifeCostPropertyFeeListVcBottomPayInfoViewDelegate
 
//bottom全选按钮
- (void)bottomViewTouchAllChooseBtnWithSelectedBool:(BOOL)selectedBool{

    for (int i = 0; i < self.dataSourceArr.count; i ++) {
        [self.chooseSectionSaveArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:selectedBool]];
        LifeCostWuyeJiaofeiListModel *model = self.dataSourceArr[i];
        for (LifeCostWuyeModel *wuyeModel  in model.list) {
            wuyeModel.isChooseSelectedType = selectedBool;
        }
    }
    [self.tableView reloadData];
    [self chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney];
}

- (void)bottomViewTouchPayBtnWithMoneyNum:(double)moneyN{
    NSLog(@"    支付     --------------------  支付   %0.2f",moneyN);
    self.payMoeyNumDouble = moneyN;
    [self choosePayType];
}
#pragma mark ============================  //支付
- (NSMutableDictionary *)parmsDicUseWillSendAdd{
    if (!_parmsDicUseWillSendAdd) {
        _parmsDicUseWillSendAdd = [[NSMutableDictionary alloc]init];
    }
    return _parmsDicUseWillSendAdd;
}
#pragma mark ==
- (PopViewChooseLifeCostChoosePayType *)PopViewPayTypeChoose{
    _PopViewPayTypeChoose = [[PopViewChooseLifeCostChoosePayType alloc]init];
    _PopViewPayTypeChoose.delegate = self;
    return _PopViewPayTypeChoose;
}
- (NSMutableArray *)popViewPayTypeChooseListTextArr{
    if (!_popViewPayTypeChooseListTextArr) {
        _popViewPayTypeChooseListTextArr = [[NSMutableArray alloc]init];
    }
    return _popViewPayTypeChooseListTextArr;
}
- (void)choosePayType{//GotoRealNameAuthenticationCardVcTool 也可在这里写判断实名
    [self.PopViewPayTypeChoose showInView:self.view thePopViewTableViewHeight:0 WithArray:self.popViewPayTypeChooseListTextArr];
}
#pragma mark == 选择付款类型
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    NSString *payTypeStr = self.popViewPayTypeChooseListTextArr[indexPath.row];
    NSLog(@" payTypeStr = %@",payTypeStr);
    
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            
            if ([self.popViewPayTypeChooseListTextArr containsObject:@"微信"]) {
                
                switch ( [ [PayBaseInfo share].payTypeStrIndexArr[indexPath.row] intValue ] ) {
                    case PayBaseInfo_TypeIndex_ZFB:
                        [weakSelf goZFBPay];
                        break;
                    case PayBaseInfo_TypeIndex_WeChat:
                        [weakSelf goWeChatPay];
                        break;
                    default:
                        NSLog(@"选择付款类型");
                        break;
                }
            }else{
                switch ( [ [PayBaseInfo share].payTypeStrIndexArr_HidentWeChat[indexPath.row] intValue ] ) {
                    case PayBaseInfo_TypeIndex_ZFB:
                        [weakSelf goZFBPay];
                        break;
                    default:
                        NSLog(@"选择付款类型");
                        break;
                }
                    
            }
        }
    }];
  
   
   
//    if ([payTypeStr isEqualToString:@"支付宝"]) {
//        [self goZFBPay];
//    }else if ([payTypeStr isEqualToString:@"微信"]){
//        [self goWeChatPay];
//    }else{
//        NSLog(@"选择付款类型");
//    }
//    switch (indexPath.row) {
//        case 0://选择微信
//        {
//            [self goWeChatPay];
//        }
//            break;
//        case 1://选择支付宝
//        {
//            [self goZFBPay];
//        }
//            break;
//
//        default:
//            NSLog(@"选择付款类型");
//            break;
//    }
}


#pragma mark ===
- (void)goWeChatPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    
    [WeChatPayData  weChatPayOfLiftCostIdStrArr:self.payOrderIdArrs];//  20220406改版
      
      
      /**
        20220406改版
       
    
    [WillPayGetOrderViewModel willWeChatPayMoneyNum:self.payMoeyNumDouble  withPayOrderType:PayOrder_Type_LifeCostWuYe withDescriptionStr:@"物业费" withOrderIdArr:self.payOrderIdArrs  withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            PayReq *req   = [[PayReq alloc] init];
            req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid] ;                   //商家id
            req.nonceStr  = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
            req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];  //时间戳
            req.package   = [TextShowWithModelStr textShowWithModelStr:model.package];
            req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
            req.prepayId  = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
            req.sign      = [TextShowWithModelStr textShowWithModelStr:model.sign];
            //orderNum 用于后续的
            [self.parmsDicUseWillSendAdd setValue:[TextShowWithModelStr textShowWithModelStr:model.orderNum] forKey:@"orderNum"];
            [self.parmsDicUseWillSendAdd setValue:@(1)   forKey:@"payTpye"];           // 1微信支付，2支付宝支付，3账户余额，4其他银行卡
            [self.parmsDicUseWillSendAdd setValue:@"微信" forKey:@"payTypeName"];
            dispatch_async( dispatch_get_main_queue(), ^{
                [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
            });
        }
    }];
       **/
}
#pragma mark ===
- (void)goZFBPay{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [WillPayGetOrderViewModel willZFBPayMoneyNum:self.payMoeyNumDouble withPayOrderType:PayOrder_Type_LifeCostWuYe  withOrderIdArr:self.payOrderIdArrs withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
            //orderNum 用于后续的
            [self.parmsDicUseWillSendAdd setValue:[TextShowWithModelStr textShowWithModelStr:model.orderNum] forKey:@"orderNum"];
            [self.parmsDicUseWillSendAdd setValue:@(2)   forKey:@"payTpye"];           // 1微信支付，2支付宝支付，3账户余额，4其他银行卡
            [self.parmsDicUseWillSendAdd setValue:@"支付宝" forKey:@"payTypeName"];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];//Community //alisdkdemo zhsj_zfb_2021002119679359
            });
        }
    }];
}
#pragma mark ======= notice—————————— pay  init
- (void)addNoticeOfPay{
    Y_NSNotificationCenter_Creat_NameAction(PaySuccessedEndInfo_Notice_Name, paySuccessNotice:);
    Y_NSNotificationCenter_Creat_NameAction(PayFailEndInfo_Notice_Name, payFailNotice:);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(PaySuccessedEndInfo_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(PayFailEndInfo_Notice_Name);
}
#pragma mark ======= notice—————————— pay  get
- (void)payFailNotice:(NSNotification *)notice{
    NSString *failMsg =  [notice.userInfo objectForKey:[notice.userInfo allKeys].firstObject];
    Y_SVP_SHOW_INFO_MES(failMsg);
}
////非水电气  物业成功后暂无add接口 待物业有了成功订单记录的接口后再使用以下。（物业缴费完成即可 没有后续接口）
- (void)paySuccessNotice:(NSNotification *)notice{
    NSInteger successInfoWithPayTypeNum =  [[notice.userInfo objectForKey:Pay_Success_PayType_Key] integerValue];
    switch (successInfoWithPayTypeNum) {//parmsDicUseWillSendAdd在第一步处理
        case 1:// 1微信支付
        {
//            [self weChatPaySuccessAfterAddParmsSend:self.parmsDicUseWillSendAdd];//非水电气 暂无记录add接口
        }
            break;
        case 2://2支付宝支付
        {
//            [self zfbPaySuccessAfertAddParmsSned:self.parmsDicUseWillSendAdd];
        }
            break;
        case 3://3账户余额
        {

        }
            break;
        case 4://4其他银行卡
        {

        }
            break;

        default:
            break;
    }

}
#pragma mark === 微信 end
- (void)weChatPaySuccessAfterAddParmsSend:(NSMutableDictionary *)parms{
    [self paySuccessAddOrder:parms];
}
#pragma mark == 支付宝 end
- (void)zfbPaySuccessAfertAddParmsSned:(NSMutableDictionary *)parms{
    [self paySuccessAddOrder:parms];
    
}
- (void)paySuccessAddOrder:(NSMutableDictionary *)parms{
    Y_SVP_SHOW_SUCCESS_MES(@"已成功缴纳");//列表更新
    [self initData];
}

@end
