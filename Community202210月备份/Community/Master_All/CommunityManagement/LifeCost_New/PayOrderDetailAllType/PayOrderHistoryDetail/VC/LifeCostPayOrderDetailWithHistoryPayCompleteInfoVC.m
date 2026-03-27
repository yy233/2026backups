//
//  PayOrderDetailWIthHistoryPayCompleteInfo.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC.h"
#import "PayOrderDetailAllTypeHeader.h"
#define  H_TopV                      (165)
#define  H_MainHeaderV               (35)
#define  H_Cell                      (33)
#define  H_FooterV_OneSectionNum     (18)
#define  H_FooterV_TwoSectionNum     (6)

#define  Color_TableViewCellBg       Y_RGB(24, 56, 118)

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView.h"
#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView.h"
#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView.h"
#import "LifeCostPayOrderDetailModel.h"

@interface LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView *topView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView *mainHeaderView;
@property (nonatomic,strong) NSMutableArray *oneSectionTitleArr;
@property (nonatomic,strong) NSMutableArray *twoSectionTitleArr;
@property (nonatomic,strong) NSMutableArray *onwSectionDataArr;


@end

@implementation LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC
- (NSMutableArray *)oneSectionTitleArr{
    if (!_oneSectionTitleArr) {
        _oneSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费状态" ,@"户号/户名" ,@"缴费单位" ,@"交易时间" ,@"订单号" , nil];
    }
    return _oneSectionTitleArr;
}
- (NSMutableArray *)twoSectionTitleArr{
    if (!_twoSectionTitleArr) {
        _twoSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"此户号的缴费记录" ,@"缴费凭证" ,@"常见问题" , @"",@"", nil];//两行占位
    }
    return _twoSectionTitleArr;
}
- (NSMutableArray *)onwSectionDataArr{
    if (!_onwSectionDataArr) {
        _onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:@"" ,@"",@"" ,@"" ,@"" , nil];
    }
    return _onwSectionDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费详情";
    [self initView];
    [self initData];
}
- (void)initData{
    //列表有图 详情没URL 两种数据都使用上
    [self.topView fillTopViewDataWithImgUrlStr:[TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.typePicUrl]  withMoneyNumStr:[TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.payAmount]];
    NSString *typeS = [self dealWithOrderStatus:self.oneOrderModel.orderStatus];//@"缴费状态"
    NSString *accountS = [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.account];
    NSString *householderS = [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.householder];
    NSString *compNmae = [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.customerName];
    NSString *uptime = [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.updateTime];
    NSString *timeS = uptime.length > 0 ? uptime : [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.createTime];
    NSString *orderIdS = [TextShowWithModelStr textShowWithModelStr:self.oneOrderModel.billId];
    NSString *accountSAndhouseholderS = [NSString stringWithFormat:@"%@ | %@",accountS,householderS];
    self.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects: typeS, accountSAndhouseholderS, compNmae,timeS,orderIdS,nil];
    [self.tableView reloadData];
    WEAKSELF
    NSString *idStr = [NSString stringWithFormat:@"%ld",self.oneOrderModel.ID];
    [LifeCostData lifeCostGetPayHistoryOrderDetailWithIdStr:idStr withBlock:^(NSDictionary *  dic, BOOL succes) {
        if (succes) {
            DLog(@"");
            LifeCostPayOrderDetailModel *model = [LifeCostPayOrderDetailModel mj_objectWithKeyValues:dic];
            NSString *typeS = [TextShowWithModelStr textShowWithModelStr:model.orderStatusName];//详情缴费状态文本字段
            weakSelf.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects: typeS, accountSAndhouseholderS, compNmae,timeS,orderIdS,nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];

  
}
- (NSString *)dealWithOrderStatus:(NSInteger)orderStatus{
    
    NSString *orderStatusMessage = @"未知状态";
    switch (orderStatus) {
        case 0:
            orderStatusMessage = @"当前订单未支付。";
            break;
        case 1:
        {
            orderStatusMessage = @"当前订单 支付成功。";
        }
            break;
        case 2:
            orderStatusMessage = @"当前订单 支付失败。";
            break;
        case 3:
            orderStatusMessage = @"销账成功。";
            break;
        case 4:
            orderStatusMessage = @"销账失败。";
            break;
        case 5:
            orderStatusMessage = @"未知状态";
            break;
        case 8:
            orderStatusMessage = @"当前订单 已实时退款";
            break;
        default:
            break;
    }
    return orderStatusMessage;
}
#pragma mark ==
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ThemeManager shareManager].type == ThemeType_White) {
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Nav_BrightBlueColor];
    }else{
        [self changeNavBackColorWithDIsCountBlueAndGW];
    }
}
- (void)initView{
    self.view.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.mainHeaderView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUI];
}
- (void)setUI{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(H_TopV);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.superview).offset(10);
        make.right.equalTo(_tableView.superview).offset(-10);
        make.top.equalTo(_topView.mas_bottom).offset(-45);
        make.bottom.equalTo(_tableView.superview);
    }];
}
#pragma mark ==
- (LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView *)topView{
    if (!_topView) {
        _topView = [[LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_TopV)];
    }
    return _topView;
}
- (LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView *)mainHeaderView{
    if (!_mainHeaderView) {
        _mainHeaderView = [[LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-20.0, H_MainHeaderV)];
    }
    return _mainHeaderView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section!=0) {
        DLog(@"%@",self.twoSectionTitleArr[indexPath.row]);
    }
    if (indexPath.section==1) {
        Y_SVP_SHOW_INFO_MES(@"暂无数据。");
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.oneSectionTitleArr.count;
    }else{
        return self.twoSectionTitleArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H_Cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView *footerv = [[LifeCostPayOrderDetailWithHistoryPayCompleteInfoSectionFooterImgView alloc]init];
    if (section == 0) {
        [footerv fillDataWithSectionOneBool:YES];
    }else{
        [footerv fillDataWithSectionOneBool:NO];
    }
    return footerv;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return H_FooterV_OneSectionNum;
    }else{
        return H_FooterV_TwoSectionNum;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderSubTextCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderSubTextCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    if (indexPath.section==0) {
        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.textLabel.text = self.oneSectionTitleArr[indexPath.row];
        cell.detailTextLabel.text = self.onwSectionDataArr[indexPath.row];
        cell.accessoryView = [UIView new];
    }else{
        cell.textLabel.textColor =  [ThemeManager shareManager].mainTextColor;
        cell.textLabel.text = self.twoSectionTitleArr[indexPath.row];
        cell.detailTextLabel.text = @"";
        //箭头
        if ( cell.textLabel.text.length > 0) {
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
            cell.accessoryView = accessoryImgView;
        }else{
            cell.accessoryView = [UIView new];
        }
      
    }

    return cell;
}
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *cellBackGroundFillColor = nil;
    if ([ThemeManager shareManager].type == ThemeType_White) {
        cellBackGroundFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }else{
        cellBackGroundFillColor = Color_TableViewCellBg;
    }
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 0.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 6.5, 0);//外距离,headerview 和 footerimg匹配6 6.5
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = cellBackGroundFillColor.CGColor;
        layer.strokeColor= cellBackGroundFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


@end
