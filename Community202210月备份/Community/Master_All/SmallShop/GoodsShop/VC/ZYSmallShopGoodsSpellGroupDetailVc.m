//
//  ZYSmallShopGoodsSpellGroupDetailVc.m
//  Community
//
//  Created by ZY on 2022/3/4.
//

#import "ZYSmallShopGoodsSpellGroupDetailVc.h"
#import "ZYSmallShopGoodsSpellGroupShareWebVc.h"
#import "ZYSmallShopGoodsSpellGroupDetailCell.h"
#import "ZYSmallShopGoodsSpellGroupDetailRemarkCell.h"
#import "ZYSmallShopDetailAddressCell.h"
#import "ZYSmallShopGoodsDetailInfoImageCell.h"
#import "ZYSmallShopGoodsSpellGroupDetailBottomView.h"
#import "AllMapNavigatioManger.h"

static NSString * const ZYSmallShopGoodsSpellGroupDetailCellID = @"ZYSmallShopGoodsSpellGroupDetailCell";
static NSString * const ZYSmallShopGoodsSpellGroupDetailRemarkCellID = @"ZYSmallShopGoodsSpellGroupDetailRemarkCell";
static NSString * const ZYSmallShopDetailAddressCellID = @"ZYSmallShopDetailAddressCell";
static NSString * const ZYSmallShopGoodsDetailInfoImageCellID = @"ZYSmallShopGoodsDetailInfoImageCell";
#define kZYSmallShopGoodsSpellGroupDetailBottomViewHeight button_bottom_height+60
#define kZYSmallShopGoodsDetailImageCellHeight 255.0/375.0*kScreenW

@interface ZYSmallShopGoodsSpellGroupDetailVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopDetailAddressCellDelegate, ZYSmallShopGoodsSpellGroupDetailBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupDetailBottomView *bottomView;

@property (nonatomic, assign) CGFloat collectionHeight;

@end

@implementation ZYSmallShopGoodsSpellGroupDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"DETAIL_INFO_IMAGE_COMPLETE_BACK", detailInfoImageCompleteBack:);
    Y_NSNotificationCenter_Creat_NameAction(@"SMALL_SHOP_PAY_SUCCESS_BACK", smallShopPaySuccessBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
}

// 通知回调
- (void)detailInfoImageCompleteBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = [noti.object doubleValue];
        self.collectionHeight = height;
        [self.tableView reloadData];
    });
}

- (void)smallShopPaySuccessBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self spellGroupButtonEvent];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"DETAIL_INFO_IMAGE_COMPLETE_BACK");
    Y_NSNotificationCenter_RemoveNotice_Name(@"SMALL_SHOP_PAY_SUCCESS_BACK");
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopGoodsSpellGroupDetailBottomViewHeight);
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

- (ZYSmallShopGoodsSpellGroupDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopGoodsSpellGroupDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        _bottomView.model = self.model;
    }
    
    return _bottomView;
}

// 加载数据
- (void)initData {
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:ZY_BASEURL(kSmallShopSpellGroupDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    self.tableView.hidden = NO;
                    self.bottomView.hidden = NO;
                    ZYSmallShopGoodsSpellGroupDetailModel *model = [ZYSmallShopGoodsSpellGroupDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    self.model = model;
                    self.bottomView.model = model;
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsSpellGroupDetailCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopGoodsSpellGroupDetailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsSpellGroupDetailRemarkCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopGoodsSpellGroupDetailRemarkCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopDetailAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopDetailAddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsDetailInfoImageCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopGoodsDetailInfoImageCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopGoodsSpellGroupDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopGoodsSpellGroupDetailCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopGoodsSpellGroupDetailRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopGoodsSpellGroupDetailRemarkCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYSmallShopDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopDetailAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 3) {
        ZYSmallShopGoodsDetailInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopGoodsDetailInfoImageCellID forIndexPath:indexPath];
        cell.imagesArray = [self.model.commodityDetailsImg componentsSeparatedByString:@","];
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopGoodsSpellGroupDetailCell *cell = (ZYSmallShopGoodsSpellGroupDetailCell *)currentCell;
        cell.model = self.model;
    }else if (indexPath.row == 1) {
        ZYSmallShopGoodsSpellGroupDetailRemarkCell *cell = (ZYSmallShopGoodsSpellGroupDetailRemarkCell *)currentCell;
        cell.model = self.model;
    }else if (indexPath.row == 2) {
        ZYSmallShopDetailAddressCell *cell = (ZYSmallShopDetailAddressCell *)currentCell;
        cell.delegate = self;
        ZYSmallShopGoodsDetailDataInfoModel *model = [[ZYSmallShopGoodsDetailDataInfoModel alloc] init];
        model.storePhone = self.model.storePhone;
        model.storeAddress = self.model.storeAddress;
        model.latitude = self.model.latitude;
        model.longitude = self.model.longitude;
        cell.model = model;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopGoodsSpellGroupDetailCellID configuration:^(ZYSmallShopGoodsSpellGroupDetailCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopGoodsSpellGroupDetailRemarkCellID configuration:^(ZYSmallShopGoodsSpellGroupDetailRemarkCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 2) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopDetailAddressCellID configuration:^(ZYSmallShopDetailAddressCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 3) {
        
        return self.collectionHeight + 80;
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

#pragma mark - ZYSmallShopGoodsSpellGroupDetailBottomViewDelegate
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

// 参加拼团
- (void)spellGroupButtonEvent {
    NSLog(@"参加拼团");
    
    if (self.model.groupSpellPersonNumber != self.model.personSpell) {
        ZYSmallShopGoodsSpellGroupShareWebVc *vc = [[ZYSmallShopGoodsSpellGroupShareWebVc alloc] init];
        vc.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
        vc.spellId = self.model.spellId;
        [self pushVc:vc];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"商品拼团活动已结束尽请期待下次拼团" toView:self.view delay:3.0];
    }
}

@end

