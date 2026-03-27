//
//  ZYParkingAddMonthCardVc.m
//  Community
//
//  Created by ZY on 2022/5/9.
//

#import "ZYParkingAddMonthCardVc.h"
#import "ZYParkingMonthCardPayDetailVc.h"
#import "ZYParkingAddMonthCardCell.h"
#import "ZYParkingMonthCardRenewalCell.h"
#import "ZYParkingMonthCardRenewalEditCell.h"
#import "ZYParkingMonthCardRenewalFooterView.h"
#import "ZYParkingMonthCardPayBottomView.h"
#import "ZYAccessRecordMemberPopView.h"
#import "ZYParkingHouseModel.h"
#import "ZYParkingCarAddressModel.h"
#import "ZYParkingStallCategoryModel.h"
#import "ZYParkingStallRelevantStallModel.h"
#import "ZYParkingStallRelevantCarModel.h"
#import "ZYParkingMonthCardUploadModel.h"

static NSString * const ZYParkingAddMonthCardCellID = @"ZYParkingAddMonthCardCell";
static NSString * const ZYParkingMonthCardRenewalCellID = @"ZYParkingMonthCardRenewalCell";
static NSString * const ZYParkingMonthCardRenewalEditCellID = @"ZYParkingMonthCardRenewalEditCell";
#define kZYParkingAddMonthCardCellHeight 50
#define kZYParkingMonthCardRenewalFooterViewHeight 100
#define kZYParkingMonthCardPayBottomViewHeight 55+button_bottom_height

@interface ZYParkingAddMonthCardVc () <UITableViewDataSource, UITableViewDelegate, ZYParkingMonthCardPayBottomViewDelegate, ZYParkingMonthCardRenewalEditCellDelegate, ZYAccessRecordMemberPopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYParkingMonthCardRenewalFooterView *footerView;

@property (nonatomic, strong) ZYParkingMonthCardPayBottomView *bottomView;

@property (nonatomic, strong) ZYAccessRecordMemberPopView *popView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 房屋数组
@property (nonatomic, strong) NSMutableArray *houseArray;

// 当前选中的房屋model
@property (nonatomic, strong) ZYParkingHouseModel *currentHouseModel;

// 车位分类(场地)数组
@property (nonatomic, strong) NSMutableArray *stallCategorArray;

// 当前选中的车位分类(场地)model
@property (nonatomic, strong) ZYParkingStallCategoryModel *currentStallCategoryModel;

// 停车位置数组
@property (nonatomic, strong) NSMutableArray *carAddressArray;

// 当前选中停车位置model
@property (nonatomic, strong) ZYParkingCarAddressModel *currentCarAddressModel;

// 关联车辆数组(地面状态时)
@property (nonatomic, strong) NSMutableArray *relevantCarArray;

// 当前选中关联车位model
@property (nonatomic, strong) ZYParkingStallRelevantCarModel *currentRelevantCarModel;

// 关联车位数组(地下状态时)
@property (nonatomic, strong) NSMutableArray *relevantStallArray;

// 当前选中关联车位model
@property (nonatomic, strong) ZYParkingStallRelevantStallModel *currentRelevantStallModel;

// 月数
@property (nonatomic, assign) NSInteger monthNum;

// 当前选中cell的index
@property (nonatomic, assign) NSInteger currentIndex;

// 是否选中停车位置
@property (nonatomic, assign) BOOL isCarAddress;

// 购买月卡提交数据model
@property (nonatomic, strong) ZYParkingMonthCardUploadModel *uploadModel;

// 月租价格
@property (nonatomic, copy) NSString *monthCardPrice;

// 第一次加载界面
@property (nonatomic, assign) BOOL isFirstLoading;

@end

@implementation ZYParkingAddMonthCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买月租卡";
    [self setUI];
    [self customTableView];
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
        make.height.offset(kZYParkingMonthCardPayBottomViewHeight);
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
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYParkingMonthCardRenewalFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardRenewalFooterView" owner:nil options:nil].lastObject;
    }
    
    return _footerView;
}

- (ZYParkingMonthCardPayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYParkingMonthCardPayBottomView" owner:nil options:nil].lastObject;
        _bottomView.hidden = YES;
        [_bottomView.payButton setTitle:@"购买" forState:UIControlStateNormal];
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYAccessRecordMemberPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordMemberPopView" owner:nil options:nil].lastObject;
        _popView.delegate = self;
    }
    
    return _popView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)houseArray {
    if (!_houseArray) {
        _houseArray = [NSMutableArray array];
    }
    
    return _houseArray;
}

- (NSMutableArray *)stallCategorArray {
    if (!_stallCategorArray) {
        _stallCategorArray = [NSMutableArray array];
    }
    
    return _stallCategorArray;
}

- (NSMutableArray *)carAddressArray {
    if (!_carAddressArray) {
        _carAddressArray = [NSMutableArray array];
    }
    
    return _carAddressArray;
}

- (NSMutableArray *)relevantCarArray {
    if (!_relevantCarArray) {
        _relevantCarArray = [NSMutableArray array];
    }
    
    return _relevantCarArray;
}

- (NSMutableArray *)relevantStallArray {
    if (!_relevantStallArray) {
        _relevantStallArray = [NSMutableArray array];
    }
    
    return _relevantStallArray;
}

- (ZYParkingMonthCardUploadModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[ZYParkingMonthCardUploadModel alloc] init];
    }
    
    return _uploadModel;
}

#pragma mark - 加载数据
- (void)initData {
    self.monthNum = 1;
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    NSArray *titlesArray = @[@"选择房屋", @"选择场地", @"停车位置", @"续期时长", @"有效期至"];
    NSDate *currentDate = [self getCurrentDateWithMonthNum:1];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", currentDate.br_year, currentDate.br_month, currentDate.br_day];
    NSArray *contentsArray = @[@"", @"", @"", @"", currentDateStr];
    for (int i = 0; i < titlesArray.count; i++) {
        ZYParkingMonthCardRenewalModel *model = [[ZYParkingMonthCardRenewalModel alloc] init];
        model.order = i;
        model.title = titlesArray[i];
        model.content = contentsArray[i];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
    self.isFirstLoading = YES;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initHouseListData];
    [self initMaxMonthNumData];
    [self initExpireTimeData];
}

// 加载房屋列表数据
- (void)initHouseListData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingAllHouseUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.houseArray.count > 0) {
                        [self.houseArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingHouseModel class] json:responsObject[@"data"]];
                    [self.houseArray addObjectsFromArray:array];
                    if (!self.houseArray.count) {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂无房屋数据" toView:self.view];
                        return;
                    }
                    if (self.isFirstLoading) {
                        self.isFirstLoading = NO;
                        if (self.houseArray.count > 0) {
                            self.currentHouseModel = [self.houseArray firstObject];
                            ZYParkingMonthCardRenewalModel *model = [self.dataArray firstObject];
                            model.content = self.currentHouseModel.belongHouse;
                            [self.tableView reloadData];
                        }
                    }else {
                        NSMutableArray *mArr = [NSMutableArray array];
                        for (ZYParkingHouseModel *model in self.houseArray) {
                            [mArr addObject:model.belongHouse];
                        }
                        self.popView.dataArray = [mArr copy];
                        [self.popView showAccessRecordMemberPopView];
                    }
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载车场分类数据
- (void)initStallCategorytData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kParkingStallCategoryUrl) withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.stallCategorArray.count > 0) {
                    [self.stallCategorArray removeAllObjects];
                }
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingStallCategoryModel class] json:responsObject[@"data"][@"records"]];
                [self.stallCategorArray addObjectsFromArray:array];
                if (!self.stallCategorArray.count) {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"暂无场地数据" toView:self.view];
                    return;
                }
                NSMutableArray *mArr = [NSMutableArray array];
                for (ZYParkingStallCategoryModel *model in self.stallCategorArray) {
                    [mArr addObject:model.siteClassificationName];
                }
                self.popView.dataArray = [mArr copy];
                [self.popView showAccessRecordMemberPopView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载停车位置列表数据
- (void)initCarAddressData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"siteClassificationId" : self.currentStallCategoryModel.ID};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingCarAddressUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.carAddressArray.count > 0) {
                        [self.carAddressArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingCarAddressModel class] json:responsObject[@"data"]];
                    [self.carAddressArray addObjectsFromArray:array];
                    if (!self.carAddressArray.count) {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂无停车位置数据" toView:self.view];
                        return;
                    }
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (ZYParkingCarAddressModel *model in self.carAddressArray) {
                        [mArr addObject:model.name];
                    }
                    self.popView.dataArray = [mArr copy];
                    [self.popView showAccessRecordMemberPopView];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载关联车辆(地面状态时)数据
