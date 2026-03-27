//
//  ZYCommunityFairIssueVc.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueVc.h"
#import "ZYCommunityFairIssueSuccessVc.h"
#import "ZYCommunityFairIssueInputCell.h"
#import "ZYCommunityFairIssueMarkCell.h"
#import "ZYCommunityFairIssueTextCell.h"
#import "ZYCommunityFairIssueVideoCell.h"
#import "ZYCommunityFairIssuePhotoCell.h"
#import "ZYCommunityFairIssueTopView.h"
#import "ZYCommunityFairIssueBottomView.h"
#import "MovEncodeToMpegTool.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFPlayerConst.h>
@import AVKit;
// 视频压缩
#import "WAVideoBox.h"
#import "ZYCommunityFairTypeModel.h"
#import "ZYCommunityFairMarkModel.h"
#import "ZYIssueActivityFileModel.h"
//
#import "LdleGoodsModel.h"
#import "LdleGoodsData.h"
#import "LdleGoodDetailVC.h"
#import "ChatManagerData.h"


static NSString * const ZYCommunityFairIssueInputCellID = @"ZYCommunityFairIssueInputCell";
static NSString * const ZYCommunityFairIssueMarkCellID = @"ZYCommunityFairIssueMarkCell";
static NSString * const ZYCommunityFairIssueTextCellID = @"ZYCommunityFairIssueTextCell";
static NSString * const ZYCommunityFairIssueVideoCellID = @"ZYCommunityFairIssueVideoCell";
static NSString * const ZYCommunityFairIssuePhotoCellID = @"ZYCommunityFairIssuePhotoCell";
#define kZYCommunityFairIssueInputCellHeight 276
#define kZYCommunityFairIssueMarkCellHeight 48
#define kZYCommunityFairIssueTextCellHeight 200
#define kZYCommunityFairIssueVideoCellHeight 240
#define kZYCommunityFairIssuePhotoCellHeight 62
#define kZYCommunityFairIssueTopViewHeight 44+status_height
#define kZYCommunityFairIssueBottomViewHeight 45+button_bottom_height

@interface ZYCommunityFairIssueVc () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ZYCommunityFairIssueInputCellDelegate, ZYCommunityFairIssueVideoCellDelegate, ZYCommunityFairIssuePhotoCellDelegate, ZYCommunityFairIssueTopViewDelegate, ZYCommunityFairIssueBottomViewDelegate, TTGTextTagCollectionViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYCommunityFairIssueTopView *topView;

@property (nonatomic, strong) ZYCommunityFairIssueBottomView *bottomView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) NSMutableArray *marksArray;

@property (nonatomic, strong) NSMutableArray *markTagsArray;

@property (nonatomic, strong) NSMutableArray *markTagsTempArray;

// 选中的标签index
@property (nonatomic, assign) NSInteger selectedMarkIndex;

@property (nonatomic, assign) CGFloat textTagCollectionViewHeight;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, strong) NSMutableArray *uploadImagesArray;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStringContent *selectedContent;

@property (nonatomic, strong) TTGTextTagStyle *style;

@property (nonatomic, strong) TTGTextTagStyle *selectedStyle;

// 分类数组
@property (nonatomic, strong) NSMutableArray *categoryArray;

// 视频相关
@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) UIButton *videoDeleteButton;

// 视频处理
@property (nonatomic , strong) WAVideoBox *videoBox;

@property (nonatomic, strong) ZYCommunityFairIssueModel *issueModel;

// 视频上传地址
@property (nonatomic, strong) NSURL *videoPath;

@end

@implementation ZYCommunityFairIssueVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    [self setUI];
    [self customTableView];
    [self initData];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMarketData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    [self hiddenNavigationBar];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        if (self.type == ZYCommunityFairIssue_Type_Add) {
            [self showSaveAlert];
        }else {
            [self popVC];
        }
    }
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kZYCommunityFairIssueTopViewHeight);
    }];
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kZYCommunityFairIssueBottomViewHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom);
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

- (ZYCommunityFairIssueTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairIssueTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (ZYCommunityFairIssueBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairIssueBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSMutableArray *)marksArray {
    if (!_marksArray) {
        _marksArray = [NSMutableArray array];
    }
    
    return _marksArray;
}

- (NSMutableArray *)markTagsArray {
    if (!_markTagsArray) {
        _markTagsArray = [NSMutableArray array];
    }
    
    return _markTagsArray;
}

- (NSMutableArray *)markTagsTempArray {
    if (!_markTagsTempArray) {
        _markTagsTempArray = [NSMutableArray array];
    }
    
    return _markTagsTempArray;
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

- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    
    return _categoryArray;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:13];
        if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
            _content.textColor = [UIColor zy_colorWithHexString:@"#AAAAB9"];
        }else {
            _content.textColor = [UIColor whiteColor];
        }
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:13];
        _selectedContent.textColor = [UIColor whiteColor];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [UIColor clearColor];
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0.5;
        _style.borderColor = [ZYThemeManager shareManager].borderThemeColor;
        _style.cornerRadius = 11;
        _style.extraSpace = CGSizeMake(20, 0);
        _style.exactHeight = 22;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = Y_RGBA(38, 114, 249, 1);
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0.5;
        _selectedStyle.borderColor = Y_RGBA(38, 114, 249, 1);
        _selectedStyle.cornerRadius = 11;
        _selectedStyle.extraSpace = CGSizeMake(20, 0);
        _selectedStyle.exactHeight = 22;
    }
    
    return _selectedStyle;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
//        _controlView.fastViewAnimated = YES;
        _controlView.horizontalPanShowControlView = NO;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.seekToPlay = NO;
    }
    return _controlView;
}

- (WAVideoBox *)videoBox {
    if (!_videoBox) {
        _videoBox = [[WAVideoBox alloc] init];
    }
    
    return _videoBox;
}

- (ZYCommunityFairIssueModel *)issueModel {
    if (!_issueModel) {
        _issueModel = [[ZYCommunityFairIssueModel alloc] init];
    }
    
    return _issueModel;
}

#pragma mark - 加载数据
- (void)initData {
    self.issueModel.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    self.issueModel.phone = [ShareUserInfo sharedUserInfo].userInfo.mobile;
    self.issueModel.negotiable = 1;
    [self.tableView reloadData];
    
    if (self.type == ZYCommunityFairIssue_Type_Edit) {//编辑状态
        
        WEAKSELF
        [LdleGoodsData getLdleOneGoodsDetailInfoWithIdStr:self.idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                weakSelf.issueModel = [ZYCommunityFairIssueModel yy_modelWithDictionary:dic];
                if (weakSelf.issueModel.imagesUrl.length>0) {
                    weakSelf.imagesArray = [NSMutableArray arrayWithArray:[weakSelf.issueModel.imagesUrl componentsSeparatedByString:@","]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
                
            }
        }];
    }
}

// 加载商品分类数据
- (void)initCategoryData {
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:Y_BASEURL(kCommunityFairCategoryUrl) withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.categoryArray.count > 0) {
                    [self.categoryArray removeAllObjects];
                }
                ZYCommunityFairTypeModel *model = [ZYCommunityFairTypeModel yy_modelWithJSON:responsObject];
                [self.categoryArray addObjectsFromArray:model.data];
                [self handleCategoryData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理商品分类数据
- (void)handleCategoryData {
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (ZYCommunityFairTypeDataModel *model in self.categoryArray) {
        [categoryArray addObject:model.categoryName];
    }
    WEAKSELF
    [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:categoryArray selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        ZYCommunityFairTypeDataModel *model = weakSelf.categoryArray[resultModel.index];
        weakSelf.issueModel.categoryId = model.ID;
        weakSelf.issueModel.categoryName = model.categoryName;
        [weakSelf.tableView reloadData];
    }];
}

// 加载商品标签数据
- (void)initMarketData {
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:Y_BASEURL(kCommunityFairMarkUrl) withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.marksArray.count > 0) {
                    [self.marksArray removeAllObjects];
                }
                ZYCommunityFairMarkModel *model = [ZYCommunityFairMarkModel yy_modelWithJSON:responsObject];
                NSArray *array = model.data;
                [self.marksArray addObjectsFromArray:array];
                [self handleMarkData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理商品标签数据
- (void)handleMarkData {
    if (self.markTagsArray.count > 0) {
        [self.markTagsArray removeAllObjects];
    }
    if (self.markTagsTempArray.count > 0) {
        [self.markTagsTempArray removeAllObjects];
    }
    for (int i = 0; i < self.marksArray.count; i++) {
        ZYCommunityFairMarkDataModel *model = self.marksArray[i];
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = model.labelName;
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = model.labelName;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.markTagsArray addObject:tag];
        [self.markTagsTempArray addObject:tag];
    }
    [self.tableView reloadData];
}

