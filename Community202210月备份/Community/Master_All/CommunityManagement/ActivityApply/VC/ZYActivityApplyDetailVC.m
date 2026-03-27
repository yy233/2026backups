//
//  ZYActivityApplyDetailVC.m
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import "ZYActivityApplyDetailVC.h"
#import "ZYActivityApplyDetailImageCell.h"
#import "ZYActivityApplyDetailContentCell.h"
#import "ZYActivityApplyDetailInstructionsCell.h"
#import "ZYActivityApplyDetatilInfoCell.h"
#import "ZYActivityApplyDetatilBottomView.h"

static NSString * const activityApplyDetailImageCellID = @"ZYActivityApplyDetailImageCell";
static NSString * const activityApplyDetailContentCellID = @"ZYActivityApplyDetailContentCell";
static NSString * const activityApplyDetailInstructionsCellID = @"ZYActivityApplyDetailInstructionsCell";
static NSString * const activityApplyDetatilInfoCellID = @"ZYActivityApplyDetatilInfoCell";

#define kActivityApplyDetailImageCellHeight 200/375.0*kScreenW
#define kActivityApplyDetailInstructionsCelllHeight 130
#define kActivityApplyDetatilInfoCelllHeight 206

@interface ZYActivityApplyDetailVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYActivityApplyDetailImageCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYActivityApplyDetatilBottomView *bottomView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) ZYActivityApplyDetailDataModel *detailModel;

@end

@implementation ZYActivityApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initActivityApplyDetailData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(50 + button_bottom_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
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

- (ZYActivityApplyDetatilBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYActivityApplyDetatilBottomView" owner:nil options:nil].lastObject;
        _bottomView.applyView.hidden = YES;
        _bottomView.appliedView.hidden = YES;
        [_bottomView.applyButton addTarget:self action:@selector(applyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomView;
}

#pragma mark - 加载数据
// 活动报名详情数据
- (void)initActivityApplyDetailData {
    
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kActivityApplyDetailURL] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYActivityApplyDetailModel *model = [ZYActivityApplyDetailModel yy_modelWithJSON:responsObject];
                self.detailModel = model.data;
                if (self.detailModel.status == 0) {
                    self.bottomView.applyView.hidden = NO;
                    self.bottomView.appliedView.hidden = YES;
                }else {
                    self.bottomView.applyView.hidden = YES;
                    self.bottomView.appliedView.hidden = NO;
                }
                [self setUI];
                [self customTableView];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 活动报名数据
- (void)initNewActivityApplyData {
    
    NSDictionary *params = @{@"activityId" : self.ID, @"name" : self.detailModel.name, @"mobile" : self.detailModel.mobile};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kNewActivityApplyURL] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.bottomView.applyView.hidden = YES;
                self.bottomView.appliedView.hidden = NO;
                self.detailModel.status = 1;
                [self.tableView reloadData];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"报名成功" toView:self.view];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 取消活动报名数据
- (void)initCancelActivityApplyData {
    
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kCancelActivityApplyURL] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.bottomView.applyView.hidden = NO;
                self.bottomView.appliedView.hidden = YES;
                self.detailModel.status = 0;
                [self.tableView reloadData];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"取消成功" toView:self.view];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYActivityApplyDetailImageCell" bundle:nil] forCellReuseIdentifier:activityApplyDetailImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYActivityApplyDetailContentCell" bundle:nil] forCellReuseIdentifier:activityApplyDetailContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYActivityApplyDetailInstructionsCell" bundle:nil] forCellReuseIdentifier:activityApplyDetailInstructionsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYActivityApplyDetatilInfoCell" bundle:nil] forCellReuseIdentifier:activityApplyDetatilInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ZYActivityApplyDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:activityApplyDetailImageCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.detailModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYActivityApplyDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:activityApplyDetailContentCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYActivityApplyDetailInstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:activityApplyDetailInstructionsCellID forIndexPath:indexPath];
        cell.model = self.detailModel;
        
        return cell;
    }else {
        ZYActivityApplyDetatilInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:activityApplyDetatilInfoCellID forIndexPath:indexPath];
        cell.nameTF.tag = 200;
        cell.nameTF.delegate = self;
        cell.telTF.tag = 300;
        cell.telTF.delegate = self;
        cell.model = self.detailModel;
        
        return cell;
    }
}

// 配置cell数据
- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        ZYActivityApplyDetailContentCell *cell = (ZYActivityApplyDetailContentCell *)currentCell;
        cell.model = self.detailModel;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return kActivityApplyDetailImageCellHeight;
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:activityApplyDetailContentCellID cacheByIndexPath:indexPath configuration:^(ZYActivityApplyDetailContentCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 2) {
        
        return kActivityApplyDetailInstructionsCelllHeight;
    }else {
        
        return kActivityApplyDetatilInfoCelllHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 25;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.tag == 200) {
        self.detailModel.name = textField.text;
    }else if (textField.tag == 300) {
        self.detailModel.mobile = textField.text;
    }
}

#pragma mark - ZYActivityApplyDetailImageCellDelegate
- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"点击图片 %ld", index);
    NSMutableArray *imagesArray = [NSMutableArray array];
    NSArray *array = [self.detailModel.picture componentsSeparatedByString:@","];
    for (NSString *str in array) {
        if (str.length > 0) {
            [imagesArray addObject:str];
        }
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:imagesArray[i]];
        photoModel.originUrl = [NSURL URLWithString:imagesArray[i]];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

#pragma mark - 点击事件
// 报名
- (void)applyButtonClicked {
    
    NSLog(@"报名");
    if (self.detailModel.name.length > 0) {
        if (self.detailModel.mobile.length > 0) {
            if ([ZYTextValidationTool validatePhone:self.detailModel.mobile]) {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"报名中..."];
                [self initNewActivityApplyData];
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入姓名" toView:self.view];
    }
}

// 取消报名
- (void)cancelButtonClicked {
    
    NSLog(@"取消报名");
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"取消中..."];
    [self initCancelActivityApplyData];
}

@end
