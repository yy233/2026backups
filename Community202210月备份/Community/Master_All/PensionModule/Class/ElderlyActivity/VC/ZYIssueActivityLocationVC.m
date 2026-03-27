//
//  ZYIssueActivityLocationVC.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityLocationVC.h"
#import "ZYOtherIssueActivityVC.h"
#import "ZYIssueActivityLocationHeaderView.h"
#import "ZYMyIssueActivityCell.h"
#import "ZYVoiceManager.h"
#import "NearActivityFriendChatRelateData.h"
#import "ZYChatVc.h"
#import "ChatManagerData.h"

static NSString * const myIssueActivityCellID = @"ZYMyIssueActivityCell";
#define kIssueActivityLocationHeaderViewHeight 460
#define kIssueActivityLocationInfoCellHeight 80
#define kMyIssueActivityTopVCellHeight 83
#define kMyIssueActivityImageVCellHeight kActivityCollectionViewCell_H+15
#define kMyIssueActivityRecordVCellHeight 63
#define kMyIssueActivityDeleteVCellHeight 40
#define kMyIssueActivityLineViewCellHeight 1

@interface ZYIssueActivityLocationVC () <UITableViewDataSource, UITableViewDelegate, ZYIssueActivityLocationHeaderViewDelegate>

@property (nonatomic, strong) ZYIssueActivityLocationHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat labelHeight;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *currentActivityModel;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *currentOriginalActivityModel;

@property (nonatomic, strong) NSMutableArray *activityArray;

@end

@implementation ZYIssueActivityLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动发布人所在地";
    self.activityModel.isMain = YES;
    self.currentActivityModel = [self.activityModel yy_modelCopy];
    self.currentOriginalActivityModel = [self.activityModel yy_modelCopy];
    [self setUI];
    [self customTableView];
    [self initHeaderData];
    [self initActivityAddressData];
    [self initIsFriendData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"LOCATION_VIEW_ANNOTATION_BACK", locationViewAnnotationBack:)
}

// 通知回调
- (void)locationViewAnnotationBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 移除定时器和语音播放
        [self deallocVoiceTimer];
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        ZYPensionMainActivityDataModel *model = noti.object;
        self.currentActivityModel = model;
        [self initHeaderData];
        [self.tableView reloadData];
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
    Y_NSNotificationCenter_RemoveNotice_Name(@"LOCATION_VIEW_ANNOTATION_BACK")
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

// 暂停语音
- (void)stopVoice {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    [self deallocVoiceTimer];
    self.currentActivityModel.voiceTime = self.currentOriginalActivityModel.voiceTime;
    self.currentActivityModel.isPlay = NO;
    // 发送通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (ZYIssueActivityLocationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYIssueActivityLocationHeaderView" owner:nil options:nil].lastObject;
        _headerView.delegate = self;
    }
    
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)activityArray {
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
    }
    
    return _activityArray;
}

#pragma mark - 加载数据
// 加载顶部数据
- (void)initHeaderData {
    self.headerView.model = self.currentActivityModel;
    self.headerView.activityArray = self.activityArray;
    [self.headerView reloadInputViews];
}