// 上传多张图片
- (void)initImagesUploadsData {
    [[ToolOfNetWork sharedTools] YrequestImgFileArrWithALLURL:ZY_BASEURL(kBaseFilesUploadUrl) withParams:@{}.mutableCopy fileDataArr:self.uploadImagesArray.mutableCopy fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYIssueActivityFileModel class] json:responsObject[@"data"]];
                for (ZYIssueActivityFileModel *model in array) {
                    [self.imagesArray addObject:model.url];
                }
                self.issueModel.imagesUrl = [self.imagesArray componentsJoinedByString:@","];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 上传视频
- (void)initVideoUploadData {
    [[ToolOfNetWork sharedTools] YrequestVideoFileArrWithALLURL:ZY_BASEURL(kBaseFilesUploadUrl) withParams:@{}.mutableCopy filePath:self.videoPath finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYIssueActivityFileModel class] json:responsObject[@"data"]];
                ZYIssueActivityFileModel *model = [array firstObject];
                self.issueModel.mvUrl = model.url;
                [self handleVideo:self.videoPath];
//                NSString *videoPath = [NSString stringWithFormat:@"%@.mp4", model.url];
//                [self handleVideo:[NSURL URLWithString:videoPath]];
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairIssueInputCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairIssueInputCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairIssueMarkCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairIssueMarkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairIssueTextCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairIssueTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairIssueVideoCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairIssueVideoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairIssuePhotoCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairIssuePhotoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYCommunityFairIssueInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairIssueInputCellID forIndexPath:indexPath];
        cell.nameTF.tag = 200;
        cell.nameTF.delegate = self;
        cell.priceTF.tag = 300;
        cell.priceTF.delegate = self;
        cell.delegate = self;
        cell.model = self.issueModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYCommunityFairIssueMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairIssueMarkCellID forIndexPath:indexPath];
        if (self.markTagsTempArray.count > 0) {
            cell.textTagCollectionView.delegate = self;
            [cell.textTagCollectionView addTags:self.markTagsTempArray];
            self.textTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            self.selectedMarkIndex = 0;
            ZYCommunityFairMarkDataModel *model = self.marksArray[self.selectedMarkIndex];
            self.issueModel.labelId = model.ID;
            self.issueModel.labelName = model.labelName;
            [cell.textTagCollectionView updateTagAtIndex:0 selected:YES];
            [self.markTagsTempArray removeAllObjects];
        }
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYCommunityFairIssueTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairIssueTextCellID forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.model = self.issueModel;
        
        return cell;
    }else if (indexPath.row == 3) {
        ZYCommunityFairIssueVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairIssueVideoCellID forIndexPath:indexPath];
        self.videoView = cell.videoView;
        self.videoDeleteButton = cell.deleteButton;
        cell.delegate = self;
        
        return cell;
    }else {
        ZYCommunityFairIssuePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairIssuePhotoCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.imagesArray = self.imagesArray;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kZYCommunityFairIssueInputCellHeight;
    }else if (indexPath.row == 1) {
        
        return kZYCommunityFairIssueMarkCellHeight + self.textTagCollectionViewHeight;
    }else if (indexPath.row == 2) {
        
        return kZYCommunityFairIssueTextCellHeight;
    }else if (indexPath.row == 3) {
        
        return kZYCommunityFairIssueVideoCellHeight;
    }else {
        if (self.imagesArray.count < 9) {
            CGFloat height = (self.imagesArray.count / 3 + 1) * (kZYCommunityFairIssuePhotoCollectionViewCell_H + 10) + kZYCommunityFairIssuePhotoCellHeight;
            
            return height;
        }else {
            
            return 3 * (kZYCommunityFairIssuePhotoCollectionViewCell_H + 10) + kZYCommunityFairIssuePhotoCellHeight;
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.issueModel.goodsExplain = textView.text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.tag == 200) {
        self.issueModel.goodsName = textField.text;
    }else if (textField.tag == 300) {
        self.issueModel.price = textField.text;
    }
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    ZYCommunityFairIssueMarkCell *cell = (ZYCommunityFairIssueMarkCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.textTagCollectionView updateTagAtIndex:self.selectedMarkIndex selected:NO];
    [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
    self.selectedMarkIndex = index;
    ZYCommunityFairMarkDataModel *model = self.marksArray[self.selectedMarkIndex];
    self.issueModel.labelId = model.ID;
    self.issueModel.labelName = model.labelName;
    [self.tableView reloadData];
}

#pragma mark - ZYCommunityFairIssueInputCellDelegate
// 选择类别
- (void)categoryViewEvent {
    NSLog(@"选择类别");
    if (self.categoryArray.count > 0) {
        [self handleCategoryData];
    }else {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initCategoryData];
    }
}

