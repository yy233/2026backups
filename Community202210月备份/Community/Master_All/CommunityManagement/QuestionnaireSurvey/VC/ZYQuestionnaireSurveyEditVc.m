//
//  ZYQuestionnaireSurveyEditVc.m
//  Community
//
//  Created by ZY on 2022/6/7.
//

#import "ZYQuestionnaireSurveyEditVc.h"
#import "ZYQuestionnaireSurveyResultVc.h"
#import "ZYQuestionnaireSurveyStatisticalVc.h"
#import "ZYQuestionnaireSurveyEditHeaderView.h"
#import "ZYQuestionnaireSurveyEditFooterView.h"
#import "ZYQuestionnaireSurveyBottomView.h"
#import "ZYQuestionnaireSurveyEditTitleCell.h"
#import "ZYQuestionnaireSurveyEditTextCell.h"
#import "ZYQuestionnaireSurveyEditOptionCell.h"
#import "ZYQuestionnaireSurveyEditOtherCell.h"
#import "ZYQuestionnaireSurveyUploadModel.h"

static NSString * const ZYQuestionnaireSurveyEditTitleCellID = @"ZYQuestionnaireSurveyEditTitleCell";
static NSString * const ZYQuestionnaireSurveyEditTextCellID = @"ZYQuestionnaireSurveyEditTextCell";
static NSString * const ZYQuestionnaireSurveyEditOptionCellID = @"ZYQuestionnaireSurveyEditOptionCell";
static NSString * const ZYQuestionnaireSurveyEditOtherCellID = @"ZYQuestionnaireSurveyEditOtherCell";
#define kZYQuestionnaireSurveyEditFooterViewHeight 30
#define kZYQuestionnaireSurveyBottomViewHeight 75+button_bottom_height
#define kZYQuestionnaireSurveyEditOtherCellHeight 45
#define kZYQuestionnaireSurveyEditOtherCellSelectedHeight 105

@interface ZYQuestionnaireSurveyEditVc () <UITableViewDataSource, UITableViewDelegate, ZYQuestionnaireSurveyBottomViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYQuestionnaireSurveyBottomView *bottomView;

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailModel *detailModel;

// 当前选中section
@property (nonatomic, assign) NSInteger selectedSection;

@property (nonatomic, strong) ZYQuestionnaireSurveyUploadModel *uploadModel;

@end

@implementation ZYQuestionnaireSurveyEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问卷调查";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        if (!self.model.status || (self.model.status && self.model.isOpenStatistics)) {
            make.height.offset(kZYQuestionnaireSurveyBottomViewHeight);
        }else {
            make.height.offset(0);
        }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.hidden = YES;
    }
    
    return _tableView;
}

- (ZYQuestionnaireSurveyBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyBottomView" owner:nil options:nil].lastObject;
        if (!self.model.status && self.model.voteStatus == 2) {
            [_bottomView.okButton setTitle:@"提交" forState:UIControlStateNormal];
        }else if (self.model.status && self.model.isOpenStatistics) {
            [_bottomView.okButton setTitle:@"查看统计" forState:UIControlStateNormal];
        }else if (!self.model.status && self.model.voteStatus == 3) {
            [_bottomView.okButton setTitle:@"查看统计" forState:UIControlStateNormal];
        }else {
            _bottomView.hidden = YES;
        }
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYQuestionnaireSurveyUploadModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[ZYQuestionnaireSurveyUploadModel alloc] init];
    }
    
    return _uploadModel;
}