//1222增 是否为好友的数据处理
- (void)initIsFriendData{
    [ChatManagerData chatSearchIsOrNotFriendsWithImid:self.activityModel.imId withBlock:^(NSDictionary * _Nonnull isOrNotFriendDic, BOOL success) {
        if (success) {
            BOOL isF = [[isOrNotFriendDic allKeys]containsObject:@"isOrNotFriend"] ? [[isOrNotFriendDic objectForKey:@"isOrNotFriend"] boolValue] : NO;
            self.headerView.isFriendBool = isF;//是否为好友 赋值
        }
    
    }];
}
// 加载活动所在地数据
- (void)initActivityAddressData {
    NSDictionary *params = @{@"id" : self.activityModel.ID,  @"page" : @(1), @"data" : @(10), @"latitude" : self.activityModel.latitude, @"longitude" : self.activityModel.longitude};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kQueryActivityAddressUrl]  withBody:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    // 移除所有数据
                    if (self.activityArray.count > 0) {
                        [self.activityArray removeAllObjects];
                    }
                    ZYPensionMainActivityModel *model = [ZYPensionMainActivityModel yy_modelWithJSON:responsObject];
                    NSArray *array = model.data;
                    [self.activityArray addObjectsFromArray:array];
                    for (int i = 0; i < self.activityArray.count; i++) {
                        ZYPensionMainActivityDataModel *dataModel = self.activityArray[i];
                        dataModel.order = i;
                        dataModel.isMain = YES;
                    }
                    // 缓存语音数据
                    [self cacheVoiceData];
                    
                    [self initHeaderData];
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
    for (ZYPensionMainActivityDataModel *model in self.activityArray) {
        if (model.voiceUrl.length > 0) {
            [[ZYVoiceManager share] voiceDownLoadWithFileUrlStr:model.voiceUrl AndIsPlay:NO];
        }
    }
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:myIssueActivityCellID bundle:nil] forCellReuseIdentifier:myIssueActivityCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMyIssueActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:myIssueActivityCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYMyIssueActivityCell *cell = (ZYMyIssueActivityCell *)currentCell;
    CGSize size = [cell.contentLabel.text boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : cell.contentLabel.font} context:nil].size;
    self.labelHeight = size.height + 16;
    cell.playButton.tag = 200 + indexPath.row;
    [cell.playButton addTarget:self action:@selector(plyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.distanceImageView.hidden = NO;
    cell.distanceLabel.hidden = NO;
    cell.lineView.hidden = YES;
    ZYPensionMainActivityDataModel *model = self.currentActivityModel;
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYPensionMainActivityDataModel *model = self.currentActivityModel;
    CGFloat height = kMyIssueActivityTopVCellHeight + kMyIssueActivityLineViewCellHeight;
    if (model.activityDesc.length > 0) {
        CGSize size = [model.activityDesc boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
        self.labelHeight = size.height + 16;
        height += self.labelHeight;
    }
    if (model.picUrl.length > 0) {
        height += kMyIssueActivityImageVCellHeight;
    }
    if (model.voiceUrl.length > 0) {
        height += kMyIssueActivityRecordVCellHeight;
    }
    if ([[ShareUserInfo sharedUserInfo].userInfo.uid isEqual:model.userUuid] && !model.isMain) {
        height += kMyIssueActivityDeleteVCellHeight;
    }
    
    return height;
//    return [tableView fd_heightForCellWithIdentifier:myIssueActivityCellID configuration:^(ZYMyIssueActivityCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kIssueActivityLocationHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYIssueActivityLocationHeaderViewDelegate
// 添加好友
- (void)addFriendButtonEvent {
    
    NSLog(@"添加好友");
    [NearActivityFriendChatRelateData nearActivityAddFriendWithFriendId:self.activityModel.imId];

}

// 交流
- (void)exchangeButtonEvent {
    
    DLog(@"交流");
    WEAKSELF
    NSString *toUserNickName = [TextShowWithModelStr textShowWithNotNullStr:self.activityModel.userName];
    NSString *toUserUUID = [TextShowWithModelStr textShowWithNotNullStr:self.activityModel.imId];
    NSString *imidStr = [TextShowWithModelStr textShowWithNotNullStr:self.activityModel.imId];
    
    //好友聊天 非陌生人 ｜ 后续可直接用imid获取sessionId
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZYChatVc *vc = [[ZYChatVc alloc] init];
        
        ChatVc_Seesion_type thishatVc_Seesion_type = ChatVc_Seesion_type_Friend;
        BOOL isMoShengRenTypeBoolNotShowRightItemBool = NO;//好友类型 非陌生人
        NSString *fImid = imidStr;
        NSString *fAccountUUID = toUserUUID;
        NSString *fNickName = toUserNickName.length>0 ? toUserNickName  : @"活动发起者";
        BOOL isFriendTypeIsDeletNotAllowSendMsgBool = NO;
        [vc fillThisNomalChatVcSubInfoWithClearnUseID:0  withSessionID:@"" withChatVcToUseType:thishatVc_Seesion_type withNotShowRightItemMSRBool:isMoShengRenTypeBoolNotShowRightItemBool withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:isFriendTypeIsDeletNotAllowSendMsgBool];
        [weakSelf pushVc:vc];
        
    });
    
}

- (void)iconImageViewEvent {
    
    NSLog(@"头像");
    ZYOtherIssueActivityVC *vc = [[ZYOtherIssueActivityVC alloc] init];
    vc.activityModel = [self.currentActivityModel yy_modelCopy];
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
// 播放
- (void)plyButtonClicked:(UIButton *)sender {
    
    NSLog(@"播放");
    self.duration = self.currentActivityModel.voiceTime;
    if (self.currentActivityModel.isPlay) {
        self.currentActivityModel.voiceTime = self.currentOriginalActivityModel.voiceTime;
        self.currentActivityModel.isPlay = NO;
        [self deallocVoiceTimer];
    }else {
        self.currentActivityModel.isPlay = YES;
        [self createVoiceTimer];
    }
    [self.tableView reloadData];
    
    // 播放语音
    if (self.currentActivityModel.isPlay) {
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        [[ZYVoiceManager share] voiceDownLoadWithFileUrlStr:self.currentActivityModel.voiceUrl AndIsPlay:self.currentActivityModel.isPlay];
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
                self.currentActivityModel.voiceTime = self.currentOriginalActivityModel.voiceTime;
                self.currentActivityModel.isPlay = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                ZYMyIssueActivityCell *cell = (ZYMyIssueActivityCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.playButton setImage:[UIImage imageNamed:@"yl_play"] forState:UIControlStateNormal];
                cell.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld″", self.currentActivityModel.voiceTime];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"STOP_VOICE_ANIMATION_BACK")
            });
        }
    }else {
        [self deallocVoiceTimer];
        self.currentActivityModel.voiceTime = self.currentOriginalActivityModel.voiceTime;
        self.currentActivityModel.isPlay = NO;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZYMyIssueActivityCell *cell = (ZYMyIssueActivityCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
