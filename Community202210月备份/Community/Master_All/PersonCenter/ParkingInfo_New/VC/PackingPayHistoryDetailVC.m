//
//  PackingPayHistoryDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "PackingPayHistoryDetailVC.h"

@interface PackingPayHistoryDetailVC ()
@property (nonatomic,strong) NSMutableArray *titleArrOneSection;
@property (nonatomic,strong) NSMutableArray *contentArrOneSection;

@property (nonatomic,strong) NSMutableArray *titleArrTwoSection;
@property (nonatomic,strong) NSMutableArray *contentArrTwoSection;

@end

@implementation PackingPayHistoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@",[ShareUserInfo sharedUserInfo].commuityInfo.name,@"缴费记录"];
    self.title = titleStr;
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
- (void)initView{
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor clearColor];
}
- (void)initData{
    [self oneSectionData];
    [self twoSectionData];
    [self.tableView reloadData];

}
- (void)oneSectionData{
    
    NSString *mainStr = @"";
    NSString *payCarOrSpotStr = @"";
    if (self.historyModel.groundUpAndDown == 1) {   // 0地上1地下   地上展示车位号 地下展示车牌号
        mainStr = [TextShowWithModelStr textShowWithModelStr: self.historyModel.carPositionNumber ];//车牌号
        payCarOrSpotStr = @"月租车辆";
    }else{
        mainStr = [TextShowWithModelStr textShowWithModelStr: self.historyModel.carNumber];//车位号
        payCarOrSpotStr = @"月租车位";
    }
    NSString *siteClassificationNameStr = [TextShowWithModelStr textShowWithModelStr:self.historyModel.siteClassificationName];//场地分类名称
    NSString *shopTimeStr = [TextShowWithModelStr textShowWithModelStr:self.historyModel.stopTime];//场地分类名称
    
    self.contentArrOneSection = [[NSMutableArray alloc]initWithObjects:@"缴费主体",@"缴费项目", @"场地名称", @"到期时间",  nil];
    self.contentArrOneSection = [[NSMutableArray alloc]initWithObjects:mainStr,payCarOrSpotStr, siteClassificationNameStr, shopTimeStr,  nil];

}
- (void)twoSectionData{

    NSString *payTypeStr = @""; //支付方式 1微信 2支付宝 3现金
    switch (self.historyModel.payType) {
        case 1:
            payTypeStr = @"微信";
            break;
        case 2:
            payTypeStr = @"支付宝";
            break;
        case 3:
            payTypeStr = @"现金";
            break;
        default:
            payTypeStr = @"其他";
            break;
    }
    NSString *payMoneyStr = [NSString stringWithFormat:@"¥%0.2f",self.historyModel.payMoney];
    NSString *payTimeStr = [TextShowWithModelStr textShowWithModelStr:self.historyModel.payTime];
    NSString *systemNumberStr = [TextShowWithModelStr textShowWithModelStr:self.historyModel.systemNumber];//系统订单编号
    self.contentArrTwoSection = [[NSMutableArray alloc]initWithObjects:@"支付方式",@"支付金额", @"支付时间", @"订单编号", nil];
    self.contentArrTwoSection = [[NSMutableArray alloc]initWithObjects:payTypeStr,payMoneyStr, payTimeStr, systemNumberStr, nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  self.titleArrOneSection.count;
    }else{
        return  self.titleArrTwoSection.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Namal"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Namal"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        cell.indentationLevel =  1;  //缩进层级
        cell.indentationWidth = 16;//每次缩进寛
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        //右边内缩 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 换成view
        UIImage *zeroImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW] width:10 height:10];
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:zeroImg];
        cell.accessoryView = accessoryImgView;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titleArrOneSection[indexPath.row];
        cell.detailTextLabel.text = self.contentArrOneSection[indexPath.row];
    }else{
        cell.textLabel.text = self.titleArrTwoSection[indexPath.row];
        cell.detailTextLabel.text = self.contentArrTwoSection[indexPath.row];
    }
    return cell;
}
 
#pragma mark ===

- (NSMutableArray *)titleArrOneSection{
    if (!_titleArrOneSection) {
        _titleArrOneSection = [[NSMutableArray alloc]initWithObjects:@"缴费主体",@"缴费项目", @"场地名称", @"到期时间",  nil];
    }
    return _titleArrOneSection;
}

- (NSMutableArray *)contentArrOneSection{
    if (!_contentArrOneSection) {
        _contentArrOneSection = [[NSMutableArray alloc]initWithObjects:@"",@"", @"", @"", @"",  nil];
    }
    return _contentArrOneSection;
}

- (NSMutableArray *)titleArrTwoSection{
    if (!_titleArrTwoSection) {
        _titleArrTwoSection = [[NSMutableArray alloc]initWithObjects:@"支付方式",@"支付金额", @"支付时间", @"订单编号", nil];
    }
    return _titleArrTwoSection;
}

- (NSMutableArray *)contentArrTwoSection{
    if (!_contentArrTwoSection) {
        _contentArrTwoSection = [[NSMutableArray alloc]initWithObjects:@"",@"", @"", @"",  nil];
    }
    return _contentArrTwoSection;
}


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    UIColor *separatoColor =  [ThemeManager shareManager].themeLineColor;
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
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-0.5, bounds.size.width-10*2, 0.5);//h_0.5
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
