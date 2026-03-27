//
//  EIntergralMallOrderDetailVC.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "EIntergralMallOrderDetailVC.h"

#import "EIntergralMallOrderDetailVcTableViewCell.h"
#define  EIntergralMallOrderDetailVcTableViewCell_Identifier     @"EIntergralMallOrderDetailVcTableViewCell"
@interface EIntergralMallOrderDetailVC ()
@property (nonatomic,strong) NSMutableArray *contentArr;
@end

@implementation EIntergralMallOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self initView];
    [self initData];
}
- (void)initView{
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}
- (void)initData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"订单号",@"支付方式",@"下单时间", nil];
    self.contentArr = [NSMutableArray arrayWithObjects:@"5023 3542 8640 4564 3",@"E币",@"2020-10-20 10:26", nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return 4;
    }
    return 0;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 190;
    }else{
        if (indexPath.row==0) {
            return 45;
        }else{
            return 40;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        EIntergralMallOrderDetailVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EIntergralMallOrderDetailVcTableViewCell_Identifier];
        if (!cell) {
            cell = [[EIntergralMallOrderDetailVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EIntergralMallOrderDetailVcTableViewCell_Identifier];
        }
        cell.orderNumL.text = @"E币商城";
        cell.goodsNameL.text = @"Beats头戴试耳机抽奖";
        cell.goodsNumL.text = @"x1";
        cell.eNumL.attributedText  =  [self getEnumLTextWithStr:@"200 E币"];
        cell.imgV.image = [UIImage imageNamed:@"Ecoin_Product_one"];
        //
        cell.topRightL.text = @"4天后过期";
        cell.centerENumL.text = @"200E币";
         return cell;
    }else{
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Top"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Top"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
            }
            cell.textLabel.font = FontSize_MoneyWallet_Bold(15);
            cell.textLabel.text = @"订单信息";
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Center"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Content"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
                cell.accessoryView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//占位
            }
            cell.textLabel.font = FontSize_MoneyWallet_Nomail(13);
            cell.detailTextLabel.font = FontSize_MoneyWallet_Nomail(13);
            cell.textLabel.textColor = Color_153GrayColor;
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = self.dataSourceArr[indexPath.row-1];
            cell.detailTextLabel.text = self.contentArr[indexPath.row-1];
            return cell;
        }
       
    }
  
}
#pragma mark ==
- (NSMutableAttributedString *)getEnumLTextWithStr:(NSString *)str{
  
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSUInteger length = [str length];
    //设置字体
    UIFont *baseFont =  FontSize_MoneyWallet_Nomail(14);// FontSize_MoneyWallet_Bold(15);
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
    // 设置颜色
    UIColor *colorRed = COlor_Red255;
    UIColor *colorGray =  [UIColor blackColor];//Color_138GrayColor;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorRed
                       range:[str rangeOfString:@"200"]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"E币"]];
    return attrString;
}
 

#pragma mark === 列表组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {//第2组才有组圆色
        return;
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.0f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            } else  if (indexPath.row==0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }else{
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色修改
            layer.fillColor = [UIColor whiteColor].CGColor;
            layer.strokeColor = [UIColor whiteColor].CGColor;
            if (addLine == YES && (indexPath.row==0 || (indexPath.row==1))) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;//线
//                lineLayer.backgroundColor = COlor_Red255.CGColor;//线
                [layer addSublayer:lineLayer];
            }else{
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = [UIColor whiteColor].CGColor;//线
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
 
@end
