//
//  ZYSmallShopServiceDetailVc.m
//  Community
//
//  Created by ZY on 2022/3/3.
//

#import "ZYSmallShopServiceDetailVc.h"
#import "SmallShopOneGoodsPayVC.h"
#import "ZYSmallShopGoodsDetailImageCell.h"
#import "ZYSmallShopServiceDetailPriceCell.h"
#import "ZYSmallShopDetailAddressCell.h"
#import "ZYSmallShopGoodsDetailInfoImageCell.h"
#import "ZYSmallShopGoodsDetailBottomView.h"
#import "AllMapNavigatioManger.h"

static NSString * const ZYSmallShopGoodsDetailImageCellID = @"ZYSmallShopGoodsDetailImageCell";
static NSString * const ZYSmallShopServiceDetailPriceCellID = @"ZYSmallShopServiceDetailPriceCell";
static NSString * const ZYSmallShopDetailAddressCellID = @"ZYSmallShopDetailAddressCell";
static NSString * const ZYSmallShopGoodsDetailInfoImageCellID = @"ZYSmallShopGoodsDetailInfoImageCell";
#define kZYSmallShopGoodsDetailBottomViewHeight button_bottom_height+60
#define kZYSmallShopGoodsDetailImageCellHeight 255.0/375.0*kScreenW

@interface ZYSmallShopServiceDetailVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopDetailAddressCellDelegate, ZYSmallShopGoodsDetailBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopGoodsDetailBottomView *bottomView;

@property (nonatomic, strong) ZYSmallShopServiceDetailModel *model;

@property (nonatomic, assign) CGFloat collectionHeight;

@end

@implementation ZYSmallShopServiceDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务详情";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"DETAIL_INFO_IMAGE_COMPLETE_BACK", detailInfoImageCompleteBack:);
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

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"DETAIL_INFO_IMAGE_COMPLETE_BACK");
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopGoodsDetailBottomViewHeight);
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

- (ZYSmallShopGoodsDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopGoodsDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.shoppingCartButton.hidden = YES;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 加载数据
- (void)initData {
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    NSDictionary *params = @{@"serveId" : self.serveId};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopServeDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    self.tableView.hidden = NO;
                    self.bottomView.hidden = NO;
                    ZYSmallShopServiceDetailModel *model = [ZYSmallShopServiceDetailModel yy_modelWithJSON:responsObject[@"data"]];
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsDetailImageCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopGoodsDetailImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopServiceDetailPriceCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopServiceDetailPriceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopDetailAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopDetailAddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsDetailInfoImageCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopGoodsDetailInfoImageCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopGoodsDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopGoodsDetailImageCellID forIndexPath:indexPath];
        cell.imageUrlStr = self.model.serveHeadImg;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopServiceDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopServiceDetailPriceCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYSmallShopDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopDetailAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 3) {
        ZYSmallShopGoodsDetailInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopGoodsDetailInfoImageCellID forIndexPath:indexPath];
        cell.imagesArray = [self.model.serveDetailsImg componentsSeparatedByString:@","];
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        ZYSmallShopServiceDetailPriceCell *cell = (ZYSmallShopServiceDetailPriceCell *)currentCell;
        cell.model = self.model;
    }else if (indexPath.row == 2) {
        ZYSmallShopDetailAddressCell *cell = (ZYSmallShopDetailAddressCell *)currentCell;
        cell.delegate = self;
        cell.model = self.model.informationDto;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kZYSmallShopGoodsDetailImageCellHeight;
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopServiceDetailPriceCellID configuration:^(ZYSmallShopServiceDetailPriceCell *cell) {
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
    
    [AllMapNavigatioManger gotoAddressWithLat:self.model.informationDto.latitude lon:self.model.informationDto.longitude title:[TextShowWithModelStr textShowWithNotNullStr:self.model.informationDto.storeAddress] andPresntVC:self];
}

#pragma mark - ZYSmallShopGoodsDetailBottomViewDelegate
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

// 立即购买
- (void)buyButtonEvent {
    NSLog(@"立即购买");
    
    SmallShopOneGoodsPayVC *vc = [[SmallShopOneGoodsPayVC alloc] init];
    vc.nowGoodsSeviceBoxType = SmallShopOneGoodsPayVC_Type_Service;
    vc.detailVcUseModelDic = [NSMutableDictionary dictionaryWithDictionary:[self.model yy_modelToJSONObject]];
 
    [self pushVc:vc];
}

@end
