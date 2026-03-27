//
//  LifeCostContWillPayWithShowInfoVC.m
//  Community
//
//  Created by 余莹 on 2022/1/8.
//

#import "LifeCostContWillPayWithShowInfoVC.h"

#import "LifeCostContWillPayMainTitleImgTableViewCell.h"
#define  LifeCostContWillPayMainTitleImgTableViewCell_Identifier          @"LifeCostContWillPayMainTitleImgTableViewCell"

@interface LifeCostContWillPayWithShowInfoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation LifeCostContWillPayWithShowInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
    self.view.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
}
- (void)initData{
    [self.tableView reloadData];
}
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(0, 16, 90, 16));
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.bottom.left.right.equalTo(_footerView.superview);
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        
        LifeCostContWillPayMainTitleImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostContWillPayMainTitleImgTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostContWillPayMainTitleImgTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostContWillPayMainTitleImgTableViewCell_Identifier];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderSubTextCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderSubTextCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
            cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        }
        if (indexPath.row==1) {
            cell.textLabel.text =  @"缴费账号";
            cell.detailTextLabel.text = (self.accountStr.length <= 0) ? @"暂无详情" : self.accountStr;
        }else{
            cell.textLabel.text =  @"缴费单位";
            cell.detailTextLabel.text = (self.commpanyStr.length <= 0) ? @"暂无详情" : self.commpanyStr;
        }
        return cell;
    }
   
}
 
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *cellBackGroundFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.0f;//圆角
        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 1.0, 0);//外距离
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
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-20, 0);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];//分割线
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
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, 150, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"完成"];
        [_footerView.footerBtn setFrame:CGRectMake(0, 0, 150, 40)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:18 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)footerBtnAction{
    [self popVC];
}
@end
