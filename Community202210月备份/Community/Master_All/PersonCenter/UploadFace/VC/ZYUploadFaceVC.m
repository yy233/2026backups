//
//  ZYUploadFaceVC.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceVC.h"
#import "ZYUploadFaceCompleteVC.h"
#import "ZYUploadFaceTopView.h"
#import "ZYUploadFaceView.h"
#import "ZYUploadFaceEmptyView.h"
#import "ZYUploadFaceBottomView.h"
#import "ZYUploadFaceSelectedView.h"
#import "ZYUploadFaceModel.h"

static CGFloat uploadFaceSelectedViewDuration = 0.25;
#define kZYUploadFaceTopViewHeight 40
#define kZYUploadFaceViewHeight 300
#define kZYUploadFaceSelectedViewHeight (190+button_bottom_height)

@interface ZYUploadFaceVC () <ZYUploadFaceViewDelegate ,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ZYUploadFaceTopView *topView;

@property (nonatomic, strong) ZYUploadFaceView *uploadFaceView;

@property (nonatomic, strong) ZYUploadFaceEmptyView *uploadFaceEmptyView;

@property (nonatomic, strong) ZYUploadFaceBottomView *uploadFaceBottomView;

@property (nonatomic, strong) ZYUploadFaceSelectedView *uploadFaceSelectedView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

@property (nonatomic, strong) ZYUploadFaceModel *uploadFaceModel;

@end

@implementation ZYUploadFaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传人脸";
    [self setUI];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initGetUploadFaceData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kZYUploadFaceTopViewHeight);
    }];
    
    [self.view addSubview:self.uploadFaceBottomView];
    [_uploadFaceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_uploadFaceBottomView.superview);
        make.bottom.equalTo(_uploadFaceBottomView.superview).offset(-button_bottom_height);
        make.height.offset(90);
    }];
    
    [self.view addSubview:self.uploadFaceView];
    [self.uploadFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(_uploadFaceView.superview);
        make.height.offset(kZYUploadFaceViewHeight);
    }];
    
    [self.view addSubview:self.uploadFaceEmptyView];
    [_uploadFaceEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.equalTo(_uploadFaceEmptyView.superview);
        make.bottom.equalTo(_uploadFaceBottomView.mas_top);
    }];
    
    [self.view addSubview:self.uploadFaceSelectedView];
    [_uploadFaceSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_uploadFaceSelectedView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYUploadFaceTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceTopView" owner:nil options:nil].lastObject;
    }
    
    return _topView;
}

- (ZYUploadFaceView *)uploadFaceView {
    if (!_uploadFaceView) {
        _uploadFaceView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceView" owner:nil options:nil].lastObject;
        _uploadFaceView.hidden = YES;
        _uploadFaceView.delegate = self;
    }
    
    return _uploadFaceView;
}

- (ZYUploadFaceEmptyView *)uploadFaceEmptyView {
    if (!_uploadFaceEmptyView) {
        _uploadFaceEmptyView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceEmptyView" owner:nil options:nil].lastObject;
        _uploadFaceEmptyView.hidden = YES;
    }
    
    return _uploadFaceEmptyView;
}

- (ZYUploadFaceBottomView *)uploadFaceBottomView {
    if (!_uploadFaceBottomView) {
        _uploadFaceBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceBottomView" owner:nil options:nil].lastObject;
        _uploadFaceBottomView.hidden = YES;
        [_uploadFaceBottomView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadFaceBottomView;
}

- (ZYUploadFaceSelectedView *)uploadFaceSelectedView {
    if (!_uploadFaceSelectedView) {
        _uploadFaceSelectedView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceSelectedView" owner:nil options:nil].lastObject;
        _uploadFaceSelectedView.hidden = YES;
        _uploadFaceSelectedView.contentViewHeightConstraint.constant = 0;
        [_uploadFaceSelectedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadFaceBottomViewTap)]];
        [_uploadFaceSelectedView.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
        [_uploadFaceSelectedView.cameraView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTap)]];
        [_uploadFaceSelectedView.albumView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumViewTap)]];
    }
    
    return _uploadFaceSelectedView;
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

- (ZYUploadFaceModel *)uploadFaceModel {
    if (!_uploadFaceModel) {
        _uploadFaceModel = [[ZYUploadFaceModel alloc] init];
    }
    
    return _uploadFaceModel;
}

