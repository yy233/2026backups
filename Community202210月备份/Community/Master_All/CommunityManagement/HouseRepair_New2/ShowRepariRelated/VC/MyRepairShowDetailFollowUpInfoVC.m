//
//  MyRepairShowDetailFollowUpInfoVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
// 跟进信息

#import "MyRepairShowDetailFollowUpInfoVC.h"
#import "ZYMyRepairShowDetailFollowUpInfoHeaderView.h"
#import "ZYMyRepairShowDetailFollowUpInfoFooterView.h"
#import "ZYMyRepairShowDetailFollowUpInfoCell.h"
#import "ZYVoiceManager.h"

static NSString * const ZYMyRepairShowDetailFollowUpInfoCellID = @"ZYMyRepairShowDetailFollowUpInfoCell";
#define kZYMyRepairShowDetailFollowUpInfoHeaderViewHeight 70
#define kZYMyRepairShowDetailFollowUpInfoFooterViewHeight 40
#define kZYMyRepairShowDetailFollowUpInfoCellHeight 20
#define kZYMyRepairShowDetailFollowUpInfoCellImageHeight 72
#define kZYMyRepairShowDetailFollowUpInfoCellVioceHeight 42

@interface MyRepairShowDetailFollowUpInfoVC () <UITableViewDataSource, UITableViewDelegate, ZYMyRepairShowDetailFollowUpInfoCellDelegate>

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 活动原数组
@property (nonatomic, strong) NSMutableArray *originalDataArray;

@property (nonatomic, strong) ZYMyRepairShowDetailFollowUpInfoModel *currentModel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger duration;

// 数据刷新标识
@property (nonatomic, assign) BOOL isRefreshing;

@end

@implementation MyRepairShowDetailFollowUpInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"COLLECTIONVIEW_HEIGHT_COMPLETE_BACK", waterFallLayoutCompleteBack:);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopVoice];
}

// 暂停语音
- (void)stopVoice {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    [self deallocVoiceTimer];
    ZYMyRepairShowDetailFollowUpInfoModel *originalModel = self.originalDataArray[self.currentModel.indexPath.section];
    self.currentModel.voiceLength = originalModel.voiceLength;
    self.currentModel.isPlay = NO;
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK");
    [self.tableView reloadData];
}

// 通知回调
- (void)waterFallLayoutCompleteBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = noti.userInfo;
        CGFloat height = [dict[@"height"] doubleValue];
        NSIndexPath *indexPath = dict[@"indexPath"];
        ZYMyRepairShowDetailFollowUpInfoModel *model = self.dataArray[indexPath.section];
        model.contentCollectionViewHeight = height;
        model.isRefreshing = NO;
        [self.tableView reloadData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"COLLECTIONVIEW_HEIGHT_COMPLETE_BACK");
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.superview).offset(15);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)originalDataArray {
    if (!_originalDataArray) {
        _originalDataArray = [NSMutableArray array];
    }
    
    return _originalDataArray;
}

