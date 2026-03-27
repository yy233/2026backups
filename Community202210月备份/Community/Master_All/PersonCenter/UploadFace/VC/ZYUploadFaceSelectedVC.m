//
//  ZYUploadFaceSelectedVC.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceSelectedVC.h"
#import "ZYUploadFaceCompleteVC.h"
#import "ZYUploadFaceView.h"
#import "ZYUploadFaceBottomView.h"
#import "ZYUploadFaceSelectedView.h"

static CGFloat uploadFaceSelectedViewDuration = 0.25;

@interface ZYUploadFaceSelectedVC () <ZYUploadFaceViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ZYUploadFaceView *uploadFaceView;

@property (nonatomic, strong) ZYUploadFaceBottomView *uploadFaceBottomView;

@property (nonatomic, strong) ZYUploadFaceSelectedView *uploadFaceSelectedView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

@end

@implementation ZYUploadFaceSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"上传人脸";
    [self setUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.uploadFaceBottomView];
    [_uploadFaceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_uploadFaceBottomView.superview);
        make.bottom.equalTo(_uploadFaceBottomView.superview).offset(-button_bottom_height);
        make.height.offset(90);
    }];
    [self.view addSubview:self.uploadFaceView];
    [self.uploadFaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_uploadFaceView.superview);
        make.height.offset(80 + (kScreenW - 32 - 20) / 3.0);
    }];
    [self.view addSubview:self.uploadFaceSelectedView];
    [_uploadFaceSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_uploadFaceSelectedView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYUploadFaceView *)uploadFaceView {
    if (!_uploadFaceView) {
        _uploadFaceView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceView" owner:nil options:nil].lastObject;
        _uploadFaceView.delegate = self;
    }
    
    return _uploadFaceView;
}

- (ZYUploadFaceBottomView *)uploadFaceBottomView {
    if (!_uploadFaceBottomView) {
        _uploadFaceBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceBottomView" owner:nil options:nil].lastObject;
        [_uploadFaceBottomView.okButton setTitle:@"确认上传照片" forState:UIControlStateNormal];
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

#pragma mark - 加载数据
- (void)initData {
    
    self.uploadFaceView.typeStr = @"add";
    self.uploadFaceView.imagesArray = self.imagesArray;
    [self.view reloadInputViews];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.imagesArray addObject:photo];
    [self initData];
}

#pragma mark - ZYUploadFaceViewDelegate
- (void)addPhotos {
    
    NSLog(@"添加照片");
    self.uploadFaceSelectedView.hidden = NO;
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 190;
        [self.view layoutIfNeeded];
    }];
}

- (void)imageViewTapWithIndex:(NSInteger)index {
    
    NSLog(@"点击照片 %ld", index);
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.image = self.imagesArray[i];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

- (void)deletePhotoWithIndex:(NSInteger)index {
    
    NSLog(@"删除照片 %ld", index);
    [self.imagesArray removeObjectAtIndex:index];
    [self initData];
}

#pragma mark - 点击事件
// 选择视图
- (void)uploadFaceBottomViewTap {
    
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 0;
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
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
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
            [weakSelf.imagesArray addObjectsFromArray:[tempPhotosArray copy]];
            [weakSelf initData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 确认
- (void)okButtonClicked {
    
    NSLog(@"确认");
    ZYUploadFaceCompleteVC *vc = [[ZYUploadFaceCompleteVC alloc] init];
    [self pushVc:vc];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_FACE_SELECTED_BACK" object:self.imagesArray];
}

@end
