//
//  ZYZhangManagerVc.m
//  Community
//
//  Created by ZY on 2021/5/10.
//

#import "ZYZhangManagerVc.h"
#import "ZYZhangManagerVcTableViewCell.h"
#import "ZYZhangManagerBottomView.h"
#import "ZYUploadFaceSelectedView.h"
#import "ZYSealImageModel.h"
 
static CGFloat uploadFaceSelectedViewDuration = 0.25;
static NSString * const zhangManagerVcTableViewCellID = @"ZYZhangManagerVcTableViewCell";
#define kZhangManagerVcTableViewCellHeight 155

@interface ZYZhangManagerVc () <UITableViewDataSource, UITableViewDelegate, ZYZhangManagerBottomViewDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZYZhangManagerBottomView *bottomView;

@property (nonatomic, strong) ZYUploadFaceSelectedView *uploadFaceSelectedView;

@property (nonatomic, strong) ZYSealImageDataModel *sealModel;

@property (nonatomic, strong) UIImage *sealImage;

@property (nonatomic, strong) ZYZhangManagerDataModel *currentModel;

@end

@implementation ZYZhangManagerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的印章";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.bottom.equalTo(_bottomView.superview).offset(-button_bottom_height);
        make.height.offset(70);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [self.view addSubview:self.uploadFaceSelectedView];
    [_uploadFaceSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_uploadFaceSelectedView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (ZYZhangManagerBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYZhangManagerBottomView" owner:nil options:nil].lastObject;
        _bottomView.hidden = YES;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 全部印章数据
- (void)initData {
    
    NSString *uuid = [ShareUserInfo sharedUserInfo].userInfo.uid;
    NSDictionary *parms = @{@"userUuid" : uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kAllSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYZhangManagerDataModel class] json:jsonStr];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                
                BOOL isHidden = NO;
                for (ZYZhangManagerDataModel *tempModel in self.dataArray) {
                    if (tempModel.type == 2) {
                        isHidden = YES;
                    }
                }
                self.bottomView.hidden = isHidden;
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 新增用户个人印章数据
- (void)initAddPersonalSealData {
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"fileUuid" : self.sealModel.uuid, @"sealName" : self.sealModel.fileName};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kAddPersonalSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"上传成功" toView:self.view];
                [self initData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除用户个人印章数据
- (void)initDeletePersonalSealData {
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"sealUuid" : self.currentModel.uuid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kDeletePersonalSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"删除成功" toView:self.view];
                [self initData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 印章图片上传
- (void)initSealImageUploadData {
    NSDictionary *parms = @{@"description" : @"个人印章"};
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:self.sealImage];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignature100KBImgFilesWithURL:kFileUploadUrl withParams:parms.mutableCopy fileDataArr:mArray fileNameStr:@"" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                ZYSealImageModel *model = [ZYSealImageModel yy_modelWithJSON:responsObject];
                self.sealModel = model.data;
                [self initAddPersonalSealData];
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
    
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 设置tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYZhangManagerVcTableViewCell" bundle:nil] forCellReuseIdentifier:zhangManagerVcTableViewCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYZhangManagerVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zhangManagerVcTableViewCellID forIndexPath:indexPath];
    ZYZhangManagerDataModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.deleteButton.tag = 200 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZhangManagerVcTableViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    self.sealImage = photo;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
    [self initSealImageUploadData];
}

#pragma mark - ZYZhangManagerBottomViewDelegate
- (void)uploadButtonEvent {
    
    NSLog(@"上传个人印章");
    self.uploadFaceSelectedView.hidden = NO;
    self.uploadFaceSelectedView.alpha = 0;
    [UIView animateWithDuration:uploadFaceSelectedViewDuration animations:^{
        self.uploadFaceSelectedView.contentViewHeightConstraint.constant = 190;
        self.uploadFaceSelectedView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 处理点击事件
- (void)deleteButtonClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 200;
    ZYZhangManagerDataModel *model = self.dataArray[index];
    self.currentModel = model;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
    [self initDeletePersonalSealData];
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
            weakSelf.sealImage = [photos firstObject];
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
            [weakSelf initSealImageUploadData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