#pragma mark - 加载数据
- (void)initData {
    self.isRefreshing = YES;
    NSDictionary *params = @{@"orderId" : @(self.model.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kRepairOrderRecordInfoUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.dataArray.count > 0) {
                        [self.dataArray removeAllObjects];
                        [self.originalDataArray removeAllObjects];
                        // 移除定时器和语音播放
                        [self deallocVoiceTimer];
                        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
                        // 发送通知
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK");
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYMyRepairShowDetailFollowUpInfoModel class] json:responsObject[@"data"]];
                    [array enumerateObjectsUsingBlock:^(ZYMyRepairShowDetailFollowUpInfoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                        model.indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
                        model.contentCollectionViewHeight = 0;
                        model.isRefreshing = self.isRefreshing;
                        [self.dataArray addObject:model];
                        [self.originalDataArray addObject:model.yy_modelCopy];
                    }];
                    if (!self.dataArray.count) {
                        // 空占位图文
                        [self.tableView emptyDataDelegate];
                    }
                    [self.tableView reloadData];
                    
                    // 缓存语音数据
                    [self cacheVoiceData];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 缓存语音数据
- (void)cacheVoiceData {
    for (ZYMyRepairShowDetailFollowUpInfoModel *model in self.dataArray) {
        if (model.voiceUrl.length > 0) {
            [[ZYVoiceManager share] voiceDownLoadWithFileUrlStr:model.voiceUrl AndIsPlay:NO];
        }
    }
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYMyRepairShowDetailFollowUpInfoCellID bundle:nil] forCellReuseIdentifier:ZYMyRepairShowDetailFollowUpInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMyRepairShowDetailFollowUpInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYMyRepairShowDetailFollowUpInfoCellID forIndexPath:indexPath];
    ZYMyRepairShowDetailFollowUpInfoModel *model = self.dataArray[indexPath.section];
    if (indexPath.section == self.dataArray.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    cell.delegate = self;
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMyRepairShowDetailFollowUpInfoModel *model = self.dataArray[indexPath.section];
    CGFloat height = kZYMyRepairShowDetailFollowUpInfoCellHeight;
    if (model.imgs.count > 0) {
        height += kZYMyRepairShowDetailFollowUpInfoCellImageHeight;
    }
    if (model.voiceUrl.length > 0) {
        height += kZYMyRepairShowDetailFollowUpInfoCellVioceHeight;
    }

    return height + model.contentCollectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZYMyRepairShowDetailFollowUpInfoHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYMyRepairShowDetailFollowUpInfoHeaderView" owner:nil options:nil].lastObject;
    ZYMyRepairShowDetailFollowUpInfoModel *model = self.dataArray[section];
    if (section == 0) {
        headerView.topLineView.hidden = YES;
        [headerView.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, kZYMyRepairShowDetailFollowUpInfoHeaderViewHeight) radius:10 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    }else if (section == self.dataArray.count - 1) {
        headerView.bottomLineView.hidden = YES;
    }
    headerView.model = model;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kZYMyRepairShowDetailFollowUpInfoHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count - 1) {
        ZYMyRepairShowDetailFollowUpInfoFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYMyRepairShowDetailFollowUpInfoFooterView" owner:nil options:nil].lastObject;
        footerView.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
        [footerView.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 20) radius:10 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        
        return footerView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count - 1) {
        
        return kZYMyRepairShowDetailFollowUpInfoFooterViewHeight;
    }
    
    return 0;
}

#pragma mark - ZYMyRepairShowDetailFollowUpInfoCellDelegate
- (void)playButtonEventWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld %ld", indexPath.section, indexPath.row);
    
    ZYMyRepairShowDetailFollowUpInfoModel *model = self.dataArray[indexPath.section];
    if (model.voiceLength <= 0) {
        return;
    }
    self.currentModel = model;
    self.duration = model.voiceLength;
    for (ZYMyRepairShowDetailFollowUpInfoModel *tempModel in self.dataArray) {
        if (tempModel == model) {
            if (model.isPlay) {
                ZYMyRepairShowDetailFollowUpInfoModel *originalModel = self.originalDataArray[tempModel.indexPath.section];
                tempModel.voiceLength = originalModel.voiceLength;
                tempModel.isPlay = NO;
                [self deallocVoiceTimer];
            }else {
                tempModel.isPlay = YES;
                [self createVoiceTimer];
            }
        }else {
            ZYMyRepairShowDetailFollowUpInfoModel *originalModel = self.originalDataArray[tempModel.indexPath.section];
            tempModel.voiceLength = originalModel.voiceLength;
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
        self.currentModel.voiceLength = self.duration;
        if (self.duration == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self deallocVoiceTimer];;
                ZYMyRepairShowDetailFollowUpInfoModel *originalModel = self.originalDataArray[self.currentModel.indexPath.section];
                self.currentModel.voiceLength = originalModel.voiceLength;
                self.currentModel.isPlay = NO;
                ZYMyRepairShowDetailFollowUpInfoCell *cell = (ZYMyRepairShowDetailFollowUpInfoCell *)[self.tableView cellForRowAtIndexPath:self.currentModel.indexPath];
                [cell.playButton setImage:[UIImage imageNamed:@"hr_play"] forState:UIControlStateNormal];
                cell.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.currentModel.voiceLength];
            });
            // 发送通知
            Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK");
        }
    }else {
        [self deallocVoiceTimer];
        ZYMyRepairShowDetailFollowUpInfoModel *originalModel = self.originalDataArray[self.currentModel.indexPath.section];
        self.currentModel.voiceLength = originalModel.voiceLength;
        self.currentModel.isPlay = NO;
    }
    ZYMyRepairShowDetailFollowUpInfoCell *cell = (ZYMyRepairShowDetailFollowUpInfoCell *)[self.tableView cellForRowAtIndexPath:self.currentModel.indexPath];
    cell.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.currentModel.voiceLength];
}

// 销毁定时器
- (void)deallocVoiceTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
