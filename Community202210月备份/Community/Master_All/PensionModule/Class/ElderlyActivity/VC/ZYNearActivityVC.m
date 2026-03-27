//
//  ZYNearActivityVC.m
//  Community
//
//  Created by ZY on 2021/11/13.
//

#import "ZYNearActivityVC.h"
#import "ZYOtherIssueActivityVC.h"
#import "ZYIssueActivityLocationVC.h"
#import "ZYIssueActivityVC.h"
#import "ZYNearActivityTopView.h"
#import "ZYPensionEmptyTableView.h"
#import "ZYPensionMainActivityCell.h"
#import "ZYVoiceManager.h"

static NSString * const pensionMainActivityCellID = @"ZYPensionMainActivityCell";
#define kNearActivityTopViewHeight 180
#define kPensionMainActivityTopVCellHeight 105
#define kPensionMainActivityImageVCellHeight kActivityCollectionViewCell_H+15
#define kPensionMainActivityRecordVCellHeight 63
#define kPensionMainActivityDeleteVCellHeight 40
#define kPensionMainActivityLineViewCellHeight 1
#define PageNum 10

@interface ZYNearActivityVC () <UITableViewDataSource, UITableViewDelegate>
 
@property (nonatomic, strong) ZYNearActivityTopView *topView;

@property (nonatomic, strong) ZYPensionEmptyTableView *tableView;

@property (nonatomic, strong) UIButton *issueButton;

// 活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;

// 活动原数组
@property (nonatomic, strong) NSMutableArray *originalActivityArray;

@property (nonatomic, assign) CGFloat labelHeight;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *currentActivityModel;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *currentDeleteActivityModel;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, assign) CGFloat longitude;

@end

@implementation ZYNearActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"附近活动";
    [self setUI];
    [self customTableView];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_ACTIVITY_BACK", pensionAddActivityBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_DELETE_ACTIVITY_BACK", pensionDeleteActivityBack)
}

// 通知回调
- (void)pensionAddActivityBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)pensionDeleteActivityBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self initNearActivityData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopVoice];
}

- (void)dealloc {
    [self deallocVoiceTimer];
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_ACTIVITY_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_DELETE_ACTIVITY_BACK")
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kNearActivityTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_topView.superview);
    }];
    [self.view addSubview:self.issueButton];
    [_issueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_issueButton.superview).offset(-20);
        make.bottom.equalTo(_issueButton.superview).offset(-30);
        make.width.offset(82);
        make.height.offset(82);
    }];
    [self.view bringSubviewToFront:self.issueButton];
}

// 暂停语音
- (void)stopVoice {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    [self deallocVoiceTimer];
    ZYPensionMainActivityDataModel *originalModel = self.originalActivityArray[self.currentActivityModel.order];
    self.currentActivityModel.voiceTime = originalModel.voiceTime;
    self.currentActivityModel.isPlay = NO;
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (ZYNearActivityTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYNearActivityTopView" owner:nil options:nil].lastObject;
    }
    
    return _topView;
}

- (ZYPensionEmptyTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYPensionEmptyTableView alloc] init];
    }
    
    return _tableView;
}

- (UIButton *)issueButton {
    if (!_issueButton) {
        _issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_issueButton setImage:[UIImage imageNamed:@"yl_fabu"] forState:UIControlStateNormal];
        [_issueButton addTarget:self action:@selector(issueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _issueButton;
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
    self.topView.locationLabel.text = [ShareUserInfo sharedUserInfo].positioningModel.detailAddress;
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf initNearActivityData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf initNearActivityData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    [self.tableView.mj_header beginRefreshing];
}

// 加载附近活动数据
- (void)initNearActivityData {
    NSDictionary *params = @{@"page" : @(self.currentPage), @"data" : @(PageNum), @"latitude" : @(self.latitude), @"longitude" : @(self.longitude)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kNearAllActivityUrl]  withBody:params finished:^(id responsObject, NSError *error) {
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
                    if (!self.activityArray.count) {
                        self.tableView.mj_footer.hidden = YES;
                        // 空占位图文
                        [self.tableView emptyDataDelegate];
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

// 加载删除活动数据
- (void)initDeleteActivityData {
    NSDictionary *params = @{@"id" : self.currentDeleteActivityModel.ID};
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kDeleteActivityUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 发送通知
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_DELETE_NEAR_ACTIVITY_BACK")
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"删除成功" toView:self.view];
                    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
                    [self deallocVoiceTimer];
                    ZYPensionMainActivityDataModel *orginModel = self.originalActivityArray[self.currentActivityModel.order];
                    self.currentActivityModel.voiceTime = orginModel.voiceTime;
                    self.currentActivityModel.isPlay = NO;
                    // 发送通知
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
                    [self.originalActivityArray removeObjectAtIndex:self.currentDeleteActivityModel.order];
                    [self.activityArray removeObjectAtIndex:self.currentDeleteActivityModel.order];
                    [self.activityArray enumerateObjectsUsingBlock:^(ZYPensionMainActivityDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.order = idx;
                    }];
                    [self.originalActivityArray enumerateObjectsUsingBlock:^(ZYPensionMainActivityDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.order = idx;
                    }];
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

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:pensionMainActivityCellID bundle:nil] forCellReuseIdentifier:pensionMainActivityCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYPensionMainActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionMainActivityCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
    cell.deleteButton.tag = 500 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ZYPensionMainActivityDataModel *model = self.activityArray[indexPath.row];
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
//    return [tableView fd_heightForCellWithIdentifier:pensionMainActivityCellID configuration:^(ZYPensionMainActivityCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - 处理点击事件
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
    vc.activityModel = [model yy_modelCopy];
    [self pushVc:vc];
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

// 删除
- (void)deleteButtonClicked:(UIButton *)sender {
    
    NSLog(@"删除 %ld", sender.tag - 500);
    NSInteger index = sender.tag - 500;
    self.currentDeleteActivityModel = self.activityArray[index];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认删除吗？" message:@"删除不可恢复哦" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteActivityData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 发布
- (void)issueButtonClicked {
    NSLog(@"发布");
    
    ZYIssueActivityVC *vc = [[ZYIssueActivityVC alloc] init];
    [self pushVc:vc];
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
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentActivityModel.order inSection:0];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentActivityModel.order inSection:0];
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

@end
