//
//  ZYSmallShopContainerRentPayVc.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPayVc.h"
#import "ZYSmallShopContainerRentOrderVc.h"
#import "ZYSmallShopContainerRentPayAddressCell.h"
#import "ZYSmallShopContainerRentPayPriceCell.h"
#import "ZYSmallShopContainerRentDetailInfoCell.h"
#import "ZYSmallShopContainerRentPayFooterView.h"
#import "ZYSmallShopPayBaseBottomView.h"
#import "SmallShopAddressData.h"
#import "BaseAddressAndPhoneInfoListVC.h"

static NSString * const ZYSmallShopContainerRentPayAddressCellID = @"ZYSmallShopContainerRentPayAddressCell";
static NSString * const ZYSmallShopContainerRentPayPriceCellID = @"ZYSmallShopContainerRentPayPriceCell";
static NSString * const ZYSmallShopContainerRentDetailInfoCellID = @"ZYSmallShopContainerRentDetailInfoCell";
#define kZYSmallShopPayBaseBottomViewHeight button_bottom_height+60
#define kZYSmallShopContainerRentPayFooterViewHeight 50
#define kZYSmallShopContainerRentPayPriceCellHeight 77+kZYSmallShopContainerRentPayPriceCollectionViewCell_H
#define kZYSmallShopContainerRentDetailInfoCellHeight 133
#define kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight 110

@interface ZYSmallShopContainerRentPayVc () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopContainerRentPayAddressCellDelegate, ZYSmallShopContainerRentPayPriceCellDelegate, ZYSmallShopContainerRentPayFooterViewDelegate, ZYSmallShopPayBaseViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopPayBaseBottomView *bottomView;

@property (nonatomic, strong) ZYSmallShopContainerRentPayFooterView *footerView;

@property (nonatomic, assign) NSInteger cabinetPriceStatus;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *address;

@end

@implementation ZYSmallShopContainerRentPayVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货柜租用";
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initAddressData];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYSmallShopPayBaseBottomViewHeight);
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (ZYSmallShopPayBaseBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopPayBaseBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        [_bottomView.payButton setTitle:@"提交订单" forState:UIControlStateNormal];
    }
    
    return _bottomView;
}

- (ZYSmallShopContainerRentPayFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopContainerRentPayFooterView" owner:nil options:nil].lastObject;
        _footerView.delegate = self;
    }
    
    return _footerView;
}

#pragma mark - 加载数据
- (void)initData {
    for (int i = 0; i < self.model.cabinetPriceDtos.count; i++) {
        ZYSmallShopContainerRentDetailCabinetModel *model = self.model.cabinetPriceDtos[i];
        if (i == 0) {
            model.isSelected = YES;
            self.bottomView.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:model.cabinetPriceSell]];
            self.cabinetPriceStatus = model.cabinetPriceStatus;
        }else {
            model.isSelected = NO;
        }
    }
}

// 获取用户地址
- (void)initAddressData {
    WEAKSELF
    [SmallShopAddressData smallShopNomalFirstAddressAndPhoneWithBlock:^(SmallShopAddressInfoModel * _Nonnull addressInfoModel, BOOL isHaveBool) {
        Y_SVP_DISMISS
        if (isHaveBool) {// yes = share 拿到了最新默认值 | no 做暂无
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone = addressInfoModel.phone;
                self.address = addressInfoModel.detail;
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

// 加载订单数据
- (void)initOrderData {
    NSDictionary *params = @{@"id" : self.model.ID, @"numOrType" : @(self.cabinetPriceStatus), @"phone" : self.model.storePhone, @"detail" : self.model.storeAddress, @"type" : @(self.model.type)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopAddOrderUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *orderId = responsObject[@"data"];
                NSLog(@"%@", orderId);
                ZYSmallShopContainerRentOrderVc *vc = [[ZYSmallShopContainerRentOrderVc alloc] init];
                vc.model = self.model;
                vc.orderId = orderId;
                vc.address = self.address;
                vc.phone = self.phone;
                [self pushVc:vc];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//续租｜生成订单数据
// 加载订单数据
- (void)boxReletRentAddOrderData {//cabinetPriceStatus收费标准(1月租 2季度 3半年 4年度)
    NSDictionary *params = @{@"cabinetId" : self.model.ID, @"cabinetPriceStatus" : @(self.cabinetPriceStatus), @"phone" : self.model.storePhone, @"addressDetail" : self.model.storeAddress};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopBoxReletRentAddOrderUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *orderId = Y_ResponsObject_dataStr;
                NSLog(@"%@", orderId);
                ZYSmallShopContainerRentOrderVc *vc = [[ZYSmallShopContainerRentOrderVc alloc] init];
                vc.model = self.model;
                vc.orderId = orderId;
                vc.address = self.address;
                vc.phone = self.phone;
                [self pushVc:vc];
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPayAddressCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPayAddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPayPriceCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentPayPriceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentDetailInfoCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopContainerRentDetailInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopContainerRentPayAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPayAddressCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYSmallShopContainerRentPayPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentPayPriceCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.model;
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYSmallShopContainerRentDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopContainerRentDetailInfoCellID forIndexPath:indexPath];
        cell.model = self.model;
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYSmallShopContainerRentPayAddressCell *cell = (ZYSmallShopContainerRentPayAddressCell *)currentCell;
        cell.delegate = self;
        [cell fillNewAddressStr:self.address andPhoneStr:self.phone];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopContainerRentPayAddressCellID configuration:^(ZYSmallShopContainerRentPayAddressCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 1) {
        
        return kZYSmallShopContainerRentPayPriceCellHeight;
    }else if (indexPath.row == 2) {
        if (self.model.isHiddenRemainDay) {
            
            return kZYSmallShopContainerRentDetailInfoCellHiddenDayHeight;
        }else {
            
            return kZYSmallShopContainerRentDetailInfoCellHeight;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return kZYSmallShopPayBaseBottomViewHeight;
}

#pragma mark - ZYSmallShopContainerRentPayAddressCellDelegate
// 信息修改
- (void)editButtonEvent {
    NSLog(@"信息修改");
    
    BaseAddressAndPhoneInfoListVC *vc = [[BaseAddressAndPhoneInfoListVC alloc] init];
    [self pushVc:vc];
}

#pragma mark - ZYSmallShopContainerRentPayPriceCellDelegate
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    ZYSmallShopContainerRentDetailCabinetModel *model = self.model.cabinetPriceDtos[indexPath.row];
    for (ZYSmallShopContainerRentDetailCabinetModel *tempModel in self.model.cabinetPriceDtos) {
        tempModel.isSelected = NO;
    }
    model.isSelected = YES;
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"%@", [ZYDecimalNumberTool stringWithDecimalString:model.cabinetPriceSell]];
    self.cabinetPriceStatus = model.cabinetPriceStatus;
    [self.tableView reloadData];
}

#pragma mark - ZYSmallShopContainerRentPayFooterViewDelegate
// 协议
- (void)agreementButtonEvent {
    NSLog(@"协议");
    
    self.footerView.agreementButton.selected = !self.footerView.agreementButton.isSelected;
}

#pragma mark - ZYSmallShopPayBaseViewDelegate
// 提交订单
- (void)payButtonEvent {
    NSLog(@"提交订单");
    
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }else{
            if(!weakSelf.footerView.agreementButton.isSelected){
                Y_SVP_SHOW_INFO_MES(@"租用协议未同意！");
                return;
            }
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"购买中..."];
            if (weakSelf.isRelet) {//续租
                [weakSelf boxReletRentAddOrderData];
            }else{
                [weakSelf initOrderData];
            }
        }
    }];

}

@end
