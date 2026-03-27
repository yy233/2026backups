//
//  ZYReportAboutRepairApplyVc.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyVc.h"
#import "ZYReportAboutRepairApplyInfoCell.h"
#import "ZYReportAboutRepairApplyTextCell.h"
#import "ZYReportAboutRepairApplyVoiceCell.h"
#import "ZYReportAboutRepairApplyBottomView.h"
#import "ZYReportAboutRepairApplyVoicePopView.h"
#import "ZYReportAboutRepairApplyCategoryModel.h"
#import "UserHouseModel.h"
#import "ZYIssueActivityFileModel.h"

static CGFloat popViewDuration = 0.25;
static NSString * const ZYReportAboutRepairApplyInfoCellID = @"ZYReportAboutRepairApplyInfoCell";
static NSString * const ZYReportAboutRepairApplyTextCellID = @"ZYReportAboutRepairApplyTextCell";
static NSString * const ZYReportAboutRepairApplyVoiceCellID = @"ZYReportAboutRepairApplyVoiceCell";

#define kZYReportAboutRepairApplyBottomViewHeight button_bottom_height+150
#define kZYReportAboutRepairApplyInfoCellHeight 241
#define kZYReportAboutRepairApplyTextCellHeight 213+kZYReportAboutRepairApplyTextCollectionViewCell_H
#define kZYReportAboutRepairApplyVoiceCellHeight 68

@interface ZYReportAboutRepairApplyVc () <UITableViewDataSource, UITableViewDelegate, ZYReportAboutRepairApplyInfoCellDelegate, ZYReportAboutRepairApplyTextCellDelegate, ZYReportAboutRepairApplyVoiceCellDelegate, ZYReportAboutRepairApplyBottomViewDelegate, UITextFieldDelegate, UITextViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYReportAboutRepairApplyBottomView *bottomView;

@property (nonatomic, strong) ZYReportAboutRepairApplyVoicePopView *popView;

// 房屋列表数组
@property (nonatomic, strong) NSMutableArray *houseArray;

// 是否显示住址选择视图
@property (nonatomic, assign) BOOL isShowHouseView;

// 报事数组
@property (nonatomic, strong) NSMutableArray *matterArray;

// 报修数组
@property (nonatomic, strong) NSMutableArray *repairArray;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

// 图片数组
@property (nonatomic, strong) NSMutableArray *imagesArray;

// 上传图片
@property (nonatomic, strong) UIImage *uploadImage;

// 上传数据model
@property (nonatomic, strong) ZYReportAboutRepairApplyUploadModel *uploadModel;

// 是否有语音
@property (nonatomic, assign) BOOL isVoice;

@property (nonatomic, copy) NSString *voicePathStr;

// 语音自动结束标识
@property (nonatomic, assign) BOOL isAutoEndVoiceMark;

@end

@implementation ZYReportAboutRepairApplyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请服务";
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
    [self initData];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initHouseListData];
    [self initRepairCategoryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf0f1f6_D001534];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kZYReportAboutRepairApplyBottomViewHeight);
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

- (ZYReportAboutRepairApplyBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYReportAboutRepairApplyBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSMutableArray *)houseArray {
    if (!_houseArray) {
        _houseArray = [NSMutableArray array];
    }
    
    return _houseArray;
}

- (NSMutableArray *)matterArray {
    if (!_matterArray) {
        _matterArray = [NSMutableArray array];
    }
    
    return _matterArray;
}

- (NSMutableArray *)repairArray {
    if (!_repairArray) {
        _repairArray = [NSMutableArray array];
    }
    
    return _repairArray;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}

- (ZYReportAboutRepairApplyUploadModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[ZYReportAboutRepairApplyUploadModel alloc] init];
    }
    
    return _uploadModel;
}

#pragma mark - 加载数据
- (void)initData {
    self.uploadModel.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    self.uploadModel.name = [ShareUserInfo sharedUserInfo].userInfo.realName;
    self.uploadModel.phone = [ShareUserInfo sharedUserInfo].userInfo.mobile;
    self.uploadModel.customRepairType = 2;
    [self.tableView reloadData];
}

// 房屋列表数据
- (void)initHouseListData {
    [UserHouseOrCommunityListModel getUserAllHouseListWithBlock:^(NSArray * arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            self.houseArray = [NSMutableArray arrayWithArray:[UserHouseModel mj_objectArrayWithKeyValuesArray:arr]];
            if (!self.isShowHouseView) {
                UserHouseModel *model = [self.houseArray firstObject];
                self.uploadModel.address = model.address;
                [self.tableView reloadData];
            }
            if (self.isShowHouseView) {
                [self handleHouseListData];
            }
        });
    }];
}

// 处理房屋列表数据
- (void)handleHouseListData {
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    for (UserHouseModel *model in self.houseArray) {
        [dataSourceArr addObject:model.address];
    }
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:[dataSourceArr copy] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        weakSelf.uploadModel.address = resultModel.value;
        [weakSelf.tableView reloadData];
    }];
}

