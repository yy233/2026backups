//
//  ZYIssueActivityVC.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityVC.h"
#import "ZYIssueActivityBottomView.h"
#import "ZYIssueActivityTopCell.h"
#import "ZYIssueActivityTextCell.h"
#import "ZYIssueActivityImageCell.h"
#import "ZYIssueActivityVoiceCell.h"
#import "ZYIssueActivityVoicePopView.h"
#import "ZYIssueActivityTypeModel.h"
#import "ZYIssueActivityFileModel.h"
#import "ZYIssueActivityUploadModel.h"

static CGFloat popViewDuration = 0.25;
static NSString * const issueActivityTopCellID = @"ZYIssueActivityTopCell";
static NSString * const issueActivityTextCellID = @"ZYIssueActivityTextCell";
static NSString * const issueActivityImageCellID = @"ZYIssueActivityImageCell";
static NSString * const issueActivityVoiceCellID = @"ZYIssueActivityVoiceCell";
#define kIssueActivityBottomViewHeight button_bottom_height+150
#define kIssueActivityTextCellHeight 160
#define kIssueActivityImageCellHeight kIssueActivityImageCell_H+70
#define kIssueActivityVoiceCellHeight 80

@interface ZYIssueActivityVC () <UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, ZYIssueActivityTopCellDelegate, ZYIssueActivityImageCellDelegate, ZYIssueActivityVoiceCellDelegate, ZYIssueActivityBottomViewDelegate, TZImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYIssueActivityBottomView *bottomView;

@property (nonatomic, strong) ZYIssueActivityVoicePopView *popView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

// 是否有语音
@property (nonatomic, assign) BOOL isVoice;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *activityModel;

@property (nonatomic, strong) NSMutableArray *activityTypeArray;

@property (nonatomic, strong) ZYIssueActivityUploadModel *uploadModel;

@property (nonatomic, copy) NSString *voicePathStr;

// 语音自动结束标识
@property (nonatomic, assign) BOOL isAutoEndVoiceMark;

@end

@implementation ZYIssueActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布活动";
    [self leftBarButtonItemCustom];
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
    [self getLocationInfoLoadData];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"VOICE_END_BACK", voiceEndBack)
}

// 通知回调
- (void)voiceEndBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAutoEndVoiceMark = YES;
        [self.popView hiddenIssueActivityVoicePopView];
        [self stopVoice];
        // caf转amr
        [self voiceDataCafChangeToAmr];
        NSData *data = [NSData dataWithContentsOfFile:self.voicePathStr];
        if (!isNotNil(data)) {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"语音录制失败!" toView:self.view];
            return;
        }
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"语音上传中..."];
        [self initUploadVoiceData];
    });
}

- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"VOICE_END_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    self.activityModel.isPlay = NO;
    [self.tableView reloadData];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self popVC];
    }
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 52, 28);
    navRightBtn.backgroundColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
    navRightBtn.layer.cornerRadius = 14;
    navRightBtn.layer.masksToBounds = YES;
    [navRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

// 定制左barButtonItem
- (void)leftBarButtonItemCustom {

    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navLeftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [navLeftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    navLeftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [navLeftBtn addTarget:self action:@selector(navLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navLeftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:navLeftBtn];
    [self.navigationItem setLeftBarButtonItem:navLeftBtnItem animated:YES];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kIssueActivityBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 根据获取的经纬度加载数据
- (void)getLocationInfoLoadData {
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ZYIssueActivityTopCell *cell = (ZYIssueActivityTopCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (model) {
            self.uploadModel.latitude = model.latitude;
            self.uploadModel.longitude = model.longitude;
            cell.addressLabel.text = model.detailAddress;
        }else {
            [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
            self.uploadModel.latitude = [ShareUserInfo sharedUserInfo].positioningModel.latitude;
            self.uploadModel.longitude = [ShareUserInfo sharedUserInfo].positioningModel.longitude;
            cell.addressLabel.text = [ShareUserInfo sharedUserInfo].positioningModel.detailAddress;
        }
    }];
}

#pragma mark - 懒加载
- (ZYIssueActivityBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYIssueActivityBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}

- (NSMutableArray *)uploadImagesArray {
    if (!_uploadImagesArray) {
        _uploadImagesArray = [NSMutableArray array];
    }
    
    return _uploadImagesArray;
}

- (ZYPensionMainActivityDataModel *)activityModel {
    if (!_activityModel) {
        _activityModel = [[ZYPensionMainActivityDataModel alloc] init];
    }
    
    return _activityModel;
}

- (NSMutableArray *)activityTypeArray {
    if (!_activityTypeArray) {
        _activityTypeArray = [NSMutableArray array];
    }
    
    return _activityTypeArray;
}

- (ZYIssueActivityUploadModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[ZYIssueActivityUploadModel alloc] init];
        _uploadModel.activityTypeCode = @"";
        _uploadModel.activityTypeName = @"";
        _uploadModel.activityDesc = @"";
        _uploadModel.picUrl = @"";
        _uploadModel.voiceUrl = @"";
    }
    
    return _uploadModel;
}

#pragma mark - 加载数据
// 加载活动类型数据
- (void)initActivityTypeData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kActivityTypeListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.activityTypeArray.count > 0) {
                        [self.activityTypeArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYIssueActivityTypeModel class] json:responsObject[@"data"]];
                    [self.activityTypeArray addObjectsFromArray:array];
                    [self handleActivityTypeData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理活动类型数据
- (void)handleActivityTypeData {
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    for (ZYIssueActivityTypeModel *model in self.activityTypeArray) {
        [dataSourceArr addObject:model.activityTypeName];
    }
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:[dataSourceArr copy] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ZYIssueActivityTopCell *cell = (ZYIssueActivityTopCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.activityLabel.text = resultModel.value;
        cell.activityLabel.textColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
        
        ZYIssueActivityTypeModel *typeModel = weakSelf.activityTypeArray[resultModel.index];
        weakSelf.uploadModel.activityTypeCode = typeModel.activityTypeCode;
        weakSelf.uploadModel.activityTypeName = typeModel.activityTypeName;
    }];
}

// 上传批量图片数据
- (void)initUploadImageData {
    [[ToolOfNetWork sharedTools] YrequestImgFileArrWithALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kPensionFilesUploadUrl] withParams:@{}.mutableCopy fileDataArr:self.uploadImagesArray fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYIssueActivityFileModel class] json:responsObject[@"data"]];
                for (ZYIssueActivityFileModel *model in array) {
                    [self.imagesArray addObject:model.url];
                }
                self.uploadModel.picUrl = [self.imagesArray componentsJoinedByString:@","];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 上传语音数据
