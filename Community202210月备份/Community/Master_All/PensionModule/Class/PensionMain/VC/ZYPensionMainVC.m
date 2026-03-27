//
//  ZYPensionMainVC.m
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import "ZYPensionMainVC.h"
#import <UserNotifications/UserNotifications.h>
#import "ZYMedicalRootTabBarVC.h"
#import "ZYEventRemindVC.h"
#import "ZYEditEventVC.h"
#import "ZYEventRemindDetailVC.h"
#import "ZYNearActivityVC.h"
#import "ZYOtherIssueActivityVC.h"
#import "ZYIssueActivityLocationVC.h"
#import "ZYPensionSOSVC.h"
#import "ZYFamilyArchiveVC.h"
#import "ZYMedicalMainVC.h"
#import "ZYIntelligentInquirySearchVC.h"
#import "MedicalWebViewVc.h"
#import "ZYPensionMainTopSearchView.h"
#import "ZYPensionMainTopImageCell.h"
#import "ZYPensionMainFunctionCell.h"
#import "ZYPensionMainTitleCell.h"
#import "ZYPensionMainEventCell.h"
#import "ZYPensionMainEmptyEventCell.h"
#import "ZYPensionMainActivityCell.h"
#import "ZBLocalNotification.h"
#import "ZYVoiceManager.h"

static NSString * const pensionMainTopImageCellID = @"ZYPensionMainTopImageCell";
static NSString * const pensionMainFunctionCellID = @"ZYPensionMainFunctionCell";
static NSString * const pensionMainTitleCellID = @"ZYPensionMainTitleCell";
static NSString * const pensionMainEventCellID = @"ZYPensionMainEventCell";
static NSString * const pensionMainEmptyEventCellID = @"ZYPensionMainEmptyEventCell";
static NSString * const pensionMainActivityCellID = @"ZYPensionMainActivityCell";
#define kPensionMainTopImageCellHeight kScreenW*(172/375.0)
#define kPensionMainFunctionCellHeight kFunctionCollectionViewCell_H*2+28
#define kPensionMainTitleCellHeight 45
#define kPensionMainEventCellHeight 100
#define kPensionMainEmptyEventCellHeight 120
#define kPensionMainActivityTopVCellHeight 105
#define kPensionMainActivityImageVCellHeight kActivityCollectionViewCell_H+15
#define kPensionMainActivityRecordVCellHeight 63
#define kPensionMainActivityDeleteVCellHeight 40
#define kPensionMainActivityLineViewCellHeight 1
#define PageNum 10

@interface ZYPensionMainVC () <UITableViewDataSource, UITableViewDelegate, ZYPensionMainTopSearchViewDelegate, ZYPensionMainFunctionCellDegate>

@property (nonatomic, strong) ZYPensionMainTopSearchView *searchView;

@property (nonatomic, strong) UITableView *tableView;

// 事件数组
@property (nonatomic, strong) NSMutableArray *eventArray;

// 活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;

// 活动原数组
@property (nonatomic, strong) NSMutableArray *originalActivityArray;

@property (nonatomic, assign) CGFloat labelHeight;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *currentActivityModel;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) ZYEventRemindModel *currentEventModel;

@end

@implementation ZYPensionMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected ) {//不在线
        [[TrusangBlueToothSdkDataManager share]backgroundKeepsBlueDevScanning];//后台扫蓝牙设备
    }
    // 判断通知权限
    [self judgeOpenNotifyAuthority];
    
    [self setUI];
    [self customTableView];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_EDIT_EVENT_BACK", pensionAddEditEventBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_DELETE_EVENT_BACK", pensionDeleteEventBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_ACTIVITY_BACK", pensionAddActivityBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_DELETE_ACTIVITY_BACK", pensionDeleteActivityBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_DELETE_NEAR_ACTIVITY_BACK", pensionDeleteActivityBack)
}

// 通知回调
- (void)pensionAddEditEventBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initEventData];
    });
}

- (void)pensionDeleteEventBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initEventData];
    });
}

- (void)pensionAddActivityBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self initElderlyActivityData];
    });
}

- (void)pensionDeleteActivityBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self initElderlyActivityData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getLocationData];
    if (self.isSwitHealthData) {
        self.isSwitHealthData = NO;
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopVoice];
}

