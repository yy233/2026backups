//
//  EIntergralMallMingXiListVC.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "EIntergralMallMingXiListVC.h"
#import "EIntergralMallMingXiListHeaderView.h"
#define  Color_NavBack          Y_ColorWith16FromRGB(0x25283B)
#define  Color_Orange_Text      Y_ColorWith16FromRGB(0xFF6600)
#define  Color_Green_Text       Y_ColorWith16FromRGB(0x38C218)
#import "EIntergralMallMingXiListVcTableViewCell.h"
#define  EIntergralMallMingXiListVcTableViewCell_Identifier    @"EIntergralMallMingXiListVcTableViewCell"

@interface EIntergralMallMingXiListVC ()
@property (nonatomic,strong) EIntergralMallMingXiListHeaderView *headerView;
@property (nonatomic,strong)  NSMutableArray *monthStrArr;
@end

@implementation EIntergralMallMingXiListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"E币明细";
    [self initView];
    [self initData];
}
- (void)addNavRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:Color_238GrayColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"E币规则" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor:Color_NavBack];
}
- (void)initView{
    [self addNavRightBtn];
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headerView;
}
- (void)initData{
    self.headerView.eNumL.text = @"30";
    //
    self.monthStrArr = [NSMutableArray arrayWithObjects:@"1月",@"2020年12月",nil];
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"成功支付订单",@"积分过期",@"积分过期",@"成功支付订单",@"成功支付订单", nil];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)rightBtnAction{
    Y_SVP_SHOW_INFO_MES(@"E币规则");
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.monthStrArr.count;//月份数量
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return  self.dataSourceArr.count+1;//当月数量
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 10;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_T"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_T"];
            cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
            cell.accessoryView =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightSkip_white"]];//占位
        }
        cell.textLabel.text = self.monthStrArr[indexPath.section];
        cell.detailTextLabel.attributedText = [self getEnumLTextWithStr:@"获得:81 支出:120"];
        return cell;
    }else{
        EIntergralMallMingXiListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EIntergralMallMingXiListVcTableViewCell_Identifier];
        if (!cell) {
            cell = [[EIntergralMallMingXiListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EIntergralMallMingXiListVcTableViewCell_Identifier];
        }
        if (indexPath.row==2 || indexPath.row==3) {
            [cell fillCellWithTypeIsZhiChu:YES withTittleStr:self.dataSourceArr[indexPath.row-1] withTimeStr:@"2021-01-17 14：36：15" withNumStr:@"-100"];
        }else{
            [cell fillCellWithTypeIsZhiChu:NO withTittleStr:self.dataSourceArr[indexPath.row-1] withTimeStr:@"2021-01-17 14：36：15" withNumStr:@"+4"];
        }
        return cell;
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
    UIColor *colorGray = Color_138GrayColor;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:Color_Orange_Text
                       range:[str rangeOfString:@"81"]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:Color_Green_Text
                       range:[str rangeOfString:@"120"]];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"获得:"]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"支出:"]];
    return attrString;
}
 
#pragma mark === 列表组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
            layer.strokeColor= [UIColor whiteColor].CGColor;
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;//线
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

#pragma mark ==
- (EIntergralMallMingXiListHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[EIntergralMallMingXiListHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}
#pragma mark ==
- (NSMutableArray *)monthStrArr{
    if (!_monthStrArr) {
        _monthStrArr = [[NSMutableArray alloc]init];
    }
    return _monthStrArr;
}

@end
