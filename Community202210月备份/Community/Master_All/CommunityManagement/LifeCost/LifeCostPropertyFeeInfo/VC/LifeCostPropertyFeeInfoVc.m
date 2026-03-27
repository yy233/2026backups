//
//  LifeCostPropertyFeeInfoVc.m
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import "LifeCostPropertyFeeInfoVc.h"
#import "LifeCostPropertyFeeInfoVcTopView.h"
#import "LifeCostPropertyFeeInfoModel.h"
#import "LifeCostPropertyFeeListVcNomalWuYeTableViewCell.h"
#define  LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier          @"LifeCostPropertyFeeListVcNomalWuYeTableViewCell"

@interface LifeCostPropertyFeeInfoVc () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LifeCostPropertyFeeInfoVcTopView *topView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

@implementation LifeCostPropertyFeeInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费详情";
    [self initView];
    [self initData];
    
}
- (void)initData{
    WEAKSELF
    
//    NSString *urlStr = [NSString stringWithFormat:@"proprietor/FinanceOrder/findOne?id=%@",self.orderIdStr];
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
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                /**
                 {
             address = "1栋1单元1612";  ❤️
             associatedType = 1;
             beginTime = "2021-07-01";
             buildType = 1;
             communityId = 1;
             coupon = 0;
             createTime = "2021-09-25 14:10:11";
             deduction = 0;
             deleted = 0;
             feeRuleId = 105015179049308160;
             feeRuleName = "高层物业服务费";
             hide = 1;
             id = 105048403548966914;
             idStr = 105048403548966914;
             orderNum = 0001163255021178979;
             orderStatus = 1;
             orderTime = "2021-08-25";
             overTime = "2021-07-31";
             payTime = "2021-09-30 10:48:36";
             payType = 2;
             penalSum = 124000;
             propertyFee = 15500;
             rise = "帆软社区-高层物业服务费";
             statementStatus = 0;
             targetId = 87343605911523330;
             totalMoney = 139500;
             type = 2;
             uid = test123;
             updateTime = "2021-09-30 08:33:39";
         }*/
//                LifeCostPropertyFeeInfoModel *model = [LifeCostPropertyFeeInfoModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
//                NSString *orderNumS = [TextShowWithModelStr textShowWithModelStr:model.entity.orderNum];
//                NSString *propertyFeeS = [NSString stringWithFormat:@"%0.2f",model.entity.propertyFee];
//                NSString *penalSumS = [NSString stringWithFormat:@"%0.2f",model.entity.penalSum];
//                NSString *totalMoneyS = [NSString stringWithFormat:@"¥:%0.2f",model.entity.totalMoney];
//                weakSelf.dataSourceArr = [NSMutableArray arrayWithObjects:orderNumS,propertyFeeS,penalSumS,totalMoneyS,nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakSelf.topView.addressLabel.text = [TextShowWithModelStr textShowWithModelStr: model.roomName];
//                    weakSelf.topView.timeLabel.text = [TextShowWithModelStr textShowWithModelStr:model.entity.orderTime];
//                    [weakSelf.tableView reloadData];
//                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 
- (void)initView{
//    [self.view addSubview:self.topView];//不用topV的地址时间
    [self.view addSubview:self.tableView];
    WEAKSELF
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(-20);
    }];
}
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"账单编号",@"单价",@"滞纳金",@"折扣",@"合计",nil];//20220420改
    }
    return _titleArr;
}
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
        //    weakSelf.dataSourceArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    }
    return _dataSourceArr;
}
#pragma  mark ==
- (LifeCostPropertyFeeInfoVcTopView *)topView{
    if (!_topView) {
        _topView = [[LifeCostPropertyFeeInfoVcTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 55)];
    }
    return _topView;
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        LifeCostPropertyFeeListVcNomalWuYeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPropertyFeeListVcNomalWuYeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier];
        }
        cell.detailTextLabel.text = @"";
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    
        cell.indentationLevel =  1;  //缩进层级=
        cell.indentationWidth = 16;//每次缩进寛
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        if (_dataSourceArr.count>0) {
            cell.textLabel.text = self.titleArr[indexPath.row-1];
            cell.detailTextLabel.text = self.dataSourceArr[indexPath.row-1];
        }
        return cell;
    }
    
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
