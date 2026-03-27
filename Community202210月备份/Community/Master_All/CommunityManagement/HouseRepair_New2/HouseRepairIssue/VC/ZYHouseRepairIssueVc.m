//
//  ZYHouseRepairIssueVc.m
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import "ZYHouseRepairIssueVc.h"
#import "ZYHouseRepairIssueOwnerListVc.h"
#import "ZYHouseRepairIssueOrderListVc.h"
#import "ZYHouseRepairIssueAddressListVc.h"
#import "ZYBaseBottomView.h"
#import "ZYHouseRepairIssueEditCell.h"
#import "ZYHouseRepairIssueRecordCell.h"
#import "ZYHouseRepairIssueTimeCell.h"
#import "ZYHouseRepairIssueRecordPopView.h"
#import "ZYIssueActivityFileModel.h"

static CGFloat popViewDuration = 0.25;
static NSString * const ZYHouseRepairIssueEditCellID = @"ZYHouseRepairIssueEditCell";
static NSString * const ZYHouseRepairIssueRecordCellID = @"ZYHouseRepairIssueRecordCell";
static NSString * const ZYHouseRepairIssueTimeCellID = @"ZYHouseRepairIssueTimeCell";
#define kZYBaseBottomViewHeight button_bottom_height+90
#define kZYHouseRepairIssueEditCellHeight 510
#define kZYHouseRepairIssueRecordCellHeight 70
#define kZYHouseRepairIssueTimeCellHeight 100

@interface ZYHouseRepairIssueVc () <UITableViewDataSource, UITableViewDelegate, ZYBaseBottomViewDelegate, ZYHouseRepairIssueEditCellDelegate, ZYHouseRepairIssueRecordCellDelegate, ZYHouseRepairIssueTimeCellDelegate, ZYHouseRepairIssueRecordPopViewDelegate, UITextViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYBaseBottomView *bottomView;

@property (nonatomic, strong) ZYHouseRepairIssueRecordPopView *popView;

// 图片数组
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

// 浏览图片
@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

// 是否有语音
@property (nonatomic, assign) BOOL isVoice;

@property (nonatomic, copy) NSString *voicePathStr;

// 语音自动结束标识
@property (nonatomic, assign) BOOL isAutoEndVoiceMark;

@property (nonatomic, strong) ZYHouseRepairIssueUploadModel *uploadModel;

@end

@implementation ZYHouseRepairIssueVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报事报修";
    [self setUI];
    [self customTableView];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"HOUSE_REPAIR_OWNER_BACK", houseRepairOwnerBack:);
    Y_NSNotificationCenter_Creat_NameAction(@"HOUSE_REPAIR_ORDER_BACK", houseRepairOrderBack:);
    Y_NSNotificationCenter_Creat_NameAction(@"HOUSE_REPAIR_ADDRESS_BACK", houseRepairAddressrBack:);
    Y_NSNotificationCenter_Creat_NameAction(@"REPAIR_VOICE_END_BACK", repairVoiceEndBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopVoicePlayer];
}

// 通知回调
- (void)houseRepairOwnerBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *communityId = noti.userInfo[@"communityId"];
        NSString *communityName = noti.userInfo[@"communityName"];
        self.uploadModel.communityId = communityId;
        self.uploadModel.communityName = communityName;
        [self.tableView reloadData];
    });
}

- (void)houseRepairOrderBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *typeId = noti.userInfo[@"typeId"];
        NSString *typeName = noti.userInfo[@"typeName"];
        self.uploadModel.typeId = typeId;
        self.uploadModel.typeName = typeName;
        [self.tableView reloadData];
    });
}

- (void)houseRepairAddressrBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *regionId = noti.userInfo[@"regionId"];
        NSString *address = noti.userInfo[@"address"];
        self.uploadModel.regionId = regionId;
        self.uploadModel.address = address;
        [self.tableView reloadData];
    });
}

