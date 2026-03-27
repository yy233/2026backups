//
//  SmallShopOrderDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopOrderDetailVC.h"
#import "BaseOneGoodsTableViewCell.h"
#import "SmallShppOrderData.h"
//
#import "OrderAdviceVC.h"

@interface SmallShopOrderDetailVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSArray *orderTitleArr;
@property (nonatomic,strong) NSArray *boxInfoTitleArr;
@property (nonatomic,strong) NSArray *boxOrderTitleArr;
@property (nonatomic,strong) NSArray *boxInfoContentArr;
@property (nonatomic,strong) NSArray *nomalOrBoxOrderContentArr;

@property (nonatomic,strong) SmallShopOrderDetailModel *detailModel;

@end

@implementation SmallShopOrderDetailVC
- (NSArray *)boxInfoTitleArr{
    if (!_boxInfoTitleArr) {
        _boxInfoTitleArr = @[@"货柜信息",@"货柜编号：",@"货柜大小：",@"租用金额：",@"计费规则："];
    }
    return _boxInfoTitleArr;
}

- (NSArray *)boxInfoContentArr{
    if (!_boxInfoContentArr) {
        _boxInfoContentArr = @[@"",@"",@"",@"",@""];
    }
    return _boxInfoContentArr;
}
- (NSArray *)boxOrderTitleArr{
    if (!_boxOrderTitleArr) {
        _boxOrderTitleArr = @[@"订单信息",@"订单号码：",@"创建时间：",@"租用时长：",@"实际付款："];
    }
    return _boxOrderTitleArr;
}
- (NSArray *)nomalOrBoxOrderContentArr{
    if (!_nomalOrBoxOrderContentArr) {
        _nomalOrBoxOrderContentArr = @[@"",@"",@"",@"",@""];
    }
    return _nomalOrBoxOrderContentArr;
}
- (NSArray *)orderTitleArr{
    if (!_orderTitleArr) {
        _orderTitleArr = @[@"订单信息",@"订单号码：",@"创建时间：",@"实际付款："];
    }
    return _orderTitleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.nowDetailVcShowType = SmallShopOrderDetailVC_Type_Goods;
    [self initView];
    [self addRefresh];
    [self initData];
}

- (void)initView{
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.footerView;
    [self.footerView.footerBtn newAnBtnWithBackColor: [UIColor clearColor]];
 }
#pragma mark ==

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}


