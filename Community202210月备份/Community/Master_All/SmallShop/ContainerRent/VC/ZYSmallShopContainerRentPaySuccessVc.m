//
//  ZYSmallShopContainerRentPaySuccessVc.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPaySuccessVc.h"
#import "CommunityManagementMainVcLate.h"
#import "ZYSmallShopMainVC.h"
#import "ZYSmallShopContainerRentPaySuccessCell.h"
#import "ZYSmallShopContainerRentPaySuccessAddressCell.h"
#import "ZYSmallShopBaseRoundBottomView.h"
#import "AllMapNavigatioManger.h"

static NSString * const ZYSmallShopContainerRentPaySuccessCellID = @"ZYSmallShopContainerRentPaySuccessCell";
static NSString * const ZYSmallShopContainerRentPaySuccessAddressCellID = @"ZYSmallShopContainerRentPaySuccessAddressCell";
#define kZYSmallShopContainerRentPaySuccessCellHeight 305
#define kZYSmallShopBaseRoundBottomViewHeight button_bottom_height+90

@interface ZYSmallShopContainerRentPaySuccessVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopContainerRentPaySuccessAddressCellDelegate, ZYSmallShopBaseRoundBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopBaseRoundBottomView *bottomView;

@end

@implementation ZYSmallShopContainerRentPaySuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *vcs = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CommunityManagementMainVcLate class]]) {
            [vcs addObject:vc];
        }
        if ([vc isKindOfClass:[ZYSmallShopMainVC class]]) {
            [vcs addObject:vc];
        }
        if ([vc isKindOfClass:[ZYSmallShopContainerRentPaySuccessVc class]]) {
            [vcs addObject:vc];
        }
    }
    self.navigationController.viewControllers = [vcs copy];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopBaseRoundBottomViewHeight);
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

- (ZYSmallShopBaseRoundBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopBaseRoundBottomView" owner:nil options:nil].lastObject;
        _bottomView.btnText = @"返回首页";
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPaySuccessCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPaySuccessCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPaySuccessAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPaySuccessAddressCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopContainerRentPaySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPaySuccessCellID forIndexPath:indexPath];
        cell.price = self.price;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopContainerRentPaySuccessAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPaySuccessAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        ZYSmallShopContainerRentPaySuccessAddressCell *cell = (ZYSmallShopContainerRentPaySuccessAddressCell *)currentCell;
        cell.delegate = self;
        cell.model = self.model;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kZYSmallShopContainerRentPaySuccessCellHeight;
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopContainerRentPaySuccessAddressCellID configuration:^(ZYSmallShopContainerRentPaySuccessAddressCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

#pragma mark - ZYSmallShopContainerRentPaySuccessAddressCellDelegate
// 导航
- (void)navigationButtonEvent {
    NSLog(@"导航");
    
    [AllMapNavigatioManger gotoAddressWithLat:self.model.latitude lon:self.model.longitude title:[TextShowWithModelStr textShowWithNotNullStr:self.model.storeAddress] andPresntVC:self];
}

// 联系商家
- (void)chatButtonEvent {
    NSLog(@"联系商家");
    
    WEAKSELF
    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0  withImIdStr:[SmallShopNowShopShare share].saveNowShopIMId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
        if (success) {
            [weakSelf pushVc:willPushVc];
        }
    }];
}

#pragma mark - ZYSmallShopBaseRoundBottomViewDelegate
- (void)okButtonEvent {
    NSLog(@"返回首页");
    
    [self popVC];
}

@end