- (void)initRelevantCarData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingRelevantCarUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    if (self.relevantCarArray.count > 0) {
                        [self.relevantCarArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingStallRelevantCarModel class] json:responsObject[@"data"]];
                    [self.relevantCarArray addObjectsFromArray:array];
                    if (!self.relevantCarArray.count) {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"暂无地面车位可用" toView:self.view];
                        return;
                    }
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (ZYParkingStallRelevantCarModel *model in self.relevantCarArray) {
                        [mArr addObject:model.carNumber];
                    }
                    self.popView.dataArray = [mArr copy];
                    [self.popView showAccessRecordMemberPopView];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载关联车位(地上下状态时)数据
- (void)initRelevantStallData {
    NSDictionary *params = @{@"groundUpAndDown" : @(self.currentCarAddressModel.type), @"siteClassificationId" : self.currentStallCategoryModel.ID};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kParkingRelevantStallUrl) withBody:params finished:^(id responsObject, NSError *error) {
        if (self.currentCarAddressModel.type != 0) {
            Y_SVP_DISMISS
        }
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.relevantStallArray.count > 0) {
                    [self.relevantStallArray removeAllObjects];
                }
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYParkingStallRelevantStallModel class] json:responsObject[@"data"]];
                if (self.currentCarAddressModel.type != 0) {
                    [self.relevantStallArray addObjectsFromArray:array];
                }
                if (!array.count) {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"暂无地下车位可用" toView:self.view];
                    return;
                }
                // 获取地面车位id
                if (self.currentCarAddressModel.type == 0) {
                    self.currentRelevantStallModel = [array firstObject];
                    [self initRelevantCarData];
                    return;
                }
                NSMutableArray *mArr = [NSMutableArray array];
                for (ZYParkingStallRelevantStallModel *model in self.relevantStallArray) {
                    [mArr addObject:model.carPositionNumber];
                }
                self.popView.dataArray = [mArr copy];
                [self.popView showAccessRecordMemberPopView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载月租卡价格数据
- (void)initMonthCardPriceData {
    NSDictionary * params = @{@"carPositionId" : self.currentRelevantStallModel.ID};;
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingMonthCardPriceUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    self.bottomView.hidden = NO;
                    NSString *price = responsObject[@"data"];
                    self.monthCardPrice = [ZYDecimalNumberTool stringWithDecimalString:price];
                    NSString *decimalsPrice = [NSString stringWithFormat:@"￥%.2lf", [self.monthCardPrice floatValue] * self.monthNum];
                    self.bottomView.priceLabel.text = decimalsPrice;
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载最大包月数数据
- (void)initMaxMonthNumData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingMonthCardMaxMonthUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSNumber *maxMonthNum = responsObject[@"data"];
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    NSString *maxMonthNumStr = [numberFormatter stringFromNumber:maxMonthNum];
                    ZYParkingMonthCardRenewalEditCell *cell;
                    if (!self.isCarAddress) {
                        cell = (ZYParkingMonthCardRenewalEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    }else {
                        cell = (ZYParkingMonthCardRenewalEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    }
                    cell.maxMonthNum = [maxMonthNumStr integerValue];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

// 加载月租到期时间数据
- (void)initExpireTimeData {
    NSDictionary *params = @{@"months" : @(self.monthNum)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kAddParkingMonthCardExpireTimeUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSString *expireTime = responsObject[@"data"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *expireDate = [dateFormatter dateFromString:expireTime];
                    ZYParkingMonthCardRenewalModel *model = [self.dataArray lastObject];
                    NSString *currentDateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", expireDate.br_year, expireDate.br_month, expireDate.br_day];
                    model.content = currentDateStr;
                    [self.tableView reloadData];
                }
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingAddMonthCardCellID bundle:nil] forCellReuseIdentifier:ZYParkingAddMonthCardCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardRenewalCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardRenewalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardRenewalEditCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardRenewalEditCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isCarAddress) {
        if (indexPath.row == 3) {
            ZYParkingMonthCardRenewalEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalEditCellID forIndexPath:indexPath];
            cell.delegate = self;
            cell.model = self.dataArray[indexPath.row];
            
            return cell;
        }else if (indexPath.row == 4) {
            ZYParkingMonthCardRenewalCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalCellID forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.row];
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineView.hidden = YES;
            }
            
            return cell;
        }else {
            ZYParkingAddMonthCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingAddMonthCardCellID forIndexPath:indexPath];
            cell.selectView.tag = 200 + indexPath.row;
            [cell.selectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTap:)]];
            ZYParkingMonthCardRenewalModel *model = self.dataArray[indexPath.row];
            cell.model = model;
            
            return cell;
        }
    }else {
        if (indexPath.row == 4) {
            ZYParkingMonthCardRenewalEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalEditCellID forIndexPath:indexPath];
            cell.delegate = self;
            cell.model = self.dataArray[indexPath.row];
            
            return cell;
        }else if (indexPath.row == 5) {
            ZYParkingMonthCardRenewalCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalCellID forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.row];
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineView.hidden = YES;
            }
            
            return cell;
        }else {
            ZYParkingAddMonthCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingAddMonthCardCellID forIndexPath:indexPath];
            cell.selectView.tag = 200 + indexPath.row;
            [cell.selectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTap:)]];
            ZYParkingMonthCardRenewalModel *model = self.dataArray[indexPath.row];
            cell.model = model;
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYParkingAddMonthCardCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return kZYParkingMonthCardRenewalFooterViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.footerView;
}

