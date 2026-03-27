//
//  BillingDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingDetailVC.h"
#import "BillingDetailHeaderView.h"
#import "BillingDetailVcTableViewCell.h"
#import "BillingListSubOneInfoDetailModel.h"

static NSString *k_wyfImg = @"sq_wyjf";//物业缴费
static NSString *k_tingcarImg = @"sq_lstc";//临时停车
static NSString *k_yuezuImg = @"sq_yzjf";//月租缴费

static NSString *url_detail_Info = @"zhsj/base/api/trade/getTrade/";//详情url


@interface BillingDetailVC ()
@property (nonatomic,strong) BillingDetailHeaderView *headerView;

@property (nonatomic,strong) NSMutableArray *titleArrOneSection;
@property (nonatomic,strong) NSMutableArray *titleArrTwoSection;
@property (nonatomic,strong) NSMutableArray *contentArrOneSection;
@property (nonatomic,strong) NSMutableArray *contentArrTwoSection;
@end

@implementation BillingDetailVC

- (BillingDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[BillingDetailHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付助手";
    [self initView];
    [self initDetailData];
}
- (void)initView{
    [self changeNavBackColorWithDDndWIsGW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;//重蓝非白
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorColor = [UIColor clearColor];
}
- (void)initDetailData{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,url_detail_Info,self.idStr];
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                BillingListSubOneInfoDetailModel *detailModel = [BillingListSubOneInfoDetailModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                NSString *tradeStateStr = [TextShowWithModelStr textShowWithModelStr:detailModel.tradeStateStr];
                NSString *subName = [TextShowWithModelStr textShowWithModelStr:detailModel.subName];
                NSString *merchantName = [TextShowWithModelStr textShowWithModelStr:detailModel.merchantName];
                NSString *payTime = [TextShowWithModelStr textShowWithModelStr:detailModel.payTime];
                NSString *sysOrderNo = [TextShowWithModelStr textShowWithModelStr:detailModel.sysOrderNo];
                NSString *thirdOrderNo = [TextShowWithModelStr textShowWithModelStr:detailModel.thirdOrderNo];
                
                weakSelf.titleArrOneSection = [NSMutableArray arrayWithObjects:@"支付状态",@"商品名称",@"商家名称",@"交易时间",@"交易单号",@"商户单号", nil];
                weakSelf.contentArrOneSection =  [NSMutableArray arrayWithObjects:tradeStateStr,subName,merchantName,payTime,sysOrderNo,thirdOrderNo, nil];
    
                //headerV
                [weakSelf.headerView.imgV sd_setImageWithURL:[UrlWithString getURLWithStr: detailModel.subHeadImgUrl] placeholderImage:Main_PlaceholderImg_WeqH];
                weakSelf.headerView.typeL.text = [TextShowWithModelStr textShowWithModelStr:detailModel.subName];
                weakSelf.headerView.moneyL.text = [NSString stringWithFormat:@"¥%0.2f",detailModel.amount];
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
    
    /**
     isTuiKuanBool = yes;
     
     if (isTuiKuanBool == yes) {//两组的 退款数据
         self.titleArrOneSection = [NSMutableArray arrayWithObjects:@"退款记录",@"退款时间",@"退款方式",@"退款单号", nil];
         self.contentArrOneSection = [NSMutableArray arrayWithObjects:@"退款记录11",@"退款时间11",@"退款方式11",@"退款单号11", nil];
         self.titleArrTwoSection = [NSMutableArray arrayWithObjects:@"商品名称",@"商家名称",@"交易时间",@"交易单号",@"商户单号", nil];
         self.contentArrTwoSection = [NSMutableArray arrayWithObjects:@"商品名称22",@"商家名称22",@"交易时间22",@"交易单号22",@"商户单号22", nil];
         
     }else{
         self.titleArrOneSection = [NSMutableArray arrayWithObjects:@"支付状态",@"商品名称",@"商家名称",@"交易时间",@"交易单号",@"商户单号", nil];
         self.contentArrOneSection =  [NSMutableArray arrayWithObjects:@"支付状态a",@"商品名称a",@"商家名称a",@"交易时间a",@"交易单号a",@"商户单号a", nil];
     }
*/
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isTuiKuanBool == YES) {//退款状态
        return 2;
    }else{//非退款状态
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArrOneSection.count;
    }else{
        return self.titleArrTwoSection.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillingDetailVcTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:BillingDetailVcTableViewCell_I];
    if (!cell) {
        cell = [[BillingDetailVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BillingDetailVcTableViewCell_I];
    }
    if (indexPath.section == 0) {
        cell.titleL.text = self.titleArrOneSection[indexPath.row];
        cell.detailL.text = self.contentArrOneSection[indexPath.row];
    }else{
        cell.titleL.text = self.titleArrTwoSection[indexPath.row];
        cell.detailL.text = self.contentArrTwoSection[indexPath.row];
    }
     return cell;
    
}
 

#pragma mark ==
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 10.0f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    UIColor *separatoColor =  [ThemeManager shareManager].themeLineColor;
//    UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
     if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
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
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
         
         
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-0.5, bounds.size.width-10*2, 0.5);//h_0.5
            [layer addSublayer:lineLayer];
            lineLayer.backgroundColor = separatoColor.CGColor;
           
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

#pragma mark ===

- (NSMutableArray *)titleArrOneSection{
    if (!_titleArrOneSection) {
        _titleArrOneSection = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _titleArrOneSection;
}
- (NSMutableArray *)titleArrTwoSection{
    if (!_titleArrTwoSection) {
        _titleArrTwoSection = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _titleArrTwoSection;
}
- (NSMutableArray *)contentArrOneSection{
    if (!_contentArrOneSection) {
        _contentArrOneSection = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _contentArrOneSection;
}
- (NSMutableArray *)contentArrTwoSection{
    if (!_contentArrTwoSection) {
        _contentArrTwoSection = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _contentArrTwoSection;
}

@end
