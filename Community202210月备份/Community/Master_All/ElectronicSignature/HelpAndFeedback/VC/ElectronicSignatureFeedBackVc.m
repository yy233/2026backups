//
//  ElectronicSignatureFeedBackVc.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ElectronicSignatureFeedBackVc.h"
#import "FeedbackTextViewTableViewCell.h"
#import "FeedbackTextFieldTableViewCell.h"
#import "FeedbackCollectionViewTableViewCell.h"
#import "FeedbackEmptyTableViewCell.h"
#import "ZYSealImageModel.h"
#import "UITextView+YLTextView.h"

#define  FeedbackTextViewTableViewCell_Identifier                    @"FeedbackTextViewTableViewCell"
#define  FeedbackTextFieldTableViewCell_Identifier                   @"FeedbackTextFieldTableViewCell"
#define  FeedbackCollectionViewTableViewCell_Identifier              @"FeedbackCollectionViewTableViewCell"

static NSString * const feedbackEmptyTableViewCellID = @"FeedbackEmptyTableViewCell";
#define kFeedbackEmptyTableViewCellHeight 35
#define Height_CollSubImg (((Screen_W-32)-31)/4)

typedef enum : NSUInteger {
    Photo_mode_Type_Grapht,
    Photo_mode_Type_Album
} Photo_mode_Type;

@interface ElectronicSignatureFeedBackVc () <UITableViewDataSource,UITableViewDelegate,FeedbackCollectionViewTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) ElectronicSignatureBaseFooterView *footerView;

@property (nonatomic, strong) GKPhotoBrowser *browser;

@property (nonatomic, strong) NSMutableArray *iconImageArray;

@property (nonatomic, strong) NSArray *photosArray;

@property (nonatomic, strong) NSMutableArray *imageArray;

// 当前选择图片
@property (nonatomic, strong) UIImage *currentImage;

// 当前选中图片model
@property (nonatomic, strong) ZYSealImageDataModel *selectedImageModel;

// 描述问题内容
@property (nonatomic, copy) NSString *describeStr;

// 联系电话
@property (nonatomic, copy) NSString *telStr;

@end

@implementation ElectronicSignatureFeedBackVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"问题反馈";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"FeedbackEmptyTableViewCell" bundle:nil] forCellReuseIdentifier:feedbackEmptyTableViewCellID];
    }
    
    return _tableView;
}

- (ElectronicSignatureBaseFooterView *)footerView{
    if (!_footerView) {
        _footerView  = [[ElectronicSignatureBaseFooterView alloc]initWithFrame:CGRectZero];
        [_footerView.footerBtn setTitle:@"立即提交" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(oKAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

- (UIImage *)currentImage {
    if (!_currentImage) {
        _currentImage = [[UIImage alloc] init];
    }
    
    return _currentImage;
}

- (NSMutableArray *)iconImageArray {
    if (!_iconImageArray) {
        _iconImageArray = [NSMutableArray array];
    }
    
    return _iconImageArray;
}

- (NSArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSArray array];
    }
    
    return _photosArray;
}

#pragma mark - 数据加载
// 附件图片批量上传
- (void)initFileImageUploadsData {
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureImgFilesArrWithURL:kFileUploadsUrl withParams:@{}.mutableCopy fileDataArr:self.photosArray.mutableCopy fileNameStr:@"" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {

                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYSealImageDataModel class] json:responsObject[@"data"]];
                [self.imageArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }else {

                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {

            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 图片附件删除
- (void)initFileImageDeleteData {
    NSDictionary *parms = @{@"uuid" : self.selectedImageModel.uuid};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kFileDeleteUrl withParams:parms.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.imageArray removeObject:self.selectedImageModel];
                [self.iconImageArray removeObject:self.currentImage];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 意见反馈数据
- (void)initFeedbackData {
    NSMutableArray *imageIdArray = [NSMutableArray array];
    for (ZYSealImageDataModel *tempModel in self.imageArray) {
        [imageIdArray addObject:tempModel.uuid];
    }
    NSString *imageIdJsonStr = [imageIdArray yy_modelToJSONString];
    NSDictionary *params = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"description" : self.describeStr, @"srcList" : imageIdJsonStr, @"telNo" : self.telStr};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kFeedbackInsertUrl withBody:params finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"反馈成功" toView:self.view.window];
                [self popVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark== 照片
- (void)addPhotosAction{ 
    
    [self enterMultiSelectedAlbum];
}

- (void)deletPhotoActionWithIndex:(NSInteger)itemNum{
    
    self.selectedImageModel = self.imageArray[itemNum];
    self.currentImage = self.iconImageArray[itemNum];
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"删除中..."];
    [self initFileImageDeleteData];
}

- (void)imgViewTapWithIndex:(NSInteger)index {
    
    NSMutableArray *photos = [NSMutableArray array];
    for (ZYSealImageDataModel *model in self.imageArray) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, model.url]];
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = url;
        photoModel.originUrl = url;
        [photos addObject:photoModel];
    }
    self.browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.browser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.browser showFromVC:self];
}