- (void)initData{
 
    WEAKSELF
    [SmallShppOrderData getOrderDetailInfoWithThisType:self.nowDetailVcShowType andOrderId:self.thisOrderId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.detailModel = [SmallShopOrderDetailModel mj_objectWithKeyValues:dic];
            if (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container ) {//货柜
                weakSelf.boxInfoContentArr = [[NSMutableArray alloc]initWithObjects:
                                              @"占位",
                                              [TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.cabinetNumber],
                                              [NSString stringWithFormat:@"%ld立方米",weakSelf.detailModel.cabinetSize],
                                              [NSString stringWithFormat:@"%@元",[TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.cabinetPriceSell]] ,
                                              @"暂无规则",
                                              nil];
                weakSelf.nomalOrBoxOrderContentArr = [[NSMutableArray alloc]initWithObjects:
                                               @"占位",
                                               [TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.orderNumber],
                                               [TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.orderTime],
                                               @"时间暂无",
                                               [NSString stringWithFormat:@"%@元",[TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.orderPayMoney]] ,
                                               nil];
            }else{
                
                weakSelf.nomalOrBoxOrderContentArr = [[NSMutableArray alloc]initWithObjects:
                                               @"占位",
                                               [TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.value1.orderNumber],
                                                [TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.value1.orderTime],
                                               [NSString stringWithFormat:@"%@元",[TextShowWithModelStr textShowWithModelStr:weakSelf.detailModel.value1.orderPayMoney]] ,
                                               nil];
            }
          
 
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
           
        }
    }];
    
 
    
     
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container ?  3 : 2 );
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    
    if (section == [tableView numberOfSections]-1 ) {//订单信息
        if (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container ) {
            return 5;
        }else{
            return 4;
        }
    
    }else{
        if ( self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container) {//货柜
            switch (section) {
                case 1:
                    return 4;//货柜信息去掉计费计费规则
                    break;
                default:
                    return 1;
                    break;
            }
        }else if (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Service){//服务
            return 1;
        }else{//商品
            return self.detailModel.value0.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  (section==0 ? 1 : 10);//有20headerv
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 106;
    }else{
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 33;
        }
    }
    return 0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if  (indexPath.section == 0){
        if ( self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container) {//货柜
            BaseOneBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseOneBoxTableViewCell_I ];
            if (!cell) {
                cell = [[BaseOneBoxTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseOneBoxTableViewCell_I];
            }
            [cell fillOrderDetailModel:self.detailModel];
            return cell;
        }else if (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Service){//服务
            BaseOneServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseOneServiceTableViewCell_I ];
            if (!cell) {
                cell = [[BaseOneServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseOneServiceTableViewCell_I];
            }
            [cell fillOrderDetailModel:self.detailModel];
            return cell;
        }else{
            
            BaseOneGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseOneGoodsTableViewCell_I ];
            if (!cell) {
                cell = [[BaseOneGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BaseOneGoodsTableViewCell_I];
            }
            [cell fillOrderDetailModelSubOneGoodsModel:self.detailModel.value0[indexPath.row]];
            return cell;
            
        }

    }else{//货柜信息|订单信息
        //title row0
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell" ];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"topCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.indentationLevel =  1;  //缩进层级
                cell.indentationWidth = 10;//每次缩进寛
                cell.textLabel.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
            if (indexPath.section == [tableView numberOfSections]-1 ) {//订单信息
                cell.textLabel.text = [NSString stringWithFormat:@"%@",self.orderTitleArr[indexPath.row]];
            }else{//货柜信息
                cell.textLabel.text = [NSString stringWithFormat:@"%@",self.boxInfoTitleArr[indexPath.row]];
            }
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nomalCell" ];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nomalCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.indentationLevel =  1;  //缩进层级
                cell.indentationWidth = 10;//每次缩进寛
                cell.textLabel.textColor = Y_ColorWith16FromRGB(0x6E727D);
                cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            }
            
            if (indexPath.section == [tableView numberOfSections]-1 ) {//订单信息
                if (self.nowDetailVcShowType == SmallShopOrderDetailVC_Type_Container ) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.boxOrderTitleArr[indexPath.row],self.nomalOrBoxOrderContentArr[indexPath.row]];

                }else{
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.orderTitleArr[indexPath.row], self.nomalOrBoxOrderContentArr[indexPath.row]];

                }
            }else{//货柜信息
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.boxInfoTitleArr[indexPath.row],self.boxInfoContentArr[indexPath.row]];

            }
            return cell;
        }
        
    }
    
}
 
#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [UIColor whiteColor];
    UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
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
            CALayer *lineLayer = [[CALayer alloc] init];// CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);//过小
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-1.0, bounds.size.width-20, 1.0);
            
            //2种都可
            lineLayer.backgroundColor = separatoColor.CGColor;
            if (indexPath.section == 0  &&  (indexPath.row != ([tableView numberOfRowsInSection:0]-1) ) ) {// 商品section 底下才显示 其余不显示
                [layer addSublayer:lineLayer];// 商品section 底下才显示 其余不显示
            }else{
            }
            /**
          
            [layer addSublayer:lineLayer];
            if (indexPath.section == 0  &&  (indexPath.row != ([tableView numberOfRowsInSection:0]-1) ) ) {// 商品section 底下才显示 其余不显示
                lineLayer.backgroundColor = separatoColor.CGColor;
            }else{
                lineLayer.backgroundColor = [UIColor clearColor].CGColor;
            }
             */
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

#pragma mark ==

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, 70, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"投诉建议"];
        [_footerView.footerBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x6E727D)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerBtnAction{
    DLog(@"投诉建议");
    OrderAdviceVC *vc = [[OrderAdviceVC alloc]init];
    vc.orderListUseModel = self.listModel;
    [self pushVc:vc];
}
@end