- (void)initUploadVoiceData {
    [[ToolOfNetWork sharedTools] YrequestVoiceFileArrWithALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kPensionFileUploadUrl] withParams:@{}.mutableCopy filePathStr:self.voicePathStr fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYIssueActivityFileModel *model = [ZYIssueActivityFileModel yy_modelWithJSON:responsObject[@"data"]];
                self.uploadModel.voiceUrl = model.url;
                self.uploadModel.voiceFileSize = model.fsize;
                self.uploadModel.voiceTime = self.popView.duration;
                [self handleUploadVoiceData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理语音数据
- (void)handleUploadVoiceData {
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    [self.view layoutIfNeeded];
    self.bottomView.hidden = YES;
    self.isVoice = YES;
    self.activityModel.isPlay = NO;
    self.activityModel.voiceTime = self.popView.duration;
    [self.tableView reloadData];
}

// 加载新增活动数据
- (void)initAddActivityData {
    NSDictionary *params = @{@"activityTypeCode" : self.uploadModel.activityTypeCode, @"activityTypeName" : self.uploadModel.activityTypeName, @"activityDesc" : self.uploadModel.activityDesc, @"picUrl" : self.uploadModel.picUrl, @"voiceUrl" : self.uploadModel.voiceUrl, @"voiceFileSize" : @(self.uploadModel.voiceFileSize), @"voiceTime" : @(self.uploadModel.voiceTime), @"longitude" : @(self.uploadModel.longitude), @"latitude" : @(self.uploadModel.latitude)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kAddActivityUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_ACTIVITY_BACK")
                [self popVC];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"发布成功" toView:self.view.window];
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
    [self.tableView registerNib:[UINib nibWithNibName:issueActivityTopCellID bundle:nil] forCellReuseIdentifier:issueActivityTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:issueActivityTextCellID bundle:nil] forCellReuseIdentifier:issueActivityTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:issueActivityImageCellID bundle:nil] forCellReuseIdentifier:issueActivityImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:issueActivityVoiceCellID bundle:nil] forCellReuseIdentifier:issueActivityVoiceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isVoice) {
        
        return 4;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYIssueActivityTopCell *cell = [tableView dequeueReusableCellWithIdentifier:issueActivityTopCellID forIndexPath:indexPath];
        cell.delegate = self;
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYIssueActivityTextCell *cell = [tableView dequeueReusableCellWithIdentifier:issueActivityTextCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYIssueActivityImageCell *cell = [tableView dequeueReusableCellWithIdentifier:issueActivityImageCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.imagesArray = self.imagesArray;
        
        return cell;
    }else if (indexPath.row == 3) {
        ZYIssueActivityVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:issueActivityVoiceCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.voicePlayCompleteBlock = ^(ZYPensionMainActivityDataModel * _Nonnull model) {
            if (self.activityModel == model) {
                self.activityModel.isPlay = NO;
            }
        };
        cell.model = self.activityModel;
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
//    ZYIssueActivityTopCell *cell = (ZYIssueActivityTopCell *)currentCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:issueActivityTopCellID configuration:^(ZYIssueActivityTopCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 1) {
        
        return kIssueActivityTextCellHeight;
    }else if (indexPath.row == 2) {
        
        return kIssueActivityImageCellHeight;
    }else if (indexPath.row == 3) {
        
        return kIssueActivityVoiceCellHeight;
    }
    
    return 0;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.uploadModel.activityDesc = textView.text;
}

#pragma mark - ZYIssueActivityTopCellDelegate
// 选择活动
- (void)activityViewEvent {
    
    NSLog(@"选择活动");
    [self.view endEditing:YES];
    if (self.activityTypeArray.count > 0) {
        [self handleActivityTypeData];
    }else {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initActivityTypeData];
    }
}

#pragma mark - ZYIssueActivityImageCellDelegate
// 添加图片
- (void)addPhotos {
    
    NSLog(@"添加图片");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            NSMutableArray *tempIconImageArray = [NSMutableArray arrayWithArray:[weakSelf.imagesArray copy]];
            NSMutableArray *tempPhotosArray = [NSMutableArray array];
            [tempIconImageArray addObjectsFromArray:photos];
            if (tempIconImageArray.count > 3) {
                for (NSInteger i = weakSelf.imagesArray.count; i < 3; i++) {
                    UIImage *image = tempIconImageArray[i];
                    [tempPhotosArray addObject:image];
                }
            }else {
                [tempPhotosArray addObjectsFromArray:photos];
            }
            weakSelf.uploadImagesArray = [tempPhotosArray copy];
            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
            [weakSelf initUploadImageData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 选择图片
- (void)imageViewTapWithIndex:(NSInteger)index {
    
    NSLog(@"点击照片 %ld", index);
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:self.imagesArray[i]];
        photoModel.originUrl = [NSURL URLWithString:self.imagesArray[i]];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

// 删除图片
- (void)deletePhotoWithIndex:(NSInteger)index {
    
    NSLog(@"删除图片 %ld", index);
    [self.imagesArray removeObjectAtIndex:index];
    self.uploadModel.picUrl = [self.imagesArray componentsJoinedByString:@","];
    [self.tableView reloadData];
}

#pragma mark - ZYIssueActivityVoiceCellDelegate
// 播放语音
- (void)playButtonEvent {
    
    NSLog(@"播放语音");
    if (self.activityModel.isPlay) {
        self.activityModel.isPlay = NO;
        [self stopVoicePlayer];
    }else {
        self.activityModel.isPlay = YES;
        [self playVoice];
    }
    [self.tableView reloadData];
}

// 关闭语音
- (void)closeButtonEvent {
    
    NSLog(@"关闭语音");
    self.uploadModel.voiceUrl = @"";
    self.uploadModel.voiceFileSize = 0;
    self.uploadModel.voiceTime = 0;
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kIssueActivityBottomViewHeight);
    }];
    [self.view layoutIfNeeded];
    self.bottomView.hidden = NO;
    [self stopVoice];
    self.isVoice = NO;
    [self.tableView reloadData];
}