#pragma mark - ZYParkingMonthCardPayBottomViewDelegate
// 购买
- (void)payButtonEvent {
    NSLog(@"购买");
    if ([self judgeNoEmptyData]) {
        ZYParkingMonthCardPayDetailVc *vc = [[ZYParkingMonthCardPayDetailVc alloc] init];
        vc.type = ZYParking_MonthCard_Type_Add;
        vc.uploadModel = self.uploadModel;
        [self pushVc:vc];
    }
}

#pragma mark - ZYParkingMonthCardRenewalEditCellDelegate
- (void)addButtonEventWithMonth:(NSInteger)month {
    NSLog(@"月数%ld", month);
    self.monthNum = month;
    ZYParkingMonthCardRenewalModel *model = [self.dataArray lastObject];
    NSDate *currentDate = [self getCurrentDateWithMonthNum:month];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", currentDate.br_year, currentDate.br_month, currentDate.br_day];
    model.content = currentDateStr;
    [self.tableView reloadData];
    [self initExpireTimeData];
    if (self.monthCardPrice.length > 0) {
        NSString *decimalsPrice = [NSString stringWithFormat:@"￥%.2lf", [self.monthCardPrice floatValue] * self.monthNum];
        self.bottomView.priceLabel.text = decimalsPrice;
    }
}

- (void)subtractButtonEventWithMonth:(NSInteger)month {
    NSLog(@"月数%ld", month);
    self.monthNum = month;
    ZYParkingMonthCardRenewalModel *model = [self.dataArray lastObject];
    NSDate *currentDate = [self getCurrentDateWithMonthNum:month];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", currentDate.br_year, currentDate.br_month, currentDate.br_day];
    model.content = currentDateStr;
    [self.tableView reloadData];
    [self initExpireTimeData];
    if (self.monthCardPrice.length > 0) {
        NSString *decimalsPrice = [NSString stringWithFormat:@"￥%.2lf", [self.monthCardPrice floatValue] * self.monthNum];
        self.bottomView.priceLabel.text = decimalsPrice;
    }
}

