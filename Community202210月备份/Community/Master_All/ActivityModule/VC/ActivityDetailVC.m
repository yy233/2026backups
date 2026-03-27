//
//  ActivityDetailVCTableViewController.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityDetailVC.h"
#import "ActivityInputInfoVC.h"
#import "ActivityDetailTopView.h"
#import "ActivityDetailVcTableViewCell.h"
#import "ActivityDetailUseModel.h"
#import "ActivityOtherData.h"
#import "AllMapNavigatioManger.h"

static NSString *k_title_MainInfo  = @"主办方信息";
static NSString *k_title_timeInfo  = @"地址时间信息";
static NSString *k_title_activeInfo  = @"活动信息";
static NSString *k_title_activeKnowInfo  = @"活动须知";
static NSString *k_title_ownUserInfo  = @"个人信息";


@interface ActivityDetailVC ()
@property (nonatomic,strong) ActivityDetailTopView *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) ActivityDetailUseModel *detailModel;

@end

@implementation ActivityDetailVC
- (ActivityDetailTopView *)headerView{
    if (!_headerView) {
        _headerView = [[ActivityDetailTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W*0.67)];
    }
    return _headerView;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W, 50)];
    }
    return _footerView;
}
- (void)footerBtnAction{
    DLog(@"");
    if (self.detailModel.theme.length <= 0 ) {
        return;
    }
    if (self.detailModel.activityStatus == 2) {//活动报名在报名期限内时footerAction
        switch (self.detailModel.status) {
            case 0:
            {
              // @"参加活动"
                ActivityInputInfoVC *vc = [[ActivityInputInfoVC alloc]init];
                NSString *idStr = @"";
                if (self.infoIDStr.length>0) {
                    idStr = self.infoIDStr;
                }else{
                    idStr = [TextShowWithModelStr textShowWithModelStr: self.detailModel.idStr];
                }
                vc.thisActivityIdStr = idStr;
                [self pushVc:vc];
            }
                break;
            case 1:
            {      //@"取消报名"
                if (self.detailModel.isCancel == YES) {
                    [self cancelThisUpActivity];

                }else{
                    Y_SVP_SHOW_ERR_MES(@"当前活动报名不可取消！");
                }
         
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark == 取消报名
- (void)cancelThisUpActivity{
    WEAKSELF
    NSString *idStr = @"";
    if (self.infoIDStr.length>0) {
        idStr = self.infoIDStr;
    }else{
        idStr = self.detailModel.idStr;
    }
    [ActivityOtherData cancelActivityOfIdStr:idStr withBlock:^(NSDictionary * _Nonnull dic,  BOOL success) {
        if (success) {
            //更新操作
            [weakSelf initDetailData];
        }
    }];
}

#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动报名";

    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDetailData];//报名回来也要有刷新
}

- (void)initView{
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.footerView.footerBtn newAnBtnWithTextStr:@""];//暂无数据
    self.footerView.footerBtn.layer.cornerRadius = 0;

}
- (void)initDetailData{
    [self.tableView reloadData];
    WEAKSELF
    NSString *idStr = @"";
    if (self.infoIDStr.length>0) {
        idStr = self.infoIDStr;
    }else{
        idStr = self.detailModel.idStr;
    }
     [ActivityOtherData getDetailOfIdStr:idStr withBlock:^(NSDictionary * _Nonnull dic,  BOOL success) {
        if (success) {
            weakSelf.detailModel = [ActivityDetailUseModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf detailInfoModel];
            });
        }
    }];

}
- (void)detailInfoModel{ //UI
    
    //status   状态1已报名0未报名
    if ((self.detailModel.activityStatus == 2) && (self.detailModel.status == 1)) {//在截止日前 + 报过名的 (有个人信息cell)
        self.dataSourceArr = @[
            @[k_title_MainInfo,k_title_timeInfo],
            @[k_title_activeInfo,k_title_activeKnowInfo],
            @[k_title_ownUserInfo]
        ].mutableCopy;
        
    }else{//无个人信息cell
        self.dataSourceArr = @[
            @[k_title_MainInfo,k_title_timeInfo],
            @[k_title_activeInfo,k_title_activeKnowInfo],
        ].mutableCopy;
        
    }
    
    //activityStatus    1预发布，2报名进行中，3报名已结束，5活动已结束,6未开始
    switch (self.detailModel.activityStatus) {
        case 1:
        {
            [self.footerView.footerBtn newAnBtnWithTextStr:@"预发布"];
            [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xC5C9D4)];
        }
            break;
            
        case 2:
        {
            if (self.detailModel.status == 1){//报过名
                [self.footerView.footerBtn newAnBtnWithTextStr:@"取消报名"];
            }else{//没报名
                [self.footerView.footerBtn newAnBtnWithTextStr:@"参加活动"];

            }
        }
            break;
            
        case 3:
        {
            [self.footerView.footerBtn newAnBtnWithTextStr:@"报名截止"];
            [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xC5C9D4)];
            //self.footerView.footerBtn.userInteractionEnabled = NO;
        }
            break;
        case 5:
        {
            [self.footerView.footerBtn newAnBtnWithTextStr:@"活动结束"];
            [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xC5C9D4)];
            //self.footerView.footerBtn.userInteractionEnabled = NO;
            
        }
            break;
        case 6:
        {
            [self.footerView.footerBtn newAnBtnWithTextStr:@"即将开始"];
            [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xC5C9D4)];
            //self.footerView.footerBtn.userInteractionEnabled = NO;
            
        }
            break;
        default:
        {
            [self.footerView.footerBtn newAnBtnWithTextStr:@"未知状态"];
            [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xC5C9D4)];
            //self.footerView.footerBtn.userInteractionEnabled = NO;
        }
            break;
    }
    [self.headerView fillModel:self.detailModel];
    
    [self.tableView reloadData];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ( self.detailModel.theme.length != 0 ) {//有详情数据
        return self.dataSourceArr.count;
    }else{
        return 0;//无详情数据
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.detailModel.theme.length == 0) {
        return 0;
    }else{
        NSArray *arr = self.dataSourceArr[section];
        return arr.count;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *sectionFooterV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 5.0)];
    sectionFooterV.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    return sectionFooterV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section == [tableView numberOfSections]-1) {
        return 0.01;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataSourceArr[indexPath.section];
    
    if ([arr.firstObject isEqualToString:k_title_ownUserInfo]) {
        return 156;
        
    }else if ([arr.firstObject isEqualToString:k_title_activeInfo] && indexPath.row == 0){
 
        CGFloat textH = [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32) withTextStr:self.detailModel.content withFont:[UIFont systemFontOfSize:14.0]];
        if (textH < 20) {
            textH = 20;
        }
        return textH + 25+20+20;
        
    }else if ([arr.lastObject isEqualToString:k_title_activeKnowInfo] && indexPath.row == 1){
        CGFloat textH = [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32) withTextStr:self.detailModel.instructions withFont:[UIFont systemFontOfSize:14.0]];
        if (textH < 20) {
            textH = 20;
        }
        return textH + 25+20+20;
    }else if ([arr.lastObject isEqualToString:k_title_timeInfo] && indexPath.row == 1){
        return 100;
    }else if ([arr.firstObject isEqualToString:k_title_MainInfo] && indexPath.row == 0){
        return 110;
    }else{
        return 0.1;
    }
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataSourceArr[indexPath.section];
    
    if ([arr.firstObject isEqualToString:k_title_ownUserInfo]) {
        
        ActivityDetailVcOwnUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailVcOwnUserInfoTableViewCell_I];
        if (!cell) {
            cell = [[ActivityDetailVcOwnUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityDetailVcOwnUserInfoTableViewCell_I];
        }
        cell.titleL.text = k_title_ownUserInfo;
        cell.nameL.text = [TextShowWithModelStr textShowWithModelStr:self.detailModel.name];
        cell.phoneL.text = [TextShowWithModelStr textShowWithModelStr:self.detailModel.mobile];

        return cell;
    }else if ([arr.firstObject isEqualToString:k_title_activeInfo] && indexPath.row == 0){
        ActivityDetailVcLongTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailVcLongTextTableViewCell_I];
        if (!cell) {
            cell = [[ActivityDetailVcLongTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityDetailVcLongTextTableViewCell_I];
        }
        cell.titleL.text = k_title_activeInfo;
        cell.lonTextL.text = self.detailModel.content;
        return cell;
        
    }else if ([arr.lastObject isEqualToString:k_title_activeKnowInfo]  && indexPath.row == 1){

        ActivityDetailVcWrangLongTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailVcWrangLongTextTableViewCell_I];
        if (!cell) {
            cell = [[ActivityDetailVcWrangLongTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityDetailVcWrangLongTextTableViewCell_I];
        }
        cell.lonTextL.text = self.detailModel.instructions;
        return cell;
    }else if ([arr.lastObject isEqualToString:k_title_timeInfo] && indexPath.row == 1){

        ActivityDetailVcAddressAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailVcAddressAndTimeTableViewCell_I];
        if (!cell) {
            cell = [[ActivityDetailVcAddressAndTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityDetailVcAddressAndTimeTableViewCell_I];
        }
        cell.addressL.text = [NSString stringWithFormat:@"活动地址：%@",[TextShowWithModelStr textShowWithModelStr: self.detailModel.address]];
        cell.timeFillFromL.text = [NSString stringWithFormat:@"报名时间：%@",[self detailApplyTimesWithModel:self.detailModel]];
        cell.timeActiveBeginL.text = [NSString stringWithFormat:@"活动时间：%@",[self detailActivityTimesWithModel:self.detailModel]];
        return cell;
        
    }else{
        ActivityDetailVcMianInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityDetailVcMianInfoTableViewCell_I];
        if (!cell) {
            cell = [[ActivityDetailVcMianInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ActivityDetailVcMianInfoTableViewCell_I];
            [cell.addressConentBtn addTarget:self action:@selector(addressConentBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.titleL.text = k_title_MainInfo;
       

        NSString *sponsorStr = self.detailModel.sponsor.length > 0 ? [TextShowWithModelStr textShowWithModelStr: self.detailModel.sponsor] : [TextShowWithModelStr textShowWithModelStr:self.listModel.sponsor];
        cell.mainAddressL.text = [NSString stringWithFormat:@"主办方：%@",sponsorStr];
        NSString *phoneStr = self.detailModel.contactMobile.length > 0 ? [TextShowWithModelStr textShowWithModelStr: self.detailModel.contactMobile ] :[TextShowWithModelStr textShowWithModelStr: self.listModel.contactMobile ];
        [cell.phoneConentBtn newAnBtnWithTextStr:phoneStr];
        
        return cell;
    }
}
 
- (NSString *)detailApplyTimesWithModel:(ActivityDetailUseModel *)model{
    NSString *strOfApplyTime = @"";
    NSString *beginT = @"";
    NSString *endT = @"";
    beginT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.beginApplyTime]];
    endT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.overApplyTime]];
    strOfApplyTime = [NSString stringWithFormat:@"%@ - %@", beginT ,endT];
    return strOfApplyTime;
}

- (NSString *)detailActivityTimesWithModel:(ActivityDetailUseModel *)model{
    NSString *strOfApplyTime = @"";
    NSString *beginT = @"";
    NSString *endT = @"";
    beginT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.beginActivityTime]];
    endT = [ToolOfTimeChangeFormat smallTimeFormatWithLongTimeStr:[TextShowWithModelStr textShowWithModelStr:model.overActivityTime]];
    strOfApplyTime = [NSString stringWithFormat:@"%@ - %@", beginT ,endT];
    return strOfApplyTime;
}

- (void)addressConentBtnAction{
    DLog(@"跳转地图导航");
    [AllMapNavigatioManger  gotoAddressWithLat:self.detailModel.lat
                                           lon: self.detailModel.lon
                                         title:self.detailModel.address
                                   andPresntVC:self];
}


 
@end
