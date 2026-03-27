//
//  ZYOwnersVoteDetailVC.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYOwnersVoteDetailVC.h"
#import "ZYOwnersVoteCompleteVC.h"
#import "ZYOwnersVotePlanVC.h"
#import "ZYOwnersVoteDetailImageCell.h"
#import "ZYOwnersVoteDetailIllustrateCell.h"
#import "ZYOwnersVoteDetailTitleCell.h"
#import "ZYOwnersVoteDetailContentCell.h"
#import "ZYOwnersVoteDetailBottomView.h"

static NSString * const ownersVoteDetailImageCellID = @"ZYOwnersVoteDetailImageCell";
static NSString * const ownersVoteDetailIllustrateCellID = @"ZYOwnersVoteDetailIllustrateCell";
static NSString * const ownersVoteDetailTitleCellID = @"ZYOwnersVoteDetailTitleCell";
static NSString * const ownersVoteDetailContentCellID = @"ZYOwnersVoteDetailContentCell";

#define kOwnersVoteDetailImageCellHeight 200/375.0*kScreenW
#define kOwnersVoteDetailInputCellHeight 70

@interface ZYOwnersVoteDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYOwnersVoteDetailImageCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYOwnersVoteDetailBottomView *bottomView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) ZYOwnersVoteDetailDataModel *dataModel;

@property (nonatomic, strong) NSMutableArray *optionsArray;

@end

@implementation ZYOwnersVoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"业主投票";
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initOwnersVoteDetailData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"OWNERS_VOTE_SUBMIT_BACK", ownersVoteSumbitBack)
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

// 通知回调
- (void)ownersVoteSumbitBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataModel.status = 1;
        [self.bottomView.submitButton setTitle:@"查看进度" forState:UIControlStateNormal];
        [self.tableView reloadData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"OWNERS_VOTE_SUBMIT_BACK")
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

- (ZYOwnersVoteDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYOwnersVoteDetailBottomView" owner:nil options:nil].lastObject;
        [_bottomView.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomView;
}

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) {
        _optionsArray = [NSMutableArray array];
    }
    
    return _optionsArray;
}

#pragma mark - 加载数据
// 加载活动详情数据
- (void)initOwnersVoteDetailData {
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kOwnersVoteDetailUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYOwnersVoteDetailModel *model = [ZYOwnersVoteDetailModel yy_modelWithJSON:responsObject];
                self.dataModel = model.data;
                if (self.optionsArray.count > 0) {
                    [self.optionsArray removeAllObjects];
                }
                [self.optionsArray addObjectsFromArray:self.dataModel.voteTopicEntity.options];
                [self setUI];
                [self customTableView];
                if (self.dataModel.status == 0) {
                    [self.bottomView.submitButton setTitle:@"提交" forState:UIControlStateNormal];
                }else {
                    [self.bottomView.submitButton setTitle:@"查看进度" forState:UIControlStateNormal];
                }
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载业主投票提交数据
- (void)initOwnersVoteSubmitData {
    
    NSMutableArray *optionIdArray = [NSMutableArray array];
    for (ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *tempModel in self.optionsArray) {
        if (tempModel.status == 1) {
            [optionIdArray addObject:tempModel.ID];
        }
    }
    NSDictionary *params = @{@"id" : self.ID, @"choose" : @(self.dataModel.choose), @"topicId" : self.dataModel.voteTopicEntity.ID, @"options" : optionIdArray};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kOwnersVoteUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYOwnersVoteCompleteVC *vc = [[ZYOwnersVoteCompleteVC alloc] init];
                [self pushVc:vc];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"OWNERS_VOTE_SUBMIT_BACK")
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYOwnersVoteDetailImageCell" bundle:nil] forCellReuseIdentifier:ownersVoteDetailImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYOwnersVoteDetailIllustrateCell" bundle:nil] forCellReuseIdentifier:ownersVoteDetailIllustrateCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYOwnersVoteDetailTitleCell" bundle:nil] forCellReuseIdentifier:ownersVoteDetailTitleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYOwnersVoteDetailContentCell" bundle:nil] forCellReuseIdentifier:ownersVoteDetailContentCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
    }else {
        
        return self.optionsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZYOwnersVoteDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ownersVoteDetailImageCellID forIndexPath:indexPath];
            cell.delegate = self;
            cell.model = self.dataModel;
            
            return cell;
        }else if (indexPath.row == 1) {
            ZYOwnersVoteDetailIllustrateCell *cell = [tableView dequeueReusableCellWithIdentifier:ownersVoteDetailIllustrateCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }else {
            ZYOwnersVoteDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ownersVoteDetailTitleCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }
    }else {
        ZYOwnersVoteDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ownersVoteDetailContentCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];

        return cell;
    }
}