- (void)repairVoiceEndBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAutoEndVoiceMark = YES;
        [self.popView hiddenHouseRepairIssueRecordPopView];
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

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"HOUSE_REPAIR_OWNER_BACK");
    Y_NSNotificationCenter_RemoveNotice_Name(@"HOUSE_REPAIR_ORDER_BACK");
    Y_NSNotificationCenter_RemoveNotice_Name(@"HOUSE_REPAIR_ADDRESS_BACK");
    Y_NSNotificationCenter_RemoveNotice_Name(@"REPAIR_VOICE_END_BACK");
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kZYBaseBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYBaseBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYBaseBottomView" owner:nil options:nil].lastObject;
        [_bottomView.okButton setTitle:@"提交" forState:UIControlStateNormal];
        _bottomView.delegate = self;
    }
    
    return _bottomView;
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

- (ZYHouseRepairIssueUploadModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[ZYHouseRepairIssueUploadModel alloc] init];
    }
    
    return _uploadModel;
}

#pragma mark - 加载数据
- (void)initData {
    self.uploadModel.name = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.realName];
    self.uploadModel.phone = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile];
    self.uploadModel.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    self.uploadModel.communityName = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].commuityInfo.name];
    [self.imagesArray addObjectsFromArray:@[]];
    [self.tableView reloadData];
}

// 上传批量图片数据
- (void)initUploadImageData {
    [[ToolOfNetWork sharedTools] YrequestImgFileArrWithALLURL:ZY_BASEURL(kBaseFilesUploadUrl) withParams:@{}.mutableCopy fileDataArr:self.uploadImagesArray fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYIssueActivityFileModel class] json:responsObject[@"data"]];
                for (ZYIssueActivityFileModel *model in array) {
                    [self.imagesArray addObject:model.url];
                }
                NSMutableString *mStr = [NSMutableString string];
                for (NSString *urlStr in self.imagesArray) {
                    [mStr appendString:[NSString stringWithFormat:@"%@;", urlStr]];
                }
                self.uploadModel.repairImg = [mStr copy];
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
    [[ToolOfNetWork sharedTools] YrequestVoiceFileArrWithALLURL:ZY_BASEURL(kBaseFileUploadUrl) withParams:@{}.mutableCopy filePathStr:self.voicePathStr fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYIssueActivityFileModel *model = [ZYIssueActivityFileModel yy_modelWithJSON:responsObject[@"data"]];
                self.uploadModel.voiceUrl = model.url;
                self.uploadModel.voiceLength = model.fsize;
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
    self.isVoice = YES;
    self.uploadModel.isPlay = NO;
    self.uploadModel.voiceLength = 60 - self.popView.duration;
    [self.tableView reloadData];
}

// 提交报事报修数据
- (void)uploadRepairData {
    ZYHouseRepairIssueUploadModel *uploadModel = [self.uploadModel yy_modelCopy];
    if (uploadModel.appointmentTime.length > 0) {
        uploadModel.appointmentTime = [NSString stringWithFormat:@"%@:00", self.uploadModel.appointmentTime];
    }
    NSDictionary *params = [uploadModel yy_modelToJSONObject];
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kAddRepairUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"提交成功" toView:self.view.window];
                [self popVC];
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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueEditCellID bundle:nil] forCellReuseIdentifier:ZYHouseRepairIssueEditCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueRecordCellID bundle:nil] forCellReuseIdentifier:ZYHouseRepairIssueRecordCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYHouseRepairIssueTimeCellID bundle:nil] forCellReuseIdentifier:ZYHouseRepairIssueTimeCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYHouseRepairIssueEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYHouseRepairIssueEditCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.delegate = self;
        cell.imagesArray = self.imagesArray;
        cell.model = self.uploadModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYHouseRepairIssueRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYHouseRepairIssueRecordCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.voicePlayCompleteBlock = ^(ZYHouseRepairIssueUploadModel * _Nonnull model) {
            if (self.uploadModel == model) {
                self.uploadModel.isPlay = NO;
            }
        };
        cell.model = self.uploadModel;
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYHouseRepairIssueTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYHouseRepairIssueTimeCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.uploadModel;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kZYHouseRepairIssueEditCellHeight;
    }else if (indexPath.row == 1) {
        if (self.isVoice) {
            
            return kZYHouseRepairIssueRecordCellHeight;
        }else {
            
            return 0;
        }
    }else if (indexPath.row == 2) {
        
        return kZYHouseRepairIssueTimeCellHeight;
    }
    
    return 0;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.uploadModel.problem = textView.text;
}