// 面议
- (void)discussButtonEvent {
    NSLog(@"面议");
    if (self.issueModel.negotiable) {
        self.issueModel.negotiable = 0;
    }else {
        self.issueModel.negotiable = 1;
    }
    self.issueModel.price = @"";
    [self.tableView reloadData];
}

#pragma mark - ZYCommunityFairIssueVideoCellDelegate
// 视频上传
- (void)videoViewEvent {
    NSLog(@"视频上传");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    // 是否显示可选原图按钮
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePickerVc.allowPickingVideo = YES;
    // 是否允许显示图片
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 播放视频
- (void)playButtonEvent {
    NSLog(@"播放视频");
}

- (void)videoDeleteButtonEvent {
    NSLog(@"删除视频");
    if (self.player) {
        self.videoDeleteButton.hidden = YES;
        [self.player stop];
    }
}

#pragma mark - TZImagePickerControllerDelegate
// 选择视频的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    NSLog(@"选中视频...");
    NSLog(@"--------- 视频编码 ----------- 开始 ----------");
    WEAKSELF
    [MovEncodeToMpegTool convertMovToMp4FromPHAsset:asset
                      andAVAssetExportPresetQuality:ExportPresetMediumQuality
                  andMovEncodeToMpegToolResultBlock:^(NSURL *mp4FileUrl, NSData *mp4Data, NSError *error) {
        NSLog(@"--------- 视频编码 ----------- 结束 ----------\n{\n  %@,\n   %ld,\n  %@\n}",mp4FileUrl,mp4Data.length,error.localizedDescription);
        

        
        /**
         //        NSURL *url = [NSURL URLWithString:@"http://192.168.12.49:8090/zhsj/base/api/file/downLoad?fn=25c6be96-354a-4275-9e11-bb4f75b70de5.mp4"];
                 NSURL *url = [NSURL URLWithString:@"https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217104524H4D6lmByOe.mp4"];
                 [self handleVideo:url];
         //        weakSelf.videoPath = mp4FileUrl;
         //        dispatch_async(dispatch_get_main_queue(), ^{
         //            [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
         //            [weakSelf initVideoUploadData];
         //        });
         
         */
        
        
        
        
        if (isNil(error)) {//成功
//            NSURL *url = [NSURL URLWithString:@"https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217104524H4D6lmByOe.mp4"];
//            //@"file:///var/mobile/Containers/Data/Application/2C24588F-B694-42EF-B27F-7C848F313F8A/Documents/Cache/VideoData/20220622163428.mp4"
            [weakSelf sendMp4DataWithFileUrl:mp4FileUrl];

        }else{
            Y_SVP_SHOW_ERR_MES(@"视频编码失败。")
        }
    }];
    
    
    /**
     
     po mp4FileUrl
     file:///var/mobile/Containers/Data/Application/2C24588F-B694-42EF-B27F-7C848F313F8A/Documents/Cache/VideoData/20220622163428.mp4

     po mp4Data.length
     2625288
     
     */
    
  
}
- (void)sendMp4DataWithFileUrl:(NSURL *)url{
    WEAKSELF
    [ChatManagerData sendMp4WithFileUrl:url withGetDicBlick:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            DLog(@"上传视频 成功 == %@",dic);
            NSURL *url = [NSURL URLWithString:@"https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217104524H4D6lmByOe.mp4"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleVideo:url];
            });
        
        }else{
            Y_SVP_SHOW_ERR_MES(@"视频上传失败。");
        }
        
    }];
}

// 视频压缩
- (void)compressVideo:(NSURL *)filePath {
    NSString *filePathStr = [filePath absoluteString];
    NSData *startData = [NSData dataWithContentsOfURL:filePath];
    NSLog(@"压缩前:%.2lfM", (CGFloat)startData.length / (1024 * 1024));
    [self.videoBox clean];
    [self.videoBox appendVideoByPath:filePathStr];
    self.videoBox.ratio = WAVideoExportRatio1280x720;
    self.videoBox.videoQuality = 1;
    [self.videoBox asyncFinishEditByFilePath:filePathStr complete:^(NSError *error) {
        NSData *endData = [NSData dataWithContentsOfURL:filePath];
        NSLog(@"压缩后:%.2lfM", (CGFloat)endData.length / (1024 * 1024));
    }];
    [self.videoBox asyncFinishEditByFilePath:filePathStr complete:^(NSError *error) {
        
    }];
    [self.videoBox asyncFinishEditByFilePath:filePathStr progress:^(float progress) {
        
    } complete:^(NSError *error) {
        
    }];
}

