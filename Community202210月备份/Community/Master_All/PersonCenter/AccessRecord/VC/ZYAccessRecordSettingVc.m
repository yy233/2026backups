//
//  ZYAccessRecordSettingVc.m
//  Community
//
//  Created by ZY on 2022/4/25.
//

#import "ZYAccessRecordSettingVc.h"
#import "ZYAccessRecordSettingCell.h"
#import "ZYAccessRecordSettingMemberCell.h"
#import "ZYAccessRecordSettingHeaderView.h"

static NSString * const ZYAccessRecordSettingCellID = @"ZYAccessRecordSettingCell";
static NSString * const ZYAccessRecordSettingMemberCellID = @"ZYAccessRecordSettingMemberCell";
#define kZYAccessRecordSettingCellHeight 255
#define kZYAccessRecordSettingMemberCellHeight 100
#define kZYAccessRecordSettingHeaderViewHeight 40

@interface ZYAccessRecordSettingVc () <UITableViewDataSource, UITableViewDelegate, ZYAccessRecordSettingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYAccessRecordSettingHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前成员model
@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *currentMemberModel;

// 当前选中成员model
@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *selectedMemberModel;

// 访问权限
@property (nonatomic, assign) BOOL visitPermit;

// 通知权限
@property (nonatomic, assign) BOOL notiPermit;

@end

@implementation ZYAccessRecordSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"访问设置";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor];
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
    }
    
    return _tableView;
}

- (ZYAccessRecordSettingHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordSettingHeaderView" owner:nil options:nil].lastObject;
    }
    
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    for (int i = 0; i < self.originalArray.count; i++) {
        ZYAccessRecordVisitPermitModel *model = self.originalArray[i];
        if (i == 0) {
            self.currentMemberModel = model;
        }else {
            [self.dataArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

// 加载访客权限数据
- (void)initVisitJurisdictionData {
    NSDictionary *params = @{@"communityId" : self.currentMemberModel.communityId, @"visitPermit" : @(!self.currentMemberModel.visitPermit)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kVisitJurisdictionUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载单个通知权限数据
- (void)initSingleNotiJurisdictionData {
    NSDictionary *params = @{@"type" : @(!self.selectedMemberModel.memberNoticePermit), @"pusherUserMobile" : self.currentMemberModel.mobile, @"bindUserMobile" : self.selectedMemberModel.mobile, @"communityId" : self.currentMemberModel.communityId};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kSingleNotiJurisdictionUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载批量通知权限数据
- (void)initBatchNotiJurisdictionData {
    NSDictionary *params = @{@"type" : @(!self.currentMemberModel.noticePermit), @"communityId" : self.currentMemberModel.communityId, @"pusherUserMobile" : self.currentMemberModel.mobile};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kBatchNotiJurisdictionUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYAccessRecordSettingCellID bundle:nil] forCellReuseIdentifier:ZYAccessRecordSettingCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYAccessRecordSettingMemberCellID bundle:nil] forCellReuseIdentifier:ZYAccessRecordSettingMemberCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        if (self.currentMemberModel.noticePermit) {
            
            return self.dataArray.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYAccessRecordSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYAccessRecordSettingCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.currentMemberModel;
        
        return cell;
    }else if (indexPath.section == 1) {
        ZYAccessRecordSettingMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYAccessRecordSettingMemberCellID forIndexPath:indexPath];
        cell.memberSwitch.tag = 200 + indexPath.row;
        [cell.memberSwitch addTarget:self action:@selector(memberSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == (self.dataArray.count - 1)) {
            [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, kZYAccessRecordSettingMemberCellHeight) radius:5 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }
        if (indexPath.row == self.dataArray.count - 1) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
        ZYAccessRecordVisitPermitModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return kZYAccessRecordSettingCellHeight;
    }else if (indexPath.section == 1) {
        if (self.currentMemberModel.noticePermit) {
            
            return kZYAccessRecordSettingMemberCellHeight;;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        return self.headerView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (self.currentMemberModel.noticePermit && self.dataArray.count > 0) {
            
            return kZYAccessRecordSettingHeaderViewHeight;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        return 15;
    }
    
    return 0;
}

#pragma mark - ZYAccessRecordSettingCellDelegate
// 访问权限
- (void)visitSwitchChangedEvent:(UISwitch *)sender {
    NSLog(@"访问权限");
    [self initVisitJurisdictionData];
    self.currentMemberModel.visitPermit = !self.currentMemberModel.visitPermit;
    [self.tableView reloadData];
}

// 通知权限
- (void)noticeSwitchChangedEvent:(UISwitch *)sender {
    NSLog(@"通知权限");
    [self initBatchNotiJurisdictionData];
    self.currentMemberModel.noticePermit = !self.currentMemberModel.noticePermit;
    for (ZYAccessRecordVisitPermitModel *model in self.dataArray) {
        model.memberNoticePermit = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - 处理点击事件
- (void)memberSwitchChanged:(UISwitch *)sender {
    NSLog(@"%ld", sender.tag - 200);
    self.selectedMemberModel = self.dataArray[sender.tag - 200];
    [self initSingleNotiJurisdictionData];
    self.selectedMemberModel.memberNoticePermit = !self.selectedMemberModel.memberNoticePermit;
    [self.tableView reloadData];
}

@end
