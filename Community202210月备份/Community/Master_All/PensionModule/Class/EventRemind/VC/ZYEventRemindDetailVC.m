//
//  ZYEventRemindDetailVC.m
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import "ZYEventRemindDetailVC.h"
#import "ZYEditEventVC.h"
#import "ZYEventRemindDetailContentCell.h"
#import "ZYEventRemindDetailBottomView.h"
#import "ZBLocalNotification.h"

static NSString * const eventRemindDetailContentCellID = @"ZYEventRemindDetailContentCell";
#define kEventRemindDetailBottomViewHeight button_bottom_height+150

@interface ZYEventRemindDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYEventRemindDetailBottomViewDelegate>

@property (nonatomic, strong) ZYEventRemindDetailBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYEventRemindModel *eventRemindModel;

@end

@implementation ZYEventRemindDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"事件详情";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_EDIT_EVENT_BACK", pensionAddEditEventBack)
}

// 通知回调
- (void)pensionAddEditEventBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_EDIT_EVENT_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kEventRemindDetailBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 加载数据
- (void)initData {
    NSDictionary *params = @{@"id" : self.eventModel.ID};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kEventDetailUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.eventRemindModel = [ZYEventRemindModel yy_modelWithJSON:responsObject[@"data"]];
                    [self.tableView reloadData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除事件提醒
- (void)initDeleteEventData {
    NSDictionary *params = @{@"id" : self.eventModel.ID};
    [[ToolOfNetWork sharedTools] YrequestDeleteALLURL:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kDeleteEventUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 取消对应的本地闹钟
                    [self cancelLocalNotification];
                    // 发送通知
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_DELETE_EVENT_BACK")
                    [self popVC];
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"删除成功" toView:self.view.window];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 懒加载
- (ZYEventRemindDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYEventRemindDetailBottomView" owner:nil options:nil].lastObject;
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:eventRemindDetailContentCellID bundle:nil] forCellReuseIdentifier:eventRemindDetailContentCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYEventRemindDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:eventRemindDetailContentCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYEventRemindDetailContentCell *cell = (ZYEventRemindDetailContentCell *)currentCell;
    cell.model = self.eventRemindModel;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return[tableView fd_heightForCellWithIdentifier:eventRemindDetailContentCellID cacheByIndexPath:indexPath configuration:^(ZYEventRemindDetailContentCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - ZYEventRemindDetailBottomViewDelegate
- (void)editButtonEvent {
    
    NSLog(@"编辑事件");
    ZYEditEventVC *vc = [[ZYEditEventVC alloc] init];
    vc.type = @"edit";
    vc.editEvenModel = [self.eventRemindModel yy_modelCopy];
    [self pushVc:vc];
}

- (void)deleteButtonEvent {
    
    NSLog(@"删除事件");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认删除吗？" message:@"删除不可恢复哦" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteEventData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 本地闹钟
// 取消本地定时通知
-(void)cancelLocalNotification {
    NSMutableArray *notiIds = [NSMutableArray array];
    for (NSString *week in self.eventModel.weeks) {
        [notiIds addObject:[NSString stringWithFormat:@"%@_%@", self.eventModel.ID, week]];
    }
    [ZBLocalNotification cancelLocalNotificationWithNotiIds:[notiIds copy]];
}

@end