// 处理视频
- (void)handleVideo:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoDeleteButton.hidden = NO;
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        playerManager.shouldAutoPlay = NO;
        self.player.shouldAutoPlay = NO;
        // 1.0是完全消失的时候
        self.player.playerDisapperaPercent = 1.0;
        // 播放器相关
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.videoView];
        self.player.controlView = self.controlView;
        // 设置退到后台继续播放
        self.player.pauseWhenAppResignActive = NO;
        self.player.assetURL = url;
        [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
    });
}

// 提交发布数据
- (void)uploadIssueData {
    NSDictionary *params = [self.issueModel yy_modelToJSONObject];
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kCommunityFairIssueUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYCommunityFairIssueSuccessVc *vc = [[ZYCommunityFairIssueSuccessVc alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - ZYCommunityFairEditPhotoCellDelegate
- (void)addPhotos {
    NSLog(@"添加照片");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - self.imagesArray.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            NSMutableArray *tempIconImageArray = [NSMutableArray arrayWithArray:[weakSelf.imagesArray copy]];
            NSMutableArray *tempPhotosArray = [NSMutableArray array];
            [tempIconImageArray addObjectsFromArray:photos];
            if (tempIconImageArray.count > 9) {
                for (NSInteger i = weakSelf.imagesArray.count; i < 9; i++) {
                    UIImage *image = tempIconImageArray[i];
                    [tempPhotosArray addObject:image];
                }
            }else {
                [tempPhotosArray addObjectsFromArray:photos];
            }
            weakSelf.uploadImagesArray = [tempPhotosArray copy];

            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"上传中..."];
            [weakSelf initImagesUploadsData];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

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
    [self.imagesArray removeObjectAtIndex:index];
    self.issueModel.imagesUrl = [self.imagesArray componentsJoinedByString:@","];
    [self.tableView reloadData];
}

#pragma mark - ZYCommunityFairIssueTopViewDelegate
// 返回
- (void)backButtonEvent {
    [self.view endEditing:YES];
    if (self.type == ZYCommunityFairIssue_Type_Add) {
        [self showSaveAlert];
    }else {
        [self popVC];
    }
}

// 预览
- (void)previewButtonEvent {
    NSLog(@"预览");
    NSDictionary *thisInfoDic = [self.issueModel yy_modelToJSONObject];
    LdleGoodDetailVC *vc = [[LdleGoodDetailVC alloc]init];
    vc.yuLanInfoModel =  [LdleGoodsModel mj_objectWithKeyValues:thisInfoDic];
    [self pushVc:vc];
    

}

- (void)showSaveAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"退出是否保存当前信息?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存草稿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"保存草稿");
        // 保存商品信息
//        [[ShareUserInfo sharedUserInfo] saveDefaultsCommunityFairMarketInfo:self.marketModel];
        [self popVC];
    }];
    UIAlertAction *noSaveAction = [UIAlertAction actionWithTitle:@"直接退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"直接退出");
//        // 保存商品信息
//        [[ShareUserInfo sharedUserInfo] saveDefaultsCommunityFairMarketInfo:[[ZYCommunityFairMarketModel alloc] init]];
        [self popVC];
    }];
    [alertVC addAction:noSaveAction];
    [alertVC addAction:saveAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - ZYCommunityFairIssueBottomViewDelegate
// 发布商品
- (void)issueButtonEvent {
    NSLog(@"发布商品");
    if ([self judgeNoEmptyData]) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"发布中..."];
        [self uploadIssueData];
    }
}

// 数据不为空判断
- (BOOL)judgeNoEmptyData {
    if (self.issueModel.categoryId.length > 0) {
        if (self.issueModel.goodsName.length > 0) {
            if ((self.issueModel.price.length > 0 && !self.issueModel.negotiable) || self.issueModel.negotiable) {
                if (self.issueModel.labelId.length > 0) {
                    if (self.issueModel.goodsExplain.length > 0) {
                        if (self.issueModel.goodsExplain.length >= 20) {
                            if (self.issueModel.imagesUrl.length > 0) {
                                
                                return YES;
                            }else {
                                [ZYProgressHUDTool showCustomHUDTextMessage:@"请上传物品图片" toView:self.view];
                            }
                        }else {
                            [ZYProgressHUDTool showCustomHUDTextMessage:@"请填写闲置物品描述至少20字" toView:self.view];
                        }
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请填写闲置物品描述" toView:self.view];
                    }
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择闲置物品标签" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入物品价格或者选择面议" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入物品名称" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择闲置物品类别" toView:self.view];
    }
    
    return NO;
}

@end
