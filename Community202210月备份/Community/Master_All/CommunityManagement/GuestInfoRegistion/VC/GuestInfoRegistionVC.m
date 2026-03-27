//
//  GuestInfoRegistionVC.m
//  Community
// 来访人员登记 list列表
//  Created by 余莹 on 2020/12/4.
//

#import "GuestInfoRegistionVC.h"
#import "GuestInfoRegistionAddOrShowVC.h"
#import "ZYGuestInfoRegistionBottomView.h"
#import "ZYChooseTemporaryTimePopView.h"

#import "GuestInfoRegistionTableViewCell.h"
#define  GuestInfoRegistionTableViewCell_Identifier @"GuestInfoRegistionTableViewCell"
#import "GuestInfoRegistionHaveStatusTableViewCell.h"

#import "GuesTestTimePopViewController.h"//test


#import "TempCodeRelated.h"
//#import "GuestTempCodeShowVc.h"
#import "GuestTempCodeShowVcLate.h"

// 新版界面
#import "ZYVisitorInviteEditVc.h"
#import "ZYVisitorInviteInfoVc.h"

@interface GuestInfoRegistionVC () <UITableViewDataSource, UITableViewDelegate, GuestInfoRegistionTableViewCellDegelate, ZYGuestInfoRegistionBottomViewDelegate, ZYChooseTemporaryTimePopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) ZYGuestInfoRegistionBottomView *bottomView;

@property (nonatomic, strong) ZYChooseTemporaryTimePopView *chooseTemporaryTimePopView;

@property (nonatomic,assign) NSInteger PageNum;
@end

@implementation GuestInfoRegistionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"访客邀请";
    [self setUI];
    [self addRefresh];
    [self addNoticeInit];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.bottom.equalTo(_bottomView.superview).offset(-button_bottom_height);
        make.height.offset(84);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

