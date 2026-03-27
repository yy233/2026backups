//
//  ZYParkingMonthCardRenewalVc.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingMonthCardRenewalVc.h"
#import "ZYParkingMonthCardPayDetailVc.h"
#import "ZYParkingMonthCardRenewalCell.h"
#import "ZYParkingMonthCardRenewalEditCell.h"
#import "ZYParkingMonthCardRenewalFooterView.h"
#import "ZYParkingMonthCardPayBottomView.h"
#import "ZYParkingMonthCardUploadModel.h"

static NSString * const ZYParkingMonthCardRenewalCellID = @"ZYParkingMonthCardRenewalCell";
static NSString * const ZYParkingMonthCardRenewalEditCellID = @"ZYParkingMonthCardRenewalEditCell";
#define kZYParkingMonthCardRenewalCellHeight 50
#define kZYParkingMonthCardRenewalFooterViewHeight 100
#define kZYParkingMonthCardPayBottomViewHeight 55+button_bottom_height

@interface ZYParkingMonthCardRenewalVc () <UITableViewDataSource, UITableViewDelegate, ZYParkingMonthCardPayBottomViewDelegate, ZYParkingMonthCardRenewalEditCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYParkingMonthCardRenewalFooterView *footerView;

@property (nonatomic, strong) ZYParkingMonthCardPayBottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger monthNum;

@property (nonatomic, strong) ZYParkingMonthCardUploadModel *uploadModel;

// 月租卡价格
@property (nonatomic, copy) NSString *monthCardPrice;

@end

@implementation ZYParkingMonthCardRenewalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@-车位续期", [ShareUserInfo sharedUserInfo].commuityInfo.name];
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
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
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
    NSString *relevantTitle;
    NSString *relevantContent;
    if (self.model.groundUpAndDown == 0) {
        relevantTitle = @"车  牌  号";
        relevantContent = self.model.carNumber;
    }else {
        relevantTitle = @"车  位  号";
        relevantContent = self.model.carPositionNumber;
    }
    NSArray *titlesArray = @[@"选择场地", relevantTitle, @"续期时长", @"有效期至"];
    NSDate *currentDate = [self getCurrentDateWithMonthNum:1];
    NSString *currentDateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日", currentDate.br_year, currentDate.br_month, currentDate.br_day];
    NSArray *contentsArray = @[self.model.siteClassificationName, relevantContent, @"", currentDateStr];
    for (int i = 0; i < titlesArray.count; i++) {
        ZYParkingMonthCardRenewalModel *model = [[ZYParkingMonthCardRenewalModel alloc] init];
        model.title = titlesArray[i];
        model.content = contentsArray[i];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMonthCardPriceData];
    [self initMaxMonthNumData];
    [self initExpireTimeData];
}

// 加载月租卡价格数据
- (void)initMonthCardPriceData {
    NSDictionary *params = @{@"carPositionId" : self.model.carPositionId};
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
                    ZYParkingMonthCardRenewalEditCell *cell = (ZYParkingMonthCardRenewalEditCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
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

// 加载续约月租到期时间数据
- (void)initExpireTimeData {
    NSDictionary *params = @{@"months" : @(self.monthNum), @"carPositionId" : self.model.carPositionId};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:Y_BASEURL(kParkingMonthCardRenewalExpireTimeUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
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
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardRenewalCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardRenewalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingMonthCardRenewalEditCellID bundle:nil] forCellReuseIdentifier:ZYParkingMonthCardRenewalEditCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        ZYParkingMonthCardRenewalEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalEditCellID forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }else {
        ZYParkingMonthCardRenewalCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingMonthCardRenewalCellID forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        if (indexPath.row == self.dataArray.count - 1) {
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYParkingMonthCardRenewalCellHeight;
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
// 立即支付
- (void)payButtonEvent {
    NSLog(@"立即支付");
    ZYParkingMonthCardPayDetailVc *vc = [[ZYParkingMonthCardPayDetailVc alloc] init];
    vc.type = ZYParking_MonthCard_Type_Renewal;
    [self handleSubmitData];
    vc.uploadModel = self.uploadModel;
    [self pushVc:vc];
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

#pragma mark - 处理提交数据model
- (void)handleSubmitData {
    // ---需要提交数据---
    self.uploadModel.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
    self.uploadModel.groundUpAndDown = self.model.groundUpAndDown;
    self.uploadModel.carPositionId = self.model.carPositionId;
    self.uploadModel.carNumber = self.model.carNumber;
    self.uploadModel.startTime = self.model.stopTime;
    self.uploadModel.monthNumber = self.monthNum;
    // ---展示数据---
    self.uploadModel.belongHouse = self.model.belongHouse;
    self.uploadModel.siteClassificationName = self.model.siteClassificationName;
    self.uploadModel.carAddressName = self.model.groundUpAndDownName;
    self.uploadModel.carPositionNumber = self.model.carPositionNumber;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:self.model.stopTime];
    self.uploadModel.startDate = [NSString stringWithFormat:@"%ld年%ld月%ld日", startDate.br_year, startDate.br_month, startDate.br_day];
    NSDate *endDate = [self getCurrentDateWithMonthNum:self.monthNum];
    self.uploadModel.endDate = [NSString stringWithFormat:@"%ld年%ld月%ld日", endDate.br_year, endDate.br_month, endDate.br_day];
    self.uploadModel.monthCardPrice = self.monthCardPrice;
}

#pragma mark - 月份转化后的日期
- (NSDate *)getCurrentDateWithMonthNum:(NSInteger)monthNum {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [dateFormatter dateFromString:self.model.stopTime];
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
