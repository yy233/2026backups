//
//  ZYFamilyArchiveInfoVC.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveInfoVC.h"
#import "ZYFamilyArchiveInfoBottomView.h"
#import "ZYFamilyArchiveInfoCell.h"
#import "ZYFamilyArchiveModel.h"
#import "ZYFamilyTypeSourceModel.h"

static NSString * const familyArchiveInfoCellID = @"ZYFamilyArchiveInfoCell";
#define kFamilyArchiveInfoBottomViewHeight button_bottom_height+150
#define kFamilyArchiveInfoCellImageHeight 66
#define kFamilyArchiveInfoCellHeight 50

@interface ZYFamilyArchiveInfoVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYFamilyArchiveInfoBottomViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) ZYFamilyArchiveInfoBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *relationArray;

@property (nonatomic, strong) UIImage *selectImage;

@end

@implementation ZYFamilyArchiveInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家人信息";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kFamilyArchiveInfoBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYFamilyArchiveInfoBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYFamilyArchiveInfoBottomView" owner:nil options:nil].lastObject;
        if (self.familyArchiveModel.oneself) {
            _bottomView.deleteButton.hidden = YES;
        }
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)relationArray {
    if (!_relationArray) {
        _relationArray = [NSMutableArray array];
    }
    
    return _relationArray;
}

#pragma mark - 加载数据
- (void)initData {
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    NSArray *typeArray = @[@"image", @"TF", @"select", @"select", @"TF", @"select"];
    NSArray *titleArray = @[@"头像", @"姓名", @"性别", @"出生日期", @"联系电话", @"与我关系"];
    NSArray *contentArray = @[@"", @"", @"", @"", @"", @""];
    for (int i = 0; i < typeArray.count; i++) {
        ZYFamilyArchiveInfoModel *model = [[ZYFamilyArchiveInfoModel alloc] init];
        model.type = typeArray[i];
        model.title = titleArray[i];
        model.content = contentArray[i];
        [self.dataArray addObject:model];
    }
    [self handleFamilyDetailData];
}

// 处理家庭档案数据
- (void)handleFamilyDetailData {
    for (int i = 0; i < self.dataArray.count; i++) {
        ZYFamilyArchiveInfoModel *infoModel = self.dataArray[i];
        if (i == 0) {
            infoModel.content = self.familyArchiveModel.avatarUrl;
        }else if (i == 1) {
            infoModel.content = self.familyArchiveModel.name;
        }else if (i == 2) {
            if (self.familyArchiveModel.sex == 1) {
                infoModel.content = @"男";
            }else if (self.familyArchiveModel.sex == 2) {
                infoModel.content = @"女";
            }else {
                if (self.familyArchiveModel.oneself) {
                    infoModel.content = @"";
                }else {
                    self.familyArchiveModel.sex = 3;
                    infoModel.content = @"--";
                }
            }
        }else if (i == 3) {
            if (self.familyArchiveModel.birthday.length > 0) {
                infoModel.content = self.familyArchiveModel.birthday;
            }else {
                if (self.familyArchiveModel.oneself) {
                    infoModel.content = self.familyArchiveModel.birthday;
                }else {
                    infoModel.content = @"--";
                }
            }
        }else if (i == 4) {
            infoModel.content = self.familyArchiveModel.mobile;
        }else if (i == 5) {
            infoModel.content = self.familyArchiveModel.relationText;
        }
    }
    [self.tableView reloadData];
}

// 加载关系公共常量数据
- (void)initFamilyTypeSourceData {
    NSDictionary *params = @{@"typeName" : @"familyRelationText"};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyTypeSourceUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.relationArray.count > 0) {
                        [self.relationArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYFamilyTypeSourceModel class] json:responsObject[@"data"]];
                    [self.relationArray addObjectsFromArray:array];
                    [self handleFamilyTypeSourceData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 处理关系公共常量数据
- (void)handleFamilyTypeSourceData {
    NSMutableArray *dataSourceArr = [NSMutableArray array];
    for (ZYFamilyTypeSourceModel *model in self.relationArray) {
        [dataSourceArr addObject:model.name];
    }
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:[dataSourceArr copy] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        ZYFamilyTypeSourceModel *typeModel = weakSelf.relationArray[resultModel.index];
        weakSelf.familyArchiveModel.relation = typeModel.code;
        weakSelf.familyArchiveModel.relationText = typeModel.name;
        [weakSelf handleFamilyDetailData];
    }];
}