// 加载报事报修类别数据
- (void)initRepairCategoryData {
    NSDictionary *params = @{@"repairOrReport" : @(self.uploadModel.customRepairType)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kGetRepairTypeCategoryUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYReportAboutRepairApplyCategoryModel class] json:responsObject[@"data"]];
                    [array enumerateObjectsUsingBlock:^(ZYReportAboutRepairApplyCategoryModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            obj.isSelected = YES;
                            self.uploadModel.typeId = obj.ID;
                        }else {
                            obj.isSelected = NO;
                        }
                    }];
                    if (self.uploadModel.customRepairType == 2) {
                        self.matterArray = [NSMutableArray arrayWithArray:array];
                    }else {
                        self.repairArray = [NSMutableArray arrayWithArray:array];
                    }
                    [self.tableView reloadData];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 上传图片数据
- (void)initUploadImageData {
    [[ToolOfNetWork sharedTools]YrequestPostHouseRepairOneImageWithURL:URL_Post_House_Repari_Img withParams:@{}.mutableCopy fileData:@[self.uploadImage].mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *url = [NSString stringWithFormat:@"%@", [responsObject objectForKey:@"data"]];
                [self.imagesArray addObject:url];
                self.uploadModel.repairImg = [self.imagesArray componentsJoinedByString:@""];
                [self.tableView reloadData];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
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
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    [self.view layoutIfNeeded];
    self.bottomView.hidden = YES;
    self.isVoice = YES;
    self.uploadModel.isPlay = NO;
    self.uploadModel.voiceLength = self.popView.duration;
    [self.tableView reloadData];
}

// 提交报事报修数据
- (void)uploadRepairData {
    NSDictionary *params = [self.uploadModel yy_modelToJSONObject];
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kAddRepairUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 发生通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"UPLOAD_REPAIR_SUCCESS_BACK");
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyInfoCellID bundle:nil] forCellReuseIdentifier:ZYReportAboutRepairApplyInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyTextCellID bundle:nil] forCellReuseIdentifier:ZYReportAboutRepairApplyTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyVoiceCellID bundle:nil] forCellReuseIdentifier:ZYReportAboutRepairApplyVoiceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isVoice) {
        
        return 3;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYReportAboutRepairApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYReportAboutRepairApplyInfoCellID forIndexPath:indexPath];
        cell.nameTF.tag = 200;
        cell.nameTF.delegate = self;
        cell.telTF.tag = 300;
        cell.telTF.delegate = self;
        cell.delegate = self;
        if (self.uploadModel.customRepairType == 2) {
            cell.dataArray = self.matterArray;
        }else {
            cell.dataArray = self.repairArray;
        }
        cell.model = self.uploadModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYReportAboutRepairApplyTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYReportAboutRepairApplyTextCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.delegate = self;
        cell.imagesArray = self.imagesArray;
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYReportAboutRepairApplyVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYReportAboutRepairApplyVoiceCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.voicePlayCompleteBlock = ^(ZYReportAboutRepairApplyUploadModel * _Nonnull model) {
            if (self.uploadModel == model) {
                self.uploadModel.isPlay = NO;
            }
        };
        cell.model = self.uploadModel;
        
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat height;
        if (self.uploadModel.customRepairType == 2) {
            if (self.matterArray.count % 2 == 0) {
                height = kZYReportAboutRepairApplyInfoCollectionViewCell_H * (self.matterArray.count / 2);
            }else {
                height = kZYReportAboutRepairApplyInfoCollectionViewCell_H * (self.matterArray.count / 2 + 1);
            }
        }else {
            if (self.repairArray.count % 2 == 0) {
                height = kZYReportAboutRepairApplyInfoCollectionViewCell_H * (self.repairArray.count / 2);
            }else {
                height = kZYReportAboutRepairApplyInfoCollectionViewCell_H * (self.repairArray.count / 2 + 1);
            }
        }
        
        return kZYReportAboutRepairApplyInfoCellHeight + height;
    }else if (indexPath.row == 1) {
        
        return kZYReportAboutRepairApplyTextCellHeight;
    }else if (indexPath.row == 2) {
        
        return kZYReportAboutRepairApplyVoiceCellHeight;
    }
    
    return 0;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.tag == 200) {
        self.uploadModel.name = textField.text;
    }else if (textField.tag == 300) {
        self.uploadModel.phone = textField.text;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.uploadModel.problem = textView.text;
}

#pragma mark - ZYReportAboutRepairApplyInfoCellDelegate
// 住址
- (void)addressViewEvent {
    NSLog(@"住址");
    
    [self.view endEditing:YES];
    self.isShowHouseView = YES;
    if (self.houseArray.count > 0) {
        [self handleHouseListData];
    }else {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initHouseListData];
    }
}

// 报事服务
- (void)matterButtonEvent {
    NSLog(@"报事服务");
    
    [self.view endEditing:YES];
    if (self.uploadModel.customRepairType != 2) {
        self.uploadModel.customRepairType = 2;
        if (self.matterArray.count > 0) {
            [self.tableView reloadData];
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initRepairCategoryData];
        }
    }
}