- (void)dealloc {
    [self deallocVoiceTimer];
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_EDIT_EVENT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_DELETE_EVENT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_ACTIVITY_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_DELETE_ACTIVITY_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_DELETE_NEAR_ACTIVITY_BACK")
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_searchView.superview);
        make.height.offset(44 + status_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

// 暂停语音
- (void)stopVoice {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    [self deallocVoiceTimer];;
    ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[self.currentActivityModel.order];
    self.currentActivityModel.voiceTime = originalModel.voiceTime;
    self.currentActivityModel.isPlay = NO;
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (ZYPensionMainTopSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"ZYPensionMainTopSearchView" owner:nil options:nil].lastObject;
        _searchView.delegate = self;
    }
    
    return _searchView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)eventArray {
    if (!_eventArray) {
        _eventArray = [NSMutableArray array];
    }
    
    return _eventArray;
}

- (NSMutableArray *)activityArray {
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
    }
    
    return _activityArray;
}

- (NSMutableArray *)originalActivityArray {
    if (!_originalActivityArray) {
        _originalActivityArray = [NSMutableArray array];
    }
    
    return _originalActivityArray;
}

#pragma mark - 加载数据
- (void)initData {
    [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
    self.latitude = [ShareUserInfo sharedUserInfo].positioningModel.latitude;
    self.longitude = [ShareUserInfo sharedUserInfo].positioningModel.longitude;
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf initEventData];
        [weakSelf initElderlyActivityData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf initElderlyActivityData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    self.tableView.mj_footer.hidden = YES;
    self.currentPage = 1;
    [self initEventData];
    [self initElderlyActivityData];
}

// 获取经纬度数据
- (void)getLocationData {
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            self.latitude = model.latitude;
            self.longitude = model.longitude;
            // 持久化
            [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:model];//经纬度存储
        }
    }];
}

