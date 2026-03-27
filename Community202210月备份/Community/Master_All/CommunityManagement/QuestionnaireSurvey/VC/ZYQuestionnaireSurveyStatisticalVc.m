//
//  ZYQuestionnaireSurveyStatisticalVc.m
//  Community
//
//  Created by ZY on 2022/6/8.
//

#import "ZYQuestionnaireSurveyStatisticalVc.h"
#import "ZYQuestionnaireSurveyStatisticalMoreVc.h"
#import "ZYQuestionnaireSurveyEditHeaderView.h"
#import "ZYQuestionnaireSurveyEditFooterView.h"
#import "ZYQuestionnaireSurveyStatisticalFooterView.h"
#import "ZYQuestionnaireSurveyEditTitleCell.h"
#import "ZYQuestionnaireSurveyStatisticalOptionCell.h"
#import "ZYQuestionnaireSurveyStatisticalOtherCell.h"
#import "ZYQuestionnaireSurveyStatisticalTextCell.h"

static NSString * const ZYQuestionnaireSurveyEditTitleCellID = @"ZYQuestionnaireSurveyEditTitleCell";
static NSString * const ZYQuestionnaireSurveyStatisticalOptionCellID = @"ZYQuestionnaireSurveyStatisticalOptionCell";
static NSString * const ZYQuestionnaireSurveyStatisticalOtherCellID = @"ZYQuestionnaireSurveyStatisticalOtherCell";
static NSString * const ZYQuestionnaireSurveyStatisticalTextCellID = @"ZYQuestionnaireSurveyStatisticalTextCell";
#define kZYQuestionnaireSurveyEditFooterViewHeight 30
#define kZYQuestionnaireSurveyStatisticalFooterViewHeight 50
#define kZYQuestionnaireSurveyStatisticalOtherCellHeight 45

@interface ZYQuestionnaireSurveyStatisticalVc () <UITableViewDataSource, UITableViewDelegate, ZYQuestionnaireSurveyStatisticalOtherCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYQuestionnaireSurveyDetailModel *detailModel;

// 当前选中的cell

@end

@implementation ZYQuestionnaireSurveyStatisticalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票统计";
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
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
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

#pragma mark - 加载数据
- (void)initData {
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kOwnersVotePlanUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    ZYQuestionnaireSurveyDetailModel *model = [ZYQuestionnaireSurveyDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    model.theme = [NSString stringWithFormat:@"%@（目前共%ld人参与）", model.theme, model.total];
                    [model.voteTopicEntityList enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.order = idx + 1;
                        [obj.options enumerateObjectsUsingBlock:^(ZYQuestionnaireSurveyDetailEntityListOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj.total = model.total;
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyEditTitleCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyEditTitleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyStatisticalOptionCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyStatisticalOptionCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyStatisticalOtherCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyStatisticalOtherCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYQuestionnaireSurveyStatisticalTextCellID bundle:nil] forCellReuseIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID];
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
            
            return model.answerContentList.count;
        }
        
        return model.options.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYQuestionnaireSurveyEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyEditTitleCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
        if (listModel.choose == 3) {
            ZYQuestionnaireSurveyStatisticalTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            if (model.isOtherOption) {
                ZYQuestionnaireSurveyStatisticalOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyStatisticalOtherCellID forIndexPath:indexPath];
                cell.delegate = self;
                cell.model = model;
                cell.indexPath = indexPath;
                
                return cell;
            }else {
                ZYQuestionnaireSurveyStatisticalOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYQuestionnaireSurveyStatisticalOptionCellID forIndexPath:indexPath];
                [self configureCell:cell atIndexPath:indexPath];
                
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
            ZYQuestionnaireSurveyStatisticalTextCell *cell = (ZYQuestionnaireSurveyStatisticalTextCell *)currentCell;
            cell.content = listModel.answerContentList[indexPath.row];
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            ZYQuestionnaireSurveyStatisticalOptionCell *cell = (ZYQuestionnaireSurveyStatisticalOptionCell *)currentCell;
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
            return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyStatisticalTextCellID configuration:^(ZYQuestionnaireSurveyStatisticalTextCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else {
            ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
            if (model.isOtherOption) {
                
                return kZYQuestionnaireSurveyStatisticalOtherCellHeight;
            }else {
                
                return [tableView fd_heightForCellWithIdentifier:ZYQuestionnaireSurveyStatisticalOptionCellID configuration:^(ZYQuestionnaireSurveyStatisticalOptionCell *cell) {
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
        if (listModel.choose == 2) {
            CGSize size = [[NSString stringWithFormat:@"%@（多选）", listModel.content] boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
            
            return size.height + 48;
        }else {
            CGSize size = [listModel.content boundingRectWithSize:CGSizeMake(kScreenW - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
            
            return size.height + 33;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return [[UIView alloc] init];
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[section - 1];
        ZYQuestionnaireSurveyEditHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyEditHeaderView" owner:nil options:nil].lastObject;
        headerView.model = listModel;
        
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0;
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[section - 1];
        if (listModel.choose == 3) {
            
            return kZYQuestionnaireSurveyStatisticalFooterViewHeight;
        }
        
        return kZYQuestionnaireSurveyEditFooterViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return [[UIView alloc] init];
    }else {
        ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[section - 1];
        if (listModel.choose == 3) {
            ZYQuestionnaireSurveyStatisticalFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyStatisticalFooterView" owner:nil options:nil].lastObject;
            footerView.moreButton.tag = 500 + section;
            [footerView.moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            return footerView;
        }
        ZYQuestionnaireSurveyEditFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYQuestionnaireSurveyEditFooterView" owner:nil options:nil].lastObject;
        
        return footerView;
    }
}

#pragma mark - ZYQuestionnaireSurveyStatisticalOtherCellDelegate
- (void)showButtonEvent:(NSIndexPath *)indexPath {
    NSLog(@"查看%ld", indexPath.row);
    ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[indexPath.section - 1];
    ZYQuestionnaireSurveyDetailEntityListOptionModel *model = listModel.options[indexPath.row];
    ZYQuestionnaireSurveyStatisticalMoreVc *vc = [[ZYQuestionnaireSurveyStatisticalMoreVc alloc] init];
    vc.titleStr = @"其它答案";
    vc.voteId = listModel.voteId;
    vc.topicId = model.topicId;
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
- (void)moreButtonClicked:(UIButton *)sender {
    NSLog(@"查看更多%ld", sender.tag - 500);
    ZYQuestionnaireSurveyDetailEntityListModel *listModel = self.detailModel.voteTopicEntityList[sender.tag - 500 - 1];
    ZYQuestionnaireSurveyStatisticalMoreVc *vc = [[ZYQuestionnaireSurveyStatisticalMoreVc alloc] init];
    vc.titleStr = @"更多答案";
    vc.voteId = listModel.voteId;
    vc.topicId = listModel.ID;
    [self pushVc:vc];
}

@end