#pragma mark - ZYHouseRepairIssueEditCellDelegate
// 报事业主
- (void)ownerViewEvent {
    NSLog(@"报事业主");
    
    ZYHouseRepairIssueOwnerListVc *vc = [[ZYHouseRepairIssueOwnerListVc alloc] init];
    [self pushVc:vc];
}

// 工单类型
- (void)orderViewEvent {
    NSLog(@"工单类型");
    
    ZYHouseRepairIssueOrderListVc *vc = [[ZYHouseRepairIssueOrderListVc alloc] init];
    vc.communityId = self.uploadModel.communityId;
    [self pushVc:vc];
}

// 报事位置
- (void)addressViewEvent {
    NSLog(@"报事位置");
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *publicAction = [UIAlertAction actionWithTitle:@"公共区域" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"公共区域");
        self.uploadModel.regionType = 1;
        ZYHouseRepairIssueAddressListVc *vc = [[ZYHouseRepairIssueAddressListVc alloc] init];
        vc.type = ZYHouseRepair_Region_Type_Public;
        vc.communityId = self.uploadModel.communityId;
        [self pushVc:vc];
    }];
    UIAlertAction *noPublicAction = [UIAlertAction actionWithTitle:@"非公共区域" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"非公共区域");
        self.uploadModel.regionType = 2;
        ZYHouseRepairIssueAddressListVc *vc = [[ZYHouseRepairIssueAddressListVc alloc] init];
        vc.type = ZYHouseRepair_Region_Type_NoPublic;
        vc.communityId = self.uploadModel.communityId;
        [self pushVc:vc];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:publicAction];
    [alertVC addAction:noPublicAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 语音
- (void)recordButtonEvent {
    NSLog(@"语音");
    
    self.popView = [[NSBundle mainBundle] loadNibNamed:@"ZYHouseRepairIssueRecordPopView" owner:nil options:nil].lastObject;
    self.popView.delegate = self;
    [self.popView showHouseRepairIssueRecordPopView];
}

// 添加图片
- (void)addPhotos {
    NSLog(@"添加图片");
    
    if (self.imagesArray.count >= 3) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"最多上传3张图片" toView:self.view];
        return;
    }
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