// 上传头像
- (void)uploadFamilyHead {
    NSMutableArray *imageArray = [NSMutableArray arrayWithObject:self.selectImage];
    [[ToolOfNetWork sharedTools] YrequestImgFileArrWithALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kUploadFamilyHeadUrl] withParams:@{}.mutableCopy fileDataArr:imageArray fileNameStr:@"" finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *urlStr = responsObject[@"data"];
                self.familyArchiveModel.avatarUrl = urlStr;
                [self handleFamilyDetailData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 保存修改
- (void)initSaveFamilyData {
    NSDictionary *params;
    if (self.familyArchiveModel.name.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入昵称！");
        return;
    }
    if (self.familyArchiveModel.name.length>16) {
        Y_SVP_SHOW_ERR_MES(@"昵称长度超过限制。");
        return;
    }
    if (self.familyArchiveModel.oneself) {
        params = @{@"id" : self.familyArchiveModel.ID, @"name" : self.familyArchiveModel.name, @"sex" : @(self.familyArchiveModel.sex), @"birthday" : self.familyArchiveModel.birthday, @"mobile" : self.familyArchiveModel.mobile, @"avatarUrl" : self.familyArchiveModel.avatarUrl};
    }else {
        params = @{@"id" : self.familyArchiveModel.ID, @"relation" : @(self.familyArchiveModel.relation), @"name" : self.familyArchiveModel.name, @"sex" : @(self.familyArchiveModel.sex), @"birthday" : self.familyArchiveModel.birthday, @"mobile" : self.familyArchiveModel.mobile, @"avatarUrl" : self.familyArchiveModel.avatarUrl};
    }
    [[ToolOfNetWork sharedTools] YrequestPUTALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kUpdateFamilyUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ShareUserInfo sharedUserInfo].userInfo.avatarUrl = self.familyArchiveModel.avatarUrl;
                [ShareUserInfo sharedUserInfo].userInfo.nickname = self.familyArchiveModel.name;
                [ShareUserInfo sharedUserInfo].userInfo.mobile = self.familyArchiveModel.mobile;
                [ZYProgressHUDTool showCustomHUDTextMessage:@"保存成功" toView:self.view.window];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_FAMILY_BACK")
                [self popVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除家人
- (void)initDeleteFamilyData {
    NSDictionary *params = @{@"id" : self.familyArchiveModel.ID};
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kDeleteFamilyUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"移除成功" toView:self.view.window];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_FAMILY_BACK")
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor = [UIColor zy_colorWithHexString:@"#EEEEEE"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:familyArchiveInfoCellID bundle:nil] forCellReuseIdentifier:familyArchiveInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYFamilyArchiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:familyArchiveInfoCellID forIndexPath:indexPath];
    ZYFamilyArchiveInfoModel *model = self.dataArray[indexPath.row];
    cell.contentTF.tag = 200 + indexPath.row;
    cell.contentTF.delegate = self;
    cell.model = model;
    if (self.familyArchiveModel.oneself) {
        if (indexPath.row == 5) {
            cell.arrowImageView.hidden = YES;
        }
        if (indexPath.row == 4) {
            cell.contentTF.userInteractionEnabled = NO;
        }
    }else {
        if (indexPath.row == 5) {
            cell.arrowImageView.hidden = NO;
        }else {
            cell.arrowImageView.hidden = YES;
        }
        cell.contentTF.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kFamilyArchiveInfoCellImageHeight;
    }
    
    return kFamilyArchiveInfoCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        if (self.familyArchiveModel.oneself) {
            [self enterPhotoAlbum];
        }
    }else if (indexPath.row == 2) {
        if (self.familyArchiveModel.oneself) {
            [BRStringPickerView showPickerWithTitle:@"" dataSourceArr:@[@"男", @"女"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
                if (resultModel.index == 0) {
                    weakSelf.familyArchiveModel.sex = 1;
                }else {
                    weakSelf.familyArchiveModel.sex = 2;
                }
                [weakSelf handleFamilyDetailData];
            }];
        }
    }else if (indexPath.row == 3) {
        if (self.familyArchiveModel.oneself) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
            NSDate *minDate = [dateFormatter dateFromString:@"1800-01-01"];
            [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:@"" selectValue:dateStr minDate:minDate maxDate:[NSDate date] isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
                weakSelf.familyArchiveModel.birthday = selectValue;
                [weakSelf handleFamilyDetailData];
            }];
        }
    }else if (indexPath.row == 5) {
        if (!self.familyArchiveModel.oneself) {
            if (self.relationArray.count > 0) {
                [self handleFamilyTypeSourceData];
            }else {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [self initFamilyTypeSourceData];
            }
        }
    }
}

// 进入相册
- (void)enterPhotoAlbum {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            weakSelf.selectImage = photos.firstObject;
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"上传中..."];
            [weakSelf uploadFamilyHead];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    ZYFamilyArchiveInfoModel *infoModel = self.dataArray[textField.tag - 200];
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (textField.tag == 201) {
        self.familyArchiveModel.name = text;
        infoModel.content = text;
    }
}

#pragma mark - ZYFamilyArchiveInfoBottomViewDelegate
// 保存
- (void)saveButtonEvent {
    
    NSLog(@"保存");
    if (self.familyArchiveModel.name) {
        if (self.familyArchiveModel.sex > 0) {
            if (self.familyArchiveModel.birthday.length > 0) {
                if (self.familyArchiveModel.mobile.length > 0) {
                    if (self.familyArchiveModel.oneself) {
                        [SVProgressHUD showLoadingCustomHUDWithStatus:@"保存中..."];
                        [self initSaveFamilyData];
                    }else {
                        if (self.familyArchiveModel.relation > 0) {
                            [SVProgressHUD showLoadingCustomHUDWithStatus:@"保存中..."];
                            [self initSaveFamilyData];
                        }else {
                            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择与我关系!" toView:self.view];
                        }
                    }
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入联系电话!" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择出生日期!" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择性别!" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入姓名!" toView:self.view];
    }
}

// 移除家人
- (void)deleteButtonEvent {
    
    NSLog(@"移除家人");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定移除家人？" message:@"移除家人后对方的家人档案也会同时移除您的家人信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"移除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"移除中..."];
        [self initDeleteFamilyData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