#pragma mark - 加载数据
- (void)initData {
    self.uploadModel.answerStartTime = [NSDate br_stringFromDate:[NSDate date] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *params = @{@"id" : self.model.ID};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kOwnersVoteDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    ZYQuestionnaireSurveyDetailModel *model = [ZYQuestionnaireSurveyDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    [model.voteTopicEntityList enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.order = idx + 1;
                        [obj.options enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj.isCurrentStatus = self.model.status;
                        }];
                    }];
                    self.detailModel = model;
                    self.tableView.hidden = NO;
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

// 加载业主投票提交数据
- (void)initUploadData {
    NSDictionary *params = [self.uploadModel yy_modelToJSONObject];
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kOwnersVoteUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYQuestionnaireSurveyResultVc *vc = [[ZYQuestionnaireSurveyResultVc alloc] init];
                vc.type = ZYQuestionnaireSurveyResult_Type_Success;
                [self pushVc:vc];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"OWNERS_VOTE_SUBMIT_BACK");
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyEditTitleCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyEditTitleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyEditTextCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyEditTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyEditOptionCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyEditOptionCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyEditOtherCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyEditOtherCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.detailModel.voteTopicEntityList.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *model = self.detailModel.voteTopicEntityList[section - 1];
        if (model.choose == 3) {
            
            return 1;
        }
        
        return model.options.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYQuestionnaireSurveyEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyEditTitleCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        if (self.model.status || self.model.voteStatus == 3) {
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
        if (listModel.choose == 3) {
            ZYQuestionnaireSurveyEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyEditTextCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            if (self.model.status || self.model.voteStatus == 3) {
                cell.userInteractionEnabled = NO;
            }
            
            return cell;
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            if (model.isOtherOption) {
                ZYQuestionnaireSurveyEditOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyEditOtherCellID forIndexPath:indexPath];
                cell.model = model;
                cell.block = ^(NSString * _Nonnull str) {
                    model.otherContent = str;
                };
                if (self.model.status || self.model.voteStatus == 3) {
                    cell.userInteractionEnabled = NO;
                }
                
                return cell;
            }else {
                ZYQuestionnaireSurveyEditOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyEditOptionCellID forIndexPath:indexPath];
                [self configureCell:cell atIndexPath:indexPath];
                if (self.model.status || self.model.voteStatus == 3) {
                    cell.userInteractionEnabled = NO;
                }
                
                return cell;
            }
        }
    }
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYQuestionnaireSurveyEditTitleCell *cell = (ZYQuestionnaireSurveyEditTitleCell *)currentCell;
        cell.model = self.detailModel;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
        if (listModel.choose == 3) {
            ZYQuestionnaireSurveyEditTextCell *cell = (ZYQuestionnaireSurveyEditTextCell *)currentCell;
            cell.textView.tag = 200 + indexPath.section;
            cell.textView.delegate = self;
            cell.model = listModel;
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            ZYQuestionnaireSurveyEditOptionCell *cell = (ZYQuestionnaireSurveyEditOptionCell *)currentCell;
            cell.model = model;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyEditTitleCellID configuration:^(ZYQuestionnaireSurveyEditTitleCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
        if (listModel.choose == 3) {
            
            return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyEditTextCellID configuration:^(ZYQuestionnaireSurveyEditTextCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            if (model.isOtherOption) {
                if (model.status) {
                    
                    return kZYQuestionnaireSurveyEditOtherCellSelectedHeight;
                }else {
                    
                    return kZYQuestionnaireSurveyEditOtherCellHeight;
                }
            }else {
                
                return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyEditOptionCellID configuration:^(ZYQuestionnaireSurveyEditOptionCell *cell) {
                    [self configureCell:cell atIndexPath:indexPath];
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[section - 1];
        if (listModel.choose == 3) {
            
            return 0;
        }else {
            if (listModel.choose == 2) {
                CGSize size = [[NSString stringWithFormat:@"%@（多选）", listModel.content] boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
                
                return size.height + 48;
            }else {
                CGSize size = [listModel.content boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
                
                return size.height + 33;
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return [[UIView alloc] init];
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[section - 1];
        if (listModel.choose == 3) {
            
            return [[UIView alloc] init];
        }else {
            ZYQuestionnaireSurveyEditHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyEditHeaderView" owner:nil options:nil].lastObject;
            headerView.model = listModel;
            
            return headerView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == self.detailModel.voteTopicEntityList.count) {
        
        return 0;
    }else {
        
        return kZYQuestionnaireSurveyEditFooterViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 || section == self.detailModel.voteTopicEntityList.count) {
        
        return [[UIView alloc] init];
    }else {
        ZYQuestionnaireSurveyEditFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyEditFooterView" owner:nil options:nil].lastObject;
        
        return footerView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        self.selectedSection = indexPath.section;
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
        if (listModel.choose != 3) {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            [listModel.options enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isOtherOption && !obj.status) {
                    obj.otherContent = @"";
                }
            }];
            if (listModel.choose == 2) {
                model.status = !model.status;
            }else {
                [listModel.options enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.status = NO;
                }];
                model.status = YES;
            }
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[textView.tag - 200 - 1];
    listModel.answerContent = textView.text;
}

#pragma mark - ZYQuestionnaireSurveyBottomViewDelegate
- (void)okButtonEvent {
    if (!self.model.status && self.model.voteStatus == 2) {
        NSLog(@"提交");
        if ([self judgeNoEmptyData]) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
            [self handleUploadData];
            [self initUploadData];
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请完整作答" toView:self.view];
        }
    }else if (self.model.status && self.model.isOpenStatistics) {
        NSLog(@"查看统计");
        ZYQuestionnaireSurveyStatisticalVc *vc = [[ZYQuestionnaireSurveyStatisticalVc alloc] init];
        vc.ID = self.model.ID;
        [self pushVc:vc];
    }else if (!self.model.status && self.model.voteStatus == 3) {
        NSLog(@"查看统计");
        ZYQuestionnaireSurveyStatisticalVc *vc = [[ZYQuestionnaireSurveyStatisticalVc alloc] init];
        vc.ID = self.model.ID;
        [self pushVc:vc];
    }
}

// 数据不为空判断
- (BOOL)judgeNoEmptyData {
    for (ZYQuestionnaireSurveyDetailEntityListModel *tempListModel in self.detailModel.voteTopicEntityList) {
        if (tempListModel.choose == 3) {
            if (!tempListModel.answerContent.length) {
                
                return NO;
            }
        }else {
            BOOL isSelect = NO;
            for (ZYQuestionnaireSurveyDetailEntityListOptionModel *tempOptionModel in tempListModel.options) {
                if ((tempOptionModel.status && !tempOptionModel.isOtherOption) || (tempOptionModel.status && tempOptionModel.isOtherOption && tempOptionModel.otherContent.length)) {
                    isSelect = YES;
                }
            }
            if (!isSelect) {
                
                return NO;
            }
        }
    }
    
    return YES;
}

// 处理提交数据
- (void)handleUploadData {
    self.uploadModel.ID = self.model.ID;
    self.uploadModel.submitTime = [NSDate br_stringFromDate:[NSDate date] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.uploadModel.answerDuration = [[NSDate br_dateFromString:self.uploadModel.submitTime dateFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970] - [[NSDate br_dateFromString:self.uploadModel.answerStartTime dateFormat:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970] / 60 + 1;
    NSMutableArray *entityListArray = [NSMutableArray array];
    for (ZYQuestionnaireSurveyDetailEntityListModel *tempListModel in self.detailModel.voteTopicEntityList) {
        ZYQuestionnaireSurveyUploadEntityLisModel *uploadEntityLisModel = [[ZYQuestionnaireSurveyUploadEntityLisModel alloc] init];
        if (tempListModel.choose == 3) {
            uploadEntityLisModel.topicId = tempListModel.ID;
            uploadEntityLisModel.answerContent = tempListModel.answerContent;
        }else {
            NSMutableArray *optionArray = [NSMutableArray array];
            for (ZYQuestionnaireSurveyDetailEntityListOptionModel *tempOptionModel in tempListModel.options) {
                uploadEntityLisModel.topicId = tempOptionModel.topicId;
                uploadEntityLisModel.otherContent = tempOptionModel.otherContent;
                if (tempOptionModel.status) {
                    [optionArray addObject:tempOptionModel.ID];
                }
            }
            uploadEntityLisModel.optionList = [optionArray copy];
        }
        [entityListArray addObject:uploadEntityLisModel];
    }
    self.uploadModel.voteUserEntityList = [entityListArray copy];
}

@end