#pragma mark - ZYAccessRecordMemberPopViewDelegate
- (void)contentViewEventWithIndex:(NSInteger)index {
    NSLog(@"选择%ld", index);
    [self.popView hiddenAccessRecordMemberPopView];
    ZYParkingMonthCardRenewalModel *model = self.dataArray[self.currentIndex];
    if (self.currentIndex == 0) {
        self.currentHouseModel = self.houseArray[index];
        model.content = self.currentHouseModel.belongHouse;
    }else if (self.currentIndex == 1) {
        self.bottomView.hidden = YES;
        self.currentStallCategoryModel = self.stallCategorArray[index];
        model.content = self.currentStallCategoryModel.siteClassificationName;
        // 重置停车位置和关联车位数据
        if (self.carAddressArray.count > 0) {
            [self.carAddressArray removeAllObjects];
            self.currentCarAddressModel = nil;
            self.monthCardPrice = @"";
            ZYParkingMonthCardRenewalModel *nextModel = self.dataArray[self.currentIndex + 1];
            nextModel.content = @"";
            if (self.isCarAddress) {
                self.isCarAddress = NO;
                [self.dataArray removeObjectAtIndex:3];
                if (self.relevantCarArray.count > 0) {
                    [self.relevantCarArray removeAllObjects];
                    self.currentRelevantCarModel = nil;
                }
                if (self.relevantStallArray.count > 0) {
                    [self.relevantStallArray removeAllObjects];
                    self.currentRelevantStallModel = nil;
                }
            }
        }
    }else if (self.currentIndex == 2) {
        self.currentCarAddressModel = self.carAddressArray[index];
        if (!self.isCarAddress) {
            self.isCarAddress = YES;
            ZYParkingMonthCardRenewalModel *model = [[ZYParkingMonthCardRenewalModel alloc] init];
            model.order = 3;
            if (self.currentCarAddressModel.type == 0) {
                model.title = @"关联车辆";
            }else {
                model.title = @"关联车位";
            }
            model.content = @"";
            [self.dataArray insertObject:model atIndex:3];
        }else {
            ZYParkingMonthCardRenewalModel *model = self.dataArray[3];
            if (self.currentCarAddressModel.type == 0) {
                model.title = @"关联车辆";
            }else {
                model.title = @"关联车位";
            }
            model.content = @"";
        }
        model.content = self.currentCarAddressModel.name;
    }else if (self.currentIndex == 3) {
        if (self.currentCarAddressModel.type == 0) {
            self.currentRelevantCarModel = self.relevantCarArray[index];
            model.content = self.currentRelevantCarModel.carNumber;
        }else {
            self.currentRelevantStallModel = self.relevantStallArray[index];
            model.content = self.currentRelevantStallModel.carPositionNumber;
        }
    }
    self.bottomView.hidden = YES;
    [self.tableView reloadData];
    
    if ([self judgeNoEmptyDataNoHint]) {
        [self initMonthCardPriceData];
    }
}

#pragma mark - 处理点击事件
- (void)selectViewTap:(UIGestureRecognizer *)tap {
    NSLog(@"选择%ld", tap.view.tag - 200);
    self.currentIndex = tap.view.tag - 200;
    ZYParkingMonthCardRenewalModel *model = self.dataArray[self.currentIndex];
    self.popView.titleLabel.text = model.title;
    if (self.currentIndex == 0) {
        if (self.houseArray.count > 0) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (ZYParkingHouseModel *model in self.houseArray) {
                [mArr addObject:model.belongHouse];
            }
            self.popView.dataArray = [mArr copy];
            [self.popView showAccessRecordMemberPopView];
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initHouseListData];
        }
    }else if (self.currentIndex == 1) {
        if (self.stallCategorArray.count > 0) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (ZYParkingStallCategoryModel *model in self.stallCategorArray) {
                [mArr addObject:model.siteClassificationName];
            }
            self.popView.dataArray = [mArr copy];
            [self.popView showAccessRecordMemberPopView];
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initStallCategorytData];
        }
    }else if (self.currentIndex == 2) {
        if (!self.currentStallCategoryModel.ID.length) {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请先选择场地" toView:self.view];
            return;
        }
        if (self.carAddressArray.count > 0) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (ZYParkingCarAddressModel *model in self.carAddressArray) {
                [mArr addObject:model.name];
            }
            self.popView.dataArray = [mArr copy];
            [self.popView showAccessRecordMemberPopView];
        }else {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
            [self initCarAddressData];
        }
    }else if (self.currentIndex == 3) {
        if (self.currentCarAddressModel.type == 0) {
            if (self.relevantCarArray.count > 0) {
                NSMutableArray *mArr = [NSMutableArray array];
                for (ZYParkingStallRelevantCarModel *model in self.relevantCarArray) {
                    [mArr addObject:model.carNumber];
                }
                self.popView.dataArray = [mArr copy];
                [self.popView showAccessRecordMemberPopView];
            }else {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [self initRelevantStallData];
            }
        }else {
            if (self.relevantStallArray.count > 0) {
                NSMutableArray *mArr = [NSMutableArray array];
                for (ZYParkingStallRelevantStallModel *model in self.relevantStallArray) {
                    [mArr addObject:model.carPositionNumber];
                }
                self.popView.dataArray = [mArr copy];
                [self.popView showAccessRecordMemberPopView];
            }else {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
                [self initRelevantStallData];
            }
        }
    }
}