- (void)addNoticeInit{
    Y_NSNotificationCenter_Creat_NameAction(GuestOneInfoAddSuccessWillRefreshListVc_Notice_Name, guestOneInfoAddSuccessWillRefreshListVcAction:)
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upMoreData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
#pragma mark == notice
- (void)guestOneInfoAddSuccessWillRefreshListVcAction:(NSNotification*)notice{
    [self initData];//刷新
}
#pragma mark === 查看delegate
- (void)guestInfoListCellRightBtnTouch:(GuestInfoModel *)model{
    NSLog(@"---guestInfoListCellRightBtnTouch---");
    //查看
    [self showDetailVcWithModel:model];
}
- (void)showDetailVcWithModel:(GuestInfoModel *)model{
    NSLog(@"查看来访人员 btn");
    if (model.tempCodeStatus) {
        [self pushTempCodeShowAddresStr:[TextShowWithModelStr textShowWithModelStr:model.address] withTempTimeNum:model.effectiveTime withBeginTimeEndTimeInfo:[TextShowWithModelStr textShowWithModelStr:model.createTime] withStrVcWithIdStr:[NSString stringWithFormat:@"%ld",model.id]];//id键待处理
    }else{
//        GuestInfoRegistionAddOrShowVC *editVc = [[GuestInfoRegistionAddOrShowVC alloc]init];
//        editVc.type = Type_Show_GuestInfoRegistionEditVC;
//        editVc.guestInfonationId = model.id;
//        [self.navigationController pushViewController:editVc animated:YES];
        
        // 新版
        ZYVisitorInviteInfoVc *vc = [[ZYVisitorInviteInfoVc alloc] init];
        vc.ID = [NSString stringWithFormat:@"%ld", model.id];
        [self pushVc:vc];
    }
}

#pragma mark == initdata
- (void)initData{
    self.PageNum = 1;
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(self.PageNum) forKey:@"page"];
    [parm setValue:@(Y_PAGE_SIZE)  forKey:@"size"];
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_List withParams:parm finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *resObjDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *resObjArr = [[NSArray alloc]initWithArray:[resObjDic objectForKey:@"records"]];
                self.dataSourceArr = [NSMutableArray arrayWithArray:[GuestInfoModel mj_objectArrayWithKeyValuesArray:resObjArr]];
                NSInteger totoal = [resObjDic[@"total"] intValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (totoal<Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = YES;
                    }else{
                        self.tableView.mj_footer.hidden = NO;
                    }
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
    
}
- (void)upMoreData{
    self.PageNum += 1;
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(self.PageNum) forKey:@"page"];
    [parm setValue:@(Y_PAGE_SIZE)  forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_List withParams:parm finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *resObjDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *resObjArr = [[NSArray alloc]initWithArray:[resObjDic objectForKey:@"records"]];
                NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[GuestInfoModel mj_objectArrayWithKeyValuesArray:resObjArr]];
                [self.dataSourceArr addObjectsFromArray:modelArr];
                NSInteger totoal = [resObjDic[@"total"] intValue];
                if (modelArr == 0) {
                    self.PageNum -= 1;
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (totoal<Y_PAGE_SIZE) {
                        self.tableView.mj_footer.hidden = YES;
                    }else{
                        self.tableView.mj_footer.hidden = NO;
                    }
                });
            }else{
                self.PageNum -= 1;
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            self.PageNum -= 1;
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
}
#pragma mark== tablev
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    GuestInfoRegistionHaveStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionHaveStatusTableViewCell_I];
    if (!cell) {
        cell = [[GuestInfoRegistionHaveStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionHaveStatusTableViewCell_I];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GuestInfoModel *model = self.dataSourceArr[indexPath.row];
    [cell fillCellModel:model];
    cell.delegate = self;
    return cell;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;//家属
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GuestInfoModel *model = self.dataSourceArr[indexPath.row];
    [self showDetailVcWithModel:model];
    //guestInfoListCellRightBtnTouch
}

#pragma mark - ZYGuestInfoRegistionBottomViewDelegate
- (void)addGuestButtonEvent {
    NSLog(@"添加来访人员");
//    GuestInfoRegistionAddOrShowVC *editVc = [[GuestInfoRegistionAddOrShowVC alloc]init];
//    editVc.type = Type_Add_GuestInfoRegistionEditVC;
//    [self.navigationController pushViewController:editVc animated:YES];
    
    // 新版
    ZYVisitorInviteEditVc *vc = [[ZYVisitorInviteEditVc alloc] init];
    vc.type = ZYVisitorInvite_Type_Add;
    ZYVisitorInviteUploadModel *model = [[ZYVisitorInviteUploadModel alloc] init];
    model.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    vc.uploadModel = model;
    [self pushVc:vc];
}

#pragma mark == 临时二维码
- (void)temporaryQRCodeButtonEvent {
    NSLog(@"生成临时二维码");
    
    [self.chooseTemporaryTimePopView showChooseTemporaryTimePopView];
    
}

#pragma mark - ZYChooseTemporaryTimePopViewDelegate
- (void)thirtyMinutesButtonEvent {
    
    NSLog(@"30分钟");
    [self addNewCodeWithMinType:TempCodeTime_Type_30];
}

- (void)sixtyMinutesButtonEvent {
    
    NSLog(@"60分钟");
    [self addNewCodeWithMinType:TempCodeTime_Type_60];
}

- (void)ninetyMinutesButtonEvent {
    
    NSLog(@"90分钟");
    [self addNewCodeWithMinType:TempCodeTime_Type_90];
}
- (void)addNewCodeWithMinType:(TempCodeTime_Type)tempCodeTime_Type{
    WEAKSELF
    //当前存储的社区
    [TempCodeRelated addTempCodeWithCommunityId:[NSString stringWithFormat:@"%ld",[ShareUserInfo sharedUserInfo].commuityInfo.ID] withTimeType:tempCodeTime_Type withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSString *idStr =  [[dic allKeys]containsObject:@"id"] ? [dic objectForKey:@"id"] : @"";
            NSInteger timeNum = 0;
            switch (tempCodeTime_Type) {
                case TempCodeTime_Type_30:
                    timeNum = 30;
                    break;
                case TempCodeTime_Type_60:
                    timeNum = 60;
                    break;
                case TempCodeTime_Type_90:
                    timeNum = 90;
                    break;
                default:
                    break;
            }
            NSString *addressStr = [[dic allKeys]containsObject:@"address"] ? [dic objectForKey:@"address"] : @"";
            [weakSelf pushTempCodeShowAddresStr:addressStr withTempTimeNum:timeNum withBeginTimeEndTimeInfo:@"" withStrVcWithIdStr:idStr];
            
        }
    }];
}
//临时二维码查看界面
- (void)pushTempCodeShowAddresStr:(NSString *)addressStr withTempTimeNum:(NSInteger)tempTimeNum withBeginTimeEndTimeInfo:(NSString *)beginTimeStr withStrVcWithIdStr:(NSString *)idStr {
    if (addressStr.length <= 0) {
        addressStr = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].commuityInfo.name];//小区名字暂时替代
    }
    DLog(@"临时二维码数据 二维码界面 跳转");
    dispatch_async(dispatch_get_main_queue(), ^{
        GuestTempCodeShowVcLate *vc = [[GuestTempCodeShowVcLate alloc]init];
        vc.visitorId = idStr;
        vc.isTempCodeShow = YES;
        vc.tempTimeNum = tempTimeNum;
        vc.tempTimeBeginInfoStr= beginTimeStr;
        vc.houseNameShowStr= addressStr;
        [self pushVc:vc];
        //新增的需要刷新列表
        if (beginTimeStr.length==0) {
            [self.tableView.mj_header beginRefreshing];
        }
//       //push
//        GuestTempCodeShowVc *vc = [[GuestTempCodeShowVc alloc]init];
//        vc.visitorId = idStr;
//        vc.tempTimeNum = tempTimeNum;
//        vc.tempTimeBeginInfoStr= beginTimeStr;
//        [self pushVc:vc];
//        //新增的需要刷新列表
//        if (beginTimeStr.length==0) {
//            [self.tableView.mj_header beginRefreshing];
//        }
    });
}
 
#pragma mark ==
//- (BaseTableViewFooterView *)footerView{
//    if (!_footerView) {
//        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
//        [_footerView.footerBtn addTarget:self action:@selector(guestInfoListfooterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_footerView.footerBtn setTitle:@"添加来访人员" forState:UIControlStateNormal];
//    }
//    return _footerView;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (ZYGuestInfoRegistionBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYGuestInfoRegistionBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYChooseTemporaryTimePopView *)chooseTemporaryTimePopView {
    if (!_chooseTemporaryTimePopView) {
        _chooseTemporaryTimePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYChooseTemporaryTimePopView" owner:nil options:nil].lastObject;
        _chooseTemporaryTimePopView.delegate = self;
    }
    
    return _chooseTemporaryTimePopView;
}

- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    
    return _dataSourceArr;
}

@end