#pragma mark - 进入多选相册
- (void)enterMultiSelectedAlbum {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            NSMutableArray *tempIconImageArray = [NSMutableArray arrayWithArray:[weakSelf.iconImageArray copy]];
            NSMutableArray *tempPhotosArray = [NSMutableArray array];
            [tempIconImageArray addObjectsFromArray:photos];
            if (tempIconImageArray.count > 10) {
                for (NSInteger i = weakSelf.iconImageArray.count; i < 10; i++) {
                    UIImage *image = tempIconImageArray[i];
                    [tempPhotosArray addObject:image];
                }
            }else {
                [tempPhotosArray addObjectsFromArray:photos];
            }
            weakSelf.photosArray = [tempPhotosArray copy];
            [weakSelf.iconImageArray addObjectsFromArray:[tempPhotosArray copy]];
            
            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
            [weakSelf initFileImageUploadsData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.text.length >= 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.telStr = textField.text;
}

#pragma mark==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 200;
    }else if(indexPath.row == 1){
        NSInteger countMax = self.imageArray.count + 1;
        float h = ((countMax/4) + (countMax%4>0?1:0)) * (Height_CollSubImg + 10) + 40;
        h = (h > (Height_CollSubImg + 50)) ? h : (Height_CollSubImg + 50);
        return h;
    }else if(indexPath.row == 2){
        return 90;
    }else{
        return kFeedbackEmptyTableViewCellHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        FeedbackTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedbackTextViewTableViewCell_Identifier];
        if (!cell) {
            cell = [[FeedbackTextViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FeedbackTextViewTableViewCell_Identifier];
        }
        cell.textView.infoBlock = ^(NSString *text, CGSize textViewSize) {
            self.describeStr = text;
            NSLog(@"%@", text);
        };
        
        return cell;
    }else if (indexPath.row==1){
        FeedbackCollectionViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedbackCollectionViewTableViewCell_Identifier];
        if (!cell) {
            cell = [[FeedbackCollectionViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FeedbackCollectionViewTableViewCell_Identifier];
        }
        cell.deleagte = self;
        cell.imageArray = self.imageArray;
        
        return cell;
    }else if (indexPath.row==2){
        FeedbackTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedbackTextFieldTableViewCell_Identifier];
        if (!cell) {
            cell = [[FeedbackTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FeedbackTextFieldTableViewCell_Identifier];
        }
        cell.textField.delegate = self;
        
        return cell;
    }else{
        FeedbackEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedbackEmptyTableViewCellID forIndexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - 处理点击事件
- (void)oKAction{
    [self.view endEditing:YES];
    if (self.describeStr.length > 0) {
        if (self.telStr.length > 0) {
            if ([ZYTextValidationTool validatePhone:[self.telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"提交中..."];
                [self initFeedbackData];
            }else {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
            }
        }else {
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请填写联系电话" toView:self.view];
        }
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请填写描述内容" toView:self.view];
    }
}

@end