// 加载最新事件数据
- (void)initEventData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kAllEventListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.eventArray.count > 0) {
                        [self.eventArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYEventRemindModel class] json:responsObject[@"data"]];
                    [self.eventArray addObjectsFromArray:array];
                    [self.tableView reloadData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载事件启停数据
- (void)initStartStopEventData {
    NSDictionary *params = @{@"id" : self.currentEventModel.ID, @"status" : @(self.currentEventModel.status)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kEventStatusUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initEventData];
                    if (self.currentEventModel.status == 1) {
                        [self createLocalNotification];
                    }else {
                        [self cancelLocalNotification];
                    }
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载老年活动数据
- (void)initElderlyActivityData {
    NSDictionary *params = @{@"page" : @(self.currentPage), @"data" : @(PageNum), @"latitude" : @(self.latitude), @"longitude" : @(self.longitude)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kAllActivityListUrl]  withBody:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_header.hidden = NO;
            self.tableView.mj_footer.hidden = NO;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if ((self.activityArray.count > 0) && (self.currentPage == 1)) {
                        // 移除定时器和语音播放
                        [self deallocVoiceTimer];
                        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
                        // 发送通知
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
                    }
                    // 移除所有数据
                    if (self.currentPage == 1) {
                        [self.activityArray removeAllObjects];
                        [self.originalActivityArray removeAllObjects];
                    }
                    ZYPensionMainActivityModel *model = [ZYPensionMainActivityModel yy_modelWithJSON:responsObject];
                    NSArray *array = model.data;
                    ZYPensionMainActivityDataModel *endModel = self.activityArray.lastObject;
                    NSInteger endOrder = 0;
                    if (isNotNil(endModel)) {
                        endOrder = endModel.order + 1;
                    }
                    [array enumerateObjectsUsingBlock:^(ZYPensionMainActivityDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.order = endOrder + idx;
                        obj.isMain = YES;
                        [self.activityArray addObject:obj.yy_modelCopy];
                        [self.originalActivityArray addObject:obj.yy_modelCopy];
                    }];
                    // 判断数据是否加载完了
                    if (self.activityArray.count >= model.total) {
                        // 表示没有数据可以请求，设置UITableView footer的状态
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        // 重置提示加载更多数据
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                    // 刷新tableView
                    [self.tableView reloadData];
                    
                    // 缓存语音数据
                    [self cacheVoiceData];
                }else {
                    if (self.currentPage > 1) {
                        self.currentPage -= 1;
                    }
                    if (self.currentPage == 1) {
                        self.tableView.mj_footer.hidden = YES;
                    }
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 缓存语音数据
- (void)cacheVoiceData {
    for (ZYPensionMainActivityDataModel *model in self.activityArray) {
        if (model.voiceUrl.length > 0) {
            [[ZYVoiceManager share] voiceDownLoadWithFileUrlStr:model.voiceUrl AndIsPlay:NO];
        }
    }
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainTopImageCellID bundle:nil] forCellReuseIdentifier:pensionMainTopImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainFunctionCellID bundle:nil] forCellReuseIdentifier:pensionMainFunctionCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainTitleCellID bundle:nil] forCellReuseIdentifier:pensionMainTitleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainEventCellID bundle:nil] forCellReuseIdentifier:pensionMainEventCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainEmptyEventCellID bundle:nil] forCellReuseIdentifier:pensionMainEmptyEventCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainActivityCellID bundle:nil] forCellReuseIdentifier:pensionMainActivityCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 3) {
        if (self.eventArray.count > 0) {
            
            return self.eventArray.count;
        }else {
            
            return 1;
        }
    }else if (section == 5) {
        
        return self.activityArray.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYPensionMainTopImageCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainTopImageCellID forIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.section == 1) {
        ZYPensionMainFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainFunctionCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section == 2) {
        ZYPensionMainTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainTitleCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"最新事件";
        [cell.addMoreButton setTitle:@"添加" forState:UIControlStateNormal];
        [cell.addMoreButton setImage:[UIImage imageNamed:@"pension_add"] forState:UIControlStateNormal];
        [cell.addMoreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [cell.addMoreButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 3) {
        if (self.eventArray.count > 0) {
            ZYPensionMainEventCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainEventCellID forIndexPath:indexPath];
            cell.alarmSwitch.tag = 200 + indexPath.row;
            [cell.alarmSwitch addTarget:self action:@selector(alarmSwitchChanded:) forControlEvents:UIControlEventValueChanged];
            if (indexPath.row == (self.eventArray.count - 1)) {
                cell.lineView.hidden = YES;
            }else {
                cell.lineView.hidden = NO;
            }
            ZYEventRemindModel *model = self.eventArray[indexPath.row];
            cell.model = model;
            
            return cell;
        }else {
            ZYPensionMainEmptyEventCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainEmptyEventCellID forIndexPath:indexPath];
            
            return cell;
        }
    }else if (indexPath.section == 4) {
        ZYPensionMainTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainTitleCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"老年活动";
        [cell.addMoreButton setTitle:@"更多" forState:UIControlStateNormal];
        [cell.addMoreButton setImage:[UIImage imageNamed:@"pension_skip"] forState:UIControlStateNormal];
        [cell.addMoreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
        [cell.addMoreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 5) {
        ZYPensionMainActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainActivityCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYPensionMainActivityCell *cell = (ZYPensionMainActivityCell *)currentCell;
    cell.iconImageView.userInteractionEnabled = YES;
    cell.iconImageView.tag = 100 + indexPath.row;
    [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
    cell.distanceLabel.userInteractionEnabled = YES;
    cell.distanceLabel.tag = 1000 + indexPath.row;
    [cell.distanceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distanceLabelTap:)]];
    CGSize size = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : cell.contentLabel.font} context:nil].size;
    self.labelHeight = size.height + 16;
    cell.playButton.tag = 200 + indexPath.row;
    [cell.playButton addTarget:self action:@selector(plyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == (self.activityArray.count - 1)) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    ZYPensionMainActivityDataModel *model = self.activityArray[indexPath.row];
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return kPensionMainTopImageCellHeight;
    }else if (indexPath.section == 1) {
        
        return kPensionMainFunctionCellHeight;
    }else if (indexPath.section == 2) {
        
        return kPensionMainTitleCellHeight;
    }else if (indexPath.section == 3) {
        if (self.eventArray.count > 0) {
            
            return kPensionMainEventCellHeight;
        }else {
            
            return kPensionMainEmptyEventCellHeight;
        }
    }else if (indexPath.section == 4) {
        
        return kPensionMainTitleCellHeight;
    }else if (indexPath.section == 5) {
        ZYPensionMainActivityDataModel *model = self.activityArray[indexPath.row];
        CGFloat height = kPensionMainActivityTopVCellHeight + kPensionMainActivityLineViewCellHeight;
        if (model.activityDesc.length > 0) {
            CGSize size = [model.activityDesc boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
            self.labelHeight = size.height + 16;
            height += self.labelHeight;
        }
        if (model.picUrl.length > 0) {
            height += kPensionMainActivityImageVCellHeight;
        }
        if (model.voiceUrl.length > 0) {
            height += kPensionMainActivityRecordVCellHeight;
        }
        if ([[ShareUserInfo sharedUserInfo].userInfo.uid isEqual:model.userUuid] && !model.isMain) {
            height += kPensionMainActivityDeleteVCellHeight;
        }
        
        return height;
//        return [tableView fd_heightForCellWithIdentifier:pensionMainActivityCellID configuration:^(ZYPensionMainActivityCell *cell) {
//            [self configureCell:cell atIndexPath:indexPath];
//        }];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        NSLog(@"最新事件:%ld", indexPath.row);
        if (self.eventArray.count > 0) {
            ZYEventRemindDetailVC *vc = [[ZYEventRemindDetailVC alloc] init];
            ZYEventRemindModel *model = self.eventArray[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            vc.eventModel = model;
            [self pushVc:vc];
        }else {
            ZYEditEventVC *vc = [[ZYEditEventVC alloc] init];
            vc.type = @"add";
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
    }
}

#pragma mark - ZYPensionMainTopSearchViewDelegate
- (void)backButtonEvent {
    
    NSLog(@"返回");
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)searchViewEvent {
    
    NSLog(@"搜索");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"";
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark - ZYPensionMainFunctionCellDegate
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSLog(@"事件提醒");
        ZYEventRemindVC *vc= [[ZYEventRemindVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 1) {
        NSLog(@"SOS");
        ZYPensionSOSVC *vc = [[ZYPensionSOSVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 2) {
        NSLog(@"医疗服务");
        for (UIViewController *tempVc in self.tabBarController.navigationController.viewControllers) {
            if ([tempVc isKindOfClass:[ZYMedicalMainVC class]]) {
                [self.tabBarController.navigationController popToViewController:tempVc animated:YES];
                return;
            }
        }
        ZYMedicalRootTabBarVC *vc = [[ZYMedicalRootTabBarVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 3) {
        NSLog(@"推荐产品");
        
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_MallGoods;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
        
    }else if (indexPath.row == 4) {
        NSLog(@"老年活动");
        ZYNearActivityVC *vc = [[ZYNearActivityVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 5) {
        NSLog(@"家人档案");
        ZYFamilyArchiveVC *vc = [[ZYFamilyArchiveVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

#pragma mark - 处理点击事件
// 添加
- (void)addButtonClicked {
    
    NSLog(@"添加");
    ZYEditEventVC *vc = [[ZYEditEventVC alloc] init];
    vc.type = @"add";
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

// 更多
- (void)moreButtonClicked {
    
    NSLog(@"更多");
    ZYNearActivityVC *vc = [[ZYNearActivityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

// 头像
- (void)iconImageViewTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"头像 %ld", tap.view.tag - 100);
    NSInteger index = tap.view.tag - 100;
    ZYPensionMainActivityDataModel *model = self.originalActivityArray[index];
    ZYOtherIssueActivityVC *vc = [[ZYOtherIssueActivityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.activityModel = [model yy_modelCopy];
    [self pushVc:vc];
}

// 距离
- (void)distanceLabelTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"距离 %ld", tap.view.tag - 1000);
    NSInteger index = tap.view.tag - 1000;
    ZYPensionMainActivityDataModel *model = self.originalActivityArray[index];
    ZYIssueActivityLocationVC *vc = [[ZYIssueActivityLocationVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.activityModel = [model yy_modelCopy];
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
// 事件提醒
- (void)alarmSwitchChanded:(UISwitch *)sender {
    NSInteger index = sender.tag - 200;
    ZYEventRemindModel *model = self.eventArray[index];
    if (sender.isOn) {
        model.status = 1;
    }else {
        model.status = 0;
    }
    self.currentEventModel = model;
    [self initStartStopEventData];
}

// 播放
- (void)plyButtonClicked:(UIButton *)sender {
    
    NSLog(@"播放");
    ZYPensionMainActivityDataModel *model = self.activityArray[sender.tag - 200];
    if (model.voiceTime <= 0) {
        return;
    }
    self.currentActivityModel = model;
    self.duration = model.voiceTime;
    for (ZYPensionMainActivityDataModel *tempModel in self.activityArray) {
        if (tempModel == model) {
            if (model.isPlay) {
                ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[tempModel.order];
                tempModel.voiceTime = originalModel.voiceTime;
                tempModel.isPlay = NO;
                [self deallocVoiceTimer];
            }else {
                tempModel.isPlay = YES;
                [self createVoiceTimer];
            }
        }else {
            ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[tempModel.order];
            tempModel.voiceTime = originalModel.voiceTime;
            tempModel.isPlay = NO;
        }
    }
    [self.tableView reloadData];
    
    // 播放语音
    if (model.isPlay) {
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        [[ZYVoiceManager share] voiceDownLoadWithFileUrlStr:model.voiceUrl AndIsPlay:model.isPlay];
    }else {
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    }
}

#pragma mark - 定时器方法
// 创建语音时长定时器
- (void)createVoiceTimer {
    if (!self.timer) {
        // 开启定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(voiceTimerBack:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

// 定时器回调
- (void)voiceTimerBack:(NSTimer *)timer {
    self.duration--;
    if (self.duration >= 0) {
        self.currentActivityModel.voiceTime = self.duration;
        if (self.duration == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self deallocVoiceTimer];;
                ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[self.currentActivityModel.order];
                self.currentActivityModel.voiceTime = originalModel.voiceTime;
                self.currentActivityModel.isPlay = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentActivityModel.order inSection:5];
                ZYPensionMainActivityCell *cell = (ZYPensionMainActivityCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
                cell.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.currentActivityModel.voiceTime];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
            });
        }
    }else {
        [self deallocVoiceTimer];
        ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[self.currentActivityModel.order];
        self.currentActivityModel.voiceTime = originalModel.voiceTime;
        self.currentActivityModel.isPlay = NO;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentActivityModel.order inSection:5];
    ZYPensionMainActivityCell *cell = (ZYPensionMainActivityCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.currentActivityModel.voiceTime];
}

// 销毁定时器
- (void)deallocVoiceTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 判断是否开启通知权限
- (void)judgeOpenNotifyAuthority {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
       if (settings.authorizationStatus == UNAuthorizationStatusDenied){
           // 没权限
           NSLog(@"无推送权限，弹窗处理");
           dispatch_async(dispatch_get_main_queue(), ^{
               [self showAlertViewAboutNotAuthor];
           });
       }
   }];
}

//提示没有通知权限
- (void)showAlertViewAboutNotAuthor{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请开启通知权限"
                                          message:@"如果App通知权限没开启，将无法接收事件消息提醒"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *oKAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 打开设置页面，去设置定位
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
                //设备系统为IOS 10.0或者以上的
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }else{
                //设备系统为IOS 10.0以下的
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:oKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 本地闹钟通知
// 创建本地定时通知
- (void)createLocalNotification {
    NSInteger currentWeek = [ZYWeekStringTool weekdayNumWithString:[NSDate date].br_weekdayString];
    NSString *currentDateStr = [NSDate br_stringFromDate:[NSDate date] dateFormat:[NSString stringWithFormat:@"yyyy-MM-dd %02ld:%02ld", self.currentEventModel.warnHour, self.currentEventModel.warnMinute]];
    NSDate *startDate = [[NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_string:currentDateStr] dateByAddingTimeInterval:-24*60*60*currentWeek];
    NSMutableArray *notiIdArray = [NSMutableArray array];
    NSArray *eventNotiIds = [[NSUserDefaults standardUserDefaults] valueForKey:@"eventNotiIds"];
    if (eventNotiIds.count > 0) {
        [notiIdArray addObjectsFromArray:eventNotiIds];
    }
    for (NSString *week in self.currentEventModel.weeks) {
        NSString *notiId = [NSString stringWithFormat:@"%@_%@", self.currentEventModel.ID, week];
        [ZBLocalNotification createLocalNotificationWithAttribute:
                                        @{ZBNotificationUserInfoName:notiId,
                                          ZBNotificationAlertTitle:@"闹钟",
                                          ZBNotificationAlertBody:self.currentEventModel.content,
                                          ZBNotificationFireDate:[startDate dateByAddingTimeInterval:24*60*60*[week integerValue]],
                                          ZBNotificationSoundName:ZBNotificationSoundAlarm,
                                          ZBNotificationRepeat:@(ZBLocalNotificationRepeatEveryWeek)}];
        BOOL isAdd = YES;
        for (NSString *tempId in notiIdArray) {
            if ([tempId isEqual:notiId]) {
                isAdd = NO;
            }
        }
        if (isAdd) {
            [notiIdArray addObject:notiId];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:[notiIdArray copy] forKey:@"eventNotiIds"];
}

// 取消本地定时通知
-(void)cancelLocalNotification {
    NSMutableArray *notiIds = [NSMutableArray array];
    for (NSString *week in self.currentEventModel.weeks) {
        [notiIds addObject:[NSString stringWithFormat:@"%@_%@", self.currentEventModel.ID, week]];
    }
    [ZBLocalNotification cancelLocalNotificationWithNotiIds:[notiIds copy]];
}

@end
