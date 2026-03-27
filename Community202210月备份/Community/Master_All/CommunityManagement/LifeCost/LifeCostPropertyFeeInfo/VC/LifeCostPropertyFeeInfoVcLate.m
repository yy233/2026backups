//
//  LifeCostPropertyFeeInfoVcLate.m
//  Community
//
//  Created by 余莹 on 2021/10/7.
//

#import "LifeCostPropertyFeeInfoVcLate.h"

#import "LifeCostPropertyFeeInfoModel.h"
#import "LifeCostPropertyFeeListVcNomalWuYeTableViewCell.h"
#define  LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier          @"LifeCostPropertyFeeListVcNomalWuYeTableViewCell"


typedef enum : NSUInteger {
    ThisOneSection_Row_Num_Address=0,
    ThisOneSection_Row_Num_OrderNum,
    ThisOneSection_Row_Num_TypeAndMoney,//类型和原始金额
    ThisOneSection_Row_Num_PenalSumMoeny, //滞纳金  penalSum：滞纳金
    ThisOneSection_Row_Num_CouponMoeny,//折扣      coupon:优惠金额
    ThisOneSection_Row_Num_TotalMoney,//总计
} ThisOneSection_Row_Num;

@interface LifeCostPropertyFeeInfoVcLate ()  <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView; 
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *contentArr;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

@implementation LifeCostPropertyFeeInfoVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"缴费详情";
    [self initView];
    [self initData];
    [self addRefresh];
}

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    WEAKSELF
    
    /** 10.07 改
     orderStatus
     0表示未缴  那么就id就传数据id，
     1表示已缴那么id就传tripartiteOrder三方单号
     */
    NSString *urlStr = @"proprietor/FinanceOrder/findOne";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    if (self.isDidPay) {
        [parms setValue:@(1) forKey:@"orderStatus"];//1表示已缴那么id
        [parms setValue:self.idStr forKey:@"id"];//就传tripartiteOrder三方单号
    }else{
        [parms setValue:@(0) forKey:@"orderStatus"];//未交0待交
        [parms setValue:self.idStr forKey:@"id"];//物业账单id
    }
    
    
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                weakSelf.dataSourceArr = [LifeCostPropertyFeeInfoModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

- (void)initView{
    [self.view addSubview:self.tableView];
    WEAKSELF
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(10);
        make.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(-20);
    }];
}
#pragma mark ==
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
       //第一位为地址占位
        _titleArr = [NSMutableArray arrayWithObjects:@"",@"账单编号",@"单价",@"滞纳金",@"折扣",@"合计",nil];//20220420改

    }
    return _titleArr;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];//第一位为时间占位
    }
    return _contentArr;
}
 
#pragma mark ==

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_FeeDetail"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_FeeDetail"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
//            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
            
            cell.indentationLevel =  1;  //缩进层级
            cell.indentationWidth = 16;//每次缩进寛
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
           
            //右边内缩 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 换成view
            UIImage *zeroImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor] width:10 height:10];
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:zeroImg];
            cell.accessoryView = accessoryImgView;
   
     
        }
 
    LifeCostPropertyFeeInfoModel *model = self.dataSourceArr[indexPath.section];
    NSString *orderNumS = [TextShowWithModelStr textShowWithModelStr:model.orderNum];
    NSString *propertyFeeS = [NSString stringWithFormat:@"¥%0.2f",model.propertyFee];//原始金额
    NSString *penalSumS = [NSString stringWithFormat:@"¥%0.2f",model.penalSum];//滞纳金
    NSString *couponMoeny = [NSString stringWithFormat:@"¥%0.2f",model.coupon];//折扣 优惠金额
    NSString *totalMoneyS = [NSString stringWithFormat:@"¥%0.2f",model.totalMoney];
    
    NSMutableArray *contArr = [[NSMutableArray  alloc]initWithObjects:@"",orderNumS,propertyFeeS,penalSumS,couponMoeny,totalMoneyS, nil];//地址日期占位0r
    if (indexPath.row == ThisOneSection_Row_Num_Address) {
        cell.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.address];
        cell.detailTextLabel.text = [ToolOfTimeChangeFormat timeGetZNFormatWithLineTimeStr:[TextShowWithModelStr textShowWithModelStr:model.beginTime]];//20220420 改成开始时间做成年月展示数据

    }else if(indexPath.row == ThisOneSection_Row_Num_TypeAndMoney ){//费用名称
        cell.textLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.feeRuleName];
        cell.detailTextLabel.text = contArr[indexPath.row];
    }else{
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.detailTextLabel.text = contArr[indexPath.row];
    }
    return cell;
  
}

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];//分割线颜色
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            separatoColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.01];//分割线颜色
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
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = separatoColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

@end