#pragma mark - ZYIssueActivityBottomViewDelegate
// 语音按钮按下
- (void)voiceButtonTouchDownEvent {
    
    NSLog(@"语音按钮按下");
    // 是否有麦克风权限
    if (![[ZYAuthorizationManager sharedManager] requestAuthorization:KAVAudioSession presentVc:self]) {
        self.isAutoEndVoiceMark = YES;
        return;
    }
    self.popView = [[NSBundle mainBundle] loadNibNamed:@"ZYIssueActivityVoicePopView" owner:nil options:nil].lastObject;
    [self.popView showIssueActivityVoicePopView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startVoice];
    });
}

// 语音按钮松开
- (void)voiceButtonTouchUpEvent {
    
    NSLog(@"语音按钮松开");
    if (self.isAutoEndVoiceMark) {
        self.isAutoEndVoiceMark = NO;
        return;
    }
    [self.popView hiddenIssueActivityVoicePopView];
    if (self.popView.duration >= 1) {
        if (self.popView.duration <= 60) {
            [self stopVoice];
            // caf转amr
            [self voiceDataCafChangeToAmr];
            NSData *data = [NSData dataWithContentsOfFile:self.voicePathStr];
            if (!isNotNil(data)) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"语音录制失败!" toView:self.view];
                return;
            }
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"语音上传中..."];
            [self initUploadVoiceData];
        }else {
            [self stopVoice];
            [ZYProgressHUDTool showCustomHUDTextMessage:@"说话时间不能大于60秒" toView:self.view];
        }
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopVoice];
        });
        [ZYProgressHUDTool showCustomHUDTextMessage:@"说话时间太短" toView:self.view];
    }
}

#pragma mark - 处理点击事件
// 取消
- (void)navLeftBtnAction {
    
    [self.view endEditing:YES];
    [self popVC];
}

// 发布
- (void)navRightBtnAction {
    
    NSLog(@"发布");
    [self.view endEditing:YES];
    if (self.uploadModel.activityTypeName.length > 0) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发布中..."];
        [self initAddActivityData];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择活动内容" toView:self.view];
    }
}

#pragma mark - 录音相关方法
// 开始录音
- (void)startVoice {
    [[LGSoundRecorder shareInstance] startSoundRecord:nil recordPath:ActivityLocation_Voice_RecordFileUrl_Str];
}

// 录音结束
- (void)stopVoice {
    [[LGSoundRecorder shareInstance] stopSoundRecord:nil];
}

// 播放录音
- (void)playVoice {
    [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:ActivityLocation_Voice_RecordFileUrl_Str];
}

// 暂停播放
- (void)stopVoicePlayer {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}

#pragma mark - caf转awr
- (void)voiceDataCafChangeToAmr {
    BOOL isSuccess = [[LGSoundRecorder shareInstance] cafChangeToAmrWithHaveCafPathStr:ActivityLocation_Voice_RecordFileUrl_Str andWillSaveAmrPahtStr:ActivityLocation_Voice_RecordFileUrl_Amr_Str];
    if (isSuccess) {
        self.voicePathStr = ActivityLocation_Voice_RecordFileUrl_Amr_Str;
    }else {
        self.voicePathStr = ActivityLocation_Voice_RecordFileUrl_Str;
    }
}

@end