#pragma mark - 处理提交数据model
- (void)handleSubmitData {
    // ---需要提交数据---
    self.uploadModel.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    self.uploadModel.houseId = self.currentHouseModel.houseId;
    self.uploadModel.groundUpAndDown = self.currentCarAddressModel.type;
    if (self.currentCarAddressModel.type == 0) {
        self.uploadModel.carNumber = self.currentRelevantCarModel.carNumber;
    }
    self.uploadModel.carPositionId = self.currentRelevantStallModel.ID;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    self.uploadModel.startTime = currentDateStr;
    self.uploadModel.monthNumber = self.monthNum;
    // ---展示数据---
    self.uploadModel.belongHouse = self.currentHouseModel.belongHouse;
    self.uploadModel.siteClassificationName = self.currentStallCategoryModel.siteClassificationName;
    self.uploadModel.carAddressName = self.currentCarAddressModel.name;
    self.uploadModel.carPositionNumber = self.currentRelevantStallModel.carPositionNumber;
    self.uploadModel.startDate = [NSString stringWithFormat:@"%ld年%ld月%ld日", [NSDate date].br_year, [NSDate date].br_month, [NSDate date].br_day];
    NSDate *endDate = [self getCurrentDateWithMonthNum:self.monthNum];
    self.uploadModel.endDate = [NSString stringWithFormat:@"%ld年%ld月%ld日", endDate.br_year, endDate.br_month, endDate.br_day];
    self.uploadModel.monthCardPrice = self.monthCardPrice;
}

// 数据不为空判断
- (BOOL)judgeNoEmptyData {
    if (self.currentHouseModel.houseId.length > 0) {
        if (self.currentStallCategoryModel.ID.length > 0) {
            if (self.currentCarAddressModel.name.length > 0) {
                if (self.currentCarAddressModel.type == 0) {
                    if (self.currentRelevantCarModel.carNumber.length > 0) {
                        [self handleSubmitData];
                        return YES;
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择关联车辆" toView:self.view];
                    }
                }else {
                    if (self.currentRelevantStallModel.carPositionNumber.length > 0) {
                        [self handleSubmitData];
                        return YES;
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择关联车位" toView:self.view];
                    }
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择停车位置" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择场地" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择房屋" toView:self.view];
    }
    
    return NO;
}

// 数据不为空判断(没提示文体)
- (BOOL)judgeNoEmptyDataNoHint {
    if (self.currentHouseModel.houseId.length > 0) {
        if (self.currentStallCategoryModel.ID.length > 0) {
            if (self.currentCarAddressModel.name.length > 0) {
                if (self.currentCarAddressModel.type == 0) {
                    if (self.currentRelevantCarModel.carNumber.length > 0) {
                        [self handleSubmitData];
                        return YES;
                    }
                }else {
                    if (self.currentRelevantStallModel.carPositionNumber.length > 0) {
                        [self handleSubmitData];
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}

#pragma mark - 月份转化后的日期
- (NSDate *)getCurrentDateWithMonthNum:(NSInteger)monthNum {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = nil;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
    [dateComponents setMonth:monthNum];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    return newDate;
}

@end
