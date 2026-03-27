//
//  ZYSmallShopContainerRentDetailVc.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentDetailVc.h"
#import "ZYSmallShopContainerRentPayVc.h"
#import "ZYSmallShopContainerRentDetailBottomView.h"
#import "ZYSmallShopDetailImageCell.h"
#import "ZYSmallShopContainerRentDetailPriceCell.h"
#import "ZYSmallShopContainerRentDetailInfoCell.h"
#import "ZYSmallShopDetailAddressCell.h"
#import "AllMapNavigatioManger.h"

static NSString * const ZYSmallShopDetailImageCellID = @"ZYSmallShopDetailImageCell";
static NSString * const ZYSmallShopContainerRentDetailPriceCellID = @"ZYSmallShopContainerRentDetailPriceCell";
static NSString * const ZYSmallShopContainerRentDetailInfoCellID = @"ZYSmallShopContainerRentDetailInfoCell";
static NSString * const ZYSmallShopDetailAddressCellID = @"ZYSmallShopDetailAddressCell";
#define kZYSmallShopContainerRentDetailBottomViewHeight button_bottom_height+60
#define kZYSmallShopDetailImageCellHeight 255.0/375.0*kScreenW
#define kZYSmallShopContainerRentDetailInfoCellHeight 133
#define kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight 110

@interface ZYSmallShopContainerRentDetailVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopDetailAddressCellDelegate, ZYSmallShopContainerRentDetailBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopContainerRentDetailBottomView *bottomView;

@property (nonatomic, strong) ZYSmallShopContainerRentDetailModel *model;

@end

@implementation ZYSmallShopContainerRentDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货柜详情";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopContainerRentDetailBottomViewHeight);
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

- (ZYSmallShopContainerRentDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopContainerRentDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 加载数据
- (void)initData {
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    NSDictionary *params = @{@"cabinetId" : self.cabinetId};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopContainerDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    self.tableView.hidden = NO;
                    self.bottomView.hidden = NO;
                    ZYSmallShopContainerRentDetailModel *model = [ZYSmallShopContainerRentDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    model.isHiddenRemainDay = self.isHiddenRemainDay;
                    self.model = model;
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopDetailImageCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopDetailImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentDetailPriceCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentDetailPriceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentDetailInfoCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentDetailInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopDetailAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopDetailAddressCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopDetailImageCellID forIndexPath:indexPath];
        cell.model = self.model;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopContainerRentDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentDetailPriceCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYSmallShopContainerRentDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentDetailInfoCellID forIndexPath:indexPath];
        cell.model = self.model;
        
        return cell;
    }else if (indexPath.row == 3) {
        ZYSmallShopDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopDetailAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        ZYSmallShopContainerRentDetailPriceCell *cell = (ZYSmallShopContainerRentDetailPriceCell *)currentCell;
        cell.model = self.model;
    }else if (indexPath.row == 3) {
        ZYSmallShopDetailAddressCell *cell = (ZYSmallShopDetailAddressCell *)currentCell;
        cell.delegate = self;
        ZYSmallShopGoodsDetailDataInfoModel *model = [[ZYSmallShopGoodsDetailDataInfoModel alloc] init];
        model.storePhone = self.model.storePhone;
        model.storeAddress = self.model.storeAddress;
        cell.model = model;;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kZYSmallShopDetailImageCellHeight;
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopContainerRentDetailPriceCellID configuration:^(ZYSmallShopContainerRentDetailPriceCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 2) {
        if (self.model.isHiddenRemainDay) {
            
            return kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight;
        }else {
            
            return kZYSmallShopContainerRentDetailInfoCellHeight;
        }
    }else if (indexPath.row == 3) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopDetailAddressCellID configuration:^(ZYSmallShopDetailAddressCell *cell) {
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

#pragma mark - ZYSmallShopDetailAddressCellDelegate
// 导航
- (void)navigationButtonEvent {
    NSLog(@"导航");
    
    [AllMapNavigatioManger gotoAddressWithLat:self.model.latitude lon:self.model.longitude title:[TextShowWithModelStr textShowWithNotNullStr:self.model.storeAddress] andPresntVC:self];
}

#pragma mark - ZYSmallShopContainerRentDetailBottomViewDelegate
// 联系商家
- (void)chatButtonEvent {
    NSLog(@"联系商家");
    WEAKSELF
 
    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0 withImIdStr:[SmallShopNowShopShare share].saveNowShopIMId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
        if (success) {
            [weakSelf pushVc:willPushVc];
        }
    }];
}

// 立即租用
- (void)rentButtonEvent {
    NSLog(@"立即租用");
    
    ZYSmallShopContainerRentPayVc *vc = [[ZYSmallShopContainerRentPayVc alloc] init];
    vc.model = [self.model yy_modelCopy];
    [self pushVc:vc];
}

@end