// 选中图片
- (void)imageViewTapWithIndex:(NSInteger)index {
    NSLog(@"选中图片%ld", index);
    
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

// 删除照片
- (void)deletePhotoWithIndex:(NSInteger)index {
    NSLog(@"删除图片%ld", index);
    
    [self.imagesArray removeObjectAtIndex:index];
    NSMutableString *mStr = [NSMutableString string];
    for (NSString *str in self.imagesArray) {
        [mStr appendString:[NSString stringWithFormat:@"%@;", str]];
    }
    self.uploadModel.repairImg = [mStr copy];
    [self.tableView reloadData];
}

#pragma mark - ZYHouseRepairIssueRecordCellDelegate
// 播放
- (void)playButtonEvent {
    NSLog(@"播放语音");
    
    if (self.uploadModel.isPlay) {
        self.uploadModel.isPlay = NO;
        [self stopVoicePlayer];
    }else {
        self.uploadModel.isPlay = YES;
        [self playVoice];
    }
    [self.tableView reloadData];
}

// 删除
- (void)closeButtonEvent {
    NSLog(@"关闭语音");
    
    self.uploadModel.voiceUrl = @"";
    self.uploadModel.voiceLength = 0;
    [self stopVoice];
    self.isVoice = NO;
    [self.tableView reloadData];
}

#pragma mark - ZYHouseRepairIssueTimeCellDelegate
// 预约时间
- (void)timeViewEvent {
    NSLog(@"预约时间");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *maxDate = [dateFormatter dateFromString:@"2222-01-01"];
    __weak typeof(self) weakSelf = self;
    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMDH title:@"" selectValue:dateStr minDate:[NSDate date] maxDate:maxDate isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        NSLog(@"%@", selectValue);
        weakSelf.uploadModel.appointmentTime = [NSString stringWithFormat:@"%@:00", selectValue];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - ZYHouseRepairIssueRecordPopViewDelegate
// 按下事件
- (void)voiceButtonTouchDownEvent {
    // 是否有麦克风权限
    if (![[ZYAuthorizationManager sharedManager] requestAuthorization:KAVAudioSession presentVc:self]) {
        self.isAutoEndVoiceMark = YES;
        return;
    }
    // 录音
    [self startVoice];
}

// 松开事件
- (void)voiceButtonTouchUpEvent {
    if (self.isAutoEndVoiceMark) {
        self.isAutoEndVoiceMark = NO;
        return;
    }
    [self.popView hiddenHouseRepairIssueRecordPopView];
    if ((60 - self.popView.duration) >= 1) {
        if ((60 - self.popView.duration) <= 60) {
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

#pragma mark - ZYBaseBottomViewDelegate
- (void)okButtonEvent {
    NSLog(@"提交");
    
    if ([self judgeNoEmptyData]) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
        [self uploadRepairData];
    }
}

// 数据不为空判断
- (BOOL)judgeNoEmptyData {
    if (self.uploadModel.typeName.length > 0) {
        if (self.uploadModel.address.length > 0) {
            if (self.uploadModel.problem.length > 0) {
                if (self.uploadModel.repairImg.length > 0) {
                    if (self.uploadModel.appointmentTime.length > 0) {
                        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH"];
                        NSString *currentDateStr = [dateFormatter1 stringFromDate:[NSDate date]];
                        NSDate *currentDate = [dateFormatter1 dateFromString:currentDateStr];
                        NSInteger currentSecond = [currentDate timeIntervalSince1970];
                        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                        [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
                        NSDate *submitDate = [dateFormatter2 dateFromString:self.uploadModel.appointmentTime];
                        NSInteger submitSecond = [submitDate timeIntervalSince1970];
                        if (submitSecond - currentSecond >= 3600) {
                            
                            return YES;
                        }else {
                            
                            [ZYProgressHUDTool showCustomHUDTextMessage:@"预约时间应大于当前时间" toView:self.view];
                        }
                    }else {
                        
                        return YES;
                    }
                    
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请上传图片" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入报事描述" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择报事位置" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择工单类型" toView:self.view];
    }
    
    return NO;
}

#pragma mark - 录音相关方法
// 开始录音
- (void)startVoice {
    [[LGSoundRecorder shareInstance] startSoundRecord:nil recordPath:ReportLocation_Voice_RecordFileUrl_Str];
}

// 录音结束
- (void)stopVoice {
    [[LGSoundRecorder shareInstance] stopSoundRecord:nil];
}

// 播放录音
- (void)playVoice {
    [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:ReportLocation_Voice_RecordFileUrl_Str];
}

// 暂停播放
- (void)stopVoicePlayer {
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}

#pragma mark - caf转awr
- (void)voiceDataCafChangeToAmr {
    BOOL isSuccess = [[LGSoundRecorder shareInstance] cafChangeToAmrWithHaveCafPathStr:ReportLocation_Voice_RecordFileUrl_Str andWillSaveAmrPahtStr:ReportLocation_Voice_RecordFileUrl_Amr_Str];
    if (isSuccess) {
        self.voicePathStr = ReportLocation_Voice_RecordFileUrl_Amr_Str;
    }else {
        self.voicePathStr = ReportLocation_Voice_RecordFileUrl_Str;
    }
}

@end
