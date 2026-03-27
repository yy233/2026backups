//
//  ZYOwnersVotePlanVC.m
//  Community
//
//  Created by ZY on 2021/8/4.
//

#import "ZYOwnersVotePlanVC.h"
#import "ZYOwnersVotePlanCell.h"

static NSString * const ownersVotePlanCellID = @"ZYOwnersVotePlanCell";

@interface ZYOwnersVotePlanVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYOwnersVotePlanDataModel *dataModel;

@end

@implementation ZYOwnersVotePlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投票进度";
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initOwnersVotePlanData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 加载数据
// 加载投票进度数据
- (void)initOwnersVotePlanData {
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kOwnersVotePlanUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [self setUI];
                [self customTableView];
                ZYOwnersVotePlanModel *model = [ZYOwnersVotePlanModel yy_modelWithJSON:responsObject];
                self.dataModel = model.data;
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYOwnersVotePlanCell" bundle:nil] forCellReuseIdentifier:ownersVotePlanCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYOwnersVotePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ownersVotePlanCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

// 配置cell数据
- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    ZYOwnersVotePlanCell *cell = (ZYOwnersVotePlanCell *)currentCell;
    cell.model = self.dataModel;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:ownersVotePlanCellID cacheByIndexPath:indexPath configuration:^(ZYOwnersVotePlanCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

@end