// 报修服务
- (void)repairButtonEvent {
    NSLog(@"报修服务");
    
    [self.view endEditing:YES];
    if (self.uploadModel.customRepairType != 1) {
        self.uploadModel.customRepairType = 1;
        if (self.repairArray.count > 0) {
            [self.tableView reloadData];
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initRepairCategoryData];
        }
    }
}

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"事项%ld", indexPath.row);
    
    [self.view endEditing:YES];
    if (self.uploadModel.customRepairType == 2) {
        ZYReportAboutRepairApplyCategoryModel *model = self.matterArray[indexPath.row];
        for (ZYReportAboutRepairApplyCategoryModel *tempModel in self.matterArray) {
            tempModel.isSelected = NO;
        }
        model.isSelected = YES;
        self.uploadModel.typeId = model.ID;
        [self.tableView reloadData];
    }else {
        ZYReportAboutRepairApplyCategoryModel *model = self.repairArray[indexPath.row];
        for (ZYReportAboutRepairApplyCategoryModel *tempModel in self.repairArray) {
            tempModel.isSelected = NO;
        }
        model.isSelected = YES;
        self.uploadModel.typeId = model.ID;
        [self.tableView reloadData];
    }
}

#pragma mark - ZYReportAboutRepairApplyTextCellDelegate
// 添加图片
- (void)addPhotos {
    NSLog(@"添加图片");
    
    [self.view endEditing:YES];
    if (self.imagesArray.count < 3) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakeVideo = NO;
        // 你可以通过block或者代理，来得到用户选择的照片.
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos.count > 0) {
                self.uploadImage = [photos firstObject];
                [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
                [weakSelf initUploadImageData];
            }
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"最多上传3张图片" toView:self.view];
    }
}

// 选中图片
- (void)imageViewTapWithIndex:(NSInteger)index {
    NSLog(@"选中图片%ld", index);
    [self.view endEditing:YES];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        NSString *urlStr = [[self.imagesArray[i] componentsSeparatedByString:@";"] firstObject];
        photoModel.url = [NSURL URLWithString:urlStr];
        photoModel.originUrl = [NSURL URLWithString:urlStr];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

// 删除图片
- (void)deletePhotoWithIndex:(NSInteger)index {
    NSLog(@"删除图片%ld", index);
    
    [self.view endEditing:YES];
    [self.imagesArray removeObjectAtIndex:index];
    self.uploadModel.repairImg = [self.imagesArray componentsJoinedByString:@""];
    [self.tableView reloadData];
}

#pragma mark - ZYReportAboutRepairApplyVoiceCellDelegate
// 播放
- (void)playButtonEvent {
    NSLog(@"播放语音");
    
    [self.view endEditing:YES];
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
    
    [self.view endEditing:YES];
    self.uploadModel.voiceUrl = @"";
    self.uploadModel.voiceLength = 0;
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(kZYReportAboutRepairApplyBottomViewHeight);
    }];
    [self.view layoutIfNeeded];
    self.bottomView.hidden = NO;
    [self stopVoice];
    self.isVoice = NO;
    [self.tableView reloadData];
}

#pragma mark - ZYReportAboutRepairApplyBottomViewDelegate
// 按下事件
- (void)voiceButtonTouchDownEvent {
    NSLog(@"按下事件");
    
    [self.view endEditing:YES];
    // 是否有麦克风权限
    if (![[ZYAuthorizationManager sharedManager] requestAuthorization:KAVAudioSession presentVc:self]) {
        self.isAutoEndVoiceMark = YES;
        return;
    }
    self.popView = [[NSBundle mainBundle] loadNibNamed:@"ZYReportAboutRepairApplyVoicePopView" owner:nil options:nil].lastObject;
    [self.popView showIssueActivityVoicePopView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startVoice];
    });
}

// 松开事件
- (void)voiceButtonTouchUpEvent {
    NSLog(@"松开事件");
    
    [self.view endEditing:YES];
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

#pragma mark - 处理点击事件
// 提交
- (void)navRightBtnAction {
    NSLog(@"提交");
    
    [self.view endEditing:YES];
    if ([self judgeNoEmptyData]) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
        [self uploadRepairData];
    }
}

// 数据不为空判断
- (BOOL)judgeNoEmptyData {
    if (self.uploadModel.name.length > 0) {
        if (self.uploadModel.phone.length > 0) {
            if (self.uploadModel.address.length > 0) {
                if (self.uploadModel.customRepairType != 0) {
                    if (self.uploadModel.typeId.length > 0) {
                        if (self.uploadModel.problem.length > 0) {
                            if (self.uploadModel.repairImg.length > 0) {
                                
                                return YES;
                            }else {
                                [ZYProgressHUDTool showCustomHUDTextMessage:@"请上传图片" toView:self.view];
                            }
                        }else {
                            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入上报内容" toView:self.view];
                        }
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择事项" toView:self.view];
                    }
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择类别" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择住址" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入姓名" toView:self.view];
    }
    
    return NO;
}

@end