#pragma mark - 加载数据
// 我的人脸数据
- (void)initGetUploadFaceData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kGetUploadFaceUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYUploadFaceModel *model = [ZYUploadFaceModel yy_modelWithJSON:responsObject[@"data"]];
                if (model.faceUrl.length > 0) {
                    if (self.imagesArray.count > 0) {
                        [self.imagesArray removeAllObjects];
                    }
                    self.uploadFaceModel = model;
                    [self.imagesArray addObject:model.faceUrl];
                    self.uploadFaceView.hidden = NO;
                    self.uploadFaceEmptyView.hidden = YES;
                    self.uploadFaceBottomView.hidden = YES;
                }else {
                    self.uploadFaceView.hidden = YES;
                    self.uploadFaceEmptyView.hidden = NO;
                    self.uploadFaceBottomView.hidden = NO;
                }
                [self reloadInputCollectionView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 上传人脸数据
- (void)initUploadFaceData {
    [[ToolOfNetWork sharedTools] YrequestImgFileArrWithALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kUploadFaceUrl] withParams:@{}.mutableCopy fileDataArr:self.uploadImagesArray fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *faceUrl = responsObject[@"data"];
                if (self.imagesArray.count > 0) {
                    [self.imagesArray removeAllObjects];
                }
                self.uploadFaceModel.faceUrl = faceUrl;
                [self.imagesArray addObject:faceUrl];
                // 保存人脸
                [self initSaveUploadFaceData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 保存我的人脸
- (void)initSaveUploadFaceData {
    NSDictionary *params = @{@"faceUrl" : self.uploadFaceModel.faceUrl};
    [[ToolOfNetWork sharedTools] YrequestPUTALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kSaveUploadFaceUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.uploadFaceView.hidden = YES;
                self.uploadFaceEmptyView.hidden = YES;
                self.uploadFaceBottomView.hidden = YES;
                [self reloadInputCollectionView];
                ZYUploadFaceCompleteVC *vc = [[ZYUploadFaceCompleteVC alloc] init];
                [self pushVc:vc];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除我的人脸
- (void)initDeleteUploadFaceData {
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kDeleteUploadFaceUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.imagesArray.count > 0) {
                    [self.imagesArray removeAllObjects];
                }
                self.uploadFaceView.hidden = YES;
                self.uploadFaceEmptyView.hidden = NO;
                self.uploadFaceBottomView.hidden = NO;
                [self reloadInputCollectionView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 刷新集合视图
- (void)reloadInputCollectionView {
    if (self.imagesArray.count > 0) {
        self.uploadFaceBottomView.okButton.enabled = NO;
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            self.uploadFaceBottomView.okButton.backgroundColor = [UIColor grayColor];
        }else {
            self.uploadFaceBottomView.okButton.backgroundColor = Y_RGBA(75, 88, 107, 1);
        }
        [self.uploadFaceBottomView.okButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else {
        self.uploadFaceBottomView.okButton.enabled = YES;
        self.uploadFaceBottomView.okButton.backgroundColor = Y_RGBA(38, 114, 249, 1);
        [self.uploadFaceBottomView.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    self.uploadFaceView.typeStr = @"edit";
    self.uploadFaceView.imagesArray = self.imagesArray;
    self.uploadFaceView.status = self.uploadFaceModel.examineStatus;
    [self.uploadFaceView reloadInputViews];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = info[UIImagePickerControllerEditedImage];
    if (self.uploadImagesArray.count > 0) {
        [self.uploadImagesArray removeAllObjects];
    }
    [self.uploadImagesArray addObject:photo];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
    [self initUploadFaceData];
}

#pragma mark - ZYUploadFaceViewDelegate
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

- (void)deletePhotoWithIndex:(NSInteger)index {
    
    NSLog(@"删除照片 %ld", index);
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
    [self initDeleteUploadFaceData];
}

#pragma mark - 点击事件
// 添加人脸
- (void)okButtonClicked {
    
    NSLog(@"添加人脸");
    self.uploadFaceSelectedView.hidden = NO;
    self.uploadFaceSelectedView.alpha = 0;
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = kZYUploadFaceSelectedViewHeight;
        self.uploadFaceSelectedView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

// 选择视图
- (void)uploadFaceBottomViewTap {
    
    self.uploadFaceSelectedView.alpha = 1;
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 0;
        self.uploadFaceSelectedView.alpha = 0;
        [self.view layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(uploadFaceSelectedViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.uploadFaceSelectedView.hidden = YES;
    });
}

- (void)contentViewTap {
}

// 相机
- (void)cameraViewTap {
    
    NSLog(@"相机");
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(uploadFaceSelectedViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.uploadFaceSelectedView.hidden = YES;
    });
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.delegate = self;
    pickVC.allowsEditing = YES;
    pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickVC animated:YES completion:nil];
}

// 相册
- (void)albumViewTap {
    
    NSLog(@"相册");
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(uploadFaceSelectedViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.uploadFaceSelectedView.hidden = YES;
    });
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            if (weakSelf.uploadImagesArray.count > 0) {
                [weakSelf.uploadImagesArray removeAllObjects];
            }
            [weakSelf.uploadImagesArray addObject:photos.firstObject];
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
            [self initUploadFaceData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