// 配置cell数据
- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            ZYOwnersVoteDetailIllustrateCell *cell = (ZYOwnersVoteDetailIllustrateCell *)currentCell;
            cell.model = self.dataModel;
        }else if (indexPath.row == 2) {
            ZYOwnersVoteDetailTitleCell *cell = (ZYOwnersVoteDetailTitleCell *)currentCell;
            cell.model = self.dataModel.voteTopicEntity;
        }
    }else if (indexPath.section == 1) {
        ZYOwnersVoteDetailContentCell *cell = (ZYOwnersVoteDetailContentCell *)currentCell;
        ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *model = self.optionsArray[indexPath.row];
        cell.model = model;
        if (self.dataModel.status == 0) {
            cell.radioButton.userInteractionEnabled = YES;
        }else {
            cell.radioButton.userInteractionEnabled = NO;
        }
        cell.radioButton.tag = 200 + indexPath.row;
        [cell.radioButton addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            return kOwnersVoteDetailImageCellHeight;
        }else if (indexPath.row == 1) {
            
            return [tableView fd_heightForCellWithIdentifier:ownersVoteDetailIllustrateCellID cacheByIndexPath:indexPath configuration:^(ZYOwnersVoteDetailIllustrateCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else {
            
            return  [tableView fd_heightForCellWithIdentifier:ownersVoteDetailTitleCellID cacheByIndexPath:indexPath configuration:^(ZYOwnersVoteDetailTitleCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }
    }else {
        
        return  [tableView fd_heightForCellWithIdentifier:ownersVoteDetailContentCellID cacheByIndexPath:indexPath configuration:^(ZYOwnersVoteDetailContentCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 25;
    }
    
    return 0;
}

#pragma mark - ZYOwnersVoteDetailImageCellDelegate
- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"点击图片 %ld", index);
    NSMutableArray *imagesArray = [NSMutableArray array];
    NSArray *array = [self.dataModel.picture componentsSeparatedByString:@","];
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
// 提交
- (void)submitButtonClicked {
    
    if (self.dataModel.status == 0) {
        NSLog(@"提交");
        BOOL isSelected = NO;
        for (ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *tempModel in self.optionsArray) {
            if (tempModel.status == 1) {
                isSelected = YES;
            }
        }
        if (isSelected) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
            [self initOwnersVoteSubmitData];
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择选项" toView:self.view];
        }
    }else {
        NSLog(@"查看进度");
        ZYOwnersVotePlanVC *vc = [[ZYOwnersVotePlanVC alloc] init];
        vc.ID = self.dataModel.ID;
        [self pushVc:vc];
    }
}

// 选择
- (void)radioButtonClicked:(UIButton *)sender {
    
    NSLog(@"index = %ld", sender.tag - 200);
    NSInteger index = sender.tag - 200;
    if (self.dataModel.choose == 1) {
        for (int i = 0; i < self.optionsArray.count; i++) {
            ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *model = self.optionsArray[i];
            if (i == index) {
                model.status = 1;
            }else {
                model.status = 0;
            }
        }
    }else {
        ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *model = self.optionsArray[index];
        if (model.status == 0) {
            model.status = 1;
        }else {
            model.status = 0;
        }
    }
    [self.tableView reloadData];
}

@end

